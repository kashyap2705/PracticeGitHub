/*
* @description - This is used to execute GetWebinarAttendees class in batch.
*
* @author: Vikash Kumar
* @since 11-03-2025
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 11-03-2025     Created             US-0003047       Created the class
*/
global class GetWebinarAttendeesBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Integer daysCount = integer.valueof(System.Label.Get_Webinar_Days_Filter);   
		
		String query = 'select id,name,CreatedDate,Webinar_Net_ID__c from Campaign where CreatedDate =LAST_N_DAYS:'+ daysCount;
		query += 'and Webinar_Net_Tracking__c = true';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<Campaign> campaignList) {
		
        for(Campaign camp : campaignList) { 
            if(camp.Webinar_Net_ID__c != null){
                GetWebinarAttendees.addWebinarAttendeeRecords(camp.Webinar_Net_ID__c);
            }          
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}