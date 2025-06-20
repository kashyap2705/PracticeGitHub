public without sharing class MyTrainingEventExtController {
     
     public My_Training_Event__c mytraningEvent {
        get; set;
     }
      
     public MyTrainingEventExtController (ApexPages.StandardController stdController) {
     	final List<String> allFields = new List<String> {'Training_Event__c', 'Level_of_Interest__c' , 'Invitation_Response__c',
     	                                                  'Release_Permission_Required__c', 'Application_Status__c' , 'Withdrawal_Reason__c', 'Withdrawal_Argumentation__c' };
        
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