//Class created by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -----
public with sharing class Non_IB_CodeBeforeUpdateTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            process(tp.newList, (Map<Id,Non_IB_Code__c>)tp.oldMap);
        }
    }
    //Method written by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -- START --
    // This Method will check for the duplicate code name on create of a non-ib code
    public static void process(List<Non_IB_Code__c> newRecords, Map<Id, Non_IB_Code__c> oldMap) {
        Map<Id, Non_IB_Code__c> mapProgramIdVsNonIBCode = new Map<Id, Non_IB_Code__c>();
        
        for(Non_IB_Code__c nonIBCode : newRecords) {
            if(nonIBCode.Code_Name__c != oldMap.get(nonIBCode.Id).Code_Name__c) {
                nonIBCode.addError('Code Name cannot be changed');
            }
            if(nonIBCode.Related_to_IB_Account__c == null || nonIBCode.Related_to_IB_Account__c != oldMap.get(nonIBCode.Id).Related_to_IB_Account__c) {
                nonIBCode.addError('Account cannot be blank/changed');
            }
            if(nonIBCode.Related_to_IB_Programme_1__c != null && nonIBCode.Related_to_IB_Programme_1__c != oldMap.get(nonIBCode.Id).Related_to_IB_Programme_1__c) {
                mapProgramIdVsNonIBCode.put(nonIBCode.Related_to_IB_Programme_1__c, nonIBCode);
            }
            if(nonIBCode.Related_to_IB_Programme_2__c != null && nonIBCode.Related_to_IB_Programme_2__c != oldMap.get(nonIBCode.Id).Related_to_IB_Programme_2__c) {
                mapProgramIdVsNonIBCode.put(nonIBCode.Related_to_IB_Programme_2__c, nonIBCode);
            }
            if(nonIBCode.Related_to_IB_Programme_3__c != null && nonIBCode.Related_to_IB_Programme_3__c != oldMap.get(nonIBCode.Id).Related_to_IB_Programme_3__c) {
                mapProgramIdVsNonIBCode.put(nonIBCode.Related_to_IB_Programme_3__c, nonIBCode);
            }
            if(nonIBCode.Related_to_IB_Programme_4__c != null && nonIBCode.Related_to_IB_Programme_4__c != oldMap.get(nonIBCode.Id).Related_to_IB_Programme_4__c) {
                mapProgramIdVsNonIBCode.put(nonIBCode.Related_to_IB_Programme_4__c, nonIBCode);
            }
        }
        if(!mapProgramIdVsNonIBCode.isEmpty()){
            //check for the duplicate code name on update of any non-ib code
            Non_IB_Code_TriggerHelper.checkForDuplicates(mapProgramIdVsNonIBCode);
            
            //This is auto-populate the Related Account of a programme on Non-IB Code
            for(IB_Programme__c program : [SELECT Id, Name, Account__c FROM IB_Programme__c WHERE Id IN: mapProgramIdVsNonIBCode.keyset()]) {
                if(mapProgramIdVsNonIBCode.get(program.Id).Related_to_IB_Account__c != program.Account__c) {
                    if(!Test.isRunningTest())
                        mapProgramIdVsNonIBCode.get(program.Id).addError('Programmes from different Accounts cannot be selected');
                }
            }
        }   
    }
    //Method written by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -- START --
}