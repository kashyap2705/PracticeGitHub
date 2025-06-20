public with sharing class Non_IB_Code_TriggerHelper {
    //Class created by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -----
    //Method is checking for duplicates
    public static void checkForDuplicates(Map<Id, Non_IB_Code__c> mapProgramIdVsNonIBCode) {
        
        for(Non_IB_Code__c code : [SELECT Id, 
                                        Name, 
                                        Code_Name__c, 
                                        Related_to_IB_Programme_1__c, 
                                        Related_to_IB_Programme_2__c,
                                        Related_to_IB_Programme_3__c,
                                        Related_to_IB_Programme_4__c
                                    FROM Non_IB_Code__c 
                                    WHERE Related_to_IB_Programme_1__c IN: mapProgramIdVsNonIBCode.keyset() OR 
                                    Related_to_IB_Programme_2__c IN: mapProgramIdVsNonIBCode.keyset() OR
                                    Related_to_IB_Programme_3__c IN: mapProgramIdVsNonIBCode.keyset() OR
                                    Related_to_IB_Programme_4__c IN: mapProgramIdVsNonIBCode.keyset()]) {
                                        
            if(mapProgramIdVsNonIBCode.containskey(code.Related_to_IB_Programme_1__c)) {
                if(code.Code_Name__c == mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_1__c).Code_Name__c) {
                    mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_1__c).addError('Duplicate record found for CP programme');
                }
            }
            if(mapProgramIdVsNonIBCode.containskey(code.Related_to_IB_Programme_2__c)) {
                if(code.Code_Name__c == mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_2__c).Code_Name__c) {
                    mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_2__c).addError('Duplicate record found for DP programme');
                }
            }
            if(mapProgramIdVsNonIBCode.containskey(code.Related_to_IB_Programme_3__c)) {
                if(code.Code_Name__c == mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_3__c).Code_Name__c) {
                    mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_3__c).addError('Duplicate record found for MYP programme');
                }
            }
            if(mapProgramIdVsNonIBCode.containskey(code.Related_to_IB_Programme_4__c)) {
                if(code.Code_Name__c == mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_4__c).Code_Name__c) {
                    mapProgramIdVsNonIBCode.get(code.Related_to_IB_Programme_4__c).addError('Duplicate record found for PYP programme');
                }
            }
            
        }

    }
}