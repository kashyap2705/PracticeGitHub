public without sharing class AttachmentsDAO {
    
    public static final AttachmentsDAO INSTANCE = new AttachmentsDAO();
    
    private AttachmentsDAO() {
    
    }
    
    public Attachment getAttachmentsbyId(String Id) {
        
        if ( String.isBlank(Id)) {
            
            throw new DAOException('The ID cannot be zero or an empty string.');
        } 
        
        final List<Attachment> result = [ Select a.id, a.ParentId, a.Name, a.ContentType, a.BodyLength, a.description From Attachment a where a.Id =: Id ];
        
        if (null == result || result.isEmpty()) {
            return null;
        }
                
        return result.get(0);
        
    } 
    
    public List<Attachment> getAttachmentsbyParentId(String parentId) {
        
        if ( String.isBlank(parentId)) {
            
            throw new DAOException('The Parent ID cannot be zero or an empty string.');
        } 
        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        List<Attachment> attachments = [ Select a.ParentId, a.Name, a.ContentType, a.BodyLength, a.description From Attachment a where a.ParentId =: parentId ];
        System.debug(LoggingLevel.ERROR, 'Heap Size: ' + Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
        for(Attachment a:attachments){
            a.body = null;
        }

        return attachments;
    }

    public static String getProfilePhoto(String parentId) {

        String response = '';
        
        if ( String.isBlank(parentId)) {
            
            throw new DAOException('The Parent ID cannot be zero or an empty string.');
        } 
        
        try{
            Attachment attachments = [ Select a.ParentId, a.Name, a.ContentType, a.BodyLength, a.body, a.description From Attachment a where a.ParentId =: parentId and a.description = 'profile photo' LIMIT 1];
            response = System.EncodingUtil.base64Encode(attachments.body);
        } catch (Exception e){}
    
        return response;
    }      
    
}