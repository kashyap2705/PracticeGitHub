@isTest
private class CSMUpdateDraftArticlesBatchTest {
    @isTest
    static void testBatchExecution() {
        
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
        
        Knowledge__kav knowledgeArticle = new Knowledge__kav(
            Title = 'Sample Article',
            Language = 'en_US',
            FAQ_Answers_Question__c = 'Sample Question',
            UrlName='SampleArticle'
        );
        insert knowledgeArticle;     
        knowledge__kav article = [SELECT Id,Title,KnowledgeArticleId,MasterVersionId FROM knowledge__kav WHERE id =: knowledgeArticle.Id];
        
        System.runAs(sysAdmUser) {
            if(article!=null){
                KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);                 
            }
        }
        Test.startTest();
        // Start the batch job
        System.runAs(sysAdmUser) {
            Database.executeBatch(new CSMUpdateDraftArticlesBatch());
        }
        Test.stopTest();
        
        Knowledge__kav updatedDraftArticle = [SELECT Id, KnowledgeArticleId, FAQ_Answers_Staff_Notes__c FROM Knowledge__kav WHERE KnowledgeArticleId = :article.KnowledgeArticleId and PublishStatus='draft'];
        System.assertNotEquals(null, updatedDraftArticle, 'Draft article not updated');
        System.assertEquals(article.MasterVersionId, updatedDraftArticle.FAQ_Answers_Staff_Notes__c, 'Draft article not updated correctly');
    }
}