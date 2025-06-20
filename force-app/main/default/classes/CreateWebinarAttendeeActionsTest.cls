/**
 * @description Test class for the CreateWebinarAttendeeActions class.
 */
@isTest
public class CreateWebinarAttendeeActionsTest {

    private static String mockWebinarId = '67bf09a2bf3934636144b18p';

    /**
     * @description Sets up test data including custom settings
     */
    @TestSetup
    public static void createDummyData() {
        Pardot_API_Settings__c pardotSettings = new Pardot_API_Settings__c();
        pardotSettings.Authorization_Prefix__c = 'Bearer';
        pardotSettings.Business_Unit_Id__c = '0Uv000000000001';
        pardotSettings.Content_Type__c = 'application/json';
        pardotSettings.Endpoint__c = 'https://pardot.example.com/api/activity/version/4/do/create';
        pardotSettings.Endpoint_CreateProspects__c = 'https://pardot.example.com/api/prospect/version/4/do/create';
        insert pardotSettings;

        OAuth_Settings__c oauthSettings = new OAuth_Settings__c();
        oauthSettings.Grant_Type__c = 'password';
        oauthSettings.Client_Id__c = 'test_client_id';
        oauthSettings.Client_Secret__c = 'test_client_secret';
        oauthSettings.Username__c = 'test_user@example.com';
        oauthSettings.Password__c = 'test_password';
        oauthSettings.Endpoint__c = 'https://login.example.com/services/oauth2/token';
        insert oauthSettings;

        Account acc1 = new Account();
        acc1.Region__c = 'IBA';
        Account acc = AccountTestDataFactory.createAccount('School Account', acc1);
        insert acc;

        Campaign camp1 = new Campaign(
            Type = 'Evaluation',
            Sub_Type__c = 'Evaluation Visit',
            StartDate = Date.newInstance(2023, 07, 12),
            EndDate = Date.newInstance(2024, 07, 11),
            Status = 'Staffing_Event_Status__c',
            Programme_Combination_Evaluation_Visits__c = 'IB only',
            Name = 'Evaluation Visit',
            Webinar_Name__c = 'Test Webinar',
            Webinar_Net_ID__c = mockWebinarId,
            Venue_Account__c = acc1.Id,
            Event_Organizer_Account__c = acc.Id
        );
        insert camp1;
    }

    /**
     * @description Mock implementation of HttpCalloutMock
     */
    private class MockHttpCallout implements HttpCalloutMock {
        private String scenario;
        private Boolean prospectCreated = false;
        private Integer activityCallCount = 0;

        public MockHttpCallout(String scenario) {
            this.scenario = scenario;
        }

        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');

            // Handle OAuth token request
            if (req.getEndpoint().contains('services/oauth2/token')) {
                if (scenario == 'tokenError') {
                    res.setStatusCode(400);
                    res.setBody('{"error": "invalid_grant"}');
                } else {
                    res.setStatusCode(200);
                    res.setBody('{"access_token": "mockToken"}');
                }
                return res;
            } 
            // Handle Pardot API requests
            else if (req.getEndpoint().contains('pardot.example.com/api/activity') || req.getEndpoint().contains('pardot.example.com/api/prospect')) {
                String body = req.getBody();
                if (body.contains('"type": "Webinar_net_Attendance"')) { // Activity creation
                    activityCallCount++;
                    if (scenario == 'addAEActivityError') {
                        res.setStatusCode(400);
                        res.setBody('{"code": "10", "message": "Some error"}');
                    } else if (scenario == 'addAEActivityJSONError') {
                        res.setStatusCode(400);
                        res.setBody('{malformed_json');
                    } else if (scenario == 'addAEActivityNoErrorCode') {
                        res.setStatusCode(400);
                        res.setBody('{"message": "No error code"}');
                    } else if ((scenario == 'prospectNotFound' || scenario == 'createProspectError' || scenario == 'createProspectJSONError' || scenario == 'createProspectNoErrorCode') && !prospectCreated) {
                        prospectCreated = true;
                        res.setStatusCode(400);
                        res.setBody('{"code": "4", "message": "Prospect not found"}');
                    } else {
                        res.setStatusCode(200);
                        res.setBody('{"success": true}');
                    }
                    return res;
                } else if (body.contains('"email"') && !body.contains('"type"')) { // Prospect creation
                    if (scenario == 'createProspectError') {
                        res.setStatusCode(400);
                        res.setBody('{"errorCode": "20", "error": "Prospect creation failed"}');
                    } else if (scenario == 'createProspectJSONError') {
                        res.setStatusCode(400);
                        res.setBody('{malformed_json');
                    } else if (scenario == 'createProspectNoErrorCode') {
                        res.setStatusCode(400);
                        res.setBody('{"error": "No error code"}');
                    } else if (scenario == 'genericError') {
                        res.setStatusCode(500);
                        res.setBody('{"error": "Server Error"}');
                    } else {
                        res.setStatusCode(200);
                        res.setBody('{"message": "success"}');
                    }
                    return res;
                }
            }
            res.setStatusCode(500);
            res.setBody('{"error": "Unrecognized endpoint"}');
            return res;
        }
    }

    @isTest
    static void testProspectFound() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Attendee_ID__c = 'ATT123',
            Email__c = 'john.doe@example.com',
            First_Name__c = 'John',
            Last_Name__c = 'Doe'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('prospectFound'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        // Since the method is async, we need to query the results or rely on the returned list
        System.assertEquals(1, processedIds.size(), 'Expected one attendee record to be processed');
        System.assertEquals(attendee.Id, processedIds[0], 'Processed ID should match test attendee');
        System.assertEquals(1, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected one attendee to be processed');
    }

    @isTest
    static void testProspectNotFound() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Attendee_ID__c = 'ATT456',
            Email__c = 'jane.doe@example.com',
            First_Name__c = 'Jane',
            Last_Name__c = 'Doe'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('prospectNotFound'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        // The async method should still return the original list, but processing should succeed
        System.assertEquals(1, processedIds.size(), 'Expected one attendee record to be processed after prospect creation');
        System.assertEquals(attendee.Id, processedIds[0], 'Processed ID should match test attendee');
        System.assertEquals(1, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected one attendee to be processed');
    }

    @isTest
    static void testEmptyInput() {
        Test.startTest();
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{});
        Test.stopTest();

        System.assertEquals(0, processedIds.size(), 'Expected no records processed for empty input');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no attendees to be processed');
    }

    @isTest
    static void testAddAEActivityError() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'error.attendee@example.com',
            First_Name__c = 'Error',
            Last_Name__c = 'Attendee'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('addAEActivityError'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to activity error after retries');
    }

    @isTest
    static void testAddAEActivityJSONError() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'json.error@example.com',
            First_Name__c = 'JSON',
            Last_Name__c = 'Error'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('addAEActivityJSONError'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to JSON error after retries');
    }

    @isTest
    static void testAddAEActivityNoErrorCode() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'noerrorcode@example.com',
            First_Name__c = 'NoError',
            Last_Name__c = 'Code'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('addAEActivityNoErrorCode'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to error after retries');
    }

    @isTest
    static void testTokenError() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'token.error@example.com',
            First_Name__c = 'Token',
            Last_Name__c = 'Error'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('tokenError'));
            CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
            Test.stopTest();

        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 
                            'Expected no attendees to be processed due to token error');
    }

    @isTest
    static void testCreateProspectError() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'prospect.error@example.com',
            First_Name__c = 'Prospect',
            Last_Name__c = 'Error'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('createProspectError'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(attendee.Id, processedIds[0], 'Processed ID should match test attendee');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to prospect creation error');
    }

    @isTest
    static void testCreateProspectJSONError() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'prospect.jsonerror@example.com',
            First_Name__c = 'ProspectJSON',
            Last_Name__c = 'Error'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('createProspectJSONError'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to JSON error');
    }

    @isTest
    static void testCreateProspectNoErrorCode() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        Webinar_Attendee__c attendee = new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'prospect.noerrorcode@example.com',
            First_Name__c = 'ProspectNoError',
            Last_Name__c = 'Code'
        );
        insert attendee;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('createProspectNoErrorCode'));
        List<String> processedIds = CreateWebinarAttendeeActions.createAEActivity(new List<String>{attendee.Id});
        Test.stopTest();

        System.assertEquals(1, processedIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to error');
    }

    @isTest
    static void testMultipleAttendeesWithErrors() {
        Campaign testCampaign = [SELECT Id, Webinar_Name__c FROM Campaign WHERE Webinar_Net_ID__c = :mockWebinarId LIMIT 1];
        List<Webinar_Attendee__c> attendees = new List<Webinar_Attendee__c>();
        attendees.add(new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'error1@example.com',
            First_Name__c = 'Error',
            Last_Name__c = 'One'
        ));
        attendees.add(new Webinar_Attendee__c(
            Webinar_Campaign__c = testCampaign.Id,
            Email__c = 'error2@example.com',
            First_Name__c = 'Error',
            Last_Name__c = 'Two'
        ));
        insert attendees;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpCallout('addAEActivityError'));
        List<String> attendeeIds = new List<String>{attendees[0].Id, attendees[1].Id};
        CreateWebinarAttendeeActions.createAEActivity(attendeeIds);
        Test.stopTest();

        System.assertEquals(2, attendeeIds.size(), 'Expected the input list to be returned immediately');
        System.assertEquals(0, CreateWebinarAttendeeActions.processedAttendeeIdsForTest.size(), 'Expected no records processed due to errors');
    }
}