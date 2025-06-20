public with sharing class CSM_CaseController {
  public static Boolean isException = false;
  private static String FILE_NAME = 'IB_Answers_';
  private static String SHARE_TYPE = 'I';
  private static String ORIGIN = 'Web';
  private static String STATUS = 'Open';
  private static Decimal ReCAPTHASCORE = 0.5;
  private static String SUCCESSMSG = 'Success';
  private static String FAILUREMSG = 'Failure';

  /*
  *********************************************************
  @Method Name    : createCaseNAU
  @description    : method is used to create Case NAU (Support Record Type)
  @param          : Map<String, Object>, Map<String, Object>
  @return         : void
  ********************************************************
*/
  @AuraEnabled
  public static void createCaseNAU(
    Map<String, Object> caseData,
    Map<String, Object> contactData
  ) {
    CSM_CaseControllerHelper.createCaseNAU(caseData, contactData);
  }

  /*
*********************************************************
@Method Name    : createCaseAU
@description    : method is used to create Case AU (Support Record Type)
@param          : Map<String, Object>, Map<String, Object>
@return         : void
********************************************************
*/
  @AuraEnabled
  public static Case createCaseAU(
    Map<String, Object> caseData,
    Map<String, Object> contactData,
    List<Id> contentVersionIds
  ) {
    try {
      if (isException) {
        throw new DmlException('Something went wrong');
      }
      Case newCase = CSM_CaseControllerHelper.createCase(caseData);
      CSM_CaseAuController.updateContactEmail(contactData, newCase);
      CSM_CaseAuController.updateContentDocuments(
        contentVersionIds,
        newCase.Id
      );
      newCase = [SELECT id, CaseNumber FROM Case WHERE id = :newCase.Id];
      return newCase;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : getCategories
@description    : method is used to get Categories 
@param          : void
@return         : Map<String, Object>
********************************************************
*/
  @AuraEnabled(cacheable=true)
  public static Map<String, sObject> getCategories() {
    try {
      if (isException) {
        throw new QueryException('Something went wrong');
      }
      List<Category1__c> category1 = [
        SELECT Name, Label__c, French_Name__c, Spanish_Name__c
        FROM Category1__c
      ];
      List<Category2__c> category2 = [
        SELECT Name, Label__c, French_Name__c, Spanish_Name__c
        FROM Category2__c
      ];
      List<Category3__c> category3 = [
        SELECT Name, Label__c, French_Name__c, Spanish_Name__c
        FROM Category3__c
      ];

      Map<String, sObject> categoryMap = new Map<String, sObject>();

      for (Category1__c category : category1) {
        categoryMap.put(category.Name, category);
      }

      for (Category2__c category : category2) {
        categoryMap.put(category.Name, category);
      }

      for (Category3__c category : category3) {
        categoryMap.put(category.Name, category);
      }
      return categoryMap;
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : getCategory2_3_MappingRecord
@description    : method is used to get 2_3 Categories Mappings 
@param          : String,String,String
@return         : Category2_3_Mapping__c
********************************************************
*/
  @AuraEnabled
  public static Category2_3_Mapping__c getCategory2_3_MappingRecord(
    String roleType,
    String category2Name,
    String category3Name
  ) {
    try {
      if (isException) {
        throw new ListException('Something went wrong');
      }
     return CSM_CaseControllerHelper.getCategory2_3_MappingRecord( roleType,  category2Name, category3Name);
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : getFieldSet
@description    : method is used to get field set
@param          : String,String
@return         : List<Map<String, Object>>
********************************************************
*/
  @AuraEnabled
  public static List<Map<String, Object>> getFieldSet(
    String objectTypeName,
    String fieldSetName
  ) {
    List<Map<String, Object>> fieldSetList = CSM_CaseControllerHelper.getFieldSet(
      objectTypeName,
      fieldSetName
    );
    return fieldSetList;
  }

  @AuraEnabled
  public static String deleteContentDocument(List<String> contentVersionId) {
    try {
      return CSM_CaseAuController.deleteContentDocument(contentVersionId);
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
    *********************************************************
    @Method Name    : getContentVersions
    @description    : method is used to get contentVersions
    @param          : List<String>
    @return         : List<ContentVersion>
    ********************************************************
*/
  @AuraEnabled
  public static List<ContentVersion> getContentVersions(
    List<String> contentVersionIds
  ) {
    try {
      return CSM_CaseAuController.getContentVersions(contentVersionIds);
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
  *********************************************************
  @Method Name    : isReCAPTCHAValid
  @description    : method is used to check the validity of ReCAPTHA on Contact Form
  @param          : String
  @return         : Boolean
  ********************************************************
*/
  @AuraEnabled
  public static String isReCAPTCHAValid(String tokenFromClient) {
    try {
      return CSM_CaseRecaptchaController.isReCAPTCHAValid(tokenFromClient);
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  @AuraEnabled
  public static Case getCaseData(List<String> fieldApiNames, String recordId) {
    Case caseRecord;
    try {
      String queryString = 'SELECT Id';
      for (String fieldName : fieldApiNames) {
        queryString += ', ' + String.escapeSingleQuotes(fieldName);
      }
      queryString +=
        ' FROM Case where Id= \'' +
        String.escapeSingleQuotes(recordId) +
        '\'';
      caseRecord = Database.query(queryString);
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
    return caseRecord;
  }
}