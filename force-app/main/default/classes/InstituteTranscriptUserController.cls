global without sharing class InstituteTranscriptUserController 
{
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
    
    public List<boolean> selectedOp{get;set;}
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
    //below line edited and a new role named : IBEC Certificate Holder is added by Prerna on 20-10-2023 for ECM00566
    public string IBECRoles ='IBEC Candidate|IBEC Faculty Member|IBEC University Administrator|IBEC Certificate Holder';
    public string associationRoles = 'Association Admin|Association User';
    public List<IB_Role__c> AdminAssigned{get;set;}
    //below line added by Suraj as a part of ECM00649
    public Set<String> allowInactiveStatus = new Set<String>{'Institute Policy User','Institute Administrator'};    
        
        public InstituteTranscriptUserController (ApexPages.StandardController stdController) {
            
            displayPopup = false;
            displayinnerPopup=true;
            
            renderTrue=false;
            accId=new Account();
            ContId=new Contact();
            accId.id = ApexPages.currentPage().getParameters().get('AccountId');
            
            
            roleId=ApexPages.currentPage().getParameters().get('roleId');
            string sError=ApexPages.currentPage().getParameters().get('errorId');
            contact_information__c conInfoJ= [SELECT id,job__c,phone__c,email__c 
                                              FROM Contact_information__c
                                              limit 1];
            jobTitle=conInfoJ.job__c;
            if(sError=='404')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' Emails do not match'));
            }
            else if(sError=='404CON')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' Phone/Email donot exist Kinldy Create phone/email by clicking + Button'));
            }
            else if(sError=='404CONN')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,' '+ system.label.My_institute_complete_all_required_fields));
                
            }
            else if(sError=='InvalidPhone')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' Please enter phone number in the format [country code] [phone number(9-15 digits only)], with no spaces or hyphens.'));
                
            }
            List<User> u=[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1];
            contId.id=u[0].contactId;
            
            if(accId.id!=Null)
            {
                accountNam=[SELECT IBIS_ID__c,id,name FROM ACCOUNT WHERE id=:accId.id];
                accountNam.Name=accountNam.Name+' - '+accountNam.IBIS_ID__c;
            }
            
            adRole= [SELECT IB_Account__c,status__c,IB_Contact__r.Name,id,name, IB_Role_name__c FROM IB_Role__c
                     WHERE IB_Account__c=:accId.id 
                     AND IB_Role_name__c='Institute Administrator' 
                     AND status__c='Confirmed' LIMIT 1];
            
            if(adRole.size()>0)
            {
                adminName=adRole[0].IB_Contact__r.Name;
            }
            conInfo=(Contact_Information__c)stdController.getRecord();
            
            
            conInfo.Email__c = apexpages.currentpage().getparameters().get('emailId');
            conInfo.Phone__c = apexpages.currentpage().getparameters().get('phoneId');
            
            conI = [SELECT id,phone__c,email__c,roleId__c 
                    FROM Contact_information__c   limit 1];
            roleId=conI.roleId__c;
            
            IB_Role_Repository__c rr=[SELECT Role_Name__c,Role_Name_es__c,Role_Name_fr__c,id 
                                      FROM IB_Role_Repository__c WHERE id=:roleId];
            
            System.debug('RoleName debug from constructor==========>'+roleName);
            roleName=rr.Role_Name__c;
            roleNameF=rr.Role_Name_fr__c;
            roleNameS=rr.Role_Name_es__c;
        }
    
    public InstituteTranscriptUserController () {
        renderTrue=false;
        contact_information__c conInfoJ= [SELECT id,job__c,phone__c,email__c 
                                          FROM Contact_information__c  limit 1];
        jobTitle=conInfoJ.job__c;
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
        
        
        conI= [SELECT id,phone__c,email__c,roleId__c
               FROM Contact_information__c   limit 1];
        roleId=conI.roleId__c;
        
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
        //below line edited by Prerna and a new role name : IBEC Certificate Holder on 20-10-2023 for ECM00566
        if(roleName == 'IBEC Candidate' || roleName == 'IBEC Faculty Member' || roleName == 'IBEC University Administrator' || roleName == 'IBEC Certificate Holder'){  
            SearchInfo_IBEC();    
        }  
        else if(roleName == 'Association Admin' || roleName == 'Association User'){
            searchInfoAssociationAccount();
        }
        else{
            SearchInfo_Inst();
        }
    }
    public  void SearchInfo_Inst() {
        boolean valid=true;
        renderTrue=true;
        System.debug('ACCNAME '+AccountName+' IBISCODE'+IBISCode+' SELECTED'+selectedCountry);
        string AccName=AccountName+'%';
        string accName2='%'+AccountName;
        string accName3='%'+AccountName+'%';
        if(AccountName!='' 
           && IBISCode!='' 
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
                                                          OR IBIS_ID__c=:IBISCode 
                                                          OR (country__c=:selectedCountry 
                                                              AND State_Abbr__c=:SelectedState 
                                                              
                                                              AND Recordtype.Name='IB Institute')) LIMIT 1000];
            System.debug(' allSearchedAccount'+ allSearchedAccount.size());
            
            
        }
        else if(AccountName!='' && IBISCode!='' && selectedCountry=='--None--')
        {
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND IBIS_ID__c=:IBISCode AND Recordtype.Name='IB Institute'];
        }
        else if(AccountName=='' && IBISCode!='' && selectedCountry!='--None--')
        {
            System.debug('IFFF2');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBIS_ID__c=:IBISCode AND (country__c=:selectedCountry AND State_Abbr__c=:SelectedState) AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName!='' && IBISCode=='' && selectedCountry!='--None--')
        {
            System.debug('IFFF3');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND ( Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry!='--None--' && SelectedState!='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry!='--None--' && SelectedState=='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND country__c=:selectedCountry AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName!='' && IBISCode=='' && selectedCountry=='--None--')
        {
            System.debug('IFFF5');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode!='' && selectedCountry=='--None--')
        {
            System.debug('IFFF6');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBIS_ID__c=:IBISCode AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry=='--None--'&& (SelectedState=='--None--' ||SelectedState==null))
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
                if(a.RecordType.Name=='IB Institute')
                {
                    wrapAccountList.add(new wrapAccount(a));
                }
                
            }
        }
    }
    public  void SearchInfo_IBEC() {
        
        boolean valid=true;
        renderTrue=true;
        System.debug('ACCNAME '+AccountName+' IBISCODE'+IBISCode+' SELECTED'+selectedCountry);
        string AccName=AccountName+'%';
        string accName2='%'+AccountName;
        string accName3='%'+AccountName+'%';
        if(AccountName!='' 
           && IBISCode!='' 
           && selectedCountry!='--None--' &&
           SelectedState!='--None--')
        {
            System.debug('IFFF1');
            allSearchedAccount=[SELECT id,
                                Recordtype.Name,IBEC_University_Flag__c,
                                Name,IBIS_ID__c,
                                Country__c,
                                State_Abbr__c 
                                FROM Account 
                                WHERE isPartner=true AND (Name 
                                                          like :AccName 
                                                          OR Name 
                                                          like :accName2 
                                                          OR Name Like : accName3 
                                                          OR IBIS_ID__c=:IBISCode 
                                                          OR (country__c=:selectedCountry 
                                                              AND State_Abbr__c=:SelectedState 
                                                              AND IBEC_University_Flag__c = true 
                                                              AND Recordtype.Name='IB Institute')) LIMIT 1000];
            System.debug(' allSearchedAccount'+ allSearchedAccount.size());
            
            
        }
        else if(AccountName!='' && IBISCode!='' && selectedCountry=='--None--')
        {
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true  AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND IBIS_ID__c=:IBISCode AND Recordtype.Name='IB Institute'];
        }
        else if(AccountName=='' && IBISCode!='' && selectedCountry!='--None--')
        {
            System.debug('IFFF2');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true  AND IBIS_ID__c=:IBISCode AND (country__c=:selectedCountry AND State_Abbr__c=:SelectedState) AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName!='' && IBISCode=='' && selectedCountry!='--None--')
        {
            System.debug('IFFF3');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true AND ( Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry!='--None--' && SelectedState!='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true AND country__c=:selectedCountry AND State_Abbr__c=:SelectedState AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry!='--None--' && SelectedState=='--None--')
        {
            System.debug('IFFF4');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true AND country__c=:selectedCountry AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName!='' && IBISCode=='' && selectedCountry=='--None--')
        {
            System.debug('IFFF5');
            allSearchedAccount=[SELECT id,Recordtype.Name,Name,IBEC_University_Flag__c,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true AND (Name like :AccName OR Name like :accName2 OR Name Like : accName3) AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode!='' && selectedCountry=='--None--')
        {
            System.debug('IFFF6');
            allSearchedAccount=[SELECT id,Recordtype.Name,IBEC_University_Flag__c,Name,IBIS_ID__c,Country__c,State_Abbr__c FROM Account WHERE isPartner=true AND IBEC_University_Flag__c = true AND IBIS_ID__c=:IBISCode AND Recordtype.Name='IB Institute' LIMIT 1000];
        }
        else if(AccountName=='' && IBISCode=='' && selectedCountry=='--None--'&& (SelectedState=='--None--' ||SelectedState==null))
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
                if(a.RecordType.Name=='IB Institute')
                {
                    wrapAccountList.add(new wrapAccount(a));
                }
                
            }
        }
    }
    public  void searchInfoAssociationAccount() {
        boolean valid=true;
        renderTrue=true;
        if(AccountName!=''){
            System.debug('IFFF1');
            allSearchedAccount=[SELECT Id,Name,
                                Recordtype.Name,
                                IBIS_ID__c,
                                Country__c,
                                State_Abbr__c 
                                FROM Account
                                WHERE isPartner=true AND ( Name like :AccountName + '%'  OR  Name like :AccountName 
                                                          OR Name like : '%' + AccountName + '%' OR Name like :'%' + AccountName )
                                AND Recordtype.Name='IB World Schools Association Account' LIMIT 1000];
            System.debug(' allSearchedAccount'+ allSearchedAccount.size());
        }
        else if(AccountName==''){
            valid=false;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING,system.label.My_institute_search_using_at_least_one_of_the_search_criteria);
            ApexPages.addMessage(msg);
        }
        wrapAccountList = new List<wrapAccount>();
        if(valid){
            check=true;
            for(Account a:allSearchedAccount){
                if(a.RecordType.Name=='IB World Schools Association Account'){
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
        System.debug('Javalog --- saveResult');
        boolean valid=false;
        integer count=0;
        selectedAccounts = new List<Account>();
        selectedInstitute = new Account();
        rolesList = new List<IB_Role__c>();
        
        
        
        if(wrapAccountList!=Null)
        {
            for(wrapAccount wrapAccountObj : wrapAccountList) {
                
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
        
        System.debug('Javalog --- valid '+valid); 
        //Following code is updated for US-12338 on 07/29/2021
        roleId=ApexPages.currentPage().getParameters().get('roleId');
        
        //added by Atticus for ECM00565 added on 26-12-2022  [start]
        
        if(!selectedAccounts.isEmpty()){
            List<IB_Role__c> existingIRolesForSelectedAccount=[SELECT Id,Name,IB_Account__c FROM IB_Role__c 
                                                               WHERE IB_Account__c= :selectedAccounts[0].Id AND IB_Role__r.Id =:roleId AND
                                                               IB_Role__r.Available__c = true AND 
                                                               IB_Role_Name__c = 'Institute Policy User' AND Status__c='Confirmed'];
            if(!existingIRolesForSelectedAccount.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Confirmed_Policy_User_Role_Exists));
                return null;
            }
        }
        //ECM00565 [end]
        
        
        IB_Role_Repository__c adminRole = [SELECT id, Role_Name__c FROM IB_Role_Repository__c WHERE id=:roleId LIMIT 1];
        AdminAssigned = new List<IB_Role__c>();
        //Condtions and query updated for ECM226(IBEC Roles) as part of Staff-Aug Project
        if(valid == true && ( adminRole.Role_Name__c == 'Institute Transcript User' ||  adminRole.Role_Name__c == 'Communication User' 
                             || adminRole.Role_Name__c == 'Institute Policy User')){ /** For ECM00565 Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
                                 AdminAssigned = [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, Active__c, 
                                                  IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c 
                                                  Where IB_Account__c =:selectedAccounts[0].Id and Status__c = 'Confirmed' and IB_Role_Name__c = 'Institute Administrator' Limit 1];
                             }
        //below line edited and new role: IBEC Certificate Holder added by Prerna on 25-10-2023 for ECM00566
        if(valid == true && ( adminRole.Role_Name__c == 'IBEC Faculty Member'|| adminRole.Role_Name__c == 'IBEC Candidate' || adminRole.Role_Name__c == 'IBEC Certificate Holder')){
            AdminAssigned = [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, Active__c, 
                             IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c 
                             Where IB_Account__c =:selectedAccounts[0].Id and Status__c = 'Confirmed' and IB_Role_Name__c = 'IBEC University Administrator' Limit 1];
        }
        if(valid == true && ( adminRole.Role_Name__c == 'Association User')){
            AdminAssigned = [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, Active__c, 
                             IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c 
                             Where IB_Account__c =:selectedAccounts[0].Id and Status__c = 'Confirmed' and IB_Role_Name__c = 'Association Admin' Limit 1];
        }
        
        /*  else if (valid == true && AdminAssigned[0].IB_Role_Name__c == NULL && ( adminRole.Role_Name__c == 'IBEC Faculty Member'|| adminRole.Role_Name__c == 'IBEC Candidate'))
{ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error, system.label.IBEC_University_Admin_Not_Exist_for_Institute);
ApexPages.addMessage(msg);}*/
        
        //below line edited and a new role : IBEC Certificate Holde added by Prerna on 25-10-2023 for ECM00566
        if(valid== true && ((AdminAssigned.size() > 0 &&  AdminAssigned[0].IB_Role_Name__c != NULL && 
                             (adminRole.Role_Name__c == 'Institute Transcript User'|| adminRole.Role_Name__c == 'Institute Policy User' || adminRole.Role_Name__c == 'Communication User' || adminRole.Role_Name__c == 'IBEC Faculty Member'|| adminRole.Role_Name__c == 'IBEC Candidate' || adminRole.Role_Name__c == 'IBEC Certificate Holder')) 
                            || adminRole.Role_Name__c == 'Institute Administrator' || adminRole.Role_Name__c == 'IBEC University Administrator'
                            || adminRole.Role_Name__c == 'Association User' || adminRole.Role_Name__c == 'Association Admin' )) // /** For ECM00565 Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
        {
            try{
                
                conI= [SELECT id, roleId__c, Country_Code__c, Phone_Number__c, phone__c, email__c, job__c FROM Contact_information__c limit 1];
                roleId=conI.roleId__c;
                
                conI.job__c=Null;
                update conI;         
                selectedInstitute = [Select Id, Active__c from Account where Id =: selectedAccounts[0].id];
                
                Id contactId = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].ContactId;
                Id appRoleId = ApexPages.currentPage().getParameters().get('roleId');
                
                rolesList = [Select Id,IB_Account__c, IB_Role__c, Status__c from IB_Role__C where IB_Contact__c =: contactId 
                             AND IB_Account__c =: selectedInstitute.Id AND IB_Role__c =: appRoleId AND (Status__c ='Applicant' OR Status__c = 'Confirmed' ) ];
                
                System.debug('rolesList size : ' + rolesList.size());
                
                //changed below if condition as a part of ECM00649 by Suraj
                if(IBECRoles.contains(adminRole.Role_Name__c) || associationRoles.contains(adminRole.Role_Name__c)  ||  (selectedInstitute.Active__c != null && selectedInstitute.Active__c != ''&& selectedInstitute.Active__c != 'Inactive' ) || allowInactiveStatus.contains(adminRole.Role_Name__c))
                {
                    if(rolesList.size() > 0) 
                    {
                        if(!associationRoles.contains(adminRole.Role_Name__c))
                        {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, system.label.Duplicate_RoleApp_Error);
                            ApexPages.addMessage(msg);
                        }
                        if(associationRoles.contains(adminRole.Role_Name__c))
                        {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, system.label.Duplicate_RoleApp_Error2);
                            ApexPages.addMessage(msg);
                        }
                        
                        return null;
                    }
                    else
                    {
                        String Pagename;
                        List<IB_Role__c> AdminAssigned1 = new List<IB_Role__c>();
                        User CurrentContact = [SELECT contactId from User WHERE Id =:UserInfo.getUserId()];
                        AdminAssigned1 = [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, Active__c, 
                                          IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c FROM IB_Role__c 
                                          Where IB_Account__c =:selectedAccounts[0].Id and IB_Contact__c =:CurrentContact.contactId and Status__c = 'Confirmed' and IB_Role_Name__c = 'IBEC Candidate' Limit 1];
                        
                        //below line edited and added IBEC Certificate Holder condition by prerna on 06-11-2023 for bug(204116) raised in ECM00566
                        if(AdminAssigned1.size()>0 && adminRole.Role_Name__c != 'IBEC Certificate Holder')
                        {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, System.label.IBEN_RoleApplication_Already_Confirmed_IBECCandidate_Error);
                            ApexPages.addMessage(msg);  
                        }
                        //below line edited by prerna on 20-10-2023 for ECM00566
                        else if(valid==true && ((adminRole.Role_Name__c == 'IBEC Faculty Member' && AdminAssigned1.size() == 0) || (adminRole.Role_Name__c == 'IBEC Candidate') || (adminRole.Role_Name__c == 'IBEC Certificate Holder') || (adminRole.Role_Name__c == 'IBEC University Administrator' && AdminAssigned1.size() == 0))) 
                        {
                            Pagename = '/apex/IBECApplyForRole'; 
                        }      
                        else if (valid == true && (adminRole.Role_Name__c == 'Institute Transcript User' || adminRole.Role_Name__c == 'Communication User' || adminRole.Role_Name__c == 'Institute Administrator' || adminRole.Role_Name__c == 'Association User' || 
                                                   adminRole.Role_Name__c == 'Association Admin' || adminRole.Role_Name__c == 'Institute Policy User'))///** For ECM00565 Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
                        {
                            Pagename = '/apex/InstituteApplyForRole'; 
                        }
                        pageReference pg=new PageReference(Pagename);
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
            catch (Exception e){
                System.debug('---> Exception: ' + e);
                
                return null;
                
            }
        }
        
        else if(valid == true)
        {
            //this code is edited for ecm 324
            //start
            if(adminRole.Role_Name__c == 'Institute Transcript User' || adminRole.Role_Name__c == 'Institute Policy User')/** For ECM00565 Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error , ' ' + system.label.Confirmed_Institute_Admin_Not_Exist);
                ApexPages.addMessage(msg);
            }
            if(adminRole.Role_Name__c == 'IBEC Faculty Member'|| adminRole.Role_Name__c == 'IBEC Candidate') {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error , ' ' + system.label.IBEN_RoleApplication_IBEC_Admin_does_not_exist);
                ApexPages.addMessage(msg);
            }
            if(adminRole.Role_Name__c == 'Communication User')
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error , ' ' + system.label.Confirmed_Institute_Admin_Not_Exist_Community_User);
                ApexPages.addMessage(msg);
            }
            if(adminRole.Role_Name__c == 'Association User')
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error , ' ' + system.label.Confirmed_Institute_Admin_Not_Exist_Community_User);
                ApexPages.addMessage(msg);
            }
        }
        else {
            if(adminRole.Role_Name__c == 'Association User' || adminRole.Role_Name__c == 'Association Admin'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING, system.label.AIBWS_select_only_one_Institute);
                ApexPages.addMessage(msg);
            }
            else {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.WARNING, system.label.My_institute_select_only_one_Institute);
                ApexPages.addMessage(msg);
            }
        }
        return null;
    }
    
    //END   
    
    
    
    @RemoteAction
    global static List<String> lookupSchoolAccountByNameMulti(String searchTerm, id roleId) {
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            string accName = searchTerm.split(':')[0];
            string ibis = searchTerm.split(':')[1];
            List<Account> accountList = new List<Account>();
            
            IB_Role_Repository__c roleSel = [Select Id, Role_Name__c FROM IB_Role_Repository__c WHERE Id = :roleId LIMIT 1];
            system.debug('Role_Name ' + roleSel.Role_Name__c);
            if(roleSel.Role_Name__c == 'Association Admin' || roleSel.Role_Name__c == 'Association User'){
                system.debug('Association_Roles');
                accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE isPartner=true And RecordTypeId = \'' + Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('IB_World_Schools_Association_Account').getRecordTypeId() + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\'');  
            }
            else if(roleSel.Role_Name__c == 'IBEC Candidate' || roleSel.Role_Name__c == 'IBEC Faculty Member' || roleSel.Role_Name__c == 'IBEC University Administrator')
            {
                system.debug('IBEC__Multi');
                //   RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'IB Institute'];
                accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE IBEC_University_Flag__c = true AND isPartner=true And RecordTypeId = \'' + Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('IB_Institute').getRecordTypeId() + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\''); 
            }
            else
            {
                system.debug('Not_IBEC__Multi');
                accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE isPartner=true And RecordTypeId = \'' + Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('IB_Institute').getRecordTypeId() + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\''); 
                
            }
            List<String> accounts = new List<String>();
            for (Account x : accountList) {
                if(x.Recordtype.name=='IB Institute'|| x.RecordType.Name=='IB World Schools Association Account')
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
    global static List<string> lookupInstituteSearchName(String searchTerm, id roleId) {
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            //This part is updated by Arbaz-Plumlogix related to Sprint-22-1 ECM-00226 on 12/20/2021
            //Begin
            IB_Role_Repository__c roleSel = [Select Id, Role_Name__c FROM IB_Role_Repository__c WHERE Id = :roleId LIMIT 1];
            system.debug('Role_Name ' + roleSel.Role_Name__c);
            List<Account> conIn = new List<Account>();
            //This part is updated by Plumlogix related to Sprint-22-6 ECM-00336 on 26/04/2022
            if(roleSel.Role_Name__c == 'Association Admin' || roleSel.Role_Name__c == 'Association User'){
                system.debug('Association_Roles');
                conIn = Database.query('SELECT Id, Name, IBIS_ID__c,Recordtype.Name FROM Account WHERE isPartner=true And Recordtype.Name = \'IB World Schools Association Account\' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');  
            }
            //below line editied and a new role named 'IBEC Certificate Holder' added by Prerna on 25-10-2023 for ECM00566
            else if(roleSel.Role_Name__c == 'IBEC Candidate' || roleSel.Role_Name__c == 'IBEC Certificate Holder'|| roleSel.Role_Name__c == 'IBEC Faculty Member' || roleSel.Role_Name__c == 'IBEC University Administrator')
            {
                conIn =  Database.query('SELECT Id,Name,Recordtype.Name FROM Account WHERE IBEC_University_Flag__c = true AND isPartner = true AND Recordtype.Name = \'IB Institute\' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
            }
            else
            {
                
                conIn =  Database.query('SELECT Id,Name,Recordtype.Name,IBEC_University_Flag__c FROM Account WHERE isPartner = true AND Recordtype.Name = \'IB Institute\' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
                
            }
            //END
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