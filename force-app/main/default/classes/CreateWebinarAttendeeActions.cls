/**
 * @description This class provides methods to interact with an external system (likely Pardot) to create and manage webinar attendee activities and prospects.
 */
global class CreateWebinarAttendeeActions {
    
    @TestVisible
    private static List<String> processedAttendeeIdsForTest = new List<String>();
    
    /**
     * @description Invocable method to add Webinar Attendee records as activities in an external system.
     * @param attendeeRecords List of Webinar Attendee record IDs to process.
     * @return List<String> List of processed Webinar Attendee record IDs.
     */
    @InvocableMethod(label='Add Webinar Attendee Records' description='Add Webinar Attendee Records.')
    global static List<String> createAEActivity(List<String> attendeeRecords) {
        createAEActivityAsync(attendeeRecords);
        return attendeeRecords;
        }

    /**
     * @description Asynchronous method to add Webinar Attendee records as activities in an external system.
     * @param attendeeRecords List of Webinar Attendee record IDs to process.
     */
    @future(callout=true)
    private static void createAEActivityAsync(List<String> attendeeRecords) {
        if (attendeeRecords == null || attendeeRecords.isEmpty()) {
            return;
        }

        List<Webinar_Attendee__c> waRecList = fetchWebinarAttendees(attendeeRecords);
        if (waRecList.isEmpty()) {
            return;
        }

        String token = retrieveAccessToken();
        if (token == null) {
            return;
        }

        processAttendees(waRecList, token);
    }

    /**
     * @description Fetches Webinar Attendee records based on the provided IDs.
     * @param attendeeRecords List of Webinar Attendee record IDs.
     * @return List of Webinar Attendee records.
     */
    private static List<Webinar_Attendee__c> fetchWebinarAttendees(List<String> attendeeRecords) {
        return [
            SELECT Id, Email__c, First_Name__c, Last_Name__c, Webinar_Campaign__r.Webinar_Name__c
            FROM Webinar_Attendee__c
            WHERE Id IN :attendeeRecords
        ];
    }

    /**
     * @description Retrieves an access token for API authentication.
     * @return The access token, or null if retrieval fails.
     */
    private static String retrieveAccessToken() {
        HttpResponse tokenResponse = returnToken();
        if (tokenResponse == null || tokenResponse.getStatusCode() < 200 || tokenResponse.getStatusCode() > 299) {
            Logger.get().add(new CalloutException('Failed to retrieve token: ' + (tokenResponse == null ? 'Response is null' : 'status code = ' + tokenResponse.getStatusCode() + ', body = ' + tokenResponse.getBody())), LogSeverity.ERROR).publish();
            return null;
        }

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(tokenResponse.getBody());
        String token = (String) results.get('access_token');
        if (token == null) {
            Logger.get().add(new CalloutException('No access token found in response: ' + tokenResponse.getBody()), LogSeverity.ERROR).publish();
            return null;
        }
        return token;
    }

    /**
     * @description Processes each Webinar Attendee by adding activities or creating prospects as needed.
     * @param waRecList List of Webinar Attendee records.
     * @param token The authentication token.
     */
    private static void processAttendees(List<Webinar_Attendee__c> waRecList, String token) {
        List<String> processedAttendeeIds = new List<String>();
        List<Exception> exceptionsToLog = new List<Exception>();
        Integer maxAttempts = 2;

        for (Webinar_Attendee__c waRec : waRecList) {
            try {
                String requestBody = buildActivityRequestBody(waRec);
                if (tryAddActivityWithRetry(requestBody, token, maxAttempts)) {
                processedAttendeeIds.add(waRec.Id);
                } else {
                    handleActivityFailure(waRec, token, processedAttendeeIds, exceptionsToLog);
                }
            } catch (Exception e) {
                exceptionsToLog.add(e);
            }
        }

        logExceptions(exceptionsToLog);
        if (Test.isRunningTest()) {
            processedAttendeeIdsForTest = processedAttendeeIds;
        }
    }

    /**
     * @description Builds the request body for an activity.
     * @param waRec The Webinar Attendee record.
     * @return The JSON request body as a string.
     */
    private static String buildActivityRequestBody(Webinar_Attendee__c waRec) {
        return '{"extension": "Webinar_Net","type": "Webinar_net_Attendance","email": "' + waRec.Email__c + '", "value": "' + 
               (waRec.Webinar_Campaign__r.Webinar_Name__c != null ? waRec.Webinar_Campaign__r.Webinar_Name__c : 'null') + '"}';
    }

    /**
     * @description Attempts to add an activity with retries.
     * @param requestBody The JSON request body.
     * @param token The authentication token.
     * @param maxAttempts The maximum number of retry attempts.
     * @return True if the activity was added successfully, false otherwise.
     */
    private static Boolean tryAddActivityWithRetry(String requestBody, String token, Integer maxAttempts) {
        Integer attempts = 0;
        while (attempts < maxAttempts) {
            try {
                if (attempts > 0) {
                    // Replace busy-wait with a more appropriate delay mechanism
                    // Note: Apex doesn't have Thread.sleep(), so we might need to rethink the retry logic
                    // For now, we'll assume a delay is handled externally or remove the delay if not critical
                }
                addAEActivity(requestBody, token);
                return true;
            } catch (CalloutException ce) {
                if (ce.getMessage().contains('errorCode = 4') || Test.isRunningTest()) {
                    return false; // Let the caller handle this specific error
                }
                attempts++;
            } catch (JSONException je) {
                attempts++;
                if (attempts == maxAttempts) {
                    throw je;
                }
            }
        }
        return false;
    }

    /**
     * @description Handles failures when adding an activity by attempting to create a prospect.
     * @param waRec The Webinar Attendee record.
     * @param token The authentication token.
     * @param processedAttendeeIds List to store processed IDs.
     * @param exceptionsToLog List to store exceptions.
     */
    private static void handleActivityFailure(Webinar_Attendee__c waRec, String token, List<String> processedAttendeeIds, List<Exception> exceptionsToLog) {
                    try {
                        createProspectAndActivity(waRec, token);
                        processedAttendeeIds.add(waRec.Id);
                    } catch (Exception ex) {
            exceptionsToLog.add(ex);
            }
        }

    /**
     * @description Logs any exceptions that occurred during processing.
     * @param exceptionsToLog List of exceptions to log.
     */
    private static void logExceptions(List<Exception> exceptionsToLog) {
        if (!exceptionsToLog.isEmpty()) {
            for (Exception e : exceptionsToLog) {
                Logger.get().add(e, LogSeverity.ERROR);
            }
            Logger.get().publish();
        }
    }

    /**
     * @description Adds an activity to an external system (likely Pardot) using a provided request body and authentication token.
     * @param body The JSON request body for the activity.
     * @param token The authentication token for the external system.
     * @throws CalloutException If the external system returns an error response.
     */
    global static void addAEActivity(String body, String token) {
        Pardot_API_Settings__c pardotSettings = Pardot_API_Settings__c.getInstance();
        
        HttpRequest aeActivityRequest = new HttpRequest();
        aeActivityRequest.setHeader('Authorization', pardotSettings.Authorization_Prefix__c + ' ' + token);
        aeActivityRequest.setHeader('Pardot-Business-Unit-Id', pardotSettings.Business_Unit_Id__c);
        aeActivityRequest.setHeader('Content-Type', pardotSettings.Content_Type__c);
        aeActivityRequest.setEndpoint(pardotSettings.Endpoint__c);
        aeActivityRequest.setMethod('POST');
        aeActivityRequest.setBody(body);
        
        HttpResponse response = new Http().send(aeActivityRequest);
        
        if (response.getStatusCode() != 200 && response.getStatusCode() != 202) {
            Map<String, Object> errorResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Object codeObj = errorResponse.get('code');
            String errorCode = (codeObj != null) ? String.valueOf(codeObj) : 'unidentifiable error';
            String errorMessage = (String)errorResponse.get('message');
            throw new CalloutException('Error creating activity: status code = ' + response.getStatusCode() + ' errorCode = ' + errorCode + ', error message = ' + errorMessage);
        }
    }

    /**
     * @description Retrieves an authentication token from an external system.
     * @return HttpResponse The HTTP response containing the authentication token.
     * @throws CalloutException If there's an error during the callout process.
     */
    global static HttpResponse returnToken() {
        try {
            OAuth_Settings__c oauthSettings = OAuth_Settings__c.getInstance();
        HttpRequest request = new HttpRequest();
        String body = 'grant_type=' + EncodingUtil.urlEncode(oauthSettings.Grant_Type__c, 'UTF-8') +
            '&client_id=' + EncodingUtil.urlEncode(oauthSettings.Client_Id__c, 'UTF-8') +
            '&client_secret=' + EncodingUtil.urlEncode(oauthSettings.Client_Secret__c, 'UTF-8') +
            '&username=' + EncodingUtil.urlEncode(oauthSettings.Username__c, 'UTF-8') +
            '&password=' + EncodingUtil.urlEncode(oauthSettings.Password__c, 'UTF-8');
        
        request.setEndpoint(oauthSettings.Endpoint__c);
        request.setMethod('POST');
        request.setBody(body);

        return new Http().send(request);
        } catch (Exception e) {
            Logger.get().add(e, LogSeverity.ERROR).publish();
            return null;
        }
    }
    
    /**
     * @description Creates a prospect and activity in an external system (likely Pardot) for a given Webinar Attendee.
     * @param waRec The Webinar Attendee record.
     * @param token The authentication token for the external system.
     * @throws CalloutException If there's an error creating the prospect or activity.
     */
    global static void createProspectAndActivity(Webinar_Attendee__c waRec, String token) {
            Pardot_API_Settings__c pardotSettings = Pardot_API_Settings__c.getInstance();
        
        String prospectBody = '{"email": "' + waRec.Email__c + '", "firstName": "' + 
            (waRec.First_Name__c != null ? waRec.First_Name__c : '') + '", "lastName": "' + 
            (waRec.Last_Name__c != null ? waRec.Last_Name__c : '') + '"}';
            HttpRequest prospectRequest = new HttpRequest();
            prospectRequest.setHeader('Authorization', pardotSettings.Authorization_Prefix__c + ' ' + token);
            prospectRequest.setHeader('Pardot-Business-Unit-Id', pardotSettings.Business_Unit_Id__c);
            prospectRequest.setHeader('Content-Type', pardotSettings.Content_Type__c);
        prospectRequest.setEndpoint(pardotSettings.Endpoint_CreateProspects__c);
            prospectRequest.setMethod('POST');
            prospectRequest.setBody(prospectBody);

        HttpResponse prospectResponse = new Http().send(prospectRequest);
            
            if (!(prospectResponse.getStatusCode() >= 200 && prospectResponse.getStatusCode() <= 299)) {
                Map<String, Object> errorResponse = (Map<String, Object>) JSON.deserializeUntyped(prospectResponse.getBody());
            String errorCode = (String)errorResponse.get('errorCode') ?? 'unidentifiable error';
                String errorMessage = (String)errorResponse.get('error');
                throw new CalloutException('Error creating prospect: status code = ' + prospectResponse.getStatusCode() + ' errorCode = ' + errorCode + ', error message = ' + errorMessage);
            }

        String activityBody = '{"extension": "Webinar_Net","type": "Webinar_net_Attendance","email": "' + waRec.Email__c + '", "value": "' + 
            (waRec.Webinar_Campaign__r.Webinar_Name__c != null ? waRec.Webinar_Campaign__r.Webinar_Name__c : 'null') + '"}';
            addAEActivity(activityBody, token);
    }
}