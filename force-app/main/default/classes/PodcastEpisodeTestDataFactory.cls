/*** This is used to Test the instance of List of Podcast Episodes*
 * @author: Alex Miller
 * @since 04-16-2025
 * @Modification Log:
 * Date            Created/Modified    Ticket           Description
 */
@isTest
public without sharing class PodcastEpisodeTestDataFactory {
    
    // Static cache for Record Type IDs
    private static Map<String, String> recordTypeIdCache = new Map<String, String>();
    
    public static List<Podcast_Episode__c> createPodcastEpisodes(String recordTypeName, Podcast_Episode__c tempPodcastEpisode, Integer nPodcastEpisodes) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        List<Podcast_Episode__c> podcastEpisodes = new List<Podcast_Episode__c>();
        for (Integer i = 0; i < nPodcastEpisodes; i++) {
            Podcast_Episode__c pod = (tempPodcastEpisode != null) ? tempPodcastEpisode.clone(false) : new Podcast_Episode__c();
            pod = createPodcastEpisodeInstance(pod, recordTypeId);
            podcastEpisodes.add(pod);
        }
        return podcastEpisodes;
    }
    
    public static Podcast_Episode__c createPodcastEpisode(String recordTypeName, Podcast_Episode__c tempPodcastEpisode) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        Podcast_Episode__c pod = (tempPodcastEpisode != null) ? tempPodcastEpisode.clone(false) : new Podcast_Episode__c();
        pod = createPodcastEpisodeInstance(pod, recordTypeId);
        return pod;
    }
    
    public static String getRecordTypeId(String recTypeName) {
        // Check cache first
        if (recordTypeIdCache.containsKey(recTypeName)) {
            return recordTypeIdCache.get(recTypeName);
        }
        
        String recTypeId = '';
        try {
            recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch (Exception e) {
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Podcast_Episode__c' LIMIT 1].Id;
        }
        recordTypeIdCache.put(recTypeName, recTypeId);
        return recTypeId;
    }
    
    public static Podcast_Episode__c createPodcastEpisodeInstance(Podcast_Episode__c podcastEpisodeRecord, String recordTypeId) {
        Podcast_Episode__c podcastEpisodeInstance = podcastEpisodeRecord;
        
        podcastEpisodeInstance.Name = String.isBlank(podcastEpisodeInstance.Name) ? TestDataUtility.generateRandomString(5) : podcastEpisodeInstance.Name;
        podcastEpisodeInstance.Description__c = String.isBlank(podcastEpisodeInstance.Description__c) ? TestDataUtility.generateRandomString(20) : podcastEpisodeInstance.Description__c;
        
        return podcastEpisodeInstance;
    }
}