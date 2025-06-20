public with sharing class PimsLandingController {

    private ProfileService profileService = new ProfileService();
    private Account account { get; set; }
    public List<IB_Programme__c> programmes { get; set; }
    public Boolean hasPypProgramme { get; set; }
    public Boolean hasMypProgramme { get; set; }
    public Boolean hasDpProgramme { get; set; }
    public Boolean hasIbccProgramme { get; set; }
    public Boolean hasAgreementProgramme { get; set; }// added for ECM00635

	public PimsLandingController() {

		PimsCommunityService pimsService = new PimsCommunityService();
		pimsService.initUserData();

		account = pimsService.getCurrentAccount();
		profileService.account = account;

		programmes = profileService.getProgrammes();
        hasPypProgramme = profileService.hasProgramme(programmes, 'PYP');
        hasMypProgramme = profileService.hasProgramme(programmes, 'MYP');
        hasDpProgramme = profileService.hasProgramme(programmes, 'Diploma_Programme');
        hasIbccProgramme = profileService.hasProgramme(programmes, 'IBCC');
        hasAgreementProgramme = profileService.hasProgramme(programmes, 'Agreement');// added for ECM00635

    }

	public PageReference init() {
    	
    	if (UserInfo.getUserType() == 'Guest') {
    		return new PageReference('/pims/PimsLogin');
    	}
    	else if (hasPypProgramme || hasMypProgramme || hasDpProgramme || hasIbccProgramme || hasAgreementProgramme) {
            return new PageReference('/pims/PimsDashboard');
    	}
        else {
            return new PageReference('/pims/PimsProfileNew');
        }

    }

}