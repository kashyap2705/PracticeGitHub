public class CaseAfterInsertTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        
        process( (List<Case>)tp.newList);
        
    }
    
    @testVisible  private static void process(List<Case> newCaseApp){
        List<Case> PGQA_Case = new List<Case>();
        Set<ID> AccountIds = new Set<ID>();
        List<Case> Update_PGQA_Case = new List<Case>();
        List<Contact> PGQA_Contact = new List<Contact>();
        System.debug('new case list is====>>>>'+newCaseApp);
        //code added by Prerna on 20-07-2023 for ECM00489 --START--
        List<Case_Queue_Management__c> newCaseQueueManagementList = new List<Case_Queue_Management__c>();
        Set<Id> ownerIds = new Set<Id>();
        List<Case> supportCases = new List<Case>();
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
        
        //below if BLOCK is added for replacing the workflow rule field update action, workflow rule name: Route Community Cases to Corresponding Queue
        //code added by prerna for INC0189003 on 22-09-2023 --START--
        Set<String> setRecordTypes = new Set<String>{'SIPGE Request','PGQA','Contingency measure'};
            List<Case> newCasesList = [SELECT Id, OwnerId, Origin, Case_Record_Type_Text__c,AccountId, ContactId FROM Case WHERE Id IN :newCaseApp AND Origin = 'Web' AND Case_Record_Type_Text__c NOT IN :setRecordTypes];
        List<Case> updateCaseOwnerList = new List<Case>();
        Set<Id> caseIdsSet = new Set<Id>();
        ID serviceQueueId = CaseTriggerHelper.soCustomerServiceQueueId;
        for(Case caseObj: newCasesList){
            if(caseObj.OwnerId != serviceQueueId){
                caseObj.OwnerId = CaseTriggerHelper.soCustomerServiceQueueId;
                updateCaseOwnerList.add(caseObj);
                caseIdsSet.add(caseObj.id);
            }        
        }
        //code added by prerna on for INC0189003 on 22-09-2023 ----ENDS----
        
        for(Case c : newCaseApp)
        {
            //code added by Prerna on 20-07-2023 for ECM00489 --START--
            
            if(c.Case_Record_Type_Text__c == 'Support'){
                ownerIds.add(c.OwnerId);
                supportCases.add(c);
            }
            
            //code added by Prerna on 20-07-2023 for ECM00489 --END--
            
            System.debug(c.Case_Record_Type_Text__c);
            if(c.Case_Record_Type_Text__c == 'PGQA')
            {
                Case caseupdate = new Case(id = c.id);
                PGQA__c Subject = [Select id,Name from PGQA__c where id = :c.PGQA_Subject_Level_Language__c Limit 1];
                System.debug('EX: '+c.PGQA_Subject_Level_Language__r.English__c);
                caseupdate.Subject = 'PGQA – '+ c.PGQA_Assessment_Session__c + ' - '+ c.CaseNumber +' – '+Subject.Name;
                Update_PGQA_Case.add(caseupdate);
            }
            
            
        }
        
        update Update_PGQA_Case;
        //code added by Prerna on 20-07-2023 for ECM00489 --START--
        if(supportCases != null && supportCases.size()>0){
            Map<Id, Group> queueMap = new Map<Id, Group>([select Id, Name from Group where id in :ownerIds]);
            Map<Id, User> userMap = new Map<Id, User>([select Id, Name from User where id in :ownerIds]);
            
            for(Case c : supportCases){
                //code added by prerna for INC0189003 on 22-09-2023 --START--
                if (!caseIdsSet.contains(c.id)) {
                //code added by prerna for INC0189003 on 22-09-2023 --ends--  
                    
                    Case_Queue_Management__c newCaseQueueManagement = new Case_Queue_Management__c();
                    newCaseQueueManagement.CaseId__c = c.Id;
                    if (String.valueOf(c.OwnerId).startsWith('00G')) {
                        newCaseQueueManagement.Case_Owner__c = queueMap.get(c.OwnerId).Name;
                        newCaseQueueManagement.Office__c = c.Office__c;
                        newCaseQueueManagement.Department__c = c.Department__c;
                    } else{
                        newCaseQueueManagement.Case_Owner__c = userMap.get(c.OwnerId).Name;
                    }
                    newCaseQueueManagementList.add(newCaseQueueManagement);
                }
            }
        }
        
        if(!newCaseQueueManagementList.isEmpty()) {
            //insert newCaseQueueManagementList;
            Database.insert(newCaseQueueManagementList,False);
        }
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
        //code added by prerna for INC0189003 on 22-09-2023 --START--
        if(updateCaseOwnerList != null && !updateCaseOwnerList.isEmpty()){
            update updateCaseOwnerList;
        }
        //code added by prerna for INC0189003 on 22-09-2023 --ENDS--
    }
}