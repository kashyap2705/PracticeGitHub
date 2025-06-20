public with sharing class ApplicationBudgetTableController extends PimsApplicationControllerHelper {
    
    public String appId { get; set; }
    
    public IB_Application__c application { get; set; }
    public Account account { get; set; }
    public List<IB_Address__c> addresses { get; set; }
    public List<SchoolSections__c> sections { get; set; }
    public List<Contact> contactsByAccount { get; set ; }
    public List<Contact> contacts { get; set; }
    public List<IB_Role__c> roles { get; set; }
    public List<IB_Programme__c> programmes { get; set; }
    public IB_Programme__c programme { get; set; }
    
    private ProfileService profileService = new ProfileService();
    
    public List<Application_Budget_Table__c> applicationBudgetTable { get; set; }
    
    public Id deleteAbtId { get; set; }
    public String activeTab { get; set; }
    public Boolean isUpdatePage { get; set; }
    
    public ApplicationBudgetTableController() {
        try
        {
            //PimsCommunityService pimsService = new PimsCommunityService();
            //pimsService.initUserData();
            String tmpTab = ApexPages.currentPage().getParameters().get('tab');
            
            //appId = ApexPages.currentPage().getParameters().get('id');
            activeTab = ApexPages.currentPage().getParameters().get('tab');
            
            if (activeTab == null || activeTab == '') {
                activeTab = 'instructions';
            }
            
            String tmpTab2 = ApexPages.currentPage().getParameters().get('tab');
            
            /*contacts = [
SELECT  Id, AccountId, LastName, FirstName, Salutation, Name, Title, Account__c, Preferred_Email__c
FROM Contact
WHERE AccountId = '001m000000LfdUBAAZ'
];*/
            
            appId = ApexPages.currentPage().getParameters().get('id');
            
            if (appId == null) {
                throw new CustomValidationException(Label.PIMS_INVALID_APPID);
            }
            
            String tmpTab3 = ApexPages.currentPage().getParameters().get('tab');
            
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            
            account = pimsService.getCurrentAccount();
            profileService.account = account;
            
            
            String tmpTab4 = ApexPages.currentPage().getParameters().get('tab');
            
            programmes = profileService.getProgrammes();
            addresses = profileService.getAddresses();
            sections = profileService.getSchoolSections();
            
            contactsByAccount = profileService.getContactsByAccount(account.Id);
            roles = profileService.getRolesByAccount(account.Id);
            contacts = profileService.getContactsByAccountAndRole(contactsByAccount, roles);
            
            ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            String tmpTab5 = ApexPages.currentPage().getParameters().get('tab');
            
            applicationBudgetTable = [
                SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
                PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
                USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
                Pro_Dev_Item__c, Other_Item__c, Id, Name, Fee_Item__c
                FROM Application_Budget_Table__c
                WHERE Name = 'Budget Test'
            ];
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
    }
    
    public PageReference save() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            /*if (!profileService.validateSections(account.Id)) {
throw new CustomValidationException('At least one school section needs to be filled out.');
}*/
            
            update applicationBudgetTable;
            
            if (isUpdatePage) {
                activeTab = 'section';
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            
            pageRef.setRedirect(true);
            
        }
        
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'section';
            pageRef.setRedirect(false);
            
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    
    public PageReference create() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            insert applicationBudgetTable;
            
            activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
            
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    
    public PageReference edit() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            update applicationBudgetTable;
            
            activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/apex/InternalApplicationFeedback');
            }
            pageRef.setRedirect(true);
            
        }
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'section';
            pageRef.setRedirect(false);
            
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    
    public PageReference remove() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Application_Budget_Table__c abtToDelete = new Application_Budget_Table__c();
            abtToDelete.Id = deleteAbtId;
            delete abtToDelete;
            
            activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/apex/InternalApplicationFeedback');
            }
            pageRef.setRedirect(true);
        }
        
        catch (DmlException ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
}