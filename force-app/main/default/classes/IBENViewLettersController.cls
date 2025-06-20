public class IBENViewLettersController {//Extending for userLanguageKey
    
    public IB_Application__c application {get;set;}
    @TestVisible public IB_Programme__c programme {get;private set;}
    public List<IB_Application_Attachment__c> appAttachments {get;set;}
    
    public IBENViewLettersController(){
        try
        {
            
            String progId = ApexPages.currentPage().getParameters().get('id');
            
            if (progId == null) {
                throw new CustomValidationException(Label.PIMS_INVALID_APPID);
            }
            
            ProgrammeService.setProgrammeId(progId);
            programme = ProgrammeService.getProgramme();
            
            ApplicationAttachmentService.setProgrammeId(programme.Id);
            appAttachments = ApplicationAttachmentService.getCandidacyResponseLetters();
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
}