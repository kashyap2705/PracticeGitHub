public without sharing class ICFSectionAController extends PimsApplicationControllerHelper {

    private String appId;
    public Boolean isEndOfProcess {get;set;}
    Public String FeasibilityLeads {get;set;}
    public Decimal pypStudentTotal {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public List<IB_Consultant_Feedback__c> consFeedbackList {get; set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public IB_Programme__c programme {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}
    public PageReference activeContent {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public ICFSectionAController() {

        if(getIsPyp()){
            activeContent = Page.ICFSectionA_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionA_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionA_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionA_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionA_CP2;
        } 
        
        isEditMode = false;
        isEditable = false;
        pdCompletionStatus = false;

        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){

            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }

        isEndOfProcess = false;
        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        }

        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();
        subjectProposals = ApplicationService.getSubjectProposals();
        assessment = ApplicationService.getApplicationAssessment();

        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        programme = ProgrammeService.getProgramme();

        // Get the list of IDs related to the Feasibility Leads
        String[] FeasibilityLeadsList = new List<String>();
        if(application.AC_3_1_Feasability_Leads__c != null){
           FeasibilityLeadsList = application.AC_3_1_Feasability_Leads__c.split(',');
        }

        // Get the Contact name for each Feasibility Lead and concatenate that list into one String
        integer cnt = 1;
        for (Contact c : [SELECT Name From Contact WHERE Id IN :FeasibilityLeadsList]) {
            if (cnt == 1) FeasibilityLeads = c.Name;
            if (cnt > 1) FeasibilityLeads = FeasibilityLeads+', '+c.Name;
            cnt++;
        }

        if (appId == null) throw new CustomValidationException(Label.PIMS_INVALID_APPID);

        ConsultantFeedbackDAO dao = ConsultantFeedbackDAO.getInstance();
        consFeedbackList = dao.getRecordsByAppId(appId);

        for (IB_Consultant_Feedback__c tmp : consFeedbackList) {
            if (tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                workingId = tmp.Id;
                isEndOfProcess = true;
            }
        }

        programmeStructureList = [
            SELECT Id,Name,PR_2_MYP_Age_From__c,PR_2_MYP_Age_To__c,PR_2_MYP_Grade_Year_From__c,PR_2_MYP_Grade_Year_To__c,PR_2_MYP_School_Lookup__c,
                    PR_2_MYP_Student_Total_Year__c,PR_2_MYP_Year__c,PR_2_PYP_MYP_Section__c,PR_2_PYP_Number_of_Classes__c,PR_2_PYP_Number_of_Grades__c,
                    PR_2_PYP_Student_Age__c,PR_2_PYP_Total_Students_Year__c
            FROM IB_Programme_Structure__c
            WHERE IB_Programme_Lookup__c = :programme.id
        ];

        pypStudentTotal = 0;

        for (IB_Programme_Structure__c rec : programmeStructureList) {
            if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
        }

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
    }

    public Void saveAndReturn(){
        undoReturn();
        save();
    }

    public Void edit(){
        isEditMode = true;
    }

    public Void undoEdit(){
        isEditMode = false;
    }

    public Void doReturn(){
        showReturn = true;
    }

    public Void undoReturn(){
        showReturn = false;
    }

    public Void saveFromEdit(){
        undoEdit();

        if(visitFeedback != null && visitFeedback.Id == workingId){
            visitFeedback.Edited_by_Staff__c = true;

            update visitFeedback;
        }
        else if(endOfProcFeedback != null && endOfProcFeedback.Id == workingId){
            endOfProcFeedback.Edited_by_Staff__c = true;
            update endOfProcFeedback;
        }
    }

    public PageReference save(){

        try {
            if (isEndOfProcess) {
                endOfProcFeedback.A_Complete__c = pdCompletionStatus;
                System.debug('status__c : ' + endOfProcFeedback.Status__c);
                update endOfProcFeedback;
            }
            if (isEndOfProcess == false) {
                visitFeedback.A_Complete__c = pdCompletionStatus;
                System.debug('status__c : ' + visitFeedback.Status__c);
                update visitFeedback;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Philosophy_saved));
            return null;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving));
            return null;
        }

    }
}