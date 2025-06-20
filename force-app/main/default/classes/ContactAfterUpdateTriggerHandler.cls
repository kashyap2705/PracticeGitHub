public class ContactAfterUpdateTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp){
		process((Map<Id,Contact>)tp.oldMap, (Map<Id,Contact>)tp.newMap);

	}

     private static void process (Map<Id,Contact> oldContact, Map<Id,Contact> newContact){
          Map<Id,Id> contactAccountIds = new Map<Id,Id>();
          for(Id key : oldContact.keySet()){
               if(oldContact.get(key).AccountId != newContact.get(key).AccountId) contactAccountIds.put(key,oldContact.get(key).AccountId);
          }

          system.debug(contactAccountIds);

          List<IB_Role__c> rolesForContact = new List<IB_Role__c>();
          if (contactAccountIds.size() > 0) rolesForContact = [SELECT IB_Contact__c, IB_Account__c FROM IB_Role__c WHERE IB_Contact__c in :contactAccountIds.keyset() AND (End_Date__c > TODAY OR End_Date__c = NULL) AND IB_Role__r.Category__c not in ('No Longer In Use')];

          List<IB_Role__c> rolesToUpdate = new List<IB_Role__c>();
          for(IB_Role__c r : rolesForContact){
               if(contactAccountIds.get(r.IB_Contact__c) == r.IB_Account__c){
                  //  IB_Role__c role = new IB_Role__c(ID = r.ID,Status__c = 'Withdrawn');
                  //  rolesToUpdate.add(role);
                   system.debug('++++++++++++++++++++++++++');
               }
          }

          if (rolesToUpdate.size() > 0) update rolesToUpdate;
     }

	/*public override void mainEntry(TriggerParameters tp) {
		process((List<Contact>)tp.oldList);
	}

	private static void process(List<Contact> listOldContacts) {
		Map<ID,ID> contactAccountIds = new Map<ID,ID>();

		for(Contact c : listOldContacts){
			contactAccountIds.put(c.ID, c.AccountID);
		}

		List<IB_Role__c> rolesForContact = [SELECT IB_Contact__c, IB_Account__c FROM IB_Role__c WHERE IB_Contact__c in :contactAccountIds.keyset()];

		List<IB_Role__c> rolesToUpdate = new List<IB_Role__c>();
		for(IB_Role__c r : rolesForContact){
			if(contactAccountIds.get(r.IB_Contact__c) == r.IB_Account__c){
				IB_Role__c role = new IB_Role__c();
				role.ID = r.ID;
				role.End_Date__c = Date.today();
				rolesToUpdate.add(role);
			}
		}

		update rolesToUpdate;

	}*/

	/*public override void inProgressEntry(TriggerParameters tp) {
		System.debug('This is an example for reentrant code...');
	}*/
}