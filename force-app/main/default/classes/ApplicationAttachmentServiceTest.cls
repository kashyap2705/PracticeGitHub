@isTest
private class ApplicationAttachmentServiceTest {
    
       @isTest
    static void ApplicationAttachmentServiceTestMethod()
    {
        
        ApplicationAttachmentService.isCached=NULL;
        ApplicationAttachmentService.attachments=NULL;
        ApplicationAttachmentService.programmeId=NULL;
        ApplicationAttachmentService.isCached=true;
        ApplicationAttachmentService.getPublishedApplicationAttachments();
        ApplicationAttachmentService.getCandidacyResponseLetters();
        ApplicationAttachmentService.getCourseOutlines();
        ApplicationAttachmentService.queryApplicationAttachementsByProgId();
        ApplicationAttachmentService.getApplicationAttachmentsByStage(NULL);
        ApplicationAttachmentService.setProgrammeId(NULL);
        ApplicationAttachmentService.isCached=false;
          ApplicationAttachmentService.getPublishedApplicationAttachments();
        ApplicationAttachmentService.isCached=false;
        ApplicationAttachmentService.getCandidacyResponseLetters();
        ApplicationAttachmentService.isCached=false;
        ApplicationAttachmentService.getCourseOutlines();
        ApplicationAttachmentService.isCached=false;
        //ApplicationAttachmentService.queryApplicationAttachementsByProgId();
        ApplicationAttachmentService.getApplicationAttachmentsByStage(NULL);
        ApplicationAttachmentService.isCached=false;
        ApplicationAttachmentService.setProgrammeId(NULL);
    }

}