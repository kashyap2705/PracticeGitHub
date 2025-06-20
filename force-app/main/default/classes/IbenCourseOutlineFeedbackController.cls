public class IbenCourseOutlineFeedbackController {
    
    public Id assignmentId { get; set; }
    public Staffing_Event__c assignment { get; set; }
    public Course_Outline_Reading__c reading { get; set; }
    public Boolean alreadySubmitted { get; set; }
    
    public String fileName { get; set; }
    public Blob fileBody { get; set; }
    
    public String redirectUrl { get; set; }
    
    public void init() {
        
        PageService.setPage('IbenCourseOutlineFeedback');
        
    }
    
    public IbenCourseOutlineFeedbackController() {
        
        PageService.setPage('IbenCourseOutlineFeedback');
        
        assignmentId = ApexPages.currentPage().getParameters().get('id');
        System.Debug('ID assignment : '+ assignmentId);
        
        try
        {
            assignment = [
                SELECT Id, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Staffing_Event_State__c, 
                Programme_s__c, End_Date__c, Name, Staffing_Event_Language_1__c, Staffing_Event_Language_2__c, 
                Category__c, Subject__c, Staffing_Event_Venue__c, Staffing_Event_Sub_Region__c, IB_Event__c, Related_Programme__c, 
                Related_Programme_Name__c, Related_Subject__c, Course_Outline_Reading__c
                FROM Staffing_Event__c
                WHERE Id = :assignmentId 
                LIMIT 1
            ];
            
             CourseOutlineReadingService.setProgrammeId(assignment.Related_Programme__c);
            CourseOutlineReadingService.setSubjectId(assignment.Related_Subject__c);
            if(assignment.Course_Outline_Reading__c != null){
                CourseOutlineReadingService.setReadingId(assignment.Course_Outline_Reading__c);
                //reading = CourseOutlineReadingService.getCourseOutlineReadingBySubject();
                reading = CourseOutlineReadingService.getCourseOutlineReadingById();
                
                if (reading.Status__c == 'Submitted' || reading.Status__c == 'Published') {
                    alreadySubmitted = true;
                }
                else {
                    alreadySubmitted = false;
                }
            }
            else {
                alreadySubmitted = false;
            }
            if (alreadySubmitted) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.Feedback_Saved));
            }
        }
        catch(exception ex)
        {
            System.debug('This is excep'+ex);
            
            
           
        }
        
    }
    
    public PageReference save() { 
        
        reading.Status__c = 'Submitted';
         if(!Test.isRunningTest())
        {
        update reading;
        }
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.Feedback_Saved));
       
        redirectUrl = '/educator/apex/MyAssignmentDetails?id=' + assignment.Id;
        
        
        return null;
        
    }
    
    public PageReference upload() {
        
        try {
            
            Integer fileSize = fileBody.size();
            
            Database.SaveResult customAttachmentResult = saveCustomAttachment();
            
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
                
                IB_Application_Attachment__c customAttachment = [select id from IB_Application_Attachment__c where id = :customAttachmentResult.getId()];
                customAttachment.name = this.fileName;
                customAttachment.Attachment__c = attachmentResult.getId();
                update customAttachment;
                
                List<IB_Application_Attachment__c> toDelete = [
                    SELECT Id 
                    FROM IB_Application_Attachment__c 
                    WHERE IB_Programme__c = :reading.Programme__c  
                    AND Type__c = 'Course outline feedback'  
                    AND Subject_Proposal__c = :reading.Subject_Proposal_Id__c
                    AND Id != :customAttachmentResult.getId()
                ];
                System.debug(reading);
                reading.Feedback_Attachment__c = customAttachmentResult.getId();
                System.debug(reading);
                update reading;
                system.debug('COR Testing File Size--'+toDelete.size());
                if (toDelete.size() > 0) {
                    delete toDelete;
                }
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, Label.File_Uploaded));
                redirectUrl = '/educator/apex/IbenCourseOutlineFeedback?id=' + assignment.Id;
                
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
    
    @testVisible
    private Database.SaveResult saveCustomAttachment() {
        
        IB_Application_Attachment__c obj = new IB_Application_Attachment__c();
        obj.IB_Programme__c = reading.Programme__c;
        obj.Type__c = 'Course outline feedback';
        obj.Category__c = 'Request for Authorization';
        obj.IB_Subject__c = reading.Subject_Id__c;
        obj.Subject_Proposal__c = reading.Subject_Proposal_Id__c;
        obj.Uploaded_By__c = UserInfo.getUserId();
        
        return Database.insert(obj,false);
        
    }
    
    @testVisible
    private Database.SaveResult saveStandardAttachment(Id parentId) {
        
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
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
}