/*

* @author : oleg, CoastalCloud.us
* @date : 1/8/2016
* @description: CR 3803 (5) Weekly Email Digest of New Assignments
*
* © Copyright 2011 - 2016 CoastalCloud, Inc.  All Rights Reserved.
* 

*/

global class IBAssignmentDigestBatch implements Database.Batchable<sObject> {
    
    String query;
    
    global IBAssignmentDigestBatch() {
        //query = 'SELECT Id, ContactId, Contact.IB_Region__c, Contact.Email, Contact.FirstName, Contact.Language_of_Correspondence__c, Contact.Alternative_Email__c, Contact.Preferred_Communication_Method__c  FROM User WHERE isActive = true AND UserType=\'PowerPartner\' AND ContactId != null';
        query = 'SELECT Id, ContactId, Contact.IB_Region__c, Contact.Email, Contact.FirstName, Contact.Language_of_Correspondence__c, Contact.Alternative_Email__c, Contact.Preferred_Communication_Method__c  FROM User WHERE isActive = true AND ContactId != null';
        if (Test.isRunningTest())
            query += ' AND Email = \'t@t.com\' LIMIT 100';
        
        System.debug(LoggingLevel.INFO, 'query - \n' + query);
    }

    global IBAssignmentDigestBatch(String query) {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List <User> scope) {
        IBAssignmentDigestUtil.processUserAssignments(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        System.debug(LoggingLevel.INFO, 'IBAssignmentDigestBatch completed');
    }
    
}