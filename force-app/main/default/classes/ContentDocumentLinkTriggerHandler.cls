public class ContentDocumentLinkTriggerHandler {
    public static void handleAfterInsert(List<ContentDocumentLink> newLinks) {
        if (newLinks == null || newLinks.isEmpty()) return;
        
        Set<Id> episodeIds = new Set<Id>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType podcastEpisodeType = globalDescribe.get('Podcast_Episode__c');
        
        for (ContentDocumentLink link : newLinks) {
            if (link.LinkedEntityId == null) continue;
            
            Schema.SObjectType linkedType = Id.valueOf(link.LinkedEntityId).getSObjectType();
            if (linkedType == podcastEpisodeType) {
                episodeIds.add(link.LinkedEntityId);
            }
        }
        
        System.debug('Episode IDs: ' + episodeIds);
        
        if (episodeIds.isEmpty()) return;
        
        // Query latest ContentVersion per episode
        List<ContentVersion> latestVersions = [
            SELECT ContentDocumentId, CreatedDate, FirstPublishLocationId
            FROM ContentVersion
            WHERE FirstPublishLocationId IN :episodeIds
            ORDER BY CreatedDate DESC
        ];
        
        System.debug('Latest Versions: ' + latestVersions);
        
        Map<Id, ContentVersion> latestPerEpisode = new Map<Id, ContentVersion>();
        
        for (ContentVersion cv : latestVersions) {
            Id episodeId = cv.FirstPublishLocationId;
            
            if (!latestPerEpisode.containsKey(episodeId)) {
                latestPerEpisode.put(episodeId, cv);
            }
        }
        
        List<Podcast_Episode__c> updates = new List<Podcast_Episode__c>();
        
        for (Id episodeId : latestPerEpisode.keySet()) {
            updates.add(new Podcast_Episode__c(
                Id = episodeId,
                Video_File__c = latestPerEpisode.get(episodeId).ContentDocumentId
            ));
        }
        
        System.debug('Updates: ' + updates);
        
        if (!updates.isEmpty()) {
            update updates;
        }
    }
}