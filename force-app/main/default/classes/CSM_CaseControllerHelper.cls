public without sharing class CSM_CaseControllerHelper {
  private static String ORIGIN = 'Web';
  private static String STATUS = 'Open';

  public static void createCaseNAU(
    Map<String, Object> caseData,
    Map<String, Object> contactData
  ) {
    try {
      AssignmentRule assignmentRule = getActiveAssignmentRuleForCase();
      Case newCase = new Case();

      List<FieldDefinition> fieldDefinitions = [
        SELECT Label, DataType, QualifiedApiName
        FROM FieldDefinition
        WHERE EntityDefinitionId = 'Case'
      ];
      Map<String, String> apiNameToTypeMap = new Map<String, String>();
      for (FieldDefinition fieldInfo : fieldDefinitions) {
        String apiName = (String) fieldInfo.QualifiedApiName;
        String type = (String) fieldInfo.DataType;
        apiNameToTypeMap.put(apiName, type);
      }

      // Loop through each case data key
      for (String fieldName : caseData.keySet()) {
        if (
          apiNameToTypeMap.get(fieldName) == 'Date' ||
          apiNameToTypeMap.get(fieldName) == 'Fecha'
        ) {
          newCase.put(
            fieldName,
            Date.valueOf(String.valueOf(caseData.get(fieldName)))
          );
        } else {
          newCase.put(fieldName, caseData.get(fieldName));
        }
      }

      newCase.put('Origin', ORIGIN);
      newCase.put('Status', STATUS);

      String email = String.valueOf(contactData.get('User_Email__c'));

      List<Contact> existingContacts = [
        SELECT Id, Email
        FROM Contact
        WHERE Email = :email
      ];

      for (String fieldName : contactData.keySet()) {
        newCase.put(fieldName, contactData.get(fieldName));
      }

      if (existingContacts.size() == 1) {
        // If a single contact is found, associate the Case to the Contact
        newCase.ContactId = existingContacts[0].Id;
      } else if (existingContacts.size() > 1) {
        // If there are multiple contacts with the same email, set a flag
        // to proceed without contact association
        newCase.Proceed_Case_without_Contact__c = true;
      } else {
        // If no match found, set a flag to proceed without contact
        newCase.Proceed_Case_without_Contact__c = true;
      }
      if (assignmentRule != null) {
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRule.id;
        newCase.setOptions(dmlOpts);
      }
      insert newCase;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
  *********************************************************
  @Method Name    : createCase
  @description    : method is used to create Case (Support Record Type)
  @param          : Map<String, Object>
  @return         : Case
  ********************************************************
*/

  public static Case createCase(Map<String, Object> caseData) {
    AssignmentRule assignmentRule = getActiveAssignmentRuleForCase();
    Case newCase = new Case();

    List<FieldDefinition> fieldDefinitions = [
      SELECT Label, DataType, QualifiedApiName
      FROM FieldDefinition
      WHERE EntityDefinitionId = 'Case'
    ];
    Map<String, String> apiNameToTypeMap = new Map<String, String>();
    for (FieldDefinition fieldInfo : fieldDefinitions) {
      String apiName = (String) fieldInfo.QualifiedApiName;
      String type = (String) fieldInfo.DataType;
      apiNameToTypeMap.put(apiName, type);
    }

    // Loop through each case data key
    for (String fieldName : caseData.keySet()) {
      // Check if the field is a date type
      if (
        apiNameToTypeMap.get(fieldName) == 'Date' ||
        apiNameToTypeMap.get(fieldName) == 'Fecha'
      ) {
        newCase.put(
          fieldName,
          Date.valueOf(String.valueOf(caseData.get(fieldName)))
        );
      } else {
        newCase.put(fieldName, caseData.get(fieldName));
      }
    }

    newCase.put('Origin', ORIGIN);
    newCase.put('Status', STATUS);
    newCase.put('ContactId', CSM_CaseAuController.getUserContact().Id);
    if (assignmentRule != null) {
      Database.DMLOptions dmlOpts = new Database.DMLOptions();
      dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRule.id;
      newCase.setOptions(dmlOpts);
    }
    insert newCase;
    return newCase;
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

      Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.FieldSets.getMap();

      if (fieldSetMap.containsKey(fieldSetName)) {
        List<Schema.FieldSetMember> fieldSetMembers = fieldSetMap.get(
            fieldSetName
          )
          .getFields();

        // Map<String, Schema.SObjectField> caseObjectFieldsMap = Case.SObjectType.getDescribe()
        //   .fields.getMap();

        for (Schema.FieldSetMember f : fieldSetMembers) {
          Map<String, Object> fieldMap = new Map<String, Object>();
          fieldMap.put('required', f.getDBRequired() || f.getRequired());
          fieldMap.put('type', (f.getType() + ''));
          fieldMap.put('label', f.getLabel());
          fieldMap.put('apiName', f.getFieldPath());

          /* HELP TEXT */
          // String fieldName = f.getFieldPath();
          // Schema.DescribeFieldResult fieldDescribe = caseObjectFieldsMap.get(
          //     fieldName
          //   )
          //   .getDescribe();
          // String fieldHelpText = fieldDescribe.getInlineHelpText();
          // fieldMap.put('helpText', fieldHelpText);

          fieldSetList.add(fieldMap);
        }
      }
      return fieldSetList;
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  /*
*********************************************************
@Method Name    : getActiveAssignmentRuleForCase
@description    : method is used to get the active Assignment Rule on case
@param          : void
@return         : AssignmentRule
********************************************************
*/
  public static AssignmentRule getActiveAssignmentRuleForCase() {
    try {
      List<AssignmentRule> assignmentRules = [
        SELECT Id
        FROM AssignmentRule
        WHERE SobjectType = 'Case' AND Active = TRUE
        LIMIT 1
      ];

      if (!assignmentRules.isEmpty()) {
        return assignmentRules[0];
      } else {
        return null;
      }
    } catch (Exception exp) {
      Logger.get().add(exp, LogSeverity.ERROR).publish();
      throw new AuraHandledException(exp.getMessage());
    }
  }

  @AuraEnabled
  public static Category2_3_Mapping__c getCategory2_3_MappingRecord(
    String roleType,
    String category2Name,
    String category3Name
  ) {
    List<Category2_3_Mapping__c> categoryRecord;
    try {
      String query =
        'SELECT id, Form_Label__c FROM Category2_3_Mapping__c WHERE IB_Roles__c = \'' +
        roleType +
        '\' AND Category2__r.Name = \'' +
        category2Name +
        '\' AND Category3__r.Name = \'' +
        category3Name +
        '\'';
      categoryRecord = Database.query(query);

      if (categoryRecord.isEmpty()) {
        return null;
      }
      return categoryRecord[0];
    } catch (Exception exp) {
      throw new AuraHandledException(exp.getMessage());
    }
  }
}