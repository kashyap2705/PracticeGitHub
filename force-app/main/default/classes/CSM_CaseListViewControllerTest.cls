/**
 * @description       : Test class for CSM_CaseListViewController
 * @author            : Charan Kumar
 * @last modified on  : 03-21-2024
 * @last modified by  : Charan Kumar
 * @code coverage	  : 85% (24/28)
**/
@isTest
public class CSM_CaseListViewControllerTest {
    @testSetup
    static void setupTestData() {
        String accountName = 'test account name';
        String contactName = 'test contact name';
        String testemail = 'testgck123@test.com';

        Profile scuProfile = [SELECT Id FROM profile WHERE Name = 'SCU + Advanced' LIMIT 1];


        Account testAccount = AccountTestDataFactory.createAccount(null,null);
		testAccount.Name = accountName;
        testAccount.Language_Of_Correspondance__c = 'English';
        testAccount.Legal_Status__c = 'Private';
        testAccount.Lead_Account__c = true;
        insert testAccount;
		
		Contact testContact = ContactTestDataFactory.createContact(null,null);
		testContact.AccountId = testAccount.Id;
		testContact.Salutation = 'Mr.';
        testContact.LastName = contactName;
        testContact.FirstName = contactName;
        testContact.Email = testemail;
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

        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
            .get(CSM_IboUtil.CASE_SUPPORT_RECORD_TYPE)
            .getRecordTypeId();


        Case c = CaseTestDataFactory.createCase(null,null);
        c.ContactId = testContact.Id;
        c.Status = 'Open';
        c.Origin = 'Phone';
        c.Subject = 'Test Case';
        c.Priority = 'Low';
        c.Description = 'Testing Change Request';
        c.RecordTypeId = recordTypeId;

        System.runAs(portalUser) {
            insert c;
        }
    }

    @isTest
    static void testCaseList() {
        User portalUser = [SELECT id FROM User WHERE email = 'testgck123@test.com'];
        System.runAs(portalUser) {
            Test.startTest();
            List<Case> caseList = CSM_CaseListViewController.getUserCases();
            Test.stopTest();
            System.assert(caseList.size() > 0, 'Case list size should be greater than 0');
        }
    }

    @isTest
    static void testGetCategories() {
        Category1__c category1 = new Category1__c(
            Name = 'Test Category 1',
            Label__c = 'Test Category 1',
            French_Name__c = 'Test Category French 1',
            Spanish_Name__c = 'Test Category Spanish 1'
        );
        insert category1;
        Test.startTest();
        Map<String, Category1__c> category1Map = CSM_CaseListViewController.getCategories();
        Test.stopTest();
        System.assertEquals(
            'Test Category French 1',
            category1Map.get('Test Category 1').French_Name__c,
            'French Name should be Test Category French 1'
        );
    }
}