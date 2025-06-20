public without sharing class ICFSectionC4Controller extends PimsApplicationControllerHelper {
    public String appId;
    public String accId;
    public String progId;

    public String activeTab {get;set;}
    //public String activeComponent {get;set;}
    //public String redirectUrl {get;set;}
    //public String lsCompletionStatus {get;set;}
    //public String rsCompletionStatus {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
	public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
	public IB_Application__c application {get;set;}
	public IB_Application_Assessment__c assessment {get;set;}
	public Boolean isEndOfProcess {get;set;}
	public Boolean pdCompletionStatus {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}

    public List<Application_Meeting_Chart__c> applicationMeetingList {get;set;}
 	public List<Application_Teaching_Time__c> applicationTeachingTimeList {get;set;}

    public List<IB_Role__c> rolesByProgramme {get;set;}
	public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
	public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
	public List<IB_Application_Curriculum_Requirement__c> applicationRequirements { get; set; }

    public List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps {get;set;}

    public List<Roles_and_Applications_Subject_Proposal__c> getStandardSubjectProps(){

        standardSubjectProps = new List<Roles_and_Applications_Subject_Proposal__c>();
        for(Roles_and_Applications_Subject_Proposal__c tmp : subjectProposals){
            if(tmp.Subject_Level__c == 'Standard'){
                standardSubjectProps.add(tmp);
            }
        }
        return standardSubjectProps;
    }

	public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
	public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

	public IB_Programme__c programme {get;set;}

    public PageReference activeContent {get;set;}

	public ICFSectionC4Controller(){
        if(getIsPyp()){
            activeContent = Page.ICFSectionC4_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionC4_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionC4_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionC4_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionC4_CP2;
        } 

		isEndOfProcess = false;
        pdCompletionStatus = false;

        PageService.setPage('PimsApplicationForCandidacy');
        activeTab = PageService.getActiveTab();
        system.debug('activeTab =====> '+activeTab);

       // if (activeTab == 'sectionc2') {


        appId = ApexPages.currentPage().getParameters().get('id');
        system.debug('appId =====> '+appId);
        if (appId == null) throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        ApplicationService.setApplicationId(appId);
        //application = ApplicationService.getApplicationBySection(activeTab);
        //assessment = ApplicationService.getApplicationAssessment();

		applicationRequirements = ApplicationService.getApplicationRequirements();

		//Each DAO is only being called once so I do not feel it is worth the time to redo and call the services.
		application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));

        //subjectProposals = ApplicationService.getSubjectProposals();
		assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);

		system.debug('marty application.Id =====> '+application.Id);

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

		//programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);
        if(visitFeedback != null){
            programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);
        } else {
            programme = ProgrammeDAO.getInstance().getProgrammeById(endOfProcFeedback.IB_Programme_Lookup__c);
        }



		RoleService.setAccountId(programme.Account__c);
		RoleService.setProgrammeId(programme.Id);
        rolesByProgramme = RoleService.getRolesByProgrammeId();

		List<Id> roleIdList = new List<Id>() ;
		for (IB_Role__c r : rolesByProgramme) {
			if (r.IB_Role_Name__c == 'Teacher') roleIdList.add(r.Id);
		}

		RoleApplicationSubjectService.setRoleList(roleIdList);
		subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
        subjectProposals = ApplicationService.getSubjectProposals();


		applicationMeetingList = [
			SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
			FROM Application_Meeting_Chart__c
			WHERE IB_Application_Lookup__c = :application.Id
		];
     	applicationTeachingTimeList = [
            SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
                    B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
            FROM Application_Teaching_Time__c
            WHERE IB_Application_Lookup__c = :appId
        ];

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
	}

	public PageReference save(){

		if(isEndOfProcess){
			endOfProcFeedback.C4_Complete__c = pdCompletionStatus;
			update endOfProcFeedback;
		}
		else{
			visitFeedback.C4_Complete__c = pdCompletionStatus;
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