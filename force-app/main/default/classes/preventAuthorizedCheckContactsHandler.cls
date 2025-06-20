public class preventAuthorizedCheckContactsHandler {
    
    @TestVisible String roleId;
    @TestVisible String roleName;
    @TestVisible Boolean roleFilledHeadOfSchool;
    @TestVisible Boolean roleFilledProgrammeCoordinator;
    
    @TestVisible Integer LoopCounter;
    @TestVisible Id currProg;
    @TestVisible Map<Id,IB_Role_Repository__c> roleRepoMap = new Map<Id,IB_Role_Repository__c>([SELECT Id,Role_Name__c FROM IB_Role_Repository__c]);
    @TestVisible Map<Id,IB_Role__c> roleMap = new Map<Id,IB_Role__c>();
    @TestVisible Map<Id,IB_Role__c> roleMapTemp = new Map<Id,IB_Role__c>();
    @TestVisible Map<Id,Map<Id,IB_Role__c>> roleMapNested = new Map<Id,Map<Id,IB_Role__c>>();
    @TestVisible Map <Id, IB_Role__c> programmeRoles = new Map <Id, IB_Role__c>();
    
    // Method used to handle processing of the programme records that fired the preventAuthorizedCheckContactsNew trigger
    public void processUpdatedProgs (List<IB_Programme__c> updatedProgs) {
        roleMap = new Map<Id,IB_Role__c>();
		roleMapTemp = new Map<Id,IB_Role__c>();
		roleMapNested = new Map<Id,Map<Id,IB_Role__c>>();
		programmeRoles = new Map <Id, IB_Role__c>();
        try
        {
            
            Set<Id> currProgs = new Set<Id>();
            for(IB_Programme__c prog : updatedProgs) currProgs.add(prog.Id);
            
            //Populate the roleMapNested Map with the correct roles by programme.
            LoopCounter = 1;
            for (IB_Role__c ibr : [SELECT Id, IB_Role__c, IB_Programme_New__c FROM IB_Role__c WHERE IB_Programme_New__c IN :currProgs AND (End_Date__c = null OR End_Date__c > TODAY) Order By IB_Programme_New__c]) {
                roleMap.put(ibr.Id,ibr);
                if (LoopCounter == 1) currProg = ibr.IB_Programme_New__c;
                if (currProg == ibr.IB_Programme_New__c) roleMapTemp.put(ibr.Id,ibr);
                if (currProg != ibr.IB_Programme_New__c) {
                    roleMapNested.put(currProg,roleMapTemp);
                    roleMapTemp.clear();
                    currProg = ibr.IB_Programme_New__c;
                    roleMapTemp.put(ibr.Id,ibr);
                }
                LoopCounter++;
            }
            //Add final roleMapTemp to the nested map once the loop is completed
            if (roleMapTemp.size() > 0) roleMapNested.put(currProg,roleMapTemp);
            
            for (IB_Programme__c prog : updatedProgs) {
                //Get all Roles and Applications associated with this programme
                programmeRoles = roleMapNested.get(prog.Id);
                system.debug('programmeRoles.size() =====> '+programmeRoles.size());
                
                roleFilledHeadOfSchool = false;
                roleFilledProgrammeCoordinator = false;
                //Loop through Roles and Applications looking for Head of School and Programme Coordinator
                for (IB_Role__c role : programmeRoles.values()) {
                    roleId = role.IB_Role__c;
                    roleName = roleRepoMap.get(roleId).Role_Name__c;
                    if (roleName == 'Head of School') roleFilledHeadOfSchool = true;
                    if (roleName == 'Programme Coordinator') roleFilledProgrammeCoordinator = true;
                    //system.debug('roleId =====> '+roleId);
                    //system.debug('roleName =====> '+roleName);
                    //system.debug('roleFilledHeadOfSchool =====> '+roleFilledHeadOfSchool);
                    //system.debug('roleFilledProgrammeCoordinator =====> '+roleFilledProgrammeCoordinator);
                }
                //If necessary roles are not met, throw error
                if (!roleFilledProgrammeCoordinator || !roleFilledHeadOfSchool) {
                    prog.addError('Please make sure the Programme has a Head of School and Programme Coordinator before updating from Interested to Candidate');
                }
            }
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
}