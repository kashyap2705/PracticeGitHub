public class ContactEmailAfterDeleteTriggerHandler extends TriggerHandlerBase {

	public override void mainEntry(TriggerParameters tp){
        System.debug(tp);
		process((Map<Id,ContactEmail__c>)tp.oldMap, (Map<Id,ContactEmail__c>)tp.newMap);
	}

	private static void process (Map<Id,ContactEmail__c> oldRec, Map<Id,ContactEmail__c> newRec){
		
		List<ContactEmail__c> emails = new List<ContactEmail__c>();
		for (Id key : oldRec.keySet()) {
			emails.add(oldRec.get(key)); 
		}
		ContactEmailTriggerHelper.deleteProgrammeDefaultRoleEmails(emails);
		
	}

}