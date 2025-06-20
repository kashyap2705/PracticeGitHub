@isTest(SeeAllData=true)
public class PimsTestUtil {
    
    
    public static User createPortalUserPYP(String testemail){
        Profile p =  [select Id,UserLicense.Name from profile where Name='SCU + Advanced' limit 1];
        
        //String testemail = 'puser000@amamama.com';
        
        Account acc = createAccount('test acc name', '');
        
        insert acc;
        
        Contact c = createContact('test name', testemail, testemail, Date.today().addYears(-22), acc);
        c.AccountId = acc.Id;
        insert c;

        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '5',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
            
        );
        
        
        
        insert s;
        
        generateStandardRoles();
        
        
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        
        system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        
        
        return pu;
    }
    
    public static User createPortalUserPYP(String testemail, Boolean generateRoles){
        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];
        
        
        //update p;
        //String testemail = 'puser000@amamama.com';
        
        Account acc = createAccount('test acc name', '');
        insert acc;
        
        Contact c = createContact('test name', testemail, testemail, Date.today().addYears(-22), acc);
        c.AccountId = acc.Id;
        insert c;
        
        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '5',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
            
        );
        
        insert s;
        
        if(generateRoles){
            generateStandardRoles();
        }
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        return pu;
    }
    
    public static User createPortalUserPIMS(String testemail, String startMonth, String endMonth, Boolean generateRoles){
        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];
        
        //String testemail = 'puser000@amamama.com';
        
        Account acc = createAccount('test acc name', '');
        acc.PIMS_Step_1__c = true;
        acc.PIMS_Step_2__c = true;
        acc.PIMS_Step_3__c = true;
        acc.PIMS_Step_4__c = true;
        acc.PIMS_Step_5__c = true;
        acc.Website = 'http://www.google.com';
        acc.Year_Founded__c = '1990';
        acc.Academic_Start_Month__c = startMonth;
        acc.Academic_End_Month__c = endMonth;
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';
        
        insert acc;
        
        Contact c = createContact('test name', testemail, testemail, Date.today().addYears(-22), acc);
        c.AccountId = acc.Id;
        insert c;
        integer year =  Date.Today().Year();   
        string Year1 =string.valueOf(year);
        year++;
        //The following code is updated by Shehryar-plumlogix for US12330 sprint 26 on 09/07/2021
        //start  
        string Year2 = string.valueof(year).right(2);
        String CurrentYear = Year1 + '-' + Year2;
        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '13',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10,
            Academic_Year__c = CurrentYear
            
        );
        //end
        insert s;
        
        SchoolSections__c s1 = new SchoolSections__c(
            Grade_From__c = 'K',
            Grade_To__c = 'K',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10,
            Academic_Year__c = CurrentYear
        );
        
        insert s1;
        
        if(generateRoles){
            generateStandardRoles();
        }
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        return pu;
    }
    
    public static Account createAccount(String name, String recordType){
        Id recordTypeId;
        if(recordType != ''){
            try{
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
            } catch(Exception e){}
        }
        
        if (recordTypeId == null){
            return new Account (
                Name = name,
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Website = 'https://www.test.org',   // US-0001944 Change
                Lead_Account__c = true,
                Short_Name__c = name
            );
            
        } else {
            return new Account (
                Name = name,
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Short_Name__c = name,
                Lead_Account__c = true,
                Billing_Currency__c = 'USD',
                RecordTypeId = recordTypeId,        // US-0001944 Change
                Website = 'https://www.test.org'    // US-0001944 Change
            );
        }
    }
    
    public static Contact createContact(String name, String homeEmail, String profEmail, Date birthdate, Account acc){
        return new Contact (
            Salutation = 'Mr.', 
            LastName = name,
            MobilePhone = '+30992907711',
            HomePhone = '+30992907711',
            //OtherPhone = '+30992907711',
            Email = homeEmail,
            Birthdate = birthdate,
            Alternative_Email__c  = 'noname@example.commm',
            FirstName = 'noname',
            MailingCity = 'Palm Coast',
            //below 2 lines modified by Prerna because this test class was failing due to 207 changes
            MailingState = 'Florida',
            MailingCountry = 'United States',
            MailingPostalCode = '32137',
            MailingStreet = 'street',
            AccountId = acc.Id,
            Full_time_Part_time__c = 'Full Time',
            Number_of_years_at_school__c = '4',
            Phone = '+13861234567',
            Qualifications__c = 'BS',
            Job_Title__c = 'Blah',
            Birth_Locale__c   = 'sea',
            Country_of_Birth__c = 'Armenia'
        );
    }
    
    public static IB_Address__c createAddress(String name, String addr1, String city, String postal, Id country, Account acc){
        return new IB_Address__c(
            Name = name,
            Address_Line_1__c = addr1,
            City__c = city,
            Postal_Code__c = postal,
            IB_Account__c = acc.Id,
            Status__c = 'Active',
            Province__c = 'FL',
            Country__c = country
        );
    }
    
    public static IB_Role_Repository__c createRoleRepo(String roleName){
        return new IB_Role_Repository__c(
            Available__c=true,
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c=roleName,
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );
    }
    
    public static IB_Role__c createIbRole(Id repoId, Id contactId, Id accId){
        return new IB_Role__c(
            IB_Contact__c = contactId,
            IB_Role__c = repoId,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            // Role_Level__c = 'Fully Qualified',
            IB_Account__c = accId
        );
    }
    
    public static IB_Programme__c createProgramme(){
        Account acc = createAccount('Test Account','');
        insert acc;
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
        
        IB_Programme__c ib = new IB_Programme__c();
        
        ib.Account__c = acc.Id;
        ib.Exam_Session__c = 'May';
        ib.Status__c = 'Test';
        ib.IBCC_Implementation_Phase__c = 'Phase 1';
        ib.Primary_Language_of_Instruction__c = 'English';
        ib.Street_Address__c =add.id;
        ib.owner__c = '0050O0000076lXX';
        
        return ib;
        
    }
    
    public static IB_Programme__c createProgrammeForAccount (Account acc, String programme){
        RecordType RecType = null;
        try {
            RecType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'IB_Programme__c' AND DeveloperName = :programme];
        }
        catch (Exception ex) {
            System.debug(ex);
            RecType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'IB_Programme__c' AND Name = :programme LIMIT 1];
        }
        
        system.debug('RecType from createProgrammeForAccount ====> '+RecType);
        system.debug('RecType.Name from createProgrammeForAccount ====> '+RecType.Name);
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
        
        IB_Programme__c ib = new IB_Programme__c();
        ib.RecordTypeId = RecType.Id;
        ib.RecordType = RecType;
        ib.Account__c = acc.Id;
        ib.Exam_Session__c = 'May';
        ib.Status__c = 'Test';
        ib.Street_Address__c =add.id;
        ib.IBCC_Implementation_Phase__c = 'Phase 1';
        ib.Primary_Language_of_Instruction__c = 'English';
        
        return ib;
    }
    
    public static IB_Programme__c createProgrammeForAccount2 (Account acc){
        IB_Programme__c ib = new IB_Programme__c();
        ib.Account__c = acc.Id;
        ib.Exam_Session__c = 'May';
        ib.Status__c = 'Test';
        ib.IBCC_Implementation_Phase__c = 'Phase 1';
        
        return ib;
    }
    
    public static IB_Country_Segmentation__c createIBACountrySegmentation (String cou, String code2, String code3){
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        
        country.Country_es__c = 'Spanish';
        country.Country_fr__c = 'French';
        country.Name = cou;
        country.ISO_Alpha_2_Code__c = code2;
        country.ISO_Alpha_3_Code__c = code3;
        country.Geographical_Sub_Region_Segmentation__c = 'Northern America';
        country.IBEN_Segmentation__c = 'IBA';
        country.Regional_Office_Segmentation__c = 'IBA';
        
        return country;
        
    }
    
    public static IB_Programme__c associateAddressWithProgramme(IB_Programme__c p, IB_Address__c a, String type){
        
        if(type == 'postal'){
            p.Postal_Address__c = a.Id;
        } else if(type == 'street') {
            p.Street_Address__c = a.Id;
        } else if (type == 'billing'){
            p.Billing_Address__c = a.Id;
        }
        
        return p;
    }
    
    public static SchoolSections__c createSchoolSection(String f, String t, Account acc){
        return new SchoolSections__c(
            Grade_From__c = f,
            Grade_To__c = t,
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );
    }
    
    public static User createGuest(String testemail){
        Profile p =  [select Id from profile where Name='PIMS Profile' limit 1];
        
        //String testemail = 'puser000@amamama.com';
        
        Account acc = createAccount('test acc name', '');
        insert acc;
        
        Contact c = createContact('test name', testemail, testemail, Date.today().addYears(-22), acc);
        c.AccountId = acc.Id;
        insert c;
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname');
        return pu;
    }
    
    public static void generateStandardRoles(){
        List<IB_Role_Repository__c> repoList = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c repo = createRoleRepo('School Contact');
        repoList.add(repo);
        repo = createRoleRepo('Programme Coordinator');
        repoList.add(repo);
        repo = createRoleRepo('Billing Contact');
        repoList.add(repo);
        repo = createRoleRepo('Exam Contact');
        repoList.add(repo);
        repo = createRoleRepo('Head of School');
        repoList.add(repo);
        repo = createRoleRepo('Head of School (Overall)');
        repoList.add(repo);
        
        insert repoList;
    }
    
    public static Standards_Practices__c createStandardPractice(String standard, String practice, boolean reqCan, boolean reqAuth, boolean progCan, boolean progAuth, String practiceId) {
        
        return new Standards_Practices__c(
            Practice__c = practice,
            Standard__c = standard,
            Required_For_Candidacy__c = reqCan,
            Required_For_Authorization__c = reqAuth,
            In_Progress_For_Candidacy__c = progCan,
            In_Progress_For_Authorization__c = progAuth,
            Practice_ID__c = practiceId
        );
        
    }
    
    public static IB_Action_Plan__c createActionPlan(Id programmeId, Id standardPracticeId, String status) {
        
        return new IB_Action_Plan__c(
            Programme__c = programmeId,
            AP_Standard_Practice__c = standardPracticeId,
            AP_Status__c = status
        );
        
    }
    
    public static IB_Application__c createApplication() {
        
        Account acc = createAccount('Test Account','');
        insert acc;
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
        
        IB_Programme__c prog = new IB_Programme__c();
        prog.Account__c = acc.Id;
        prog.Exam_Session__c = 'May';
        prog.Status__c = 'Test';
        prog.IBCC_Implementation_Phase__c = 'Phase 1';
        prog.Primary_Language_of_Instruction__c = 'English';
        prog.Street_Address__c = add.id;
        insert prog;
        
        IB_Application__c app = new IB_Application__c(
            Application_Lookup_to_Programme__c = prog.Id
        );
        
        return app;
        
    }
    
    public static IB_Workshop_Titles__c createWorkshopTitle(){
        IB_Workshop_Titles__c wt = new IB_Workshop_Titles__c();
        wt.Programme__c = 'PYP';
        wt.Subject__c = 'Dance';
        wt.Subject_Group__c = 'Arts';
        wt.Workshop__c = 'Workshop Development';
        wt.Workshop_Title_ENG__c = 'test';
        wt.Workshop_Title_FR__c = 'test';
        wt.Workshop_Title_SP__c = 'test';
        return wt;
    }
    
    public static Role_Application_Workshop_Title__c createRoleApplicationWorkshopTitle(Id roleAppId, Id workshpTitleId){
        Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
        rawt.IB_Workshop_Title__c = workshpTitleId;
        rawt.Role_And_Application__c = roleAppId;
        return rawt;
    }
    
}