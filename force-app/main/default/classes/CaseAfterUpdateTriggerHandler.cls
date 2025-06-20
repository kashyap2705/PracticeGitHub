public class CaseAfterUpdateTriggerHandler  extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        process( (List<Case>)tp.newList, (Map<Id,Case>)tp.oldMap);
    }
    
    @testVisible  private static void process(List<Case> newCaseApp, Map<Id, Case> oldCaseMap){
        List<Case> PGQA_Case = new List<Case>();
        Set<ID> AccountIds = new Set<ID>();
        List<Case> Update_PGQA_Case = new List<Case>();
        List<Contact> PGQA_Contact = new List<Contact>();
        //Added by Shahrukh on 12/06/2023 for ECM00423 -- START --
        Map<Id, Case> caseByCaseId = new Map<Id, Case>();
        List<Voice_of_Customer__c> vocToUpdate = new List<Voice_of_Customer__c>();
        List<Voice_of_Customer__c> vocToInsert = new List<Voice_of_Customer__c>();
        //Added by Shahrukh on 12/06/2023 for ECM00423 -- END --
        
         //code added by Prerna on 21-07-2023 for ECM00489 --START--
        List<Case_Queue_Management__c> oldCaseQueueManagementList = new List<Case_Queue_Management__c>();
        List<Case_Queue_Management__c> newCaseQueueManagementList = new List<Case_Queue_Management__c>();
        Set<Id> caseIdsCQM = new Set<Id>(); 
        Set<Id> ownerIds = new Set<Id>();
        List<Case> casesCQM = new List<Case>();
        List<Case> closedCases = new List<Case>();
        Set<Id> closedCasesIds = new Set<Id>(); 
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
        
        
        for(Case c : newCaseApp)
        {
             //code added by Prerna on 21-07-2023 for ECM00489 --START--
            if(c.Status !=oldCaseMap.get(c.Id).Status && c.Status == 'Closed'){
                closedCases.add(c);
                closedCasesIds.add(c.id);
            }
            if(c.OwnerId != oldCaseMap.get(c.Id).OwnerId && c.Case_Record_Type_Text__c == 'Support') {
                casesCQM.add(c);
                caseIdsCQM.add(c.Id);
                ownerIds.add(c.OwnerId);
            }
            //code added by Prerna on 20-07-2023 for ECM00489 --END--
            System.debug(c.Case_Record_Type_Text__c);
            
            
            if(c.Case_Record_Type_Text__c == 'PGQA')
            {
                Case caseupdate = new Case(id = c.id);
                PGQA__c Subject = [Select id,Name from PGQA__c where id = :c.PGQA_Subject_Level_Language__c Limit 1];
                //System.debug('EX: '+c.PGQA_Subject_Level_Language__r.English__c);
                caseupdate.Subject = 'PGQA – '+ c.PGQA_Assessment_Session__c + ' - '+ c.CaseNumber +' – '+Subject.Name;
                Update_PGQA_Case.add(caseupdate);
            }
            
            //Added by Shahrukh on 12/06/2023 for ECM00423 -- START --
            if(c.Q2_Unresolved_request_for_follow_up__c != oldCaseMap.get(c.Id).Q2_Unresolved_request_for_follow_up__c ||
               c.Q8_Suggestions_for_improvement__c != oldCaseMap.get(c.Id).Q8_Suggestions_for_improvement__c ||
               c.Q7_Reason_for_dissatisfaction_Other__c != oldCaseMap.get(c.Id).Q7_Reason_for_dissatisfaction_Other__c) {
                   caseByCaseId.put(c.Id, c);
               }
            
            if(oldCaseMap.get(c.Id).Q1_Did_we_resolve_your_support_request__c == NULL && c.Q1_Did_we_resolve_your_support_request__c != NULL && 
               oldCaseMap.get(c.Id).Survey_Date__c == NULL && c.Survey_Date__c != NULL) {
                   Voice_of_Customer__c voiceOfCustomer = new Voice_of_Customer__c();
                   voiceOfCustomer.Contact__c = c.ContactId;
                   voiceOfCustomer.Case__c = c.Id;
                   voiceOfCustomer.Q2_Unresolved_request_for_follow_up__c = c.Q2_Unresolved_request_for_follow_up__c;
                   voiceOfCustomer.Q8_Suggestions_for_improvement__c = c.Q8_Suggestions_for_improvement__c;
                   voiceOfCustomer.Q7_Reason_for_dissatisfaction_Other__c = c.Q7_Reason_for_dissatisfaction_Other__c;
                   vocToInsert.add(voiceOfCustomer);
               }
            //Added by Shahrukh on 12/06/2023 for ECM00423 -- END --
        }
        
        update Update_PGQA_Case;
        
        //Added by Shahrukh on 12/06/2023 for ECM00423 -- START --
        for(Voice_of_Customer__c voc : [SELECT Id, Name, Case__c, Q2_Unresolved_request_for_follow_up__c, Q8_Suggestions_for_improvement__c, Q7_Reason_for_dissatisfaction_Other__c
                                        FROM Voice_of_Customer__c 
                                        WHERE Case__c IN :caseByCaseId.keySet()]) {
                                            voc.Q2_Unresolved_request_for_follow_up__c = caseByCaseId.get(voc.Case__c).Q2_Unresolved_request_for_follow_up__c;
                                            voc.Q8_Suggestions_for_improvement__c = caseByCaseId.get(voc.Case__c).Q8_Suggestions_for_improvement__c;
                                            voc.Q7_Reason_for_dissatisfaction_Other__c = caseByCaseId.get(voc.Case__c).Q7_Reason_for_dissatisfaction_Other__c;
                                            vocToUpdate.add(voc);
                                        }
        
        if(!vocToUpdate.isEmpty()) {
            update vocToUpdate;
        }
        
        if(!vocToInsert.isEmpty()) {
            insert vocToInsert;
        }
        //Added by Shahrukh on 12/06/23 for ECM00423 -- END --
        
         //code added by Prerna on 21-07-2023 for ECM00489 --START--
        
        Map<Id, Group> queueMap = new Map<Id, Group>([select Id, Name from Group where id in :ownerIds]);
        Map<Id, User> userMap = new Map<Id, User>([select Id, Name from User where id in :ownerIds]);
        
        for(Case c : casesCQM){
            Case_Queue_Management__c newCaseQueueManagement = new Case_Queue_Management__c();
            newCaseQueueManagement.CaseId__c = c.Id;
            if (String.valueOf(c.OwnerId).startsWith('00G')) {
                newCaseQueueManagement.Case_Owner__c = queueMap.get(c.OwnerId).Name; 
                newCaseQueueManagement.Office__c = c.Office__c;
                newCaseQueueManagement.Department__c = c.Department__c;
            }
            else{
                newCaseQueueManagement.Case_Owner__c = userMap.get(c.OwnerId).Name; 
            }
            newCaseQueueManagementList.add(newCaseQueueManagement);
        }
        
        if(caseIdsCQM != null && !caseIdsCQM.isEmpty()){
            List<Case> casesWithCQM = [select id, (select id, Ownership_Ended_Time__c from Case_Queue_Management__r order by CreatedDate desc limit 1) from Case where id in :caseIdsCQM];
            for(Case c : casesWithCQM) {
                if(c.Case_Queue_Management__r != null && !c.Case_Queue_Management__r.isEmpty()) {
                    c.Case_Queue_Management__r[0].Ownership_Ended_Time__c = System.now();
                    oldCaseQueueManagementList.add(c.Case_Queue_Management__r[0]);
                }
            }
        }
        if(closedCasesIds != null && !closedCasesIds.isEmpty()){
            List<Case> closedCasesWithCQM = [select id, (select id, Ownership_Ended_Time__c from Case_Queue_Management__r order by CreatedDate desc limit 1) from Case where id in :closedCasesIds];
            for(Case c :closedCasesWithCQM){
                if(c.Case_Queue_Management__r != null && !c.Case_Queue_Management__r.isEmpty()) {
                    c.Case_Queue_Management__r[0].Ownership_Ended_Time__c = System.now();
                    oldCaseQueueManagementList.add(c.Case_Queue_Management__r[0]);
                }
            }
        }

        newCaseQueueManagementList = dedupeCaseQueueManagement(newCaseQueueManagementList);
        oldCaseQueueManagementList = dedupeCaseQueueManagement(oldCaseQueueManagementList);

        if(!newCaseQueueManagementList.isEmpty()) {
            Database.insert(newCaseQueueManagementList, False);
        }
        
        if(!oldCaseQueueManagementList.isEmpty()) {
            Database.update(oldCaseQueueManagementList, False);
        }
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
        
    }
    
    /**
     * dedupeCaseQueueManagement
     * 
     * takes a list of Case_Queue_Management__c and then returns a deduped list, if there were duplicates at all
     */
    @testVisible private static List<Case_Queue_Management__c> dedupeCaseQueueManagement(List<Case_Queue_Management__c> inputList)
    {
        Map<Id, Case_Queue_Management__c> mapOfRecords = new Map<Id, Case_Queue_Management__c>();

        for(Case_Queue_Management__c item : inputList)
        {
            if(mapOfRecords.get(item.Id) == null)
            {
                mapOfRecords.put(item.Id, item);
            }
            // skip
            else {}
        }
        
        return mapOfRecords.values();
    }

}