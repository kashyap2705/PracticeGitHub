public with sharing class IB_RoleAfterUndeleteTriggerHandler extends TriggerHandlerBase {
	
	public override void mainEntry(TriggerParameters tp) {
		process((Map<Id,IB_Role__c>)tp.oldMap, (Map<Id,IB_Role__c>)tp.newMap);
	}

	private static void process (Map<Id,IB_Role__c> oldRec, Map<Id,IB_Role__c> newRec) {
		Set<Id> contactIds = new Set<Id>();
        for(IB_Role__c r:newRec.values()){
            contactIds.add(r.IB_Contact__c);
        }
        system.debug('ContactIds: ' + contactIds);
        PermissionSetMaintenance.permissionMaintenance(contactIds);
	}
}