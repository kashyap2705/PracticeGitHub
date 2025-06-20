/**     
    * <h1>IB_VVFAfterUpdateTriggerHandler</h1>      
    * This class is responsible managing After Update Trigger Handler functionality on IB_Verification_Visit_Feedback__c object.
    * 
    * @author Ammara Alvi       
    * @version 1.0      
    * @since   6-19-2020
    
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/

public class IB_VVFAfterUpdateTriggerHandler extends TriggerHandlerBase{  
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            TriggerContextUtility.setFirstRunFalse();
            process((Map<Id,IB_Verification_Visit_Feedback__c>)tp.oldMap, (List<IB_Verification_Visit_Feedback__c>)tp.newList);
        }
    }
    
    void process (Map<Id,IB_Verification_Visit_Feedback__c> old_feedback, List<IB_Verification_Visit_Feedback__c> new_fedback) {
         Set<ID> feedback_ids = new Set<ID>();
         Set<Id> programmeIdSet = new Set<ID>();// added by Kashyap as a part of ECM00536
   for(IB_Verification_Visit_Feedback__c verification_visit: new_fedback)
   {
       if(old_feedback.get(verification_visit.Id).Status__c != 'Submitted' && verification_visit.Status__c == 'Submitted'){
           feedback_ids.add(verification_visit.Id);
           programmeIdSet.add(verification_visit.IB_Programme__c); // added by kashyap as a part of ECM00536
       }
   }
    if(feedback_ids.size()>0){
   IB_VVFAfterUpdateTriggerHandler VVFeedback = new IB_VVFAfterUpdateTriggerHandler();
    VVFeedback.validate_feedback(feedback_ids);
        }
        
        /** Added by Kashyap as a part of ECM00536***/
         if(programmeIdSet != null && programmeIdSet.size() > 0)
        {
            updateRFCstatus(programmeIdSet);
        }
        /** End of addition by kashyap as a part of ECM00536**/
    }
    
    
    /** Added by Kashyap as a part of ECM00536**/
    public static void updateRFCstatus(Set<Id> relatedProg)
    {
        System.debug('IBApplicationFeedbackHandler updateRFCstatus');
        List<Campaign> rfcEvents = new List<Campaign>();        
        List<Campaign> updateRFCEvents = new List<Campaign>();
        rfcEvents = [Select Id, Status, Sub_Type__c, Related_IB_Programme__r.Owner__c from Campaign where Related_IB_Programme__c in :relatedProg
                     AND Status = 'Staffed' AND Sub_Type__c = 'Verification Visit']; 
        for(Campaign c : rfcEvents)
        {
            //c.Status = 'Complete';// Removed by Atticus as part of INC0180134 
            c.Verification_Visit_Submitted_by_IBEN__c = system.today();// added by Kashyap as a part of ECM00536
            updateRFCEvents.add(c);
        }
        update updateRFCEvents;
    }
     /**
     * This method is used to validate Verification Visit Feedback for Section A,B1,B2,C1,C2,C3,C4 and replace (" OR ') with a Null Character
     * @author Ammara Alvi
     * @since 6/26/2020
     * @return void
    */
    public void validate_feedback(Set<ID> feedbackids){
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_A__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_B1__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_B2__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_C1__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_C2__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_C3__c');
        Validate_Feedback_data(feedbackids,'IB_Verification_Visit_Feedback_C4__c');
        
        
    }
    public void Validate_Feedback_data(Set<ID> Feedback,String str){
        DescribeSObjectResult describeResult;
        if(str == 'IB_Verification_Visit_Feedback_A__c')
        describeResult = IB_Verification_Visit_Feedback_A__c.getSObjectType().getDescribe();
         if(str == 'IB_Verification_Visit_Feedback_B1__c')
        describeResult = IB_Verification_Visit_Feedback_B1__c.getSObjectType().getDescribe();
        if(str == 'IB_Verification_Visit_Feedback_B2__c')
        describeResult = IB_Verification_Visit_Feedback_B2__c.getSObjectType().getDescribe();
        if(str == 'IB_Verification_Visit_Feedback_C1__c')
        describeResult = IB_Verification_Visit_Feedback_C1__c.getSObjectType().getDescribe();
        if(str == 'IB_Verification_Visit_Feedback_C2__c')
        describeResult = IB_Verification_Visit_Feedback_C2__c.getSObjectType().getDescribe();
        if(str == 'IB_Verification_Visit_Feedback_C3__c')
        describeResult = IB_Verification_Visit_Feedback_C3__c.getSObjectType().getDescribe();
        if(str == 'IB_Verification_Visit_Feedback_C4__c')
        describeResult = IB_Verification_Visit_Feedback_C4__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() ); 
        String Feedbackquery =' SELECT ' +String.join( fieldNames, ',' ) +' FROM ' +describeResult.getName() +' WHERE ' +' IB_Verification_Visit_Feedback__c IN :Feedback ' +' LIMIT 1 ';
        List<SObject> feedback_recs = database.query(Feedbackquery);
        
        String newname = '';
        
        for (SObject rec: feedback_recs){
            for (Integer f=0; f< fieldNames.size();f++){
                newname=rec.get(fieldNames[f])+'';
                if(newname.contains('\'')){
                    newname=newname.replace('\'','');
                    rec.put(fieldNames[f], newname);
                    system.debug('Change: '+newname);
                }
                 if(newname.contains('"')){
                    newname=newname.replace('"','');
                    rec.put(fieldNames[f], newname);
                    system.debug('Change: '+newname);
                }
                System.debug(newname);
            }  }
        update feedback_recs;
        
    }
}