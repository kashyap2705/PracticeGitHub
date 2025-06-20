@isTest
private class CSM_ArticleDetailControllerTest {
    @testSetup
	static void makeData() {
        String testemail = 'kttest@test.com123';

        Profile scuProfile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];

        User adminUser = new User(
            profileId = scuProfile.id,
            username = testemail,
            email = testemail,
            emailencodingkey = 'UTF-8',
            languagelocalekey = 'en_US',
            localesidkey = 'en_US',
            timezonesidkey = 'America/Los_Angeles',
            alias = 'cspu',
            lastname = 'lastname',
            UserPermissionsKnowledgeUser = true
        );
        insert adminUser;
        
        Knowledge__kav knowledgeArticle = new Knowledge__kav(
            Title = 'Sample Article',
            Language = 'en_US',
            FAQ_Answers_Question__c = 'Sample Question',
            UrlName='SampleArticle'
        );
        insert knowledgeArticle;

    }

    @isTest
    static void getArticleDetailTest() {
        knowledge__kav article1;
        User u = [SELECT id FROM User WHERE email = 'kttest@test.com123'];
        knowledge__kav insertedArticleID = [SELECT Id,Title,KnowledgeArticleId,FAQ_Answers_Question__c FROM knowledge__kav LIMIT 1 ];
        System.debug('Article ID Tharun' +insertedArticleID.id);
        try{
            Knowledge__kav article2 = CSM_ArticleDetailController.getArticleDetail(insertedArticleID.Id);
            System.assert(false,'should have thrown an exception');
        }catch(Exception e){
            System.assert(true);
        }
        System.runAs(u){
        KbManagement.PublishingService.publishArticle(insertedArticleID.KnowledgeArticleId, true);
        }
        Test.startTest();
        System.runAs(u){
             article1 = CSM_ArticleDetailController.getArticleDetail(insertedArticleID.Id);
        }
        Test.stopTest();
        System.assertEquals(insertedArticleID.FAQ_Answers_Question__c, article1.FAQ_Answers_Question__c, 'Question is not matching');
    }
    
}