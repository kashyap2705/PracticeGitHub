@IsTest
public class CSM_MycaseviewcontrollerTest {
	@testSetup
    static void setupTestData() {
        String accountName = 'test account name';
        String contactName = 'test contact name';
        String testemail = 'testgck123@test.com';

        Profile scuProfile = [SELECT Id FROM profile WHERE Name = 'SCU + Advanced' LIMIT 1];

        Account testAccount = new Account(
            Name = accountName,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'public',
            Lead_Account__c = true,
            website = 'www.google.com'
        );
        insert testAccount;

        Contact testContact = new Contact(
            Salutation = 'Mr.',
            LastName = contactName,
            FirstName = contactName,
            Email = testemail,
            AccountId = testAccount.Id
        );
        insert testContact;

        User portalUser = new User(
            profileId = scuProfile.id,
            username = testemail,
            email = testemail,
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias = 'cspu',
            lastname = 'lastname',
            contactId = testContact.id
        );
        insert portalUser;

        testContact.User__c = portalUser.Id;
        update testContact;
    }
    @IsTest
    public static void getAttachmentsTest() {
        Account cs = [select id from Account limit 1];
        CSM_Mycaseviewcontroller.getAttachments(cs.Id);
    }
        
  @isTest
    static void testGetUserRolesMap() {
        // Create test data
        IB_Role_Repository__c testRole = new IB_Role_Repository__c(
            Available__c = true,
            Role_Level__c = 'Fully Qualified;',
            Category__c = 'Learning Centre',
            Role_Name__c = 'TestRole',
			Related_Programmes__c = 'PYP;MYP;DP;IBCC'
        );
        insert testRole;
		// Call the method to be tested
        Test.startTest();
        IB_Role_Repository__c resultRole = CSM_Mycaseviewcontroller.getUserRolesMap('TestRole');
        Test.stopTest();
    }
    
}