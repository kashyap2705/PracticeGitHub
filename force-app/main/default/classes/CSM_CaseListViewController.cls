/**
 * @description       : Controller for the Case List View component
 * @author            : Charan Kumar
 * @last modified on  : 03-22-2024
 * @last modified by  : Charan Kumar
 **/
public with sharing class CSM_CaseListViewController {
    /**
     * @description : Method to get the logged in user cases
     * @author      : Charan Kumar | 03-21-2024
     * @return      : List<Case>
     **/
    @AuraEnabled
    public static List<Case> getUserCases() {
        Id userId = UserInfo.getUserId();
        List<Case> cases = new List<Case>();
        List<String> ownerNames = new List<String>();
        try {
            List<IB_Answers__mdt> excludedOwnersList = [SELECT value__c FROM IB_Answers__mdt
                                                        WHERE Name__c = :CSM_IboUtil.EXCLUDED_OWNERS_NAME
                                                        LIMIT 1];
            if (excludedOwnersList.size() > 0) {
                IB_Answers__mdt excludedOwners = excludedOwnersList[0];
                if (excludedOwners != null && excludedOwners.value__c != null) {
                    ownerNames = excludedOwners.value__c.split(';');
                }
            }

            for (Case c : [SELECT Id, CaseNumber, CreatedDate, Web_Category_Level_1__c, Description, Status, IsClosed
                           FROM Case
                           WHERE Contact.User__c = :userId
                           AND Owner.Name NOT IN :ownerNames
                           AND RecordType.Name = :CSM_IboUtil.CASE_SUPPORT_RECORD_TYPE]) {
                cases.add(c);
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return cases;
    }

    /**
     * @description : Method to get the category1 records
     * @author Charan Kumar | 03-21-2024
     * @return Map<String, Category1__c>
     **/
    @AuraEnabled(cacheable=true)
    public static Map<String, Category1__c> getCategories() {
        Map<String, Category1__c> categoryMap = new Map<String, Category1__c>();
        try {
            List<Category1__c> category1 = [SELECT Name, Label__c, French_Name__c, Spanish_Name__c FROM Category1__c];
            for (Category1__c category : category1) {
                categoryMap.put(category.Name, category);
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        return categoryMap;
    }
}