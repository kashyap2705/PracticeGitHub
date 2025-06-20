/**
* <h1>Withdraw Roles & Applications</h1>
* This Batch Class is responsible to withdraw roles and appications related to programmes with one of the following statuses - 
* Terminated/Terminated by School/Terminated by IB
* Withdrawn/Withdrawn by School/Withdrawn by IB
* @author  Paridhi Bindal
* @version 1.0
* @since   04/01/2021
*/

global class WithdrawRolesBatch implements Database.Batchable<sObject>  {
    
    
    global List<String>  updateResult=new List<String>();
    
    global Set<Id> programmeIds = new Set<Id>();
    global Map<Id,Boolean> mapAccountHasActiveProgram = new Map<Id,Boolean>(); //ECM00774
    
    global List<Id> roleIds = new List<Id>();
    
    global WithdrawRolesBatch() {
    }
    
    global WithdrawRolesBatch(Set<Id> programmeIds) {
        this.programmeIds = programmeIds;
    }
    //ECM00774 [start]
    global WithdrawRolesBatch(Set<Id> programmeIds,Map<Id,Boolean> mapAccountHasActiveProgram) {
        this.programmeIds = programmeIds;
        this.mapAccountHasActiveProgram = mapAccountHasActiveProgram;
    }
    //End
    global WithdrawRolesBatch(List<Id> roleIds) {
        this.roleIds = roleIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if(!programmeIds.isEmpty() && mapAccountHasActiveProgram.isEmpty()) { //ECM00774
            return Database.getQueryLocator([Select name,IB_Contact__c,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c,IB_Account__c from IB_Role__c where IB_Programme_New__c IN : programmeIds]);    
        }else  if(!programmeIds.isEmpty() && !mapAccountHasActiveProgram.isEmpty()) { //ECM00774 if block added
            return Database.getQueryLocator([Select name,IB_Contact__c,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c,IB_Account__c from IB_Role__c where IB_Programme_New__c IN : programmeIds OR IB_Account__c IN: mapAccountHasActiveProgram.keySet()]);    
        }else  if(!roleIds.isEmpty()) {
            return Database.getQueryLocator([Select name,IB_Contact__c,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c,IB_Account__c from IB_Role__c where Id IN : roleIds]);    
        } else {
          return Database.getQueryLocator([Select name,IB_Contact__c,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c ,IB_Account__c from IB_Role__c where
                                         Status__c='Confirmed' AND IB_Role__c != null AND 
                                         (IB_Role__c.IB_Programme_New__r.Status__c like 'Terminated%' OR IB_Role__c.IB_Programme_New__r.Status__c like 'Withdrawn%' OR IB_Role__c.IB_Programme_New__r.Status__c like '%Previously Interested%')]);    
        }
        
    }
    
    
    global void execute(Database.BatchableContext BC, List<IB_Role__c> scope) {
        IboUtil.showLimits('WithdrawRolesBatch');
        List<IB_Role__c> rolesToUpdate = new  List<IB_Role__c>();
        System.debug('WithdrawRolesBatch#: scope size : '+scope.size());
        for(IB_Role__c role: scope ) {
            //ECM00774 [added/modified]
            if( mapAccountHasActiveProgram != null && ((role.IB_Programme_New__c != null && programmeIds.contains(role.IB_Programme_New__c)) || (mapAccountHasActiveProgram.containsKey(role.IB_Account__c) && !mapAccountHasActiveProgram.get(role.IB_Account__c))) ){
                rolesToUpdate.add(updateRoleStatus(role));
            }else{
                rolesToUpdate.add(updateRoleStatus(role));
            } 
            //ECM00774 [end]
        }
        
        Set<Id> contactIds = new Set<Id>();
        for(IB_Role__c rID : rolesToUpdate){
            contactIds.add(rID.IB_Contact__c);
        }
        
        System.debug('WithdrawRolesBatch#: rolesToUpdate.size():'+rolesToUpdate.size());
        if(rolesToUpdate.size() > 0)
        {
            update rolesToUpdate;
            ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(contactIds));
            System.debug('WithdrawRolesBatch# jobID : ' + jobID);
        }
        IboUtil.showLimits('WithdrawRolesBatch');
    }  
    //ECM00774 function created
    global IB_Role__c updateRoleStatus (IB_Role__c role){
        if(role.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && role.Status__c!=IboUtil.ROLE_INVITED_STATUS){
            role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
        }else{
            role.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
        }
        
        if(role.IB_Programme_New__r.Old_Withdrawn_Status_Date__c != null){
            role.End_Date__c= role.IB_Programme_New__r.Old_Withdrawn_Status_Date__c;  
        }else{
            role.End_Date__c= Date.today();
        }   
        role.Active__c = false;
        return role;
    }
    global void finish(Database.BatchableContext BC) {
    }
}