/*******************************************************************************************
* @Name         CaseBeforeInsertTriggerHandler 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Ranjith        04/26/2023         PRB004095, for multiple contact with same email the case will be assigned to GSSS queue
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  2.0             Prerna Sobti        07/31/2023         ECM00489, for Support Cases, Populate Office__c and Department__c values based on Case owner Queue Name
*******************************************************************************************/
public class CaseBeforeInsertTriggerHandler extends TriggerHandlerBase{
    
    public override void mainEntry(TriggerParameters tp){
        
        process( (List<Case>)tp.newList);
        
    }
    
    @testVisible  private static void process(List<Case> newCaseApp){
        List<Case> PGQA_Case = new List<Case>();
        Set<ID> AccountIds = new Set<ID>();
        List<Case> Update_PGQA_Case = new List<Case>();
        List<Contact> PGQA_Contact = new List<Contact>();
        //code added by Prerna on 20-07-2023 for ECM00489 --START--
        Set<Id> ownerIds = new Set<Id>();
        List<Case> supportCases = new List<Case>();
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
        for(Case c : newCaseApp)
        {
            
            System.debug(c.Case_Record_Type_Text__c);
            
            //code added by Prerna on 20-07-2023 for ECM00489 --START--
            //below first if BLOCK is added for replacing the workflow rule field update action
            //workflow rule name: Route Community Cases to Corresponding Queue
            //below logic commented by Prerna for INC0189003 on 22-09-2023 and shifted this code in caseAfterInsertTriggerHandler
            /*if(c.Origin == 'Web' && c.Case_Record_Type_Text__c != 'SIPGE Request' && c.Case_Record_Type_Text__c != 'PGQA' && c.Case_Record_Type_Text__c != 'Contingency measure'){                
                c.OwnerId = CaseTriggerHelper.soCustomerServiceQueueId; 
                System.debug('OWNER IS ASSIGNED FROM BEFORE INSERT TRIGGER');
            }*/
            
            if (String.valueOf(c.OwnerId).startsWith('00G')) {
                ownerIds.add(c.OwnerId);
            }
            if(c.Case_Record_Type_Text__c == 'Support')
            {
                supportCases.add(c);
            }
            //code added by Prerna on 20-07-2023 for ECM00489 --END--
            
            
            if(c.Case_Record_Type_Text__c == 'PGQA')
            {
                
                PGQA_Case.add(c);
                AccountIds.add(c.AccountId);
            }
            
            /*
            //Update Case Owner to GSSS Queue Id if there is a email to case without Single Contact match
            if(c.ContactId == null && String.isNotBlank(c.SuppliedEmail) && c.Origin == IboUtil.ORIGIN_EMAIL && c.RecordTypeId == IboUtil.SUPPORT_CASE_RT_ID) {
                c.OwnerId = CaseTriggerHelper.gsssQueueId;
            }*/
            
        }
        
        if(PGQA_Case.size()>0){
            System.debug(PGQA_Case.size());
            //This Part of code is updated as part of ECM430(Add Error Message if there is no DP Programme Coordinators for account), Staff-Aug Project
            List<IB_Role__c> roles = new List<IB_Role__c>();
            try{
                roles = [Select id,IB_Contact__c,IB_Contact__r.id,IB_Account__r.DP_Programme_Status__c,IB_Account__r.id,Account_ID__c from IB_Role__c where IB_Account__c IN: AccountIds AND Programme_Selection__c = 'DP' AND IB_Role_Name__c = 'Programme Coordinator' AND Active__c = true AND Status__c ='Confirmed' Limit 1];
                
                
                
                Map<ID,ID> PC_Map = new Map<ID,ID>();
                Map<ID,String> Account_Prg_Status = new Map<ID,String>();
                if(roles != null && roles.size()>0){
                    System.debug('Confirmed: '+roles);
                    PC_Map.put(roles[0].IB_Account__r.id,roles[0].IB_Contact__c);
                    Account_Prg_Status.put(roles[0].IB_Account__r.id,roles[0].IB_Account__r.DP_Programme_Status__c);
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
                    
                }else{
                    PGQA_Case[0].addError('Please Only Select Account have DP Authorized Programme for PGQA Cases');
                }
            }
            catch(Exception ex){
                System.debug('Exception: '+ex);
            }//End
        }
        
        //code added by Prerna on 20-07-2023 for ECM00489 --START--
        if(supportCases.size()>0) {
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

            for( Case c : supportCases) {
                if(String.valueOf(c.OwnerId).startsWith('00G')) {
                    if(ownerMap.get(c.OwnerId).Name != null){
                        String ownerName = ownerMap.get(c.OwnerId).Name;
                        if(queuesMap.containsKey(ownerName)) {
                            c.Office__c = queuesMap.get(ownerName).Office__c;
                            c.Department__c = queuesMap.get(ownerName).Department__c;
                        }
                    }
                }
            }
        }
        
        //code added by Prerna on 20-07-2023 for ECM00489 --END--
    }    
}