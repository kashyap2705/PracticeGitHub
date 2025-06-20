public without sharing class ICFInstructionsController {

	public String instructionsToShow{get;set;}

	public ICFInstructionsController() {

		String appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        }

        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();

        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();

        if(UserInfo.getLanguage() == 'en_US'){
        	if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
                instructionsToShow = 'ICFInstructionsCP1EN';
            } else {
        		instructionsToShow = 'ICFInstructionsAllEN';
        	}
        } else if(UserInfo.getLanguage() == 'fr'){
        	if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
                instructionsToShow = 'ICFInstructionsCP1FR';
            } else {
        		instructionsToShow = 'ICFInstructionsAllFR';
        	}
        } else if(UserInfo.getLanguage() == 'es'){
        	if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
                instructionsToShow = 'ICFInstructionsCP1ES';
            } else {
        		instructionsToShow = 'ICFInstructionsAllES';
        	}
        }
	}
}