global class WithdrawStaleOnBoardingRolesBatch implements Database.Batchable<sObject>, Schedulable  {
       
    global void execute(SchedulableContext sc)
    {
        WithdrawStaleOnBoardingRolesBatch withdrawBatch = new WithdrawStaleOnBoardingRolesBatch();
        Database.executebatch(withdrawBatch, 20);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date expiryDate = Test.isRunningTest() ? Date.today().addDays(90) : Date.today();
        return Database.getQueryLocator([Select name,IB_Contact__c,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c from IB_Role__c where
                                         Expiry_Date__c<=:expiryDate and IB_Programme_New__c=null and IB_Role__r.Role_Name__c IN : IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION and Status__c <> :IboUtil.ROLE_WITHDRAWN_STATUS and Status__c <> :IboUtil.ROLE_DECLINED_STATUS]);
    }
    
    global void execute(Database.BatchableContext BC, List<IB_Role__c> scope) {
        try{
            List<IB_Role__c> rolesToUpdate = new  List<IB_Role__c>();
            System.debug('WithdrawRolesBatch#: scope size : '+scope.size());
            for(IB_Role__c role: scope ) {
                 if(role.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && role.Status__c!=IboUtil.ROLE_INVITED_STATUS){
                    role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                    }
                    else{
                    role.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                    }
                role.Active__c = false;
                role.End_Date__c = Date.today();
                rolesToUpdate.add(role);
            }
            
            Set<Id> contactIds = new Set<Id>();
            for(IB_Role__c rID : rolesToUpdate){
                contactIds.add(rID.IB_Contact__c);
            }
            
            if(rolesToUpdate.size() > 0)
            {
                update rolesToUpdate;
                ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(contactIds));
                System.debug('WithdrawRolesBatch# jobID : ' + jobID);
            }
        }catch (Exception exp){                                                        
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
        
    }
}