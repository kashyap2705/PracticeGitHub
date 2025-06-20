public class PimsAppSchoolDescController extends PimsApplicationControllerHelper {
    
    public String appId { get; set; }
    public String activeTab { get; set; }
    public String redirectUrl { get; set; }
    public String sdCompletionStatus { get; set; }
    
    public IB_Application__c application { get; set; }
    public IB_Programme__c programme { get; set; }
    
    public PimsAppSchoolDescController() {
        try
        {
            
            appId = ApexPages.currentPage().getParameters().get('id');
            
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            
            PageService.setPage(getApplicationPageName());
            activeTab = PageService.getActiveTab();
            if (activeTab == 'desc') {
                
                ApplicationService.setApplicationId(appId);
                application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                programme = ProgrammeService.getProgramme(); 
                
            }
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
        
    }
    
    public PageReference save() {
        
        system.debug('sdCompletionStatus =====> '+sdCompletionStatus);
        
        try {
            
            application.AFC_School_Description_Status__c = sdCompletionStatus;
            update application;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Description_saved));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=prog';
            System.debug('mw redirectUrl '+redirectUrl );
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
}