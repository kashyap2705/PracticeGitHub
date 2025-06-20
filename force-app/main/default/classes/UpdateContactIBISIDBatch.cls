public class UpdateContactIBISIDBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext context) {
 
        String query = 'SELECT Id, IBIS_contact_ID__c FROM Contact WHERE IBIS_contact_ID__c = null';
        query += ' AND RecordType.Name = \'Invited Contact\'';
        query += ' AND Id IN (SELECT IB_Contact__c FROM IB_Role__c WHERE Status__c = \'Confirmed\')';
        if (!Test.isRunningTest()) {
            query += ' AND Id IN (SELECT ContactId FROM User WHERE LastLoginDate != null AND IsActive = true)';
        } else {
            query += ' AND Id IN (SELECT ContactId FROM User WHERE IsActive = true)';
    }
    
        query += ' LIMIT 9999';
        return Database.getQueryLocator(query);
    }
    
    
    public void execute(Database.BatchableContext context, List<Contact> contactsToUpdate) {
        List<Contact> updateList = new List<Contact>();
        ContactMaxIBCode__c cSetting = ContactMaxIBCode__c.getInstance('MaxContactIBCode');
        Integer maxCode;
        if(Test.isRunningTest()){
            maxCode = 100000;
        } else {
            maxCode = Integer.valueof(cSetting.MaxIBCode__c);
        }
        System.debug('maxCode:'+maxCode);
        
        for(Contact con: contactsToUpdate) {
            con.IBIS_contact_ID__c = String.valueof(maxCode);
            maxCode++;
            updateList.add(con);
        }
        
        System.debug('updateList.size(): '+updateList.size());
        if(updateList.size() > 0){
            try{ 
                System.debug('maxCode: '+maxCode);
                cSetting.MaxIBCode__c = maxCode;
                System.debug('cSetting.MaxIBCode__c: '+cSetting.MaxIBCode__c);
                update cSetting;
                update updateList;
            }catch(Exception e)
            {
                System.debug('Exception : ' + e.getMessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext context) {
        // Optional finishing tasks
    }
}