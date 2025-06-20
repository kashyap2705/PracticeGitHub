public without sharing class MyTrainingEventInternalExtController {
    
     public My_Training_Event__c mytraningEvent {
        get; set;
     }
      
     public MyTrainingEventInternalExtController (ApexPages.StandardController stdController) {
        final List<String> allFields = new List<String> {'Training_Event__c','Name', 'Application_Status__c','IB_Contact__c','Invitation_Response__c','Level_of_Interest__c','Release_Response__c',
        'Release_Permission_Required__c','Withdrawal_Reason__c','Withdrawal_Argumentation__c','Application_Feedback__c','Training_Event_Recommendation__c','IB_Event__c',
        'IB_Role_Recommendation__c','Redirection_Reason__c','Related_IB_Programme_Recommendation__c','Training_Result__c','Role_Level__c','Training_Feedback__c','Declined_for_Further_Trainings__c'};
        
        if (! Test.isRunningTest()) {
            
            stdController.addFields(allFields);
        }
        
        mytraningEvent = (My_Training_Event__c) stdController.getRecord();
        
        if (null == mytraningEvent.Training_Event__c) {
            mytraningEvent.Training_Event__c = ApexPages.currentPage().getParameters().get('trainingEventId');
        }
        
        
     }
     
     public PageReference  save () {

        try {
            MyTrainingEventsDAO trainDAO = MyTrainingEventsDAO.getInstance();
            if(mytraningEvent.IB_Event__c == null){
                mytraningEvent.IB_Event__c = trainDAO.getCampaignIdFromTrainingId(mytraningEvent.Training_Event__c);
            }
            upsert mytraningEvent;
            
        } catch (System.DmlException e) {
               for (Integer i = 0; i < e.getNumDml(); i++) {
                  ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
                  
               }
                 
               return null;
               
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' '+ ex.getMessage()));
            return null;        
        }   
        
        final String retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        if (!String.isBlank(retUrl)) {
            return new PageReference(retUrl);
        }
        
        return new PageReference('/'+mytraningEvent.id);
        
    }
    
    public PageReference cancel () {
        final String retUrl = ApexPages.currentPage().getParameters().get('cancelURL');
        
        if (!String.isBlank(retUrl)) {
            return new PageReference(retUrl);
        }
        
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        
        if (!String.isBlank(retUrl)) {
            return new PageReference(retUrl);
        }
        
        return new PageReference('/a0t/o');
    }
     
}