//Class created by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -----
    public with sharing class Non_IB_CodeBeforeInsertTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
            process(tp.newList);
        }
    }
    //Method written by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -- START --
    // This Method will populate the map if programme is selcted by user
    //Also this will auto-populate the Related Account 
    public static void process(List<Non_IB_Code__c> newList) {
        Map<Id, Non_IB_Code__c> mapProgramIdVsNonIBCode = new Map<Id, Non_IB_Code__c>();
        
        for(Non_IB_Code__c nonIbCode : newList) {
            if(nonIbCode.Related_to_IB_Programme_1__c != null) {
                mapProgramIdVsNonIBCode.put(nonIbCode.Related_to_IB_Programme_1__c, nonIbCode);
            }
            if(nonIbCode.Related_to_IB_Programme_2__c != null) {
                mapProgramIdVsNonIBCode.put(nonIbCode.Related_to_IB_Programme_2__c, nonIbCode);
            }
            if(nonIbCode.Related_to_IB_Programme_3__c != null) {
                mapProgramIdVsNonIBCode.put(nonIbCode.Related_to_IB_Programme_3__c, nonIbCode);
            }
            if(nonIbCode.Related_to_IB_Programme_4__c != null) {
                mapProgramIdVsNonIBCode.put(nonIbCode.Related_to_IB_Programme_4__c, nonIbCode);
            }
        }

        if(!mapProgramIdVsNonIBCode.isEmpty()){
            //check for the duplicate code name on create of a non-ib code
            Non_IB_Code_TriggerHelper.checkForDuplicates(mapProgramIdVsNonIBCode);

            //This is auto-populate the Related Account of a programme on Non-IB Code
            for(IB_Programme__c program : [SELECT Id, Name, Account__c 
                                            FROM IB_Programme__c 
                                            WHERE Id IN: mapProgramIdVsNonIBCode.keyset()]) {
                if(mapProgramIdVsNonIBCode.get(program.Id).Related_to_IB_Account__c == null) {
                    mapProgramIdVsNonIBCode.get(program.Id).Related_to_IB_Account__c = program.Account__c;
                } else if(mapProgramIdVsNonIBCode.get(program.Id).Related_to_IB_Account__c != program.Account__c) {
                    mapProgramIdVsNonIBCode.get(program.Id).addError('Programmes from different Accounts cannot be selected');
                }
            }
        }

    }
    //Method written by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -- END --
}