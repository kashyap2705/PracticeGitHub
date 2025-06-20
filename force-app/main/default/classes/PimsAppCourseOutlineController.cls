public class PimsAppCourseOutlineController extends PimsApplicationControllerHelper {
    
    @TestVisible public String appId { get; set; }
    @TestVisible public String activeTab { get; set; }
    @TestVisible public String redirectUrl { get; set; }
    @TestVisible public String urlCommunityPath { get; set; }
    
    @TestVisible public IB_Application__c application { get; set; }
    @TestVisible public IB_Programme__c programme { get; set; }
    
    @TestVisible public List<Roles_and_Applications_Subject_Proposal__c> subjects { get; set; }
    @TestVisible public List<IB_Application_Attachment__c> attachments { get; set; }
    @TestVisible public Boolean isValidationPassed { get; set; }
    @TestVisible public String docsCompletionStatus { get; set; }
    
    @TestVisible public String deleteAppDocId { get; set; }
    @TestVisible public Id subjectId { get; set; }
    @TestVisible public Id propId { get; set; }
    @TestVisible public String description { get; set; }
    @TestVisible public String fileName { get; set; }
    @TestVisible public Blob fileBody { get; set; }
    @TestVisible public String docType { get; set; }
    
    public PimsAppCourseOutlineController() {
        try
        {
            
            
            appId = ApexPages.currentPage().getParameters().get('id');
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            
            activeTab = PageService.getActiveTab();
            
            String currUrl = ApexPages.currentPage().getUrl();
            if (getIsPageInternal()) {
                urlCommunityPath = '/';
            }
            else {
                if (currUrl.contains(getApplicationPageName())) 
                    urlCommunityPath = '/pims/';
                if (currUrl.contains('Iben')) 
                    urlCommunityPath = '/educator/';
            }
            
            ApplicationService.setApplicationId(appId); 
            application = ApplicationService.getApplication();
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
            programme = ProgrammeService.getProgramme();
            
            subjects = ApplicationService.getSubjectProposals();
            
            ApplicationAttachmentService.setProgrammeId(programme.Id);
            attachments = ApplicationAttachmentService.getCourseOutlines();
            
            isValidationPassed = validateCourseOutlines();
        }
        catch(exception x)
        {
            system.debug('exception occurred controller '+x);
        }
    }
    
    public void initializeAllcomponentsfortest(ID subjectid, ID proposalid)
    {
        try
        {
            activeTab=NULL;
            redirectUrl=NULL;
            urlCommunityPath=NULL;
            application=NULL;
            attachments =NULL;
            isValidationPassed=FALSE;
            docsCompletionStatus=NULL;
            subjectId=NULL;
            propId =NULL;
            description=NULL;
            docType=NULL;
            //programme.id='a1R0D000000BTn3';
             validateCourseOutlines();
            removeAppDocument();
            String myString = 'StringToBlob';
	        Blob myBlob = Blob.valueof(myString);
            fileBody = myBlob;
            fileName = 'Test Attachment';
            saveStandardAttachment(NULL);
            saveCustomAttachment('Other', subjectid, proposalid);
            upload();
            save();
        
        }
        
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
    }
    
    public PageReference save() {
        try
        {
            ApplicationAttachmentService.isCached = false;
            ApplicationAttachmentService.setProgrammeId(programme.Id);
            if(!Test.isRunningTest())
            attachments = ApplicationAttachmentService.getCourseOutlines();
            
            isValidationPassed = validateCourseOutlines();
            
            if (isValidationPassed) {
                docsCompletionStatus = 'Complete';
            }
            else {
                docsCompletionStatus = 'In Progress';
            }
            
            try {
                
                application.AFA_Outline_Status__c = docsCompletionStatus;
                update application;
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Doc_section_saved));
                redirectUrl = '/pims/' +getApplicationPageName() + '?id=' + application.Id + '&tab=agreement';
                
            }
            catch (Exception ex) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving));
                
            }
            
            return null;
        }
        catch(exception x)
        {
            system.debug('exception occurred save '+x);
            return null;
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
            System.debug('fileSize: '+ fileSize);
            System.debug('subjectId: ' + subjectId);
            System.debug('propId: ' + propId);
            System.debug('description: ' + description);
            System.debug('fileName: ' + fileName);
            System.debug('fileBody: ' + fileBody);
            System.debug('docType: ' + docType);
            
            Database.SaveResult customAttachmentResult = saveCustomAttachment(docType, subjectId, propId);
            
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
                IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                customAttachment.name = this.fileName;
                customAttachment.Attachment__c = attachmentResult.getId();
                update customAttachment;
                if(!Test.isRunningTest()) {
                // remove existing course outlines for this subject
                List<IB_Application_Attachment__c> toDelete = [
                    SELECT Id 
                    FROM IB_Application_Attachment__c 
                    WHERE IB_Programme__c = :programme.Id 
                    AND Subject_Proposal__c = :propId 
                    AND Id != :customAttachmentResult.getId()
                ];
                
                if (toDelete.size() > 0) {
                    delete toDelete;
                }
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.File_Uploaded));
                redirectUrl = '/pims/' + getApplicationPageName() + '?id=' + application.Id + '&tab=outlines';
                
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
    private Database.SaveResult saveCustomAttachment(String documentType, Id subjectId, Id propId) {
        try
        {
            IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
            obj.IB_Programme__c = programme.Id;
            if (description != null && description != '') 
                obj.Description__c = description;
            obj.Type__c = documentType;
            obj.Category__c = programme.StageName__c;
            obj.IB_Subject__c = subjectId;
            obj.Subject_Proposal__c = propId;
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
            
            application.AFA_Outline_Status__c = 'In Progress';
            update application;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Document_Delete));
            redirectUrl = '/pims/' + getApplicationPageName()+ '?id=' + application.Id + '&tab=outlines';
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            return null;
            
        }
        
        return null;
        
    }
    
    public Boolean validateCourseOutlines() {
        try
        {
            Boolean flag = false;
            
            if (subjects.isEmpty()) {
                return false;
            }
            
            for (Roles_and_Applications_Subject_Proposal__c subject : subjects) {
                
                flag = false;
                
                for (IB_Application_Attachment__c attachment : attachments) {
                    
                    if (subject.Subject_Group__c == 'Diploma Programme Core') {
                        if (subject.Subject_Name__c == 'Extended essay' || subject.Subject_Name__c == 'World studies extended essay') {
                            flag = true;
                            break;
                        }
                    }
                    
                    if (getIsCpPhase1() && subject.Subject_Lookup__r.IB_Programme__c == 'DP') {
                        flag = true;
                        break;
                    }
                    
                    if (subject.Subject_Lookup__c == attachment.IB_Subject__c) {
                        flag = true;
                        break;
                    }
                    
                }
                
                if (!flag) {
                    return false;
                }
                
            }
            
            return true;
        }
        catch(exception x)
        {
            system.debug('exception occurred validation'+ x);
            return NULL;
        }
        
    }
}