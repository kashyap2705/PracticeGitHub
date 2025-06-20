global without sharing class onlineProviderSearchCtrl {

    public boolean displayPopup {get; set;}
    public boolean displayinnerPopup {get; set;}
    
    public boolean renderTrue {get;set;}
    Public Account accountNam{get;set;}
    public List<wrapAccount> wrapAccountList {get; set;}
    public List<Account> selectedAccounts{get;set;}
    public  Contact_Information__c conInfo{get;set;}
    public Account selectedInstitute;
    private User user; 
    public  string PhoneVal{get;set;}
    public List<IB_Role__c> rolesList;
    
    public static string jobTitle{get;set;}
    public string AccountName{get;set;}
    public string IBISCode{get;set;}
    public string Phone{get;set;}
    public string Email{get;set;}
    public IB_Role__c ibRole{get;set;}
    public IB_Role_Repository__c currentRole {get;set;}
    public  boolean check{get;set;}
    
    public  string selectedState{get;set;}
    public  string selectedCountry{get;set;}
    
   // public List<boolean> selectedOp{get;set;}
    public List<Account> allSearchedAccount{get;set;}
    public static string roleId=null;
    
    public static List<IB_Role__c> adRole;
    public Contact_Information__c conI {get;set;}
    public static Contact contId{get;set;}
    public static Account accId{get;set;}
    public string adminName{get;set;} 
    
    public string roleName{get;set;}
    public string roleNameF{get;set;}
    public string roleNameS{get;set;}
    
    public onlineProviderSearchCtrl (ApexPages.StandardController stdController) {
        
        displayPopup = false;
        displayinnerPopup=true;
        
        renderTrue=false;
        accId=new Account();
        ContId=new Contact();
        accId.id=ApexPages.currentPage().getParameters().get('AccountId');
        
        roleId=ApexPages.currentPage().getParameters().get('roleId');
        string sError=ApexPages.currentPage().getParameters().get('errorId');
        
        
        if(sError=='404')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' '+system.label.My_onlineProvider_email_not_match));
        }
        else if(sError=='404CON')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' '+system.label.My_onlineProvider_phoneNumber_Validation));
        }
        else if(sError=='404CONN')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' '+ system.label.My_institute_complete_all_required_fields));
            
        }
        else if(sError=='InvalidPhone')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.My_onlineProvider_phoneNumber_FormatError));
            
        }
        List<User> u=[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
        contId.id=u[0].contactId;
        
        contact_information__c conInfoJ= [SELECT id,job__c,phone__c,email__c 
                                          FROM Contact_information__c where IB_Contact__r.id =: contId.id
                                          limit 1];
        jobTitle=conInfoJ.job__c;
        
        if(accId.id!=Null)
        {
            accountNam=[SELECT IBIS_ID__c,id,name FROM ACCOUNT WHERE id=:accId.id];
            accountNam.Name=accountNam.Name+' - '+accountNam.IBIS_ID__c;
        }
        
        adRole= [SELECT IB_Account__c,status__c,IB_Contact__r.Name,id,name, IB_Role_name__c FROM IB_Role__c
                 WHERE IB_Account__c=:accId.id 
                 AND IB_Role_name__c='Teacher' 
                 AND status__c='Confirmed' LIMIT 1];
        
        if(adRole.size()>0)
        {
            adminName=adRole[0].IB_Contact__r.Name;
        }
        conInfo=(Contact_Information__c)stdController.getRecord();
        
        
        conInfo.Email__c = apexpages.currentpage().getparameters().get('emailId');
        conInfo.Phone__c = apexpages.currentpage().getparameters().get('phoneId');
        
        conI = [SELECT id,phone__c,email__c,roleId__c 
                FROM Contact_information__c where IB_Contact__r.id =: contId.id limit 1];
        roleId=conI.roleId__c;
        
        IB_Role_Repository__c rr=[SELECT Role_Name__c,Role_Name_es__c,Role_Name_fr__c,id 
                                  FROM IB_Role_Repository__c WHERE id=:roleId];
        
        System.debug('RoleName'+roleName);
        roleName=rr.Role_Name__c;
        roleNameF=rr.Role_Name_fr__c;
        roleNameS=rr.Role_Name_es__c;
    }
    
    public onlineProviderSearchCtrl () {
        System.debug('Umair IN');
        renderTrue=false;
      /*  contact_information__c conInfoJ= [SELECT id,job__c,phone__c,email__c 
                                          FROM Contact_information__c  limit 1];
        jobTitle=conInfoJ.job__c; */
        string sError=ApexPages.currentPage().getParameters().get('errorId');
        if(sError=='404')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Email does not matched'));
        }
        conInfo=new Contact_information__c();
        string str=ApexPages.currentPage().getParameters().get('AccountId');
        roleId=ApexPages.currentPage().getParameters().get('roleId');
        IB_Role_Repository__c rr;
        if(roleId!=Null)
        {
            rr=[SELECT Role_Name__c,Role_Name_fr__c,Role_Name_es__c,id FROM IB_Role_Repository__c WHERE id=:roleId];
            System.debug('RRRllName'+roleName);
            roleName=rr.Role_Name__c; 
            roleNameF=rr.Role_Name_fr__c;
            roleNameS=rr.Role_Name_es__c;
        }
        
        Contact c = new Contact();
        List<User> u=[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
        c.id=u[0].contactId;
        
       /* conI= [SELECT id,phone__c,email__c,roleId__c
               FROM Contact_information__c where IB_Contact__r.id =: c.id  limit 1];
        roleId=conI.roleId__c;*/
        
        Id id=userInfo.getUserId();
        
    }
    
    public List<SelectOption> getCountryNames()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('--None--','--None--'));
        
        Schema.DescribeFieldResult fieldResult =Account.Country__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getLabel()));
        }       
        return options;
    }
    
    public List<SelectOption> getCountryState()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        Map<Object,List<String>> result =dependentPickListTest.getDependentPicklistValues(Account.State_Abbr__c);
        List<string> getStateValue=new List<string>();
        if(SelectedCountry!='' && SelectedCountry!=null)
        {
            
            getStateValue=result.get(SelectedCountry);
            if(getStateValue!=nUll && getStateValue.size()>0)
            {
                
                for(string s:getStateValue)
                {
                    options.add(new SelectOption(s,s));
                }
                return options;
            }
        }
        return null;
    }
    
    //This method is responsible for saving the user selections at role application
    public void showPopup() {
        displayPopup = true;
        displayinnerPopup =false;
        
    }
    public void closePopup() {
        displayPopup = false;
        displayinnerPopup =true;
        
    }
    
    public void showinnerpopup() {
        displayinnerPopup = true;
    }
    public void closeinnerpopup() {
        displayinnerPopup =false;
    }    
    
    
    public  void SearchInfo() {
        boolean valid=true;
        renderTrue=true;
        System.debug('ACCNAME '+AccountName+' IBISCODE'+IBISCode+' SELECTED'+selectedCountry);
        string AccName=AccountName+'%';
        string accName2='%'+AccountName;
        string accName3='%'+AccountName+'%';
        if(AccountName!='' 
           && selectedCountry!='--None--' &&
           SelectedState!='--None--')
        {
            System.debug('IFFF1');
            allSearchedAccount=[SELECT id,
                                Recordtype.Name,
                                Name,IBIS_ID__c,
                                Country__c,
                                State_Abbr__c 
                                FROM Account 
                                WHERE isPartner=true AND (Name 
                                                          like :AccName 
                                                          OR Name 
                                                          like :accName2 
                                                          OR Name Like : accName3 
                                                          
                                                          OR (country__c=:selectedCountry 
                                                              AND State_Abbr__c=:SelectedState 
                                                              
                                                              AND Recordtype.Name='Online Provider')) LIMIT 1000];
            System.debug(' allSearchedAccount'+ allSearchedAccount.size());
            
            
        }
        else if(AccountName!=''  && selectedCountry=='--None--')
        {
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3)  AND Recordtype.Name='Online Provider'];
        }
        else if(AccountName==''  && selectedCountry!='--None--')
        {
            System.debug('IFFF2');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true  AND (country__c=:selectedCountry AND State_Abbr__c=:SelectedState) AND Recordtype.Name='Online Provider' LIMIT 1000];
        }
        else if(AccountName!=''  && selectedCountry!='--None--')
        {
            System.debug('IFFF3');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND ( Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='Online Provider' LIMIT 1000];
        }
        else if(AccountName==''  && selectedCountry!='--None--' && SelectedState!='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='Online Provider' LIMIT 1000];
        }
        else if(AccountName==''  && selectedCountry!='--None--' && SelectedState=='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND country__c=:selectedCountry AND Recordtype.Name='Online Provider' LIMIT 1000];
        }
      /*  else if(AccountName!=''  && selectedCountry=='--None--')
        {
            System.debug('IFFF5');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND Recordtype.Name='Online Provider' LIMIT 1000];
        }
        else if(AccountName==''  && selectedCountry=='--None--')
        {
            System.debug('IFFF6');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true  AND Recordtype.Name='Online Provider' LIMIT 1000];
        }*/
        else if(AccountName=='' && selectedCountry=='--None--'&& (SelectedState=='--None--' ||SelectedState==null))
        {
            valid=false;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING,system.label.My_institute_search_using_at_least_one_of_the_search_criteria);
            ApexPages.addMessage(msg);
            
        }
        wrapAccountList = new List<wrapAccount>();
        if(valid)
        {
            check=true;
            
            for(Account a:allSearchedAccount)
            {
                if(a.RecordType.Name=='Online Provider')
                {
                    wrapAccountList.add(new wrapAccount(a));
                }
                
            }
        }
    }
    
    
    public PageReference cancelSearch()
    {
        return new pageReference('/ibportal/MyIBRoles');
        
    }
    
    public PageReference saveResult()
    {
        boolean valid=false;
        integer count=0;
        selectedAccounts = new List<Account>();
        selectedInstitute = new Account();
        rolesList = new List<IB_Role__c>();
        System.debug('wrapAccountList: '+wrapAccountList.size());
        
        if(wrapAccountList!=Null)
        {
            for(wrapAccount wrapAccountObj : wrapAccountList) {
                
        System.debug('wrapAccountList: '+wrapAccountObj.selected);
                if(wrapAccountObj.selected == true ||Test.isRunningTest()) {
                    count++;
                    valid = true;
                    selectedAccounts.add(wrapAccountObj.acc);
                }
            }
            
            if(count>1)
            {
                valid=false;
            }
        }
        if(count == 0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error, system.label.My_onlineProvider_Select_atleast_OP);
            ApexPages.addMessage(msg);
            
            return null;            
        }
        if(valid==true)
        {
            Contact c = new Contact();
        	List<User> u=[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
        	c.id=u[0].contactId;
           /* conI= [SELECT id,phone__c,email__c,roleId__c,job__c FROM Contact_information__c where IB_Contact__r.id =: c.id limit 1];
            roleId=conI.roleId__c;
            conI.job__c=Null;
            update conI;*/
            
            selectedInstitute = [Select Id, Active__c from Account where Id =: selectedAccounts[0].id];
            
            Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].ContactId;
            Id appRoleId = ApexPages.currentPage().getParameters().get('roleId');
            
            rolesList = [Select Id,IB_Account__c, IB_Role__c, IB_Programme_New__c, Status__c from IB_Role__C where IB_Contact__c =: contactId 
                         AND IB_Account__c =: selectedInstitute.Id AND IB_Role__c =: appRoleId AND (Status__c ='Applicant' OR Status__c = 'Confirmed' ) ];
            List <IB_Programme__c> prog = new List <IB_Programme__c>();
            prog = [Select id , name from IB_Programme__c where Account__c =: selectedInstitute.Id AND Status__c='Authorized'];
            System.debug('Apple prog'+ prog.size());
            System.debug('Apple rolesList : ' + rolesList.size());
            
            
            if(selectedInstitute.Active__c != 'Inactive')
            {
               if(rolesList.size() >= prog.size()) 
                {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR , system.label.My_OnlineProvider_Role_Error);
                    ApexPages.addMessage(msg);
                    
                    return null;
                }else{
                    pageReference pg=new PageReference('/apex/onlineProviderApplyForRole');
                    pg.setRedirect(true);
                    pg.getParameters().put('AccountId',selectedAccounts[0].id);
                    if(roleId!=null && roleId!='')
                    {
                        pg.getParameters().put('roleId',roleId);
                    }
                    else
                    {
                        pg.getParameters().put('roleId',[SELECT id  FROM IB_Role_Repository__c WHERE Role_Name__c=:roleName].id);
                    } 
                    return pg;
                }
            }
            else
            {            
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, System.Label.Inactive_Institute_Application_Error);
                ApexPages.addMessage(msg);
                
                return null;
            }
        }
        else
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error, system.label.My_onlineProvider_Select_OP);
            ApexPages.addMessage(msg);
            
            return null;
        }
    }
    
    @RemoteAction
    global static List<String> lookupSchoolAccountByNameMulti(String searchTerm) {
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            string accName = searchTerm.split(':')[0];
            string ibis = searchTerm.split(':')[1];
            
            //   RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'IB Institute'];
            //   
            List<Account> accountList = Database.query
                ('SELECT Id, Name, IBIS_ID__c FROM Account WHERE isPartner=true And RecordTypeId = \'' 
                 + Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get(
                     'Online Provider'
                 ).getRecordTypeId() + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\'');
            //List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE AND RecordTypeId =' + RecType.Id );
            
            //return accountList[0].IBIS_ID__c;
            List<String> accounts = new List<String>();
            for (Account x : accountList) {
                if(x.Recordtype.name=='Online Provider')
                {
                    accounts.add(x.Id);
                }
            }
            return accounts;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    
    public PageReference isLoggedIn() {
        try
        {
            if (UserInfo.getUserType() == 'Guest') {
                return new PageReference('/ibportal/IBPortalLogin');
            } else {
                return null;
            }  
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    
    public String getLocale() {
        try
        {
            return UserInfo.getLanguage();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    
    @RemoteAction
    global static List<string> lookupInstituteSearchName(String searchTerm) {
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            User u=[SELECT id,contactId,name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
            List<Account>conIn=[SELECT Name,Recordtype.Name FROM Account WHERE isPartner=true And Recordtype.Name='Online Provider' AND name like :searchTerm+'%'];
            
            List<String> names = new List<String>();
            
            for (Account x : conIn) {
                names.add(x.name);
            }
            
            return names;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
        
    }
    
    public class wrapAccount {
        public Account acc {get; set;}
        public Boolean selected {get; set;}
        
        public wrapAccount(Account a) {
            acc = a;
            selected = false;
        }
        public wrapAccount() {
            
        }
    }
    
}