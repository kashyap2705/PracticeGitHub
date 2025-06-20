public class PimsApplicationForAuthController extends PimsApplicationControllerHelper {
    
    public String appId {get;set;}
    
    public transient IB_Application__c application {get;set;}
    public transient IB_Programme__c programme {get;set;}
    
    public Account account {get;set;}
    public List<IB_Address__c> addresses {get;set;}
    @TestVisible public List<SchoolSections__c> sections {get;set;}
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public List<IB_Programme__c> programmes {get;set;}
    public Boolean showPageDetails {get; set;}

    public IB_Application__c afc {get;set;}    
    public IB_Application_Assessment__c assessment { get; set; }
    
    public List<IB_Application_Attachment__c> attachments {get;set;}
    
    public List<Application_Budget_Table__c> applicationBudgetTable {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {get;set;}
    
    public List<IB_Application_Curriculum_Requirement__c> applicationRequirementsList {get;set;}
    
    @TestVisible public Application_Coordinator_Time__c editCoordinatorTime {get;set;}
    /*public List<Application_Coordinator_Time__c> coordnatorTimeList {get;set;}*/
    
    @TestVisible public Application_Account_Facilities__c applicationAccountFacilities {get;set;}
    @TestVisible public List<Application_Account_Facilities__c> applicationAccountFacilitiesList {get;set;}
    
    public String activeTab {get;set;}
    
    // Conpletion status flags for the various sections of the AFC - used to color coordinate the overall level of the AFC completion
    public String afcProfileReviewStatus {get;set;}
    public String afcSchoolDescriptionStatus {get;set;}
    public String afcProgrammeDataStatus {get;set;}
    public String afcSubjectProposalStatus {get;set;}
    public String afcPhilosophyStatus {get;set;}
    public String afcLeadershipStructureStatus {get;set;}
    public String afcResourcesSupportStatus {get;set;}
    public String afcCollaborativePlanningStatus {get;set;}
    public String afcWrittenCurriculumStatus {get;set;}
    public String afcTeachingLearningStatus {get;set;}
    public String afcAssessmentStatus {get;set;}
    public String afcImplementationBudgetStatus {get;set;}
    public String afcDocumentsStatus {get;set;}
    public String afcAgreementStatus {get;set;}
    public String afaOutlineStatus { get; set; }
    
    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }
    
    //private ProfileService profileService = new ProfileService();
    
    public void init() {
        
        try
        {
            if(getIsAfc())
                PageService.setPage('PimsApplicationForCandidacy');
            else
                PageService.setPage('PimsApplicationForAuthorization');
            
            activeTab = PageService.getActiveTab();
            
            // we should never fall into here, but just in case show the info tab panel
            if (activeTab == null) {
                activeTab = 'profile';
            }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
    
    public PimsApplicationForAuthController() {
        try
        {
            appId = ApexPages.currentPage().getParameters().get('id');
            activeTab = ApexPages.currentPage().getParameters().get('tab');
            
            PageReference pageRef = ApexPages.currentPage();
            String url = pageRef.getUrl();
            
            if (activeTab == null || activeTab == '') {
                activeTab = 'profile';
            }
            
            if (appId == null) {
                throw new CustomValidationException(Label.PIMS_INVALID_APPID);
            }
            
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            
            ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();        
            assessment = ApplicationService.getApplicationAssessment();
            
            ApplicationService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            afc = ApplicationService.getAfcByProgrammeId();
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            
            if (!url.contains('IbenApplicationForAuthorization')) {
                account = pimsService.getCurrentAccount();
            }
            else {
                AccountService.isCached = false;
                AccountService.setAccountId(programme.Account__c);
                account = AccountService.getAccount();
            }
            //profileService.account = account;
            
            ProgrammeService.setAccountId(account.Id);
            programmes = ProgrammeService.getProgrammesByAccount();
            
            AddressService.setAccountId(account.Id);
            addresses = AddressService.getAddressesByAccount();
            
            SchoolSectionsService.setAccountId(account.Id);
            //sections = SchoolSectionsService.getSectionsByAccount();
            
            RoleService.setAccountId(account.Id);
            //roles = RoleService.getRolesByAccountId();
            
            ContactService.setAccountId(account.Id);
            //contacts = ContactService.getContacts();
            
            /*ApplicationService.setApplicationId(appId);
application = ApplicationService.getApplication();

ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
programme = ProgrammeService.getProgramme();*/
            
           showPageDetails = pimsService.isMySchoolRole(account.Id,pimsService.getCurrentContact().Id);        
            
            
            
            afcProfileReviewStatus = application.AFC_Profile_Review_Status__c;
            afcSchoolDescriptionStatus = application.AFC_School_Description_Status__c;
            afcProgrammeDataStatus = application.AFC_Programme_Information_Status__c;
            afcSubjectProposalStatus = application.AFC_Subject_Proposal_Status__c;
            afcPhilosophyStatus = application.AFC_Philosophy_Status__c;
            afcLeadershipStructureStatus = application.AFC_Leadership_Structure_Status__c;
            afcResourcesSupportStatus = application.AFC_Resources_Support_Status__c;
            afcCollaborativePlanningStatus = application.AFC_Collaborative_Planning_Status__c;
            afcWrittenCurriculumStatus = application.AFC_Written_Curriculum_Status__c;
            afcTeachingLearningStatus = application.AFC_Teaching_Learning_Status__c;
            afcAssessmentStatus = application.AFC_Assessment_Status__c;
            afcImplementationBudgetStatus = application.AFC_Implementation_Budget_Status__c;
            afcDocumentsStatus = application.AFC_Documents_Status__c;
            afcAgreementStatus = application.AFC_Agreement_Status__c;
            afaOutlineStatus = application.AFA_Outline_Status__c;
            
            applicationBudgetTable = [
                SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
                PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
                USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
                Pro_Dev_Item__c, Other_Item__c, Id, Name, Fee_Item__c
                FROM Application_Budget_Table__c
                WHERE IB_Application_Lookup__c = :application.id
            ];
            
            applicationBudgetList = [
                SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
                PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
                USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
                Pro_Dev_Item__c, Other_Item__c, Id, Name, Fee_Item__c
                FROM Application_Budget_Table__c
                WHERE IB_Programme__c = :programme.Id
            ];
            
            applicationRequirementsList = [
                SELECT PYP_Years__c, MYP_Years__c, DP_years__c, CP_years__c, IB_Application__c, Programme_Requirements_Locales__c, Programme_Requirements__c, Id, Name
                FROM IB_Application_Curriculum_Requirement__c
                WHERE IB_Application__c = :application.Id
            ];
            
            attachments = [
                SELECT Id, Type__c, Attachment__c, Description__c, View__c, IB_Programme__c, IB_Programme__r.Name, Publish_to_Community__c, Name
                FROM IB_Application_Attachment__c
                WHERE IB_Programme__c = :programme.id
            ];
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    
    public PageReference getActiveSection(){ 
        try
        {
            Map<String, PageReference> tmpKey = new Map<String, PageReference>{
                'profile' => Page.AFC_Section_Profile,
                    'desc' => Page.AFC_Section_Desc,
                    'prog' => Page.AFC_Section_Prog,
                    'subject' => Page.AFC_Section_Subject,
                    'sectiona' => Page.AFC_Section_A,
                    'sectionb1' => Page.AFC_Section_B1,
                    'sectionb2' => Page.AFC_Section_B2,
                    'sectionc1' => Page.AFC_Section_C1,
                    'sectionc2' => Page.AFC_Section_C2,
                    'sectionc3' => Page.AFC_Section_C3,
                    'sectionc4' => Page.AFC_Section_C4,
                    'budget' => Page.AFC_Section_Budget,
                    'docs' => Page.AFC_Section_Docs,
                    'outlines' => Page.AFA_Outlines,
                    'agreement' => Page.AFC_Section_Agreement
                    };
                        
                        if(activeTab == null){
                            ActiveTab = 'profile';
                        }
            
            PageReference tmp = tmpKey.get(activeTab);
            tmp.getParameters().put('id', appId);
            tmp.setredirect(true);
            
            return tmp;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public void checkApplicationsExist() {
        try
        {
            if (application == null || afc == null) {
                appId = ApexPages.currentPage().getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                application = ApplicationService.getApplication();        
                assessment = ApplicationService.getApplicationAssessment();
                ApplicationService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                afc = ApplicationService.getAfcByProgrammeId();
            }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
   @TestVisible public boolean isAChanged
    {
        get
        {
            checkApplicationsExist();            
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.A1_2_Mission_Align__c!=null && application.A1_2_Mission_Align__c==afc.A1_2_Mission_Align__c)||
               (application.A1_3_Refinement_Process__c!=null && application.A1_3_Refinement_Process__c==afc.A1_3_Refinement_Process__c)|| 
               (application.A1_4_Alignment_Extent__c!=null && application.A1_4_Alignment_Extent__c==afc.A1_4_Alignment_Extent__c)||
               (application.A1_5_Further_Align__c!=null && application.A1_5_Further_Align__c==afc.A1_5_Further_Align__c)||
               (application.A1_5_describe_other__c!=null && application.A1_5_describe_other__c==afc.A1_5_describe_other__c)||
               (application.A3_4_10_Pedagogical_Outcomes__c!=null && application.A3_4_10_Pedagogical_Outcomes__c==afc.A3_4_10_Pedagogical_Outcomes__c)||
               (application.A3_4_11_Teacher_Actions__c!=null && application.A3_4_11_Teacher_Actions__c==afc.A3_4_11_Teacher_Actions__c)||
               (application.A3_4_12_Teacher_Outcomes__c!=null && application.A3_4_12_Teacher_Outcomes__c==afc.A3_4_12_Teacher_Outcomes__c)|| 
               (application.A3_4_1_Governing_Actions__c!=null && application.A3_4_1_Governing_Actions__c==afc.A3_4_1_Governing_Actions__c )||
               (application.A3_4_2_Governing_Outcomes__c!=null && application.A3_4_2_Governing_Outcomes__c==afc.A3_4_2_Governing_Outcomes__c )||
               (application.A3_4_3_Local_Actions__c!=null && application.A3_4_3_Local_Actions__c==afc.A3_4_3_Local_Actions__c )||
               (application.A3_4_4_Local_Outcomes__c!=null && application.A3_4_4_Local_Outcomes__c==afc.A3_4_4_Local_Outcomes__c )||
               (application.A3_4_5_Other_Actions__c!=null && application.A3_4_5_Other_Actions__c==afc.A3_4_5_Other_Actions__c) ||
               (application.A3_4_6_Other_Outcomes__c!=null && application.A3_4_6_Other_Outcomes__c==afc.A3_4_6_Other_Outcomes__c) ||
               (application.A3_4_7_Parents_Actions__c!=null && application.A3_4_7_Parents_Actions__c==afc.A3_4_7_Parents_Actions__c) ||
               (application.A3_4_8_Parents_Outcomes__c!=null && application.A3_4_8_Parents_Outcomes__c==afc.A3_4_8_Parents_Outcomes__c) ||
               (application.A3_4_9_Pedagogical_Actions__c!=null && application.A3_4_9_Pedagogical_Actions__c==afc.A3_4_9_Pedagogical_Actions__c)|| 
               (application.A3_5_Additional_Information__c!=null && application.A3_5_Additional_Information__c==afc.A3_5_Additional_Information__c)|| 
               (application.A3_e_2_PYP_Transdisciplinary_Challenges__c!=null && application.A3_e_2_PYP_Transdisciplinary_Challenges__c==afc.A3_e_2_PYP_Transdisciplinary_Challenges__c) ||
               (application.A7_a_1_PYP_What_languages__c!=null && application.A7_a_1_PYP_What_languages__c==afc.A7_a_1_PYP_What_languages__c) ||
               (application.A7_a_2_PYP_Language_Age__c!=null && application.A7_a_2_PYP_Language_Age__c==afc.A7_a_2_PYP_Language_Age__c) ||
               (application.A8_1_OCC_Utilization__c!=null && application.A8_1_OCC_Utilization__c==afc.A8_1_OCC_Utilization__c) ||
               (application.A9_a_2_Admission_Requirements__c!=null && application.A9_a_2_Admission_Requirements__c==afc.A9_a_2_Admission_Requirements__c) ||
               (application.A9_a_2_CP_Promote_Access__c!=null && application.A9_a_2_CP_Promote_Access__c==afc.A9_a_2_CP_Promote_Access__c) ||
               (application.A9_a_2_MYP_Year_2__c!=null && application.A9_a_2_MYP_Year_2__c==afc.A9_a_2_MYP_Year_2__c) ||
               (application.A9_a_2_MYP_Year_3__c!=null && application.A9_a_2_MYP_Year_3__c==afc.A9_a_2_MYP_Year_3__c) ||
               (application.A9_a_2_MYP_Year_4__c!=null && application.A9_a_2_MYP_Year_4__c==afc.A9_a_2_MYP_Year_4__c) ||
               (application.A9_a_2_MYP_Year_5__c!=null && application.A9_a_2_MYP_Year_5__c==afc.A9_a_2_MYP_Year_5__c) ||
               (application.A9_a_2_MYP_Year__c!=null && application.A9_a_2_MYP_Year__c==afc.A9_a_2_MYP_Year__c) ||
               (application.A9_a_3_Admissions_Policy__c!=null && application.A9_a_3_Admissions_Policy__c==afc.A9_a_3_Admissions_Policy__c) ||
               (application.A9_a_3_MYP_Inclusive_Program__c!=null && application.A9_a_3_MYP_Inclusive_Program__c==afc.A9_a_3_MYP_Inclusive_Program__c) ||
               (application.A9_a_4_Full_Cohort_Explanation__c!=null && application.A9_a_4_Full_Cohort_Explanation__c==afc.A9_a_4_Full_Cohort_Explanation__c) ||
               (application.A9_a_MYP_5_Year_Explanation__c!=null && application.A9_a_MYP_5_Year_Explanation__c==afc.A9_a_MYP_5_Year_Explanation__c) ||
               (application.A9_a_MYP_All_Grades_Start__c!=null && application.A9_a_MYP_All_Grades_Start__c==afc.A9_a_MYP_All_Grades_Start__c) ||
               (application.AC_4_1_DP_CP_International_Embodied__c!=null && application.AC_4_1_DP_CP_International_Embodied__c==afc.AC_4_1_DP_CP_International_Embodied__c) ||
               (application.AC_A1_2b_CP_Implementation__c!=null && application.AC_A1_2b_CP_Implementation__c==afc.AC_A1_2b_CP_Implementation__c) ||
               (application.AC_A1_2c_CP_Community__c!=null && application.AC_A1_2c_CP_Community__c==afc.AC_A1_2c_CP_Community__c) ||
               (application.AC_A3_2_Additional_Stakeholders_Other__c!=null && application.AC_A3_2_Additional_Stakeholders_Other__c==afc.AC_A3_2_Additional_Stakeholders_Other__c) ||
               (application.AC_A3_2_Additional_Stakeholders__c!=null && application.AC_A3_2_Additional_Stakeholders__c==afc.AC_A3_2_Additional_Stakeholders__c) ||
               (application.AC_A3_3_Feasibility_Process__c!=null && application.AC_A3_3_Feasibility_Process__c==afc.AC_A3_3_Feasibility_Process__c) ||
               (application.AF_A1_2_Mission_Change__c!=null && application.AF_A1_2_Mission_Change__c==afc.AF_A1_2_Mission_Change__c)  ||
               (application.AF_A1_4_Philosophy_Change__c!=null && application.AF_A1_4_Philosophy_Change__c==afc.AF_A1_4_Philosophy_Change__c) ||
               (application.AF_A2_1_DP_Approaches_to_Learning__c!=null && application.AF_A2_1_DP_Approaches_to_Learning__c==afc.AF_A2_1_DP_Approaches_to_Learning__c) ||
               (application.AF_A2_2_DP_School_s_Philosophy__c!=null && application.AF_A2_2_DP_School_s_Philosophy__c==afc.AF_A2_2_DP_School_s_Philosophy__c) ||
               (application.A_1_1_Current_Mission__c!=null && application.A_1_1_Current_Mission__c==afc.A_1_1_Current_Mission__c )||
               //application.Current_Assessment_12__c==afc.Current_Assessment_12__c ||
               (application.X9_b_1_DP_Will_Encourage__c!=null && application.X9_b_1_DP_Will_Encourage__c==afc.X9_b_1_DP_Will_Encourage__c))
                return false;
            else
                return true;
        }
        set;
    }
   @TestVisible public boolean isB1Changed
    {
        get
        {            
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            
            if((application.B124_CP_recruiting__c!=null && application.B124_CP_recruiting__c==afc.B124_CP_recruiting__c)||
               (application.B1_5a_1_DP_CP_Admission_Changes__c!=null && application.B1_5a_1_DP_CP_Admission_Changes__c==afc.B1_5a_1_DP_CP_Admission_Changes__c)||
               (application.B1_5a_1_Language_Policy__c!=null && application.B1_5a_1_Language_Policy__c==afc.B1_5a_1_Language_Policy__c)||
               (application.B1_5a_2_PYP_MYP_Language_Support__c!=null && application.B1_5a_2_PYP_MYP_Language_Support__c==afc.B1_5a_2_PYP_MYP_Language_Support__c)||
               (application.B1_5b_1_Assessent_Policy__c!=null && application.B1_5b_1_Assessent_Policy__c==afc.B1_5b_1_Assessent_Policy__c)||
               (application.B1_5b_2_DP_CP_Language_Provisions__c!=null && application.B1_5b_2_DP_CP_Language_Provisions__c==afc.B1_5b_2_DP_CP_Language_Provisions__c)||
               (application.B1_5b_3_DP_CP_Language_Policy__c!=null && application.B1_5b_3_DP_CP_Language_Policy__c==afc.B1_5b_3_DP_CP_Language_Policy__c)||
               (application.B1_5b_MYP_Assessment__c!=null && application.B1_5b_MYP_Assessment__c==afc.B1_5b_MYP_Assessment__c)||
               (application.B1_5c_1_DP_CP_Support_Requirements__c!=null && application.B1_5c_1_DP_CP_Support_Requirements__c==afc.B1_5c_1_DP_CP_Support_Requirements__c)||
               (application.B1_5c_1_MYP_Assessment_Process__c!=null && application.B1_5c_1_MYP_Assessment_Process__c==afc.B1_5c_1_MYP_Assessment_Process__c)||
               (application.B1_5c_1_PYP_Assessment_Perspective__c!=null && application.B1_5c_1_PYP_Assessment_Perspective__c==afc.B1_5c_1_PYP_Assessment_Perspective__c)||
               (application.B1_5d_1_DP_Assessment_Policy__c!=null && application.B1_5d_1_DP_Assessment_Policy__c==afc.B1_5d_1_DP_Assessment_Policy__c)||
               (application.B1_5d_1_MYP_Honesty_Policy_Process__c!=null && application.B1_5d_1_MYP_Honesty_Policy_Process__c==afc.B1_5d_1_MYP_Honesty_Policy_Process__c)||
               (application.B1_5e_1_DP_CP_Honesty_Revisions__c!=null && application.B1_5e_1_DP_CP_Honesty_Revisions__c==afc.B1_5e_1_DP_CP_Honesty_Revisions__c)||
               (application.B1_6_1_DP_Structure_Examples__c!=null && application.B1_6_1_DP_Structure_Examples__c==afc.B1_6_1_DP_Structure_Examples__c)||
               (application.B_1_1_1_AF_Explain_informed__c!=null && application.B_1_1_1_AF_Explain_informed__c==afc.B_1_1_1_AF_Explain_informed__c)||
               (application.B_1_2_1_Educational_Authority__c!=null && application.B_1_2_1_Educational_Authority__c==afc.B_1_2_1_Educational_Authority__c)||
               (application.B_1_2_1_Other_Description__c!=null && application.B_1_2_1_Other_Description__c==afc.B_1_2_1_Other_Description__c)||
               (application.B_1_2_2_Educational_Authority__c!=null && application.B_1_2_2_Educational_Authority__c==afc.B_1_2_2_Educational_Authority__c)||
               (application.B_1_2_2a_Authority_Formed__c!=null && application.B_1_2_2a_Authority_Formed__c==afc.B_1_2_2a_Authority_Formed__c)||
               (application.B_1_2_2a_Explain_Authority__c!=null && application.B_1_2_2a_Explain_Authority__c==afc.B_1_2_2a_Explain_Authority__c)||
               (application.B_1_2_3_Pedagogical_Leadership__c!=null && application.B_1_2_3_Pedagogical_Leadership__c==afc.B_1_2_3_Pedagogical_Leadership__c)||
               (application.B_1_2_3a_AF_Pedagogical_Changes__c!=null && application.B_1_2_3a_AF_Pedagogical_Changes__c==afc.B_1_2_3a_AF_Pedagogical_Changes__c)||
               (application.B_1_2_3b_AF_New_Members__c!=null && application.B_1_2_3b_AF_New_Members__c==afc.B_1_2_3b_AF_New_Members__c)||
               (application.B_1_2_4_Staff_Recruiting__c!=null && application.B_1_2_4_Staff_Recruiting__c==afc.B_1_2_4_Staff_Recruiting__c)||
               (application.B_1_2_5_Recruiting_Challenges__c!=null && application.B_1_2_5_Recruiting_Challenges__c==afc.B_1_2_5_Recruiting_Challenges__c)||
               (application.B_1_3_1_Common_Language__c!=null && application.B_1_3_1_Common_Language__c==afc.B_1_3_1_Common_Language__c)||
               (application.B_1_3_2_Different_Language__c!=null && application.B_1_3_2_Different_Language__c==afc.B_1_3_2_Different_Language__c)||
               (application.B_1_4_1_Weekly_Schedule__c!=null && application.B_1_4_1_Weekly_Schedule__c==afc.B_1_4_1_Weekly_Schedule__c)||
               (application.B_1_5_1DP_CP_Policy_Process__c!=null && application.B_1_5_1DP_CP_Policy_Process__c==afc.B_1_5_1DP_CP_Policy_Process__c)||
               (application.B_1_5a_3_PYP_MYP_Language_Provisions__c!=null && application.B_1_5a_3_PYP_MYP_Language_Provisions__c==afc.B_1_5a_3_PYP_MYP_Language_Provisions__c)||
               (application.B_2_AF_School_Changes__c!=null && application.B_2_AF_School_Changes__c==afc.B_2_AF_School_Changes__c))
                return false;
            else
                return true;
        }
        set;
    }
   @TestVisible public boolean isB2Changed
    {
        get
        {
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.B2_10_1a_Cp_IBCC_Choose_Course__c!=null && application.B2_10_1a_Cp_IBCC_Choose_Course__c==afc.B2_10_1a_Cp_IBCC_Choose_Course__c)||
               (application.B2_10_2_Standard_Level__c!=null && application.B2_10_2_Standard_Level__c==afc.B2_10_2_Standard_Level__c)||
               (application.B2_10_3_Display_Standard__c!=null && application.B2_10_3_Display_Standard__c==afc.B2_10_3_Display_Standard__c)||
               (application.B2_10_4_CP_Programme_Choices__c!=null && application.B2_10_4_CP_Programme_Choices__c==afc.B2_10_4_CP_Programme_Choices__c)||
               (application.B2_10a_2_Schedule_Adjustments__c!=null && application.B2_10a_2_Schedule_Adjustments__c==afc.B2_10a_2_Schedule_Adjustments__c)||
               (application.B2_10c_2_CP_IBCC_School_Adjustments__c!=null && application.B2_10c_2_CP_IBCC_School_Adjustments__c==afc.B2_10c_2_CP_IBCC_School_Adjustments__c)||
               (application.B2_10c_2_DP_CP_Schedule_Adjustments__c!=null && application.B2_10c_2_DP_CP_Schedule_Adjustments__c==afc.B2_10c_2_DP_CP_Schedule_Adjustments__c)||
               (application.B2_10c_2_MYP_Min_Req__c!=null && application.B2_10c_2_MYP_Min_Req__c==afc.B2_10c_2_MYP_Min_Req__c)||
               (application.B2_10c_2_MYP_Sched_Adj__c!=null && application.B2_10c_2_MYP_Sched_Adj__c==afc.B2_10c_2_MYP_Sched_Adj__c)||
               (application.B2_10c_2a_MYP_Instruct_Lang__c!=null && application.B2_10c_2a_MYP_Instruct_Lang__c==afc.B2_10c_2a_MYP_Instruct_Lang__c)||
               (application.B2_10c_3_MYP_Min_Teach__c!=null && application.B2_10c_3_MYP_Min_Teach__c==afc.B2_10c_3_MYP_Min_Teach__c)||
               (application.B2_10c_4_MYP_Sched_Adj__c!=null && application.B2_10c_4_MYP_Sched_Adj__c==afc.B2_10c_4_MYP_Sched_Adj__c)||
               (application.B2_10c_4_MYP_Teach_Hours__c!=null && application.B2_10c_4_MYP_Teach_Hours__c==afc.B2_10c_4_MYP_Teach_Hours__c)||
               (application.B2_10c_5_MYP_Lang_Sustained__c!=null && application.B2_10c_5_MYP_Lang_Sustained__c==afc.B2_10c_5_MYP_Lang_Sustained__c)||
               (application.B2_10c_5_MYP_Sched_Adj__c!=null && application.B2_10c_5_MYP_Sched_Adj__c==afc.B2_10c_5_MYP_Sched_Adj__c)||
               (application.B2_10c_6_MYP_No_Visual_Art__c!=null && application.B2_10c_6_MYP_No_Visual_Art__c==afc.B2_10c_6_MYP_No_Visual_Art__c)||
               (application.B2_10c_7_MYP_Describe_Sched__c!=null && application.B2_10c_7_MYP_Describe_Sched__c==afc.B2_10c_7_MYP_Describe_Sched__c)||
               (application.B2_10c_7_MYP_PE_50__c!=null && application.B2_10c_7_MYP_PE_50__c==afc.B2_10c_7_MYP_PE_50__c)||
               (application.B2_12_1_CP_IBCC_Support_Plan__c!=null && application.B2_12_1_CP_IBCC_Support_Plan__c==afc.B2_12_1_CP_IBCC_Support_Plan__c)||
               (application.B2_12_1_DP_Extended_Essay__c!=null && application.B2_12_1_DP_Extended_Essay__c==afc.B2_12_1_DP_Extended_Essay__c)||
               (application.B2_12_2_MYP_Community_Project__c!=null && application.B2_12_2_MYP_Community_Project__c==afc.B2_12_2_MYP_Community_Project__c)||
               (application.B2_12_3_MYP_Community_project__c!=null && application.B2_12_3_MYP_Community_project__c==afc.B2_12_3_MYP_Community_project__c)||
               (application.B2_12_4_MYP_Community_project__c!=null && application.B2_12_4_MYP_Community_project__c==afc.B2_12_4_MYP_Community_project__c)||
               (application.B2_12_5_MYP_Community_Project__c!=null && application.B2_12_5_MYP_Community_Project__c==afc.B2_12_5_MYP_Community_Project__c)||
               (application.B2_1_12_1_MYP_Personal_Project_Process__c!=null && application.B2_1_12_1_MYP_Personal_Project_Process__c==afc.B2_1_12_1_MYP_Personal_Project_Process__c)||
               (application.B2_1a_1_DP_CAS_Time__c!=null && application.B2_1a_1_DP_CAS_Time__c==afc.B2_1a_1_DP_CAS_Time__c)||
               (application.B2_1a_1a_Service_Learning_Time__c!=null && application.B2_1a_1a_Service_Learning_Time__c==afc.B2_1a_1a_Service_Learning_Time__c)||
               (application.B2_2_2_Staff_Standards__c!=null && application.B2_2_2_Staff_Standards__c==afc.B2_2_2_Staff_Standards__c)||
               (application.B2_3a_2_Staff_Training__c!=null && application.B2_3a_2_Staff_Training__c==afc.B2_3a_2_Staff_Training__c)||
               (application.B2_4_1_Collaborative_Planning__c!=null && application.B2_4_1_Collaborative_Planning__c==afc.B2_4_1_Collaborative_Planning__c)||
               (application.B2_5_1_Technology_Approach__c!=null && application.B2_5_1_Technology_Approach__c==afc.B2_5_1_Technology_Approach__c)||
               (application.B2_5_1_Text_b__c!=null && application.B2_5_1_Text_b__c==afc.B2_5_1_Text_b__c)||
               (application.B2_5_1_Text_c__c!=null && application.B2_5_1_Text_c__c==afc.B2_5_1_Text_c__c)||
               (application.B2_5_1_Text_d__c!=null && application.B2_5_1_Text_d__c==afc.B2_5_1_Text_d__c)||
               (application.B2_5_1_Text_f__c!=null && application.B2_5_1_Text_f__c==afc.B2_5_1_Text_f__c)||
               (application.B2_5_1_Text_h__c!=null && application.B2_5_1_Text_h__c==afc.B2_5_1_Text_h__c)||
               (application.B2_5_2_DP_CP_Community_Resources__c!=null && application.B2_5_2_DP_CP_Community_Resources__c==afc.B2_5_2_DP_CP_Community_Resources__c)||
               (application.B2_5_2_Internet_Access__c!=null && application.B2_5_2_Internet_Access__c==afc.B2_5_2_Internet_Access__c)||
               (application.B2_5_3_CP_Services_Learning__c!=null && application.B2_5_3_CP_Services_Learning__c==afc.B2_5_3_CP_Services_Learning__c)||
               (application.B2_5_4_CP_Skilss_Development__c!=null && application.B2_5_4_CP_Skilss_Development__c==afc.B2_5_4_CP_Skilss_Development__c)||
               (application.B2_5_4_Classroom_Computers__c!=null && application.B2_5_4_Classroom_Computers__c==afc.B2_5_4_Classroom_Computers__c)||
               (application.B2_5_4_Internet_Restrictions__c!=null && application.B2_5_4_Internet_Restrictions__c==afc.B2_5_4_Internet_Restrictions__c)||
               (application.B2_5b_DP_CP_IT_Facilities__c!=null && application.B2_5b_DP_CP_IT_Facilities__c==afc.B2_5b_DP_CP_IT_Facilities__c)||
               (application.B2_5c_1_DP_CP_Exam_Location__c!=null && application.B2_5c_1_DP_CP_Exam_Location__c==afc.B2_5c_1_DP_CP_Exam_Location__c)||
               (application.B2_6_1_CP_Library_Resources__c!=null && application.B2_6_1_CP_Library_Resources__c==afc.B2_6_1_CP_Library_Resources__c)||
               (application.B2_6_1_Independent_Access__c!=null && application.B2_6_1_Independent_Access__c==afc.B2_6_1_Independent_Access__c)||
               (application.B2_6_2_Browse_Borrow__c!=null && application.B2_6_2_Browse_Borrow__c==afc.B2_6_2_Browse_Borrow__c)||
               (application.B2_6_4_Study_Spaces__c!=null && application.B2_6_4_Study_Spaces__c==afc.B2_6_4_Study_Spaces__c)||
               (application.B2_6_5_Age_Group__c!=null && application.B2_6_5_Age_Group__c==afc.B2_6_5_Age_Group__c)||
               (application.B2_6_5a_Who_Else__c!=null && application.B2_6_5a_Who_Else__c==afc.B2_6_5a_Who_Else__c)||
               (application.B2_6_7_Whole_Class__c!=null && application.B2_6_7_Whole_Class__c==afc.B2_6_7_Whole_Class__c)||
               (application.B2_6_8_Class_Library__c!=null && application.B2_6_8_Class_Library__c==afc.B2_6_8_Class_Library__c)||
               (application.B2_6_8_Library_Managed__c!=null && application.B2_6_8_Library_Managed__c==afc.B2_6_8_Library_Managed__c)||
               (application.B2_6_9_Library_Description__c!=null && application.B2_6_9_Library_Description__c==afc.B2_6_9_Library_Description__c)||
               (application.B2_6a_2_DP_Adequate_Resources__c!=null && application.B2_6a_2_DP_Adequate_Resources__c==afc.B2_6a_2_DP_Adequate_Resources__c)||
               (application.B2_9a_1_CP_Guidance__c!=null && application.B2_9a_1_CP_Guidance__c==afc.B2_9a_1_CP_Guidance__c)||
               (application.B2_9a_1_DP_Guidance__c!=null && application.B2_9a_1_DP_Guidance__c==afc.B2_9a_1_DP_Guidance__c)||
               (application.B_2_AF_School_Changes__c!=null && application.B_2_AF_School_Changes__c==afc.B_2_AF_School_Changes__c)||
               (application.Does_the_school_have_WiFi__c!=null && application.Does_the_school_have_WiFi__c==afc.Does_the_school_have_WiFi__c)||
               (application.GEN_Current_Implementation__c!=null && application.GEN_Current_Implementation__c==afc.GEN_Current_Implementation__c)
              )
                return false;
            else
                return true;
        }
        set;
    }
   @TestVisible public boolean isC1Changed
    {
        get
        {
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.C1_1_1a_CP_Articulation__c!=null && application.C1_1_1a_CP_Articulation__c==afc.C1_1_1a_CP_Articulation__c)||
               (application.C1_1_1b_CP_Overview__c!=null && application.C1_1_1b_CP_Overview__c==afc.C1_1_1b_CP_Overview__c)||
               (application.C1_1_1c_CP_Differentiation__c!=null && application.C1_1_1c_CP_Differentiation__c==afc.C1_1_1c_CP_Differentiation__c)||
               (application.C1_1_1d_CP_Assessment__c!=null && application.C1_1_1d_CP_Assessment__c==afc.C1_1_1d_CP_Assessment__c)||
               (application.C1_1_1e_CP_Learner_Profile__c!=null && application.C1_1_1e_CP_Learner_Profile__c==afc.C1_1_1e_CP_Learner_Profile__c)||
               (application.C1_1_CP_DP_Planning_Changes__c!=null && application.C1_1_CP_DP_Planning_Changes__c==afc.C1_1_CP_DP_Planning_Changes__c)||
               (application.C1_4_1_DP_Desc_Collab__c!=null && application.C1_4_1_DP_Desc_Collab__c==afc.C1_4_1_DP_Desc_Collab__c)||
               (application.C1_5_1_DP_Desc_Collab__c!=null && application.C1_5_1_DP_Desc_Collab__c==afc.C1_5_1_DP_Desc_Collab__c)||
               (application.C1_7_1A_Learning_Skills_Dev__c!=null && application.C1_7_1A_Learning_Skills_Dev__c==afc.C1_7_1A_Learning_Skills_Dev__c)||
               (application.C1_7_1B_Student_Feedback__c!=null && application.C1_7_1B_Student_Feedback__c==afc.C1_7_1B_Student_Feedback__c)||
               (application.C1_7_1D_Meaningful_Reflection__c!=null && application.C1_7_1D_Meaningful_Reflection__c==afc.C1_7_1D_Meaningful_Reflection__c)||
               (application.C1_8_1_DP_Learning_Efforts__c!=null && application.C1_8_1_DP_Learning_Efforts__c==afc.C1_8_1_DP_Learning_Efforts__c)||
               (application.DP_CP_C1_9_1A_Int_mindedness__c!=null && application.DP_CP_C1_9_1A_Int_mindedness__c==afc.DP_CP_C1_9_1A_Int_mindedness__c)||
               (application.MYP_DP_C1_9_1B_Learner_Incorporation__c!=null && application.MYP_DP_C1_9_1B_Learner_Incorporation__c==afc.MYP_DP_C1_9_1B_Learner_Incorporation__c)
              )
                return false;
            else
                return true;
        }
        set;
    }
   @TestVisible public boolean isC2Changed
    {
        get
        {
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.C2_1c_1_DP_Chosen_Levels__c!=null && application.C2_1c_1_DP_Chosen_Levels__c==afc.C2_1c_1_DP_Chosen_Levels__c)||
               (application.Additional_Comments__c!=null && application.Additional_Comments__c==afc.Additional_Comments__c)||
               (application.C2_1D_1_CP_IBCC_School_Components__c!=null && application.C2_1D_1_CP_IBCC_School_Components__c==afc.C2_1D_1_CP_IBCC_School_Components__c)||
               (application.C2_1_1B_Requirement_Challenges__c!=null && application.C2_1_1B_Requirement_Challenges__c==afc.C2_1_1B_Requirement_Challenges__c)||
               (application.C2_1_1_Other_Mandated_Requirements__c!=null && application.C2_1_1_Other_Mandated_Requirements__c==afc.C2_1_1_Other_Mandated_Requirements__c)||
               (application.C2_1e_1_CP_IBCC_Learning_Plans__c!=null && application.C2_1e_1_CP_IBCC_Learning_Plans__c==afc.C2_1e_1_CP_IBCC_Learning_Plans__c)||
               (application.C2_1f_1_CP_Desc_Plans__c!=null && application.C2_1f_1_CP_Desc_Plans__c==afc.C2_1f_1_CP_Desc_Plans__c)||
               (application.C2_1g_1_Reflective_Plans__c!=null && application.C2_1g_1_Reflective_Plans__c==afc.C2_1g_1_Reflective_Plans__c)||
               (application.C2_2_1_DP_Curriculum_Plans__c!=null && application.C2_2_1_DP_Curriculum_Plans__c==afc.C2_2_1_DP_Curriculum_Plans__c)||
               (application.PYP_C2_4a_1_Scope_Sequence__c!=null && application.PYP_C2_4a_1_Scope_Sequence__c==afc.PYP_C2_4a_1_Scope_Sequence__c)
              )
                return false;
            else
                return true;
        }
        set;
    }
   @TestVisible public boolean isC3Changed
    {
        get
        {
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.C3_1_1_PYP_Implementation_Changes__c!=null && application.C3_1_1_PYP_Implementation_Changes__c==afc.C3_1_1_PYP_Implementation_Changes__c)||               
               (application.C3_1_1_MYP_Implementation_Changes__c!=null && application.C3_1_1_MYP_Implementation_Changes__c==afc.C3_1_1_MYP_Implementation_Changes__c))
                return false;
            return true;
        }
        set;
    }
   @TestVisible public boolean isC4Changed
    {
        get
        {
            checkApplicationsExist();
            if(application.Is_Agreement_Confirmed__c)
                return true;
            if((application.B2_12_1_DP_Extended_Essay__c!=null && application.B2_12_1_DP_Extended_Essay__c==afc.B2_12_1_DP_Extended_Essay__c)||
               (application.C4_1_1_Assess_Student_Learning__c!=null && application.C4_1_1_Assess_Student_Learning__c==afc.C4_1_1_Assess_Student_Learning__c)||
               (application.C4_1b_1_MYP_Student_Learning_Changes__c!=null && application.C4_1b_1_MYP_Student_Learning_Changes__c==afc.C4_1b_1_MYP_Student_Learning_Changes__c)||
               (application.C4_1b_1_PYP_Student_Learning_Changes__c!=null && application.C4_1b_1_PYP_Student_Learning_Changes__c==afc.C4_1b_1_PYP_Student_Learning_Changes__c)||
               (application.C4_6_1_DP_Assessment_Report__c!=null && application.C4_6_1_DP_Assessment_Report__c==afc.C4_6_1_DP_Assessment_Report__c)||
               (application.C4_6_1_MYP_Student_Achievements__c!=null && application.C4_6_1_MYP_Student_Achievements__c==afc.C4_6_1_MYP_Student_Achievements__c)||
               (application.C4_6_1_PYP_Student_Achievements__c!=null && application.C4_6_1_PYP_Student_Achievements__c==afc.C4_6_1_PYP_Student_Achievements__c)||
               (application.C4_6a_1_Learner_Profile_Description__c!=null && application.C4_6a_1_Learner_Profile_Description__c==afc.C4_6a_1_Learner_Profile_Description__c)||
               (application.C4_8_1_DP_Teacher_Efforts__c!=null && application.C4_8_1_DP_Teacher_Efforts__c==afc.C4_8_1_DP_Teacher_Efforts__c)
              )
                return false;
            else
                return true;
        }
        set;
    }

}