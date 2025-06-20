@isTest
public class IBConciergeDataIntegrationTest {

    @isTest
    static void testDoPost_Success() {
        // Create a valid JSON payload
        String validJson = '{"eventAt":"2025-05-20T17:36:31Z","eventId":"93b519fe-de5f-4a2e-8e42-a47d49dbc5f5","eventName":"preliminary_review.approved","processReference":"060787/EVAL/2025/PYP","programmeCodes":["PYP"],"schoolCode":"060787","triggerEventNames":[{"IBConciergeDate":"2025-05-20T17:36:31Z","triggerName":"IBWSM approval date for PR report"}]}';

        // Simulate a REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/dataexchange/v1/ibConciergeData';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(validJson);
        RestContext.request = req;
        RestContext.response = res;

        // Call the method
        IBConciergeDataIntegration.IBConciegeResponse response = IBConciergeDataIntegration.doPost();

    }

    @isTest
    static void testDoPost_EmptyPayload() {
        // Send empty JSON
        String emptyJson = '';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/dataexchange/v1/ibConciergeData';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(emptyJson);
        RestContext.request = req;
        RestContext.response = res;

        IBConciergeDataIntegration.IBConciegeResponse response = IBConciergeDataIntegration.doPost();

    }

    @isTest
    static void testDoPost_MalformedJson() {
        // Provide malformed JSON to trigger exception
        String malformedJson = '{"eventId":"12345"';  // Missing closing }

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/dataexchange/v1/ibConciergeData';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(malformedJson);
        RestContext.request = req;
        RestContext.response = res;

        IBConciergeDataIntegration.IBConciegeResponse response = IBConciergeDataIntegration.doPost();

    }
}