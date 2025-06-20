/*-
* Modified By: Tarun Sharma
* Modified Date: Nov 21,2023
* Modified Changes: Line number 1049-1053
*/
@isTest
public class TestsUtil {
    
    public static final String COMMUNITY_NAME_IB_EDUCATOR = 'IB_Educator';
    public static final String COMMUNITY_NAME_INTERNAL = 'Internal';
    
    
    public static Contact createContact(String name, String homeEmail, String profEmail, Date birthdate, IB_Country_Segmentation__c country){
        return new Contact (
            Salutation = 'Mr.',
            LastName = name,
            MobilePhone = '+9212345607865',
            HomePhone = '+9212345607865',
            AssistantPhone = '+9212345607865',
            OtherPhone = '+9212345607865',
            NoK_Mobile__c = '+9212345607865',
            NoK_Phone__c = '+9212345607865',
            Permission_Mobile__c = '+9212345607865',
            Permission_Phone__c = '+9212345607865',
            Work_Phone_Extension__c = '+9212345607865',
            Phone = '+9212345607865',
            //OtherPhone = '+30992907711',
            Email = homeEmail,
            Birthdate = birthdate,
            Country__c = (country == null ? null : country.id),
            Alternative_Email__c = profEmail,
            FirstName = 'FN'+name,
            MailingCity = 'Lviv city',
          //  MailingState = 'state UA',
            MailingCountryCode = 'UA',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
    }
    
    
    public static void fillContactWithNokData(Contact cont){
        cont.NoK_First_Name__c = 'FNoK' + cont.FirstName;
        cont.NoK_Last_Name__c = 'LNoK' + cont.LastName;
        //cont.NoK_Phone__c = '+301020304';
        cont.NoK_Mobile__c = '+301020304';
        cont.NoK_Title__c = 'Next of Kin';
        cont.NoK_Email__c = 'atest@test.com';
        //cont.Bank_Name__c = 'testuserBankname';
        cont.Independent_Educator__c = 'Yes';
    }
    
    
    public static void fillContactWithPassportDetails(Contact cont){
        cont.Full_Name__c = cont.FirstName + cont.LastName;
        cont.Legal_first_name__c = 'FirstName';  
        cont.Legal_Last_name__c = 'LastName';
        cont.Passport_Number__c = '010203';
        cont.Birth_Locale__c = 'Somewhere';
        cont.Country_of_Birth__c = 'Ukraine';
        cont.Place_of_Issue__c = 'Ukraine';
        cont.Expiry_Date__c = Date.today().addDays(20);
        cont.Nationality__c = 'Ukraine';
        //cont.OtherStreet = 'other_street';
    }   
    
    
    public static IB_Country_Segmentation__c createCountry(String name, String region, Account acc){
        return new IB_Country_Segmentation__c (
            Name = 'Austria', 
            Geographical_Sub_Region_Segmentation__c = 'Europe',
            Regional_Office_Segmentation__c ='IBAEM', 
            IBEN_Segmentation__c = 'IBAEM',
            IBEN_Independent_Account__c = acc.Id
        );
    }
    
    public static IB_Country_Segmentation__c createCountryLanguages(String name, String fr, String es, Account acc){
        return new IB_Country_Segmentation__c (
            Name = name, 
            country_es__c = es,
            country_fr__c = fr,
            Geographical_Sub_Region_Segmentation__c = 'Europe',
            Regional_Office_Segmentation__c ='IBAEM', 
            IBEN_Segmentation__c = 'IBAEM',
            IBEN_Independent_Account__c = acc.Id
            
        );
    }
    
    
    public static IB_E_Background__c createMyProfileObject(Id contactId, Id recordTypeId){
        return new IB_E_Background__c(
            Related_Subject_Area__c = 'test area',
            Title_of_Research__c = 'test Research',
            Publication_Date__c = Date.today().addYears(-2),
            IB_Contact__c = contactId,
            RecordTypeId = recordTypeId
        );
    }
    
    
    public static Attachment createAttachment(String fileName, Id parentId){
        return new Attachment (
            body = Blob.valueOf('test value body'), 
            Name = fileName, 
            ContentType = 'text/html', 
            parentId = parentId
        );
    }   
    
    
    public static Account createAccount(String name){
        return new Account ( 
            Name = name,
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = name,
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',
            Phone = '+9212345607865',
            Website = 'www.test.com'
        );
        //,
        //IBIS_ID__c = '000001'
    }
    
    
    
    //Code added by Prerna Start-----
    public static IB_Address__c createAddress(Id accountId){
       return new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = accountId,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        ); 
    }
    
    public static IB_Programme__c createCPProgramme(Id accountId, Id streetAddress, Id recordTypeID){
        return new IB_Programme__c(
            Name = 'CP Test Programme',
            RecordTypeId = recordTypeID,
            StageName__c = 'Evaluation', 
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = accountId, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = streetAddress
        );
    }
    
    public static Non_IB_Code__c createNonIBCodeForCP(Id programmeId, Id accountId){
        return new Non_IB_Code__c(
            Code_Name__c = 'NCES (USA)',
            Code__c = '1',
            Related_to_IB_Programme_1__c = programmeId,
            Related_to_IB_Account__c = accountId
        );
    }
    public static IB_Programme__c createDPProgramme(Id accountId, Id StreetAddress, Id recordTypeID){
        return new IB_Programme__c(
            Name = 'DP Test Programme',
            RecordTypeId = recordTypeID,
            StageName__c = 'Evaluation', 
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = accountId, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = StreetAddress
        );
    }
    
    public static Non_IB_Code__c createNonIBCodeForDP(Id programmeId, Id accountId){
        return new Non_IB_Code__c(
            Code_Name__c = 'State (USA)',
            Code__c = '2',
            Related_to_IB_Programme_2__c = programmeId
            //Related_to_IB_Account__c = accountId
        );
    }
    
    public static Account createSecondAccount(String name){
        return new Account ( 
            Name = name,
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = name,
            IBIS_ID__c = '000002',
            State_Abbr__c = 'SA',
            Phone = '+9212345607867'
        );
    }
    
    public static IB_Address__c createSecondAddress(Id accountId){
       return new IB_Address__c(
            Name = 'STRUNK 2',
            IB_Account__c = accountId,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        ); 
    }
    
    public static IB_Programme__c createSecondDPProgramme(Id accountId, Id StreetAddress, Id recordTypeID){
        return new IB_Programme__c(
            Name = 'DP Test Programme 2',
            RecordTypeId = recordTypeID,
            StageName__c = 'Evaluation', 
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = accountId, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = StreetAddress
        );
    }

    public static IB_Programme__c createPYPProgramme(Id accountId, Id StreetAddress, Id recordTypeID){
        return new IB_Programme__c(
            Name = 'PYP Test Programme',
            RecordTypeId = recordTypeID,
            StageName__c = 'Evaluation', 
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = accountId, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = StreetAddress
        );
    }
    public static Non_IB_Code__c createNonIBCodeForPYP(Id programmeId, Id accountId){
        return new Non_IB_Code__c(
            Code_Name__c = 'NCES (USA)',
            Code__c = '4',
            Related_to_IB_Programme_4__c = programmeId
            //Related_to_IB_Account__c = accountId
        );
    }
    
    
    public static IB_Programme__c createSecondPYPProgramme(Id accountId, Id StreetAddress, Id recordTypeID){
        return new IB_Programme__c(
            Name = 'PYP Test Programme 2',
            RecordTypeId = recordTypeID,
            StageName__c = 'Evaluation', 
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = accountId, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = StreetAddress
        );
    }
    
    //Code added by Prerna End-----
    
    public static Campaign createRFCCampaign(String name, Id accountId, Id programmeId, Id recordTypeId, String status) {
        return new Campaign  (
            Name = 'Request for Candidacy',
            Event_Organizer_Account__c = accountId,
            Related_IB_Programme__c = programmeId, 
            RecordTypeId = recordTypeId,  
            Type = 'Authorization',
            Sub_Type__c = 'Request for Candidacy',
            Status  = status,
            Staffing_Event_Published__c = false,
            Event_Organizer_Region__c = 'IBA',
            Required_Number_of_Educators__c = 1,
            Venue_Account__c = accountId,
            Bundle__c = false
        );
        
    }   
    
    public static Campaign createCampaign(String name, Id accountId, Id opportunityId, Id recordTypeId) {
        return new Campaign  (
            Name = 'Verification visit',
            Event_Organizer_Account__c = accountId,
            Related_Programme__c = opportunityId, 
            RecordTypeId = recordTypeId,  
            Type = 'Authorization',
            Sub_Type__c = 'Verification Visit',
            //    IB_Docs_ID__c = 'Test',
            Status  = 'Planned / Ready for Staffing',
            Staffing_Event_Published__c = false,
            Event_Organizer_Region__c = 'IBAEM',
            Required_Number_of_Educators__c = 3,
            Venue_Account__c = accountId,
            Bundle__c = false
        );
        /* Workshop_Event_Region__c = 'IBAEM',
Workshop_Event_Region_del__c = 'IBAEM'*/
    }   
    
    
    public static My_Staffing_Event__c createMyStaffingEvent(String name, Id accountId, Id campaignId, Id ibEventRoleId, Id ibRoleId) {
        return new My_Staffing_Event__c(
            IB_Event__c=campaignId, //camp 70111000000DyOKAA0
            CurrencyIsoCode='USD', 
            IB_Event_Role__c = ibEventRoleId,
            Level_of_Interest__c='Interested',
            Application_Status__c='Pending Selection',
            My_Role__c = ibRoleId
        );
    }   
    
    //Below method writtened by Prerna on 18-03-2024
    public static My_Staffing_Event__c createMyStaffingEventForTeamLeader(String name, Id accountId, Id campaignId, Id ibEventRoleId, Id ibRoleId, Id contactId) {
        return new My_Staffing_Event__c(
            IB_Event__c=campaignId, //camp 70111000000DyOKAA0
            CurrencyIsoCode='USD', 
            IB_Event_Role__c = ibEventRoleId,
            Level_of_Interest__c='Interested',
            Application_Status__c='Confirmed',
            IB_Role__c = ibRoleId,
            IB_Contact__c = contactId
        );
    }  
    
    
    public static Staffing_Event__c createStaffingEvent(String name, Id campaignId, Id accountId) {
        return new Staffing_Event__c(
            Name = name,
            IB_Event__c = campaignId,
            Event_Organizer__c = accountId
        );
    }
    
    
    public static Opportunity createOpportunity(String name, Id accountId){
        return new Opportunity (
            Name = name,
            StageName = 'Evaluation', 
            AccountId = accountId, 
            CloseDate = Date.today(), 
            CurrencyIsoCode= 'EUR'
            // This Part is being commented by Ammara-Plumlogix on 9-22-2019,US-11329
            //begin
            //Primary_Language_Of_Instruction__c = 'English',
            //Status__c = 'Interested',
            //Programme_Legal_Name__c =  'Test',
            //Exam_Session__c = 'May'
            //End
            
            
            
        );
    }
    
    
    public static IB_Role__c createIbRole(Id repoId, Id contactId){
        return new IB_Role__c(
            IB_Contact__c = contactId,
            IB_Role__c = repoId,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified'
        );
    } 
    
    public static IB_Role__c createIbRoleWithParams(Id repoId, Id contactId,String status,String programmeSelection, Boolean isActive,String roleLevel){
        Contact_Information__c CI = new Contact_Information__c();
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Email', 'Contact_Information__c');
        CI.RecordType = rt1;
        CI.Email__c = 'Test@test.com';
        CI.Name =   'Test@test.com';  
        CI.IB_Contact__c = contactId;
        insert CI;
        return new IB_Role__c(
            IB_Contact__c = contactId,
            IB_Role__c = repoId,
            Programme_Selection__c=programmeSelection,
            Status__c=status,
            Active__c = false,
            Contact_Information_Email__c = CI.Id,
            Role_Level__c = roleLevel
        );
    } 
    
    
    
    
    public static IB_Event_Role__c createIbEventRole(Double numberOfEducators, Id campaignId){
        return new IB_Event_Role__c(
            IB_Event__c = campaignId,
            Number_of_Required_Educators__c = numberOfEducators,
            Proposed_Language__c = 'French'
        );
    }
    
    
    public static IB_Role_Repository__c createRoleRepo(){
        return new IB_Role_Repository__c(
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
    }
    
    //Below method writtened by Prerna on 18-03-2024
    public static IB_Role_Repository__c createRoleRepoForTeamLeader(){
        return new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c='School Visit Team Leader',
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );
    }
    
    public static IB_Role_Repository__c createRoleRepoWithParams(String roleName,String roleLevel,String category, string subCategory ){
        return new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c=roleName,
            Category__c=category,
            Role_Level__c=roleLevel,
            Sub_Category__c=subCategory,
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            IB_Staff_Role__c=true
        );
    }
    
    
    public static MyRoleRedirectionRules__c createMyRoleRedirectionRule(String name, String communityName, String url,  String profileIds){
        return new MyRoleRedirectionRules__c(
            Name = name,
            communityName__c = communityName,
            url__c = '/apex/myRoleEditApplicationInternal',
            ids__c = profileIds
        ); 
    }
    
    // helper method to form proper name for createMyRoleRedirectionRule
    public static String getMyRoleRedirectionRuleNameOnCreate(String communityName){
        return MyRoleRedirectionController.ACTION_CREATE + '_' + communityName;
    }
    
    // helper method to form proper name for createMyRoleRedirectionRule
    public static String getMyRoleRedirectionRuleNameOnEdit(String roleStatus, String communityName){
        String name = MyRoleRedirectionController.ACTION_EDIT + '_'+ roleStatus + '_' + communityName;
        return name;
    }
    
    
    
    public static MyStaffingEventRedirectionRules__c createMyStafEventRedirectRule(String name, String communityName, String url, String profileIds){
        return new MyStaffingEventRedirectionRules__c(
            Name = name,
            communityName__c = communityName,
            url__c = '/apex/myRoleEditApplicationInternal',
            ids__c = profileIds
        ); 
    }
    
    public static My_Training_Event__c createMyTrainingEvent(String applicationStatus, Id contactId, Id trainingEventId){
        return new My_Training_Event__c(
            Application_Status__c = applicationStatus,
            IB_Contact__c = contactId,
            Training_Event__c = trainingEventId
            
        );
    }
    
    public static My_Training_Event__c createMyTrainingEvents(String applicationStatus, Id contactId, Id trainingEventId, Id campaignid){
        return new My_Training_Event__c(
            Application_Status__c = applicationStatus,
            IB_Contact__c = contactId,
            Training_Event__c = trainingEventId,
            IB_event__c = campaignid
        );
    }
    
    public static Training_Event__c createTrainingEvent(String name, Id repoId, Id campaignId){
        return new Training_Event__c (
            Name = name,
            IB_Role__c = repoId,
            IB_Event__c = campaignId
        );
    }   
    
    
    public static void fillUpContactDetailsInfo(Contact contactObject, Id countryId) {
        
        contactObject.Salutation = 'Prof';
        contactObject.FirstName  = 'First Name';
        contactObject.LastName   = 'Last  Name';
        contactObject.Email      = 'test@test.com';
        contactObject.Alternative_Email__c = 'atest@test.com';
        
        contactObject.HomePhone  = '+380909929';
        contactObject.OtherPhone = '+380909929';
        contactObject.MobilePhone= '+380909929';
        
        contactObject.Birthdate = Date.today().addYears(-25);
        
        contactObject.Country__c = countryId;
    }
    
    
    public static User createPortalUser(String name){
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        
        return createPortalUser('any_possible_name', p.Id);
    }
    
    public static User NonPortalUser(String name){
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        
        return createNonPortalUser('any_possible_name', p.Id);
    }
    
    
    public static User createNonPortalUser(String name, Id profileId){
        String testemail = name+'zzz@testtest.com';
        User npu = new User(profileId = profileId, username = testemail, email = testemail,
                            emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                            languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                            alias='csnpu', lastname=name);
        return npu;
    }//end createNonPortalUser
    
    public static User createPortalUser(String name, Id profileId){
        //Account acc = new Account (Name = 'acc_test_' + name);
        Account acc = createAccount('acc_test_' + name);
        acc.IBIS_ID__c = '000002';
        acc.Region__c='IBA';
        acc.Billing_Currency__c='USD';
        acc.Website = 'www.testwebsite.com';
        insert acc;
        
        IB_Country_Segmentation__c country = createCountry('Test_Country', 'Europe', acc);
        insert country;
        
        String testemail = name+'xxx@testtest.com';
        
        Contact c = createContact(name, testemail, testemail, Date.today().addYears(-22), country);
        fillContactWithNokData(c);
        fillContactWithPassportDetails(c);
        //c.Independent_Educator__c = 'Yes';
        //c.OtherStreet = 'other street';
        c.AccountId = acc.Id;
        insert c;
        
        User pu = new User(profileId = profileId, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname=name, contactId = c.id);
        return pu;
    }   
    
    
    public static List<IB_Event_Role__c> getIbEventRoles(){
        return [SELECT id, IB_Event__c, IB_Event__r.ParentId,Number_of_Required_Educators__c, Proposed_Language__c 
                FROM IB_Event_Role__c];
    }
    
    
    public static List<Sobject> getSObjectsByType(Schema.SObjectType sObjectType){
        return Database.query('SELECT Id FROM ' + String.valueOf(sObjectType));
    }   
    
    public static List<Training_Event__c> getTrainingEvents(){
        return [SELECT IB_Role__c, IB_Event__c 
                FROM Training_Event__c];
    }
    
    public static List<IB_Role_Repository__c> getRoleRepos(){
        return [SELECT id,Role_Level__c,Role_Name__c,Category__c, Training_Model__c
                FROM IB_Role_Repository__c];
    }
    
    public static List<My_Training_Event__c> getMyTrainingEvents(){
        return [SELECT Id, Training_Event__c
                FROM My_Training_Event__c];
    }
    
    public static List<Contact> getContacts(){
        return [SELECT Id, FirstName, LastName
                FROM Contact];
    } 
    
    public static Contact getContact(Id contactId) {
        // This Part Fields is being commented by Ammara-Plumlogix on 9-22-2019,US-11329
        // IBEN_Educator_Remarks__c is commented by Abd Ur Rehman-Plumlogix 1-7-2021,US-12100
        //begin
        return [
            SELECT Id, IsDeleted, MasterRecordId, AccountId, LastName, FirstName, Salutation, Name, RecordTypeId, OtherStreet, 
            OtherCity, OtherState, OtherStateCode, OtherPostalCode, OtherCountry, OtherCountryCode, OtherLatitude, OtherLongitude, MailingStreet, 
            MailingCity, MailingState, MailingStateCode, MailingPostalCode, MailingCountry, MailingCountryCode, MailingLatitude, MailingLongitude, Phone, 
            Fax, MobilePhone, HomePhone, OtherPhone, AssistantPhone, ReportsToId, Email, Title, Department, AssistantName, LeadSource, 
            Birthdate, Description, CurrencyIsoCode, OwnerId, HasOptedOutOfEmail, CreatedDate, CreatedById, LastModifiedDate, 
            LastModifiedById, SystemModstamp, LastActivityDate, LastCURequestDate, LastCUUpdateDate,  
            EmailBouncedReason, EmailBouncedDate, Jigsaw, JigsawContactId, 
            IMPORTED_IBIS_NAME__c, IMPORTED_IBIS_SURNAME__c, IMPORTED_IBIS_EMAIL__c, Terms_Conditions_Checked__c, 
            IMPORTED_IBIS_ROLE__c, IMPORTED_IBIS_RELATED_SCHOOL__c, Account__c, Import_Date_Time_from_IBIS__c, 
            IMPORTED_IBIS_HEAD_DIPLOMA__c, IMPORTED_IBIS_HEAD_OF_MYP__c, IMPORTED_IBIS_HEAD_OF_PYP__c, /*IMPORTED_IBIS_HEAD_OF_IBCC__c,*/
            IBIS_contact_ID__c, Subscribe_to_Friends_Mailings__c, Nationality__c, IMPORTED_IBIS_HEAD_OF_EP__c, Nationality_2__c, 
            Account_Country__c, Job_Title__c, Professional_Email__c, IBEN_Sub_Region__c,/*IBIS_Email_Changed__c,*/ Contact_Comments__c, 
            IBIS_School_Changed__c,  /*Event_Programmes__c,IBIS_Role_Changed__c,*/
            Timestamp_on_last_change_in_IBIS__c, IMPORTED_IBIS_DIPLOMA_COORDINATOR__c, IMPORTED_IBIS_PYP_COORDINATOR__c, 
            IMPORTED_IBIS_MYP_COORDINATOR__c, IMPORTED_IBIS_IBCC_COORDINATOR__c, IBIS_IMPORTED_IBIS_SCHOOL_ID__c, Primary_Contact__c, 
            /*School_Visit_Team_Member__c, School_Visit_Team_Leader__c,*/IBEN_Contact_Remarks__c,/* IBEN_Educator_Remarks__c, */
            /*IBEN_Next_of_Kin__c,IBAEM__c, Permission_Contact__c, Email_Changed_in_IBIS__c,*/IBEN_Educator_Active__c, 
            /*IBEN_Permission__c, Role_Changed_in_IBIS__c,*/School_Changed_in_IBIS__c, Contact_IBEN_Manager__c, Educator_ID__c, 
            Preferred_Email__c, Deceased__c, Account_Region__c,/*IBEN_Mother_Tongue__c, IBEN_Active_Since__c, Remarks__c*/ IB_Staff__c, 
            /*Recognition_Account_Type__c, Previously_IB_employee__c, DP_Coordinator__c,*/
            Last_modified_by_stakeholder__c, Language_of_Correspondence__c, IBA_IBEN_DB_ID__c, 
            Background_Check__c, Other_Background_Check__c, Global_IBEN_ID__c, Communications_Contact_Type__c,
            Historic__c, Integration_Key_for_IBIS_Imports__c, Work_Phone_Extension__c, 
            Alternative_Email__c, Contact_Type__c, Contract_Signed__c, 
            Country__c, Country_of_Birth__c, Expiry_Date__c, Fourth_Nationality__c,Legal_first_name__c,Legal_Last_name__c, Full_Name__c, IBEN_Region__c, /*IBAN__c, */
            IB_Region__c, Independent_Educator__c, Middle_Name__c, NoK_Email__c, NoK_First_Name__c, NoK_Last_Name__c, NoK_Mobile__c, 
            NoK_Phone__c, NoK_Title__c, OFAC_Result__c, Passport_Number__c, Permission_Email__c, Permission_First_Name__c, 
            Permission_Last_Name__c, Permission_Mobile__c, Permission_Phone__c, Permission_Title__c, Birth_Locale__c, 
            Place_of_Issue__c, Preferred_Address_of_Correspondence__c, Preferred_Communication_Method__c, Preferred_Phone__c, 
            Retired__c, School_IBIS_Code__c, School_Name__c, School_Type__c, Third_Nationality__c, 
            OFAC_Check_Required__c 
            FROM Contact  
            WHERE Id = :contactId and Valid_Residential_Country__c = false 
        ];
        //End
        //Account_Holder__c, Bank_ABA_Transit_Number__c, Bank_Account_Number__c, Bank_City__c, Bank_Country__c,
        //Bank_Name__c, Bank_SWIFT_BIC_Code__c, Bank_Street__c, Bank_ZIP_Postal_Code__c,
    }      
    
    //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c in soql by kashyap for test class fix 
     public static List<My_Staffing_Event__c> getMyStaffingEvents(){
        return [SELECT My_Role__c,Name,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, IB_Event_Role__c,IB_Event_Role__r.PSP__c,IB_Event__r.ParentId, IB_Event__c, Staffing_Event__c, Event_Organizer_Account__c,
                Performance_Rating__c, Invitation_Response__c, Role_Level__c, IB_Role_Name__c, IB_Role__c,Event_Organizer_Account__r.External_PD_Provider__c,Event_Organizer_Account__r.RecordType.Name,
                IB_Programme__c, IB_Contact__c, Application_Status__c, Level_of_Interest__c,Staffing_Event_Type__c, Staffing_Event_City__c, Staffing_Event_Country__c,
                Staffing_Event_Region__c,Staffing_Event_Venue__c, Staffing_Event__r.Name,IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.Delivery_Mode__c,
                Release_Permission_Required__c, Release_Response__c, Withdrawal_Reason__c, Start_Date__c, End_Date__c, Programme_Selection__c,Programme_s__c,Programme_From_Event_Role__c, Withdrawal_Argumentation__c, Positions_Left_per_Role__c,IB_Event__r.Bundle__c,IB_Contact__r.Id
                FROM My_Staffing_Event__c 
                LIMIT 10];
    }
    
      //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c in soql by kashyap for test class fix 
            
    public static List<Staffing_Event__c> getStaffingEvents(){// added Campaign.Event_Organizer_Account__r field in soql by kashyap for test class fix 
        return [
            SELECT Id,IB_Event__r.Name,IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, IB_Event__r.Event_Organizer_Account__r.Name, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, CreatedDate, CreatedById,IB_Event__r.ParentId, IB_Event__r.RecordType.Name,IB_Event__r.Delivery_Mode__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Programme_Combination_Evaluation_Visits__c,IB_Event__r.Type,IB_Event__r.Event_Language__c,IB_Event__r.Sub_Type__c,
            LastModifiedDate, LastModifiedById, SystemModstamp, 
            Category__c, End_Date__c,Staffing_Event__c.IB_Event__r.Audience__c,Staffing_Event__c.IB_Programme_spanish__c, Event_Organizer__c, IB_Event__c, Programme_s__c, Staffing_Event_City__c, 
            Staffing_Event_Country__c, Staffing_Event__c.IB_Programme_french__c, Staffing_Event_State__c, Staffing_Event_Language_1__c, Staffing_Event_Language_2__c, Staffing_Event_Name__c, 
            Staffing_Event_Organizer__c, Staffing_Event_Region__c, Staffing_Event_Status__c, Staffing_Event_Sub_Region__c, 
            Staffing_Event_Type__c, Staffing_Event_Venue__c, Start_Date__c, Subject__c, Topic_Language_1__c, Topic_Language_2__c, Workshop_Product_Title__c,IB_Event__r.Programme_Relationship_Manager__c
            FROM Staffing_Event__c 
            LIMIT 10
        ];
    }   
    
    public static List<Campaign> getCampaigns(){
        return [
            SELECT Id, IsDeleted, Name, ParentId, Type, RecordTypeId, Status, StartDate, EndDate, CurrencyIsoCode, IB_Event_Record_Type__c,
            ExpectedRevenue, BudgetedCost, ActualCost, ExpectedResponse, NumberSent, IsActive, Description, NumberOfLeads, 
            NumberOfConvertedLeads, NumberOfContacts, NumberOfResponses, NumberOfOpportunities, NumberOfWonOpportunities, 
            AmountAllOpportunities, AmountWonOpportunities, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
            SystemModstamp, LastActivityDate, CampaignMemberRecordTypeId, 
            Proposed_Additional_IBE_Language__c, Proposed_IBE_Language_Level__c, Proposed_IBE_experience__c, IB_Department__c, 
            Actual_PAX__c, Estimated_PAX__c, Important_note_on_Start_Date__c, Cancellation_Waived__c, Workshop_Event_City__c, 
            Preferred_Start_Date_1__c, Important_note_on_End_Date__c, Letter_to_school__c, Letter_to_visiting_team__c, 
            RD_s_Letter_and_Report_to_School__c, Sub_Type__c, 
            Deadline_to_Submit_Docs__c, /*Evaluation_number__c,*/ Proposed_IBE_Knowledge_of_local_educ__c, IB_Docs_status_date__c, 
            
            Action_Plan_Due__c, SS_Event_Notes__c, School_Service_Team_Notes__c, AEM_Contact__c, SS_Event_Billed_Date__c, 
            DG_Letter_to_Global_Service__c, 
            Event_Notes__c, 
            Location_Rating__c, F_B_Rating__c, Workshop_Room_Rating__c, Accommodation_Rating__c, Status_Date__c, Status_Note__c, 
            External_PD_Provider__c, External_Reference_Number__c, Actual_Number_of_IBEN__c, Per_Capita__c, Budgeted_Revenue__c, 
            Actual_Revenue__c, Related_Programme__c, Regis_ID__c, Preferred_start_date_2__c, Account_City__c, RO_Contact__c, 
            Shool_Coordinator__c, Consultation_Visit_Date_Confirmed__c, IBE_Training_Comment__c, Topic_Language_1__c, 
            Topic_Language_3_del__c, Topic_Language_2__c, New_deadline__c,   Category__c, 
            Event_Type__c, Event_Organizer_Contact__c, Workshop_Programme__c, Next_Evaluation_Date__c, auto_number__c, 
            Report_Received__c,  Observer__c, IB_Docs_visit_preparation_due_date__c, 
            Visit_Agenda_in_IB_Docs_due_date__c, /* IB_Docs_ID__c, */
            Workshop_Subject__c, DO_NOT_DELETE_Programme_Op__c, Evaluation_outcome__c, Evaluation_MTBA__c, 
            X20_Hours_Confirmed__c, School_Documentation_for_IBE_uploaded__c, 
            Event_Organizer_Account__c, X40_Hours_Confirmed__c, Exam_Session__c, Exam_subjects__c, Expense_claim_processed__c, 
            Travel_arrangements__c, Issue_s_raised__c, Programme_del__c, DG_s_Letter_sent_to_School__c, 
            RD_s_Letter_sent_for_signature__c, Invoice_Issue_Date_for_Annual_Fee__c, Cross_Programme_2__c, Cross_Programme_3__c, 
            Action_Plan_New_Deadline__c, Action_Plan_format__c, Additional_Documents_for_MTBA_due__c, Account_IBIS_Code__c, 
            Alternative_Start_Date__c, Alternative_End_Date__c, X10_Hours_IBCC_Confirmed__c, 
            Expense_claim_received__c, Staff_Internally__c, Account_Country__c, Credit_Control_for_cand__c, Status_IB_Docs__c, 
            Report_Due_Date__c, Venue_Account__c, Workshop_Event_City_del__c, Print_Shop__c, Workshop_Event_Country_del__c, 
            Workshop_Event_Sub_Region_del__c, Workshop_Event_Region_del__c, Number_Iterations__c, Extra_Night_Cost__c, 
            Double_Occupancy_Cost__c, Visit_Report_Received__c, End_of_Consultation_Report_Received__c, Account_Region__c, 
            Estimated_No_of_IB_Staff__c, Actual_Number_of_IB_Staff__c, Length_of_Event__c, IB_Event_Description__c, 
            Orientation_Seminar_Event_Audience__c, Invoice_issue_date_for_AOC__c, Participant_Fee__c, Payment_received_date_AOC__c, 
            Invoice_issue_date_for_visits__c, Payment_received_date_for_visits__c, School_MEMO_1__c, School_MEMO_2__c, 
            School_MEMO_3__c, IB_Survey_requested__c, Certificates__c, IBEN_notes__c, Application_for_Authorization__c, 
            MTBA_Due_Date__c,   CV_End_Date__c, Consultation_Visit__c, 
            Duration__c, Event_ID__c,  External_Bodies__c, 
            Status_MTBA__c, Status_MTBA_date__c, DP_EV_Visit__c, Campaign_Record_Type_Flow__c, 
            Programme_Combination_Evaluation_Visits__c,  MTBA_Resolved__c, 
            MTBA_Remarks__c, MTBA_Date_received__c, MTBA_Type__c, TBC_Number_of_PAX__c, CFMD_Number_of_Pax__c, 
            Minimum_Number_of_PAX__c, Maximum_Number_of_PAX__c, Participant_Registration_Comment_Box__c, 
            Actual_Number_of_CFMD_Educators__c, Total_Number_of_Participants_IBEs__c, Registration_Deadline__c, 
            Actual_Number_of_CFMD_PFRs__c, Actual_Number_of_CFMD_PDREPs__c, Actual_Number_of_CFMD_SAMs__c, 
            Actual_Number_of_CFMD_Exhibitors__c, Actual_Number_of_CFMD_Session_Observers__c, Report_received_Tick__c, MTBA__c, 
            Status_Letter__c, MTBA_received__c, RD_Letter__c, Fee_Paid__c, Total_Number_of_CFMD_Parts_in_Main_Event__c, 
            Num_of_CFMD_Members_in_Main_Event__c, Registration_Deadline_of_the_Main_Event__c, Seg_5_code__c, 
            Invoice_issued_date__c, Payment_received_date__c, Telephone_number_Fax_Number__c, E_mail_address__c, 
            Project_Summary__c, Target_Audience__c,  Additional_details__c, Delivery_details__c, 
            Objectives__c, Internal_Client_name__c, 
            Type_of_Project__c, Project_status__c, Reason_Pending__c, 
            Approved_by__c,  Cost_Center__c, Briefing_Validation_Date__c, 
            Name_CM_project_manager__c, Region__c, 
            Calculation_of_No_of_CNFD_Educators__c, Department__c, 
            Before_Year_2011_Authorisation_Process__c, Partner_School_1__c, Partner_School_2__c, Partner_School_3__c, 
            Partner_School_4__c, Partner_School_5__c, Partner_School_6__c,  IBDOCS_ID_Opp__c, 
            Report_finalized__c, 
            Reason_for_Cancellation__c, Overall_Quality_of_Workshop__c, Preffered_Start_Date_3__c, 
            Status_Image__c, School_Questionnaire_Received__c, Approval_Q_Doc__c, Notes_Approval_Q_Doc__c, Parent_event_Seg_5__c, 
            Division__c, Consultant_Assigned_and_School_Notified__c, Feedback_Part_1_Spreadsheet_Uploaded__c, 
            AfC_Final_Response_to_School_Date__c, 
            Consultation_Visit_Revised_SSheet_Rep__c, X60_Hours_Confirmed__c, 
            Feedbacks_Published__c, Feedback_on_AfA_Uploaded_by_IB__c, 
            Report_on_School_Auth_published_by_IB__c, Cross_Programme_4__c, 
            Payment_Received_Date_for_AfC_Fee__c, Invoice_Issue_Date_for_AfC_Fee__c, 
            Invoice_Issue_Date_for_Candidate_Fee_Y2__c, 
            // Invoice_Issue_Date_for_Candidate_Fee_Y3__c, 
            CAS_Monitoring_Report_Received__c, 
            Feedback_frm_IBE__c, 
            IBIS_Status_Changed_and_Info_Updated__c, Questionnaire_Received__c, Signed_Statement_of_Acceptance_by_School__c, 
            Contract_Holder__c, Extension_of_candidacy__c, Import_Test_Lookup__c, Early_Bird_Registration_Fee__c, 
            Registrated_Pax__c, MTBA_Deadline__c, ERN_from_Parent__c, Status_details__c, Completed_project__c, 
            Programme_Visit_RecordType__c, PAX_from_Participant_School_1__c, PAX_from_Participant_School_2__c, 
            PAX_from_Participant_School_3__c, PAX_from_Participant_School_4__c, PAX_from_Participant_School_5__c, 
            Start_Date_from_Parent__c, End_Date_from_Parent__c, Workshop_Event_Country__c, Forecasted_PAX__c, 
            Goals_and_Objectives__c, Event_Language__c, Billed_21_days_prior__c, 
            General_Workshop_Satisfaction__c, Late_Fee__c,  Single_Room_Rate__c, Double_Room_Rate__c, 
            WiFi_Bedroom_Rate__c, Early_Bird_PAX__c,  Low_Sell_E_Blast__c, Targeted_Marketing__c, 
            Timestamp_Low_Sell_E_Blast__c, Timestamp_Targeted_Marketing__c, 
            Hotel_Name__c, Total_Leader_Fee__c, Hotel_Airport_Recommendation__c, Allowable_Attrition__c, WiFi_Meeting_Rate__c, 
            F_B_Minimum__c, Parking_Rate__c, Cut_off_Date__c, AV_Cost__c, Caterer_Details__c, F_B_Cost__c, Cancellation_Fee__c, 
            Airport_Transfer_Details__c, Workshop_Event_Sub_Region__c, Transportation_Confirmed__c, AV_Details__c, Airport__c, 
            Proof_of_Insurance__c, Participant_List_received__c, Budgeted_PAX__c,  Provider_Fee__c, 
            Estimated_Invoice__c, GDOC_Record_ID__c, Event_School_Coordinator__c,  Days_to_Event__c, 
            Workshop_Event_Region__c,  Number_of_hours__c, AfC_Date_of_Req_for_Late_Submission__c, 
            Payment_Received_Date_for_AfC_Late_Fee__c, AfC_Late_Fee_Invoice_sent__c, AfC_Date_of_Late_Submission__c, 
            Sum_Overall_Quality_of_WSL_s__c, Days_to_Registration_closure__c, Total_of_Event_Members__c, 
            Overall_Quality_of_WSL_s__c, Venue_Quality__c, Total_PAX_Reg_Fee__c, Preferred_End_Date_1__c, 
            Preferred_End_Date_3__c, Number_of_Students__c,  IBAP_IBEN_Remarks__c, Pickup_Day_1__c, 
            Pickup_Day_2__c, Pickup_Day_3__c, Date_for_Pre_Event_Check_in__c, Days_to_add_completely_new_WS__c, Days_to_CXL_WS__c, 
            Days_to_add_new_WS_section_WSL__c, X24_Advisory_Date__c, Pickup_Day_4__c, Pickup_Day_5__c, Present_Room_Pickup_perc__c, 
            Hotel_Rebate__c, OCC_Access_Code__c, Day_1__c, Day_2__c, Day_3__c, Day_4__c, Day_5__c, Total_Contracted_Room__c, 
            Participant_List_sent__c, Workbook_sent__c, Name_Badge_cost__c, Temp_Cost__c, Final_Rebate_OLD__c, Printing_Cost__c, 
            Misc_Cost__c, Misc_Cost_Comments__c, Sleeping_Room_Cost__c, Supplies_Cost__c, X24_Activate_Certificates__c, 
            Confirmed_with_School__c, Invoice_Amount__c, X1_week_MYP_email_sent__c, Approval_Date__c, Blended_Type__c, 
            Start_Date_for_F2F__c, End_Date_for_F2F__c, Start_Date_Online_Pt_1__c, End_Date_Online_Pt_1__c, 
            Start_Date_Online_Pt_2__c, End_Date_Online_Pt_2__c, X26_Cancellation_Date__c, X26_Advisory_Date__c, 
            X3_hour_component_sent__c, Total_Pickup__c, MYP_Invoice_paid__c, Request_Date__c, 
            Response_Total__c, Expectations_met__c, Workshop_Event_State__c, Extended_Registration_Deadline__c, Cancellation_Deadline__c, 
            PD_Staff_Onsite__c, Extended_Reg_Deadline_in_Main_Event__c, Total_Honorarium__c, Total__c, Total_Other_Expenses__c, 
            Total_Expenses__c, Final_Rebate__c, Application_Deadline__c, Confirmed_Number_of_Educators__c, 
            Event_Organizer_Region_Formula__c, Event_Organizer_Region__c, IBEN_Owner__c, IBEN_Training_Comment__c, IB_Programme__c, 
            IB_Role_2__c, IB_Role_3__c, IB_Role_Name_2__c, IB_Role_Name_3__c, IB_Role_Name__c, IB_Role_Name_s__c, IB_Role__c, 
            Positions_Left__c, Required_Number_of_Educators__c, Staffing_Event_Notice_Board__c, Staffing_Event_Published__c, 
            Traing_Event_Published__c, Training_Event_Notice_Board__c, Training_Event_Type__c, Training_Language__c, 
            Training_Pre_Requistes__c 
            FROM Campaign
        ];
    }
    
    public static List<IB_Role__c> getIbRoles(){
        return [SELECT Id, IB_Role__c, Programme_Selection__c,Continuum__c 
                FROM IB_Role__c];
    }   
    
    public static List<Account> getAccounts(){
        return [
            SELECT Id, IsDeleted, MasterRecordId, Name, Type, RecordTypeId, ParentId, BillingStreet, 
            BillingCity, BillingState, BillingStateCode, BillingPostalCode, BillingCountry, BillingCountryCode, BillingLatitude, BillingLongitude, 
            ShippingStreet, ShippingCity, ShippingState, ShippingStateCode, ShippingPostalCode, ShippingCountry, ShippingCountryCode,
            ShippingLatitude, ShippingLongitude, Phone, Fax, Website, Ownership, 
            Description, Site, CurrencyIsoCode, OwnerId, CreatedDate, CreatedById,  
            IsPartner, IsCustomerPortal, Jigsaw, JigsawCompanyId, AccountSource, SicDesc, Programme_Recognised__c, 
            Main_Session__c, IBIS_IMPORTED_SCHOOL_NAME__c, IBIS_IMPORTED_INST_EMAIL__c, 
            IBIS_IMPORTED_BILLING_CURRENCY__c, Country__c, Sub_region__c, Region__c, IBIS_IMPORTED_LEGAL_STATUS__c, 
            Country_Associations__c, IBIS_IMPORTED_COUNTRY__c, IBIS_ID__c, Policy_Statement__c, 
            Primary_Language_Of_Instruction__c, Secondary_Language_Of_Instruction__c, Language_Of_Correspondance__c, 
            Year_Founded__c, Legal_Name__c, IBIS_IMPORTED_DATE_TIME__c, Legal_Status__c, Diploma_Language_Exam__c, 
            IBIS_IMPORTED_WEB_SITE__c, recognition_policy__c, License_Agreement__c, University_Policy_or_Statement__c, 
            Source_Lead_RT__c, Country_Profile__c, Email__c, Programme_Statistics__c, Email_Opt__c, Policy_updated_on__c, 
            University_IBIS_Code__c, Institutional_Remarks__c, IBIS_School_Name_different_than_SF__c, 
            Flag_Different_Name_in_IBIS_and_SF__c, School_District__c, County__c, Billing_begins__c, State_Abbreviation__c, 
            IBEN_Accommodation_Rating__c, State_Abbr__c, Billing_Currency__c, State_Full_Name__c, In_partnership__c, 
            Status_in_partnership__c, Main_Partner__c, Partnership_Start_Date__c, Partnership_End_Date__c, 
            Country_Account__c, Lead_Institution__c, General_Guidelines__c, Country_Recognition_Requirements__c, 
            mail_specific__c, Alternative_Email__c, PD_Provider_Pwd__c, Group_of_School__c, School_County__c, 
            University_Contact_Notes__c, School_State__c, IBEN_Venue_Facility_Rating__c, Other_Institution__c, 
            Free_WiFi_in_Meeting_Rooms__c, Country_of_Governmental_Body__c, IBEN_Plenary__c, IBEN_Classroom_20__c, 
            IBEN_Classrooms_25__c, Free_Wired_Internet_for_WSL__c, IBEN_Catering__c, Meeting_Rooms_30__c, IBEN_Stars__c, 
            IBEN_Business_Center__c, IBEN_Free_WiFi__c, WiFi_Rate__c, IBEN_Location__c, IBEN_Transport__c, 
            Accommodation_Comments__c, Total_Number_of_Bedrooms__c, Total_Number_of_Meeting_Rooms__c, Weekend_Bedroom_Rate__c, 
            Extra_Night_Rate__c, IBEN_Tech_Equipment__c, Double_Occupancy_Rate__c, Weekly_Bedroom_Rate__c, Additional_Remarks__c, 
            Year_Authorized__c, Comments__c, Contract_Sign_Date__c, Institution_Type__c, Contract_Exp_Date__c, 
            External_PD_Provider__c, N_B__c, /*DP_Status_Roll_up__c,*/ DP_Programme_Status__c, Authorized_School__c, 
            /*PYP_Status_Roll_up__c,*/ PYP_Programme_Status__c, /*MYP_Status_Roll_up__c,*/ MYP_Programme_Status__c, 
            /*IBCC_Status_Roll_up__c,*/ IBCC_Programme_Status__c, School_Category__c 
            FROM Account
        ]; 
        //LastViewedDate, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastReferencedDate,
    }
    
    public static Account getAccount(Id accountId){
        return [
            SELECT Id, IsDeleted, MasterRecordId, Name, Type, RecordTypeId, ParentId, BillingStreet, 
            BillingCity, BillingState, BillingStateCode, BillingPostalCode, BillingCountry, BillingCountryCode, BillingLatitude, BillingLongitude, 
            ShippingStreet, ShippingCity, ShippingState, ShippingStateCode, ShippingPostalCode, ShippingCountry, ShippingCountryCode,
            ShippingLatitude, ShippingLongitude, Phone, Fax, Website, Ownership, 
            Description, Site, CurrencyIsoCode, OwnerId, CreatedDate, CreatedById,  
            IsPartner, IsCustomerPortal, Jigsaw, JigsawCompanyId, AccountSource, SicDesc, Programme_Recognised__c, 
            Main_Session__c, IBIS_IMPORTED_SCHOOL_NAME__c, IBIS_IMPORTED_INST_EMAIL__c, 
            IBIS_IMPORTED_BILLING_CURRENCY__c, Country__c, Sub_region__c, Region__c, IBIS_IMPORTED_LEGAL_STATUS__c, 
            Country_Associations__c, IBIS_IMPORTED_COUNTRY__c, IBIS_ID__c, Policy_Statement__c, 
            Primary_Language_Of_Instruction__c, Secondary_Language_Of_Instruction__c, Language_Of_Correspondance__c, 
            Year_Founded__c, Legal_Name__c, IBIS_IMPORTED_DATE_TIME__c, Legal_Status__c, Diploma_Language_Exam__c, 
            IBIS_IMPORTED_WEB_SITE__c, recognition_policy__c, License_Agreement__c, University_Policy_or_Statement__c, 
            Source_Lead_RT__c, Country_Profile__c, Email__c, Programme_Statistics__c, Email_Opt__c, Policy_updated_on__c, 
            University_IBIS_Code__c, Institutional_Remarks__c, IBIS_School_Name_different_than_SF__c, 
            Flag_Different_Name_in_IBIS_and_SF__c, School_District__c, County__c, Billing_begins__c, State_Abbreviation__c, 
            IBEN_Accommodation_Rating__c, State_Abbr__c, Billing_Currency__c, State_Full_Name__c, In_partnership__c, 
            Status_in_partnership__c, Main_Partner__c, Partnership_Start_Date__c, Partnership_End_Date__c, 
            Country_Account__c, Lead_Institution__c, General_Guidelines__c, Country_Recognition_Requirements__c, 
            mail_specific__c, Alternative_Email__c, PD_Provider_Pwd__c, Group_of_School__c, School_County__c, 
            University_Contact_Notes__c, School_State__c, IBEN_Venue_Facility_Rating__c, Other_Institution__c, 
            Free_WiFi_in_Meeting_Rooms__c, Country_of_Governmental_Body__c, IBEN_Plenary__c, IBEN_Classroom_20__c, 
            IBEN_Classrooms_25__c, Free_Wired_Internet_for_WSL__c, IBEN_Catering__c, Meeting_Rooms_30__c, IBEN_Stars__c, 
            IBEN_Business_Center__c, IBEN_Free_WiFi__c, WiFi_Rate__c, IBEN_Location__c, IBEN_Transport__c, 
            Accommodation_Comments__c, Total_Number_of_Bedrooms__c, Total_Number_of_Meeting_Rooms__c, Weekend_Bedroom_Rate__c, 
            Extra_Night_Rate__c, IBEN_Tech_Equipment__c, Double_Occupancy_Rate__c, Weekly_Bedroom_Rate__c, Additional_Remarks__c, 
            Year_Authorized__c, Comments__c, Contract_Sign_Date__c, Institution_Type__c, Contract_Exp_Date__c, 
            External_PD_Provider__c, N_B__c, /*DP_Status_Roll_up__c,*/ DP_Programme_Status__c, Authorized_School__c, 
            /*PYP_Status_Roll_up__c,*/ PYP_Programme_Status__c, /*MYP_Status_Roll_up__c,*/ MYP_Programme_Status__c, 
            /*IBCC_Status_Roll_up__c,*/ IBCC_Programme_Status__c, School_Category__c 
            FROM Account
            WHERE Id = :accountId
        ];
        //LastModifiedDate,  LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate,
    }  
    public static Opportunity getOpportunity(Id opportunityId) {
        // This Part is being Changed by Ammara-Plumlogix on 9-22-2019,US-11329
        //begin
        return [
            SELECT Id
            FROM Opportunity
            WHERE Id = :opportunityId
        ];
        //End
    }  
    
    public static List<IB_E_Background__c> getBackgrounds(){
        return [SELECT Id, Related_Subject_Area__c,RecordTypeId,IB_Contact__c
                FROM IB_E_Background__c];
    }
    
    public static IB_E_Background__c getBackgroundById(Id bId){
        return [SELECT Id, Related_Subject_Area__c
                FROM IB_E_Background__c
                WHERE ID = : bId];
    }
    
    public static List<Profile> getProfilesByNames(List<String> profileNames){
        return [SELECT Id 
                FROM Profile 
                WHERE Name IN : profileNames];
    }
    
    
    public static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '123457';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '123456';
        insert new List<Account> {acc1,acc2};
            
            Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id);
        insert new List<Opportunity> {opp1,opp2};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        Campaign camp3 = TestsUtil.createCampaign('camp test name 3', acc2.Id, opp2.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2,camp3};
            
            }
    
    
    public static void initMyStaffingEventRedirectionRules(String currentUserProfileName){
        
        String separator = ',';
        
        List<String> ibEducatorProfileNames = new List<String>{'Customer Community Advanced'};
            List<String> internalProfileNames = new List<String>{'IBAP IBEN', 'IBA IBEN', 'System Administrator'};
                
                if(String.isNotBlank(currentUserProfileName)){
                    ibEducatorProfileNames.add(currentUserProfileName);    
                }
        
        
        List<Profile> profiles = getProfilesByNames(ibEducatorProfileNames);
        String idsStr = getShortIdsAsString(profiles, separator);
        System.debug('idsStr===='+idsStr);
        
        MyStaffingEventRedirectionRules__c myStafEvent1 = createMyStafEventRedirectRule(
            COMMUNITY_NAME_IB_EDUCATOR, COMMUNITY_NAME_IB_EDUCATOR, '/apex/registerForEventsIbenPortal', idsStr);
        
        profiles = getProfilesByNames(internalProfileNames);
        idsStr = getShortIdsAsString(profiles, separator);
        
        MyStaffingEventRedirectionRules__c myStafEvent2 = createMyStafEventRedirectRule(
            COMMUNITY_NAME_INTERNAL, COMMUNITY_NAME_INTERNAL, '/apex/registerForEventsInternal', idsStr);
        
        insert new List<MyStaffingEventRedirectionRules__c>{ myStafEvent1, myStafEvent2 };
            }
    
    
    
    public static String getIdsAsString(List<Id> ids, String separator){
        String idsStr = String.join(ids, separator);
        return idsStr;
    } 
    
    
    public static String getIdsAsString(List<SObject> sobjs, String separator){
        
        List<Id> ids = new List<Id>();
        
        for (SObject so : sobjs){
            ids.add(so.Id);
        }
        String idsStr = String.join(ids, separator);
        
        return idsStr;
    }   
    
    public static String getShortIdsAsString(List<SObject> sobjs, String separator){
        
        List<String> ids = new List<String>();
        
        for (SObject so : sobjs){
            ids.add(String.valueOf(so.Id).substring(0,15));
        }
        String idsStr = String.join(ids, separator);
        
        return idsStr;
    }  
    
    
    
    // Method creates instances of:
    // IB_Country_Segmentation__c, Contact
    // Campaign, Account, Staffing_Event__c, My_Staffing_Event__c,  
    // IB_Event_Role__c, IB_Role__c, IB_Role_Repository__c
    public static void initMyStaffingEvents(){
        
        initCampaigns();
        
        List<Campaign> campaigns = getCampaigns();
        List<Account> accounts = getAccounts();
        
        initStaffingEvents(campaigns, accounts);
        
        List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
        
        initIbEventRoles(staffingEvents);
        
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        
        initMyStaffingEvents(ibEventRoles, staffingEvents, accounts);
    }
    
    
    
    public static void initIbEventRoles(List<Staffing_Event__c> staffingEvents){
        //
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
        IB_Event_Role__c ibEventRole3 = TestsUtil.createIbEventRole(20, staffingEvents.get(2).IB_Event__c);
        
        ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
        ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
        ibEventRole3.Staffing_Event__c = staffingEvents.get(2).Id;
        
        insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2,ibEventRole3};
            }
    
    
    public static void initMyStaffingEvents(List<IB_Event_Role__c> ibEventRoles, List<Staffing_Event__c> staffingEvents, List<Account> accounts){
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accounts.get(0));
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherState = 'Florida';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'United States';
        con1.Country__c = country.id;
        
        Contact con2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
        con2.OtherStreet = 'other_street2';
        con2.OtherCity = 'other_city2';
        con2.OtherState = 'Florida';
        con2.OtherPostalCode = 'postal2';
        con2.OtherCountry = 'United States';
        con2.Country__c = country.id;
        con2.Phone = '+9212345607865';
        
        insert new List<Contact>{con1, con2};
            Contact cont1 = TestsUtil.getContact(con1.id);
        Contact cont2 = TestsUtil.getContact(con2.id);
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont1.Id);
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo.Id, cont2.Id);
        insert new List<IB_Role__c> {ibRole1, ibRole2};
            
            // Ib Event Role's IB_Event__c field value is reference to Campaign
            My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', accounts.get(0).Id, 
                                                                                 ibEventRoles.get(0).IB_Event__c, null, ibRole1.Id);
        
        myStaffEvent1.IB_Contact__c = cont1.id;     
        myStaffEvent1.Staffing_Event__c = staffingEvents.get(0).Id; 
        
        My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', accounts.get(0).Id, 
                                                                             ibEventRoles.get(1).IB_Event__c, null, ibRole2.Id);
        
        myStaffEvent2.IB_Contact__c = cont2.id;     
        myStaffEvent2.Staffing_Event__c = staffingEvents.get(1).Id;
        List<My_Staffing_Event__c> listOfNewStaffingEvents = new List<My_Staffing_Event__c>();
        listOfNewStaffingEvents.add(myStaffEvent1);
        listOfNewStaffingEvents.add(myStaffEvent2);
        //EMS - Tarun Sharma --203747 START
        if(ibEventRoles!=null && ibEventRoles.size()>2){ 
            My_Staffing_Event__c myStaffEvent3 = TestsUtil.createMyStaffingEvent('test_staf_name_003', accounts.get(0).Id, ibEventRoles.get(2).IB_Event__c, null, ibRole2.Id);
            myStaffEvent3.IB_Contact__c = cont2.id;
            myStaffEvent3.Staffing_Event__c = staffingEvents.get(2).Id;
            listOfNewStaffingEvents.add(myStaffEvent3);
        }
        insert listOfNewStaffingEvents;
        //EMS - Tarun Sharma --203747 END     
        system.debug(loggingLevel.ERROR, 'myStaffEvent1: ' + myStaffEvent1);
        system.debug(loggingLevel.ERROR, 'myStaffEvent2: ' + myStaffEvent2);
    }
    
    public static void initMyStaffingEventsPL(List<IB_Event_Role__c> ibEventRoles, List<Staffing_Event__c> staffingEvents, List<Account> accounts, IB_Role_Repository__c repo){
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accounts.get(0));
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherState = 'Florida';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'United States';
        con1.Country__c = country.id;
        
        Contact con2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
        con2.OtherStreet = 'other_street2';
        con2.OtherCity = 'other_city2';
        con2.OtherState = 'Florida';
        con2.OtherPostalCode = 'postal2';
        con2.OtherCountry = 'United States';
        con2.Country__c = country.id;
        con2.Phone = '+9212345607865';
        
        insert new List<Contact>{con1, con2};
            Contact cont1 = TestsUtil.getContact(con1.id);
        Contact cont2 = TestsUtil.getContact(con2.id);
        
        //IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        // repo.Role_Name__c = 'Programme Leader';
        // insert repo;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont1.Id);
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo.Id, cont2.Id);
        insert new List<IB_Role__c> {ibRole1, ibRole2};
            
            // Ib Event Role's IB_Event__c field value is reference to Campaign
            My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', accounts.get(0).Id, 
                                                                                 ibEventRoles.get(0).IB_Event__c, null, ibRole1.Id);
        
        myStaffEvent1.IB_Contact__c = cont1.id;     
        myStaffEvent1.Staffing_Event__c = staffingEvents.get(0).Id; 
        myStaffEvent1.IB_Event_Role__c = ibEventRoles.get(0).id;
        myStaffEvent1.IB_Role__c = repo.id;
        
        if(ibEventRoles.size()>1){
            My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', accounts.get(0).Id, 
                                                                                 ibEventRoles.get(1).IB_Event__c, null, ibRole2.Id);
            
            myStaffEvent2.IB_Contact__c = cont2.id;     
            myStaffEvent2.Staffing_Event__c = staffingEvents.get(1).Id;
            myStaffEvent2.IB_Event_Role__c = ibEventRoles.get(1).id;
            myStaffEvent2.IB_Role__c = repo.id;
            
            insert new List<My_Staffing_Event__c>{myStaffEvent1, myStaffEvent2};
                system.debug(loggingLevel.ERROR, 'myStaffEvent1: ' + myStaffEvent1);
            system.debug(loggingLevel.ERROR, 'myStaffEvent2: ' + myStaffEvent2);
        }
        else
            insert myStaffEvent1;
    }
    
    
    public static void initStaffingEvents(List<Campaign> campaigns, List<Account> accounts){
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', campaigns.get(0).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', campaigns.get(1).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent3 = TestsUtil.createStaffingEvent('test_name_st_event_003', campaigns.get(2).Id, accounts.get(0).Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        staffEvent3.RecordTypeId = staffEventRecTypeId;
        insert new List<Staffing_Event__c>{staffEvent1, staffEvent2, staffEvent3};
            }
    
  
    public static IBENApiRequest__c IBENApiRequests(String firstname, String lastname, String Email, Date birthdate){
       
          IB_Role_Repository__c repo = new IB_Role_Repository__c(
                Available__c=true,
                SF_Role_Application__c=true,
                Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                CurrencyIsoCode='EUR',
                Role_Name__c='Teacher',
                Category__c='Learning Centre',
                Role_Level__c='Fully Qualified;',
                Sub_Category__c='Administration',
                Related_Programmes__c='PYP;MYP;DP;IBCC',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true);
        
        Insert repo;
        
        List<IB_Role_Repository__c> roleIDList = New List<IB_Role_Repository__c>([Select Id from IB_Role_Repository__c Where Role_Name__c ='Teacher']);
        return new IBENApiRequest__c (
            FirstName__c = firstname,
            LastName__c = lastname,
            Legal_first_name__c = firstname,
            Legal_Last_name__c = lastname,
            Email__c = Email,
            Birthdate__c = birthdate,
            IB_Role__c = roleIDList[0].Id,
            Request_Processed__c = false
          //  Contact_ID__c = CId
        );
    }    
    
}