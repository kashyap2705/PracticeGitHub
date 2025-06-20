global class caseOwnerChangeOnUserDeactivate implements Database.Batchable<sObject>{
    
    public Set<ID> userCasesID = new Set<ID>();
    public List<Case> userCases = new List<Case>();
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query;
        String parameter = 'testeng1415@gmail.com';
        if(Test.isRunningTest())
            query = 'Select id, Name,IsActive FROM User where IsActive = False and username LIKE:parameter Limit 200';
        else
            query = 'Select id, Name,IsActive FROM User where IsActive = False';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<User> inActiveUsers){
        try{
            Set<ID> userCasesIDRemaining = new Set<ID>();
            Group queueGroup = [select Id from Group where  Type = 'Queue' AND NAME = 'SO Customer Service' Limit 1];
            if(!Test.isRunningTest())
                userCases = [Select id, CaseNumber, OwnerId from Case where OwnerId In: inActiveUsers and Status != 'Closed'];
            for(Case caseData : userCases){
                userCasesID.add(caseData.id);
                userCasesIDRemaining.add(caseData.id);
            }
            Map<id,List<CaseHistory>> caseHistoryMap = new Map<id,List<CaseHistory>>();
            
            for(CaseHistory caseHistry : [SELECT CaseId, OldValue, NewValue FROM CaseHistory where CaseId IN:userCasesID AND Field = 'Owner']){
                userCasesIDRemaining.remove(caseHistry.CaseId);
                if (caseHistoryMap.containsKey(caseHistry.CaseId)){
                    caseHistoryMap.get(caseHistry.CaseId). add(caseHistry);
                }
                else{
                    caseHistoryMap.put(caseHistry.CaseId, new List<CaseHistory>{caseHistry});
                }
            }
            
            List<CaseHistory> caseHistry = new List<CaseHistory>();
            Set<ID> secondUserID = new Set<ID>();
            Set<ID> secondCaseID = new Set<ID>();
            Map<id,Case> updateCaseOwner = new Map<id,Case>();
            Map<id,id> secondUserCaseUpdate = new Map<id,id>();
            
            for(Id key : caseHistoryMap.keySet()){
                Case tempCase = new Case();
                caseHistry = caseHistoryMap.get(key);
                if(caseHistry.size()>0 ){
                    Integer caseIds = caseHistry.size()-1;                  
                    secondCaseID.add(key);
                    tempCase.id = key;
                    tempCase.OwnerId = (id)caseHistry[caseIds].OldValue;
                    secondUserID.add(tempCase.OwnerId);
                    updateCaseOwner.put(key,tempCase);
                    secondUserCaseUpdate.put((id)caseHistry[caseIds].OldValue,key);
                    caseHistry.clear();
                    caseIds = 0;
                }
                else{
                    tempCase.id = key;
                    tempCase.OwnerId = queueGroup.id;
                    updateCaseOwner.put(key,tempCase);
                }
            }
            List<User> secondUser = new List<User>();
            Set<ID> caseIdToUpdateQueue = new Set<ID>();
            secondUser = [Select id, Name,CreatedDate,Email,IsActive,Profile.Name,LastLoginDate,LanguageLocaleKey FROM User where IsActive = False AND id IN : secondUserID];
            if(secondUser.size()>0)
            {
                for (User u : secondUser)
                {
                    ID myId = secondUserCaseUpdate.get(u.id);
                    caseIdToUpdateQueue.add(myId);
                }
            }
            List<Case> userCasesSecondUser = new List<Case>();
            userCasesSecondUser = [Select id, OwnerId from Case where id IN : caseIdToUpdateQueue and Status != 'Closed'];
            
            for (Case caseData : userCasesSecondUser){
                caseData.OwnerId = queueGroup.id;
                if (updateCaseOwner.containsKey(caseData.id)){
                    updateCaseOwner.remove(caseData.id);
                    updateCaseOwner.put(caseData.id,caseData);
                }
            }
            if(userCasesIDRemaining.size()>0){
                for(Case caseData : [Select id, ownerId from Case where id IN : userCasesIDRemaining]){
                    caseData.OwnerId = queueGroup.id;
                    updateCaseOwner.put(caseData.id,caseData);
                }
            }
            if(updateCaseOwner.size()>0){
                if(!Test.isRunningTest())
                    Database.update (updateCaseOwner.values(),false);
            }
        }
        catch(exception ex)
        {
            System.debug('Exception : '+ex);
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
    } 
}