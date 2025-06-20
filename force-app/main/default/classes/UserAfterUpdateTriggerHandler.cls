public class UserAfterUpdateTriggerHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp){
        process((Map<Id,User>)tp.oldMap, (Map<Id,User>)tp.newMap);
    }

    private static void process(Map<Id,User> oldUser, Map<Id,User> newUser) {
    	 boolean isChanged = false;     
        if(FutureHelper.canIRun()){
            Set<Id> contactIds = new Set<Id>();
            for (Id key : newUser.keySet()) {
                if(newUser.get(key).isActive == true && oldUser.get(key).isActive == false)
                    contactIds.add(newUser.get(key).ContactId); 
                if(newUser.get(key).contactID == oldUser.get(key).contactID)
                    isChanged = true;
            }
                
            if(contactIds.size() > 0)
                PermissionSetMaintenance.permissionMaintenance(contactIds);
            if( !isChanged ){
                system.debug('Added by uma in line 20 userAfterUpdateTriggerHandler');
            SyncUserIdWithContact.SyncUserIdWithContact(contactIds);
                system.debug('Added by uma in line 22 userAfterUpdateTriggerHandler');
            }
        }

    }

}