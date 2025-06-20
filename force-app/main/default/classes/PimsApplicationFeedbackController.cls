/*******************************************************************************************
* @Name         PimsApplicationFeedbackController
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Ranjith Kondabathini      05/18/2023         Removed unncessary local variable for programme coordinator and using  the getter
*******************************************************************************************/
public class PimsApplicationFeedbackController{
    
    public String fbId {get;set;}
    public String consultantfbId {get;set;}
    public String appId {get;set;}
    public String accId {get;set;}
    public String progId {get;set;}
    public String tab {get;set;}
    public String path {get;set;}
    public String url {get;set;}
    public String devPath {get;set;}
    public String redirectUrl {get;set;}
    String currPage = ApexPages.currentPage().getUrl();
    public Boolean isConsultantViewing {get;set;}
    
    public String budgetId {get;set;}
    public String editBudgetId {get;set;}
    
    public Account account {get;set;}
    
    public IB_Address__c address {get;set;}
    public List<IB_Address__c> addressList {get;set;}
    
    public IB_Application_Feedback__c pimsApplicationFeedback {get;set;}
    public IB_Consultant_Feedback__c pimsConsultationFeedback {get;set;}
    public List<IB_Application_Feedback__c> pimsApplicationFeedbackList {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    
    public Application_Budget_Table__c budget {get;set;}
    public Application_Budget_Table__c removeBudget {get;set;}
    public Application_Budget_Table__c applicationBudget {get;set;}
    public List<Application_Budget_Table__c> appBudget {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetTable {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {get;set;}
    public List<Application_Budget_Table__c> buds {get;set;}
    public String[] lines {get;set;}
    
    public Application_Teaching_Time__c appTeachingTime {get;set;}
    
    public IB_Application__c application {get;set;}
    public List<IB_Application__c> applicationList {get;set;}
    public List<SchoolSections__c> sections {get;set;}
    
    public IB_Programme__c programme  {get;set;}
    public List<IB_Programme__c> programmeList  {get;set;}
    
    public List<SchoolSections__c> sectionsList {get;set;}
    
    public IB_Role__c progCoordinator {get;set;}
    
    public List<Application_Staff_Table__c> applicationStaffTable {get;set;}
    
    public Id deleteAfbId {get;set;}
    
    public String activeTab {get;set;}
    public Boolean isUpdatePage {get;set;}
    
    public String progType {get;set;}
    
    public Boolean isIben {get;set;}
    public Boolean isPims {get;set;}
    public Boolean isInternal {get;set;}
    public Boolean isApplicationFeedback {get;set;}
    public Boolean isConsultantFeedback {get;set;}
    
    public String ibenPath {get;set;}
    public String pimsPath {get;set;}
    public String intPath {get;set;}
    
    public List<Application_Teaching_Time__c> applicationTeachingTimeList {get;set;}
    public List<IB_Application_Curriculum_Requirement__c> applicationRequirements {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}
    public List<IB_Role__c> rolesByProgramme {get;set;}
    public List<Contact> contacts {get;set;}
    public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
    public List<Contact_Professional_Development__c> proDevByRoles {get;set;}
    
    public Decimal mypStudentTotal {get;set;}
    public Decimal pypStudentTotal {get;set;}
    
    public map<String, Pagereference> tabMappings = new map<String, Pagereference>{
        'instructions'=>Page.PimsAppFeedback_Section_Instructions,
            'legal'=>Page.PimsAppFeedback_Section_Legal,
            'name'=>Page.PimsAppFeedback_Section_Name,
            'mission'=>Page.PimsAppFeedback_Section_Mission,
            'campus'=>Page.PimsAppFeedback_Section_Campus,
            'continuum'=>Page.PimsAppFeedback_Section_Continuum,
            'programme'=>Page.PimsAppFeedback_Section_Programme,
            'budget'=>Page.PimsAppFeedback_Section_Budget,
            'action'=>Page.PimsAppFeedback_Section_Action,
            'community'=>Page.PimsAppFeedback_Section_Community,
            'cas'=>Page.PimsAppFeedback_Section_CAS,
            'tok'=>Page.PimsAppFeedback_Section_TOK,
            'partner'=>Page.PimsAppFeedback_Section_Partner,
            'length'=>Page.PimsAppFeedback_Section_Length,
            'language'=>Page.PimsAppFeedback_Section_Language,
            'part'=>Page.PimsAppFeedback_Section_Part,
            'gradual'=>Page.PimsAppFeedback_Section_Gradual,
            'subject'=>Page.PimsAppFeedback_Section_Subject,
            'structure'=>Page.PimsAppFeedback_Section_Structure,
            'commitment'=>Page.PimsAppFeedback_Section_Commitment,
            'cq'=>Page.PimsAppFeedback_Section_CQ,
            'diploma'=>Page.PimsAppFeedback_Section_Diploma,
            'development'=>Page.PimsAppFeedback_Section_Dev,
            'sched'=>Page.PimsAppFeedback_Section_Sched
            };
                
                
                public void init() {
                    
                    /*PageService.setPage('InternalApplicationFeedback');
activeTab = PageService.getActiveTab();

if (activeTab == null) {
activeTab = 'instructions';
}*/
                    
                }
    
    public String SaveFeedback {
        get {
            return this.getTranslationsMap().get(IboUtil.Pims_Save_Feedback);
        }
        set;
    }
       public String viewActionPlans {
        get {
            return this.getTranslationsMap().get(IboUtil.Iben_Application_ViewActionPlan);
        }
        set;
    }
    private final List<String> constantList = new List<String>{IboUtil.Pims_Save_Feedback,IboUtil.Iben_Application_ViewActionPlan};
        public static final Map<String, String> languageCodeMap {
        get {
            Map<String, String> languageMap = new Map<String, String>();
            languageMap.put('fr', 'French');
            languageMap.put('es', 'Spanish');
            return languageMap;
        }
    }
    transient Map<String, String> translationsMap;
    
    public  Map<String, String> getTranslationsMap() {        
        if (null == this.translationsMap) {
            try {
                String userLanguage = null != languageCodeMap.get(UserInfo.getLanguage()) ? languageCodeMap.get(UserInfo.getLanguage()) : 'American English';
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                     WHERE CustomLabel__r.Label__c =: constantList
                                                     AND Language__c = :userLanguage];
                
                this.translationsMap = new Map<String, String>();
                
                for (Translation__c translation : translations) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                } 
            }
            catch (Exception ex) {
                Logger.get().add(ex, LogSeverity.ERROR).publish();               
            }
        }
        
        return this.translationsMap;
    }
    
    public PimsApplicationFeedbackController() {
        //PimsCommunityService pimsService = new PimsCommunityService();
        //pimsService.initUserData();
        
        isConsultantViewing = false;
        if(ApexPages.currentPage().getParameters().containsKey('conview')){
            isConsultantViewing = true;
        }
        
        fbId = ApexPages.currentPage().getParameters().get('id');
        isApplicationFeedback = false;
        isConsultantFeedback = false;
        if (fbId.substring(0,3) == 'a2E'){
            isApplicationFeedback = true;
        }else if (fbId.substring(0,3) == 'a2u'){
            isConsultantFeedback = true;
        }
        activeTab = ApexPages.currentPage().getParameters().get('tab');
        
        if (activeTab == null || activeTab == '') {
            activeTab = 'instructions';
        }
        
        // Get the programme ID related to the current Application Feedback record
        String currentProg2 = [SELECT FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__c FROM IB_Application_Feedback__c WHERE Id = :fbId].FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__c;
        
        // Get the ID related to the current consultant feedback record
        //consultantfbId = [SELECT Id FROM IB_Consultant_Feedback__c WHERE Status__c != 'Submitted' AND IB_Programme_Lookup__c = :currentProg2 LIMIT 1].Id;
        system.debug('fbId =====> '+fbId);
        if(isConsultantFeedback){
            //  pimsConsultationFeedback = [SELECT Id,Name,IB_Application__c FROM IB_Consultant_Feedback__c WHERE Status__c != 'Submitted' AND IB_Application__c = :fbId];
            pimsConsultationFeedback = [SELECT Id,Name,IB_Application__c FROM IB_Consultant_Feedback__c WHERE Status__c not in ('Submitted','Published') AND IB_Application__c = :fbId];
        }
        pimsApplicationFeedbackList = [
            SELECT Id, OwnerId, IsDeleted, Name, AccountSchoolName__c, FB_AP_Comment_1__c, FB_AP_Requirement_Met_1__c, FB_Application_ID__c, FB_BD_Comment_1__c,
            FB_BD_Comment_2__c, FB_BD_Comment_3__c, FB_BD_Comment_4__c, FB_BD_Comment_5__c, FB_BD_Requirement_Met_1__c, FB_BD_Requirement_Met_2__c, FB_BD_Requirement_Met_3__c,
            FB_BD_Requirement_Met_4__c, FB_BD_Requirement_Met_5__c, FB_CAS_Comment_1__c, FB_CAS_Requirement_Met_1__c, FB_SL_Comment_1__c, FB_SL_Requirement_Met_1__c,
            FB_CIB_Comment_1__c, FB_CIB_Requirement_Met_1__c, FB_CQ_Comment_1__c, FB_CQ_Comment_2__c, FB_CQ_Comment_3__c, FB_CQ_Comment_4__c, FB_CQ_Requirement_Met_1__c, FB_CQ_Requirement_Met_2__c,
            FB_CQ_Requirement_Met_3__c, FB_CQ_Requirement_Met_4__c, FB_Documents_Expiration__c, FB_EP_Comment_1__c, FB_EP_Requirement_Met_1__c, FB_FD_Comment_1__c, FB_FD_Comment_2__c,
            FB_FD_Requirement_Met_1__c, FB_FD_Requirement_Met_2__c, FB_GI_Comment_1__c, FB_GI_Requirement_Met_1__c, FB_Head_of_School__c, FB_LD_Comment_1__c, FB_LD_Requirement_1__c,
            FB_LD_Requirement_Met_1__c, FB_LE_Comment_1__c, FB_LE_Comment_2__c, FB_LE_Comment_3__c, FB_LE_Comment_4__c, FB_LE_Comment_5__c, FB_LE_Comment_6__c, FB_LE_Comment_7__c, FB_LE_Requirement_Met_1__c,
            FB_LE_Requirement_Met_2__c, FB_LE_Requirement_Met_3__c, FB_LE_Requirement_Met_4__c, FB_LE_Requirement_Met_5__c, FB_LE_Requirement_Met_6__c, FB_LE_Requirement_Met_7__c, FB_LG_Comment_1__c,
            FB_LG_Comment_2__c, FB_LG_Comment_3__c, FB_LG_Requirement_Met_1__c, FB_LG_Requirement_Met_2__c, FB_LG_Requirement_Met_3__c, FB_LI_Comment_1__c, FB_LI_Comment_2__c, FB_LI_Requirement_Met_1__c,
            FB_LI_Requirement_Met_2__c, FB_LOM_Comment_1__c, FB_LOM_Requirement_Met_1__c, FB_MC_Comment_1__c, FB_MC_Comment_2__c, FB_MC_Comment_3__c,
            FB_MC_Comment_4__c, FB_MC_Comment_5__c, FB_MC_Comment_6__c, FB_MC_Comment_7__c, FB_MC_Comment_8__c, FB_MC_Comment_9__c, FB_MC_Requirement_Met_1__c, FB_MC_Requirement_Met_2__c,
            FB_MC_Requirement_Met_3__c, FB_MC_Requirement_Met_4__c, FB_MC_Requirement_Met_5__c, FB_MC_Requirement_Met_6__c, FB_MC_Requirement_Met_7__c, FB_MC_Requirement_Met_8__c,
            FB_MC_Requirement_Met_9__c, FB_PC_Comment_1__c, FB_PC_Requirement_Met_1__c, FB_PD_Comment_1__c, FB_PD_Comment_2__c, FB_PD_Comment_3__c, FB_PD_Requirement_Met_1__c, FB_PD_Requirement_Met_2__c,
            FB_PD_Requirement_Met_3__c, FB_PSG_Comment_1__c, FB_PSG_Requirement_Met_1__c, FB_PS_Comment_1__c, FB_PS_Comment_2__c, FB_PS_Comment_3__c, FB_PS_Comment_4__c, FB_PS_Comment_5__c,
            FB_PS_Requirement_Met_1__c, FB_PS_Requirement_Met_2__c, FB_PS_Requirement_Met_3__c, FB_PS_Requirement_Met_4__c, FB_PS_Requirement_Met_5__c, FB_Programme_Coordinator__c, FB_Programme__c,
            FB_SC_Comment_1__c, FB_SC_Requirement_Met_1__c, FB_SM_Comment_1__c, FB_SM_Comment_2__c, FB_SM_Comment_3__c, FB_SM_Comment_4__c, FB_SM_Requirement_Met_1__c, FB_SM_Requirement_Met_2__c,
            FB_SM_Requirement_Met_3__c, FB_SM_Requirement_Met_4__c, FB_SN_Comment_1__c, FB_SN_Comment_2__c, FB_SN_Requirement_Met_2__c, FB_SP_Comment_1__c, FB_SP_Requirement_Met_1__c, FB_STR_Comment_1__c,
            FB_STR_Comment_2__c, FB_STR_Comment_3__c, FB_STR_Requirement_Met_1__c, FB_STR_Requirement_Met_2__c, FB_STR_Requirement_Met_3__c, FB_School_Code__c, FB_School_Mission__c, FB_School_Name__c,
            FB_School_Open__c, FB_TOK_Comment_1__c, FB_TOK_Requirement_1__c, FB_TOK_Requirement_Met_1__c, Date_Submitted__c, Status__c, FB_SN_Requirement_Met_1__c, Current_Mission_Lookup__c,
            FB_Lookup_IB_Application__c, FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__c, FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c, FB_Feedback_Completed__c
            FROM IB_Application_Feedback__c
            WHERE FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__c = :currentProg2
        ];
        
        System.debug('pimsApplicationFeedbackList =====> '+pimsApplicationFeedbackList);
        
        FOR (IB_Application_Feedback__c rec : pimsApplicationFeedbackList) {
            if (rec.Name.endsWith('Candidacy Feedback')) pimsApplicationFeedback = rec;
            //if (rec.Name.endsWith('Consultation Feedback') && rec.Status__c != 'Submitted') pimsConsultationFeedback = rec;
        }
        if(pimsApplicationFeedback!=null){//inc0207579 ben mcgarvey, adding in check to prevent null pointer exception
        	System.debug('application =====>' + pimsApplicationFeedback.FB_Lookup_IB_Application__c);
        	System.debug('object data =====>' + pimsApplicationFeedback);
        
        	if (pimsApplicationFeedback.Name.endsWith('Candidacy Feedback')) appId = pimsApplicationFeedback.FB_Lookup_IB_Application__c;
        	if (pimsApplicationFeedback.Name.endsWith('Candidacy Feedback')) accId = pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c;
        }else{
            System.debug('object data was null =====>' + pimsApplicationFeedback);
        }
		if(isConsultantFeedback){
            if (pimsConsultationFeedback.Name.endsWith('Consultation Feedback')) appId = pimsConsultationFeedback.IB_Application__c;
            if (pimsConsultationFeedback.Name.endsWith('Consultation Feedback')) accId = pimsConsultationFeedback.IB_Application__r.Application_Lookup_to_Programme__r.Account__c;
        }
        /*progId = application.Application_Lookup_to_Programme__r.Id;*/
        
        System.debug('big query ran');
        
        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();
        applicationRequirements = ApplicationService.getApplicationRequirements();
        subjectProposals = ApplicationService.getSubjectProposals();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        programme = ProgrammeService.getProgramme();
        
        RoleService.setAccountId(accId);
        RoleService.setProgrammeId(programme.Id);
        rolesByProgramme = RoleService.getRolesByProgrammeId();
        
        ContactService.setAccountId(accId);
        contacts = ContactService.getContacts();
        
        List<Id> roleIdList = new List<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            if (r.IB_Role_Name__c == 'Teacher') {
                roleIdList.add(r.Id);
            }
        }
        RoleApplicationSubjectService.setRoleList(roleIdList);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
        
        roleIdList = new List<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            roleIdList.add(r.Id);
        }
        ContactPDService.setRoleList(roleIdList);
        proDevByRoles = ContactPDService.getProfessionalDevelopmentByRoleList();
        
        system.debug('programme =====> '+programme);
        system.debug('progType =====> '+programme.RecordType.Name);
        
        progType = programme.RecordType.Name;
        
        account = [
            SELECT Id, Legal_Name__c, Website, Name, Total_Number_Of_Students__c
            FROM Account
            WHERE Id = :accId
        ];
        
        System.debug(LoggingLevel.ERROR, 'progType = ' + progType + ' accId = '+accId);
        
        progCoordinator = [
            SELECT Id, Name, IB_Account__c, IB_Contact__c, IB_Programme__c, IB_Role_Name__c, IB_Role__c, First_Name__c , Last_Name__c, Programme_Type__c, Role_Level__c
            FROM IB_Role__c
            WHERE IB_Role_Name__c = 'Programme Coordinator' AND Programme_Type__c = :progType AND IB_Account__c = :accId AND End_Date__c = null limit 1
        ];
        
        programmeList = [
            SELECT Id, Name, Account__c, Programme_Legal_Name__c, PR_5_Languages__c, Type__c
            FROM IB_Programme__c
            WHERE Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
        ];
        
        applicationBudgetList = [
            SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
            PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
            PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
            Fee_Item__c
            FROM Application_Budget_Table__c
            WHERE IB_Programme__c = :programme.Id
        ];
        
        addressList = [
            SELECT Id, Address_Line_1__c, City__c, Country__c, IB_Account__c, Postal_Code__c, Province__c, Status__c, Name
            FROM IB_Address__c
            WHERE IB_Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
        ];
        
        sectionsList = [
            SELECT Id, Name, Account__c, Age_From__c, Age_To__c, Grade_From__c, Number_Of_Classes__c, Grade_To__c, Number_Of_Students__c, Other__c, Section_Name__c
            FROM SchoolSections__c
            WHERE Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
        ];
        
        applicationStaffTable = [
            SELECT B2_2_2_Staff_Standards__c, B2_2_3_Full_Time__c, B2_2_4_Part_Time__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Staff_Table__c
            WHERE IB_Application_Lookup__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__c
        ];
        
        buds = [
            Select Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
            PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
            PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
            Fee_Item__c
            From Application_Budget_Table__c
            Where PR_12_budget_Line__c IN ( 'Other','Professional Development', 'Fee','Resource')
            AND IB_Programme__c = :programme.Id
        ];
        
        applicationTeachingTimeList = [
            SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
            B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
            FROM Application_Teaching_Time__c
            WHERE IB_Application_Lookup__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__c
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
        
        // lines = budget lines; dynamically create set of unique lines from query
        Set<String> lineSet = new Set<String>();
        for (Application_Budget_Table__c a : buds)
            lineSet.add(a.PR_12_budget_Line__c);
        
        // convert the set into a string array
        lines = new String[lineSet.size()];
        Integer i = 0;
        for (String line : lineSet) {
            lines[i] = line;
            i++;
        }
        
        url = ApexPages.currentPage().getUrl();
        path = url.substring( url.indexOf( '/' ), url.indexOf( '?' ) );
        path = url.substring( url.indexOf( '/' ), url.indexOf( '?' ) );
        ibenPath = '/educator/IbenApplicationFeedback';
        pimsPath = '/pims/PimsApplicationFeedback';
        intPath = '/apex/InternalApplicationFeedback';
        
        isPims = path.contains( 'Pims' );
        
        // path return begins with /apex/ right now while developing so were going to have a devPath and just path will work in future -js
        devPath = '/educator' + path;
        
        System.debug('apex path == ' + path);
        System.debug('developing path == ' + devPath);
        
        if(isPims == True && activeTab == null) {
            activeTab = 'legal';
        }
        
        isIben = path.contains( 'Iben' );
        isInternal = path.contains( 'Internal' );
        
        if(isIben == True && activeTab == null) {
            activeTab = 'instructions';
        }
        
        SchoolSectionsService.setAccountId(account.Id);
        sections = SchoolSectionsService.getSectionsByAccount();
        
        System.debug('Made it to the end');
    }
    
    public String getFeasabilityContacts() {
        
        try {
            
            String currentContacts = application.AC_3_1_Feasability_Leads__c;
            
            String[] currContactsList = new String[]{};
                if (currentContacts != null && currentContacts != '') {
                    currContactsList = currentContacts.split(',');
                }
            
            String contactList = '';
            for (Contact c: [SELECT Id, Name, Title, Job_Title__c FROM Contact WHERE AccountId = :programme.Account__c]){
                if (c.Job_Title__c != null) {
                    contactList += c.Name + ' - (' + c.Job_Title__c + ')<br />';
                }
                else {
                    contactList += c.Name + ' - (No Job Title)<br />';
                }
            }
            
            return contactList;
        }
        catch (Exception ex) {
            return ' ';
        }
        
    }
    
    public virtual Boolean getIsEditable() {
        
        List<String> editProfileNames = new List<String>();
        editProfileNames.add('System Administrator');
        editProfileNames.add('SCU + Advanced');
        editProfileNames.add('Customer Community Advanced');
        editProfileNames.add('SCU + Basic');
        
        
        
        
        
        editProfileNames.add('');
        
        Profile currProfile = [ SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1 ];
        
        for (String name : editProfileNames) {
            if (name == currProfile.Name && (!currPage.contains('IbenInternalAppFeedback'))) {
                return true;
            }
        }
        
        return false;
    }
    
    public  Boolean getIsPyp() {
        
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'PYP') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public virtual Boolean getIsMyp() {
        
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'MYP') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public virtual Boolean getIsMypPartner() {
        
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'MYP Partner') {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    public virtual Boolean getIsDp() {
        
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'Diploma Programme') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public virtual Boolean getIsCp() {
        
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public virtual Boolean getIsCpPhase1() {
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public virtual Boolean getIsCpPhase2() {
        
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
            return true;
        }
        else {
            return false;
        }
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public PageReference save() {
        
        try {
            System.debug('Active Tab**************** '+activeTab);
            update pimsApplicationFeedback;
            //This code is updated by Umair-Plumlogix of Staff Augmentation Project of US11961 on 7/14/2020 
            //Start                       
            if (activeTab == 'legal') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Legal_Entity));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=name';
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=name';
                }
            }
            else if (activeTab == 'name') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Name_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=mission';
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=mission';
                }
            }
            else if (activeTab == 'mission') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_Mission_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=campus';
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=campus';
                }
            }
            else if (activeTab == 'campus') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Multi_Campus_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=programme';
                    /*if(getIsCP()||getIsMYP() == true) {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=programme';
} else {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=continuum';
}*/
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=programme';
                    /*if(getIsCP() ||getIsMYP() == true) {
redirectUrl = path + '?id=' + fbId + '&tab=programme';
} else {
redirectUrl = path + '?id=' + fbId + '&tab=continuum';
}*/
                }
                
            }
            else if (activeTab == 'continuum') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.IB_Section_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=programme';
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=programme';
                }
                
            }
            else if (activeTab == 'programme') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Programme_Section_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=budget';
                }else {
                    redirectUrl = path + '?id=' + fbId + '&tab=budget';
                }
                
            }
            else if (activeTab == 'budget') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Section_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=commitment';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=commitment';
                }
                
            }
            else if (activeTab == 'commitment') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PD_Section_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=action';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=action';
                }
                
            }
            else if (activeTab == 'action') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Action_Plan_Section));
                if(isIben == true) {
                    if(getIsDP() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=community';
                    } else
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=community';
                    
                } else if (getIsDP() == true) {
                    redirectUrl = path + '?id=' + fbId + '&tab=community';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=community';
                }
                
            }
            /* else if (activeTab == 'diploma') { 
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Diploma_Section));
if (isIben == true) {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=community';
} else {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=community';
}
} */
            else if (activeTab == 'community') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Community_Section));
                if(isIben == true) {
                    if(getIsCP() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=cq';  
                    }else if (getIsDP() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=diploma';  
                    }else if (getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=language';
                    } else {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=language';
                    }
                } else {
                    if(getIsCP() == true) {
                        redirectUrl = path + '?id=' + fbId + '&tab=cq'; 
                    }else if (getIsDP() == true) {
                        redirectUrl = path + '?id=' + fbId + '&tab=diploma'; 
                    }else if (getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = path + '?id=' + fbId + '&tab=language';
                    } else {
                        redirectUrl = path + '?id=' + fbId + '&tab=language';
                    }
                }
            }
            else if (activeTab == 'cas') {
                if (getIsCp() == true) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.CAS2_Section));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.CAS_Section));
                }
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=tok';
                }else{
                    redirectUrl = path + '?id=' + fbId + '&tab=tok';
                }
            }
            else if (activeTab == 'tok' && getIsCp() == true) {
                if (getIsCp() == true) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.TOK2_Section));
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.TOK_Section));
                }
                if(isIben == true && getIsCp() == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=cq';
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved));
                    
                    pimsApplicationFeedback.Status__c = 'Submitted';
                    pimsApplicationFeedback.Date_Submitted__c = date.today().format();
                    update pimsApplicationFeedback;
                    
                    if(isIben == true){
                        redirectUrl = '/educator/myassignments';
                    } else if (isPims == true) {
                        redirectUrl = '/pims/PimsDashboard';
                    } else {
                        redirectUrl = '/' + fbId;
                    }
                }
            }
            else if (activeTab == 'cq') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.CP_Section_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=development';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=development';
                }
                
            }
            /*else if (activeTab == 'development') { 
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Language_Development));
if(isIben == true) {
if(getIsCP() == true) {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=sched';
}else if (getIsPYP() == true){
redirectUrl = ibenPath + '?id=' + fbId + '&tab=structure';
}
} else {
redirectUrl = path + '?id=' + fbId + '&tab=sched';
}

}*/
            else if (activeTab == 'partner') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Partner_Section));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=length';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=length';
                }
            }
            else if (activeTab == 'length') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.MYP_Saved));
                if(isIben == true) {
                    if(getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=gradual';
                    }else{
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=language';
                    }
                } else {
                    if(getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = path + '?id=' + fbId + '&tab=gradual';
                    }else{
                        redirectUrl = path + '?id=' + fbId + '&tab=language';
                    }
                }
            }
            else if (activeTab == 'language') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.FB_Language_of_Instruction));
                if(isIben == true) {
                    if(getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=part';
                    }else{
                        redirectUrl = ibenPath + '?id=' + fbId + '&tab=structure';
                    }
                } else {
                    if(getIsMyp() == true || getIsMypPartner() == true) {
                        redirectUrl = path + '?id=' + fbId + '&tab=part';
                    }else {
                        redirectUrl = path + '?id=' + fbId + '&tab=structure';
                    }
                }
            }
            else if (activeTab == 'part') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Partner_School_Saved));
                if(isIben == true) {
                    redirectUrl = ibenPath + '?id=' + fbId + '&tab=partner';
                } else {
                    redirectUrl = path + '?id=' + fbId + '&tab=partner';
                }
            }
            /*  else if (activeTab == 'gradual') { 
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Partner_School_Saved));
if(isIben == true) {
redirectUrl = ibenPath + '?id=' + fbId + '&tab=subject';
} else {
redirectUrl = path + '?id=' + fbId + '&tab=subject';
}
}*/
            
            //End
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved));
                
                pimsApplicationFeedback.Status__c = 'Submitted';
                pimsApplicationFeedback.Date_Submitted__c = date.today().format();
                update pimsApplicationFeedback;
                
                if(isIben == true){
                    redirectUrl = '/educator/myassignments';
                } else if (isPims == true) {
                    redirectUrl = '/pims/PimsDashboard';
                } else {
                    redirectUrl = '/' + fbId;
                }
            }
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        System.debug('Active Tab**************** '+redirectUrl);
        return null;
    }
    
    // CR 14339 - Added method for save button 
    public PageReference saveOnly() {
        system.debug('#### saveOnly called');
        try {
            update pimsApplicationFeedback;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference edit() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            update pimsApplicationFeedback;
            
            activeTab = 'feedback';
            if (isUpdatePage) {
                pageRef = new PageReference('/apex/InternalApplicationFeedback');
            }
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            ApexPages.addMessages(ex);
            activeTab = 'feedback';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
    }
    
    public PageReference remove() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            IB_Application_Feedback__c afbToDelete = new IB_Application_Feedback__c();
            afbToDelete.Id = deleteAfbId;
            delete afbToDelete;
            
            activeTab = 'feedback';
            if (isUpdatePage) {
                pageRef = new PageReference('/apex/InternalApplicationFeedback');
            }
            pageRef.setRedirect(true);
        }
        catch (DmlException ex) {
            ApexPages.addMessages(ex);
            activeTab = 'feedback';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
    }
    
    public PageReference saveInternalEdit() {
        try {
            update pimsApplicationFeedback;
            
            PageReference feedbackPage = new ApexPages.StandardController(pimsApplicationFeedback).view();
            feedbackPage.setRedirect(true);
            return feedbackPage;
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference cancelInternalEdit() {
        PageReference feedbackPage = new ApexPages.StandardController(pimsApplicationFeedback).view();
        feedbackPage.setRedirect(true);
        return feedbackPage;
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    
    public PageReference updateStartDate() {
        
        try {
            update application;
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference removeBudget() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Application_Budget_Table__c budgetToRemove = new Application_Budget_Table__c();
            budgetToRemove.Id = budgetId;
            
            delete budgetToRemove;
            
            if (tab == 'budget') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line_Saved));
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=budget#budgetTable';
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line_Saved));
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=budget';
            }
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference saveBudget() {
        
        try {
            
            insert budget;
            
            applicationBudgetList = [
                SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c
                FROM Application_Budget_Table__c
                WHERE IB_Programme__c = :programme.Id
            ];
            
            budget = new Application_Budget_Table__c(IB_Programme__c = programme.Id);
            
            if (tab == 'budget') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line_Saved));
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=budget';
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line_Saved));
                redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + application.Id + '&tab=budget';
            }
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public Pagereference viewActionPlans(){
        Pagereference tmpRef = new PageReference('/educator/IbenActionPlan');
        tmpRef.getParameters().put('id', programme.Id);
        tmpRef.setRedirect(true);
        return tmpRef;
    }
    
    public Pagereference getCurrentSection(){
        return tabMappings.get(activeTab);
    }
    
    public Pagereference viewSchoolWebsite(){
        
        string startURL = String.valueOf(Account.Website);
        string endURL = '';
        
        if(url.startsWithIgnoreCase('http')){
            System.debug(LoggingLevel.ERROR,'url.startsWithIgnoreCase(\'http\') ==== ' + 'TRUE');
            endURL = startURL;
        }
        else if(url.startsWithIgnoreCase('www')){
            System.debug(LoggingLevel.ERROR,'url.startsWithIgnoreCase(\'www\') ==== ' + 'TRUE');
            endURL = 'http://' + startURL;
        }
        else{
            System.debug(LoggingLevel.ERROR,'ELSE ==== ' + 'TRUE');
            endURL = '';
        }
        
        Pagereference tmp = new Pagereference(endURL);
        tmp.setRedirect(true);
        
        System.debug(LoggingLevel.ERROR,'Account.Website ==== ' + Account.Website);
        System.debug(LoggingLevel.ERROR,'startURL ==== ' + startURL);
        System.debug(LoggingLevel.ERROR,'endURL ==== ' + endURL);
        System.debug(LoggingLevel.ERROR,'Pagereference ==== ' + tmp);
        
        return tmp;
    }
    
    public Pagereference viewCandidacyApp(){
        return null;
    }
    
    public Pagereference viewActionPlan(){
        return null;
    }
    
    /*public pagereference goToSchoolSite(){
pagereference tmp = new pagereference('https://www.google.com');
tmp.setRedirect(true);
return null;
}*/
    
    
}