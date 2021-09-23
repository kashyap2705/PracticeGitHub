trigger OpportunityTrigger on Opportunity (after update) {
    System.enqueueJob(new TrackingHistory(Opportunity.sObjectType, Trigger.oldMap, Trigger.newMap));
}