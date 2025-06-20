public class ContentDocumentTriggerHandler {
    public static void processFileDeletion(List<ContentDocument> cdList){
        Set<Id> cdSet = new Set<Id>();
        Set<Id> delRecords = new Set<Id>();
        for(ContentDocument cd : cdList){
            cdSet.add(cd.Id);
        }
        for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId IN: cdSet]){
            if(String.valueOf(cdl.linkedEntityId).startsWith(SchemaGlobalDescribe.findRecordIdPrefixFromObjectName('IB_Consultant_Feedback__c'))){
                delRecords.add(cdl.ContentDocumentId);
            }
        }        
        
        if(delRecords.size() >0){
            delete ([SELECT ID FROM IB_Application_Attachment__c 
                     WHERE Attachment__c IN: delRecords]);            
        }           
    }
}