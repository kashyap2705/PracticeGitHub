/**
 * @description       : class for CSM_NotificationController
 * @author            : Yatin Bajaj
 * @modified by       : Yatin Bajaj  | 03-25-2024
 * @modified by       : Charan Kumar | 05-10-2024
 **/
public with sharing class CSM_NotificationController {
  public static Boolean isException = false;

  /**
   * @Method Name    : getHighPriorityServiceAlert
   * @description    : Method to get service alerts of type 'High Priority'
   * @param          : Boolean isGuest, String userLanguage
   * @return         : Service_Alert__c
   **/

  @AuraEnabled
  public static Service_Alert__c getHighPriorityServiceAlert(
    Boolean isGuest,
    String userLanguage
  ) {
    string PRIORITY = 'High Priority';
    Datetime today = Datetime.now();
    try {
      List<Service_Alert__c> highAlert;
      if (isGuest) {
        highAlert = [
          SELECT
            Id,
            Title__c,
            Alert_Level__c,
            Body__c,
            Start_Date__c,
            End_Date__c,
            LastModifiedDate,
            Alert_Type__c
          FROM Service_Alert__c
          WHERE
            Alert_Level__c = :PRIORITY
            AND Start_Date__c <= :today
            AND End_Date__c > :today
            AND Accessible_External_Unauthenticated__c = TRUE
            AND Language__c = :userLanguage
          ORDER BY Start_Date__c DESC, LastModifiedDate DESC
        ];
      } else {
        highAlert = [
          SELECT
            Id,
            Title__c,
            Alert_Level__c,
            Body__c,
            Start_Date__c,
            End_Date__c,
            LastModifiedDate,
            Alert_Type__c
          FROM Service_Alert__c
          WHERE
            Alert_Level__c = :PRIORITY
            AND Start_Date__c <= :today
            AND End_Date__c > :today
            AND Accessible_External_Authenticated__c = TRUE
            AND Language__c = :userLanguage
          ORDER BY Start_Date__c DESC, LastModifiedDate DESC
        ];
      }
      if (isException) {
        throw new ListException('Something went wrong');
      }
      if (highAlert.isEmpty()) {
        return null;
      }
      return highAlert[0];
    } catch (ListException exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new ListException(exp.getMessage());
    }
  }
}