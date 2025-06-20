/**
 * @description A mock class that simulates a successful OAuth token retrieval response.
 */
@isTest
global class MockTokenResponse implements HttpCalloutMock {
    /**
     * @description Simulates a successful HTTP response for an OAuth token request.
     * @param req The HTTP request.
     * @return A mocked HTTP response with a 200 status code and an access token.
     */
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token": "mocked_access_token", "token_type": "Bearer", "expires_in": 3600}');
        res.setStatusCode(200);
        return res;
    }
}