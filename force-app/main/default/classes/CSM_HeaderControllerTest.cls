@IsTest
public class CSM_HeaderControllerTest {
  @IsTest
  static void testFetchNotification() {
    // Create a mock HTTP response
    HttpResponse mockResponse = new HttpResponse();
    mockResponse.setStatusCode(200);
    mockResponse.setHeader('Content-Type', 'application/json');
    mockResponse.setBody(
      '{"notifications": [{"additionalData": "SampleData", "count": 1}]}'
    );

    // Create a mock HTTP callout
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(mockResponse)
    );

    // Call the method
    Test.startTest();
    CSM_HeaderController.NotificationWrapper result = CSM_HeaderController.fetchNotification();
    Test.stopTest();

    // Verify the result
    System.assertNotEquals(null, result);
    System.assertEquals(1, result.notifications.size());
    System.assertEquals('SampleData', result.notifications[0].additionalData);
    System.assertEquals(1, result.notifications[0].count);
  }

  @IsTest
  static void testUpdateNotification1() {
    // Create a mock HTTP response
    HttpResponse mockResponse = new HttpResponse();
    mockResponse.setStatusCode(200);
    mockResponse.setHeader('Content-Type', 'application/json');
    mockResponse.setBody('{"success": true}');

    // Create a mock HTTP callout
    Test.setMock(
      HttpCalloutMock.class,
      new MockHttpResponseGenerator(mockResponse)
    );

    // Call the method
    Test.startTest();
    String result = CSM_HeaderController.updateNotification('notificationId');
    Test.stopTest();

    // Verify the result
    System.assertEquals('{"success": true}', result);
  }

  // MockHttpResponseGenerator inner class to mock HTTP callouts
  private class MockHttpResponseGenerator implements HttpCalloutMock {
    HttpResponse response;
    public MockHttpResponseGenerator(HttpResponse response) {
      this.response = response;
    }

    public HttpResponse respond(HttpRequest request) {
      return this.response;
    }
  }
}