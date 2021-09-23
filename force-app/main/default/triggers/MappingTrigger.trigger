trigger MappingTrigger on e_eat__Mapping__c (after update) {
	System.enqueueJob(new TrackingHistory(e_eat__Mapping__c.sObjectType, Trigger.oldMap, Trigger.newMap));
}