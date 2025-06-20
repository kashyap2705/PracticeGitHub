public class BqcMypMySchoolController {
    public   Campaign mypEvent{get; set;}
    public  Campaign mypEvent_Eng;
    public   Account account ;
    public   List<Campaign> mypchildeventslist{get; set;}
    public  List<IB_Application_Attachment__c> attachments{get; set;}
    public   String description { get; set; }
    public   String fileName { get; set; }
    public   Blob fileBody { get; set; }
    public   String docType { get; set; }   
    public  IB_Programme__c programme ;
    public   Id subjectId { get; set; }
    public    Id EventId { get; set; }
    public   String UnitPlan { get; set; }
    public   String deleteAppDocId { get; set; }
    public   boolean checkStatus;
    public   string redirectUrl{get;set;}
    public   string Subject_Name{get;set;}
    @testvisible private Set<String> fileformat = new Set<String> {'.doc','.docx','.pdf'};
        public BqcMypMySchoolController() {
            try{
                attachments = new List<IB_Application_Attachment__c>();
                PimsCommunityService pimsService = new PimsCommunityService();
                pimsService.initUserData();
                account = pimsService.getCurrentAccount();
                if(account != null){ 
                    programme = [Select id,StageName__c from IB_Programme__c where Account__c=:account.id And name like '%MYP%' Limit 1];
                    /***Queries are updated by Ammara-Plumlogix as part of INC0150184,Staff-Aug Project(Sprint 27)*/
                    /***Add the Status Conditions for Parent Event
/***Begin***/
                    mypEvent = [Select id,Name,BQC_Subject__c,BQC_Status__c from campaign 
                                where Sub_Type__c ='BQC Event' AND Related_IB_Programme__c =:programme.id AND name like '%BQC%' AND ParentId=null 
                                AND Status != 'Cancelled' AND Status != 'Complete' AND Status != 'Postponed' Limit 1];
                    
                    System.debug('ID----- '+mypEvent.id+' Programme: '+programme.id);
                    
                    mypchildeventslist = [Select id,BQC_Subject_Spanish__c, BQC_Subject_French__c, Unit_Plan_Spanish__c, Unit_Plan_French__c,BQC_Subject__c,BQC_Status__c,Unit_Plan__c,Name from Campaign where ParentID =: mypEvent.id AND Status != 'Cancelled' AND Status != 'Complete' AND Status != 'Postponed' order by Name, Unit_Plan__c];
                    
                    attachments = [Select id,Name,Unit_Plan__c,Attachment__c,Type__c,BQC_Subject__c from IB_Application_Attachment__c where IB_Programme__c=: programme.id AND (Type__c = 'Unit Plan' OR Type__c = 'Self-assessment') AND Event_Cancelled_Postponed__c = false];
                    /**End**/
                    System.debug('Attachment Size: '+attachments.size());
                }
            }
            Catch(Exception ex){
                System.debug('Exception: '+ex);
            }
        }
    public boolean getcheckStatus(){
        if(mypEvent.BQC_Status__c == 'Pending Document Submission' )
        {
            checkStatus = true;
        }
        else
        {
            checkStatus = false;
        }     
        return checkstatus;
    }
    public void submit(){
        List<Campaign> record_to_be_updated = new List<Campaign>();
        try {
            mypEvent.BQC_Status__c = 'Document Submitted';
            record_to_be_updated.add(mypEvent);
            Database.update(record_to_be_updated);
            checkStatus = false;
            redirectUrl='pims/PimsDashboard';
        }
        catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    /**
* Upload process is:
*  1. Insert new IB_Application_Attachment__c record
*  2. Insert new Attachment with the new IB_Application_Attachment__c record as parent
*  3. Update the IB_Application_Attachment__c record with the ID of the new Attachment
**/
    public PageReference upload() {
        
        try {
            Integer fileSize = fileBody.size();
            string fileextenion ;
            boolean wrongFileextension = true;
            System.debug('fileSize: '+ fileSize);
            System.debug('Subject Name: ' + Subject_Name);
            System.debug('description: ' + description);
            System.debug('unitplan: ' + UnitPlan);
            System.debug('fileName: ' + fileName);
            System.debug('fileBody: ' + fileBody);
            System.debug('docType: ' + docType);
            for( String ext : fileformat) {
                if( this.fileName.endsWith(ext) ) {
                    fileextenion = ext;
                    wrongFileextension = false;
                    break;
                }
            }
            if( wrongFileextension ) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.BQC_Document + ' ' + this.fileName));
                return null;
            }
            else {
                Database.SaveResult customAttachmentResult = saveCustomAttachment(docType,UnitPlan);
                
                if (customAttachmentResult == null || !customAttachmentResult.isSuccess()) {
                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                    return null;
                    
                }
                
                Database.SaveResult attachmentResult = saveStandardAttachment(customAttachmentResult.getId());
                
                if (attachmentResult == null || !attachmentResult.isSuccess()) {
                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Save_Attachment));
                    return null;
                    
                }
                else {
                    // update the custom attachment record with some attachment info
                    String attachment_name = Subject_Name+' '+UnitPlan+' '+docType+fileextenion;
                    attachment_name=attachment_name.replaceAll(' ','_');
                    attachment_name=attachment_name.replaceAll('-','_');
                    System.debug('Attachment Name: '+attachment_name);
                    IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                    customAttachment.name = this.fileName;
                    customAttachment.Attachment__c = attachmentResult.getId();
                    update customAttachment;
                    // if(!Test.isRunningTest()) {
                    // remove existing course outlines for this subject
                    List<IB_Application_Attachment__c> toDelete = [
                        SELECT Id 
                        FROM IB_Application_Attachment__c 
                        WHERE IB_Programme__c = :programme.Id 
                        AND BQC_Subject__c = :Subject_Name
                        AND Type__c =: docType
                        AND Unit_Plan__c =: UnitPlan
                        AND Id != :customAttachmentResult.getId()
                    ];
                    
                    if (toDelete.size() > 0) {
                        delete toDelete;
                        // }
                    }
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.File_Uploaded));
                    redirectUrl='/pims/PimsBQCMYP';
                    
                }
                
                
            }            
            
        } catch (DMLException e) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Uploading));
            return null;
            
        } catch (Exception e) {
            
            String msg = e.getMessage();
            
            if (msg == 'Argument cannot be null.') {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.File_Upload));
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Uploading +e));
            }
            return null;
        }
        
        return null;
    }
    
    // creates a new IB_Application_Attachment__c record
    @testVisible
    private Database.SaveResult saveCustomAttachment(String documentType,String UnitPlan) {
        try
        {
            IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
            obj.IB_Programme__c = programme.Id;
            if (description != null && description != '') 
                obj.Description__c = description;
            obj.Type__c = documentType;
            obj.Unit_Plan__c = UnitPlan;
            obj.Category__c = programme.StageName__c;
            obj.BQC_Subject__c = Subject_Name;
            obj.Uploaded_By__c = UserInfo.getUserId();
            
            return Database.insert(obj);
            
        }
        catch(exception x)
        {
            system.debug('exception occurred saveCustomAttachment '+x);
            return NULL;
        }
        
    }
    
    // create an actual Attachment record with the IB_Application_Attachment__c as parent
    @testVisible
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        try
        {
            Database.SaveResult result;
            
            Attachment newFile = new Attachment();
            newFile.body = this.fileBody;
            newFile.name = this.fileName;
            newFile.parentId = parentId;
            
            // insert the attahcment
            result = Database.insert(newFile);
            
            // reset the file for the view state
            fileBody = Blob.valueOf(' ');
            
            return result;
        }
        
        catch(exception x)
        {
            system.debug('exception occurred save standard attachment '+x);
            return NULL;
        }
    }
    public PageReference removeAppDocument() {
        
        try {
            
            IB_Application_Attachment__c docToRemove = new IB_Application_Attachment__c();
            docToRemove.Id = deleteAppDocId;
            
            delete docToRemove;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Document_Delete));
            redirectUrl='/pims/PimsBQCMYP';
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            return null;
            
        }
        
        return null;
        
    }
    public String getLocale() {
        return UserInfo.getLanguage();
    }
}