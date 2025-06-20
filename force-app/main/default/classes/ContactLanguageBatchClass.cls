/**
* <h1> ContactLanguageBatcnhClass </h1>
* This class is created to assign the owner id field value to development manager field (if it is null)
* This class is part of US12185
* @author  Umair - Plumlogix
* @version 1.0
* @since   2021-03-10 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

global class ContactLanguageBatchClass implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc) {
         
         
    string query = 'Select id, Development_Manager__c,isconverted, Status,OwnerId,Owner.isActive  from Lead where Development_Manager__c = Null and isconverted = false and Owner.isActive = true And (NOT Owner.name LIKE \'%Queue%\')' ;
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List <Lead> leadData) {
        
        List<Lead> leadList = new List<Lead>();
		for(Lead l : leadData)
        {
            l.Development_Manager__c = l.OwnerId;
            leadList.add(l);
        }
    
    try{
        if(leadList.size()>0)
      update leadList;
    }
    catch(Exception ex){
        System.debug('Exception: '+ex);
    }
        
    }
    
    
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}