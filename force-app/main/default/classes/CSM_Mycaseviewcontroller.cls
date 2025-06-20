public without sharing class CSM_Mycaseviewcontroller {
    @AuraEnabled(cacheable=true)
    public static list<ContentVersion> getAttachments(string caseId) {
        List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId, LinkedEntityId 
                                                         FROM   ContentDocumentLink 
                                                         WHERE  LinkedEntityId =: caseId WITH SYSTEM_MODE];
        Set<Id> contentDocumentId = new Set<Id>();
        for(ContentDocumentLink cdl : contentDocumentList){
            contentDocumentId.add(cdl.ContentDocumentId);
        }
        List<ContentVersion> contentVersionList = [SELECT Id, VersionData, FileType, Title, FileExtension,
                                                   ContentDocument.CreatedBy.Name, ContentDocument.ContentSize,
                                                   CreatedDate, ContentDocumentId, ContentDocument.FileType
                                                   FROM   ContentVersion 
                                                   WHERE  ContentDocumentId IN : contentDocumentId WITH SYSTEM_MODE];
        return contentVersionList;
    }

    @AuraEnabled(cacheable=true)
    public static IB_Role_Repository__c getUserRolesMap(String roleName) {
        IB_Role_Repository__c ibRole;
        try {
            ibRole = [select id, Role_Name__c, Role_Name_es__c, Role_Name_fr__c from IB_Role_Repository__c where Role_Name__c=:roleName];    
        } 
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return ibRole;
    }
}