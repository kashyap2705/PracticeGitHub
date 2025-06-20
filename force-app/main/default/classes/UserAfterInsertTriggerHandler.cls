public class UserAfterInsertTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        process((Map<Id,User>)tp.oldMap, (Map<Id,User>)tp.newMap);
    }

    private static void process(Map<Id,User> oldUser, Map<Id,User> newUser) {
        
        Set<Id> contactIds = new Set<Id>();
        for (Id key : newUser.keySet()) {
            if(newUser.get(key).ContactId != null)
                contactIds.add(newUser.get(key).ContactId);
        }
        
        
        PermissionSetMaintenance.permissionMaintenance(contactIds);
        system.debug('Added by uma in line 17 userAfterInsertTriggerHandler');
        SyncUserIdWithContact.SyncUserIdWithContact(contactIds);
        system.debug('Added by uma in line 19 userAfterInsertTriggerHandler');

    }

}