/**
 * @description       : class for CSM_NewsAndUpdateController
 * @author            : Yatin Bajaj
 * @modified by       : Yatin Bajaj  | 03-25-2024
 * @modified by       : Charan Kumar | 05-10-2024
 **/
public with sharing class CSM_NewsAndUpdateController {
  public static Boolean isTest = false;

  /**
   * @Method Name    : getServiceAlerts
   * @description    : Method to get service alerts of any type
   * @param          : Boolean isGuest, String userLanguage
   * @return         : List<Service_Alert__c>
   **/

  @AuraEnabled
  public static List<Service_Alert__c> getServiceAlerts(
    Boolean isGuest,
    String userLanguage
  ) {
    try {
      List<Service_Alert__c> serviceAlerts;
      Datetime today = Datetime.now();
      if (isGuest) {
        serviceAlerts = [
          SELECT
            Id,
            Title__c,
            Alert_Level__c,
            Alert_Type__c,
            Body__c,
            Start_Date__c,
            End_Date__c,
            LastModifiedDate,
            Language__c,
            Audience__c
          FROM Service_Alert__c
          WHERE
            End_Date__c >= :today
            AND Accessible_External_Unauthenticated__c = TRUE
            AND Language__c = :userLanguage
          ORDER BY Start_Date__c DESC
        ];
      } else {
        serviceAlerts = [
          SELECT
            Id,
            Title__c,
            Alert_Level__c,
            Alert_Type__c,
            Body__c,
            Start_Date__c,
            End_Date__c,
            LastModifiedDate,
            Language__c,
            Audience__c
          FROM Service_Alert__c
          WHERE
            End_Date__c >= :today
            AND Language__c = :userLanguage
            AND Accessible_External_Authenticated__c = TRUE
          ORDER BY Start_Date__c DESC
        ];
      }
      if (isTest) {
        throw new ListException('Something went wrong');
      }
      return serviceAlerts;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }
}