trigger OpportunityProductTrigger on OpportunityLineItem (after update) {
System.enqueueJob(new e_eat.TrackingHistory(OpportunityLineItem.sObjectType,Trigger.oldMap, Trigger.newMap));

}