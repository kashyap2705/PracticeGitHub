trigger AccountTrigger on Account (after update) {
    System.enqueueJob(new TrackingHistory(Account.sObjectType, Trigger.oldMap, Trigger.newMap));
}