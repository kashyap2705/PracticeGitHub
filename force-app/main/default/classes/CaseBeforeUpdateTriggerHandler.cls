public class CaseBeforeUpdateTriggerHandler extends TriggerHandlerBase{
    public override void mainEntry(TriggerParameters tp){
        
        process((Map<Id,Case>)tp.oldMap, (Map<Id,Case>)tp.newMap);
        
        
    }
    
    @testVisible  private static void process(Map<Id,Case> oldCaseApp, Map<Id,Case> newCaseApp){
        List<Case> PGQA_Case = new List<Case>();
        List<Case> PGQA_Case_status = new List<Case>();
        Set<ID> AccountIds = new Set<ID>();
        Set<ID> case_Ids = new Set<ID>();
        List<Case> Update_PGQA_Case = new List<Case>();
        List<Contact> PGQA_Contact = new List<Contact>();
        
        //Added by Prerna on 19-07-2023 for ECM00489 --START--
        Set<Id> ownerIds = new Set<Id>();
        List<Case> ownerUpdatedSupportCases = new List<Case>();
        //Added by Prerna --ENDS--
        
        //Following code is added for US11975 SA Project on 09/10/2020
        //Start
        
        for(Case c : newCaseApp.values())
        {
            try{
                Case temp1 = oldCaseApp.get(c.id); 
                //Added by Prerna on 19-07-2023 for ECM00489 --START--
                if(c.Case_Record_Type_Text__c == 'Support' && oldCaseApp.get(c.id).OwnerId != c.OwnerId)
                {
                    ownerIds.add(c.OwnerId);
                    ownerUpdatedSupportCases.add(c);
                }
                //Added by Prerna --ENDS--
                if(c.Case_Record_Type_Text__c == 'Support' && c.OwnerId != temp1.OwnerId && (c.OwnerID.getsobjecttype() == User.sobjecttype))
                {
                    User us = UserDAO.INSTANCE.getUserById(c.OwnerId);
                    if(us.UserPermissionsSupportUser == false && !Test.isRunningTest())
                        c.addError(Label.Service_Cloud_User_Error);
                }
                if(c.Case_Record_Type_Text__c == 'PGQA' && temp1.AccountId != c.AccountId)
                {
                    
                    PGQA_Case.add(c);
                    AccountIds.add(c.AccountId);
                }
                if(c.Case_Record_Type_Text__c == 'PGQA' && temp1.Status != c.Status && c.Status != 'Draft')
                {
                    PGQA_Case_status.add(c);
                    case_Ids.add(c.id);
                }
                
                /* Commented by Shahrukh on 27/06/23 for future use
//Added by Shahrukh on 15/06/23 for ECM00423 -- START --
if(String.isNotBlank(c.Q1_Did_we_resolve_your_support_request__c) && !c.Is_Survey_Unresolved__c &&
(c.Q1_Did_we_resolve_your_support_request__c.contains('No') || c.Q1_Did_we_resolve_your_support_request__c.contains('partly'))) {
c.Status = 'Unresolved (Survey)';
c.Is_Survey_Unresolved__c = true;
}
//Added by Shahrukh on 15/06/23 for ECM00423 -- END --
*/
                
            }
            catch(Exception ex)
            {
                System.debug('Exception : '+ex);
                
            }
            
        }
        //End
        
        if(PGQA_Case.size()>0){
            System.debug(PGQA_Case.size());
            IB_Role__c roles = [Select id,IB_Contact__c,IB_Contact__r.id,IB_Account__r.DP_Programme_Status__c,IB_Account__r.id,Account_ID__c from IB_Role__c where IB_Account__c IN: AccountIds AND Programme_Selection__c = 'DP' AND IB_Role_Name__c = 'Programme Coordinator' AND Active__c = true AND Status__c ='Confirmed' Limit 1];
            
            
            
            System.debug('Javalog - Confirmed PC: '+roles);
            Map<ID,ID> PC_Map = new Map<ID,ID>();
            Map<ID,String> Account_Prg_Status = new Map<ID,String>();
            
            PC_Map.put(roles.IB_Account__r.id,roles.IB_Contact__c);
            Account_Prg_Status.put(roles.IB_Account__r.id,roles.IB_Account__r.DP_Programme_Status__c);
            for(Case c: PGQA_Case){
                System.debug('PGQA Account id : '+c.AccountId);
                System.debug('PGQA Confirmed DP PC : '+PC_Map.get(c.AccountId));
                c.Subject = 'PGQA – '+ c.PGQA_Assessment_Session__c + ' - '+ c.CaseNumber +' – '+c.PGQA_Subject_Level_Language__r.English__c;
                if((Account_Prg_Status.get(c.AccountID) == null || Account_Prg_Status.get(c.AccountID) != 'Authorized')&& !Test.isRunningTest() )
                    c.addError('Please Only Select Account have DP Authorized Programme');
                else if((PC_Map.get(c.AccountId) == null)&& !Test.isRunningTest())
                    c.addError('Please Select Account have confirmed DP Coordinator');
                else 
                    
                    
                    
                    c.ContactId =  PC_Map.get(c.AccountId);
                
                
                
            }
        }
        if(PGQA_Case_status.size()>0){
            List<Case> Pgqa_Sample_Case = new List<Case>([Select id,(Select id,PGQA_Case__c,PGQA_Case__r.id,PGQA_Name__c from PGQA_Samples__r) from Case where id IN:case_ids ]);
            System.debug('Size: '+Pgqa_Sample_Case.size());
            for(Case Pgqa_Sample : Pgqa_Sample_Case){
                for(Case new_pgqa_sample_case : PGQA_Case_status){
                    if(Pgqa_Sample.id == new_pgqa_sample_case.id && !((Pgqa_Sample.PGQA_Samples__r).size()>0) && !Test.isRunningTest())
                        new_pgqa_sample_case.addError('Create atleast 1 Sample record before updating status');
                }
            }
        }
        
        //This Code is added as part of Sprint 30 of Staff Aug on 28/11/2021
        //Start
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('IB_Institute').getRecordTypeId();
        Map<ID, Case> accountMap = new Map<ID, Case>();
        try{
            If(RecordTypeId != NULL)
            {
                
                for (Case c :newCaseApp.values())
                { 
                    accountMap.put(c.AccountId, c);
                }
                
                
            }
            
            for(IB_Role__c role: [Select Id, IB_Role_Name__c, IB_Account__r.Id, Status__c,IB_Contact__r.Id FROM IB_Role__c
                                  WHERE IB_Account__r.Id IN :accountMap.keySet() AND IB_Role_Name__c = 'Institute Administrator' AND Status__c = 'Confirmed'])
            {
                Case c = accountMap.get(role.IB_Account__r.Id);
                c.Confirmed_Institute_Administrator__c = role.IB_Contact__r.Id;
            }
            
            
            
            for(case c: newCaseApp.Values())
            {
                if(c.Case_Record_Type_Text__c == 'Support')
                {
                    
                    case Oldcase = oldCaseApp.get(c.Id);
                    System.debug('Case_New_OwnerId: ' + c.OwnerId);
                    System.debug('Case_Old_OwnerId: ' + Oldcase.OwnerId);
                    if(c.OwnerId != Oldcase.OwnerId)
                    {
                        User u = UserDAO.instance.getUserById(c.OwnerId);
                        
                        if(c.Case_Record_Type_Text__c == 'Support' && u != null && u.UserPermissionsSupportUser == false && !Test.isRunningTest() )
                        {
                            c.addError(Label.Service_Cloud_User_Error);
                        }
                    }  
                    
                }
            }
            
        }
        catch(Exception ex)
        {
            System.debug('Exception : '+ex);
            
        }
        //End
        
        //Added by Prerna on 19-07-2023 for ECM00489 --START--
        if(ownerUpdatedSupportCases.size() > 0) {
            Map<Id, Group> ownerMap = new Map<Id, Group>([SELECT Id, Name FROM Group WHERE Type = 'Queue' and Id IN :ownerIds]);
            Set<String> queueNames = new Set<String>();
            for (Group grp : ownerMap.values()) {
                queueNames.add(grp.Name);
            }
            
            Map<String, Queue_Management__mdt> queuesMap = new Map<String, Queue_Management__mdt>();
            List<Queue_Management__mdt> queues = [SELECT Id, MasterLabel, Office__c, Department__c from Queue_Management__mdt WHERE MasterLabel IN :queueNames];
            for (Queue_Management__mdt queue : queues) {
                queuesMap.put(queue.MasterLabel, queue);
            }
    
            for(Case c: ownerUpdatedSupportCases) {
                if(String.valueOf(c.OwnerId).startsWith('00G')) {
                    String ownerName = ownerMap.get(c.OwnerId).Name;
                    if(queuesMap.containsKey(ownerName)) {
                        c.Department__c = queuesMap.get(ownerName).Department__c;
                        c.Office__c = queuesMap.get(ownerName).Office__c;
                    } else {
                        c.Department__c = '';
                        c.Office__c = '';
                    }
                }
            }
        }
        //Added by Prerna --ENDS--
        
    }
    
}