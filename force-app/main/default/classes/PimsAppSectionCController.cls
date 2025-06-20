public class PimsAppSectionCController extends PimsApplicationControllerHelper {

    public String activeTab { get; set; }
    public String redirectUrl { get; set; }
    public String tab { get; set; }
    public String cpCompletionStatus { get; set; }
    public String wcCompletionStatus { get; set; }
    public String tlCompletionStatus { get; set; }
    public String asmtCompletionStatus { get; set; }

    public String selectedRequirement { get; set;}
    public String selectedType { get; set;}
    public String selectedYear { get; set;}

    public String deleteAppReqId { get; set;}
    public IB_Application__c application { get; set;}
    public IB_Application_Assessment__c assessment { get; set; }
    
    //public IB_Application_Implementation__c applicationImplementation { get; set; }
    public List<IB_Application_Curriculum_Requirement__c> applicationRequirements { get; set; }
    public IB_Application_Curriculum_Requirement__c newRequirement { get; set; }

    public PimsAppSectionCController() {
        if(getIsAfa())
        	PageService.setPage('PimsApplicationForAuthorization');
        else	
        	PageService.setPage('PimsApplicationForCandidacy');

        activeTab = PageService.getActiveTab();
        if (activeTab.contains('sectionc'))  {
            //&& !PageService.isTabLoaded)

            PageService.isTabLoaded = true;
            tab = ApexPages.currentPage().getParameters().get('tab');

            ApplicationService.setApplicationId(ApexPages.currentPage().getParameters().get('id'));
            application = ApplicationService.getApplication();
            assessment = ApplicationService.getApplicationAssessment();
            //applicationImplementation = ApplicationService.getApplicationImplementation();
			
            applicationRequirements = ApplicationService.getApplicationRequirements();

            newRequirement = new IB_Application_Curriculum_Requirement__c(
                IB_Application__c = application.Id
            );
        }
    }
	
    // get picklist values for the programme requirements from the IB Application Curriculum Requirements object
    public List<SelectOption> getProgrammeRequirements() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        Schema.DescribeFieldResult programmeRequirementFieldDescription = IB_Application_Curriculum_Requirement__c.Programme_Requirements__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : programmeRequirementFieldDescription.getPicklistValues()) {
            options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return options;
    }

    // get picklist values for the programme type from the IB Application Curriculum Requirements object
    public List<SelectOption> getProgrammeTypes() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        Schema.DescribeFieldResult programmeTypeFieldDescription = IB_Application_Curriculum_Requirement__c.Programme_Requirements_Locales__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : programmeTypeFieldDescription.getPicklistValues()) {
            options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return options;
    }

    // get picklist values for the programme years from the IB Application Curriculum Requirements object
    public List<SelectOption> getProgrammeYears() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--Select--'));
        Schema.DescribeFieldResult programmeYearFieldDescription;
        if (getIsPyp()) programmeYearFieldDescription = IB_Application_Curriculum_Requirement__c.PYP_Years__c.getDescribe();
        if (getIsMyp()) programmeYearFieldDescription = IB_Application_Curriculum_Requirement__c.MYP_Years__c.getDescribe();
        if (getIsDp()) programmeYearFieldDescription = IB_Application_Curriculum_Requirement__c.DP_Years__c.getDescribe();
        if (getIsCp() || getIsCpPhase1()) programmeYearFieldDescription = IB_Application_Curriculum_Requirement__c.CP_years__c.getDescribe();
        for (Schema.Picklistentry picklistEntry : programmeYearFieldDescription.getPicklistValues()) {
            options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
        return options;
    }

    public PageReference createAppRequirement() {

        try {
            newRequirement.Programme_Requirements__c = selectedRequirement;
            newRequirement.Programme_Requirements_Locales__c = selectedType;
            if (getIsPyp()) newRequirement.PYP_Years__c = selectedYear;
            if (getIsMyp()) newRequirement.MYP_Years__c = selectedYear;
            if (getIsDp()) newRequirement.DP_Years__c = selectedYear;
            if (getIsCp() || getIsCpPhase1()) newRequirement.CP_years__c = selectedYear;

            insert newRequirement;

            ApplicationService.setApplicationId(ApexPages.currentPage().getParameters().get('id'));
            application = ApplicationService.getApplication();
            applicationRequirements = ApplicationService.getApplicationRequirements();

            newRequirement = new IB_Application_Curriculum_Requirement__c(
                IB_Application__c = application.Id
            );

            // reset selected picklist values
            selectedRequirement = '';
            selectedType = '';
            selectedYear = '';

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Programme_Added));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference updateAppRequirement() {
        if(getIsAfa())
        	redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionc2';
        else	
        	redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectionc2';

        try {
            update applicationRequirements;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Programme Requirements updated successfully'));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference removeAppRequirement() {

        try {

            IB_Application_Curriculum_Requirement__c requirementToRemove = new IB_Application_Curriculum_Requirement__c();
            requirementToRemove.Id = deleteAppReqId;

            delete requirementToRemove;

            ApplicationService.setApplicationId(ApexPages.currentPage().getParameters().get('id'));
            applicationRequirements = ApplicationService.getApplicationRequirements();

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Programme_Deleted));
            if(getIsAfa())
                redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionc2';
            else	
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectionc2';
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }

    public PageReference save() {

        system.debug('cpCompletionStatus =====> '+cpCompletionStatus);
        system.debug('wcCompletionStatus =====> '+wcCompletionStatus);
        system.debug('asmtCompletionStatus =====> '+asmtCompletionStatus);
        system.debug('tlCompletionStatus =====> '+tlCompletionStatus);

        try {

            if (cpCompletionStatus != null) application.AFC_Collaborative_Planning_Status__c = cpCompletionStatus;
            if (wcCompletionStatus != null) application.AFC_Written_Curriculum_Status__c = wcCompletionStatus;
            if (tlCompletionStatus != null) application.AFC_Teaching_Learning_Status__c = tlCompletionStatus;
            if (asmtCompletionStatus != null) application.AFC_Assessment_Status__c = asmtCompletionStatus;
            update application;
            update assessment;
            //update applicationImplementation;

            if (activeTab == 'sectionc1')  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.C1_Saved));
                if(getIsAfa())
                    redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionc2';
                else	
                    redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectionc2';
            } else if (activeTab == 'sectionc2') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.C2_Saved));
                if(getIsAfa())
                    redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionc3';
                else	
                    redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectionc3';
            } else if (activeTab == 'sectionc3') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.C3_Saved));
                if(getIsAfa())
                    redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=sectionc4';
                else	
                    redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=sectionc4';
            } else  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.C4_Saved));
                if(getIsAfa())
                    redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + application.Id + '&tab=budget';
                else	
                    redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=budget';
                
            }
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
}