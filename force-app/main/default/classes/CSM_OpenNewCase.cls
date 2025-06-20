public without sharing class CSM_OpenNewCase {
  public static Boolean isException = false;

  @AuraEnabled(cacheable=true)
  public static Map<String, sObject> getCategories() {
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
  }

  @AuraEnabled
  public static Category2_3_Mapping__c getCategory2_3_MappingRecord(
    String roleType,
    String category2Name,
    String category3Name
  ) {
    System.debug('category2Name: ' + category2Name);
    System.debug('category3Name: ' + category3Name);
    System.debug('roleType: ' + roleType);

    List<Category2_3_Mapping__c> categoryRecord;
    try {
      categoryRecord = [
        SELECT id, Form_Label__c
        FROM Category2_3_Mapping__c
        WHERE
          IB_Roles__c = :roleType
          AND Category2__r.Name = :category2Name
          AND Category3__r.Name = :category3Name
      ];
      if (isException) {
        throw new ListException('Something went wrong');
      }
      System.debug(categoryRecord);
      if (categoryRecord.isEmpty()) {
        return null;
      }
      return categoryRecord[0];
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  @AuraEnabled
  public static List<Map<String, Object>> getFieldSet(
    String objectTypeName,
    String fieldSetName
  ) {
    List<Map<String, Object>> fieldSetList = new List<Map<String, Object>>();
    try {
      List<Schema.FieldSetMember> fieldSetMembersList;
      Schema.DescribeSObjectResult objectDescribe = Schema.SObjectType.Case;
      System.debug(objectDescribe);

      Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.FieldSets.getMap();
      System.debug(fieldSetMap);

      if (fieldSetMap.containsKey(fieldSetName)) {
        List<Schema.FieldSetMember> fieldSetMembers = fieldSetMap.get(
            fieldSetName
          )
          .getFields();
        System.debug(fieldSetMembers);
        Map<String, Schema.SObjectField> caseObjectFieldsMap = Case.SObjectType.getDescribe()
          .fields.getMap();
        for (Schema.FieldSetMember f : fieldSetMembers) {
          Map<String, Object> fieldMap = new Map<String, Object>();
          fieldMap.put('required', f.getDBRequired() || f.getRequired());
          fieldMap.put('type', (f.getType() + ''));
          fieldMap.put('label', f.getLabel());
          fieldMap.put('apiName', f.getFieldPath());
          /* HELP TEXT */
          String fieldName = f.getFieldPath();
          Schema.DescribeFieldResult fieldDescribe = caseObjectFieldsMap
            .get(fieldName)
            .getDescribe();
          String fieldHelpText = fieldDescribe.getInlineHelpText();
          System.debug('Field Help Text: ' + fieldHelpText);
          fieldMap.put('helpText', fieldHelpText);
          fieldSetList.add(fieldMap);
        }
        System.debug(fieldSetList);
      }
      return fieldSetList;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  @AuraEnabled(cacheable=true)
//   public static List<ContentVersion> getContentVersions(List<String> contentDocumentIds) {
//     List<ContentVersion> cvList = new List<ContentVersion>();
//     try {
//         cvList = [SELECT Id, ContentDocumentId, FileExtension, Title, ContentSize, CreatedBy.Name FROM ContentVersion WHERE Id IN :contentDocumentIds];

//         Set<Id> contentDocumentIdSet = new Set<Id>();
//         for (ContentVersion cv : cvList) {
//             contentDocumentIdSet.add(cv.ContentDocumentId);
//         }

//         List<ContentDocument> cdList = [SELECT Id, Title FROM ContentDocument WHERE Id IN :contentDocumentIdSet];
//         Map<Id, ContentDocument> cdMap = new Map<Id, ContentDocument>();
//         for (ContentDocument cd : cdList) {
//             cdMap.put(cd.Id, cd);
//         }

//         List<ContentDocument> updatedCdList = new List<ContentDocument>();
//         for (ContentVersion cv : cvList) {
//             ContentDocument cd = cdMap.get(cv.ContentDocumentId);
//             if (cd != null) {
//                 cd.Title = 'IB_Answers ' + cd.Title;
//                 updatedCdList.add(cd);
//             }
//         }

//         update updatedCdList;
//     } catch (Exception exp) {
//         Logger.get().add(exp, LogSeverity.ERROR).publish();
//         throw new AuraHandledException(exp.getMessage());
//     }
//     return cvList; // Return the original ContentVersion list
// }

  public static List<ContentVersion> getContentVersions(
    List<String> contentVersionIds
  ) {
    try {
      System.debug('METHOD Called' + contentVersionIds);
      return [
        SELECT
          Id,
          ContentDocumentId,
          FileExtension,
          Title,
          ContentSize,
          CreatedBy.Name
        FROM ContentVersion
        WHERE Id IN :contentVersionIds
      ];
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  @AuraEnabled
  public static String deleteContentDocument(List<String> contentVersionId) {
    system.debug('contentDocumentId-->' + contentVersionId);
    List<String> contentDocumentIDList = new List<String>();
    for (ContentVersion cv : [
      SELECT
        Id,
        ContentDocumentId,
        FileExtension,
        Title,
        ContentSize,
        CreatedBy.Name
      FROM ContentVersion
      WHERE Id IN :contentVersionId
    ]) {
      system.debug('inside contentDocumentId-->');
      contentDocumentIDList.add(cv.ContentDocumentId);
    }
    system.debug('contentDocumentIDList-->' + contentDocumentIDList);
    try {
      List<ContentDocument> cd = [
        SELECT Id, CreatedBy.name, ContentSize, ParentId
        FROM ContentDocument
        WHERE Id IN :contentDocumentIDList
      ];
      delete cd;
      return 'Success';
    } catch (Exception exp) {
      System.debug(exp);
      // Logger.get().add(exp, LogSeverity.ERROR).publish();
      // throw new AuraHandledException(exp.getMessage());
      return 'fail';
    }
  }

}