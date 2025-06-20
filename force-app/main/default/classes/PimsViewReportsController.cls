public class PimsViewReportsController extends PimsApplicationControllerHelper{//Extending for userLanguageKey

	public IB_Application__c application {get;set;}
	public IB_Programme__c programme {get;private set;}
	public List<IB_Application_Attachment__c> appAttachments {get;set;}
    private ProfileService profileService;
    @testVisible private List<IB_Programme__c> programmes {get;set;}
    public AppHelper appHelper {get;private set;}
    public Boolean showPageDetails {get; set;}
    
	public PimsViewReportsController(){

        profileService = new ProfileService();

    	String progId = ApexPages.currentPage().getParameters().get('pid');

        if (progId == null) {
            throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        }
        
        system.debug('profileService.acc###'+profileService.account);
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            showPageDetails = pimsService.isMySchoolRole(pimsService.getCurrentAccount().Id,pimsService.getCurrentContact().Id);        

        ProgrammeService.setProgrammeId(progId);
        programme = ProgrammeService.getProgramme();
		if(ProgrammeService.getApplication() != null)
        ApplicationService.setApplicationId((ProgrammeService.getApplication()).Id);

        ApexPages.currentPage().getParameters().put('id', ApplicationService.applicationId);
        appHelper = new AppHelper();

        ApplicationAttachmentService.setProgrammeId(programme.Id);
        appAttachments = ApplicationAttachmentService.getPublishedApplicationAttachments();
        
	}

    //Needed to extend because the appId is being derived and set after outer class extends
    public class AppHelper extends PimsApplicationControllerHelper{}
}