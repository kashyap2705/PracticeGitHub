public class IB_ApplicationAfterInsertTriggerHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		process((Map<Id,IB_Application__c>)tp.oldMap, (Map<Id,IB_Application__c>)tp.newMap);
	}

	private static void process (Map<Id,IB_Application__c> oldRec, Map<Id,IB_Application__c> newRec) {

		List<IB_Application__c> applications = new List<IB_Application__c>();
		for (Id key : newRec.keySet()) {
			applications.add(newRec.get(key)); 
		}

		populateChildObjects(applications);

	}

	private static void populateChildObjects(List<IB_Application__c> applications) {

		List<IB_Application_Assessment__c> assessments = new List<IB_Application_Assessment__c>();

		for (IB_Application__c app : applications) {

			IB_Application_Assessment__c assessment = new IB_Application_Assessment__c(
				Application__c = app.Id
			);
			assessments.add(assessment);

		}

		if (!assessments.isEmpty()) {
			insert assessments;
		}

	}

}