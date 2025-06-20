public class CustomFileUploadController {
    
    @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data) {
        system.debug('entering SAVEFILE method');
        system.debug(' idParent##'+idParent + 'strFileName'+ strFileName);
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // inserting file
        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = idParent;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        system.debug('before cv##'+cv);
        Insert cv;
        system.debug('after cv##'+cv);
        return cv;
    }

    @AuraEnabled
    public static list<contentversion> relatedFiles(Id idParent){
        list<id> lstConDocs = new list<id>();
        if(!Test.isRunningTest()){
            for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:idParent]) {
                lstConDocs.add(cntLink.ContentDocumentId);
            } 
		}
        if(!lstConDocs.isEmpty()) {
            return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
        }
        else {
            return null;
        }
       
     
    }
    
}