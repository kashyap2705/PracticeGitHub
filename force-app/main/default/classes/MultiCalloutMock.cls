/**
 * @description A mock class that supports multiple HTTP callouts in a single test by mapping endpoints to their respective mocks.
 */
@isTest
global class MultiCalloutMock implements HttpCalloutMock {
    private Map<String, HttpCalloutMock> endpointToMock;

    /**
     * @description Constructor that accepts a map of endpoints to their corresponding mocks.
     * @param endpointToMock A map where the key is a partial endpoint string and the value is the mock to use for that endpoint.
     */
    public MultiCalloutMock(Map<String, HttpCalloutMock> endpointToMock) {
        this.endpointToMock = endpointToMock;
    }

    /**
     * @description Responds to an HTTP request by selecting the appropriate mock based on the endpoint.
     * @param req The HTTP request.
     * @return The mocked HTTP response.
     * @throws CalloutException If no mock is found for the endpoint.
     */
    global HttpResponse respond(HttpRequest req) {
        String endpoint = req.getEndpoint();
        for (String key : endpointToMock.keySet()) {
            if (endpoint.contains(key)) {
                return endpointToMock.get(key).respond(req);
            }
        }
        throw new CalloutException('No mock found for endpoint: ' + endpoint);
    }
}