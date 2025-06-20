/**
* @description       : Test class for IBAnswersArticleVoteController
* @author            : Mounika
* @group             : 
* @last modified on  : 02-14-2024
* @last modified by  : Mounika - coverage 86%
**/
@isTest
private class IBAnswersArticleVoteControllerTest {
    
    @TestSetup
    static void setupTestData() {
        Account acc = new Account(
            Name = 'test account',
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Lead_Account__c = true,
            website='http://www.ibo.org'
        );
        insert acc;
        
        Contact contactRecord = new Contact(FirstName = 'Test', LastName = 'Con', AccountId = acc.Id,Email ='test@email.com');
        insert contactRecord;
        
        List<Profile> ccAdvancedProfileId = [
            SELECT Id, Name
            FROM profile
            WHERE name = 'Customer Community Advanced'
        ];
        System.debug(ccAdvancedProfileId);
        
        User userRecord = new User(
            Alias = 'ibport' + 1,
            Email ='abc@gmail.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = contactRecord.FirstName,
            LastName = contactRecord.LastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ccAdvancedProfileId[0].Id,
            ContactId = contactRecord.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'first@lastname.com.test.' + Math.random(),
            UserPermissionsKnowledgeUser = true
        );
        
        insert userRecord;
        
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
    }    
    
    @isTest
    static void testInsertVote(){
        User userRecord = [
            SELECT id, email, Lastname
            FROM user
            WHERE Lastname = 'Con' AND email='abc@gmail.com' AND isActive=True LIMIT 1  
        ];
        List<Knowledge__kav> articles = [SELECT Id,knowledgeArticleId FROM Knowledge__kav LIMIT 1];
        String articleId;
        System.runAs(userRecord) {
            
            articleId = articles[0].knowledgeArticleId;
            String voteType = 'Up';           
            
            Test.startTest(); 
            ibAnswersArticleVoteController.insertVote(articleId, voteType);           
            Test.stopTest();
        }
       
        List<Vote> votes = [SELECT Id, Type, ParentId, CreatedById FROM Vote WHERE ParentId = :articleId LIMIT 1];
        System.assertEquals(1, votes.size(), 'Expected one vote record');
        Vote insertedVote = votes[0];
        System.assertEquals(articleId, insertedVote.ParentId, 'ParentId should match'); 
        String updatedVoteType = 'Down';
        ibAnswersArticleVoteController.insertVote(articleId, updatedVoteType);           
        
        
        // Verify the updated vote record
        List<Vote> updatedVotes = [SELECT Id, Type, ParentId, CreatedById FROM Vote WHERE ParentId = :articleId LIMIT 1];
        System.assertEquals(1, updatedVotes.size(), 'Expected one vote record');
        //System.assertEquals(updatedVoteType, updatedVotes[0].Type, 'Updated vote type should match');
        
        
    } 
    @isTest
    static void testCheckVote(){
        
        List<Knowledge__kav> articles = [SELECT Id,knowledgeArticleId FROM Knowledge__kav LIMIT 1];
        String articleId = articles[0].knowledgeArticleId;    
        
        Test.startTest();
        IBAnswersArticleVoteController.checkVote(articleId);       
        Test.stopTest(); 
        List<Vote> votes = [SELECT Id, Type, ParentId, CreatedById FROM Vote WHERE ParentId = :articleId LIMIT 1];
        System.assertEquals(0, votes.size(), 'No vote record');        
    } 
    @isTest
    static void testUpsertVote(){
        User userRecord = [
            SELECT id, Lastname
            FROM user
            WHERE Lastname = 'Con' AND email='abc@gmail.com' AND isActive=True LIMIT 1
        ];
        List<Knowledge__kav> articles = [SELECT Id,knowledgeArticleId FROM Knowledge__kav LIMIT 1];
        String articleId;
        System.runAs(userRecord) {
            articleId = articles[0].knowledgeArticleId;
            String initialVoteType = 'Up';           
            String updatedVoteType = 'Down'; 
            
            Test.startTest();          
            
            ibAnswersArticleVoteController.insertVote(articleId, initialVoteType); 
            
            List<Vote> initialVotes = [SELECT Id, Type, ParentId, CreatedById FROM Vote WHERE ParentId = :articleId LIMIT 1];
            System.assertEquals(1, initialVotes.size(), 'Expected one vote record');
            System.assertEquals(initialVoteType, initialVotes[0].Type, 'Initial vote type should match');
            
            ibAnswersArticleVoteController.insertVote(articleId, updatedVoteType);           
            Test.stopTest();
            List<Vote> updatedVotes = [SELECT Id, Type, ParentId, CreatedById FROM Vote WHERE ParentId = :articleId];
            System.assertEquals(1, updatedVotes.size(), 'Expected one vote record');
            //System.assertEquals(updatedVoteType, updatedVotes[0].Type, 'Vote type should be updated');
        }
    } 
}