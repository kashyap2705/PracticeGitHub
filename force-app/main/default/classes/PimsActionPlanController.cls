public class PimsActionPlanController {

    public Account account { get; set; }
    public Id programmeId { get; set; }
    public IB_Programme__c programme { get; set; }
    public List<IB_Action_Plan__c> actionPlan { get; set; }
    public Boolean showPageDetails {get; set;}

    public String filterStandards { get; set; }
    public String filterStatus { get; set; }
    public String filterStage { get; set; }
    public String filterType { get; set; }
    public String filterActionType { get; set; }
    public String selectedPractice { get; set; }
    public IB_Action_Plan__c actionItem { get; set; }
    public Boolean isConView {get;set;}

    private ProfileService profileService = new ProfileService();
    private final string ACTION_STATUS_NOT_APPLICABLE = 'Not Applicable';

    
    public void init() {

        PageService.setPage('PimsActionPlan');

        isConView = false;

        if(ApexPages.currentPage().getParameters().containsKey('conview')){
            isConView = true;
        }
    }

    public PimsActionPlanController() {

        programmeId = ApexPages.currentPage().getParameters().get('id');

        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();

        account = AccountService.getAccount();
        
        showPageDetails = pimsService.isMySchoolRole(account.Id,pimsService.getCurrentContact().Id);        

        ProgrammeService.setProgrammeId(programmeId);
        programme = ProgrammeService.getProgramme();

        ActionPlanService.setProgrammeId(programme.Id);
        actionPlan = ActionPlanService.getActionPlanByProgramme();

        ActionPlanService.setStandard('All');
        ActionPlanService.setStatus('All');
        ActionPlanService.setStage('All');
        ActionPlanService.setApType('All');
        ActionPlanService.setActionType('All');
        //setActionType('All');
        actionPlan = ActionPlanService.getFilteredActionPlan();

        actionItem = new IB_Action_Plan__c(Programme__c = programme.Id);
    }

    public PageReference filter() {

        System.debug(LoggingLevel.ERROR, 'programmeId :' + programmeId);
        System.debug(LoggingLevel.ERROR, 'filterStandards :' + filterStandards);
        System.debug(LoggingLevel.ERROR, 'filterStatus :' + filterStatus);
        System.debug(LoggingLevel.ERROR, 'filterStage :' + filterStage);
        System.debug(LoggingLevel.ERROR, 'filterType :' + filterType);

        ActionPlanService.setProgrammeId(programmeId);
        ActionPlanService.setStandard(filterStandards);
        ActionPlanService.setStatus(filterStatus);
        ActionPlanService.setStage(filterStage);
        ActionPlanService.setApType(filterType);
        ActionPlanService.setActionType(filterActionType);
        actionPlan = ActionPlanService.getFilteredActionPlan();

        return null;

    }

    public List<SelectOption> getStandards() {

        ActionPlanService.setProgrammeId(programmeId);
        ActionPlanService.setStandard(filterStandards);
        ActionPlanService.setStatus(filterStatus);
        ActionPlanService.setStage(filterStage);
        ActionPlanService.setApType(filterType);
        ActionPlanService.setActionType(filterActionType);

        return ActionPlanService.getStandardOptions();

    }

    public List<SelectOption> getStatuses() {

        ActionPlanService.setProgrammeId(programmeId);
        ActionPlanService.setStandard(filterStandards);
        ActionPlanService.setStatus(filterStatus);
        ActionPlanService.setStage(filterStage);
        ActionPlanService.setApType(filterType);
		ActionPlanService.setActionType(filterActionType);
        return ActionPlanService.getStatusOptions();

    }
    
    public List<SelectOption> getActionType() {
        List<SelectOption> pickListValuesList= new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = IB_Action_Plan__c.AP_Action_Type__c.getDescribe();

        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        pickListValuesList.add(new SelectOption('All','All'));
        for( Schema.PicklistEntry pickListVal : ple){

            pickListValuesList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));

        }    

        return pickListValuesList;

         
       
    }

    public List<SelectOption> getStages() {

        return ActionPlanService.getStageOptions();

    }

    public List<SelectOption> getStandardsForAdd() {

        return StandardsPracticesService.getStandardsPicklistOptions();

    }

    public List<SelectOption> getPracticesForAdd() {
        StandardsPracticesService.setProgrammeChoice(programme.RecordType.Name, programme.IBCC_Implementation_Phase__c);
        return StandardsPracticesService.getPracticesDependentPicklistOptions(filterStandards);

    }

    public List<SelectOption> getApTypes() {

        return new List<SelectOption>{
            new SelectOption(Label.PIMS_All,Label.PIMS_All),
            new SelectOption(Label.PIMS_Required, Label.PIMS_Required),
            new SelectOption(Label.PIMS_In_Progress,Label.PIMS_In_Progress)
        };

    }

    public List<SelectOption> getStatusOpts(){

        List<SelectOption> opts = new List<SelectOption>();
        
        // Use getDescribe() to find the Lead object's Company_Size__c options
        Schema.DescribeFieldResult fieldResult = IB_Action_Plan__c.AP_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        // default first option
        opts.add(new SelectOption('', '--None--')); 

        // Add an option for each value
        for(Schema.PicklistEntry f : ple){

            // Don't add the "Not Applicable" option for the New Action dialog
            if(f.getValue().equalsIgnoreCase(ACTION_STATUS_NOT_APPLICABLE)) continue;
            
            opts.add(new SelectOption(f.getValue(),f.getLabel()));
        
        }

        return opts;
    }

    public PageReference create() {

        try {

            actionItem.AP_Standard_Practice__c = selectedPractice;
            insert actionItem;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Action_Item_Added));

        }
        catch (Exception ex) {

            ApexPages.addMessages(ex);

        }

        return null;

    }

}