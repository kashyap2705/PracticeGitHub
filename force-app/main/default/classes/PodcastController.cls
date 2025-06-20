public without sharing class PodcastController {
    @AuraEnabled
    public static String getVideoDownloadPath(Id episodeId) {
        if (String.isBlank(episodeId)) {
            throw new AuraHandledException('Blank episode ID');
        }
        
        Podcast_Episode__c ep = [
            SELECT Video_File__c
            FROM Podcast_Episode__c
            WHERE Id = :episodeId
            LIMIT 1
        ];
        
        if (String.isBlank(ep.Video_File__c)) {
            throw new AuraHandledException('No video associated with this episode.');
        }
        
        ContentVersion cv = [
            SELECT Id
            FROM ContentVersion
            WHERE ContentDocumentId = :ep.Video_File__c
            ORDER BY VersionNumber DESC
            LIMIT 1
        ];
        
        return '/sfc/servlet.shepherd/version/download/' + cv.Id;
    }
    
    
    @AuraEnabled
    public static void markEpisodeAsViewed(Id episodeId) {
        if (!Test.isRunningTest() && String.isBlank(episodeId)) return;
        insert new Podcast_View__c(Episode__c = episodeId);
    }
    
    @AuraEnabled
    public static Map<String, String> getLatestUnviewedEpisode() {
        Date threeWeeksAgo = System.today().addDays(-21);
        
        // Get most recent published episode in the last 3 weeks
        List<Podcast_Episode__c> episodes = [
            SELECT Id, Name
            FROM Podcast_Episode__c
            WHERE Publish_Date__c >= :threeWeeksAgo AND
            Is_Published__c = true
            ORDER BY Publish_Date__c DESC
            LIMIT 1
        ];
        
        if (episodes.isEmpty()) return new Map<String, String>();
        
        Podcast_Episode__c latest = episodes[0];
        
        // Check if the current user has viewed it
        Integer views = [
            SELECT COUNT()
            FROM Podcast_View__c
            WHERE Episode__c = :latest.Id
            AND CreatedById = :UserInfo.getUserId()
        ];
        
        if (views == 0) {
            return new Map<String, String>{
                'Id' => latest.Id,
                'Name' => latest.Name
            };
        }
        
        return new Map<String, String>();
    }
    
    @AuraEnabled
    public static void markSegmentWatched(Id episodeId, String segment) {
        if (String.isBlank(episodeId) || String.isBlank(segment)) return;
        
        List<Podcast_View__c> views = [
            SELECT Id, Watched_Start__c, Watched_Middle__c, Watched_End__c
            FROM Podcast_View__c
            WHERE Episode__c = :episodeId AND CreatedById = :UserInfo.getUserId()
            LIMIT 1
        ];
        
        if (views.isEmpty()) return;
        
        Podcast_View__c view = views[0];
        
        switch on segment.toLowerCase() {
            when 'start' {
                view.Watched_Start__c = true;
            }
            when 'middle' {
                view.Watched_Middle__c = true;
            }
            when 'end' {
                view.Watched_End__c = true;
            }
            when else {
                return;
            }
        }
        
        update view;
    }
    
}