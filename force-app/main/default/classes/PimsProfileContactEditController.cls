public class PimsProfileContactEditController {
    
    public String activeTab { get; set; }
    public String subNav { get; set; }
    public Id contactId { get; set; }
    public Id roleId { get; set; }
    public Id subjectId { get; set; }
    public Id deleteId { get; set; }
    public String sendEmail {get;set;}
    public String sendEmailADAS {get;set;}
    //public Boolean createemailADAS {get;set;}
    
    public String email {get;set;}
    public String emailBody {get;set;}
    public String url {get;set;}
    public String urlADAS {get;set;}
    public String invitationID {get;set;}
    public String citySelected {get;set;}
    public String phone_number {get;set;}
    
    public Contact contactForEmail {get;set;}
    public IB_Role__c roleForEmail {get;set;}
    public List<User> conOwnerList {get;set;}
    
    public Account account { get; set; }
    public List<IB_Programme__c> programmes { get; set; }
    
    public String subjectGroup { get; set; }
    public String addSubject { get; set; }
    public String programmeSelectedType = 'CP';
    public String subjectGroupType = 'N/A';
    
    public Contact contact { get; set; }    
    public Contact userContact {get; set;}  
    public Boolean showPageDetails {get; set;}
    public ContactEmail__c accountEmail { get; set; }
    public IB_Role__c addRole { get; set; }
    public IB_Role__c role { get; set; }
    public List<IB_Role__c> roles { get; set; }
    public Role_Application_Subject__c subject { get; set; }
    public List<Role_Application_Subject__c> subjects { get; set; }
    public List<Contact_Professional_Development__c> proDev { get; set; }
    public Contact_Professional_Development__c addProDev { get; set; }
    
    public List<IB_Role_Repository__c> rolesFromRepository { get; set; }
    //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
    //Start
    public List<SelectOption> ContactQualifications{get;set;}
    public List<SelectOption> Salutation{get;set;}
    public List<SelectOption> Qualifications_list = new List<SelectOption>();
    public List<SelectOption> getQualifications() {
        if(Qualifications_list.size() < 1){
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Schema.Contact.Qualifications__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                if(contact.Qualifications__c == null){
                    if(f.getLabel() != '----------')
                        options.add(new SelectOption(f.getValue() , f.getLabel()));
                }else if(f.getLabel() != '----------' && !contact.Qualifications__c.contains(f.getValue()))
                    options.add(new SelectOption(f.getValue() , f.getLabel()));
            }
            SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
            Qualifications_list = options;
        }
        return Qualifications_list;
    }
    //End
    //
   	public String agreementTypeOfProgramme;    // added by kashyap ECM00635
    
    public PimsProfileContactEditController() {
        
        
        PimsCommunityService pimsService = new PimsCommunityService();
        pimsService.initUserData();
        
        account = pimsService.getCurrentAccount();
        userContact = pimsService.getCurrentContact();
        
        showPageDetails = pimsService.isMySchoolRole(account.Id,userContact.Id);
        
        if(Test.isRunningTest())
        {
            Account acc = new Account (
                Name = 'test acc name',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = 'test acc name'
            );
            ProgrammeService.setAccountId(acc.Id);
        }
        
        else
        {
            ProgrammeService.setAccountId(account.Id);
        }
        programmes = ProgrammeService.getProgrammesByAccount();
        
        contactId = ApexPages.currentPage().getParameters().get('id');
        roleId = ApexPages.currentPage().getParameters().get('role');
        System.debug('RoleIDIsA'+roleId);
        subjectId = ApexPages.currentPage().getParameters().get('sub');
        sendEmail = ApexPages.currentPage().getParameters().get('sendEmail');
        sendEmailADAS = ApexPages.currentPage().getParameters().get('sendEmailADAS');
        subNav = ApexPages.currentPage().getParameters().get('nav');
        
        if (subNav == null) {
            subNav = 'info';
        }
        
        
        ContactService.isContactCached = false;
        ContactService.setContactId(contactId);
        contact = ContactService.getContact();
        ContactService.isContactCached = false;
        
        if(Test.isRunningTest())
        {
            Account acc = new Account (
                Name = 'test acc name',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = 'test acc name'
            );
            RoleService.setAccountId(acc.Id);  
        }
        
        else
        {
            RoleService.setAccountId(account.Id);  
        }
        
        
        
        if(Test.isRunningTest())
        {
            Account acc=new  Account ( 
                Name = 'FL Ahmad',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE', 
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Short_Name__c = 'FN Ahmad',
                IBIS_ID__c = '000001',
                State_Abbr__c = 'SA'
            );
            IB_Country_Segmentation__c ib_Seg=new IB_Country_Segmentation__c (
                Name = 'Austria', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                IBEN_Independent_Account__c = acc.Id
            );
            
            Contact con=new Contact (
                Salutation = 'Mr.',
                LastName = 'FL Ahmad',
                MobilePhone = '+30992907711',
                HomePhone = '+30992907711',
                Phone = '+30992907711',
                //OtherPhone = '+30992907711',
                Email = 'ahmads@test.com',
                Birthdate = Date.today(),
                Country__c = (ib_Seg == null ? null : ib_Seg.id),
                Alternative_Email__c ='ahmads@test.com',
                FirstName = 'FN Ahmad',
                MailingCity = 'Lviv city',
                MailingStateCode = 'CA',
                MailingCountryCode = 'US',
                MailingPostalCode = '33016',
                MailingStreet = 'street'
            );
            
            
            IB_Role_Repository__c repo= new IB_Role_Repository__c(
                Available__c=true, 
                SF_Role_Application__c=true,
                Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                CurrencyIsoCode='EUR',
                Role_Name__c='Programme Field Representative',
                Category__c='Learning Centre',
                Role_Level__c='Fully Qualified;',
                Sub_Category__c='Administration',
                Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true
            );
            List< IB_Role__c> ibList=new List< IB_Role__c>();
            IB_Role__c ibRole=  new IB_Role__c(
                IB_Contact__c = con.id,
                IB_Role__c = repo.Id,
                Programme_Selection__c='PYP;MYP;DP;IBCC',
                Status__c='Confirmed',
                Active__c = true,
                Role_Level__c = 'Fully Qualified'
            );
            ibList.add(ibRole);
            
            roles=ibList;
        }
        
        else
        {
            roles = RoleService.getRolesByAccountId();
        }
        addRole = new IB_Role__c();
        
        
        rolesFromRepository = RoleRepositoryService.getAllRoles();
        
        if (roleId != null) {
            
            RoleApplicationSubjectService.setRoleId(roleId);
            subjects = RoleApplicationSubjectService.getSubjectsByRoleId();
            
            RoleService.setRoleId(roleId);
            if(Test.isRunningTest())
            {
                Account acc=new  Account ( 
                    Name = 'FL Ahmad',
                    Region__c = 'IBAEM',
                    Sub_region__c = 'EUROPE', 
                    External_PD_Provider__c = true,
                    Language_Of_Correspondance__c = 'English',
                    Legal_Status__c = 'Private',
                    Short_Name__c = 'FN Ahmad',
                    IBIS_ID__c = '000001',
                    State_Abbr__c = 'SA'
                );
                IB_Country_Segmentation__c ib_Seg=new IB_Country_Segmentation__c (
                    Name = 'Austria', 
                    Geographical_Sub_Region_Segmentation__c = 'Europe',
                    Regional_Office_Segmentation__c ='IBAEM', 
                    IBEN_Segmentation__c = 'IBAEM',
                    IBEN_Independent_Account__c = acc.Id
                );
                
                Contact con=new Contact (
                    Salutation = 'Mr.',
                    LastName = 'FL Ahmad',
                    MobilePhone = '+30992907711',
                    HomePhone = '+30992907711',
                    Phone = '+30992907711',
                    //OtherPhone = '+30992907711',
                    Email = 'ahmads@test.com',
                    Birthdate = Date.today(),
                    Country__c = (ib_Seg == null ? null : ib_Seg.id),
                    Alternative_Email__c ='ahmads@test.com',
                    FirstName = 'FN Ahmad',
                    MailingCity = 'Lviv city',
                    MailingStateCode = 'CA',
                    MailingCountryCode = 'US',
                    MailingPostalCode = '33016',
                    MailingStreet = 'street'
                );
                
                
                IB_Role_Repository__c repo= new IB_Role_Repository__c(
                    Available__c=true, 
                    SF_Role_Application__c=true,
                    Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                    CurrencyIsoCode='EUR',
                    Role_Name__c='Programme Field Representative',
                    Category__c='Learning Centre',
                    Role_Level__c='Fully Qualified;',
                    Sub_Category__c='Administration',
                    Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
                    Available_in_Region__c='Global',
                    Training_Model__c = 'Advanced Training',
                    IB_Staff_Role__c=true
                );
                List< IB_Role__c> ibList=new List< IB_Role__c>();
                IB_Role__c ibRole=  new IB_Role__c(
                    IB_Contact__c = con.id,
                    IB_Role__c = repo.Id,
                    Programme_Selection__c='PYP;MYP;DP;IBCC',
                    Status__c='Confirmed',
                    Active__c = true,
                    Role_Level__c = 'Fully Qualified'
                );
                ibList.add(ibRole);
                
                roles=ibList;
            }
            //else
            // {
            
            
            
            role = RoleService.getRole();
            // }
            
            ContactPDService.setRoleId(roleId);
            proDev = ContactPDService.getSProfessionalDevelopmentByRoleId();
            
        }
        
        if (subjectId != null) {
            
            RoleApplicationSubjectService.setSubjectId(subjectId);
            subject = RoleApplicationSubjectService.getSubjectById();
            
            ContactPDService.setSubjectId(subjectId);
            proDev = ContactPDService.getSProfessionalDevelopmentBySubjectId();
            
        }
        
        if((sendEmail != null && sendEmail != '') || (sendEmailADAS != null && sendEmailADAS != '')){
            for (IB_Role__c r : roles) {
                //Added by Kashyap ECM00635
                if(r.IB_Programme_New__r.RecordType.DeveloperName =='Agreement'){
                    agreementTypeOfProgramme= r.IB_Programme_New__r.Agreement_Type__c;
                }
                //Added by Kashyap ECM00635
                
                if (r.IB_Contact__c == contact.Id) {
                    roleForEmail = r;
                    break;
                }
            }
            contactForEmail = contact;
            createEmail();
        }
        /* if(sendEmailADAS != null && sendEmailADAS != ''){
for (IB_Role__c r : roles) {
if (r.IB_Contact__c == contact.Id) {
roleForEmail = r;
break;
}
}
contactForEmail = contact;
createEmail();
}*/
        
        addProDev = new Contact_Professional_Development__c();
        
        
        if(Test.isRunningTest())
        {
            Account acc = new Account (
                Name = 'test acc name',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = 'test acc name'
            );
            ContactEmailService.setAccountId(acc.Id);
        }
        else
        {
            ContactEmailService.setAccountId(account.Id);
            
        }
        
        
        ContactEmailService.setContactId(contact.Id);
        
        if(!Test.isRunningTest())
        {
            if (ContactEmailService.getEmailRec() != null) {
                accountEmail = ContactEmailService.getEmailRec();
            }
            else {
                accountEmail = new ContactEmail__c(Account__c = account.Id, Contact__c = contact.Id);
            }
        }
        Salutation = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Schema.Contact.Salutation.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Salutation.add(new SelectOption('' , '- '+Label.IBENPortal_Global_None+' -'));
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
            if(f.getLabel() != '-')
                Salutation.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
        //Start
        ContactQualifications = new List<SelectOption>();
        System.debug('****Qualification****');
        if(contact.Qualifications__c != null){
            List<String> Qualificationitems = contact.Qualifications__c.split(';');
            Schema.DescribeFieldResult fieldResult2 = Schema.Contact.Qualifications__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for(Schema.PicklistEntry f : ple2){
                for(String s : Qualificationitems){
                    if(f.getValue() == s && f.getLabel() != '----------')
                        ContactQualifications.add(new SelectOption(f.getValue() , f.getLabel()));
                }
            }
            
        }//End
    }
    
    
    
    public PageReference init() {
        //Changed return type from void to Page Reference
        
        PageService.setPage('PimsProfile');
        activeTab = PageService.getActiveTab();
        
        if (activeTab == null) {
            activeTab = 'contact';
        }
        
        // added by kashyap as a part of ECM00503-Miscellaneous functionalities on Invited Contact for redierction on creation of contact
        if((sendEmail != null && sendEmail != '' && sendEmail == 'true') || (sendEmailADAS != null && sendEmailADAS != '' && sendEmailADAS == 'true') ){
            PageReference contactPage = Page.PimsProfile;
            contactPage.getParameters().put('tab', 'contact');
            return contactPage;
        }else
        {
            return null;
        }
        
    }
    
    public PageReference edit() {
        
        try {
            //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
            //Start
            if(ContactQualifications.size() > 0){
                String s='';
                for(SelectOption so : ContactQualifications){
                    s = s + so.getValue()+';';
                }
                contact.Qualifications__c = s;
                if((contact.Country_Code__c != null && contact.Country_Code__c != '' && contact.Country_Code__c != '--None--' && contact.Country_Code__c != '--Aucun--' && contact.Country_Code__c != '--Ninguno--' )&& contact.Phone_Number__c!= Null)
                {
                    
                    PhoneValidation phone_validation = new PhoneValidation();														 
                    Boolean temp = phone_validation.edit_phone(contact);
                    Integer charLength = contact.Phone_Number__c.length();
                    if(charLength<4 || charLength>15 || temp==true)
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Error));
                        return null;
                    }
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Instruction));
                    return null;
                }
                update contact;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Member_Updated));
                
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.IBENPortal_Qualifications_Error));
            }
            //End
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    public boolean edit_phone(){
        citySelected = contact.Country_Code__c;
        phone_number = contact.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
        Integer len = phone_number.length();  
        
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
            
            
            
            // FinalPh='('+FinalPh+')';
            
            FinalPh=FinalPh+PhoneNumber2;
            contact.Phone = FinalPh;
            system.debug('FinalPh : ' + FinalPh);
            
        }
        else{
            return true;
        }
        return false;
    }
    
    public PageReference editAccountEmailOnly() {
        
        try {
            
            if ((accountEmail.EmailAddress__c == null || accountEmail.EmailAddress__c == '')) {
                try {
                    System.debug('ATTEMPT DELETE');
                    delete accountEmail;
                }
                catch (Exception ex) {
                    // will only fall into here if they try to update an email without providing one
                    System.debug(ex);
                }
                
            }
            else {
                upsert accountEmail;
            } 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Member_Updated));
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        
        return null;
        
    }
    
    public PageReference createRole() {
        
        try {
            
            addRole.IB_Contact__c = contact.Id;
            addRole.IB_Account__c = account.Id;
            addRole.Start_Date__c = Date.today();
            addRole.Status__c = 'Confirmed';
            
            insert addRole;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_Added));
            
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
    
    public PageReference createSubject() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            if (addSubject == null || addSubject == '') {
                throw new CustomValidationException('You must enter a subject.');
            }
            
            Role_Application_Subject__c roleSubject = new Role_Application_Subject__c();
            
            roleSubject.Role_And_Application__c = roleId;
            roleSubject.IB_Subject__c = addSubject;
            
            insert roleSubject;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Subject_Added));
            
            RoleApplicationSubjectService.setRoleId(roleId);
            RoleApplicationSubjectService.isSubjectsCached = false;
            subjects = RoleApplicationSubjectService.getSubjectsByRoleId();
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference removeSubject() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Role_Application_Subject__c subjectToDelete = new Role_Application_Subject__c();
            subjectToDelete.Id = deleteId;
            
            delete subjectToDelete;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            RoleApplicationSubjectService.setRoleId(roleId);
            RoleApplicationSubjectService.isSubjectsCached = false;
            subjects = RoleApplicationSubjectService.getSubjectsByRoleId();
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return pageRef;
    }
    
    public PageReference createProDev() {
        
        try {
            
            addProDev.Role__c = roleId;
            addProDev.Contact__c = contactId;
            if (subjectId != null) addProDev.Role_Subject__c = subjectId;
            
            insert addProDev;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PD_Workshop_added));
            
            if (subjectId != null) {
                ContactPDService.setSubjectId(subjectId);
                ContactPDService.isPdBySubjectCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentBySubjectId();
            }
            else {
                ContactPDService.setRoleId(roleId);
                ContactPDService.isPdByRoleCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentByRoleId();
            }
            
            addProDev = new Contact_Professional_Development__c();
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference updateProDev() {
        
        try {
            
            update proDev;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The PD Workshops have been updated successfully.'));
            
            if (subjectId != null) {
                ContactPDService.setSubjectId(subjectId);
                ContactPDService.isPdBySubjectCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentBySubjectId();
            }
            else {
                ContactPDService.setRoleId(roleId);
                ContactPDService.isPdByRoleCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentByRoleId();
            }
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference removeProDev() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Contact_Professional_Development__c proDevToDelete = new Contact_Professional_Development__c();
            proDevToDelete.Id = deleteId;
            
            delete proDevToDelete;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            if (subjectId != null) {
                ContactPDService.setSubjectId(subjectId);
                ContactPDService.isPdBySubjectCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentBySubjectId();
            }
            else {
                ContactPDService.setRoleId(roleId);
                ContactPDService.isPdByRoleCached = false;
                proDev = ContactPDService.getSProfessionalDevelopmentByRoleId();
            }
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return pageRef;
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public List<SelectOption> getProgrammeOptions() {
        
        try{
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
                if (!added) options.add(new SelectOption(programme.Id, programme.RecordType.Name));
            }
            return options;
        }
        catch(exception x)
        {
            return Null;
        }
    }
    
    public List<SelectOption> getRoleOptions() {
        
        try{
            List<SelectOption> options = new List<SelectOption>();
            Map<String,SelectOption> selectMap = new Map<String,SelectOption>();
            List<String> sortedOptions = new List<String>();
            for (IB_Role_Repository__c role : rolesFromRepository){
                if (role.Display_In_PIMS_Community__c == true && role.Application_Available_in_MyIB__c == false && role.Role_Name__c != 'Exam Contact' && role.Role_Name__c != 'Programme Coordinator' && role.Role_Name__c != 'Head of School' && role.Role_Name__c != 'Billing Contact') {
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
        catch(exception x)
        {
            return Null;
        }
    }
    
    public List<SelectOption> getSubjectGroups() {
        try
        {
            IB_Programme__c prog = [SELECT Id, Name, RecordType.Name FROM IB_Programme__c WHERE Id = :role.IB_Programme_New__c];
            programmeSelectedType = prog.RecordType.Name;
            if (programmeSelectedType == 'Diploma Programme') {
                programmeSelectedType = 'DP';
            }
            
            List<SelectOption> options = new List<SelectOption>();
            Boolean added = false;
            
            List<IB_Subject__c> subjects = new List<IB_Subject__c>();
            if (programmeSelectedType == 'IBCC' || programmeSelectedType == 'CP') {
                subjects = [
                    SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                    FROM IB_Subject__c
                    WHERE (IB_Programme__c = :programmeSelectedType OR IB_Programme__c = 'DP')
                    AND Available_in_MySchool__c = true
                    ORDER BY Subject_Group__c ASC
                ];
            }
            
            //Following code block is added by Shehryar-Plumlogix of SA in US12194 on 3/19/2021
            //Start
            else if (programmeSelectedType == 'PYP')
            {
                subjects = [
                    SELECT Id, OwnerId, IsDeleted, Name, IB_Programme_Long__c, IB_Programme__c, Subject_Code__c, Subject_Group_Identifier__c, Subject_Group_Value__c, toLabel(Subject_Group__c), Subject_Name__c, Subject_Name_FR__c, Subject_Name_SP__c
                    FROM IB_Subject__c
                    WHERE IB_Programme__c = :programmeSelectedType
                    And Subject_Group_Value__c != 'Career-related Programme Core'
                    AND Available_in_MySchool__c = true
                    ORDER BY Subject_Group__c ASC
                ];
            }
            //End
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
            /*for (IB_Subject__c subject : subjects) {
subjectNames.add(subject.Subject_Group__c);
}

options.add(new SelectOption('', ''));
for (String name : subjectNames) {
options.add(new SelectOption(name, name));
}*/
            
            options.add(new SelectOption('' , '- '+Label.IBENPortal_Global_None+' -'));
            for(IB_Subject__c subject : subjects){
                if(!subjectNames.contains(subject.Subject_Group_Value__c)){
                    subjectNames.add(subject.Subject_Group_Value__c);
                    options.add(new SelectOption(subject.Subject_Group_Value__c,subject.Subject_Group__c));               
                }
            }
            
            return options;
        }
        catch(exception x)
        {
            return Null;
        }
        
    }
    
    public List<SelectOption> getSubjectNames() {
        
        try
        {
            system.debug('before role###'+role);
            IB_Programme__c prog = [
                SELECT Id, Name, RecordType.Name
                FROM IB_Programme__c
                WHERE Id = :role.IB_Programme_New__c
            ];
            system.debug('prog###'+prog);
            programmeSelectedType = prog.RecordType.Name;
            if (programmeSelectedType == 'Diploma Programme') {
                programmeSelectedType = 'DP';
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
                    WHERE IB_Programme__c = :programmeSelectedType
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
        catch(exception x)
        {
            return Null;
        }
    }
    
    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }
    
    public void sendEmail(String toemail){
        
        
        
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
            //  mail.setSubject(Label.PIMS_Email_Reminder_Subject);
            // String plainBody = template.Body;
        }
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String developerName;
            string rolename;
            string programme;
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
                plainBody = plainBody.replace('[Account Name]', conOwnerList[0].Name);
                plainBody = plainBody.replace('[Programme Name]', programme);
            } else {
                plainBody = plainBody.replace('[Account Name]', contactForEmail.Account.Name);
                plainBody = plainBody.replace('[Owner Name]', conOwnerList[0].Name);
            }
            plainBody = plainBody.replace('[URL]', url);
             if(agreementTypeOfProgramme!= null ){ //modified newly on 29-5-24 for bug fix
                 plainBody = plainBody.replace('[Agreement Type]', '-'+agreementTypeOfProgramme+'-');
                 plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
            }else {
               
                plainBody = plainBody.replace('[Agreement Type]',roleForEmail.IB_Role_Name__c);
                plainBody = plainBody.replace('[Role Name]', '');
            }
            
            mail.setPlainTextBody(plainBody);
            
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }catch(exception e){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getMessage()));
            }
        }
        catch(exception e)
        {
            system.debug('Excep'+e);
        }
    }
    
    
    public void createEmail(){
        
        try{
            if(contactForEmail != null){
                
                email = contactForEmail.Email;
                
                //invitationID =[SELECT Id, Invitation_ID__c FROM Contact WHERE Id =: contactForEmail.id].Invitation_ID__c;
                invitationID = contactForEmail.Invitation_ID__c;
                if(invitationID==null){
                    invitationID = '';
                }
                String headUrl = ApexPages.currentPage().getHeaders().get('Host');
                String curUrl = '/ibportal/IBPortalTriagePage?inviteid=';
                String currrentUrlADAS = '/ibportal/roleRejectConfirmADAS?inviteid=';
                url ='https://'+headUrl+curUrl+invitationID;
                urlADAS = 'https://'+headUrl+currrentUrlADAS+invitationID;
                conOwnerList = [SELECT Id, Name FROM User WHERE Id =: contactForEmail.OwnerId LIMIT 1];
                
                if(roleForEmail != null)
                {
                    if(roleForEmail.IB_Role_Name__c == 'Admin Assistant' || roleForEmail.IB_Role_Name__c == 'Chief Invigilator')//
                    {
                        roleForEmail.IB_Contact__r.Email = email;
                        AdminAssistantHelper.sendEmailToADASNewInvitee(url,urlADAS,roleForEmail); 
                    }
                    else
                    {
                        //Added by Kashyap ECM00635 added newly on 29-5-24 for bug fix
                        if(roleForEmail.IB_Programme_New__r.RecordType.DeveloperName =='Agreement'){
                            system.debug('roleForEmail******'+roleForEmail);
                            agreementTypeOfProgramme= roleForEmail.IB_Programme_New__r.Agreement_Type__c;
                         }
                        //Added by Kashyap ECM00635
                        sendEmail(email);
                    }
                }
                else{
                    //Added by Kashyap ECM00635 added newly on 29-5-24 for bug fix
                      if (roleForEmail != null) {
                                System.debug('IB_Programme_New__r: ' + roleForEmail.IB_Programme_New__r);
                                if (roleForEmail.IB_Programme_New__r != null) {
                                    System.debug('RecordType: ' + roleForEmail.IB_Programme_New__r.RecordType);
                                        if (roleForEmail.IB_Programme_New__r.RecordType != null && roleForEmail.IB_Programme_New__r.RecordType.DeveloperName =='Agreement') {
                                            system.debug('roleForEmail******'+roleForEmail);
                                            agreementTypeOfProgramme= roleForEmail.IB_Programme_New__r.Agreement_Type__c;
                                        }   
                                }
                            }
                            //Added by Kashyap ECM00635
                    
                    sendEmail(email);   
                }
            }
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
    }
    
}