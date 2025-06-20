@isTest
private class UpdateInstituteAccountsTest {
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i,IBIS_ID__c='N00000'+i,Maximum_Transcript_Users__c = '5', billingcity='New York', billingcountrycode='US',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB Institute').getRecordTypeId()));
        }
        insert accounts;
        
    }
    @isTest static void test() {
        Test.startTest();
        UpdateInstituteAccounts uia = new UpdateInstituteAccounts();
        Id batchId = Database.executeBatch(uia);
        Test.stopTest();
        
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Account where Maximum_Transcript_Users__c = '10']);
    }
}