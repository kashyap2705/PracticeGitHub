@isTest
public class CheckAccountNameTest {

    @isTest
    static void testAccountTrigger() {
        
        Account acc = PimsTestUtil.createAccount('Test Class Account', '');
        insert acc;
        
        acc.name ='Updated account name';
        acc.website = 'www.testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest.com';
        update acc;
        
        AccountService.setAccountId(acc.Id);
        Account testGetAccount = AccountService.getAccount();
        
        IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
        acc.name ='Second Update';
        update acc;
        System.assert(testGetAccount != null);
        
    }
    @isTest
    static void testAccountWithProg() {
        
        Account acc = PimsTestUtil.createAccount('Test Class Account', '');
        insert acc;
        
        AccountService.setAccountId(acc.Id);
        Account testGetAccount = AccountService.getAccount();
        
        IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
		insert programme;
        acc.name ='Second Update';
		test.startTest();
        update acc;
		test.stopTest();
        System.assert(testGetAccount != null);
        
    }
    @isTest
    static void testAccountWithEvent() {
        
        Account acc = PimsTestUtil.createAccount('Test Class Account', '');
        insert acc;
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
		Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp1.Id, recordTypeId);
        camp1.Bundle__c = false;
        insert camp1;
        acc.name ='Second Update';
		test.startTest();
        update acc;
		test.stopTest();
        
    }
}