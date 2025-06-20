public class PimsApplicationForCandidacyController extends PimsApplicationControllerHelper {

    public String appId {get;set;}

    public transient IB_Application__c application {get;set;}
    public transient IB_Programme__c programme {get;set;}

    public Account account {get;set;}
    public List<IB_Address__c> addresses {get;set;}
    public List<SchoolSections__c> sections {get;set;}
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public List<IB_Programme__c> programmes {get;set;}
    public Boolean showPageDetails {get; set;}
    
    public List<IB_Application_Attachment__c> attachments {get;set;}

    public List<Application_Budget_Table__c> applicationBudgetTable {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {get;set;}

    public List<IB_Application_Curriculum_Requirement__c> applicationRequirementsList {get;set;}

    public Application_Coordinator_Time__c editCoordinatorTime {get;set;}
    /*public List<Application_Coordinator_Time__c> coordnatorTimeList {get;set;}*/

    public Application_Account_Facilities__c applicationAccountFacilities {get;set;}
    public List<Application_Account_Facilities__c> applicationAccountFacilitiesList {get;set;}

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

    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }

    //private ProfileService profileService = new ProfileService();

    public void init() {

        if(getIsIBEN()) {
            PageService.setPage('IbenApplicationForCandidacy');
        } else {
        	PageService.setPage('PimsApplicationForCandidacy');    
        }
        
        //This Part of Code is being updated by Ammara-Plumlogix,as a part of DE6234 related to CR-648
        //This Change include the visibility of Print Application form section only in the case of Agreement Tab
        activeTab = ApexPages.currentPage().getParameters().get('tab');
        System.debug('Active Tab Init(Current Page): '+activeTab);
        //End
        // we should never fall into here, but just in case show the info tab panel
        if(activeTab == null || activeTab == '') {
        	activeTab = PageService.getActiveTab();    
        }        
        if (activeTab == null || activeTab == '') {
            activeTab = 'profile';
        }

    }

    public PimsApplicationForCandidacyController() {

        appId = ApexPages.currentPage().getParameters().get('id');
        
        if(activeTab == null || activeTab == '') {
            activeTab = ApexPages.currentPage().getParameters().get('tab');
        }        
        if(activeTab == null || activeTab == '') {
            if(getIsIBEN()) {
                PageService.setPage('IbenApplicationForCandidacy');
            } else {
                PageService.setPage('PimsApplicationForCandidacy');    
            }
            activeTab = PageService.getActiveTab();    
        }        
        if (activeTab == null || activeTab == '') {
            activeTab = 'profile';
        }
        
        PageReference pageRef = ApexPages.currentPage();
        String url = pageRef.getUrl();

        if (appId == null) {
            throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        }

        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();

        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();

        // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/16/2019, QA Class Failure
        //begin 
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
        //End
		programme = ProgrammeService.getProgramme();

        if (!url.contains('IbenApplicationForCandidacy')) {
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

    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }

    public PageReference getActiveSection(){
         System.debug('Active Tab(Section): '+activeTab);
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
            'agreement' => Page.AFC_Section_Agreement
                };
                    
                    if(activeTab == null || activeTab == '') {
                        activeTab = ApexPages.currentPage().getParameters().get('tab');
                    }
        //End
        // we should never fall into here, but just in case show the info tab panel
        if(activeTab == null || activeTab == '') {
            if(getIsIBEN()) {
                PageService.setPage('IbenApplicationForCandidacy');
            } else {
                PageService.setPage('PimsApplicationForCandidacy');    
            }
        	activeTab = PageService.getActiveTab();    
        }        
        if (activeTab == null || activeTab == '') {
            activeTab = 'profile';
        }

        PageReference tmp = tmpKey.get(activeTab);
        tmp.getParameters().put('id', appId);
        tmp.setredirect(true);

        return tmp;
    }
}