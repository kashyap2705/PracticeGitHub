/**
* Project:     PSP 2020
* Created By:  Dilip Kumar
*
**************************************************************************************
* Description:  Class for Custom Label Dynamic Functionality
**************************************************************************************
*/
public without sharing class CustomLabelController {
    @AuraEnabled (cacheable=true)
    public static list<CustomLabel__c> getLabels(String section, String language)
    {
        Map<String, String> mapCustomLabelToValue = new Map<String, String>();
        String userLanguage;
        if (language == 'American English' || language == 'French' || language == 'Spanish') {
            userLanguage = language;
        } else {
            userLanguage = 'American English';
        }
        
        list<CustomLabel__c> customlabels = [SELECT Id, Label__c, Group__c,
                                             (SELECT Id, CustomLabel__c, Language__c,Value__c
                                              FROM Translations__r
                                              WHERE Language__c =:userLanguage)
                                             FROM CustomLabel__c
                                             WHERE Group__c=:section];
        
        if (!customlabels.isEmpty()) {
            return customlabels;
        } else {
            return null;
        }  
    }
}