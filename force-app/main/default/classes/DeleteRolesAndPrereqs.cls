public with sharing class DeleteRolesAndPrereqs {
    @InvocableMethod
    public static void deleteIBEventRoles(List<Id> eventIds) {
        try
        {
            List<IB_Event_Role__c> eventRolesToDelete = new List<IB_Event_Role__c>();
            for(IB_Event_Role__c e:[SELECT Id, (SELECT Id FROM My_Staffing_Events1__r) FROM IB_Event_Role__c WHERE IB_Event__c in :eventIds]){
                if(e.My_Staffing_Events1__r.size() == 0){
                    eventRolesToDelete.add(e);
                }
            }
            
            delete eventRolesToDelete;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
}