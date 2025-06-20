public class IB_ConsultantFeedbackBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        process((Map<Id,IB_Consultant_Feedback__c>)tp.oldMap, (Map<Id,IB_Consultant_Feedback__c>)tp.newMap);
    }
        
    private static void process (Map<Id,IB_Consultant_Feedback__c> oldFeedback, Map<Id,IB_Consultant_Feedback__c> newFeedback) {
        ibConsultantFeedbackProcessing(oldFeedback, newFeedback);
        Validate_Feedback_Data(newFeedback);//Added INC0178453 BenMcgarvey
    }
    
     private static void ibConsultantFeedbackProcessing(Map<Id,IB_Consultant_Feedback__c> oldMap, Map<Id,IB_Consultant_Feedback__c> newMap) {
         for (IB_Consultant_Feedback__c consultantFeedback : newMap.values()) {
             
           if (oldMap.get(consultantFeedback.Id).Status__c != 'Submitted' && newMap.get(consultantFeedback.Id).Status__c == 'Submitted') {
                
               consultantFeedback.consultant_submitted_id__c  = consultantFeedback.LastModifiedById;
            }
            
        }
         
     }
    
    //This method added for INC0178453 to remove quotes so that the report button can be used. This saves users 
    //manually deleting all single and double quotes
    private static void Validate_Feedback_Data(Map<Id,IB_Consultant_Feedback__c> newFeedback){
        DescribeSObjectResult describeResult = IB_Consultant_Feedback__c.getSObjectType().getDescribe(); 
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.IB_Consultant_Feedback__c.fields.getMap();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() ); 
		String newname='';
        
        
        for (IB_Consultant_Feedback__c feedback: newFeedback.values()){
            
            for (Integer f=0; f< fieldNames.size();f++){
                if(fieldMap.get(fieldNames[f]).getDescribe().isUpdateable()){
                    newname=feedback.get(fieldNames[f])+'';
                    //if(newname.contains('\'')){
                    //    newname=newname.replace('\'','');
                    //    feedback.put(fieldNames[f], newname);
                    //    system.debug('Change: '+newname);
                    //}
                     if(newname.contains('"')){
                        newname=newname.replace('"','');
                        feedback.put(fieldNames[f], newname);
                        system.debug('Change: '+newname);
                    }
                    System.debug(newname);
                   }
            }
            
        }
    }

}