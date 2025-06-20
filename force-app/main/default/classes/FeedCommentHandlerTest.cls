@isTest 
private class FeedCommentHandlerTest {
    static String internalUserEmail = 'AdminTest1234@test.com';
    static String externalUserEmail = 'exteralUser1234@test.com';
    static Id feedItemId;
    @testSetup
    static void makeData(){
        String accountName = 'test account name';
        String contactName = 'test contact name';
        
        
		Custom_Label_Project__c project = CustomProjectTestDataFactory.createProject(null);
		insert project;
        
        // Create CustomLabels
        List<CustomLabel__c> clList = new List<CustomLabel__c>();
        CustomLabel__c cl = new CustomLabel__c();
        cl.Label__c = 'view_case';
        cl.Group__c = 'FeedCommentHandler';
        cl.Project__c = project.Id;
		cl = CustomLabelTestDataFactory.createLabel(cl);
        clList.add(cl);
        
        CustomLabel__c cl2 = new CustomLabel__c();
        cl2.Label__c = 'comment_mention';
        cl2.Group__c = 'FeedCommentHandler';
        cl2.Project__c = project.Id;
		cl2 = CustomLabelTestDataFactory.createLabel(cl2);
        clList.add(cl2);
        
        CustomLabel__c cl3 = new CustomLabel__c();
        cl3.Label__c = 'comment_received';
        cl3.Group__c = 'FeedCommentHandler';
        cl3.Project__c = project.Id;
		cl3 = CustomLabelTestDataFactory.createLabel(cl3);
        clList.add(cl3);
        
        insert clList;
        
        // Create Translations
        List<Translation__c> tlList = new List<Translation__c>();
        for (Integer i = 0; i < clList.size(); i++) {
            Translation__c tl = new Translation__c();
            tl.Value__c = i == 0 ? 'view case' : (i == 1 ? 'comment mention' : 'comment received');
                tl.Language__c = 'American English';    
            tl.CustomLabel__c = clList[i].Id;
            tlList.add(tl);
        }
        
        insert tlList;
        
        Profile standardProfile = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'System Administrator'
            LIMIT 1
        ];
        
        Profile ccAdvancedProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'Customer Community Advanced'
            LIMIT 1
        ];
        
		
		Account testAccount = AccountTestDataFactory.createAccount(null,null);
        insert testAccount;

		User internalUser = UserTestDataFactory.createUser('System Administrator',null);
		internalUser.email = 'AdminTest1234@test.com';
        insert internalUser;
        
        Contact externalContact = ContactTestDataFactory.createContact(null,null);
		externalContact.AccountId = testAccount.Id;
		insert externalContact;
		
		
		User externalUser = UserTestDataFactory.createUser('Customer Community Advanced',null);
		externalUser.contactId = externalContact.id;
		externalUser.email = externalUserEmail;
		externalUser.IsActive = true;
        insert externalUser;
        
        externalContact.User__c = externalUser.Id;
        update externalContact;
        
        Id supportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Support').getRecordTypeId();
        Case testCase = new Case(
            Subject = 'Test Case',
            RecordTypeId = supportRecordTypeId,
            ContactId = externalContact.Id,
            OwnerId = internalUser.Id
        );
		
		system.debug('externalUser-->'+externalUser.IsActive);
        System.runas(externalUser){
            insert testCase;
        }
        
		FeedItem testFeedItem = new FeedItem(
			Body = 'Test FeedItem',
			ParentId = testCase.Id,
			Visibility = 'AllUsers'
		);
		insert testFeedItem;
    }
    
    @isTest
    static void testInsertFeedCommentStandard() {
        User internalUser = [select id,email from User where email = :internalUserEmail];
		system.debug('internalUser-->'+internalUser.email);
        FeedItem testFeedItem = [select Id from FeedItem LIMIT 1];
        Test.startTest();
            FeedComment testFeedComment = new FeedComment(
                FeedItemId = testFeedItem.Id,
                CommentBody = 'Test Comment'
            );
            insert testFeedComment;
        Test.stopTest();
    }
    
    @isTest
    static void testInsertFeedCommentPortal() {
        User communityUser = [SELECT id,email FROM user WHERE email =:externalUserEmail];
		system.debug('communityUser-->'+communityUser.email);
        FeedItem testFeedItem = [SELECT Id FROM FeedItem LIMIT 1];
        Case userCase = [SELECT Id, CaseNumber, Contact.User__r.Email, Contact.User__r.Id, Contact.User__r.LanguageLocaleKey,
                            Owner.Email, Owner.Id, RecordType.Name, Status, isClosed, Owner.FirstName, Subject
                         FROM Case LIMIT 1];
        
        FeedComment testFeedComment = new FeedComment(
            FeedItemId = testFeedItem.Id,
            CommentBody = 'Test Comment'
        );
        insert testFeedComment;
        
        System.runas(communityUser){
        	FeedCommentHandler.handleExpCloudComment(userCase, testFeedComment);
        }
    }
}