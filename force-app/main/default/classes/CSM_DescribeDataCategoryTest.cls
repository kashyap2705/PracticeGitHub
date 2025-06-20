/**
* @description       : Test class for CSM_DescribeDataCategoryGroupStructures
* @author            : Mounika
* @last modified on  : 03-22-2024
* @last modified by  : Mounika
* @code coverage	  : 82% (172/209)
**/
@isTest
private class CSM_DescribeDataCategoryTest {
    
    @TestSetup
    static void setupTestData() {
        String roleName = 'Head of School';
        String accountName = 'test account name';
        String contactName = 'test contact name';
        String testemail = 'testgck123@test.com'; 
        
		Account accRec = AccountTestDataFactory.createAccount(null,null);
		accRec.Name = accountName;
        accRec.Language_Of_Correspondance__c = 'English';
        accRec.Legal_Status__c = 'Private';
        accRec.Lead_Account__c = true;
        insert accRec;
		
		Contact contactRecord = ContactTestDataFactory.createContact(null,null);
		contactRecord.AccountId = accRec.Id;
		contactRecord.Salutation = 'Mr.';
        contactRecord.LastName = contactName;
        contactRecord.FirstName = contactName;
        contactRecord.Email = testemail;
		insert contactRecord;
		
		
        
       
		
        IB_Country_Segmentation__c country2 = RoleRepoFactoryTest.createCountry(
            false,
            accRec
        );
        insert country2;
        
        List<IB_Address__c> addresRec = RoleRepoFactoryTest.createAddress(
            3,
            country2.id,
            accRec,
            false
        );
        
        if (!addresRec.isEmpty()) {
            insert addresRec;
        }
        

        IB_Role_Repository__c headOfSchool = RoleRepoFactoryTest.createRepoRecord(false,roleName);
        headOfSchool.Available__c = true;
        headOfSchool.Role_Level__c = 'Fully Qualified;';
        headOfSchool.Category__c = 'Learning Centre';
        headOfSchool.Related_Programmes__c = 'PYP;MYP;DP;IBCC';
        insert headOfSchool;
        IB_Role__c headOfSchoolRole = RoleRepoFactoryTest.createIbRole( headOfSchool.Id,contactRecord.Id,accRec.Id);
        insert headOfSchoolRole;
        
        List<Profile> ccAdvancedProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'Customer Community Advanced'
        ];
        
        List<Profile> guestProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'IB Answers Profile'
        ];
        
        
        User userRecord = new User(
            Alias = 'ibport' + 1,
            Email = contactRecord.Email,
            EmailEncodingKey = 'UTF-8',
            FirstName = contactRecord.FirstName,
            LastName = contactRecord.LastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ccAdvancedProfileId[0].Id,
            ContactId = contactRecord.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = contactRecord.Email,
            UserPermissionsKnowledgeUser = true
        );
        insert userRecord;



        User guestUserRecord = new User(
            Alias = 'guest',
            Email = 'guest@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Guest',
            FirstName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            ProfileId = guestProfileId[0].Id,
            Username = 'guest@example.com'            
        );       
        
        insert guestUserRecord;
        Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User sysAdmUser = new User(
            ProfileId = sysAdminProfile.Id,
            Username = 'sysadm@example.com',
            Email = 'sys@example.com',
            LastName = 'Test',
            FirstName = 'User',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            UserPermissionsKnowledgeUser = true
            
        );
        insert sysAdmUser;
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(
            accRec,
            'PYP'
        );
        progRec.Programme_Decision_Owner__c = sysAdmUser.id;
        progRecList.add(progRec);
        if (!progRecList.isEmpty()) {
            insert progRecList;
        }
        Category1__c category1Record = new Category1__c(
            Name = 'IB_Sites',
            French_Name__c='IB Sites fr',
            Spanish_Name__c='IB Sites en',
            Label__c='IB Sites'         
        );
        insert category1Record;
        
        Category2__c category2Record = new Category2__c(
            Name = 'My_IB',
            French_Name__c='My IB fr',
            Spanish_Name__c='My IB en',
            Label__c='My IB'  
        );
        insert category2Record;
        
        Category1_2_Mapping__c catagory12MappingRecord = new Category1_2_Mapping__c(
            Category1__c = category1Record.Id, 
            Category2__c = category2Record.Id,
            IB_Roles__c='Parents_candidates_and_alumni',
            IB_Programme__c='DP'           
        );
        insert catagory12MappingRecord;
        
        Category3__c category3Record = new Category3__c(
            Name = 'Account_Creation',
            French_Name__c='Account Creation fr',
            Spanish_Name__c='Account Creation en',
            Label__c='Account Creation'  
        );
        insert category3Record;
        
        Category2_3_Mapping__c catagory23MappingRecord = new Category2_3_Mapping__c(
            Category2__c = category2Record.Id, 
            Category3__c = category3Record.Id,
            IB_Roles__c='Parents_candidates_and_alumni',
            IB_Programme__c='DP'          
        );
        insert catagory23MappingRecord;
        
        Knowledge__kav parentKnowledgeArticle = new Knowledge__kav(
            Title = 'Sample Article',
            Language = 'en_US',
            FAQ_Answers_Question__c = 'Sample Question',
            UrlName='SampleArticle'
        );
        insert parentKnowledgeArticle;
        
        Knowledge__kav parentKnowledgeArticlefr = new Knowledge__kav(
            Title = 'Sample Article fr',
            Language = 'fr',
            FAQ_Answers_Question__c = 'Sample Question',
            UrlName='SampleArticlefr'
        );
        insert parentKnowledgeArticlefr;
        
        knowledge__kav article = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle.Id];
        
        System.runAs(sysAdmUser) {
            KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
        }
        
        Knowledge__DataCategorySelection dataCategory = new Knowledge__DataCategorySelection();
        dataCategory.ParentId = parentKnowledgeArticle.Id;
        dataCategory.DataCategoryGroupName = 'IB_Answers';
        dataCategory.DataCategoryName = 'IB_Sites';
        insert dataCategory;
        
        Knowledge__kav parentKnowledgeArticle2 = new Knowledge__kav(
            Title = 'Sample Article2',
            Language = 'en_US',
            FAQ_Answers_Question__c = 'Sample Question2',
            UrlName='SampleArticle2'
        );
        insert parentKnowledgeArticle2;
        
        knowledge__kav article2 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle2.Id];
        
        System.runAs(sysAdmUser) {
            KbManagement.PublishingService.publishArticle(article2.KnowledgeArticleId, true);
        }
        
        Knowledge__DataCategorySelection dataCategory2 = new Knowledge__DataCategorySelection();
        dataCategory2.ParentId = parentKnowledgeArticle2.Id;
        dataCategory2.DataCategoryGroupName = 'IB_Programmes';
        dataCategory2.DataCategoryName = 'Diploma_programme';
        insert dataCategory2; 
        
        Knowledge__kav parentKnowledgeArticle3 = new Knowledge__kav(
            Title = 'Sample Article3',
            Language = 'en_US',
            FAQ_Answers_Question__c = 'Sample Question3',
            UrlName='SampleArticle3'
        );
        insert parentKnowledgeArticle3;
        
        knowledge__kav article3 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle3.Id];
        
        System.runAs(sysAdmUser) {
            KbManagement.PublishingService.publishArticle(article3.KnowledgeArticleId, true);
        }
        
        Knowledge__DataCategorySelection dataCategory3 = new Knowledge__DataCategorySelection();
        dataCategory3.ParentId = parentKnowledgeArticle3.Id;
        dataCategory3.DataCategoryGroupName = 'IB_Roles';
        dataCategory3.DataCategoryName = 'School_Roles';
        insert dataCategory3;  
        
    }
    @isTest
    static void testDataCategoryGroupStructureforGuest() {
        User insertedGuestUser = [SELECT Id, Username,profile.Name,LanguageLocaleKey FROM User WHERE Email = 'guest@example.com' LIMIT 1];
        System.assertEquals('guest@example.com', insertedGuestUser.Username,'User Name should match');       
        Test.startTest();        
        CSM_DescribeDataCategoryGroupStructures.getDataCategoryGroupStructure(true,insertedGuestUser.Id,insertedGuestUser.LanguageLocaleKey);
        Test.stopTest();
    }
    @isTest
    static void testDataCategoryGroupStructureforAU() {
        User insertedAUUser = [SELECT Id, Username,profile.Name,LanguageLocaleKey FROM User WHERE 
                               username = 'testgck123@test.com'
                               and profile.Name = 'Customer Community Advanced' LIMIT 1];
        System.assertEquals('Customer Community Advanced', insertedAUUser.profile.Name,'User Profile should match');    
        Test.startTest();
        system.runAs(insertedAUUser){
            CSM_DescribeDataCategoryGroupStructures.getDataCategoryGroupStructure(false,insertedAUUser.Id,insertedAUUser.LanguageLocaleKey);
        }
        Test.stopTest();
    }
}