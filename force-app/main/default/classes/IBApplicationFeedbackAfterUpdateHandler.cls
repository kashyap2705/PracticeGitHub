public class IBApplicationFeedbackAfterUpdateHandler extends TriggerHandlerBase {
   
    // When feedback status changed from Not Started to Submitted --> 1. send email to PRM 2. Update corresponding IB Event status from Staffed to Complete  3. Create task for PRM
    
    public override void mainEntry(TriggerParameters tp){
        System.debug('IBApplicationFeedbackHandler mainEntry');
        process((Map<Id,IB_Application_Feedback__c>)tp.oldMap, (Map<Id,IB_Application_Feedback__c>)tp.newMap ,(list<IB_Application_Feedback__c>)tp.newList
                ,(list<IB_Application_Feedback__c>)tp.oldList);
    }
    
    private static void process (Map<Id,IB_Application_Feedback__c> oldFeedback, Map<Id,IB_Application_Feedback__c> newFeedback, 
                                 list<IB_Application_Feedback__c> newlist , list<IB_Application_Feedback__c> oldlist) {
                                     System.debug('IBApplicationFeedbackHandler pre updateFeedbackStatus ');
                                     onUpdateFeedbackStatus(oldFeedback, newFeedback);
                                     System.debug('IBApplicationFeedbackHandler post updateFeedbackStatus ');
                                 }
    
    private static void onUpdateFeedbackStatus(Map<Id,IB_Application_Feedback__c> oldMap, Map<Id,IB_Application_Feedback__c> newMap){
        
        Set<Id> feedIdSet = new Set<Id>();
        Set<Id> programmeIdSet = new Set<ID>();
        
        List<IB_Application_Feedback__c> feedList = new List <IB_Application_Feedback__c>();
        
        for(IB_Application_Feedback__c feedback : newMap.values())
        {
            if(feedback.Status__c == 'Submitted' && oldMap.get(feedback.Id).Status__c != 'Submitted')
            {
                feedIdSet.add(feedback.Id); 
            }
        }
        //varAppFeedbackID, varProgrammeID, varProgrammeName, varApplicationID, varAccountID
        //AccountIBISCode, varProgrammeOwner, varProgrammeOwnerName, varProgrammeOwnerEmail
        feedList = [Select Id, IB_Programme_Lookup__c, IB_Programme_Lookup__r.Name, FB_Lookup_IB_Application__c, IB_Programme_Lookup__r.Account__r.Id, 
                    IB_Programme_Lookup__r.Account__r.IBIS_Id__c, IB_Programme_Lookup__r.Owner__c, IB_Programme_Lookup__r.Owner__r.Name, IB_Programme_Lookup__r.Owner__r.Email,
                    Status__c from IB_Application_Feedback__c where Id in :feedIdSet];
        
        if(feedList != null && feedList.size() >0 )
        {
            for(integer i=0; i< feedList.size(); i++)
            {
                System.debug('IBApplicationFeedbackHandler feedList:'+feedList[i]);
                SendPRMEmail(feedList[i].IB_Programme_Lookup__r.Owner__r.Email, 
                             feedList[i].IB_Programme_Lookup__r.Owner__r.Name, 
                             feedList[i].IB_Programme_Lookup__r.Account__r.IBIS_Id__c, 
                             feedList[i].IB_Programme_Lookup__r.Name, 
                             feedList[i].Id);
                programmeIdSet.add(feedList[i].IB_Programme_Lookup__c);
            }
        }
        
        if(programmeIdSet != null && programmeIdSet.size() > 0)
        {
            updateRFCstatus(programmeIdSet);
        }
        
    }
    
    public static void SendPRMEmail(String userEmail, String programmeOwnerName, String accountIBISCode, String programmeName, Id appFeedbackID) {
        System.debug('IBApplicationFeedbackHandler SendPRMEmail');
        
        try {
            
            ID Org_wide_id;
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
            if ( owea.size() > 0 ) {
                Org_wide_id = owea.get(0).Id;
            }
            System.debug('IBApplicationFeedbackHandler userEmail: '+ userEmail);
            
            String[] sendingTo = new String[]{userEmail};
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setOrgWideEmailAddressId(Org_wide_id);
            mail.setToAddresses(sendingTo);
            mail.setSubject('Application for candidacy feedback submitted:' + accountIBISCode);
            mail.setPlainTextBody(programmeOwnerName +'\n\n' +
                                  'Application for candidacy feedback has been submitted for '+ accountIBISCode +' and ' + programmeName+'.\n'+
                                  'Please log into Salesforce to begin your review ' + Label.BASE_URL + '/apex/InternalApplicationFeedback?id=' + appFeedbackID + '.');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            System.debug('IBApplicationFeedbackHandler mail: '+ mail);
            
        }
        catch (Exception ex) {
            System.debug('Error in Send Email:'+ ex);
        }
    }
    
    public static void updateRFCstatus(Set<Id> relatedProg)
    {
        System.debug('IBApplicationFeedbackHandler updateRFCstatus');
        List<Campaign> rfcEvents = new List<Campaign>();		
        List<Campaign> updateRFCEvents = new List<Campaign>();
        rfcEvents = [Select Id, Status, Sub_Type__c, Related_IB_Programme__r.Owner__c from Campaign where Related_IB_Programme__c in :relatedProg
                     AND Status = 'Staffed' AND Sub_Type__c = 'Request for Candidacy'];
        for(Campaign c : rfcEvents)
        {
            c.Status = 'Complete';
		    c.Feedback_Part_1_Spreadsheet_Uploaded__c = system.today();// added by Kashyap as a part of ECM00536 
            updateRFCEvents.add(c);
        }
        
        if(!updateRFCEvents.isEmpty()){
            try{
                System.debug('IBApplicationFeedbackHandler updateRFCEvents:'+updateRFCEvents.size());
                update updateRFCEvents;
                createPRMTask(updateRFCEvents);
                System.debug('IBApplicationFeedbackHandler postcreatePRMTask:');
                
            }catch(Exception e){
                System.debug('Exception Occured: ' + e);
            }
        }
    }
    
    public static void createPRMTask(List<Campaign> campaignList){
        System.debug('IBApplicationFeedbackHandler in createPRMTask:'+campaignList.size());
        Id taskRecordTypeId = Schema.getGlobalDescribe().get('Task').getDescribe().getRecordTypeInfosByName().get('standard').getRecordTypeId();        
        List<Task> taskList = new List<Task>();
        for(Campaign c: campaignList){
            Task taskPRM = new Task();
            //Defaults
            taskPRM.Type = 'Other';
            taskPRM.Subject = 'Review feedback on candidacy';
            taskPRM.Status = 'Not Started';
            taskPRM.Description = 'Review feedback on candidacy';
            //Dynamic
            taskPRM.RecordTypeId = taskRecordTypeId;
            taskPRM.ActivityDate = System.today() + 7;
            taskPRM.OwnerId = c.Related_IB_Programme__r.Owner__c; 
            taskPRM.WhatId = c.Id; 
            taskList.add(taskPRM);
        }
        System.debug('IBApplicationFeedbackHandler taskList:'+taskList.size());
        if(taskList.size() > 0)
        {
            try{
                insert taskList;
                System.debug('IBApplicationFeedbackHandler taskList inserted');
                
            }catch(Exception e){
                System.debug('Exception Occured: ' + e);
            }
        }
    }
}