global with sharing class Batch_DeleteHistoryRecords implements Database.Batchable<sObject>,schedulable{ 

    List<e_eat__Audit_Tracking_sObject__c> objectList = new List<e_eat__Audit_Tracking_sObject__c>();
    global Batch_DeleteHistoryRecords(){
        if(Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__API_Name__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__Archival_Time_in_Months__c.isAccessible()) {
                objectList = [SELECT Id,e_eat__API_Name__c,e_eat__Archival_Time_in_Months__c FROM e_eat__Audit_Tracking_sObject__c 
                              where e_eat__API_Name__c != null];
           }
    }
    // Database.Batchable interface method
    global  Database.QueryLocator start(Database.BatchableContext info){
        
        Map<String,Integer> archivalMap = new Map<String,Integer>();
        for(e_eat__Audit_Tracking_sObject__c obj : objectList){
            archivalMap.put(obj.Id, obj.e_eat__Archival_Time_in_Months__c.intValue());
        }
        String query;
        if(Schema.SObjectType.e_eat__Audit_Tracking_History__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Audit_Tracking_sObject__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.CreatedDate.isAccessible()) {
        
            query = 'select Id from e_eat__Audit_Tracking_History__c where ';
            for( Id obj : archivalMap.keySet()){
                Integer duration = (archivalMap.get(obj) * -1);
                query += '(e_eat__Audit_Tracking_sObject__c = \''+obj +'\' AND CreatedDate <=' +System.now().addMonths(duration).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                query += ') OR ';
            }
            query = query.substringBeforeLast('OR ');
           }
        return Database.getQueryLocator(query);   
    }

    // Database.Batchable interface method     
    global void execute(Database.BatchableContext BC, List<e_eat__Audit_Tracking_History__c> historyRecords){
        if(Schema.SObjectType.e_eat__Audit_Tracking_History__c.isDeletable() && !historyRecords.isEmpty()) {
         	Database.delete(historyRecords);   
        }
    }

    // Database.Batchable interface method    
    global void finish(Database.BatchableContext info){
    
    }
    
    // schedulable interface method
    global void execute(SchedulableContext SC){
        Database.executeBatch(new Batch_DeleteHistoryRecords(), 200);
    }

}