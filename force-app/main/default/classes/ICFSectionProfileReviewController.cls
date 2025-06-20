public without sharing class ICFSectionProfileReviewController extends PimsApplicationControllerHelper {
    public String appId {get;set;}
    public String accId;
    public String progId;

    public String path {get;set;}
    public String url {get;set;}
    public String activeTab {get;set;}
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}

    public Account account {get;set;}
    public List<IB_Address__c> addresses {get;set;}
    public List<SchoolSections__c> sections {get;set;}
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}
    public Decimal mypStudentTotal {get;set;}
    public Decimal pypStudentTotal {get;set;}

    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    //public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}

    public Boolean isEndOfProcess {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public Boolean isIben {get;set;}
    public Boolean isPims {get;set;}
    public Boolean isInternal {get;set;}

    public List<Application_Meeting_Chart__c> applicationMeetingList {get;set;}
    public List<Application_Teaching_Time__c> applicationTeachingTimeList {get;set;}

    public List<IB_Role__c> rolesByProgramme {get;set;}
    public List<IB_Role__c> rolesByContact {get;set;}

    public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    //public List<IB_Application_Curriculum_Requirement__c> applicationRequirements { get; set; }

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

    public ICFSectionProfileReviewController(){


        url = ApexPages.currentPage().getUrl();
        path = url.substring( url.indexOf( '/' ), url.indexOf( '?' ) );
        system.debug('mw 123 path =====> '+path);
        isIben = path.contains( 'educator' );
        isInternal = path.contains( 'Internal' );


        isEndOfProcess = false;
        if(pdCompletionStatus == null) pdCompletionStatus = false;

        PageService.setPage('PimsApplicationForCandidacy');
        activeTab = PageService.getActiveTab();

        appId = ApexPages.currentPage().getParameters().get('id');
        system.debug('mw 123 appId =====> '+appId);
        if (appId == null) throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        //ApplicationService.setApplicationId(appId);
        //application = ApplicationService.getApplicationBySection(activeTab);
        //assessment = ApplicationService.getApplicationAssessment();

        //applicationRequirements = ApplicationService.getApplicationRequirements();

        //Each DAO is only being called once so I do not feel it is worth the time to redo and call the services.
        //application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));

        //subjectProposals = ApplicationService.getSubjectProposals();
        //assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(appId);

        isEditMode = false;
        isEditable = false;

        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){

            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }

        for(IB_Consultant_Feedback__c tmp : ConsultantFeedbackDAO.getInstance().getRecordsByAppId(appId)){

            // May need to do a status check for one-off scenarios

            if (tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                workingId = tmp.Id;
                isEndOfProcess = true;
            }

            ApexPages.currentPage().getParameters().put('id', appId);
        }

        if(visitFeedback != null){
            programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);
        } else {
            programme = ProgrammeDAO.getInstance().getProgrammeById(endOfProcFeedback.IB_Programme_Lookup__c);
        }

        RoleService.setAccountId(programme.Account__c);
        RoleService.setProgrammeId(programme.Id);
        rolesByProgramme = RoleService.getRolesByProgrammeId();

        accId = accId = programme.account__c;
        accountService.setAccountId(accId);
        account = accountService.getAccount();
        AddressService.setAccountId(accId);
        addresses = AddressService.getAddressesByAccount();

        SchoolSectionsService.setAccountId(accId);
        sections = SchoolSectionsService.getSectionsByAccount();

        RoleService.setAccountId(accId);
        roles = RoleService.getRolesByAccountId();

        ContactService.setAccountId(accId);
        contacts = ContactService.getContactsForAccount();

        List<Id> roleIdList = new List<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            if (r.IB_Role_Name__c == 'Teacher') roleIdList.add(r.Id);
        }

        RoleApplicationSubjectService.setRoleList(roleIdList);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
        //subjectProposals = ApplicationService.getSubjectProposals();
		subjectProposals = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IB_Application_Lookup__c,
            	Subject_Lookup__c, Subject_Group__c, Subject_Name__c, Language_of_Instruction__c, MYP_Year_Subject_taught__c, Subject_Level__c, Current_Number_of_Students__c, Estimated_Number_of_Students__c,
               Year_1_Hours__c, Year_2_Hours__c, Before_Year_1_Subject_Name__c, Before_Year_2_Subject_Name__c, IsYearOne__c, IsYearTwo__c, Subject_Lookup__r.Course_Outline__c, 
               Subject_Lookup__r.Course_Outline_SP__c, Subject_Lookup__r.Course_Outline_FR__c, Subject_Lookup__r.Subject_Name_SP__c, Subject_Lookup__r.Subject_Name_FR__c, Subject_Lookup__r.IB_Programme__c 
			FROM Roles_and_Applications_Subject_Proposal__c
            WHERE IB_Application_Lookup__c = :appId
            ORDER By Subject_Group__c ASC
        ];
		
        applicationMeetingList = [
            SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Meeting_Chart__c
            WHERE IB_Application_Lookup__c = :appId
        ];

        applicationTeachingTimeList = [
            SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
            B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
            FROM Application_Teaching_Time__c
            WHERE IB_Application_Lookup__c = :appId
        ];

        programmeStructureList = [
            SELECT Id,Name,PR_2_MYP_Age_From__c,PR_2_MYP_Age_To__c,PR_2_MYP_Grade_Year_From__c,PR_2_MYP_Grade_Year_To__c,PR_2_MYP_School_Lookup__c,
            PR_2_MYP_Student_Total_Year__c,PR_2_MYP_Year__c,PR_2_PYP_MYP_Section__c,PR_2_PYP_Number_of_Classes__c,PR_2_PYP_Number_of_Grades__c,
            PR_2_PYP_Student_Age__c,PR_2_PYP_Total_Students_Year__c, PR_2_MYP_School_Lookup__r.Name
            FROM IB_Programme_Structure__c
            WHERE IB_Programme_Lookup__c = :programme.id
        ];

        mypStudentTotal = 0;
        pypStudentTotal = 0;
        for (IB_Programme_Structure__c rec : programmeStructureList) {
            if (getIsMyp() && rec.PR_2_MYP_Student_Total_Year__c != null) mypStudentTotal += rec.PR_2_MYP_Student_Total_Year__c;
            if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
        }

        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
    }

    public PageReference save(){


        if(isEndOfProcess){
            endOfProcFeedback.Profile_Review_Complete__c = pdCompletionStatus;
            update endOfProcFeedback;
        }
        else{
            visitFeedback.Profile_Review_Complete__c = pdCompletionStatus;
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