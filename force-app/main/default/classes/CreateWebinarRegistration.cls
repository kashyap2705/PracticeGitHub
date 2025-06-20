/**
 * @description Global class to handle webinar registration creation for Webinar.net
 *              through AE form submissions
 */
global class CreateWebinarRegistration {
    
    /**
     * @description Creates Webinar.net registrations from a list of registration requests
     * @param regValues List of registration request objects containing registrant details
     */
    @InvocableMethod(label='Get Registration Records' description='Creates Webinar.net registration after AE form submission.')
    global static void createWebinarReg(List<CreateWebinarRegistrationsRequest> regValues) {
        
        List<CreateWebinarRegistrationsResult> results = new List<CreateWebinarRegistrationsResult>();
        
        for (CreateWebinarRegistrationsRequest webinarString : regValues) {
            results.add(createWebReg(webinarString));
        }
    }
    
    /**
     * @description Creates a single webinar registration and handles the HTTP callout
     * @param request Registration request object containing registrant details
     * @return CreateWebinarRegistrationsResult Result object with success status and callout details
     */
    public static CreateWebinarRegistrationsResult createWebReg(CreateWebinarRegistrationsRequest request) {
        
        CreateWebinarRegistrationsResult result = new CreateWebinarRegistrationsResult();
        
        string fName = request.firstname;
        string lName = request.lastname;
        string email = request.email;
        string company = request.company;
        string webinarID = request.webinarID;
        string jobTitle = request.jobTitle;
        string favoriteColor = request.favoriteColor;
        string watchedMovies = request.watchedMovies;
        string mcc = request.mcc;
        
        Http http = new Http();
        HttpRequest hRequest = new HttpRequest();
        hRequest.setEndpoint('callout:Account_Engagement_Webinar/' + webinarID + '/registrants');
        hRequest.setMethod('POST');
        hRequest.setHeader('Content-Type', 'application/json');
     
        DataWrapper data = new DataWrapper();
        
        data.fields.add(new FieldWrapper('firstName', fName));
        data.fields.add(new FieldWrapper('lastName', lName));
        data.fields.add(new FieldWrapper('emailAddress', email));
        data.fields.add(new FieldWrapper('company', company));
        data.fields.add(new FieldWrapper('jobTitle', jobTitle));
        data.fields.add(new FieldWrapper('favoriteColor', favoriteColor));
        data.fields.add(new FieldWrapper('watchedMovies', watchedMovies));
        
        data.mcc = mcc;
        
        String jsonString = JSON.serialize(data);
        
        hRequest.setBody(jsonString);
        
        try {
            HttpResponse response = http.send(hRequest);
            
            if (response.getStatusCode() >= 200 && response.getStatusCode() <= 299) {
                result.calloutResult = 'Success';
                result.success = true;
                if (response.getBody().contains('error')){
                    result.calloutResult = 'Error' + response.getBody();
                    result.success = false;
                }
            } else {
                String errorDetails = 'HTTP Request Failed: ' + 
                    '\nClass Name: createWebinarRegistration' +
                    '\nMethod Name: createWebReg' +
                    '\nStatus Code: ' + response.getStatusCode() + 
                    '\nStatus: ' + response.getStatus() +
                    '\nBody: ' + response.getBody();
                
                logger.get().add(errorDetails, LogSeverity.ERROR).publish();
                result.calloutResult = 'Error: Status Code ' + response.getStatusCode() + ' - ' + response.getBody();
            }
        } catch (System.CalloutException e) {
            logger.get().add(e, LogSeverity.ERROR).publish();
            result.calloutResult = 'Error: Callout Exception - ' + e.getMessage();
        }
        
        return result;
    }
    
    /**
     * @description Wrapper class for structuring registration data in JSON payload
     */
    public class DataWrapper {
        /**
         * @description List of FieldWrapper objects containing key-value pairs for the callout request.
         */
        public List<FieldWrapper> fields { get; set; }
        /**
         * @description The MCC value for the callout request.
         */
        public String mcc { get; set; }
        
        /**
         * @description Constructor to initialize the fields list.
         */
        public DataWrapper() {
            fields = new List<FieldWrapper>();
        }
    }
    
    /**
     * @description Wrapper class for individual field key-value pairs in registration data
     */
    public class FieldWrapper {
        /**
         * @description The key of the field.
         */
        public String key { get; set; }
        /**
         * @description The value of the field.
         */
        public String value { get; set; }
        
        /**
         * @description Constructor to initialize the key and value.
         * @param key The key of the field.
         * @param value The value of the field.
         */
        public FieldWrapper(String key, String value) {
            this.key = key;
            this.value = value;
        }
    }
    
    /**
     * @description Result class for webinar registration operations
     */
    global class CreateWebinarRegistrationsResult {
        /**
         * @description The result message of the callout, indicating success or the error message.
         */
        @InvocableVariable
        global string calloutResult;
        /**
         * @description Indicates if the callout was successful.
         */
        @InvocableVariable
        global Boolean success;
        
        /**
         * @description Constructor, sets success to false by default.
         */
        public CreateWebinarRegistrationsResult(){
            success = false;
        }
    }
    
    /**
     * @description Request class containing registrant details for webinar registration
     */
    global class CreateWebinarRegistrationsRequest {
        @InvocableVariable(required=true) global string firstname;
        @InvocableVariable(required=true) global string lastname;    
        @InvocableVariable(required=true) global string email;    
        @InvocableVariable(required=true) global string company;       
        @InvocableVariable(required=true) global string webinarID;  
        @InvocableVariable(required=false) global string jobTitle;
        @InvocableVariable(required=false) global string favoriteColor;
        @InvocableVariable(required=false) global string watchedMovies;
        @InvocableVariable(required=false) global string mcc;
    }  
}