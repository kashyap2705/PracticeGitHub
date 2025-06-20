@isTest
public class AccountTestDataFactory_Test {
	@isTest
    static void testDataSingle(){
        Account acc = AccountTestDataFactory.createAccount('School Account',null);
        insert acc;
        System.assert([SELECT Id FROM Account].size() == 1);
    }
    @isTest
    static void testDataBulk(){
        List<Account> accList = AccountTestDataFactory.createAccounts('School Account',null,10);
        insert accList;
        System.assert([SELECT Id FROM Account].size() == 10);
    }
    @isTest
    static void testIllegalRecordTypeName(){
        Account acc = AccountTestDataFactory.createAccount('Invalid RecordType',null);
        insert acc;
        System.assert([SELECT Id FROM Account].size() == 1);
    }
}