public class IB_ConsultantFeedbackAfterUpdateTrigger extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        process((Map<Id,IB_Consultant_Feedback__c>)tp.oldMap, (Map<Id,IB_Consultant_Feedback__c>)tp.newMap);
     }
        
        private static void process (Map<Id,IB_Consultant_Feedback__c> oldFeedback, Map<Id,IB_Consultant_Feedback__c> newFeedback) {
        ibConsultantFeedbackProcessing(oldFeedback, newFeedback);
    }
    
    private static void ibConsultantFeedbackProcessing(Map<Id,IB_Consultant_Feedback__c> oldMap, Map<Id,IB_Consultant_Feedback__c> newMap) {
        RecordType recTypeEndProcess = RecordTypeService.getRecordTypeByTypeAndName('IB_Consultant_Feedback__c', 'End_of_Process');
        RecordType recTypeInitialVisit = RecordTypeService.getRecordTypeByTypeAndName('IB_Consultant_Feedback__c', 'Initial_Visit');
        
        
        Set<Id> progIdSetForEndOfProcess = new Set<Id>();
        Set<Id> progIdSetForInitialVisit = new Set<Id>();
        
        for (IB_Consultant_Feedback__c consultantFeedback : newMap.values()) {
            
            if (newMap.get(consultantFeedback.Id).RecordTypeId == recTypeEndProcess.Id && oldMap.get(consultantFeedback.Id).Status__c != 'Submitted' && newMap.get(consultantFeedback.Id).Status__c == 'Submitted') {
                progIdSetForEndOfProcess.add(consultantFeedback.IB_Programme_Lookup__c);
            }
            if (newMap.get(consultantFeedback.Id).RecordTypeId == recTypeInitialVisit.Id && oldMap.get(consultantFeedback.Id).Status__c != 'Submitted' && newMap.get(consultantFeedback.Id).Status__c == 'Submitted') {
                progIdSetForInitialVisit.add(consultantFeedback.IB_Programme_Lookup__c);
            }
        }
        
        if(!progIdSetForEndOfProcess.isEmpty())
        {
            ibEventUpdation(progIdSetForEndOfProcess,'recTypeEndProcess');
        }
        if(!progIdSetForInitialVisit.isEmpty())
        {
            ibEventUpdation(progIdSetForInitialVisit,'recTypeInitialVisit');
        }
        
    }
    
    public static void ibEventUpdation(Set<Id> relatedProg, String recordTyeName)
    {
        System.debug('IBApplicationFeedbackHandler updateRFCstatus');
        List<Campaign> rfcEvents = new List<Campaign>();        
        List<Campaign> updateRFCEvents = new List<Campaign>();
        rfcEvents = [Select Id, Status, Sub_Type__c, Related_IB_Programme__r.Owner__c from Campaign where Related_IB_Programme__c in :relatedProg
                     AND Status = 'Staffed' AND Sub_Type__c = 'Candidacy Consultation'];
        if(recordTyeName =='recTypeInitialVisit' && !rfcEvents.isEmpty())
        {
            for(Campaign c : rfcEvents)
            {
                //c.Status = 'Complete'; // Removed by Atticus as part of INC0180134 
                c.Visit_Report_Received__c = system.today();
                updateRFCEvents.add(c);
            }
        }
        if(recordTyeName =='recTypeEndProcess' && !rfcEvents.isEmpty())
        {
            for(Campaign c : rfcEvents)
            {
                //c.Status = 'Complete'; // Removed by Atticus as part of INC0180134 
                c.End_of_Consultation_Report_Received__c = system.today();
                updateRFCEvents.add(c);
            }
        }
        
        if(!updateRFCEvents.isEmpty()){
            try{
                System.debug('IBApplicationFeedbackHandler updateRFCEvents:'+updateRFCEvents.size());
                update updateRFCEvents;
               
                
            }catch(Exception e){
                System.debug('Exception Occured: ' + e);
            }
        }
    }

}