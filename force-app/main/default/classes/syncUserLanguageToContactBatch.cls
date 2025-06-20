// Batch Job for updated the language field on contacts to match the user language.
// Created by Kevin Fugate on 3/23/2023
// Tested by syncUserLanguageToContactBatchTest
// To use this batch on all contact records, execute: Database.executeBatch(new syncUserLanguageToContactBatch(), 200);
// To use this batch on specific contact records, execute: Database.executeBatch(new syncUserLanguageToContactBatch('SOQL QUERY STRING'), 200);
global class syncUserLanguageToContactBatch implements Database.Batchable<sObject>,   Database.AllowsCallouts {
    
    global string batchQuery;
    
    // Constructor for query input
    global syncUserLanguageToContactBatch(String batchQuery){
        this.batchQuery = batchQuery;
    }
    
    // Constructor for all contacts
    global syncUserLanguageToContactBatch(){
    }
    
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        if(batchQuery==null){
            if(!Test.isRunningTest()){
                return Database.getQueryLocator('select id, LanguageLocaleKey, Contactid, Contact.User_Language__c FROM User WHERE User.Contactid != null AND Contact_Language_Mismatch__c = true');
            } else {
                return Database.getQueryLocator('select id, LanguageLocaleKey, Contactid, Contact.User_Language__c FROM User WHERE User.Contactid != null AND (Profile.Name LIKE \'%Customer%\'OR Profile.Name LIKE \'%Partner%\') LIMIT 200');
            }
        } else {
            return Database.getQueryLocator(batchQuery);
        }
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<User> scope) {
        List<Contact> conList = new List<Contact>();
        for(User u : scope){
            Contact con = new Contact(Id = u.ContactId, User_Language__c = u.LanguageLocaleKey);
            conList.Add(Con);
        }
        if(conList.size() > 0){
            Database.update(conList, false);
        }
    }
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        
    }
}