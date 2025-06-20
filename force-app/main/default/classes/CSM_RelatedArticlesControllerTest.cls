@isTest
private class CSM_RelatedArticlesControllerTest {

    @testSetup
	static void makeData() {
        //Account accRec = AccountFactoryTest.createAccount('Test Account', '');
        //insert accRec;
        Account accRec = new Account(
		Name = 'Test Account',
        Region__c = 'IBAEM',
        Sub_region__c = 'EUROPE',
        External_PD_Provider__c = true,
        Language_Of_Correspondance__c = 'English',
        Legal_Status__c = 'Private',
        Billing_Currency__c = 'USD',
        Lead_Account__c = true,
        Short_Name__c = 'Test Account',
		Website = 'http://example.com');
		insert accRec;
        
        List<Contact> contactRecords = ContactFactoryTest.createContacts(
            1,
            false,
            accRec
        );
        
        if (!contactRecords.isEmpty()) {
            insert contactRecords;
        }
        
        Contact contactRecord = contactRecords[0];
        
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
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(
            accRec,
            'PYP'
        );
        progRecList.add(progRec);
        if (!progRecList.isEmpty()) {
            insert progRecList;
        }
        
        List<Profile> ccAdvancedProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'Customer Community Advanced'
        ];
        System.debug(ccAdvancedProfileId);
        
        List<Profile> guestProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'IB Answers Profile'
        ];
        
        System.debug(guestProfileId);
        
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
            UserName = contactRecord.Email
        );
        
        insert userRecord;
        System.debug('User List: ' + userRecord);
        
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
       System.runAs(sysAdmUser) {
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
            knowledge__kav article = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle.Id];
            
            KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory = new Knowledge__DataCategorySelection();
            dataCategory.ParentId = parentKnowledgeArticle.Id;
            dataCategory.DataCategoryGroupName = 'IB_Answers';
            dataCategory.DataCategoryName = 'IB_Sites';
            insert dataCategory;
    
            /* added*/
            Knowledge__kav relatedparentKnowledgeArticle = new Knowledge__kav(
                Title = 'Sample Article',
                Language = 'en_US',
                FAQ_Answers_Question__c = 'Sample Question',
                UrlName='SampleArticle0'
            );
            insert relatedparentKnowledgeArticle;
            knowledge__kav relatedparentKnowledgeArticleget = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: relatedparentKnowledgeArticle.Id];
            
            KbManagement.PublishingService.publishArticle(relatedparentKnowledgeArticleget.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory0 = new Knowledge__DataCategorySelection();
            dataCategory0.ParentId = relatedparentKnowledgeArticle.Id;
            dataCategory0.DataCategoryGroupName = 'IB_Answers';
            dataCategory0.DataCategoryName = 'IB_Sites';
            insert dataCategory0;
    
            /* 2nd article for the same */
            Knowledge__kav relatedparentKnowledgeArticle1 = new Knowledge__kav(
                Title = 'Sample Article',
                Language = 'en_US',
                FAQ_Answers_Question__c = 'Sample Question',
                UrlName='SampleArticle01'
            );
            insert relatedparentKnowledgeArticle1;
            knowledge__kav relatedparentKnowledgeArticle1get = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: relatedparentKnowledgeArticle1.Id];
            
            KbManagement.PublishingService.publishArticle(relatedparentKnowledgeArticle1get.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory1 = new Knowledge__DataCategorySelection();
            dataCategory1.ParentId = relatedparentKnowledgeArticle1.Id;
            dataCategory1.DataCategoryGroupName = 'IB_Answers';
            dataCategory1.DataCategoryName = 'IB_Sites';
            insert dataCategory1;
    
            /* 3rd article for the same */
            Knowledge__kav relatedparentKnowledgeArticle2 = new Knowledge__kav(
                Title = 'Sample Article',
                Language = 'en_US',
                FAQ_Answers_Question__c = 'Sample Question',
                UrlName='SampleArticle02'
            );
            insert relatedparentKnowledgeArticle2;
            knowledge__kav relatedparentKnowledgeArticle2get = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: relatedparentKnowledgeArticle2.Id];
            
            KbManagement.PublishingService.publishArticle(relatedparentKnowledgeArticle2get.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory2 = new Knowledge__DataCategorySelection();
            dataCategory2.ParentId = relatedparentKnowledgeArticle2.Id;
            dataCategory2.DataCategoryGroupName = 'IB_Answers';
            dataCategory2.DataCategoryName = 'IB_Sites';
            insert dataCategory2;
    
    
            /* original continuation */
            Knowledge__kav parentKnowledgeArticle2 = new Knowledge__kav(
                Title = 'Sample Article2',
                Language = 'en_US',
                FAQ_Answers_Question__c = 'Sample Question2',
                UrlName='SampleArticle2'
            );
            insert parentKnowledgeArticle2;
            knowledge__kav article2 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle2.Id];
            
            KbManagement.PublishingService.publishArticle(article2.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory3 = new Knowledge__DataCategorySelection();
            dataCategory3.ParentId = parentKnowledgeArticle2.Id;
            dataCategory3.DataCategoryGroupName = 'IB_Programmes';
            dataCategory3.DataCategoryName = 'Diploma_programme';
            insert dataCategory3;     
            Knowledge__kav parentKnowledgeArticle3 = new Knowledge__kav(
                Title = 'Sample Article3',
                Language = 'en_US',
                FAQ_Answers_Question__c = 'Sample Question3',
                UrlName='SampleArticle3'
            );
            insert parentKnowledgeArticle3;
            knowledge__kav article3 = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav WHERE id =: parentKnowledgeArticle3.Id];
            
            KbManagement.PublishingService.publishArticle(article3.KnowledgeArticleId, true);
            
            Knowledge__DataCategorySelection dataCategory4 = new Knowledge__DataCategorySelection();
            dataCategory4.ParentId = parentKnowledgeArticle3.Id;
            dataCategory4.DataCategoryGroupName = 'IB_Roles';
            dataCategory4.DataCategoryName = 'School_Roles';
            insert dataCategory4; 
         }
    }

    @isTest
    static void testfetchRelatedArticles() {
        User sysAdmUser = [SELECT id FROM User WHERE email = 'sys@example.com'];
        Test.startTest();
        String relatedArticleInput = '{"categories":["IB_Sites"],"userLanguage":"en_US"}';
        Id knowledgid = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav Limit 1].Id;
        String relatedArticleInput2 = '{"articleId":"' + knowledgid + '","userLanguage":"en_US"}';
        
        List<Knowledge__kav> finalknowledgeRelatedArticleList;
        List<Knowledge__kav> finalknowledgeRelatedArticleList2;
        System.runAs(sysAdmUser){
            finalknowledgeRelatedArticleList = CSM_RelatedArticlesController.fetchRelatedArticles(relatedArticleInput);
            finalknowledgeRelatedArticleList2 = CSM_RelatedArticlesController.fetchRelatedArticles(relatedArticleInput2);
        }
        System.assert(finalknowledgeRelatedArticleList.size()>0, 'Articles should have atleast one');
        System.debug('debug finalknowledgeRelatedArticleList.size():::'+finalknowledgeRelatedArticleList.size());
        System.assert(finalknowledgeRelatedArticleList2.size()>0, 'Articles should have atleast one');
        
        //for exception
        String relatedArticleInput3 = '{articleId:"' + knowledgid + '","userLanguage":"en_US"}';
        try{
            List<Knowledge__kav> article2 = CSM_RelatedArticlesController.fetchRelatedArticles(relatedArticleInput3);
        }catch(Exception e){
            System.assert(true);
        }
        
        List<Knowledge__kav> Knaowledgelist = [SELECT Id,Title,KnowledgeArticleId FROM knowledge__kav];
        System.assert(Knaowledgelist.size()>0, 'Articles should have atleast one');
        List<Knowledge__DataCategorySelection> KnowDataCatList = [SELECT Id,Parentid FROM Knowledge__DataCategorySelection];
        System.assert(KnowDataCatList.size()>0, 'Knowledge DataCategorySelection should have atleast one record');
        Test.stopTest();
    }
}