/*******************************************************************************************
* @Name         PimsProfileContactController  
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Michael Khan      04/28/2023         To reduce the view state we have declared "roles" as transient and did necessary changes to populate the values
*  1.1           Saurabh Singh      06/31/2023         I have commented the line 557 and 558 because we need to capture the alternative email field value as it is.
*  2.0              Michael Khan    26-06-23      Story PRB0041369 added
*  3.0        Ranjith Kondabathini      05/30/2023         Update the logic to not confirm invited contact roles when updated from Programme Default Contacts section.
*******************************************************************************************/
public class PimsProfileContactController implements PimsProfilePanelInterface {
    
    public String redir { get; set; }
    
    public Account account { get; set; }
    public List<IB_Programme__c> programmes { get; set; }
    public List<Contact> contacts { get; set; }
    public List<Contact> confirmedContacts { get; set; } // added by kashyap as a part of ECM00503
    public Contact contact { get; set; }
    public List<Contact> del {get;set;} 
    public Contact addContact { get; set; }
    public Contact editContact { get; set; }
    public IB_Role__c addRole { get; set; }
    public Contact_Professional_Development__c addProDev { get; set; }
    
    public Id deleteContactId { get; set; }
    
    public Id newReminderId { get; set; }
    public Id invitedContactRecordTypeId { get; set; }
    public Id devRecordTypeId { get; set; }
    public List<Contact> invitedContacts { get; set; }
    public List<String> remiderDateList { get; set; }
    public List<String> createddateList  {get;set;} // added by kashyap as a part of ECM00503
    public List<IB_Role__c> invitedRoles { get; set; }
    public IB_Role_Repository__c checkRolName { get; set; }
    
    public String email { get; set; }
    public String emailBody { get; set; }
    public String url { get; set; }
    public String url2 { get; set; }
    public String invitationID { get; set; }
    
    public Contact contactForEmail { get; set; }
    public IB_Role__c roleForEmail { get; set; }
    public List<User> conOwnerList { get; set; }
    
    public transient List<IB_Role__c> roles { get; set; }
    // public List<IB_Role__c> roles;
    public transient List<IB_Role__c> activeRoles { get; set; }
    public List<IB_Role__c> applicantRoles { get; set; }
    
    public Id contactId { get; set; }    
    public String addStep { get; set; }    
    public String subjectGroup { get; set; }
    public String subject { get; set; }
    public String programmeSelectedType = 'CP';
    public String subjectGroupType = 'N/A';
    public String mypRecordTypeName;
    
    public String activeTab { get; set; }
    public Boolean isUpdatePage { get; set; }
    public String redirectUrl { get; set; }
    
    public Id roleId { get; set; }
    public IB_Role__c role { get; set; }
    public transient List<IB_Role_Repository__c> rolesFromRepository { get; set; }
    // public List<IB_Role_Repository__c> rolesFromRepository;
    
    public IB_Role__c headOfSchool { get; set; }
    public IB_Role__c pypHosContact { get; set; }
    public IB_Role__c pypPrimaryContact { get; set; }
    public IB_Role__c pypProgrammeCoordinator { get; set; }
    public IB_Role__c pypBillingContact { get; set; }
    public IB_Role__c pypExamContact { get; set; }
    
    public IB_Role__c mypHosContact { get; set; }
    public IB_Role__c mypPrimaryContact { get; set; }
    public IB_Role__c mypProgrammeCoordinator { get; set; }
    public IB_Role__c mypBillingContact { get; set; }
    public IB_Role__c mypExamContact { get; set; }
    
    public IB_Role__c dpHosContact { get; set; }
    public IB_Role__c dpPrimaryContact { get; set; }
    public IB_Role__c dpProgrammeCoordinator { get; set; }
    public IB_Role__c dpBillingContact { get; set; }
    public IB_Role__c dpExamContact { get; set; }
    
    public IB_Role__c ibccHosContact { get; set; }
    public IB_Role__c ibccPrimaryContact { get; set; }
    public IB_Role__c ibccProgrammeCoordinator { get; set; }
    public IB_Role__c ibccBillingContact { get; set; }
    public IB_Role__c ibccExamContact { get; set; }
    
    public String pageIntent { get; set; }
    public String progType { get; set; }
    public String citySelected { get; set; }
    public string PhoneNumber { get; set; }
    public String MobilePhone { get; set; }
    public Boolean mobError { get; set; }
    
    public Id mypAdminAssistantContact1 { get; set; }
    public Id mypAdminAssistantContact2 { get; set; }
    public Id mypAdminAssistantContact3 { get; set; }
    
    public Id pypAdminAssistantContact1 { get; set; }
    public Id pypAdminAssistantContact2 { get; set; }
    public Id pypAdminAssistantContact3 { get; set; }
    
    public Id dpAdminAssistantContact1 { get; set; }
    public Id dpAdminAssistantContact2 { get; set; }
    public Id dpAdminAssistantContact3 { get; set; }
    
    public Id ibccAdminAssistantContact1 { get; set; }
    public Id ibccAdminAssistantContact2 { get; set; }
    public Id ibccAdminAssistantContact3 { get; set; }
    
    public List<Contact> dupeContacts { get; set; }    
    
    private final string ROLE_HEAD = 'Head of School';
    private final string ROLE_COORDINATOR = 'Programme Coordinator';
    private final string ROLE_BILLING = 'Billing Contact';
    private final string ROLE_EXAM = 'Exam Contact';
    private final string ROLE_ADMIN = 'Admin Assistant';
    public String agreementTypeOfProgramme;// added by kashyap ECM00635
    
    public List<SelectOption> ContactQualifications { get; set; }
    public List<SelectOption> Salutation { get; set; }
    
    private ProfileService profileService = new ProfileService();
    
    /** Added for DAS **/
    
    
    public Map<String, String> mapObject { get; set; } 
    private final List<String> constantList = new List<String>{IboUtil.PIMS_ADMIN1,IboUtil.PIMS_ADMIN2,IboUtil.PIMS_ADMIN3, IboUtil.DAS_DUPLICATECONTACTINVITATIONERROR, IboUtil.Ib_Application_New_Programme_Application,
        IboUtil.Ib_Application_Select_Contact,IboUtil.PIMS_MYP,IboUtil.PIMS_DP,IboUtil.PIMS_PYP, IboUtil.PIMS_CP, IboUtil.PIMS_TOOL_TIP , 
        IboUtil.PIMS_SCHOOL_TUTORIAL , IboUtil.PIMS_IB_TUTORIAL , IboUtil.PIMS_CI_ROLE_LIMIT_ERROR,IboUtil.PIMS_CHIEF_INVIGILATOR };
        public boolean isRender{get;set;}
    
    public String pimsAdminAssistant1{
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_ADMIN1);
        }
        set;
    }
    public String pimsAdminAssistant2 {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_ADMIN2);
        }
        set;
    }
    public String pimsAdminAssistant3 {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_ADMIN3);
        }
        set;
    }
    
    public String pimsDuplicateContactError {
        get {
            return this.getTranslationsMap().get(IboUtil.DAS_DUPLICATECONTACTINVITATIONERROR);
        }
        set;
    }
    
    
    public String pimsMYP {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_MYP);
        }
        set;
    }
    
    public String pimsDP {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_DP);
        }
        set;
    }
    
    public String pimsPYP {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_PYP);
        }
        set;
    }
    
    public String pimsCP {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_CP);
        }
        set;
    }
    
    
    
    public String pimsLimitError {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_CI_ROLE_LIMIT_ERROR);
        }
        set;
    }
    public String pimsChiefInvigilator {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_CHIEF_INVIGILATOR);
        }
        set;
    }
    
    
    Public String pimToolTip{
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_TOOL_TIP);
        }
        set;
    }
    public String pimsSchoolTutorial {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_SCHOOL_TUTORIAL);
        }
        set;
    }
    
    Public String pimsIBTutorial {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_IB_TUTORIAL);
        }
        set;
    }
    
    
    
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
               system.debug('userLanguage in getTranslationsMap PimsprofilecontactController**'+userLanguage);
        
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                     WHERE CustomLabel__r.Label__c =: constantList
                                                     AND Language__c = :userLanguage];
                
                this.translationsMap = new Map<String, String>();
                
                for (Translation__c translation : translations) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                } 
            }
            catch (Exception ex) {
                system.debug('exceptionn in PimsprofilecontactController**'+ex.getMessage()+'lno**'+ex.getLinenUmber());
                Logger.get().add(ex, LogSeverity.ERROR).publish();             
            }
        }
        
        return this.translationsMap;
    }
    
    /** End of Added for DAS **/
    
    
    public IB_Programme__c pyp {
        get {
            return profileService.getProgrammeByType(programmes, 'PYP');
        }
    }
    
    public IB_Programme__c myp {
        get {
            return profileService.getProgrammeByType(programmes, 'MYP');
        }
    }
    
    public IB_Programme__c dp {
        get {
            return profileService.getProgrammeByType(programmes, 'Diploma_Programme');
        }
    }
    
    public IB_Programme__c ibcc {
        get {
            return profileService.getProgrammeByType(programmes, 'IBCC');
        }
    }    
    
    /** Added for Agreement phase -2***/
    public IB_Programme__c agreement {
        get {
            return profileService.getProgrammeByType(programmes, 'Agreement');
        }
    }    
    /** Added for Agreement ***/
    
    public PimsProfileContactController() {
        
        init();       
        
    }
    
    // Added by Saurabh for the translation story(PRB0041181).
    public String NewProgrammeApplication {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Application_New_Programme_Application);
        }
        set;
    }
    public String SelectContactTrans {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Application_Select_Contact);
        }
        set;
    }
    /** private final List<String> constantList = new List<String>{IboUtil.Ib_Application_New_Programme_Application,IboUtil.Ib_Application_Select_Contact};
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
}**/
    
    //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
    public List<SelectOption> getQualifications() {
        
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Schema.Contact.Qualifications__c.getDescribe();        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f : ple) {
            
            if (f.getLabel() != '----------') {
                options.add(new SelectOption(f.getValue() , f.getLabel()));
            }
            
        }
        
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        
        return options;
    }
    
    //Ahmad
    //below code is added by developer Abd Ur Rehman as part of DE6322 on 6-10-2020
    public List<SelectOption> getcitynames() {
        
        List<SelectOption> pickListValuesList= new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Country_Segmentation__c.Country_Codes__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for ( Schema.PicklistEntry pickListVal : ple) {
            pickListValuesList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        
        return pickListValuesList;
    }
    
    public void init() {
        
        try {
            mapObject    = new Map<String, String>();
            mapObject.put('toastSuccess',system.label.PIMS_Profile_Contact_Panel_Change_Default_Contacts_Roles_Updated);
            mapObject.put('buttonName',system.label.My_Institute_Role_Application_Update);
            mapObject.put('buttonName','test buttton kasyp');
            
            PageReference pageRef = ApexPages.currentPage();
            
            PimsCommunityService pimsService = new PimsCommunityService();
            account = pimsService.getCurrentAccount();
            ProgrammeService.setAccountId(account.Id);
            programmes = ProgrammeService.getProgrammesByAccount();
            RoleService.setAccountId(account.Id);
            roles = RoleService.getRolesByAccountId();
            applicantRoles = RoleService.getApplicantRolesForApprovalByAccountId();
            
            invitedRoles = new List<IB_Role__c>();
            activeRoles = new List<IB_Role__c>();
            
            for (IB_Role__c role : roles) {
                
                if (role.Status__c == 'Invited') {                    
                    invitedRoles.add(role);                    
                } else {                    
                    activeRoles.add(role);                    
                }
                
            }
            
            // Stripping out "Invited" roles
            roles = activeRoles;
            ContactService.setAccountId(account.Id);
            contacts = ContactService.getContactsForAccount(); 
            
            ContactEmailService.setAccountId(account.Id);
            
            invitedContacts = new List<Contact>();
            
           
            
            invitedContacts = ContactService.getInvitedContactsForAccount(); // added new method by kashyap to get invited contacts whose role associated is invited
            confirmedContacts = ContactService.getConfirmedContactsForAccount(); // added new method by kashyap to get confirmed contacts whose role associated is invited
            
            remiderDateList = new List<String>();
            createddateList = new List<String>();//added by kashyap as part of ECM00503
            
            for (Contact con : invitedContacts) {
                
                if(con.createddate != null){
                    createddateList.add(con.CreatedDate.Date().format());
                }
                if (con.EmailReminderDateTime__c != null) {
                    remiderDateList.add(con.EmailReminderDateTime__c.Date().format());
                    
                } else {
                    remiderDateList.add('');
                }
                
            }
            
            rolesFromRepository = RoleRepositoryService.getAllRoles();
            addContact = new Contact(AccountId = account.Id);
            addRole = new IB_Role__c();
            addProDev = new Contact_Professional_Development__c();
            addStep = '1';
            
            for (IB_Programme__c prog : programmes) {
                
                if (prog.RecordType.DeveloperName.Contains('MYP')) {
                    mypRecordTypeName = prog.RecordType.DeveloperName;
                }
                
            }
            
            if (getHasPypProgramme()) {                
                
                pypProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Programme Coordinator');
                pypBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Billing Contact');
                pypHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Head of School');
                
            }
            
            if (getHasDpProgramme()) {
                
                dpProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Programme Coordinator');
                dpBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Billing Contact');
                dpHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Head of School');
                dpExamContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Exam Contact');
                
            }
            
            if (getHasMypProgramme()) {
                
                mypProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, mypRecordTypeName, 'Programme Coordinator');
                mypBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, mypRecordTypeName, 'Billing Contact');
                mypHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, mypRecordTypeName, 'Head of School');
                mypExamContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, mypRecordTypeName, 'Exam Contact');
                
            }
            
            if (getHasCpProgramme()) {
                
                ibccProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Programme Coordinator');
                ibccBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Billing Contact');
                ibccHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Head of School');
                ibccExamContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Exam Contact');            
                
            }
            
            /** Added for Agreement   /** Added for Agreement 635 phase 2***/ 
            if (getHasAgreementProgramme()) {
                
                dpProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Agreement', 'Programme Coordinator');
                dpBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Agreement', 'Billing Contact');
                dpHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Agreement', 'Head of School');
                dpExamContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Agreement', 'Exam Contact');
                
            }
            /** Added for Agreement 635 phase 2***/ 
            
            initializeAdminAssistants(roles);
             System.debug('after initializeAdminAssistants' );
            // Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
            Salutation = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Schema.Contact.Salutation.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            Salutation.add(new SelectOption('' , '- '+Label.IBENPortal_Global_None+' -'));
            
            for ( Schema.PicklistEntry f : ple) {
                
                if (f.getLabel() != '-') {
                    Salutation.add(new SelectOption(f.getValue() , f.getLabel()));
                }
                
            }
            
            ContactQualifications = new List<SelectOption>();
            
        } Catch(Exception x) {
            System.debug('Exception: in PimsProfileContactController**' + x +'Line no'+x.getLineNumber());
        }        
        
    }
    
    @testvisible
    private void initializeAdminAssistants( List<IB_Role__c> roles ) {
        
        
        
        Map<String,List<IB_Role__c>> adminAssistantRoles = profileService.getContactRoleByProgrammeAndTypeforAdmin(account.Id, roles);
        system.debug('initializeAdminAssistants adminAssistantRoles***'+adminAssistantRoles);
        
        if (adminAssistantRoles.get('MYP') != null && getHasMypProgramme() == true) {
            
            List<IB_Role__c> mypAdminRoles = new List<IB_Role__c>(adminAssistantRoles.get('MYP'));
            
            if (mypAdminRoles.size() >= 1) {
                mypAdminAssistantContact1 = mypAdminRoles[0].IB_Contact__c;                    
            }
            
            if (mypAdminRoles.size() >= 2) {
                mypAdminAssistantContact2 = mypAdminRoles[1].IB_Contact__c;                    
            }
            
            if (mypAdminRoles.size() >= 3) {
                mypAdminAssistantContact3 = mypAdminRoles[2].IB_Contact__c;                    
            }
            
        }
        
        if (adminAssistantRoles.get('PYP') != null && getHasPypProgramme() == true) {
            
            List<IB_Role__c> pypAdminRoles = new List<IB_Role__c>(adminAssistantRoles.get('PYP'));
            
            if (pypAdminRoles.size() >= 1) {
                pypAdminAssistantContact1 = pypAdminRoles[0].IB_Contact__c;                    
            }
            
            if (pypAdminRoles.size() >= 2) {
                pypAdminAssistantContact2 = pypAdminRoles[1].IB_Contact__c;                    
            }
            
            if (pypAdminRoles.size() >= 3) {
                pypAdminAssistantContact3 = pypAdminRoles[2].IB_Contact__c;                    
            }
            
        }
        
        if (adminAssistantRoles.get('DP') != null && getHasDpProgramme() == true) {
            
            List<IB_Role__c> dpAdminRoles = new List<IB_Role__c>(adminAssistantRoles.get('DP'));
            
            if (dpAdminRoles.size() >= 1) {
                dpAdminAssistantContact1 = dpAdminRoles[0].IB_Contact__c;                    
            }
            
            if (dpAdminRoles.size() >= 2) {
                dpAdminAssistantContact2 = dpAdminRoles[1].IB_Contact__c;                    
            }
            
            if (dpAdminRoles.size() >= 3) {
                dpAdminAssistantContact3 = dpAdminRoles[2].IB_Contact__c;                    
            }
            
        }
        
        /** Agrrement phase 2***/
        if (adminAssistantRoles.get('Agreement') != null && getHasAgreementProgramme() == true) {
            
            List<IB_Role__c> dpAdminRoles = new List<IB_Role__c>(adminAssistantRoles.get('Agreement'));
            system.debug('Agreement admin assist***'+dpAdminRoles);
            
            if (dpAdminRoles.size() >= 1) {
                dpAdminAssistantContact1 = dpAdminRoles[0].IB_Contact__c;                    
            }
            
            if (dpAdminRoles.size() >= 2) {
                dpAdminAssistantContact2 = dpAdminRoles[1].IB_Contact__c;                    
            }
            
            if (dpAdminRoles.size() >= 3) {
                dpAdminAssistantContact3 = dpAdminRoles[2].IB_Contact__c;                    
            }
            
        }
        /** Agrrement phase 2***/
        
        if (adminAssistantRoles.get('IBCC') != null && getHasCpProgramme() == true) {
            
            List<IB_Role__c> ibccAdminRoles = new List<IB_Role__c>(adminAssistantRoles.get('IBCC'));
            
            if (ibccAdminRoles.size() >= 1) {
                ibccAdminAssistantContact1 = ibccAdminRoles[0].IB_Contact__c;                    
            }
            
            if (ibccAdminRoles.size() >= 2) {
                ibccAdminAssistantContact2 = ibccAdminRoles[1].IB_Contact__c;                    
            }
            
            if (ibccAdminRoles.size() >= 3) {
                ibccAdminAssistantContact3 = ibccAdminRoles[2].IB_Contact__c;                    
            }
            
        }
        
    }
    
    public Boolean getHasPypProgramme() {
        return profileService.hasProgramme(programmes, 'PYP');
    }
    
    public Boolean getHasMypProgramme() {
        return profileService.hasProgramme(programmes, 'MYP');
    }
    
    public Boolean getHasDpProgramme() {
        return profileService.hasProgramme(programmes, 'Diploma_Programme');
    }
    
    public Boolean getHasCpProgramme() {
        return profileService.hasProgramme(programmes, 'IBCC');
    }
    
    // adding this because other pages/components are still referencing it as "IBCC"
    public Boolean getHasIbccProgramme() {
        return profileService.hasProgramme(programmes, 'CP');
    }
    
    public Boolean getHasAgreementProgramme() {
        return profileService.hasProgramme(programmes, 'Agreement');
    }
    
    public Boolean hasProgramme() {
        if(getHasPypProgramme() || getHasMypProgramme() || getHasDpProgramme() || getHasCpProgramme() || getHasAgreementProgramme())
            return true;
        else
            return false;
    }
    
    public Boolean getFromAfa() {
        String redir = apexpages.currentpage().getparameters().get('redir');
        if(redir == 'afa') 
            return true;
        else
            return false;    
    }
    
    public PageReference save() {
        
        try {
            
            if (headOfSchool.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchool);
            else {
                try {
                    IB_Role__c curHeadOfSchool = [SELECT IB_Contact__c FROM IB_Role__c WHERE ID = :headOfSchool.Id LIMIT 1];
                    if (curHeadOfSchool.IB_Contact__c != headOfSchool.IB_Contact__c){
                        curHeadOfSchool.End_Date__c = Date.today();
                        update curHeadOfSchool;
                        headOfSchool.Id = null;
                        headOfSchool.Start_Date__c = Date.today();
                        insert headOfSchool;
                    }
                }
                catch (Exception ex) {
                    upsert headOfSchool;
                }
            }
            
            List<Contact> contactValidation = [
                SELECT ID, Name
                FROM Contact
                WHERE AccountId = :account.Id
            ];
            
            if (contactValidation.size() < 1) throw new CustomValidationException(Label.PIMS_Error_Add_Staff);
            
            update account;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Staff_Saved));
            
            if (!isUpdatePage) redirectUrl = '/pims/PimsProfileNew?tab=intent';
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference create() {
        
        PageReference pageRef = ApexPages.currentPage();
        String url = pageRef.getUrl();
        
        //check for duplicate
        
        List<Contact> dupeContacts1 = new List<Contact>();
        
        String firstInitial;
        
        system.debug('addContact*****&*&*&'+addContact);
        
        if(addContact.FirstName != null && addContact.FirstName != '') firstInitial = addContact.FirstName.mid(0,1) + '%';
        else firstInitial = '';
        
        if(addContact.Alternative_Email__c != null && addContact.Alternative_Email__c != ''){
            dupeContacts1 = [SELECT Id 
                             FROM Contact 
                             WHERE FirstName like :firstInitial 
                             AND LastName = :addContact.LastName
                             AND (Alternative_Email__c = :addContact.Alternative_Email__c 
                                  OR Alternative_Email__c = :addContact.Email
                                  OR Email = :addContact.Alternative_Email__c 
                                  OR Email = :addContact.Email)];
        }
        
        else{
            dupeContacts1 = [SELECT Id 
                             FROM Contact 
                             WHERE FirstName like :firstInitial 
                             AND LastName = :addContact.LastName
                             AND (Alternative_Email__c = :addContact.Email 
                                  OR Email = :addContact.Email)];
        }
        
        try {
            //This Part is being added by Abd Ur Rehman-Plumlogix on 22-06-2020,US11890
            //start
            
            Integer len = 10;//PhoneNumber.length();
            
            String phone = '123456789';//PhoneNumber;    
            
            boolean error = false;
            //end
            //Following line is commented by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
            //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Invited_Contact'];
            addContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Invited Contact').getRecordTypeId();//this line is added to get the recrdtype id
            addContact.Contact_Type__c = 'School Services';
            if(addContact.Alternative_Email__c != NULL)
                addContact.Professional_Email__c = addContact.Alternative_Email__c;
            
            addContact.Email_Reminder__c = Date.today();
            addContact.EmailReminderDateTime__c = Datetime.now();
            
            //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
            //Start
            if(ContactQualifications.size() > 0){
                String s='';
                for(SelectOption so : ContactQualifications){
                    s = s + so.getValue()+';';
                }
                addContact.Qualifications__c = s;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IBENPortal_Qualifications_Error));
                error = true;
                //Added by Kevin Fugate as part of INC0177789
                System.debug('Returning user to school staff page with Qualifications error.');
                return null;
            }
            //End
            
            // Following code is added by Umair-Plumlogix of SA Project of US12186 on 3/22/2021
            // Start
            if(addContact.Country_Code__c != Null && addContact.Phone_Number__c!= Null)
            {
                mobError = false;
                
                PhoneValidation phone_validation = new PhoneValidation();
                Boolean temp = phone_validation.edit_phone(addContact);
                Integer charLength = addContact.Phone_Number__c.length();
                if(charLength<4 || charLength>15 || temp==true || mobError == true)
                {
                    if(mobError == true)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Mobile_Format));
                        return null;
                    }
                    else
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Error));
                        return null;
                    }
                }
                
            }
            //End
            
            //This code is added as a part of ADASUS04 of Admin Assistant Project on 11/2/2021 by Umair Mukhtar
            //Start 
            if(addrole.IB_Role__c != null)
            { 
                ID roleID = addrole.IB_Role__c;
                checkRolName = [Select id, Role_Name__c from IB_Role_Repository__c where id =: roleID];
                ID progID = addrole.IB_Programme_New__c;                
                IB_Programme__c checkProgStatus = [Select id, Status__c from IB_Programme__c where id =: progID];
                if(checkRolName.Role_Name__c == ROLE_ADMIN)
                {
                    List<Contact> conADAS = new List<Contact>();
                    conADAS = [Select id, Name, Email from Contact where Email =: addContact.Email];
                    if(conADAS.size() > 0)
                    {
                        List<IB_Role__c> rolADAS = new List<IB_Role__c>();
                        rolADAS = [Select id, IB_Role_Name__c , Status__c from IB_Role__c where IB_Role_Name__c = 'Admin Assistant' AND IB_Contact__c IN :conADAS AND (Status__c = 'Confirmed' OR Status__c = 'Invited') AND IB_Programme_New__c =: checkProgStatus.id ];
                        if(rolADAS.size() > 0)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ADAS_duplicateContactInvitationError.replace('__CONTACT_NAME__', '')));
                            return null;
                        }
                    } 
                }
                /** Added newly for Chief Invigilator 29-05-24***/
                if(checkRolName.Role_Name__c == 'Chief Invigilator')
                {
                    List<Contact> conADAS = new List<Contact>();
                    conADAS = [Select id, Name, Email from Contact where Email =: addContact.Email];
                    if(conADAS.size() > 0)
                    {
                        List<IB_Role__c> rolADAS = new List<IB_Role__c>();
                        rolADAS = [Select id, IB_Role_Name__c , Status__c from IB_Role__c where IB_Role_Name__c = 'Chief Invigilator' AND IB_Contact__c IN :conADAS AND (Status__c = 'Confirmed' OR Status__c = 'Invited') AND IB_Programme_New__c =: checkProgStatus.id ];
                        system.debug('rolADAS****'+rolADAS.size());
                        system.debug('rolADAS conADAS****'+conADAS);
                        system.debug('rolADAS checkProgStatus.id****'+checkProgStatus.id);
                        system.debug('rolADAS ****'+rolADAS);
                        if(rolADAS.size() > 0)
                        {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,pimsDuplicateContactError));
                            return null;
                        }
                    } 
                }
                /** End of Added newly for Chief Invigilator***/
                
                
                if(checkProgStatus.Status__c != 'Authorized' && checkRolName.Role_Name__c == ROLE_ADMIN)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ADAS_ProgrammeStatusError));
                    return null;
                }
                
                
                //This code is added as a part of ADASUS02 of Admin Assistant Project on 11/2/2021 by Umair Mukhtar
                //Start 
                if(checkRolName.Role_Name__c == 'Admin Assistant')
                {
                    List<IB_Role__c> iBroleList = [Select Id, Status__c, IB_Role_Name__c, IB_Programme_New__c from IB_Role__c  where Status__c = 'Confirmed' AND IB_Role_Name__c =: ROLE_ADMIN AND IB_Programme_New__c=:progID];
                    if(iBroleList.size() >= Integer.valueOf(system.label.ADAS_AdminAssistantMaxLimitInteger) )
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ADAS_Admin_Assistant_Max_Limit));
                        return null;  
                    } 
                    //End
                }
                
                /** Added newly for Chief Invigilator 29-05-24***/
                if(checkRolName.Role_Name__c == 'Chief Invigilator')
                {
                    List<IB_Role__c> iBroleList = [Select Id, Status__c, IB_Role_Name__c, IB_Programme_New__c from IB_Role__c  where (Status__c = 'Confirmed' OR Status__c = 'Invited') AND IB_Role_Name__c = 'Chief Invigilator' AND IB_Programme_New__c=:progID];
                    if(iBroleList.size() >= Integer.valueOf(system.label.CI_Max_Limit_Integer) )
                    {
                        isRender=true;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,pimsLimitError));
                        return null;  
                    } 
                    //End
                }
                
                /** Added newly for Chief Invigilator 29-05-24***/
                
            }
            //}
            //End
            
            if(!error) {
                system.debug('addContact***'+addContact);
                upsert addContact;// insert replaced with upsert
            }
            
            if (addRole.IB_Programme_New__c != null ) {
          
                     system.debug('addContact***'+addContact.Id);
                 system.debug('account***'+account.Id);
                
                addRole.IB_Contact__c = addContact.Id;            
                addRole.IB_Account__c = account.Id;
                addRole.Start_Date__c = Date.today();
                addRole.Expiry_Date__c = null;
                //benjamin mcgarvey INC 0171645
                String progId = addRole.IB_Programme_New__c+'';
                List<IB_Programme__c> proglist = [Select RecordType.name,RecordType.Developername FROM IB_Programme__c WHERE id=:progId];
                if(addRole.IB_Programme_New__r.RecordTypeId==null&&proglist.size()>0){
                    if(proglist.get(0).RecordType.name=='European Platform'){
                        addRole.Programme_Selection__c='European Platform';
                    }
                    /** Added by kashyap ECM635**/
                    else if(proglist.get(0).RecordType.Developername=='Agreement'){
                        addRole.Programme_Selection__c='DP';
                    }
                    /** Added by kashyap ECM635**/
                    
                    else if(proglist.get(0).RecordType.Name == 'Diploma Programme') {
                        addRole.Programme_Selection__c='DP';
                    } else {
                        addRole.Programme_Selection__c = proglist.get(0).RecordType.Name;    
                    }
                }
                //end
                addRole.RecordTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Invited').getRecordTypeId(); 
                
                addRole.My_School_Invitee__c = true;
                system.debug('addRole*****'+addRole);
                insert addRole; 
                
                IB_Programme__c progToUpdate = new IB_Programme__c(Id=addRole.IB_Programme_New__c);
                if(checkRolName.Role_Name__c == IboUtil.ROLE_HOS) {
                    progToUpdate.Contact_Head_of_School__c = null;
                    progToUpdate.Head_of_School_Email__c = null;  
                } else if(checkRolName.Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR) {
                    progToUpdate.Contact_Programme_Coordinator__c = null;
                    progToUpdate.Programme_Coordinator_Email__c = null;
                } else if(checkRolName.Role_Name__c == IboUtil.ROLE_BILLING_CONTACT) {
                    progToUpdate.Contact_Billing_Contact__c = null;
                    progToUpdate.Billing_Contact_Email__c = null;
                }                    
                update progToUpdate;
                
                List<IB_Role__c> listExistingRoles = [select Id,Active__c,End_Date__c,Status__c,Reason_For_Status__c from IB_Role__c where IB_Account__c=:account.Id and IB_Role__c=:addRole.IB_Role__c and Id<>:addRole.Id and 
                                                      (IB_Programme_New__c=:addRole.IB_Programme_New__c or Programme_Selection__c=:addRole.Programme_Selection__c) 
                                                      and Status__c<>:IboUtil.ROLE_WITHDRAWN_STATUS and Status__c<>:IboUtil.ROLE_DECLINED_STATUS and IB_Role_Name__c<>:ROLE_ADMIN and IB_Role_Name__c<>:'Chief Invigilator']; 
                system.debug('listExistingRoles in PImsProfileContactController*****'+listExistingRoles);
                system.debug('listExistingRoles in PImsProfileContactController size*****'+listExistingRoles.size());
                if(!listExistingRoles.isEmpty()) {
                    for(IB_Role__c role: listExistingRoles) {
                        system.debug('role.Status__c*******'+role.Status__c);
                        role.Active__c = false;
                        role.End_Date__c = Date.today();//.adddays(10)
                        //role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                        if(role.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && role.Status__c!=IboUtil.ROLE_INVITED_STATUS){
                            system.debug('Role ROLE_WITHDRAWN_STATUS is happening here check *******');
                            role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                        }
                        else{
                            system.debug('Role declination is happening here check *******');
                            //if not set to declined this worflow rule will get fired 'Update Status to Withdrawn on End Date Immediate Execution'
                            
                            role.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                            
                            //if  set to declined this worflow rule will get fired 'Update Role Application Record Type to Declined'
                        }
                        if(role.Reason_For_Status__c == 'Confirmed'){
                            role.Reason_For_Status__c= '';
                        }  
                    }
                    update listExistingRoles;
                    
                    system.debug('listExistingRoles after update**'+listExistingRoles);
                }
                
                if (subject != null && subject != '') {
                    
                    Role_Application_Subject__c roleSubject = new Role_Application_Subject__c();
                    roleSubject.Role_And_Application__c = addRole.Id;
                    roleSubject.IB_Subject__c = subject;         
                    
                    insert roleSubject;  
                    
                }
                
                RoleService.setAccountId(account.Id);
                RoleService.isRolesCached = false;
                roles = RoleService.getRolesByAccountId();
                
                addRole = new IB_Role__c();
            }
            
            if (!error) {
                
                //comment one time error shown and one time added message with green bar
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Member_Added));
                
            }     
            
            if (programmes.size() > 0 && !url.contains('PimsDashboard') && !url.contains('PimsProfileNew')) {
                
                system.debug('error*** check here**'+error);
                
                if(!error)
                {
                    if(checkRolName != null && (checkRolName.Role_Name__c == ROLE_ADMIN || checkRolName.Role_Name__c == 'Chief Invigilator'))
                    {
                        system.debug('insdie of redirectUrl*** check here**');
                        redirectUrl = '/pims/PimsProfileContactEdit?id=' + addContact.Id+'&sendEmailADAS=true';
                    }
                    else
                    {
                        redirectUrl = '/pims/PimsProfileContactEdit?id=' + addContact.Id+'&sendEmail=true';
                        
                    }
                }
                else
                {
                    redirectUrl = '/pims/PimsProfile?tab=contact';
                }
                
            }
            // Added by Jagan US-0002284
            if(url.contains('PimsDashboard') && pageIntent!= null){
                contactForEmail=addContact;
                sendInvitationEmail(addContact.Email);
            }//end
            if(error == false)
                addStep = 'X';
            
            //Added By Michael as part of PRB0041369
            PageReference pageRefer = ApexPages.currentPage();
            String pageName = ApexPages.currentPage().getURL();
            
            
            if(pageName.contains('PimsDashboard')|| pageName.contains('PimsProfileNew')/*|| pageName.contains('PimsProfile')*/){
                pageRefer = pageRedirect(pageName);
                return pageRefer;
            }
            
        }
        catch (DmlException ex){
            
            system.debug('EXception at:'+ex.getLineNUmber()+'**'+ex.getMessage());
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public boolean edit_phone(){
        string citySelected = addContact.Country_Code__c;
        string phone_number = addContact.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        
        Integer len = phone_number.length();  
        boolean moblength = String.isBlank(addContact.MobilePhone);
        
        if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
            city = true;
        } 
        if( !city && phone_number!=Null  && len<=15 && len>8  && phone_number.isNumeric() ){
            String []str=citySelected.split('\\(');
            String []strFinal=str[1].split('\\)');
            String FinalPh='';
            String countCode=strFinal[0];
            FinalPh=FinalPh+'+';
            for(Integer x=1;x<countCode.length();x++){
                if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
                    FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
                }
            }
            
            String PhoneNumber2 ='';
            String strPh = phone_number;
            Boolean check=false;
            for(Integer x=0;x<strPh.length();x++){
                if(strPh.charAt(x)!=48){
                    check = true;
                }
                if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) && check == true ){
                    PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
                }
            }
            Boolean checkM=false;
            String mobPhone='';
            String FinalMob='';
            string mobilelength = addContact.MobilePhone;
            String strMob= mobilelength;
            if(!moblength)
            {
                Integer len1 = addContact.MobilePhone.length();
                if(len1>0 && len1<=15 && len1>8  && addContact.MobilePhone.isNumeric()  )
                {
                    for(Integer x=0;x<strMob.length();x++)
                    {
                        if(strMob.charAt(x)!=48)
                        {
                            checkM=true;
                        }
                        if((strMob.charAt(x)>=48 && strMob.charAt(x)<=57) && checkM==true )
                        {
                            
                            mobPhone=mobPhone+String.valueOf((strMob.charAt(x)-48));
                        }
                        
                    }                 
                    
                    
                    FinalMob=FinalPh+mobPhone;
                    addContact.MobilePhone=FinalMob;
                }
                else
                {
                    
                    mobError = true;
                    
                    
                }
            }
            
            FinalPh=FinalPh+PhoneNumber2;
            addContact.Phone = FinalPh;
            system.debug('FinalPh : ' + FinalPh);
            
        }
        else{
            return true;
        }
        return false;
    }
    
    public PageReference createIntent() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Standard_Contact'];
            contact.RecordTypeId = RecType.Id;
            
            insert contact;
            
            if (pageIntent == null) pageIntent = 'pyp';
            
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsDashboard');
                pageRef.getParameters().put('prog', pageIntent);
            }
            else {
                pageRef = new PageReference('/pims/PimsProfileNew');
                pageRef.getParameters().put('tab', 'intent');
                pageRef.getParameters().put('prog', pageIntent);
            }
            
            
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            pageRef.setRedirect(false);
            pageRef.getParameters().put('prog', pageIntent);
            
        }
        
        //pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
        
    }
    
    public PageReference cancelIntent() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        if (pageIntent == null) pageIntent = 'pyp';
        
        if (isUpdatePage) {
            pageRef = new PageReference('/pims/PimsDashboard');
            pageRef.getParameters().put('prog', pageIntent);
        }
        else {
            pageRef = new PageReference('/pims/PimsProfileNew');
            pageRef.getParameters().put('tab', 'intent');
            pageRef.getParameters().put('prog', pageIntent);
        }
        
        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    public PageReference edit() {
        
        try {
            
            update editContact;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Member_Updated));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public PageReference remove() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact contactToDelete = new Contact();
            contactToDelete.Id = deleteContactId;
            RoleService.setAccountId(deleteContactId);
            roles = RoleService.getRolesByAccountId();
            
            //check of contact is associated to a user
            User isUser;
            
            try{
                isUser = [SELECT ID FROM User WHERE ContactId = :deleteContactId LIMIT 1];
            } catch(Exception e) {
                //this means there is no associated contact which is valid
                isUser = null;
            }
            
            //get account region for contact
            Contact currentRegion = [SELECT Account.Region__c FROM Contact WHERE ID = :deleteContactId LIMIT 1];
            String findAccount = '';
            
            if(isUser != null){
                findAccount = currentRegion.Account.Region__c + ' IBEN Independent';
            } else {
                findAccount = currentRegion.Account.Region__c + ' Inactive Contacts';
            }
            
            //find account for inactive accounts in the given region
            Account newAccount = [SELECT ID FROM Account WHERE Name = :findAccount LIMIT 1];
            //update account associated with contact
            contactToDelete.AccountId = newAccount.ID;
            
            update contactToDelete;
            
            activeTab = 'contact';
            if (isUpdatePage) pageRef = new PageReference('/pims/PimsProfile');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'contact';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
        
    }
    
    public PageReference Removecon() {
        //Whoever made this I replaced the call to this with removeallroles - Benjamin McGarvey
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact contactToDelete = new Contact();
            contactToDelete.Id = deleteContactId;
            RoleService.setAccountId(deleteContactId);
            roles = RoleService.getRolesByAccountId();
            
            //added by benjamin mcgarvey to fix bug with delete button on myschool
            //check of contact is associated to a user
            User isUser;
            
            try{
                isUser = [SELECT ID FROM User WHERE ContactId = :deleteContactId LIMIT 1];
            } catch(Exception e) {
                //this means there is no associated contact which is valid
                isUser = null;
            }
            
            //get account region for contact
            Contact currentRegion = [SELECT Account.Region__c FROM Contact WHERE ID = :deleteContactId LIMIT 1];
            String findAccount = '';
            
            if(isUser != null){
                findAccount = currentRegion.Account.Region__c + ' IBEN Independent';
            } else {
                findAccount = currentRegion.Account.Region__c + ' Inactive Contacts';
            }
            
            //find account for inactive accounts in the given region
            Account newAccount = [SELECT ID FROM Account WHERE Name = :findAccount LIMIT 1];
            //update account associated with contact
            contactToDelete.AccountId = newAccount.ID;
            
            update contactToDelete;
            //Added by benjamin mcgarvey end
            system.debug('RemoveconcontactToDelete' +deleteContactId);
            
            List<IB_Role__c> RolesWithContact = [Select id, Status__c from IB_Role__c where IB_Contact__c =:deleteContactId and Status__c = 'Invited'];
            If(RolesWithContact != Null){
                delete RolesWithContact;
                delete[select id from Contact Where ID = :deleteContactId  and RecordType.Name = 'Invited Contact'];
            }
            delete[select id from Contact Where ID = :deleteContactId  and RecordType.Name = 'Invited Contact'];
            
            activeTab = 'contact';
            if (isUpdatePage) pageRef = new PageReference('/pims/PimsProfile');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'contact';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
        
    }
    
    
    public PageReference removeAllRoles() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact contactToDelete = new Contact();
            contactToDelete.Id = deleteContactId;
            system.debug('conToDelete id : ' + contactToDelete.Id);
            //delete contactToDelete;
            //
            // Added IB_Role_Name__c,Email__c,IB_Contact__r.Name, IB_Account__r.Name for DAS 
            List<IB_Role__c> rolesForContact = [SELECT IB_Contact__c,IB_Contact__r.User_Language__c,Programme_Selection__c,Status__c, Disable_CI_Role__c, IB_Account__c, IB_Role_Name__c,Email__c,IB_Contact__r.Name, IB_Account__r.Name
                                                FROM IB_Role__c WHERE IB_Contact__c = :deleteContactId AND IB_Account__c = :account.Id 
                                                AND (End_Date__c = null OR End_Date__c > TODAY) AND IB_Role__r.Category__c not in ('No Longer In Use')];
            
            
            for(IB_Role__c r:rolesForContact){
                
                r.Status__c = 'Withdrawn';
                
                
            }
            
            update rolesForContact;
            
            /*** Send email when confirmed user is deleted for CI Role DAS***/
            
            List<Messaging.SingleEmailMessage> listEmails = new List<Messaging.SingleEmailMessage>();
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
            
            
            String userLanguage;
            String developerName;
            if(getUserLanguageKey() == 'fr'){
                developerName = 'PIMS_CI_withdrawn_fr';
                
            }else if(getUserLanguageKey()  == 'es'){
                developerName = 'PIMS_CI_withdrawn_es';
                
            }else{
                developerName = 'PIMS_CI_withdrawn';//PIMS_RemovalFromConfirmed_Role
            }
            
            EmailTemplate template;  
            try {
                template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
            } catch (Exception e) {
                
            }
            List<IB_Role__c>  singleContactRoleCI = new List<IB_Role__c>();
            for(IB_Role__c r:rolesForContact)
                
            {
                if(r.IB_Role_Name__c =='Chief Invigilator' && r.Disable_CI_Role__c == false){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if (owea.size()>0) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    String plainSubject= template.Subject;
                    plainSubject= plainSubject.replace('[roleName]',r.IB_Role_Name__c );
                    plainSubject= plainSubject.replace('[schoolName]',r.IB_Account__r.Name );
                    String[] toAddresses = new String[] {r.Email__c};
                        mail.setToAddresses(toAddresses);
                    mail.setSubject(plainSubject);
                    String plainBody = template.Body;
                    plainBody = plainBody.replace('[CI]', r.IB_Contact__r.Name);
                    plainBody = plainBody.replace('[roleName]',r.IB_Role_Name__c);
                    plainBody= plainBody.replace('[schoolName]',r.IB_Account__r.Name );
                    mail.setPlainTextBody(plainBody);
                    listEmails.add(mail);
                }
                
                
                if(r.IB_Role_Name__c =='Chief Invigilator' && r.Disable_CI_Role__c == true){
                    singleContactRoleCI.add(r);
                    
                }
            }
            
            if(!listEmails.isEmpty()){
                Messaging.sendEmail(listEmails); 
            }
            
            if(!singleContactRoleCI.isEmpty()){
            IB_NewCIRoleAdded.withdrawTheUserWhoRequestedCIRole(singleContactRoleCI);
            }
            
            
            /*** Send email when confirmed user is deleted for CI Role DAS ***/
            
            
            User isUser;
            
            try{
                isUser = [SELECT ID FROM User WHERE ContactId = :deleteContactId LIMIT 1];
            } catch(Exception e) {
                //this means there is no associated contact which is valid
                isUser = null;
            }
            
            //get account region for contact
            Contact currentRegion = [SELECT Account.Region__c FROM Contact WHERE ID = :deleteContactId LIMIT 1];
            String findAccount = '';
            
            if(isUser != null){
                findAccount = currentRegion.Account.Region__c + ' IBEN Independent';
            } else {
                findAccount = currentRegion.Account.Region__c + ' Inactive Contacts';
            }
            
            
            
            //find account for inactive accounts in the given region
            
            List<Account> newAccountList = [SELECT ID FROM Account WHERE Name = :findAccount LIMIT 1];
            if (newAccountList.size() > 0)
            {
                //update account associated with contact
                contactToDelete.AccountId = newAccountList[0].ID;
                update contactToDelete;
            }
            
            
            activeTab = 'contact';
            if (isUpdatePage) pageRef = new PageReference('/pims/PimsProfile');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'contact';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
        
    }
    
    public PageReference createRole() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact thisContact = new Contact();
            if (addContact.Id != null) thisContact.Id = addContact.Id;
            else thisContact.Id = editContact.Id;
            
            addRole.IB_Contact__c = thisContact.Id;            
            addRole.IB_Account__c = account.Id;
            addRole.Start_Date__c = Date.today();
            
            if (!test.isRunningTest()) {
                
                addRole.RecordType.Name = 'Invited';
                
            }                
            
            insert addRole;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_Added));
            
            if(subject != null && subject != '') {
                
                Role_Application_Subject__c roleSubject = new Role_Application_Subject__c();
                roleSubject.Role_And_Application__c = addRole.Id;
                roleSubject.IB_Subject__c = subject;         
                
                insert roleSubject;  
                
                addStep = '3';
                
            }
            
            RoleService.setAccountId(account.Id);
            RoleService.isRolesCached = false;
            roles = RoleService.getRolesByAccountId(); 
            
            addRole = new IB_Role__c();
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference createProDev() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact thisContact = new Contact();
            if (addContact.Id != null) thisContact.Id = addContact.Id;
            else thisContact.Id = 'editContact.Id';
            
            addProDev.Contact__c = thisContact.Id;
            
            insert addProDev;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PD_Added));
            
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference removeRole() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
           	
            IB_Role__c roleToDelete = new IB_Role__c();
            roleToDelete.Id = roleId;
            roleToDelete.End_Date__c = Date.today();
            if(!test.isRunningTest())
                update roleToDelete;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            
            
            RoleService.setAccountId(account.Id);
            RoleService.isRolesCached = false;
            roles = RoleService.getRolesByAccountId();
            
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return pageRef;
        
    }    
    
    public PageReference changeRole(){
        string progAbbrev = progType;
        if(progType.equalsIgnoreCase('Diploma Programme')) progAbbrev = 'DP';
        return new PageReference('/pims/PimsProfile?tab=contact#dpc_' + progAbbrev);
    }    
    
    public PageReference confirmRole() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            IB_Role__c roleToConfirm = new IB_Role__c();
            roleToConfirm.Id = roleId;
            roleToConfirm.Status__c = 'Confirmed';
            
            update roleToConfirm;
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            RoleService.setAccountId(account.Id);
            RoleService.isRolesCached = false;
            roles = RoleService.getRolesByAccountId();
            
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return pageRef;
        
    }
    
    public PageReference declineRole() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            IB_Role__c roleToDecline = new IB_Role__c();
            roleToDecline.Id = roleId;
            roleToDecline.Status__c = 'Declined';
            roleToDecline.End_Date__c = Date.today();
            
            update roleToDecline;
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            RoleService.setAccountId(account.Id);
            RoleService.isRolesCached = false;
            roles = RoleService.getRolesByAccountId();
            
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return pageRef;
        
    }    
    
    public List<IB_Role__c> getRolesByContact() {
        
        List<IB_Role__c> newRoleList = new List<IB_Role__c>();
        RoleService.setAccountId(account.Id);
        List<IB_Role__c>  contactRoles = RoleService.getRolesByAccountId();
        for (IB_Role__c role : contactRoles) {
            if (role.IB_Contact__c == contact.Id && role.Status__c != 'Invited') newRoleList.add(role);
        }
        
        return newRoleList;
        
    }
    
    // This method is used to fill billing contact picklist in my school communites with all the billing contacts that belong to same school or group of school of that school,US10828
    // @author Fahad Farrukh
    // @since 8/10/2019
    // @return List<SelectOption>.Returns list of all billing contacts
    
    public List<SelectOption> getBillingContactOptions() {
        
        List<SelectOption> optionSet;
        try
        {
            // List<AccountContactRelation> acr =[SELECT ContactId FROM AccountContactRelation where AccountId=:account.id ];
            Set<Id> records = new Set<Id>();
            // add all the contact ID's from AccountContactRelation object into a set
            for(AccountContactRelation a :[SELECT ContactId FROM AccountContactRelation where AccountId=:account.id ])
            {
                records.add(a.ContactId);
            }
            // Query the contact names from the set of id's
            List<Contact> contactNameListAcr=[select AccountId,name from contact where id IN:records];
            
            
            optionSet = new List<SelectOption>();
            
            optionSet.add(new SelectOption('',SelectContactTrans));
            for (Contact contact : contactNameListAcr){
                
                // add all the contact names from ACR set to universal set
                optionSet.add(new SelectOption(contact.Id, contact.Name));
            }
            
            // return options;
            
            // List<Contact> sameSchool=[select AccountId,name from contact where AccountId=:account.id];
            
            // Query to get the account in group of school field of the accounts object
            List<Account> billing=[select name,Group_of_School__c from account where id=:account.id AND Group_of_School__c!=Null  limit 1];
            // Query to get all the contacts that belong to the group of school Account
            List<Contact> contactNameList=new List<Contact>();
            if(billing.size()>0)
                contactNameList=[select AccountId,name from contact where AccountId=:billing[0].Group_of_School__c];
            
            // List<SelectOption> options = new List<SelectOption>();
            // options.add(new SelectOption('', ''));
            // options.add(new SelectOption('','Select a Contact',true));
            
            for (Contact contact : contactNameList){
                // options.add(new SelectOption(contact.Id, contact.Name));
                // add all the contact names from group of school Account to universal set
                optionSet.add(new SelectOption(contact.Id, contact.Name));
            }
            
        }
        catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        
        return optionSet;
        
    }
    
    public List<SelectOption> getContactOptions() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('',SelectContactTrans));
        
        for (Contact contact : contacts){
            options.add(new SelectOption(contact.Id, contact.Name));
        }
        
        return options;
        
    }
    
    public List<SelectOption> getAdminAssistantContactOptions() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','-None-'));
        
        for (Contact contact : contacts) {
            
            options.add(new SelectOption(contact.Id, contact.Name));
            
        }        
        
        return options;
        
    }
    
    public List<SelectOption> getProgrammeOptions() {
        
        try
        {
            
            List<SelectOption> options = new List<SelectOption>();
            Boolean added = false;
            
            List<IB_Data_Translate__c> dt = [
                SELECT Id, Name, Locale__c, Object_Name__c, Record_Id__c, Translate_Value_1__c
                FROM IB_Data_Translate__c
                WHERE Object_Name__c = 'IB_Programme__c'
                AND Locale__c = :getUserLanguageKey()
            ];
            
            for (IB_Programme__c programme : programmes){
                added = false;
                for (IB_Data_Translate__c trans : dt) {
                    if (programme.RecordType.Name == trans.Record_Id__c) {
                        options.add(new SelectOption(programme.Id, trans.Translate_Value_1__c));
                        added = true;
                        break;
                    }
                }
                if (!added)   //options.add(new SelectOption(programme.Id, programme.RecordType.Name)); 
                    /** Added below snippet by kashyap by commenting above line ECM00635**/ 
                {
                    if(programme.RecordType.DeveloperName!='Agreement'){
                        options.add(new SelectOption(programme.Id, programme.RecordType.Name));
                    }else
                    {
                        options.add(new SelectOption(programme.Id, programme.RecordType.DeveloperName+ '-'+programme.Agreement_Type__c));
                    }
                }
            }
            
            return options;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public List<SelectOption> getProgrammeOptionsNewContact() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',NewProgrammeApplication));
        Boolean added = false;
        
        List<IB_Data_Translate__c> dt = [
            SELECT Id, Name, Locale__c, Object_Name__c, Record_Id__c, Translate_Value_1__c
            FROM IB_Data_Translate__c
            WHERE Object_Name__c = 'IB_Programme__c'
            AND Locale__c = :getUserLanguageKey()
        ];
        for (IB_Programme__c programme : programmes){
            added = false;
            for (IB_Data_Translate__c trans : dt) {
                if (programme.RecordType.Name == trans.Record_Id__c) {
                    options.add(new SelectOption(programme.Id, trans.Translate_Value_1__c));
                    added = true;
                    break;
                }
            }
            if (!added) //options.add(new SelectOption(programme.Id, programme.RecordType.Name)); 
                /** Added below snippet by kashyap by commenting above line ECM00635**/ 
            {
                if(programme.RecordType.DeveloperName!='Agreement'){
                    options.add(new SelectOption(programme.Id, programme.RecordType.Name));
                }else
                {
                    options.add(new SelectOption(programme.Id, programme.RecordType.DeveloperName+ '-'+programme.Agreement_Type__c));
                }
            }
        }
        
        
        
        return options;
    }
    
    public List<SelectOption> getRoleOptions() {
        
        List<SelectOption> options = new List<SelectOption>();
        
        Map<String,SelectOption> selectMap = new Map<String,SelectOption>();
        List<String> sortedOptions = new List<String>();
        
        for (IB_Role_Repository__c role : rolesFromRepository){
            if (role.Display_In_PIMS_Community__c == true && role.Application_Available_in_MyIB__c == false && role.Role_Name__c != 'Exam Contact' && role.Role_Name__c != 'Programme Coordinator' && role.Role_Name__c != 'Head of School' && role.Role_Name__c != 'Billing Contact' || (role.Role_Name__c == ROLE_ADMIN || role.Role_Name__c == 'Chief Invigilator')) {
                sortedOptions.add(role.Role_Name__c);
                if (getUserLanguageKey() == 'es') selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name_es__c));
                else if (getUserLanguageKey() == 'fr') selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name_fr__c));
                else selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name__c));
            }
        }
        
        sortedOptions.sort();
        
        for (String s : sortedOptions){
            options.add(selectMap.get(s));
        }
        
        return options;
    }
    
    public List<SelectOption> getRoleOptionsNewContact() {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption( '','N/A' ) );
        Map<String,SelectOption> selectMap = new Map<String,SelectOption>();
        List<String> sortedOptions = new List<String>();
        for (IB_Role_Repository__c role : RoleRepositoryService.getAllRoles()){
            // Added new role || role.Role_Name__c == 'Chief Invigilator' here for DAS Story
            if (role.Display_In_PIMS_Community__c == true && role.Application_Available_in_MyIB__c == false && role.Role_Name__c == 'Exam Contact' || role.Role_Name__c == 'Programme Coordinator' || role.Role_Name__c == 'Head of School' || role.Role_Name__c == 'Billing Contact' || role.Role_Name__c == ROLE_ADMIN || role.Role_Name__c == 'Chief Invigilator') {
                sortedOptions.add(role.Role_Name__c);
                if (getUserLanguageKey() == 'es') selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name_es__c));
                else if (getUserLanguageKey() == 'fr') selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name_fr__c));
                else selectMap.put(role.Role_Name__c,new SelectOption(role.Id, role.Role_Name__c));
            }
        }
        sortedOptions.sort();
        for (String s : sortedOptions){
            options.add(selectMap.get(s));
        }
        return options;
    }
    
    public List<String> getHasMissingRoles() {
        
        List<String> hasMissingRoles = new List<String>();
        List<IB_Role_Repository__c> allRoles = profileService.getAllRolesFromRepository();
        RoleService.setAccountId(account.Id);
        RoleService.isRolesCached = false;
        roles = RoleService.getRolesByAccountId(); 
        
        Boolean hasPypBilling = false;
        Boolean hasPypPOC     = false;
        Boolean hasPypHOS     = false;
        Boolean hasMypBilling = false;
        Boolean hasMypPOC     = false;
        Boolean hasMypHOS     = false;
        Boolean hasDpBilling  = false;
        Boolean hasDpPOC      = false;
        Boolean hasDpHOS      = false;
        Boolean hasCpBilling  = false;
        Boolean hasCpPOC      = false;
        Boolean hasCpHOS      = false;
        
        for (IB_Programme__c programme : programmes) {
            if (programme.Status__c == 'Candidate' || programme.Status__c == 'Authorized') {
                if (programme.RecordType.Name == 'PYP') {
                    for (IB_Role__c role : roles) {
                        if (role.IB_Programme_New__r.RecordType.Name == 'PYP') {
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Billing Contact').Id) hasPypBilling = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Programme Coordinator').Id) hasPypPOC = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Head of School').Id) hasPypHOS = true;
                        }
                    }
                    if (!hasPypBilling) hasMissingRoles.add(Label.PIMS_Validate_PYP_BillingContact);
                    if (!hasPypPOC) hasMissingRoles.add(Label.PIMS_Validate_PYP_POC);
                    if (!hasPypHOS) hasMissingRoles.add(Label.PIMS_Validate_PYP_HOS);
                }
                if (programme.RecordType.Name == 'MYP') {
                    for (IB_Role__c role : roles) {
                        if (role.IB_Programme_New__r.RecordType.Name == 'MYP') {
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Billing Contact').Id) hasMypBilling = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Programme Coordinator').Id) hasMypPOC = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Head of School').Id) hasMypHOS = true;
                        }
                    }
                    if (!hasMypBilling) hasMissingRoles.add(Label.PIMS_Validate_MYP_BillingContact);
                    if (!hasMypPOC) hasMissingRoles.add(Label.PIMS_Validate_MYP_POC);
                    if (!hasMypHOS) hasMissingRoles.add(Label.PIMS_Validate_MYP_HOS);
                }
                if (programme.RecordType.Name == 'Diploma Programme') {
                    for (IB_Role__c role : roles) {
                        if (role.IB_Programme_New__r.RecordType.Name == 'Diploma Programme') {
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Billing Contact').Id) hasDpBilling = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Programme Coordinator').Id) hasDpPOC = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Head of School').Id) hasDpHOS = true;
                        }
                    }
                    if (!hasDpBilling) { hasMissingRoles.add(Label.PIMS_Validate_DP_BillingContact); }
                    if (!hasDpPOC) { hasMissingRoles.add(Label.PIMS_Validate_DP_POC); }
                    if (!hasDpHOS) { hasMissingRoles.add(Label.PIMS_Validate_DP_HOS); }
                }
                if (programme.RecordType.Name == 'CP') {
                    for (IB_Role__c role : roles) {
                        if (role.IB_Programme_New__r.RecordType.Name == 'CP') {
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Billing Contact').Id) hasCpBilling = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Programme Coordinator').Id) hasCpPOC = true;
                            if (role.IB_Role__c == profileService.getRoleByName(allRoles, 'Head of School').Id) hasCpHOS = true;
                        }
                    }
                    if (!hasCpBilling) { hasMissingRoles.add(Label.PIMS_Validate_CP_BillingContact); }
                    if (!hasCpPOC) { hasMissingRoles.add(Label.PIMS_Validate_CP_POC); }
                    if (!hasCpHOS) { hasMissingRoles.add(Label.PIMS_Validate_CP_HOS); }
                }
            }
        }
        
        return hasMissingRoles;
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public String getUserContactId() {
        return UserService.getUser().ContactId;
    }
    
    public List<SelectOption> getSubjectGroups() {
        
        if (addRole.IB_Programme_New__c != null) {
            
            IB_Programme__c prog = [
                SELECT Id, Name, RecordType.Name
                FROM IB_Programme__c
                WHERE Id = :addRole.IB_Programme_New__c
            ];
            programmeSelectedType = prog.RecordType.Name;
            
        }
        
        List<SelectOption> options = new List<SelectOption>();
        Boolean added = false;
        
        List<IB_Subject__c> subjects = new List<IB_Subject__c>();
        if (programmeSelectedType == 'CP') {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE (IB_Programme__c = :programmeSelectedType OR IB_Programme__c = 'DP')
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Group__c ASC
            ];
        }
        else {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE IB_Programme__c = :programmeSelectedType
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Group__c ASC
            ];
        }
        
        Set<String> subjectNames = new Set<String>();
        
        for(IB_Subject__c subject : subjects){
            if(!subjectNames.contains(subject.Subject_Group_Value__c)){
                subjectNames.add(subject.Subject_Group_Value__c);
                options.add(new SelectOption(subject.Subject_Group_Value__c,subject.Subject_Group__c));
            }
        }
        
        return options;
        
    }
    
    public List<SelectOption> getSubjects() {
        
        if (addRole.IB_Programme_New__c != null) {
            
            IB_Programme__c prog = [
                SELECT Id, Name, RecordType.Name
                FROM IB_Programme__c
                WHERE Id = :addRole.IB_Programme_New__c
            ];
            programmeSelectedType = prog.RecordType.Name;
            
        }
        List<SelectOption> options = new List<SelectOption>();
        Boolean added = false;
        
        List<IB_Subject__c> subjects = new List<IB_Subject__c>();
        if (programmeSelectedType == 'CP') {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE (IB_Programme__c = :programmeSelectedType OR IB_Programme__c = 'DP')
                AND Subject_Group_Value__c = :subjectGroup
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Name__c ASC
            ];
        }
        else {
            subjects = [
                SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                FROM IB_Subject__c
                WHERE (IB_Programme__c = :programmeSelectedType)
                AND Subject_Group_Value__c = :subjectGroup
                AND Available_in_MySchool__c = true
                ORDER BY Subject_Name__c ASC
            ];
        }
        
        for (IB_Subject__c subject : subjects) {
            if(getUserLanguageKey() == 'fr'){
                options.add(new SelectOption(subject.Id, subject.Subject_Name_FR__c));     
            } else if(getUserLanguageKey() == 'es'){
                options.add(new SelectOption(subject.Id, subject.Subject_Name_SP__c));  
            } else {
                options.add(new SelectOption(subject.Id, subject.Subject_Name__c));
            }
        }
        
        return options;
        
    }
    
    public List<SelectOption> getPDYears() {
        
        return PDCatalogService.getYearOptions();
        
    }
    
    public PageReference savePYP() {
        return saveDefaultRoles('PYP');
    }
    
    public PageReference saveMYP() {        
        return saveDefaultRoles('MYP');
    }
    
    public PageReference saveDP() {
        return saveDefaultRoles('Diploma_Programme');
    }
    
    public PageReference saveCP() {
        return saveDefaultRoles('IBCC');
    }
    
    /** Added for Agreement 635 phase 2***/
    public PageReference saveAgreement() {
        return saveDefaultRoles('Agreement');
    }
    /** Added for Agreement 635 phase 2***/
    
    public PageReference saveDefaultRoles(String programmeName) {
        
        string logTag = '++++ [saveProgramme]';         
        
        try {
            
            IB_Programme__c prog = profileService.getProgrammeByType(programmes, programmeName);
            
            ProfileService.account = account; // Get all the programms for this account.
            
            if (!test.isRunningTest()) {    
                RoleService.setAccountId(account.Id);
            }
            
            RoleService.setProgrammeId(prog.Id); // one programme at a time   
            
            List<IB_Role__c> rolesList = new List<IB_Role__c>();                                    
            Map<String,IB_Role__c> roleMap = new Map<String,IB_Role__c>(); 
            
            for (IB_Role__c role: RoleService.getRolesByProgrammeId()) {
                
                if (IboUtil.DEFAULT_PROGRAMME_ROLES.contains(role.IB_Role_Name__c)){
                    rolesList.add(role);
                }
                
            }
            
            for (IB_Role__c role: rolesList) {
                roleMap.put(role.IB_Role_Name__c,role);
            }                         
            
            List<IB_Role__c> newRoles = new List<IB_Role__c>();
            final Set<Id> setContacts = new Set<Id>();
            
            if (programmeName.equals('PYP')) {
                
                if (pypHosContact.IB_Contact__c != null && updateRequired(pypHosContact,roleMap)) {
                    
                    IB_Role__c newRole = roleMap.containsKey(ROLE_HEAD) ? roleMap.get(ROLE_HEAD).clone() : pypHosContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = pypHosContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'PYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }                    
                } 
                
                if (pypProgrammeCoordinator.IB_Contact__c != null && updateRequired(pypProgrammeCoordinator,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_COORDINATOR) ? roleMap.get(ROLE_COORDINATOR).clone() : pypProgrammeCoordinator;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = pypProgrammeCoordinator.IB_Contact__c;
                    newRole.Programme_Selection__c = 'PYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    } 
                }
                
                if (pypBillingContact.IB_Contact__c != null && updateRequired(pypBillingContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_BILLING) ? roleMap.get(ROLE_BILLING).clone() : pypBillingContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = pypBillingContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'PYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }   
                
            } 
            
            else if (programmeName.equals('IBCC')) {
                
                if (ibccHosContact.IB_Contact__c != null && updateRequired(ibccHosContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_HEAD) ? roleMap.get(ROLE_HEAD).clone() : ibccHosContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = ibccHosContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'CP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (ibccProgrammeCoordinator.IB_Contact__c != null && updateRequired(ibccProgrammeCoordinator,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_COORDINATOR) ? roleMap.get(ROLE_COORDINATOR).clone() : ibccProgrammeCoordinator;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = ibccProgrammeCoordinator.IB_Contact__c;
                    newRole.Programme_Selection__c = 'CP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (ibccBillingContact.IB_Contact__c != null && updateRequired(ibccBillingContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_BILLING) ? roleMap.get(ROLE_BILLING).clone() : ibccBillingContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = ibccBillingContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'CP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (ibccExamContact.IB_Contact__c != null && updateRequired(ibccExamContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_EXAM) ? roleMap.get(ROLE_EXAM).clone() : ibccExamContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = ibccExamContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'CP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
            } 
            
            else if (programmeName.equals('MYP')) {
                
                if (mypHosContact.IB_Contact__c != null && updateRequired(mypHosContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_HEAD) ? roleMap.get(ROLE_HEAD).clone() : mypHosContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = mypHosContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'MYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (mypProgrammeCoordinator.IB_Contact__c != null && updateRequired(mypProgrammeCoordinator,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_COORDINATOR) ? roleMap.get(ROLE_COORDINATOR).clone() : mypProgrammeCoordinator;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = mypProgrammeCoordinator.IB_Contact__c;
                    newRole.Programme_Selection__c = 'MYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (mypBillingContact.IB_Contact__c != null && updateRequired(mypBillingContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_BILLING) ? roleMap.get(ROLE_BILLING).clone() : mypBillingContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = mypBillingContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'MYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (mypExamContact.IB_Contact__c != null && updateRequired(mypExamContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_EXAM) ? roleMap.get(ROLE_EXAM).clone() : mypExamContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = mypExamContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'MYP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
            } 
            
            else if (programmeName.equals('Diploma_Programme') || programmeName.equals('Agreement') ) { /**Agreement logic goes Here for Agreement 635 phase 2***/ 
                
                
                if (dpHosContact.IB_Contact__c != null && updateRequired(dpHosContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_HEAD) ? roleMap.get(ROLE_HEAD).clone() : dpHosContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = dpHosContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'DP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (dpProgrammeCoordinator.IB_Contact__c != null && updateRequired(dpProgrammeCoordinator,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_COORDINATOR) ? roleMap.get(ROLE_COORDINATOR).clone() : dpProgrammeCoordinator;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = dpProgrammeCoordinator.IB_Contact__c;
                    newRole.Programme_Selection__c = 'DP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (dpBillingContact.IB_Contact__c != null && updateRequired(dpBillingContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_BILLING) ? roleMap.get(ROLE_BILLING).clone() : dpBillingContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = dpBillingContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'DP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
                if (dpExamContact.IB_Contact__c != null && updateRequired(dpExamContact,roleMap)) {
                    IB_Role__c newRole = roleMap.containsKey(ROLE_EXAM) ? roleMap.get(ROLE_EXAM).clone() : dpExamContact;
                    newRole.IB_Programme_New__c = prog.Id;
                    newRole.IB_Contact__c = dpExamContact.IB_Contact__c;
                    newRole.Programme_Selection__c = 'DP';
                    if(!isAlreadyInvited(newRole)) {
                        newRoles.add(newRole);
                        setContacts.add(newRole.IB_Contact__c);    
                    }
                }
                
            } 
            
            else {
                
                System.debug(logTag + 'UNSUPPORTED PROGRAM: ' + programmeName);
                
            }           
            
            //Update the logic to not confirm invited contact roles when updated from Programme Default Contacts section.
            final ID confirmedRoleRecTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
            final ID invitedRoleRecTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Invited').getRecordTypeId();
            final ID standardContactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
            final ID invitedContactRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Invited Contact').getRecordTypeId();
            
            Map<Id,Contact> mapContacts = new Map<Id,Contact>();
            
            if(!setContacts.isEmpty()) {
                mapContacts = new Map<Id,Contact>([select Id,RecordTypeId from Contact where Id IN : setContacts]);
            }
            
            for (IB_Role__c role : newRoles) {                
                role.Start_Date__c = Date.today();
                if(mapContacts.containsKey(role.IB_Contact__c) && mapContacts.get(role.IB_Contact__c).RecordTypeId == standardContactRecTypeId) {
                    role.RecordTypeId = confirmedRoleRecTypeId;  
                    role.Status__c = 'Confirmed';
                    role.Active__c = true;
                } else {
                    role.RecordTypeId = invitedRoleRecTypeId;
                    role.Status__c = 'Invited';
                }                          
            } 
            
            // INSERT NEW ROLES
            if (newRoles.isEmpty()) {
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.PIMS_Profile_Contact_Panel_Change_Default_Contacts_Roles_Not_Updated)); 
                return null;
                
            } else {
                
                insert newRoles;                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PIMS_Profile_Contact_Panel_Change_Default_Contacts_Roles_Updated));
                String pageName = ApexPages.currentPage().getUrl().substringBetween('apex/', '?');
                return pageRedirect(pageName);
                
            }
            
        } catch (Exception exp) {
            
            ApexPages.addMessages(exp);
            return null;
            
        }
        /*RoleService.isRolesCached = false;
init();

return null;*/
        
    }    
    
    public PageReference saveAdminPYP() {
        return saveAdminAssistant('PYP');
    }
    
    public PageReference saveAdminMYP() {        
        return saveAdminAssistant('MYP');
    }
    
    public PageReference saveAdminDP() {
        return saveAdminAssistant('Diploma_Programme');
    }
    
    public PageReference saveAdminCP() {
        return saveAdminAssistant('IBCC');
    }
    
    /** Agreement 635-phase 2***/
    public PageReference saveAdminAgreement() {
        return saveAdminAssistant('Agreement');
    }
    
    
    public PageReference saveAdminAssistant(String programmeName) {
        system.debug('saveAdminAssistant Agreement***'+programmeName);
        string logTag = '++++ [saveAdminAssistant]';         
        
        try {
            
            system.debug('saveAdminAssistant programmes***'+programmes);
            IB_Programme__c prog = profileService.getProgrammeByType(programmes, programmeName);
            system.debug('saveAdminAssistant prog***'+prog);
            IB_Programme__c updateProg = new IB_Programme__c(Id = prog.Id, Programme_Contacts_Last_Modified__c = Date.today());
            
            if (!test.isRunningTest()) {
                update updateProg;
                system.debug('saveAdminAssistant prog***'+updateProg);
            }           
            
            ProfileService.account = account;
            
            if (!test.isRunningTest()) {    
                RoleService.setAccountId(account.Id);
            }
            
            RoleService.setProgrammeId(prog.Id);  
            
            List<IB_Role__c> rolesList = new List<IB_Role__c>();
            List<IB_Role__c> adasRolesList = new List<IB_Role__c>();
            
            for (IB_Role__c role: RoleService.getRolesByProgrammeId()) {
                
                if (role.IB_Role_Name__c == ROLE_ADMIN) {
                    adasRolesList.add(role);
                }
                
            }
            
            Set<Id> adminRolesToWithdraw = new Set<Id>();
            List<IB_Role__c> newRolesADAS = new List<IB_Role__c>();
            system.debug('saveAdminAssistant before switch***');
            switch on programmeName {
                
                when 'PYP' {
                    
                    List<Id> pypNewAdminContacts = getPypAdminAssistants();
                    
                    AdminValidationResponse validationResult = validateAdminRoles(pypNewAdminContacts, adasRolesList );
                    
                    adminRolesToWithdraw.addAll(validationResult.rolesToWithdraw);
                    
                    if (validationResult.isSuccess == true) {  
                        
                        for (Id pypAdminContact : validationResult.contactsToAdd) {
                            //Removing HOS from this validation rule per INC0175659 - Kevin Fugate
                            if (/*pypAdminContact == pypHosContact.IB_Contact__c || */pypAdminContact == pypProgrammeCoordinator.IB_Contact__c) {
                                
                                apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.ADAS_HOS_PC_Error));                          
                                return null;
                                
                            }               
                            
                            IB_Role__c newRole = new IB_Role__c();
                            newRole.IB_Contact__c = pypAdminContact;                     
                            newRolesADAS.add(newRole);                
                            
                        } 
                        
                    } else {
                        
                        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,validationResult.errorMsg));                   
                        return null;
                        
                    }
                    
                }   
                
                when 'IBCC' {
                    
                    List<Id> ibccNewAdminContacts = getIbccAdminAssistants();
                    
                    AdminValidationResponse validationResult = validateAdminRoles(ibccNewAdminContacts, adasRolesList );
                    
                    adminRolesToWithdraw.addAll(validationResult.rolesToWithdraw);
                    
                    if (validationResult.isSuccess == true) {  
                        
                        for (Id ibccAdminContact : validationResult.contactsToAdd) {
                            //Removing HOS from this validation rule per INC0175659 - Kevin Fugate
                            if (/*ibccAdminContact == ibccHosContact.IB_Contact__c || */ibccAdminContact == ibccProgrammeCoordinator.IB_Contact__c) {
                                
                                apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.ADAS_HOS_PC_Error));                            
                                return null;
                                
                            }               
                            
                            IB_Role__c newRole = new IB_Role__c();
                            newRole.IB_Contact__c = ibccAdminContact;                     
                            newRolesADAS.add(newRole);                
                            
                        } 
                        
                    } else {
                        
                        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,validationResult.errorMsg));                 
                        return null;
                        
                    }    
                    
                }
                
                when 'MYP' {                    
                    
                    List<Id> mypNewAdminContacts = getMypAdminAssistants();
                    
                    AdminValidationResponse validationResult = validateAdminRoles(mypNewAdminContacts, adasRolesList );
                    
                    adminRolesToWithdraw.addAll(validationResult.rolesToWithdraw);
                    
                    if (validationResult.isSuccess == true) {  
                        
                        for (Id mypAdminContact : validationResult.contactsToAdd) {
                            //Removing HOS from this validation rule per INC0175659 - Kevin Fugate
                            if (/*mypAdminContact == mypHosContact.IB_Contact__c || */mypAdminContact == mypProgrammeCoordinator.IB_Contact__c) {
                                
                                apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.ADAS_HOS_PC_Error));                           
                                return null;
                                
                            }               
                            
                            IB_Role__c newRole = new IB_Role__c();
                            newRole.IB_Contact__c = mypAdminContact;                     
                            newRolesADAS.add(newRole);                
                            
                        } 
                        
                    } else {
                        
                        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,validationResult.errorMsg));                     
                        return null;
                        
                    }
                    
                }
                
                when 'Diploma_Programme' {                    
                    
                    List<Id> dpNewAdminContacts = getDpAdminAssistants();
                    
                    AdminValidationResponse validationResult = validateAdminRoles(dpNewAdminContacts, adasRolesList );
                    
                    adminRolesToWithdraw.addAll(validationResult.rolesToWithdraw);
                    
                    if (validationResult.isSuccess == true) {  
                        
                        for (Id dpAdminContact : validationResult.contactsToAdd) {
                            //Removing HOS from this validation rule per INC0175659 - Kevin Fugate
                            if (/*dpAdminContact == dpHosContact.IB_Contact__c || */dpAdminContact == dpProgrammeCoordinator.IB_Contact__c) {
                                
                                apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.ADAS_HOS_PC_Error));                           
                                return null;
                                
                            }               
                            
                            IB_Role__c newRole = new IB_Role__c();
                            newRole.IB_Contact__c = dpAdminContact;                     
                            newRolesADAS.add(newRole);                
                            
                        } 
                        
                    } else {
                        
                        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,validationResult.errorMsg));                     
                        return null;
                        
                    }                
                    
                }
                
                /** Added for Agreement phase 2***/
                when 'Agreement' {                    
                    
                    system.debug('saveAdminAssistant Agreement***');
                    List<Id> agreementNewAdminContacts = getAgreementAdminAssistants();
                    
                    AdminValidationResponse validationResult = validateAdminRoles(agreementNewAdminContacts, adasRolesList );
                    
                    adminRolesToWithdraw.addAll(validationResult.rolesToWithdraw);
                    
                    system.debug('validationResult***'+validationResult);
                    system.debug('validationResult.isSuccess***'+validationResult.isSuccess);
                    if (validationResult.isSuccess == true) {  
                        
                        for (Id agreementAdminContact : validationResult.contactsToAdd) {
                            if (agreementAdminContact == dpProgrammeCoordinator.IB_Contact__c) {
                                system.debug('Label.ADAS_HOS_PC_Error***'+Label.ADAS_HOS_PC_Error);
                                apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Label.ADAS_HOS_PC_Error));                           
                                return null;
                                
                            }               
                            
                            IB_Role__c newRole = new IB_Role__c();
                            newRole.IB_Contact__c = agreementAdminContact;                     
                            newRolesADAS.add(newRole);                
                            
                        } 
                        
                    } else {
                        
                        apexpages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,validationResult.errorMsg));                     
                        return null;
                        
                    }                
                    
                }
                
                /** Added for Agreement phase 2***/ 
                when else {
                    
                    System.debug(logTag + 'UNSUPPORTED PROGRAM: ' + programmeName);
                    
                }
                
            }
            
            system.debug('saveAdminAssistant after switch***');
            ID invitedRecTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
            system.debug('invitedRecTypeIdh***'+invitedRecTypeId);
            
            List<IB_Role_Repository__c> roleRepo = ProfileService.getAllRolesFromRepository();
            system.debug('roleRepo***'+roleRepo);
            
            List<IB_Role__c> upsertRolesList = new List<IB_Role__c>();
            List<IB_Role__c> updateRolesList = new List<IB_Role__c>();
            
            system.debug('newRolesADAS***'+newRolesADAS);
            for (IB_Role__c role : newRolesADAS) {
                
                if (role.IB_Contact__c != null) { 
                    
                    if(prog.Recordtype.Name =='Agreement'){
                        role.Programme_Selection__c ='DP';
                    }
                    
                    role.IB_Programme_New__c = prog.Id;
                    role.IB_Role__c = ProfileService.getRoleByName(roleRepo, ROLE_ADMIN).Id; 
                    role.IB_Account__c = account.Id;
                    role.Start_Date__c = Date.today();
                    role.RecordTypeId = invitedRecTypeId;
                    role.Status__c = 'Confirmed';
                    role.Active__c = true;
                    role.Id = null;  
                    
                }             
                
            }
            
            for (Id roleId : adminRolesToWithdraw) {
                
                IB_Role__c role = new IB_Role__c(Id = roleId);
                role.Status__c = 'Withdrawn';
                role.End_Date__c = Date.today();
                role.Active__c = false;                     
                updateRolesList.add(role);
                
            }
            
            upsertRolesList.addAll(newRolesADAS);
            upsertRolesList.addAll(updateRolesList);
            
            system.debug('upsertRolesList***'+upsertRolesList);
            
            if (upsertRolesList.isEmpty()){
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.PIMS_Profile_Contact_Panel_Change_Default_Contacts_Roles_Not_Updated));    
                
            } else {
                system.debug('saveAdminAssistant Agreement inside else***');
                Database.UpsertResult[] sResults = Database.Upsert(upsertRolesList);
                system.debug('sResults Agreement inside else***'+sResults);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PIMS_Profile_Contact_Panel_Change_Default_Contacts_Roles_Updated));
                
                List<IB_Role__c> newlyInsertedRoleIds = new List<IB_Role__c>();
                
                for (Integer index = 0, size = sResults.size(); index < size; index++) {                    
                    if(sResults[index].isSuccess()) {                        
                        if (sResults[index].isCreated()) { 
                            
                            newlyInsertedRoleIds.add(new IB_Role__c(Id = sResults[index].getId()));   
                            
                        }                         
                    }                    
                }
                
                if (newlyInsertedRoleIds.size() > 0) {
                    
                    AdminAssistantHelper.sendEmailToAdminAssistantforInvitation(newlyInsertedRoleIds);
                    
                }
                
            }
            
        } catch (Exception exp) {
            system.debug('exp**'+exp.getLineNUmber()+'**'+exp.getCause());            
            ApexPages.addMessages(exp);
            
        }
        
        init();
        
        return null;
        
    }
    
    /** Added for agreement ***/
    @testvisible 
    private List<Id> getAgreementAdminAssistants() {
        
        List<Id> ibRolesContactIdsList = new List<Id>();
        
        if (dpAdminAssistantContact1 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact1);
        }      
        
        if (dpAdminAssistantContact2 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact2);
        }
        
        if (dpAdminAssistantContact3 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact3);
        }
        
        return ibRolesContactIdsList;
        
    }
    
    
    @testvisible 
    private List<Id> getDpAdminAssistants() {
        
        List<Id> ibRolesContactIdsList = new List<Id>();
        
        if (dpAdminAssistantContact1 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact1);
        }      
        
        if (dpAdminAssistantContact2 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact2);
        }
        
        if (dpAdminAssistantContact3 != null) {
            ibRolesContactIdsList.add(dpAdminAssistantContact3);
        }
        
        return ibRolesContactIdsList;
        
    }
    
    @testvisible 
    private List<Id> getPypAdminAssistants() {
        
        List<Id> ibRolesContactIdsList = new List<Id>();
        
        if (pypAdminAssistantContact1 != null) {
            ibRolesContactIdsList.add(pypAdminAssistantContact1);
        }      
        
        if (pypAdminAssistantContact2 != null) {
            ibRolesContactIdsList.add(pypAdminAssistantContact2);
        }
        
        if (pypAdminAssistantContact3 != null) {
            ibRolesContactIdsList.add(pypAdminAssistantContact3);
        }
        
        return ibRolesContactIdsList;
        
    }
    
    @testvisible 
    private List<Id> getMypAdminAssistants() {
        
        List<Id> ibRolesContactIdsList = new List<Id>();
        
        if (mypAdminAssistantContact1 != null) {
            ibRolesContactIdsList.add(mypAdminAssistantContact1);
        }      
        
        if (mypAdminAssistantContact2 != null) {
            ibRolesContactIdsList.add(mypAdminAssistantContact2);
        }
        
        if (mypAdminAssistantContact3 != null) {
            ibRolesContactIdsList.add(mypAdminAssistantContact3);
        }
        
        return ibRolesContactIdsList;
        
    }
    
    @testvisible 
    private List<Id> getIbccAdminAssistants() {
        
        List<Id> ibRolesContactIdsList = new List<Id>();
        
        if (ibccAdminAssistantContact1 != null) {
            ibRolesContactIdsList.add(ibccAdminAssistantContact1);
        }      
        
        if (ibccAdminAssistantContact2 != null) {
            ibRolesContactIdsList.add(ibccAdminAssistantContact2);
        }
        
        if (ibccAdminAssistantContact3 != null) {
            ibRolesContactIdsList.add(ibccAdminAssistantContact3);
        }
        
        return ibRolesContactIdsList;
        
    } 
    
    @testvisible 
    private Boolean updateRequired(IB_Role__c newRole, Map<String,IB_Role__c> roleMap) {
        
        final string logTag = '[updateRequired]';
        
        if(roleMap.containsKey(newRole.IB_Role_Name__c)){
            
            IB_Role__c oldRole = roleMap.get(newRole.IB_Role_Name__c);
            // Check if the roles have the same programme id and 
            // if the IB_Contact__c has changed
            if(oldRole.IB_Programme_New__c == newRole.IB_Programme_New__c && oldRole.IB_Contact__c != newRole.IB_Contact__c){
                return true;
            } else {
                return false;
            }
        } else {
            return true; // true will allow the calling method to insert a new role for this program.
        }
    }
    
    @testvisible
    private boolean isAlreadyInvited(IB_Role__c newRole) {
        for(IB_Role__c invitedRole: invitedRoles) {
            if(newRole.IB_Contact__c == invitedRole.IB_Contact__c && newRole.IB_Programme_New__c == invitedRole.IB_Programme_New__c && newRole.IB_Role__c == invitedRole.IB_Role__c)
                return true;
        }
        return false;
    }
    
    @testvisible 
    private AdminValidationResponse validateAdminRoles(List<Id> newContactIdsList, List<IB_Role__c> oldRolesList) {
        
        AdminValidationResponse resp = new AdminValidationResponse(); 
        
        Set<Id> newContactIdsSet = new Set<Id>(newContactIdsList);         
        
        if (newContactIdsSet.size() < newContactIdsList.size()) {
            
            resp.isSuccess = false;
            resp.errorMsg = Label.ADAS_duplicateAdminAssistantError;
            
        } else {
            
            for (IB_Role__c existingRole : oldRolesList) {                          
                
                // Case 1: when new contacts list contains an already confirmed contact, do not insert the role record again
                // Case 2: when new contacts list does not contain an already confirmed contact, withdraw existing role
                
                if (newContactIdsList.contains(existingRole.IB_Contact__c) && (existingRole.Status__c == 'Confirmed')) {
                    
                    // this should be a confirmed contact displayed while initially loading page
                    newContactIdsSet.remove(existingRole.IB_Contact__c);                     
                    
                } else if (!newContactIdsList.contains(existingRole.IB_Contact__c) && (existingRole.Status__c == 'Confirmed')) {
                    
                    resp.rolesToWithdraw.add(existingRole.Id);
                    
                }        
                
            }
            
        }
        
        resp.contactsToAdd = newContactIdsSet;
        
        return resp;
        
    }
    
    public class AdminValidationResponse {
        
        public String errorMsg;
        public Boolean isSuccess;
        public Set<Id> rolesToWithdraw;
        public Set<Id> contactsToAdd;
        
        public AdminValidationResponse(){
            isSuccess = true;
            errorMsg = '';
            rolesToWithdraw = new Set<Id>();
            contactsToAdd = new Set<Id>();
        }       
        
    }
    
    @testvisible 
    private List<IB_Role__c> getRoleUpdates(Map<String,IB_Programme__c> progMap, Map<String,List<IB_Role__c>> progRoleMap, Map<String,List<IB_Role__c>> newRoleMap) {
        
        final string logTag = '[getRoleUpdates]';
        List<IB_Role__c> updates = new List<IB_Role__c>();
        
        // Did any of the Roles change?
        // Loop through the progRoleMap, identify which Programme we're working with..
        for(String progName:progRoleMap.keySet()){
            
            
            // Loop through each Role in the List
            List<IB_Role__c> progRoles = progRoleMap.get(progName);
            Map<String,IB_Role__c> roleMap = new Map<String,IB_Role__c>();
            for(IB_Role__c r:progRoles) roleMap.put(r.IB_Role_Name__c,r);
            
            // Get the current IB Programme record
            IB_Programme__c ibp = progMap.get(progName);
            
        }
        
        return updates;
        
    }
    
    public PageReference sendReminder() {
        PageReference pageRef = ApexPages.currentPage();// added by kashyap as a part of ECM 00503
        
        if(!Test.isRunningTest()){
            createEmail();
        }
        else if(Test.isRunningTest())
        {
            sendEmail('test@example.com');
        }
        
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PIMS_Email_Reminder_Message));//Added  by Kashyap as a part of ECM003-Miscellaneous functionalities on Invited Contact 
        if (isUpdatePage){
            redirectUrl = '/pims/PimsProfile?tab=contact';// added by kashyap as a part of ECM 00503
            addStep='X';// added by kashyap as a part of ECM 00503 to show toast messsage on click on send reminder and reload the same page
        }else{
            redirectUrl='/pims/PimsProfileNew?tab=contact';
            addStep='X';
        }
        return null;
    }
    
    @testvisible 
    private void sendEmail(String toemail) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String developerName;
        string rolename;
        string programme;
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        
        /** Since Program coordinators in cc is not required commenting out below ***/
        //List<User> programCoordinatorContacts=  [select id,name, Email,contactId,contact.Name from User where id=:UserInfo.getUserId() ];
        //system.debug('programCoordinatorContacts***'+programCoordinatorContacts[0].Email);
        
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        if(getUserLanguageKey() == 'fr'){
            developerName = 'PIMS_Send_Email_Reminder_Body_fr';
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name_fr__c;
                programme = roleForEmail.Programme_Type_FR__c;
            }
        } else if(getUserLanguageKey() == 'es'){
            developerName = 'PIMS_Send_Email_Reminder_Body_es';
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name_es__c;
                programme = roleForEmail.Programme_Type_ES__c;
            }
        } else {
            developerName = 'PIMS_Send_Email_Reminder_Body'; 
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name__c;
                programme = roleForEmail.Programme_Type__c;
            }
        }
        
        EmailTemplate template;  
        try {
            template = [SELECT id, name, HtmlValue, Body,Subject FROM EmailTemplate WHERE developername =: developerName];
        } catch (Exception e) {
            
        }
        
        try{
            String[] toAddresses = new String[] {toemail};
                mail.setToAddresses(toAddresses);
            //String[] ccAddresses = new String[] {programCoordinatorContacts[0].Email};
            //mail.setCcAddresses(ccAddresses);
            
            String plainSubject= template.Subject;
            mail.setSubject(plainSubject);
            
            String plainBody = template.Body;
            
            system.debug('roleForEmail***'+roleForEmail);
            
            if(contactForEmail != null)
            {
                plainBody = plainBody.replace('[Last Name]', contactForEmail.name);
                plainBody = plainBody.replace('[School Name]', contactForEmail.Account.Name);
            }
            if(roleForEmail!= null)
            {
                plainBody = plainBody.replace('[Date]', (roleForEmail.createddate).date().format());
                plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
            }
            plainBody = plainBody.replace('[URL]', url);
            if(conOwnerList[0].Name!= null)
                plainBody = plainBody.replace('[Owner Name]', conOwnerList[0].Name);
            if(programme!= null)
                plainBody = plainBody.replace('[Programme Name]', programme);
            // Agreement Recordtye ECM00635
            if(agreementTypeOfProgramme!= null ){
                plainBody = plainBody.replace('[Agreement Type]', '-'+agreementTypeOfProgramme+'-');
            }else{
                plainBody = plainBody.replace('[Agreement Type]','');
            }
            // Agreement Recordtye ECM00635
            
            
            mail.setPlainTextBody(plainBody);
        }
        catch(exception e)
        {
            system.debug('excep'+e+'lno**'+e.getLineNumber()+'Cause**'+e.getCause());
        }
        system.debug('mail***'+mail);
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
    
    //New method added by Jagan for sending email to invited contact from intent to apply add contact 
    public void sendInvitationEmail(String toemail){
        if(Test.isRunningTest())
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String developerName;
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }            
            if(getUserLanguageKey() == 'fr'){
                developerName = 'PIMS_Email_Reminder_Body_fr';
            } else if(getUserLanguageKey() == 'es'){
                developerName = 'PIMS_Email_Reminder_Body_es';
            } else {
                developerName = 'PIMS_Email_Reminder_Body';
            }
            if(roleForEmail == null){
                developerName = developerName + '_v2';
            }
            EmailTemplate template;  
            try {
                template = [SELECT id, name, HtmlValue, Body FROM EmailTemplate WHERE developername =: developerName];
            } catch (Exception e) {
                
            }
            String[] toAddresses = new String[] {toemail};
                mail.setToAddresses(toAddresses);
        }
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String developerName;
            string rolename;
            string programme;
            invitationID =[SELECT Id, Invitation_ID__c FROM Contact WHERE Id =: contactForEmail.id].Invitation_ID__c;
            if(invitationID==null){
                invitationID = '';
            }
            String headUrl = ApexPages.currentPage().getHeaders().get('Host');
            String curUrl = '/ibportal/IBPortalTriagePage?inviteid=';
            url ='https://'+headUrl+curUrl+invitationID;
            List<User> conOwnerL = [SELECT Id, Name FROM User WHERE Id =: UserInfo.getUserId()  LIMIT 1];
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            if(getUserLanguageKey() == 'fr'){
                developerName = 'PIMS_Email_Reminder_Body_fr';
                if(roleForEmail != null){
                    rolename = roleForEmail.IB_Role_Name_fr__c;
                    programme = roleForEmail.Programme_Type_FR__c;
                }
            } else if(getUserLanguageKey() == 'es'){
                developerName = 'PIMS_Email_Reminder_Body_es';
                if(roleForEmail != null){
                    rolename = roleForEmail.IB_Role_Name_es__c;
                    programme = roleForEmail.Programme_Type_ES__c;
                }
            } else {
                developerName = 'PIMS_Email_Reminder_Body';
                if(roleForEmail != null){
                    rolename = roleForEmail.IB_Role_Name__c;
                    programme = roleForEmail.Programme_Type__c;
                }
            }
            if(roleForEmail == null){
                developerName = developerName + '_v2';
            }
            EmailTemplate template;  
            try {
                template = [SELECT id, name, HtmlValue, Body FROM EmailTemplate WHERE developername =: developerName];
            } catch (Exception e) {
                
            }
            String[] toAddresses = new String[] {toemail};
                mail.setToAddresses(toAddresses);
            mail.setSubject(Label.PIMS_Email_Reminder_Subject);
            String plainBody = template.Body;
            if(contactForEmail.Salutation== null || contactForEmail.Salutation == ''){
                plainBody = plainBody.replace('[Salutation]', '');
            } else plainBody = plainBody.replace('[Salutation]', contactForEmail.Salutation);
            plainBody = plainBody.replace('[First Name]', contactForEmail.firstname);
            plainBody = plainBody.replace('[Last Name]', contactForEmail.lastname);
            if(roleForEmail != null){
                plainBody = plainBody.replace('[Account Name]', conOwnerL[0].Name);
                // plainBody = plainBody.replace('[Account Name]', contactForEmail.Account.Name);
                plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
                plainBody = plainBody.replace('[Programme Name]', programme);
            } else {
                plainBody = plainBody.replace('[Account Name]', account.Name);
                plainBody = plainBody.replace('[Owner Name]', conOwnerL[0].Name);
            }
            plainBody = plainBody.replace('[URL]', url);
            mail.setPlainTextBody(plainBody);
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(exception e){
                
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        }
        catch(exception e)
        {
            system.debug('excep invite'+e+'lno**'+e.getLineNumber()+'Cause**'+e.getCause());
            
        }
    }
    
    public void createEmail() { 
        
        
        if(newReminderId != null && !invitedContacts.isEmpty()){
            for(Contact con:invitedContacts){
                if(con.Id == newReminderId){
                    contactForEmail = con;
                    break;
                }
            }
        }
        try{
            if(contactForEmail != null){
                contactForEmail.Email_Reminder__c = Date.today();
                contactForEmail.EmailReminderDateTime__c =Datetime.now();
                
                update contactForEmail;
                
                email = contactForEmail.Email;
                invitationID =[SELECT Id, Invitation_ID__c,AccountId,Account.Name FROM Contact WHERE Id =: contactForEmail.id].Invitation_ID__c;
                if(invitationID==null){
                    invitationID = '';
                }
                String headUrl = ApexPages.currentPage().getHeaders().get('Host');
                String curUrl = '/ibportal/IBPortalTriagePage?inviteid=';
                String curUrl2 = '/ibportal/roleRejectConfirmADAS?inviteid=';
                url ='https://'+headUrl+curUrl+invitationID;
                url2 = 'https://'+headUrl+curUrl2+invitationID;
                if(invitedRoles != null && !invitedRoles.isEmpty()){
                    if(roleId != null)
                    {
                        for (IB_Role__c role : invitedRoles) {
                            if (role.Id == roleId) {
                                roleForEmail = role;
                                break;
                            }
                        }
                    }  else{
                        if(!Test.isRunningTest())
                        {
                            for (IB_Role__c role : invitedRoles) {
                                if (role.IB_Contact__c == contactForEmail.Id) {
                                    roleForEmail = role;
                                    break;
                                }
                                
                            }
                            
                        }
                    }
                }
                conOwnerList = [SELECT Id, Name FROM User WHERE Id =: contactForEmail.OwnerId LIMIT 1];
                
                system.debug('in roleForEmail***'+roleForEmail +'Name **'+ roleForEmail.IB_Role_Name__c + '** Admin' +ROLE_ADMIN);
                if(roleForEmail != NULL && (roleForEmail.IB_Role_Name__c == ROLE_ADMIN  || roleForEmail.IB_Role_Name__c == 'Chief Invigilator') )
                {
                    system.debug('inside of AdminAssistantHelper');
                    roleForEmail.IB_Contact__r.Email = email;
                    AdminAssistantHelper.sendEmailToADASReminder(url,url2,roleForEmail);
                }
                else{
                    //Added by Kashyap ECM00635 
                    if(roleForEmail.IB_Programme_New__r.RecordType.DeveloperName =='Agreement'){
                        agreementTypeOfProgramme= roleForEmail.IB_Programme_New__r.Agreement_Type__c;
                    }
                    //Added by Kashyap ECM00635 
                    sendEmail(email);  
                }
            }
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
    }
    
    /** New method added by kashyap for manual withdraw of invited contacts ****/
    public PageReference removeInvitedRoleManually() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact contactToDelete = new Contact();
            contactToDelete.Id = deleteContactId;
            system.debug('conToDelete id : ' + contactToDelete.Id);
            List<IB_Role__c> rolesForContact = [select id,name,IB_Role_Name_fr__c,IB_Role_Name_es__c,Programme_Type_FR__c,Programme_Type_ES__c,IB_Role_Name__c,Programme_Type__c,IB_Contact__r.Email,IB_Account__c,IB_Account__r.Name,createddate from IB_Role__c  WHERE IB_Contact__c = :deleteContactId AND IB_Account__c = :account.Id ];
            if(rolesForContact.size()>0)
            {
                String withDrawalEmail = rolesForContact[0].IB_Contact__r.Email;
                if(withDrawalEmail!= '' && withDrawalEmail!= null)
                {
                    sendWithDrawalEmail(rolesForContact[0].IB_Contact__c,rolesForContact[0]);
                }
            }
            List<IB_Referee_Feedback__c> ibRefereeFeedback =[select id,name from IB_Referee_Feedback__c where My_Role__c =: rolesForContact[0].id 
                                                             and IB_Contact__c =: contactToDelete.Id ];
            
            delete ibRefereeFeedback;
            delete rolesForContact;
            User isUser;
            
            try{
                isUser = [SELECT ID FROM User WHERE ContactId = :deleteContactId LIMIT 1];
            } catch(Exception e) {
                //this means there is no associated contact which is valid
                isUser = null;
            }
            if(isUser == null)
            {
                delete contactToDelete;
            }
            
            activeTab = 'contact';
            if (isUpdatePage) pageRef = new PageReference('/pims/PimsProfile');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'contact';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
        
    }
    
    /** New method added by kashyap for sending manual withdraw emails of invited contacts ****/
    public void sendWithDrawalEmail(Id contactId, IB_Role__c roleForEmail) {
        List<Contact> removalContact= [select id,name,Email,Salutation,firstname,lastname,Account.Name,AccountId from contact where id=: contactId ];
        List<User> programCoordinatorContacts=  [select id,name, Email,contactId,contact.Name from User where id=:UserInfo.getUserId() ];
        Contact contactForEmail= removalContact[0];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String developerName;
        string rolename;
        string programme;
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        if(getUserLanguageKey() == 'fr'){
            developerName = 'PIMS_WithDrawalEmail_Body_fr';
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name_fr__c;
                programme = roleForEmail.Programme_Type_FR__c;
            }
        } else if(getUserLanguageKey() == 'es'){
            developerName = 'PIMS_WithDrawalEmail_Body_es';
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name_es__c;
                programme = roleForEmail.Programme_Type_ES__c;
            }
        } else {
            developerName = 'PIMS_WithDrawalEmail_Body';
            if(roleForEmail != null){
                rolename = roleForEmail.IB_Role_Name__c;
                programme = roleForEmail.Programme_Type__c;
            }
        }
        EmailTemplate template;  
        try {
            template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
        } catch (Exception e) {
            
        }
        
        try{
            String[] toAddresses = new String[] {contactForEmail.Email };
                String[] ccAddresses = new String[] {programCoordinatorContacts[0].Email};          
                    mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            String plainSubject= template.Subject;
            plainSubject= plainSubject.replace('[Role Name] ', roleForEmail.IB_Role_Name__c);
            plainSubject= plainSubject.replace('[Name of School]', roleForEmail.IB_Account__r.Name);
            mail.setSubject(plainSubject);
            String plainBody = template.Body;
            plainBody = plainBody.replace('[Last Name]', contactForEmail.name);
            if(programCoordinatorContacts[0].contact.Name != null){
                plainBody= plainBody.replace('[Programme Coordinator]', programCoordinatorContacts[0].contact.Name);
            }
            if(roleForEmail != null){
                plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
            } 
            mail.setPlainTextBody(plainBody);
        }
        catch(exception e)
        {
            system.debug('excep'+e+'lno:'+e.getLineNumber() + 'In class PimsProfileContactController');
        }
        
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception e){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
        }
    }
    
    public PageReference pageRedirect(String pageName) {
        pageName = pageName.toLowerCase();
        PageReference pageRefer = ApexPages.currentPage();
        if(pageName.contains('pimsdashboard')   &&(pageIntent == 'pyp' || pageIntent == 'myp' || pageIntent == 'ibcc' || pageIntent =='dp')){
            pageRefer = new PageReference('/pims/PimsDashboard');
            pageRefer.getParameters().put('prog', pageIntent);
        } else if(pageName.contains('pimsprofilenew')){//Requesting to not merge below if with this else if
            pageRefer = new PageReference('/pims/PimsProfileNew');
            if(pageIntent == 'profileNew_pyp' || pageIntent == 'profileNew_myp' || pageIntent == 'profileNew_ibcc' || pageIntent =='profileNew_dp'){
                pageIntent = pageIntent.split('_')[1];
                pageRefer.getParameters().put('prog', pageIntent);
            }
            else{
                pageRefer.getParameters().put('tab', 'contact');
            }
        } else if(pageName.contains('pimsprofile')){
            pageRefer = new PageReference('/pims/PimsProfile');
            pageRefer.getParameters().put('tab', 'contact');
        }
        pageRefer.setRedirect(true);
        return pageRefer;
    }
    
}