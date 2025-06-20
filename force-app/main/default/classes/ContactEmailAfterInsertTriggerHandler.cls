public class ContactEmailAfterInsertTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp){
		process((Map<Id,ContactEmail__c>)tp.oldMap, (Map<Id,ContactEmail__c>)tp.newMap);
	}

	private static void process (Map<Id,ContactEmail__c> oldRec, Map<Id,ContactEmail__c> newRec){
		
		List<ContactEmail__c> emails = new List<ContactEmail__c>();
		for (Id key : newRec.keySet()) {
			emails.add(newRec.get(key)); 
		}
		ContactEmailTriggerHelper.setProgrammeDefaultRoleEmails(emails);
		
	}

}