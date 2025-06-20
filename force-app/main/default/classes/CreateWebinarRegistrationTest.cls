/**
 * @description Test class for CreateWebinarRegistration functionality
 */
@isTest
public class CreateWebinarRegistrationTest {
    
    /**
     * @description Mock HTTP response generator for testing webinar registration callouts
     */
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private Integer statusCode;
        private String responseBody;
        
        /**
         * @description Constructor for MockHttpResponseGenerator
         * @param statusCode HTTP status code to return
         * @param responseBody Response body to return
         */
        public MockHttpResponseGenerator(Integer statusCode, String responseBody) {
            this.statusCode = statusCode;
            this.responseBody = responseBody;
        }
        
        /**
         * @description Generates mock HTTP response for test callouts
         * @param request The HTTP request being mocked
         * @return HttpResponse Mocked HTTP response
         */
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(statusCode);
            response.setBody(responseBody);
            response.setStatus('Completed');
            return response;
        }
    }
    
    /**
     * @description Creates a dummy webinar registration request for testing
     * @return CreateWebinarRegistrationsRequest A populated request object with test data
     */
    private static createWebinarRegistration.CreateWebinarRegistrationsRequest createDummyRequest() {
        createWebinarRegistration.CreateWebinarRegistrationsRequest request = new createWebinarRegistration.CreateWebinarRegistrationsRequest();
        request.firstname = 'User'; 
        request.lastname = 'user'; 
        request.email = 'User.user@example.com'; 
        request.company = 'Abc Corporation'; 
        request.webinarID = 'WB-202345';  
        request.jobTitle = 'Developer'; 
        request.favoriteColor = 'Black';
        request.watchedMovies = 'Matrix, Inception, Interstellar'; 
        request.mcc = '123'; 
        
        return request;
    }
    
    /**
     * @description Tests successful webinar registration scenario
     */
    @isTest
    static void testSuccessfulWebinarRegistration() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"success":true}'));
        
        List<createWebinarRegistration.CreateWebinarRegistrationsRequest> requests = new List<createWebinarRegistration.CreateWebinarRegistrationsRequest>{
            createDummyRequest()
        };
                    
        Test.startTest();
        // Capture the results to assert against
        List<createWebinarRegistration.CreateWebinarRegistrationsResult> results = new List<createWebinarRegistration.CreateWebinarRegistrationsResult>();
        for (createWebinarRegistration.CreateWebinarRegistrationsRequest req : requests) {
            results.add(createWebinarRegistration.createWebReg(req));
        }
        Test.stopTest();
        
        // Assertions for successful case
        System.assertEquals(1, results.size(), 'Should have one result');
        System.assertEquals(true, results[0].success, 'Registration should be successful');
        System.assertEquals('Success', results[0].calloutResult, 'Callout result should indicate success');
    }
    
    /**
     * @description Tests failed webinar registration scenario
     */
    @isTest
    static void testFailedWebinarRegistration() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(400, '{"error":"Bad Request"}'));
        
        List<createWebinarRegistration.CreateWebinarRegistrationsRequest> requests = new List<createWebinarRegistration.CreateWebinarRegistrationsRequest>{
            createDummyRequest()
        };
                    
        Test.startTest();
        // Capture the results to assert against
        List<createWebinarRegistration.CreateWebinarRegistrationsResult> results = new List<createWebinarRegistration.CreateWebinarRegistrationsResult>();
        for (createWebinarRegistration.CreateWebinarRegistrationsRequest req : requests) {
            results.add(createWebinarRegistration.createWebReg(req));
        }
        Test.stopTest();
        
        // Assertions for failed case
        System.assertEquals(1, results.size(), 'Should have one result');
        System.assertEquals(false, results[0].success, 'Registration should not be successful');
        System.assert(results[0].calloutResult.contains('Error'), 'Callout result should contain Error');
        System.assertNotEquals('Success', results[0].calloutResult, 'Callout result should not indicate success');
    }
}