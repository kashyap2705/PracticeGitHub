/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Michael  Khan     08/08/2023         PRB0041128: Apex Test Execution Failed (SharingContactBatchTest)
*******************************************************************************************/

global class SharingContactBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        string query = 'select id, Event_Organizer_Account__r.RecordType.Name,Event_Organizer_Account__r.External_PD_Provider__c, Application_Status__c,Staffing_Event_Type__c,Staffing_Event__c,IB_Contact__c,Event_Organizer_Account__c,Staffing_Event_Venue__c from My_Staffing_Event__c WHERE LastModifiedDate >= YESTERDAY' ;
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc,List< My_Staffing_Event__c> newEvents)    {
         new MyStaffingEventTriggerHandler().GrantAccessToAccountContacts(newEvents);
       // new MyStaffingEventTriggerHandler().GrantAccessToEducator(newEvents); This is commented due UAT not passed for Chatter access for consultants

    }
    
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}