global class UpdateContactRecTypeBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global string batchQuery;
    
    // Constructor for query input
    global UpdateContactRecTypeBatch(String batchQuery){
        this.batchQuery = batchQuery;
    }
    
    // Constructor for all contacts
    global UpdateContactRecTypeBatch(){
    }
    
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        if(batchQuery==null){
            if(!Test.isRunningTest()){
                return Database.getQueryLocator('Select id, IB_Role_Name__c, IB_Contact__r.RecordType.Name, CreatedDate, CreatedBy.Name , IB_Contact__r.Name, IB_Contact__r.Email, IB_Contact__r.Id  from IB_Role__c where Status__c =\'Confirmed\' and IB_Contact__r.RecordType.Name =\'Invited Contact\'');
            } else {
                return Database.getQueryLocator('Select id, IB_Role_Name__c, IB_Contact__r.RecordType.Name, CreatedDate, CreatedBy.Name , IB_Contact__r.Name, IB_Contact__r.Email, IB_Contact__r.Id  from IB_Role__c where Status__c =\'Confirmed\' and IB_Contact__r.RecordType.Name =\'Invited Contact\' LIMIT 200');
            }
        } else {
            return Database.getQueryLocator(batchQuery);
        }
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<IB_Role__c> scope) {
        RecordType standardRecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Standard_Contact'];
        List<Contact> conList = new List<Contact>();

        for(IB_Role__c r : scope){
            Contact con = new Contact(Id = r.IB_Contact__c, RecordTypeId = standardRecType.Id);
            if(!conList.contains(con)){
                conList.Add(Con);
            }
        }
        if(conList.size() > 0){
            Database.update(conList, false);
        }
    }
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        
    }
}