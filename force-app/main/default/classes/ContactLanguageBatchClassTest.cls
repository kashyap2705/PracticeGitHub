@isTest
private class ContactLanguageBatchClassTest {
    
    private static final String SCHOOL_NAME = 'ThatThereSchool';
    private static final String ACCOUNT_TYPE = 'School Account';
    private static final String PROFILE_NAME = 'School Community User';
    private static final Integer LEAD_COUNT = 1;
    
    @TestSetup
    static void setupTestData() {
        
        Account testAccount = AccountTestDataFactory.createAccount(ACCOUNT_TYPE, null);
        testAccount.Name = SCHOOL_NAME;
        testAccount.Lead_Account__c = true;
        insert testAccount;
        
        Contact tempContact = new Contact(
            FirstName = 'Robert',
            LastName = 'Strunk',
            Email = 'rs@profEmail.com',
            Birthdate = Date.newInstance(1984, 09, 14),
            AccountId = testAccount.Id
        );
        Contact testContact = ContactTestDataFactory.createContact(null, tempContact);
        insert testContact;
        
        User tempUser = new User(
            LastName = 'lastname',
            Email = 'rs@email.com',
            Username = 'rs@em558861ail.com',
            ContactId = testContact.Id,
            isActive = true
        );
        
        User communityUser = UserTestDataFactory.createUser(PROFILE_NAME,tempUser);
        insert communityUser;
    }
    
    @isTest
    static void testBatchProcessing() {
        
        User testUser = [SELECT Id FROM User WHERE Username = 'rs@em558861ail.com' AND isActive = true LIMIT 1];
        
        Lead tempLead = new Lead(
            Company = 'Test Lead',
            Legal_Status__c = 'Private',
            Position_with_School__c = 'Other',
            OwnerId = testUser.Id,
            IsConverted = false,
            Status = 'Open',
            Development_Manager__c = null,
            PYP_Interest__c = true
        );
        
        Test.startTest();
        
        List<Lead> leadList = LeadTestDataFactory.createLeads(tempLead, LEAD_COUNT);
        for (Integer i = 0; i < leadList.size(); i++) {
            leadList[i].Email = 'tuser15' + i + '@salesforce.com';
            leadList[i].FirstName = 'John' + i;
            leadList[i].LastName = 'Doe' + i;
        }
        insert leadList;
        
        Test.stopTest();
        ContactLanguageBatchClass batch = new ContactLanguageBatchClass();
        Id batchId = Database.executeBatch(batch);
        
        List<Lead> processedLeads = [SELECT Id, OwnerId, Status, Development_Manager__c 
                                     FROM Lead 
                                     WHERE OwnerId = :testUser.Id];
        System.assertEquals(LEAD_COUNT, processedLeads.size(), 'Should have processed all test leads');
        for (Lead lead : processedLeads) {
            System.assertEquals('Open', lead.Status, 'Lead status should remain Open');
            System.assertEquals(testUser.Id, lead.OwnerId, 'Lead should be owned by test user');
        }
    }
}