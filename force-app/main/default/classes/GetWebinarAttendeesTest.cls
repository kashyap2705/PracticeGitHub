/**
 * @description Test class for GetWebinarAttendees. This class tests the functionality of the GetWebinarAttendees class,
 *              including successful and failed HTTP callout scenarios.
 */
@isTest
global class GetWebinarAttendeesTest {
    
    /**
     * @description Mock Webinar ID used for testing.
     */
    private static String mockWebinarId = '67bf09a2bf3934636144b18p';
    
    /**
     * @description Sets up test data for the test methods.
     *              Creates a dummy Account, Campaign, and OAuth_Settings__c record for testing purposes.
     */
    @TestSetup
    public static void createDummyData() {
        // Create Account
        Account acc1 = new Account();
        acc1.Region__c = 'IBA';
        Account acc = AccountTestDataFactory.createAccount('School Account', acc1);
        insert acc;
        
        // Create Campaign
        Campaign camp1 = new Campaign();
        camp1.Type = 'Evaluation';
        camp1.Sub_Type__c = 'Evaluation Visit';
        camp1.StartDate = Date.newInstance(2023, 07, 12);
        camp1.EndDate = Date.newInstance(2024, 07, 11);
        camp1.Status = 'Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c = 'IB only';
        camp1.Name = 'Evaluation Visit';
        camp1.Webinar_Net_ID__c = mockWebinarId;
        camp1.Venue_Account__c = acc.Id;
        camp1.Event_Organizer_Account__c = acc.Id;
        camp1.Webinar_Net_Tracking__c = true;
        
        Campaign testCamp = CampaignTestDataFactory.createCampaign('Evaluation', camp1);
        insert testCamp;

        // Create OAuth_Settings__c for token retrieval
        OAuth_Settings__c oauthSettings = new OAuth_Settings__c(
            Grant_Type__c = 'password',
            Client_Id__c = 'test_client_id',
            Client_Secret__c = 'test_client_secret',
            Username__c = 'test_user',
            Password__c = 'test_password',
            Endpoint__c = 'https://test.oauth.endpoint/token'
        );
        insert oauthSettings;
    }
    
    /**
     * @description Mock implementation of HttpCalloutMock for a failed response.
     *              Returns a 401 status code with a success message.
     */
    private class MockResponseFailure implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"message": "Success"}');
            res.setStatusCode(401);
            return res;
        }
    }
    
    /**
     * @description Mock implementation of HttpCalloutMock for a successful response.
     *              Returns a 200 status code with dummy attendee data.
     */
    private class MockResponseSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "12345",'+
                        '"firstName": "John",'+
                        '"lastName": "Doe",'+
                        '"emailAddress": "john.doe@example.com",'+
                        '"Company": "Tech Corp",'+
                        '"Title": "Software Engineer",'+
                        '"hasMore": "true",'+
                        '"pageIndex": "1",'+
                        '"pageSize": "10"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    /**
     * @description Test method for the failure scenario of addWebinarAttendeeRecords.
     *              Mocks a failed HTTP callout and verifies the response.
     */
    @isTest
    public static void addWebinarAttendeeRecordsFailure() {
        Test.setMock(HttpCalloutMock.class, new MockResponseFailure());
        List<String> response = GetWebinarAttendees.getWebinar(new List<String>{mockWebinarId});
        System.assertEquals('Error Occurred', response[0]);
    }
    
    /**
     * @description Test method for the success scenario of addWebinarAttendeeRecords.
     *              Mocks a successful HTTP callout and verifies the response.
     */
    @isTest
    public static void addWebinarAttendeeRecordsSuccess() {
        // Set up mocks for both callouts
        Map<String, HttpCalloutMock> endpointMocks = new Map<String, HttpCalloutMock>{
            'callout:Account_Engagement_Webinar' => new MockResponseSuccess(),
            'https://test.oauth.endpoint/token' => new MockTokenResponse()
        };
        Test.setMock(HttpCalloutMock.class, new MultiCalloutMock(endpointMocks));

        List<String> response = GetWebinarAttendees.getWebinar(new List<String>{mockWebinarId});
        System.assertEquals(1, response.size());
    }
    
    /**
     * @description Test method for getWebinarAttendees Scheduler and Batch class.           
     */
    @isTest
    public static void getWebinarScheduler() {
        // Set up mocks for both callouts
        Map<String, HttpCalloutMock> endpointMocks = new Map<String, HttpCalloutMock>{
            'callout:Account_Engagement_Webinar' => new MockResponseSuccess(),
            'https://test.oauth.endpoint/token' => new MockTokenResponse()
        };
        Test.setMock(HttpCalloutMock.class, new MultiCalloutMock(endpointMocks));

        Test.startTest();
        GetWebinarAttendeesScheduler scheduler = new GetWebinarAttendeesScheduler();
        scheduler.execute(null);
        Test.stopTest();
    }
}