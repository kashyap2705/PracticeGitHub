trigger CustomerTrigger on Customer__c (after update) {
    System.enqueueJob(new TrackingHistory(Customer__c.sObjectType, Trigger.oldMap, Trigger.newMap));
}