trigger LeadTrigger on Lead (after Update) {
	System.enqueueJob(new TrackingHistory(Lead.sObjectType, Trigger.oldMap, Trigger.newMap));
}