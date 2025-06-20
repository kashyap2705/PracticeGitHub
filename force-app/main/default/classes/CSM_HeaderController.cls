/*
*********************************************************
Apex Class Name    : CSM_HeaderController
@description       : This is class is control the notifications in "ibAnswersHeader" LWC Component.
@author            : Sagar Sirsat
Modification Log:
Ver   Date           Author                     Modification

*********************************************************
*/
public without sharing class CSM_HeaderController {
  public class Notification {
    @AuraEnabled
    public String additionalData;
    @AuraEnabled
    public String communityId;
    @AuraEnabled
    public String communityName;
    @AuraEnabled
    public Integer count;
    @AuraEnabled
    public String id;
    @AuraEnabled
    public String image;
    @AuraEnabled
    public DateTime lastModified;
    @AuraEnabled
    public String messageBody;
    @AuraEnabled
    public String messageTitle;
    @AuraEnabled
    public DateTime mostRecentActivityDate;
    @AuraEnabled
    public String organizationId;
    @AuraEnabled
    public Boolean read;
    @AuraEnabled
    public String recipientId;
    @AuraEnabled
    public Boolean seen;
    @AuraEnabled
    public String target;
    @AuraEnabled
    public String targetPageRef;
    @AuraEnabled
    public String type;
    @AuraEnabled
    public String url;
  }

  public class NotificationWrapper {
    @AuraEnabled
    public List<Notification> notifications;
  }
  /*
*********************************************************
@Method Name    : fetchNotification
@description    : method is used to fetch the custom Notifications 
@param          : void
@return         : NotificationWrapper
********************************************************
*/
  @AuraEnabled(cacheable=false)
  public static NotificationWrapper fetchNotification() {
    String sfdcURL = URL.getOrgDomainUrl().toExternalForm();
    String restAPIURL = sfdcURL + '/services/data/v51.0/connect/notifications';

    HttpRequest httpRequest = new HttpRequest();
    httpRequest.setMethod('GET');
    httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
    httpRequest.setEndpoint(restAPIURL);

    NotificationWrapper wrapper = new NotificationWrapper();

    try {
      Http http = new Http();
      HttpResponse httpResponse = http.send(httpRequest);

      if (httpResponse.getStatusCode() == 200) {
        String jsonString = httpResponse.getBody();
        system.debug('jsonString' + jsonString);
        // Deserialize the JSON response directly into NotificationWrapper
        wrapper = (NotificationWrapper) JSON.deserialize(
          jsonString,
          NotificationWrapper.class
        );
        system.debug('httpResponse.getBody()' + wrapper);
      }
    } catch (ListException exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new ListException(exp.getMessage());
    }

    return wrapper;
  }

  /*
*********************************************************
@Method Name    : updateNotification
@description    : method is used to update the custom Notifications to read
@param          : String
@return         : String
********************************************************
*/
  @AuraEnabled
  public static String updateNotification(String notificationId) {
    String notiId = notificationId; //ID of the notification

    String sfdcURL = URL.getOrgDomainUrl().toExternalForm();

    String restAPIURL =
      sfdcURL +
      '/services/data/v51.0/connect/notifications/' +
      notificationId;

    HttpRequest httpRequest = new HttpRequest();

    httpRequest.setMethod('PATCH');
    httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
    httpRequest.setEndpoint(restAPIURL);
    httpRequest.setHeader('Content-Type', 'application/json');

    String bd = '{"read":true}';
    httpRequest.setBody(bd);
    try {
      Http http = new Http();

      HttpResponse httpResponse = http.send(httpRequest);
      return String.valueOf(httpResponse.getBody());
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  class BodyWrapper {
    Boolean read;
    
  }
 
}