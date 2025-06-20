public without sharing class ICFSectionAdviceController extends PimsApplicationControllerHelper {

    private String appId;
    public Boolean isEndOfProcess {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public List<IB_Consultant_Feedback__c> consFeedbackList {get; set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public IB_Programme__c programme {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public Boolean feedbackComplete {get;set;}
    public String assignmentId {get;set;}
    public Boolean showReturn {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public ICFSectionAdviceController() {

        feedbackComplete = false;
        Boolean visitFeedbackComplete = false;
        Boolean eofFeedbackComplete = false;
        isEndOfProcess = false;
        pdCompletionStatus = false;
        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        }

        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();

        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        programme = ProgrammeService.getProgramme();

        ConsultantFeedbackDAO dao = ConsultantFeedbackDAO.getInstance();
        consFeedbackList = dao.getRecordsByAppId(appId);

        isEditMode = false;
        isEditable = false;

        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){

            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }

        for (IB_Consultant_Feedback__c tmp : consFeedbackList) {
            if (tmp.RecordTypeId == visitRecType.Id) {
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
                if(visitFeedback.A_Complete__c && visitFeedback.B1_Complete__c &&
                    visitFeedback.B2_Complete__c && visitFeedback.C1_Complete__c &&
                    visitFeedback.C2_Complete__c && visitFeedback.C3_Complete__c &&
                    visitFeedback.C4_Complete__c && visitFeedback.Advice_Complete__c &&
                    visitFeedback.Profile_Review_Complete__c) {
                    visitFeedbackComplete = true;
                } 
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                isEndOfProcess = true;
                workingId = tmp.Id;
                if(endOfProcFeedback.A_Complete__c && endOfProcFeedback.B1_Complete__c &&
                    endOfProcFeedback.B2_Complete__c && endOfProcFeedback.C1_Complete__c &&
                    endOfProcFeedback.C2_Complete__c && endOfProcFeedback.C3_Complete__c &&
                    endOfProcFeedback.C4_Complete__c && endOfProcFeedback.Advice_Complete__c &&
                    endOfProcFeedback.Profile_Review_Complete__c) {
                    eofFeedbackComplete = true;
                } 
            }
        }
        
        if(isEndOfProcess){
            feedbackComplete = eofFeedbackComplete;
        } else {
            feedbackComplete = visitFeedbackComplete;
        }

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
    }

    public PageReference save(){

        if (isEndOfProcess) {
            endOfProcFeedback.Advice_Complete__c = pdCompletionStatus;
            update endOfProcFeedback;
        }
        if (!isEndOfProcess) {
            visitFeedback.Advice_Complete__c = pdCompletionStatus;
            update visitFeedback;
        }

        return null;
    }

    public PageReference saveAndSubmit(){

        if (isEndOfProcess) {
            endOfProcFeedback.Status__c = 'Submitted';
            update endOfProcFeedback;
        }

        if (!isEndOfProcess) {
            visitFeedback.Status__c = 'Submitted';
            update visitFeedback;
        }

        return null;
    }

    public Void saveAndReturn(){
        undoReturn();

        if(visitFeedback != null && visitFeedback.Id == workingId){
            visitFeedback.Status__c = 'Returned to Consultant';
        }
        else if(endOfProcFeedback != null && endOfProcFeedback.Id == workingId){
            endOfProcFeedback.Status__c = 'Returned to Consultant';
        }

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
}