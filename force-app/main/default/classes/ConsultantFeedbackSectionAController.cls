public without sharing class ConsultantFeedbackSectionAController extends PimsApplicationControllerHelper {

    //Commented by Plumlogics US11182
    /*
    private String appId;
    public Boolean isEndOfProcess {get;set;}
    Public String FeasibilityLeads {get;set;}
    public Decimal pypStudentTotal {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public List<IB_Consultant_Feedback__c> consFeedbackList {get; set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public IB_Programme__c programme {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public ConsultantFeedbackSectionAController() {

        isEndOfProcess = false;
        appId = ApexPages.currentPage().getParameters().get('id');
        application = ApplicationDAO.getInstance().getApplicationById(appId);
        assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);
        programme = ProgrammeDAO.getInstance().getProgrammeById(application.Application_Lookup_to_Programme__c);
        ApplicationService.setApplicationId(application.Id);
        subjectProposals = ApplicationService.getSubjectProposals();

        // Get the list of IDs related to the Feasibility Leads
        String[] FeasibilityLeadsList = application.AC_3_1_Feasability_Leads__c.split(',');

        // Get the Contact name for each Feasibility Lead and concatenate that list into one String
        integer cnt = 1;
        for (Contact c : [SELECT Name From Contact WHERE Id IN :FeasibilityLeadsList]) {
            if (cnt == 1) FeasibilityLeads = c.Name;
            if (cnt > 1) FeasibilityLeads = FeasibilityLeads+', '+c.Name;
            cnt++;
        }

        if (appId == null) throw new CustomValidationException('The application ID is invalid.');

        ConsultantFeedbackDAO dao = ConsultantFeedbackDAO.getInstance();
        consFeedbackList = dao.getRecordsByAppId(appId);

        for (IB_Consultant_Feedback__c tmp : consFeedbackList) {
            if (tmp.RecordTypeId == visitRecType.Id && tmp.Status__c != 'Submitted') visitFeedback = tmp;
            if (tmp.RecordTypeId == endOfProcRecType.Id && tmp.Status__c != 'Submitted') {
                endOfProcFeedback = tmp;
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
    }
*/
    public PageReference save(){

        try {/*
            if (isEndOfProcess) update endOfProcFeedback;
            if (isEndOfProcess == false) update visitFeedback;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Philosophy_saved));*/
            return null;
        }
        catch (Exception ex) {/*
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving));*/
            return null;
        }

    }
}