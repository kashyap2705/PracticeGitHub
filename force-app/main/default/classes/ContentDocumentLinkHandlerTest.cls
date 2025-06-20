@isTest
public class ContentDocumentLinkHandlerTest {
    
    @testSetup
    static void setup() {
        Podcast_Episode__c episode = PodcastEpisodeTestDataFactory.createPodcastEpisode('', null);
        episode.Publish_Date__c = System.today();
        episode.Is_Published__c = true;
        insert episode;
    }
    
    @isTest
    static void testHandleAfterInsert() {
        
        Podcast_Episode__c tempEpisode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        
        Test.startTest();
        
        ContentVersion contentVersion = new ContentVersion(
            Title           = 'IBCF',
        PathOnClient    = 'Pic.jpg',
        VersionData     = Blob.valueOf('Test Content'),
        IsMajorVersion  = true,
        FirstPublishLocationId = tempEpisode.Id
            );
        insert contentVersion;
        
        Test.stopTest();
        
        Podcast_Episode__c episode = [SELECT Id, Video_File__c FROM Podcast_Episode__c LIMIT 1];
        
        ContentVersion cd = [SELECT Id, ContentDocumentId FROM ContentVersion LIMIT 1];
        
        System.assertEquals(cd.ContentDocumentId, episode.Video_File__c);
    }
}