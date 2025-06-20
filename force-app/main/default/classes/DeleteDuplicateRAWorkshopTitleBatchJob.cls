global class DeleteDuplicateRAWorkshopTitleBatchJob implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
            String query = 'SELECT Id,Name, Role_And_Application__c,IB_Workshop_Title__c,Duplicate__c FROM Role_Application_Workshop_Title__c where Duplicate__c = true';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Role_Application_Workshop_Title__c> scope) {
 
         list<Role_Application_Workshop_Title__c> dupAppWorkTitleList = new List<Role_Application_Workshop_Title__c>();
        
        for(Role_Application_Workshop_Title__c ra : scope){
            dupAppWorkTitleList.add((Role_Application_Workshop_Title__c)ra);
        }

        system.debug('Duplicate WorkingTitles Count'+dupAppWorkTitleList.size());
        if(dupAppWorkTitleList.size() > 0){
           Delete dupAppWorkTitleList;  
        }
             
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
      
}