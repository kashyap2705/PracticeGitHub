public without sharing class ICFSectionC3Controller extends PimsApplicationControllerHelper {

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public Boolean isEndOfProcess {get;set;}
    public List<Application_Meeting_Chart__c> applicationMeetingList {get;set;}
    public List<IB_Role__c> rolesByProgramme {get;set;}
    public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}
    public Decimal pypStudentTotal {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}
    public PageReference activeContent {get;set;}

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

    public IB_Programme__c programme {get;set;}

    public ICFSectionC3Controller(){
        if(getIsPyp()){
            activeContent = Page.ICFSectionC3_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionC3_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionC3_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionC3_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionC3_CP2;
        } 

        isEndOfProcess = false;
        pdCompletionStatus = false;

        application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));
        assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);

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

		ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
		programme = ProgrammeService.getProgramme();

        RoleService.setAccountId(programme.Account__c);
        RoleService.setProgrammeId(programme.Id);
        rolesByProgramme = RoleService.getRolesByProgrammeId();

        List<Id> roleIdList = new List<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            if (r.IB_Role_Name__c == 'Teacher') roleIdList.add(r.Id);
        }

        RoleApplicationSubjectService.setRoleList(roleIdList);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();

        applicationMeetingList = [
            SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Meeting_Chart__c
            WHERE IB_Application_Lookup__c = :application.Id
        ];

		programmeStructureList = [
		    SELECT  Id, Name, PR_2_MYP_Age_From__c, PR_2_MYP_Age_To__c, PR_2_MYP_Grade_Year_From__c, PR_2_MYP_Grade_Year_To__c, PR_2_MYP_School_Lookup__c,
		            PR_2_MYP_Student_Total_Year__c, PR_2_MYP_Year__c, PR_2_PYP_MYP_Section__c, PR_2_PYP_Number_of_Classes__c, PR_2_PYP_Number_of_Grades__c,
		            PR_2_PYP_Student_Age__c, PR_2_PYP_Total_Students_Year__c
		    FROM    IB_Programme_Structure__c
		    WHERE   IB_Programme_Lookup__c = :programme.id
		];

		pypStudentTotal = 0;

		for (IB_Programme_Structure__c rec : programmeStructureList) {

		    if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null){
		        pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
		    }
		}

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }

    }

    public PageReference save(){

        if(isEndOfProcess){
            endOfProcFeedback.C3_Complete__c = pdCompletionStatus;
            update endOfProcFeedback;
        }
        else{
            visitFeedback.C3_Complete__c = pdCompletionStatus;
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