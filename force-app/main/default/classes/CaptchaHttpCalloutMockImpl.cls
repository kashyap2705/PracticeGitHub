@isTest
global class CaptchaHttpCalloutMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
       
       System.assertEquals(IbenRegistrationWizardController.baseUrl, req.getEndpoint());
       System.assertEquals('POST', req.getMethod());
       
       HTTPResponse response = new HTTPResponse();
       response.setBody('true result');
       response.setStatusCode(200);
       return response; 
    }
}