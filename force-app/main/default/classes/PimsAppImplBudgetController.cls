public class PimsAppImplBudgetController extends PimsApplicationControllerHelper {
    
    public String appId {get;set;}
    public String accId {get;set;}
    public String progId {get;set;}
    public String programmeId {get;set;}
    
    public String tab {get;set;}
    public String activeTab {get;set;}
    public String redirectUrl {get;set;}
    public String ibCompletionStatus {get;set;}
    
    public String budgetId {get;set;}
    public String editBudgetId {get;set;}
    
    public Boolean showReqBdgtMsg {get;set;}
    public String CandidateSchoolFeeStatus;
    public String AnnualSchoolFeeStatus;
    public String ProfDevelopmentStatus;
    
    public IB_Application__c application {get;set;}
    public IB_Programme__c programme {get;set;}
    
    public Account account {get;set;}
    public List<Contact> contacts {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public List<IB_Programme__c> programmes {get;set;}
    
    public Application_Budget_Table__c budget {get;set;}
    public Application_Budget_Table__c removeBudget {get;set;}
    public Application_Budget_Table__c applicationBudget {get;set;}
    public List<Application_Budget_Table__c> appBudget {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {get;set;}
    
    public Application_Budget_Table__c editBudget {get;set;}
    
    public List<IB_Role__c> rolers {get;set;}
    
    public List<Application_Budget_Table__c> buds {get;set;}
    public String[] lines {get;set;}
    public String url {get;set;}
    
    
    
    private final List<String> constantList = new List<String>{IboUtil.Ib_Agreement_Resource,IboUtil.Ib_Agreement_Fee,IboUtil.Ib_Agreement_Other,IboUtil.Ib_Agreement_Professional_Development};
        
        public String Professional_Development {
            get {
                return this.getTranslationsMap().get(IboUtil.Ib_Agreement_Professional_Development);
            }
            set;
        }
    
    public String Fee {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Agreement_Fee);
        }
        set;
    }
    
    public String Resource {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Agreement_Resource);
        }
        set;
    }
    
    public String Other {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Agreement_Other);
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
    
    
    
    
    public PimsAppImplBudgetController() {
        try
        {
            
            appId = ApexPages.currentPage().getParameters().get('id');
            tab = ApexPages.currentPage().getParameters().get('tab');
            
            if (appId == null) {
                throw new CustomValidationException('The application ID is invalid.');
            }
            
            PageService.setPage(getApplicationPageName());
            activeTab = PageService.getActiveTab();
            if (activeTab == 'budget') {
                
                if (tab == null) {
                    tab = 'budget';
                }
                
                /*PimsCommunityService pimsService = new PimsCommunityService();
pimsService.initUserData();*/
                
                ApplicationService.setApplicationId(appId);
                application = ApplicationService.getApplication();
                
                progId = application.Application_Lookup_to_Programme__r.Id;
                ProgrammeService.setProgrammeId(progId);
                programme = ProgrammeService.getProgramme();
                
                /*AccountService.setAccountId(accId);
account = AccountService.getAccount();

RoleService.setAccountId(account.Id);
roles = RoleService.getRolesByAccountId();*/
                
                /*appId = ApexPages.currentPage().getParameters().get('id');

tab = ApexPages.currentPage().getParameters().get('tab');

if (tab == null || tab == '') {
tab = 'profile';
}

if (appId == null) {
throw new CustomValidationException('The application ID is invalid.');
}

ApplicationService.setApplicationId(appId);
application = ApplicationService.getApplication();

ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
programme = ProgrammeService.getProgramme();

accId = programme.account__c;
progId = programme.Id;

ContactService.setAccountId(account.Id);
contacts = ContactService.getContacts();

RoleService.setAccountId(account.Id);
roles = RoleService.getRolesByAccountId();

System.debug('WORKS 2');*/
                
                showReqBdgtMsg = true;
                CandidateSchoolFeeStatus = 'Fail';
                AnnualSchoolFeeStatus = 'Fail';
                ProfDevelopmentStatus = 'Fail';
                applicationBudgetList = [
                    SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                    PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                    PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
                    toLabel(Fee_Item__c)
                    FROM Application_Budget_Table__c
                    WHERE IB_Programme__c = :programme.Id
                ];
                
                for (Application_Budget_Table__c abt : applicationBudgetList) {
                    if (abt.PR_12_budget_Line__c == 'Fee') {   
                        if ((abt.Fee_Item__c == 'Candidate school fee')||(abt.Fee_Item__c == 'Droits et frais de candidature')||(abt.Fee_Item__c == 'Tasa del colegio solicitante') && (abt.PR_12_Amount__c != null || abt.PR_12_Amount2__c != null)) CandidateSchoolFeeStatus = 'Pass';
                        if ((abt.Fee_Item__c == 'Annual school fee')||(abt.Fee_Item__c == 'Frais de base annuels')||(abt.Fee_Item__c == 'Tasa anual') && (abt.PR_12_Amount3__c != null || abt.PR_12_AmountIB__c != null || abt.PR_12_AmountIB2__c != null)) AnnualSchoolFeeStatus = 'Pass';
                    }
                    if (abt.PR_12_budget_Line__c == 'Professional Development')  ProfDevelopmentStatus = 'Pass';
                }
                
                if (CandidateSchoolFeeStatus == 'Pass' && AnnualSchoolFeeStatus == 'Pass' && ProfDevelopmentStatus == 'Pass') showReqBdgtMsg = false;
                
                /*contacts = [
SELECT Id, AccountId, FirstName, LastName, Name, Title, Email
FROM Contact
WHERE AccountId = :account.Id
];

rolers = [
SELECT Id, IB_Account__c, First_Name__c, Last_Name__c, RecordTypeId, IB_Role_Name__c
FROM IB_Role__c
WHERE IB_Account__c = :account.Id
];*/
                
                budget = new Application_Budget_Table__c(IB_Programme__c = programme.Id);
                removeBudget = new Application_Budget_Table__c(IB_Programme__c = programme.Id);
                
                /*
appBudget = [
SELECT Start_Year__c, Current_Year__c, IB_Programme__c, PR_12_Amount__c, PR_12_Currency_Used__c, IB_Application_Lookup__c, Name, Id, Resource_Item__c, Fee_Item__c
FROM Application_Budget_Table__c
WHERE IB_Programme__c = :programme.Id
];

// code for sorting by budget line item
buds = [
Select Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
Fee_Item__c
From Application_Budget_Table__c
Where PR_12_budget_Line__c IN ('Other', 'Resource', 'Professional Development', 'Fee' )
];
*/
                
                // lines == budget lines dynamically create set of unique lines from query
                Set<String> lineSet = new Set<String>();
                for (Application_Budget_Table__c a : applicationBudgetList) {
                    if (a.PR_12_budget_Line__c == 'Other' || a.PR_12_budget_Line__c == 'Resource' || a.PR_12_budget_Line__c == 'Professional Development' || a.PR_12_budget_Line__c == 'Fee') lineSet.add(a.PR_12_budget_Line__c);
                }
                
                // convert the set into a string array
                lines = new String[lineSet.size()];
                Integer i = 0;
                for (String line : lineSet) {
                    lines[i] = line;
                    i++;
                }
                
                url = ApexPages.currentPage().getUrl();
            }
            
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
    }
    
    public PageReference removeBudgetItem() {
        
        system.debug('In remove method, budgetId =====> '+budgetId);
        try {
            system.debug('Creating budgetToRemove object variable =====>');
            Application_Budget_Table__c budgetToRemove = new Application_Budget_Table__c();
            budgetToRemove.Id = budgetId;
            
            system.debug('About to delete budget line item =====>');
            delete budgetToRemove;
            
            system.debug('Setting page message and redirectUrl =====>');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=budget';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Removing_Budget +ex));
            return null;
        }
        return null;
    }
    
    public PageReference updateStartDate() {
        
        try {
            update application;
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Start_Date +ex));
            return null;
        }
        return null;
    }
    
    public PageReference saveBudget() {
        
        try {
            insert budget;
            
            applicationBudgetList = [
                SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c, toLabel(Fee_Item__c)
                FROM Application_Budget_Table__c
                WHERE IB_Programme__c = :programme.Id
            ];
            
            budget = new Application_Budget_Table__c(IB_Programme__c = programme.Id);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Line_Saved));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=budget';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Saving_budget +ex));
            return null;
            
        }
        return null;
    }
    
    
    public PageReference saveApp() {
        
        try {
            applicationBudgetList = [
                SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,  toLabel(Fee_Item__c)
                FROM Application_Budget_Table__c
                WHERE IB_Programme__c = :programme.Id
            ];
            
            if (showReqBdgtMsg == false) {
                ibCompletionStatus = 'Complete';
            } else {
                ibCompletionStatus = 'In Progress';
            }
            system.debug('ibCompletionStatus =====> '+ibCompletionStatus);
            
            application.AFC_Implementation_Budget_Status__c = ibCompletionStatus;
            update application;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Implementation_Budget));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=docs';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Saving +ex));
            return null;
        }
        return null;
    }
    
    
    public PageReference edit() {
        
        try {
            System.debug(editBudgetId);
            System.debug(editBudget);
            
            //update coordinatorTime;
            update editBudget;
            
            applicationBudgetList = [
                SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,  toLabel(Fee_Item__c)
                FROM Application_Budget_Table__c
                WHERE IB_Programme__c = :programme.Id
            ];
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Budget_Information));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=budget';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Error_Budget +ex));
            return null;
        }
        return null;
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
}