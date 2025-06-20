global class GrantAccessToIbenServiceBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
      //  string query =  ;
        return Database.getQueryLocator([select id,Application_Status__c,IB_Event__c,Staffing_Event_Type__c,Staffing_Event__c,IB_Contact__c,Event_Organizer_Account__c,Staffing_Event_Venue__c from My_Staffing_Event__c where Application_Status__c='Confirmed']);
    }
    global void execute(Database.BatchableContext bc,List< My_Staffing_Event__c> newEvents)    {
         for(My_Staffing_Event__c event:newEvents)
         {
             new MyStaffingEventTriggerHandler().GrantAccessToIbenService(new list<my_staffing_Event__c>{event});
         }

    }
    
    
    global void finish(Database.BatchableContext bc){
        
    }
    
}