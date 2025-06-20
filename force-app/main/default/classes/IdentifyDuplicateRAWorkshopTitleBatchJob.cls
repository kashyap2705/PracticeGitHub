global class IdentifyDuplicateRAWorkshopTitleBatchJob implements Database.Batchable<sObject>  {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name, Role_And_Application__c,Role_And_Application__r.Name,IB_Workshop_Title__c,Duplicate__c FROM Role_Application_Workshop_Title__c where Duplicate__c = false Order By Role_And_Application__c';//  Role_And_Application__r.Name != null and 
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Role_Application_Workshop_Title__c> scope) {

         set<string> uniqueAppWorkTitleSet = new set<string>();
         list<Role_Application_Workshop_Title__c> dupAppWorkTitleList = new List<Role_Application_Workshop_Title__c>();
         list<Role_Application_Workshop_Title__c> nullAppWorkTitleList = new List<Role_Application_Workshop_Title__c>();
         list<Role_Application_Workshop_Title__c> allDuplicateRAWTList = new List<Role_Application_Workshop_Title__c>();
        
        for(Role_Application_Workshop_Title__c ra : scope){
            string key = '' + (Id)ra.get('Role_And_Application__c') + (Id)ra.get('IB_Workshop_Title__c');
            if((Id)ra.get('Role_And_Application__c') == null){
                nullAppWorkTitleList.add((Role_Application_Workshop_Title__c)ra);
             }

            if((Id)ra.get('Role_And_Application__c') != null){
                 system.debug('R&A##'+(Id)ra.get('Role_And_Application__c'));
                if(uniqueAppWorkTitleSet.contains(key) ){
                   system.debug('identified duplicate##'+key);
                    dupAppWorkTitleList.add((Role_Application_Workshop_Title__c)ra);
                }else{
                    uniqueAppWorkTitleSet.add(key);	
                }            
            }

            key = '';
        }
        system.debug('dupAppWorkTitleList##'+dupAppWorkTitleList.size());
        system.debug('nullAppWorkTitleList##'+nullAppWorkTitleList.size());
        allDuplicateRAWTList.addall(nullAppWorkTitleList);
        allDuplicateRAWTList.addall(dupAppWorkTitleList);

         for(Role_Application_Workshop_Title__c dup : allDuplicateRAWTList)
         {
            dup.Duplicate__c = true;
          }
        
        system.debug('Original WorkingTitles Count'+scope.size());        
        system.debug('Duplicate WorkingTitles Count'+allDuplicateRAWTList.size());
        if(allDuplicateRAWTList.size() > 0){
           Update allDuplicateRAWTList;  
        }
             
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
      

}