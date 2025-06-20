public class WithdrawOnboardingRolesQueueable implements Database.Batchable<sObject>{
    
    Set<ID> programmeIds = new Set<ID>();
    
    public static Map<Id,Set<String>> mapAccProgrammes = new Map<Id,Set<String>>();
    
    public WithdrawOnboardingRolesQueueable(Set<ID> programmeIds)
    {
        this.programmeIds = programmeIds;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {        
                for(IB_Programme__c prog : [select Id,Account__c,RecordType.Name from IB_Programme__c where Id IN : programmeIds]) {
                    Set<String> setProgrammeTypes = new Set<String>();
                    if(mapAccProgrammes.containsKey(prog.Account__c)) {
                        setProgrammeTypes = mapAccProgrammes.get(prog.Account__c);
                    }
                    if(prog.RecordType.Name == 'Diploma Programme') {
                        setProgrammeTypes.add('DP');
                    } else {
                        setProgrammeTypes.add(prog.RecordType.Name);    
                    }
                    
                    mapAccProgrammes.put(prog.Account__c, setProgrammeTypes);
                }
        return Database.getQueryLocator([select Id,IB_Account__c,IB_Contact__c,IB_Programme_New__c,Programme_Selection__c,IB_Role__r.Role_Name__c,Status__c from IB_Role__c where IB_Account__c IN : mapAccProgrammes.keyset() 
                                       and IB_Role__r.Role_Name__c IN :IboUtil.DEFAULT_PROGRAMME_ROLES and IB_Programme_New__c = null and Status__c <> :IboUtil.ROLE_WITHDRAWN_STATUS and Status__c <> :IboUtil.ROLE_DECLINED_STATUS]);
    }
    
    public void execute(Database.BatchableContext context, List<IB_Role__c> scope) {
        try{           
            final List<IB_Role__c> listRolesToWithdraw = new List<IB_Role__c>();
            
            for(IB_Role__c role : scope) {
                                           Set<String> accProgrammeTypes = mapAccProgrammes.get(role.IB_Account__c);
                                           if(accProgrammeTypes.contains(role.Programme_Selection__c)) {
                    //role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                    if(role.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && role.Status__c!=IboUtil.ROLE_INVITED_STATUS){
                        role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                        }
                        else{
                        role.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                        }
                                               role.End_Date__c = Date.today();
                                               role.Active__c = false;
                                               listRolesToWithdraw.add(role);
                                           }
                                       }
                
                if(!listRolesToWithdraw.isEmpty()) {
                    update listRolesToWithdraw;
                }
        }catch (Exception exp) {                                                        
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }
    }
    
    public void finish(Database.BatchableContext BC) {
    }
}