/**
 * @description       : class for CSM_ContactUsController
 * @author            : Yatin Bajaj
 * @last modified on  : 03-25-2024
 * @last modified by  : Yatin Bajaj
 **/
public with sharing class CSM_ContactUsController {
  public static Boolean isTest = false;

  /**
   * @Method Name    : getContactUsDetails
   * @description    : Method to get contact us details
   * @return         : List<IB_Answers_Contact_Us_Details__mdt>
   **/
  @AuraEnabled
  public static List<IB_Answers_Contact_Us_Details__mdt> getContactUsDetails() {
    try {
      List<IB_Answers_Contact_Us_Details__mdt> contactUsDetails = [
        SELECT
          Country_Code__c,
          Id,
          Country_Label__c,
          Country_Label_French__c,
          Country_Label_Spanish__c,
          Contact_Number__c,
          Order_By_Country__c
        FROM IB_Answers_Contact_Us_Details__mdt
        ORDER BY Order_By_Country__c
      ];
      Map<String, IB_Answers_Contact_Us_Details__mdt> mapContactUsDetails = IB_Answers_Contact_Us_Details__mdt.getAll();
      if (isTest) {
        throw new ListException('Something went wrong');
      }
      return contactUsDetails;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /**
   * @Method Name    : getHelpInfo
   * @description    : Method to get Help Info
   * @return         : IB_Answers_Contact_Us_Help_Info__mdt record
   **/
  @AuraEnabled
  public static IB_Answers_Contact_Us_Help_Info__mdt getHelpInfo() {
    try {
      IB_Answers_Contact_Us_Help_Info__mdt contactUsInfo = [
        SELECT Id, Help_Info__c, Help_Info_fr__c, Help_Info_es__c
        FROM IB_Answers_Contact_Us_Help_Info__mdt
        LIMIT 1
      ];
      if (isTest) {
        throw new ListException('Something went wrong');
      }
      return contactUsInfo;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }
}