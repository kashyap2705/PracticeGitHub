trigger ContactTrigger on Contact (after update) {
	System.enqueueJob(new TrackingHistory(Contact.sObjectType, Trigger.oldMap, Trigger.newMap));
}