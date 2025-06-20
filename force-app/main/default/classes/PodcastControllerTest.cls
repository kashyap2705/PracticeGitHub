@isTest
public class PodcastControllerTest {
    
    @testSetup
    static void setup() {
        // Create test data
        Podcast_Episode__c episode = PodcastEpisodeTestDataFactory.createPodcastEpisode('', null);
        episode.Publish_Date__c = System.today();
        episode.Is_Published__c = true;
        insert episode;
        
        ContentVersion contentVersion = new ContentVersion(
            Title           = 'IBCF',
        PathOnClient    = 'Pic.jpg',
        VersionData     = Blob.valueOf('Test Content'),
        IsMajorVersion  = true,
        FirstPublishLocationId = episode.Id
            );
        insert contentVersion;
    }
    
    @isTest
    static void testGetVideoDownloadPath() {
        Podcast_Episode__c episode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        
        Test.startTest();
        String path = PodcastController.getVideoDownloadPath(episode.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, path);
        System.assert(path.contains('/sfc/servlet.shepherd/version/download/'));
    }
    
    @isTest
    static void testMarkEpisodeAsViewed() {
        Podcast_Episode__c episode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        
        Test.startTest();
        PodcastController.markEpisodeAsViewed(episode.Id);
        Test.stopTest();
        
        Podcast_View__c view = [SELECT Id FROM Podcast_View__c WHERE Episode__c = :episode.Id LIMIT 1];
        System.assertNotEquals(null, view);
    }
    
    @isTest
    static void testGetLatestUnviewedEpisode() {
        Podcast_Episode__c episode = [SELECT Id, Name FROM Podcast_Episode__c LIMIT 1];
        
        Test.startTest();
        Map<String, String> result = PodcastController.getLatestUnviewedEpisode();
        Test.stopTest();
        
        System.assertNotEquals(null, result);
        System.assertEquals(episode.Id, result.get('Id'));
        System.assertEquals(episode.Name, result.get('Name'));
    }
    
    @isTest
    static void testMarkSegmentWatched() {
        Podcast_Episode__c episode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        Podcast_View__c view = new Podcast_View__c(Episode__c = episode.Id);
        insert view;
        
        Test.startTest();
        PodcastController.markSegmentWatched(episode.Id, 'start');
        Test.stopTest();
        
        view = [SELECT Watched_Start__c FROM Podcast_View__c WHERE Episode__c = :episode.Id LIMIT 1];
        System.assertEquals(true, view.Watched_Start__c);
    }
    
    @isTest
    static void testMarkSegmentWatched2() {
        Podcast_Episode__c episode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        Podcast_View__c view = new Podcast_View__c(Episode__c = episode.Id);
        insert view;
        
        Test.startTest();
        PodcastController.markSegmentWatched(episode.Id, 'middle');
        Test.stopTest();
        
        view = [SELECT Watched_Middle__c FROM Podcast_View__c WHERE Episode__c = :episode.Id LIMIT 1];
        System.assertEquals(true, view.Watched_Middle__c);
    }
    
    @isTest
    static void testMarkSegmentWatched3() {
        Podcast_Episode__c episode = [SELECT Id FROM Podcast_Episode__c LIMIT 1];
        Podcast_View__c view = new Podcast_View__c(Episode__c = episode.Id);
        insert view;
        
        Test.startTest();
        PodcastController.markSegmentWatched(episode.Id, 'end');
        Test.stopTest();
        
        view = [SELECT Watched_End__c FROM Podcast_View__c WHERE Episode__c = :episode.Id LIMIT 1];
        System.assertEquals(true, view.Watched_End__c);
    }
}