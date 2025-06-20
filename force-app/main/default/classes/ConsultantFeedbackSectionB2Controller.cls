public without sharing class ConsultantFeedbackSectionB2Controller extends PimsApplicationControllerHelper {

    //Commented by Plumlogics US11182
    /*
    private String appId;
    public Boolean isEndOfProcess {get;set;}
    Public String FeasibilityLeads {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public List<IB_Consultant_Feedback__c> consFeedbackList {get; set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public IB_Programme__c programme {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public ConsultantFeedbackSectionB2Controller() {

        isEndOfProcess = false;
        appId = ApexPages.currentPage().getParameters().get('id');
        application = ApplicationDAO.getInstance().getApplicationById(appId);
        assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);
        programme = ProgrammeDAO.getInstance().getProgrammeById(application.Application_Lookup_to_Programme__c);

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
    }

    public PageReference save(){

        system.debug('visitFeedback =====> '+visitFeedback);
        system.debug('endOfProcFeedback =====> '+endOfProcFeedback);

        System.debug('appId =====>' + appId);

        try {
            if (isEndOfProcess) update endOfProcFeedback;
            if (isEndOfProcess == false) update visitFeedback;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B2_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +ex));
            return null;
        }

        return null;
    }

    public PageReference saveAndContinue(){

        save();
        PageReference nextSection = Page.IBENConsultationFeedback;
        nextSection.getParameters().put('sec', IBENConsultationFeedbackController.SECTION_C1);
        nextSection.getParameters().put('id', ApexPages.currentPage().getParameters().get('id'));
        return nextSection;
    }
*/
}