public class InternalAppForCandidacyController extends PimsApplicationControllerHelper {
    
    public String appId {get;set;}
    public String accId {get;set;}
    public String progId {get;set;}
    
    public IB_Application__c application {get;set;}
    public IB_Programme__c programme {get;set;}
    
    public Account account {get;set;}
    public List<IB_Address__c> addresses {get;set;}
    public List<SchoolSections__c> sections {get;set;}
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public List<IB_Programme__c> programmes {get;set;}
    
    public List<IB_Application_Attachment__c> attachments {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetTable {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {get;set;}
    
    
    public Application_Coordinator_Time__c editCoordinatorTime {get;set;}
    
    /*public List<Application_Coordinator_Time__c> coordnatorTimeList {get;set;}*/
    
    public Application_Account_Facilities__c applicationAccountFacilities {get;set;}
    public List<Application_Account_Facilities__c> applicationAccountFacilitiesList {get;set;}
    
    public String activeTab {get;set;}
    
    private ProfileService profileService = new ProfileService();
    
    public void init() {
        
        activeTab = PageService.getActiveTab();
        
        // we should never fall into here, but just in case show the profile panel
        if (activeTab == null) {
            activeTab = 'desc';
        }
        
    }
    
    public InternalAppForCandidacyController () {
        try
        {
            
            appId = ApexPages.currentPage().getParameters().get('id');
            activeTab = ApexPages.currentPage().getParameters().get('tab');
            
            if (activeTab == null || activeTab == '') {
                activeTab = 'desc';
            }
            
            if (appId == null) {
                throw new CustomValidationException(Label.PIMS_INVALID_APPID);
            }
            
            ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();
            
            /*setAccountId(application.Account__r.Id);*/
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            
            accId = programme.account__c;
            progId = programme.Id;
            
            /*ProgrammeService.setAccountId(account.Id);*/
            /*programmes = ProgrammeService.getProgrammesByAccount();*/
            
            /*AddressService.setAccountId(account.Id);
addresses = AddressService.getAddressesByAccount();*/
            
            /*SchoolSectionsService.setAccountId(account.Id);
sections = SchoolSectionsService.getSectionsByAccount();*/
            
            /*RoleService.setAccountId(account.Id);
roles = RoleService.getRolesByAccountId();

ContactService.setAccountId(account.Id);
contacts = ContactService.getContacts();*/
            
            /* DELETE THIS FROM HERE AND FROM PIMS AfC CONTROLLER > THINK ITS UNUSED

applicationBudgetTable = [
SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
Pro_Dev_Item__c, Other_Item__c, Id, Name
FROM Application_Budget_Table__c
WHERE Name = 'Budget Test'
];*/
            
            /*applicationBudgetList = [
SELECT IB_Application_Lookup__c, PR_12_Currency_Used__c, PR_12_budget_Line__c, PR_12_Academic_Year__c, PR_12_Amount__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c,
PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, IB_Programme__c, PR_12_Currency_Used2__c,
USD_GBP_SGD_Euro_CHF__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used3__c, Start_Year__c, Current_Year__c, Year_Picklist__c, Resource_Item__c,
Pro_Dev_Item__c, Other_Item__c, Id, Name
FROM Application_Budget_Table__c
WHERE IB_Programme__c = :programme.Id
];


contacts = [
SELECT Id, AccountId, FirstName, LastName, Name, Title, Email
FROM Contact
WHERE AccountId = :account.Id
];

attachments = [
SELECT Id, Type__c, Attachment__c, Description__c, View__c, IB_Programme__c, IB_Programme__r.Name, Publish_to_Community__c, Name
FROM IB_Application_Attachment__c
WHERE IB_Programme__c = :programme.Id
];*/
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    
    public PageReference getActiveSection(){
        
        Map<String, PageReference> tmpKey = new Map<String, PageReference>{
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
                    
                    if(activeTab == null){
                        ActiveTab = 'desc';
                    }
        
        PageReference tmp = tmpKey.get(activeTab);
        tmp.getParameters().put('id', appId);
        tmp.setredirect(true);
        
        return tmp;
    }
}