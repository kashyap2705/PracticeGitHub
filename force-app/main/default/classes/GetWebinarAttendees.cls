/**
 * @description This class handles retrieving and processing webinar attendee data from an external system.
 */
public class GetWebinarAttendees {

    /**
     * @description Retrieves webinar attendees for a given webinar ID and returns pagination information.
     * @param webinarIdList A list containing a single webinar ID (String).
     * @return A list of strings representing pagination details (e.g., hasMore, pageIndex, pageSize).
     * @throws Exception If an error occurs during the process, the exception is logged.
     */
    @InvocableMethod(label='Get Webinar Attendees' description='Returns the list of pagination strings')
    public static List<String> getWebinar(List<String> webinarIdList) {
		List<String> classResponseList = new List<String>();
        String classResponse;
        try {
            classResponse = addWebinarAttendeeRecords(webinarIdList[0]);
            classResponseList.add(classResponse);
        } catch(Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
        return classResponseList;
    }

    /**
     * @description Retrieves webinar attendees from an external system using a REST callout and upserts them into Salesforce.
     * @param webinarId The ID of the webinar to retrieve attendees for.
     * @return A list of strings representing pagination details from the external system.
     * @throws Exception If an error occurs during the process, the exception is logged.
     */
    public static String addWebinarAttendeeRecords(String webinarId) {

        String paginationString;
        Campaign campWebinar;

        try {
            campWebinar = [SELECT Id FROM Campaign WHERE Webinar_Net_ID__c = :webinarId LIMIT 1];
        } catch(Exception exp) {
            logger.get().add(exp, LogSeverity.ERROR).publish();
			paginationString = 'Error Occurred';
            return paginationString;
        }

        try {
            WebinarData data = new WebinarData(webinarId, campWebinar);
            paginationString = processWebinarAttendees(data);
        } catch (Exception exp){
			paginationString = 'Error Occurred';
            logger.get().add(exp, LogSeverity.ERROR).publish();
        }
        
        return paginationString;
    }

    /**
     * @description Processes the webinar attendee data from the external API response.
     * @param data An object of type WebinarData containing the needed parameters for the proccess.
     * @return A List of String contatining the pagination details.
     * @throws Exception If an error occurs during the process, the exception is logged.
     */
    private static String processWebinarAttendees(WebinarData data){
        String paginationString;

        String endPoint = 'callout:Account_Engagement_Webinar/' + data.webinarId + '/attendees';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);

            if(response.getStatusCode() != 200) {
                logger.get().add('HTTP Request Failed: ' + response.getStatus(), LogSeverity.ERROR).publish();
                paginationString = 'Error Occurred';
				return paginationString;
            }

            JSONParser parser = JSON.createParser(response.getBody());
            parser.nextToken();

            List<Webinar_Attendee__c> waList = new List<Webinar_Attendee__c>();

            // Parse the response and create Webinar Attendee records
            waList = parseAndCreateAttendees(parser, data);

            // Upsert the collected attendee records.
            if(!waList.isEmpty()) {
                try {
                    Database.upsert(waList, Webinar_Attendee__c.Attendee_ID__c, false);
                } catch(Exception exp) {
                    logger.get().add(exp, LogSeverity.ERROR).publish();
					paginationString = 'Error Occurred';					
                }
            }
        } catch(Exception exp) {
            logger.get().add(exp, LogSeverity.ERROR).publish();
			paginationString = 'Error Occurred';
        }

        return paginationString;
    }

    /**
     * @description Parses the JSON response and creates Webinar_Attendee__c records.
     * @param parser The JSON parser for the API response.
     * @param data An object of type WebinarData containing the needed parameters for the proccess.
     * @return A List of Webinar_Attendee__c records.
     * @throws Exception If an error occurs during the process, the exception is logged.
     */
    private static List<Webinar_Attendee__c> parseAndCreateAttendees(JSONParser parser, WebinarData data) {
        String fName;
        String lName;
        String email;
        String company;
        String title;
        String regId;

        List<Webinar_Attendee__c> waList = new List<Webinar_Attendee__c>();
        while(parser.nextToken() != null) {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String fieldName = parser.getText();
                parser.nextToken();
                switch on fieldName {
                    when 'id' { regId = parser.getText(); }
                    when 'firstName' { fName = parser.getText(); }
                    when 'lastName' { lName = parser.getText(); }
                    when 'emailAddress' { email = parser.getText(); }
                    when 'Company' { company = parser.getText(); }
                    when 'Title' { title = parser.getText(); }
                }
            }

            if(lName != null && fName != null && email != null && regId != null) {
                waList.add(new Webinar_Attendee__c(
                        Attendee_ID__c = data.webinarId + regId,
                        Company__c = company,
                        Email__c = email,
                        First_Name__c = fName,
                        Last_Name__c = lName,
                        Registrant_ID__c = regId,
                        Title__c = title,
                        Webinar_Campaign__c = data.campWebinar?.Id,
                        Webinar_ID__c = data.webinarId
                ));
                fName = lName = email = regId = company = title = null;
            }
        }
        return waList;
    }

    /**
    * @description This class is a data transfer object used to hold the webinar data
    */
    public class WebinarData {
        /**
        * @description The ID of the webinar.
        */
        public String webinarId {get;set;}
        /**
        * @description The Campaign record related to the webinar.
        */
        public Campaign campWebinar {get;set;}
        
        /**
        * @description Constructor for the WebinarData class.
        * @param webinarId The ID of the webinar.
        * @param campWebinar The Campaign record related to the webinar.
        */
        public WebinarData(String webinarId, Campaign campWebinar){
            this.webinarId = webinarId;
            this.campWebinar = campWebinar;
        }
    }
}