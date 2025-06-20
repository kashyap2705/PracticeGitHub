global class BitlyServiceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('http://sforce.co/2cCk3Uz');
        res.setStatusCode(200);
        return res;
    }
}