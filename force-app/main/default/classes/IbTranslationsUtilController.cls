public with sharing class IbTranslationsUtilController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Map<String,String>> getTranslationsMap(String projectName) {
        Map<String, Map<String,String>> translationsMap = new Map<String, Map<String,String>>();
        try {
            List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c WHERE CustomLabel__r.Project__r.Name = :projectName];
            for (Translation__c translation : translations) {
                if (!translationsMap.containsKey(translation.CustomLabel__r.Label__c)) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, new Map<String, String>());
                }
                translationsMap.get(translation.CustomLabel__r.Label__c).put(translation.Language__c, translation.Value__c);
            } 
        }
        catch (Exception ex) {
            Logger.get().add(ex, LogSeverity.ERROR).publish(); 
        }
        return translationsMap;
    }
}