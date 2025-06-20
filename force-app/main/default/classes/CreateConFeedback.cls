public with sharing class CreateConFeedback {

  @InvocableMethod(label='Create EOP Consultant Feedback')
  public static List<Boolean> createEOPFeedbackRecord(List<CreateEOPActionRequest> requests) {

    List<Id> visitIds = new List<Id>();

    for (CreateEOPActionRequest request : requests) {
      visitIds.add(request.visitFeedbackId);
    }

  RecordType eopRecType = [select Id from RecordType where DeveloperName = 'End_of_Process' AND sObjectType = 'IB_Consultant_Feedback__c' limit 1];
  RecordType visitRecType = [select Id from RecordType where DeveloperName = 'Initial_Visit' AND sObjectType = 'IB_Consultant_Feedback__c' limit 1];

  DescribeSObjectResult describeResult = IB_Consultant_Feedback__c.getSObjectType().getDescribe();
  List<String> fieldNames = new List<String>();
  //below Set created by Prerna for ECM00753 - 2 on 1st Dec 2024    
  Set<String> existingFields = new Set<String>();
  for(String tmp : describeResult.fields.getMap().keySet()){
	 //below if modified by Prerna for ECM00753 - 2 on 1st Dec 2024 and added Analysis_Findings__c And CV_EOC_Findings_and_Next_Steps__c since we have to fetch data related to these fields as well.
      if(tmp.containsIgnoreCase('Initial_Findings_and_Next_Steps') || tmp.containsIgnoreCase('Consultant_Advice_Initial__c') || tmp.containsIgnoreCase('Analysis_Findings__c') || tmp.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')){
          fieldNames.add(tmp);
      }
      //code Added by Prerna for ECM00753 - 2 on 1st Dec 2024 --STARTS--
      if(tmp.containsIgnoreCase('Analysis_Findings__c') || tmp.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')){
        existingFields.add(tmp);
      }
      //code Added by Prerna for ECM00753 - 2 on 1st Dec 2024 --ENDS--
  }

  System.debug(LoggingLevel.ERROR, fieldNames);

  String qStr = 'SELECT ' + String.join(fieldNames, ',') + ', IB_Application__c, Name, IB_Programme_Lookup__c, Assignment_Id__c FROM ' + describeResult.getName() + ' WHERE Id IN :visitIds and recordTypeId = \''+ visitRecType.Id + '\'';
  System.debug(LoggingLevel.ERROR, qStr.substringAfter('FROM'));
  List<IB_Consultant_Feedback__c> visitFeedbackList = Database.query(qStr);
  List<IB_Consultant_Feedback__c> eopFeedbackList = new List<IB_Consultant_Feedback__c>();
      for(IB_Consultant_Feedback__c tmp : visitFeedbackList){
          IB_Consultant_Feedback__c tmpFeedback = tmp.clone();
          tmpFeedback.recordTypeId = eopRecType.Id;
          tmpFeedback.Status__c = 'Not Started';
          //code Added by Prerna for ECM00753 - 2 on 1st Dec 2024 --STARTS--
          for(String exstFields: existingFields){
              String newKey;
              if(exstFields.containsIgnoreCase('Analysis_Findings__c')){
                  String prefix = exstFields.replace('analysis_findings__c', '');
                  newKey = prefix + 'IV_Analysis_For_Reporting__c';
              }
              else if(exstFields.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')){
                  String prefixEoc = exstFields.replace('cv_eoc_findings_and_next_steps__c', '');
                  newKey = prefixEoc + 'IV_Next_Steps_for_Reporting__c';
              }
              // Check if the field with the API name newKey exists on the IB_Consultant_Feedback__c object
              if (describeResult.fields.getMap().containsKey(newKey)) {
                  System.debug('Field ' + newKey + ' exists on IB_Consultant_Feedback__c');
                  tmpFeedback.put(newKey, tmp.get(exstFields)); 
              } else {
                  System.debug('Field ' + newKey + ' does NOT exist on IB_Consultant_Feedback__c');
              }
              tmpFeedback.put(exstFields, ''); 
          }
          //code Added by Prerna for ECM00753 - 2 on 1st Dec 2024 --ENDS--
          eopFeedbackList.add(tmpFeedback);
      }
      
      insert eopFeedbackList;
      
      return new List<Boolean>{true};
          }

 // public static void handleError(Exception e, List<CreateEOPActionRequest> requests){

  //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

  //List<String> toIds = new List<String>();

  //for(User tmp : [SELECT ID from User where Profile.Name = 'System Administrator' AND isActive = true]){
  //  toIds.add(tmp.Id);
  //}

  //message.toAddresses = toIds;
  //message.subject = 'End of Process Consultant Report Failed to be Created';

  //String startIds = '';

  //for(CreateEOPActionRequest tmp : requests){
  //  startIds += '['+tmp.visitFeedbackId+']';
  //}

  //String body = 'The Initial Visit Consultant Report ID(s) that triggered this process is/are\n'+
  //startIds + '\n\n'+
  //'CAUSE: ' + e.getCause() + '\n'+
  //'LINE_NUMBER: ' + e.getLineNumber() + '\n'+
  //'MESSAGE: ' + e.getMessage() + '\n'+
  //'STACK_TRACE: ' + e.getStackTraceString() + '\n'+
  //'TYPE_NAME: ' + e.getTypeName() + '\n';

  //message.plainTextBody = body;
  //Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
  //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 // }

  public class CreateEOPActionRequest {
    @InvocableVariable(required=true)
    public ID visitFeedbackId;
  }

}