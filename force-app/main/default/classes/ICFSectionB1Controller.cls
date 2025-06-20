public without sharing class ICFSectionB1Controller extends PimsApplicationControllerHelper {

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public Boolean isEndOfProcess {get;set;}
    public Boolean pdCompletionStatus {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];
    public Boolean isEditMode {get;set;}
    public Boolean showReturn {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public List<String> feasabilityContacts {get;set;}
    public IB_Programme__c programme {get;set;}
    public Boolean otherLanguage {get;set;}
    public List<Application_Coordinator_Time__c> progCoordinatorTimeList {get;set;}
    public Decimal pcTimeAllocTotal {get;set;}
    public PageReference activeContent {get;set;}

    public ICFSectionB1Controller(){

        if(getIsPyp()){
            activeContent = Page.ICFSectionB1_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionB1_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionB1_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionB1_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionB1_CP2;
        } 

        isEndOfProcess = false;
        pdCompletionStatus = false;

        //Each DAO is only being called once so I do not feel it is worth the time to redo and call the services.
        application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));
        assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);

        Set<String> conIds = new Set<String>();

        if(application.AC_3_1_Feasability_Leads__c != null){
            conIds.addAll(((String)(application.AC_3_1_Feasability_Leads__c)).split(','));
        }

        isEditMode = false;
        isEditable = false;

        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){
            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }

        for(IB_Consultant_Feedback__c tmp : ConsultantFeedbackDAO.getInstance().getRecordsByAppId(application.Id)){

            if (tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                workingId = tmp.Id;
                isEndOfProcess = true;
            }

            ApexPages.currentPage().getParameters().put('id', application.Id);
        }

        feasabilityContacts = new List<String>();
        for(Contact tmp : [select Id, FirstName, LastName from Contact where Id IN:conIds]){
            feasabilityContacts.add(tmp.FirstName + ' ' + tmp.LastName);
        }

        if(visitFeedback != null){
            programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);
        } else {
            programme = ProgrammeDAO.getInstance().getProgrammeById(endOfProcFeedback.IB_Programme_Lookup__c);
        }
        if (programme.Primary_Language_of_Instruction__c == 'English' || programme.Primary_Language_of_Instruction__c == 'Spanish' || programme.Primary_Language_of_Instruction__c == 'French' || programme.Secondary_Language_of_Instruction__c == 'English' || programme.Secondary_Language_of_Instruction__c == 'Spanish' || programme.Secondary_Language_of_Instruction__c == 'French' || programme.PR_5_Third_Language__c == 'English' || programme.PR_5_Third_Language__c == 'Spanish' || programme.PR_5_Third_Language__c == 'French' || programme.PR_5_Fourth_Language__c == 'English' || programme.PR_5_Fourth_Language__c == 'Spanish' || programme.PR_5_Fourth_Language__c == 'French'){
           otherLanguage = false;
        }
        else {
           otherLanguage = true;
        }

        progCoordinatorTimeList = [
           SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c,
           B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
           FROM Application_Coordinator_Time__c
           WHERE IB_Application_Lookup__c = :application.Id AND Type__c = 'Programme coordinator'
        ];

        pcTimeAllocTotal = 0;
        for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
           if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
           if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
           if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
           if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
        }

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
    }

    public PageReference save(){

        if(isEndOfProcess){
            endOfProcFeedback.B1_Complete__c = pdCompletionStatus;
            update endOfProcFeedback;
        }
        else{
            visitFeedback.B1_Complete__c = pdCompletionStatus;
            update visitFeedback;
        }

        return null;
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
}