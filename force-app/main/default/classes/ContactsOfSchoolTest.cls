@isTest
public class ContactsOfSchoolTest {
    
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static Contact con1{get; set;}
    public static Contact con2{get; set;}
    public static IB_Role_Repository__c repo {get; set;}
    // public static IB_Role__c ibRole1 {get; set;}
    
    
    
    
    Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
    
    
    @isTest
    static void MyIBRolesControllerTestMethod()
    {
        
        Profile p = [select Id,name from Profile where name='Customer Service - Level 4' limit 1];
        
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        User user = UserService.getUser();
        
        System.runAs(user)
        {
            user.Bypass_Validation_Rules__c = true;
            update user;
            insert new PermissionSetAssignment(AssigneeId = user.id, PermissionSetId = ps.Id); 
        }
        
        
        Account acc=new Account ( 
            Name = 'John123',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'John123',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA');
        
        acc = PimsTestUtil.createAccount('test', 'School Account' );//IB Institute
        acc.ibis_id__c='N050234';
        acc.country__c='UNITED STATES';
        acc.State_Abbr__c ='AK';
        acc.IBIS_ID__c='001294';
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId();//School Account
        
        insert acc;
        
        acc.IsPartner=true;
        update acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        con.IB_Staff__c = 'Current'; 
        con.User_IsPortalEnabled__c = true;
        
        con1 = PimsTestUtil.createContact('Test11 Contacttest 1', 'a123412@a.com', 'aedefrf@a.com', Date.newInstance(1990, 1, 1), acc);
        con1.AccountId=acc.id;
        con1.IB_Staff__c = 'Current'; 
        con1.User_IsPortalEnabled__c = true;
        insert con1;
        
        
        con2 = PimsTestUtil.createContact('Testwew11 Contacttest 1', 'a1234eeced12@a.com', 'aeeefefdefrf@a.com', Date.newInstance(1994, 1, 1), acc);
        con2.AccountId=acc.id;
        con2.IB_Staff__c = 'Current'; 
        con2.User_IsPortalEnabled__c = true;
        insert con2;
        
        insert con;
        
        
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibo.org', false);
        
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'CP');
        progRec.StageName__c = 'Evaluation';
        progRec.Status__c = 'Authorized';
        progRec.Owner__c=user.id;
        progRec.Date_Decision_on_Authorization__c=Date.newInstance(2025, 12, 9);
        progRecList.add(progRec);
        insert progRecList;
        
        System.runAs(user)
        {
            u.ContactId=con.Id;
            insert u;
        }
        
        Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con.id, Email__c = 'test@test.com');
        insert ci;
        Contact_Information__c ci1 = new Contact_Information__c(IB_Contact__c = con1.id, Phone__c = '1234567');
        insert ci1;
        
        initCustomSettings();
        
        /** repo = TestsUtil.createRoleRepo();
repo.Role_Name__c = 'Institute Administrator';
repo.Display_in_MyIB__c=true;
repo.Available_From__c=Null;
repo.Available_From__c=Null;
insert repo;
ibRole1 = TestsUtil.createIbRole(repo.Id, con.id);
ibRole1.Email_Confirmed__c = true;
ibRole1.IB_Account__c = acc.id;
ibRole1.Contact_Information_Email__c=ci.id;
ibRole1.Contact_Information_Phone__c=ci1.id;
ibRole1.Job_Title__c='ibRole1';
insert ibRole1;**/
        
        
        
        IB_Role_Repository__c tmpRepo = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Teacher',
            Role_type__c = 'IBEN Role',
            Category__c = 'Professional Development' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        insert tmpRepo;
        IB_Role_Repository__c tmpRepo1 = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Programme Leader',
            Role_type__c = 'School Role',
            Category__c = 'Professional Development' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        //tmpRepo1.Role_Name__c = 'Programme Leader';
        insert tmpRepo1;
        
        //initCustomSettings();
        IB_Role_Repository__c tmpRepo2 = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Evaluation Leader',
            Role_type__c = 'IBEN Role',
            MyIB_Max_Number_of_this_Role__c = 5,
            Category__c = 'School Services' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        //tmpRepo2.Role_Name__c = 'Evaluation Leader';
        insert tmpRepo2;
        
        
        
        IB_Role_Repository__c tmpRepoCIRole = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Chief Invigilator',
            Role_type__c = 'School Role',
            MyIB_Max_Number_of_this_Role__c = 5,
            Category__c = 'School Services' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        insert tmpRepoCIRole;
        
        
        IB_Role_Repository__c tmpRepoPCRole = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Programme Coordinator',
            Role_type__c = 'IBEN Role',
            MyIB_Max_Number_of_this_Role__c = 5,
            Category__c = 'School Services' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        insert tmpRepoPCRole;
        
        
        
        
        
        
        
        
        
        List<IB_Role__c> abc = new List<IB_Role__c>();
        IB_Role__c roleRecord1 = new IB_Role__c ();
        
        roleRecord1.Reason_For_Status__c = 'Confirmed';
        roleRecord1= TestsUtil.createIbRole(tmpRepo1.Id, con.Id);
        roleRecord1.IB_Contact__c=u.ContactId;
        roleRecord1.IB_Account__c=acc.id;
        roleRecord1.Job_Title__c='Test';
        roleRecord1.Contact_Information_Email__c=ci.id;
        roleRecord1.Contact_Information_Phone__c=ci1.id;
        
        abc.add(roleRecord1);
        
        IB_Role__c roleRecord2 = new IB_Role__c ();
        roleRecord2= TestsUtil.createIbRole(tmpRepo2.Id, con.Id);
        roleRecord2.IB_Account__c=acc.id;
        roleRecord2.Job_Title__c='Test';
        roleRecord2.Reason_For_Status__c = 'Confirmed';
        roleRecord2.Contact_Information_Email__c=ci.id;
        
        
        roleRecord2.Contact_Information_Phone__c=ci1.id;
        
        abc.add(roleRecord2);
        
         /**List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'CP');
        progRecList.add(progRec);
        insert progRecList;**/
                
                
        IB_Role__c roleRecord3 = new IB_Role__c ();
        roleRecord3= TestsUtil.createIbRole(tmpRepoCIRole.Id, con.Id);
        roleRecord3.IB_Account__c=acc.id;
        roleRecord3.Job_Title__c='Test';
        roleRecord3.Contact_Information_Email__c=ci.id;
        roleRecord3.Contact_Information_Phone__c=ci1.id;
        roleRecord3.Reason_For_Status__c = 'Confirmed';
        roleRecord3.Disable_CI_Role__c = false;
        roleRecord3.IB_Programme_New__c=progRecList[0].id;
        
        IB_Role__c roleRecord4 = new IB_Role__c ();
        roleRecord4= TestsUtil.createIbRole(tmpRepoPCRole.Id, con.Id);
        roleRecord4.IB_Account__c=acc.id;
        roleRecord4.Job_Title__c='Test';
        roleRecord4.Contact_Information_Email__c=ci.id;
        roleRecord4.Contact_Information_Phone__c=ci1.id;
        roleRecord4.Reason_For_Status__c = 'Confirmed';
        roleRecord4.Programme_Selection__c = 'CP';
        
         Contact_Information__c ci2 = new Contact_Information__c(IB_Contact__c = con1.id, Email__c = 'tes56565t@test.com');
        insert ci2;
        
        IB_Role__c roleRecord5 = new IB_Role__c ();
        roleRecord5= TestsUtil.createIbRole(tmpRepo2.Id, con2.Id);
        roleRecord5.IB_Account__c=acc.id;
        roleRecord5.Job_Title__c='Test';
        roleRecord5.Contact_Information_Email__c=ci2.id;
        roleRecord5.Contact_Information_Phone__c=ci1.id;
        roleRecord5.Reason_For_Status__c = 'Confirmed';
        roleRecord5.Disable_CI_Role__c = false;
        
        abc.add(roleRecord3);
        abc.add(roleRecord4);
         // abc.add(roleRecord5);
        
       
      /**    Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con.id, Email__c = 'test@test.com');
        insert ci;
        Contact_Information__c ci1 = new Contact_Information__c(IB_Contact__c = con1.id, Phone__c = '1234567');
        insert ci1;**/
        
        IB_Role__c roleRecordCIRoleNew = new IB_Role__c ();
        roleRecordCIRoleNew= TestsUtil.createIbRole(tmpRepoCIRole.Id, con1.Id);
        roleRecordCIRoleNew.IB_Account__c=acc.id;
        roleRecordCIRoleNew.Job_Title__c='Test';
        roleRecordCIRoleNew.Contact_Information_Email__c=ci2.id;
        roleRecordCIRoleNew.Contact_Information_Phone__c=ci1.id;
        roleRecordCIRoleNew.Reason_For_Status__c = 'Confirmed';
        roleRecordCIRoleNew.Disable_CI_Role__c = false;
        roleRecordCIRoleNew.Programme_Selection__c = 'CP';
        roleRecordCIRoleNew.IB_Programme_New__c=progRecList[0].id;
        //insert roleRecordCIRoleNew;
        abc.add(roleRecordCIRoleNew);
        Test.startTest();
        
        Conflict_of_Interest__c coi= new Conflict_of_Interest__c();
        coi.IB_Account__c=acc.id;
        coi.IB_Contact__c=con.id;
        insert coi;
        
        insert abc;
        system.debug('abc***'+abc);
        
        List<Id> withDrawalContactIds= new List<Id>();
        withDrawalContactIds.add(con1.id);
        
        
        List<Id> contactIds= new List<Id>();
        contactIds.add(con2.id);        
        contactIds.add(con.id);   
        
         List<IB_Role__c> roleList= new List<IB_Role__c>();
            roleList.add(roleRecordCIRoleNew);
              
        
        ContactsOfSchool.upsertRolesOfConatct('CP',acc.id,contactIds ,withDrawalContactIds);
        
        ContactsOfSchool.getAllContactsOfSchool(acc.id);
        
        ContactsOfSchool.sendEmailToConfirmedContact(contactIds,roleList);
        
        
        ContactsOfSchool.sendEmailToWithDrawalContact(withDrawalContactIds, acc.id,'CP');
        
        
        ContactsOfSchool.getTranslationsMap('French');
        Test.stopTest();
    }
    
    private static void initCustomSettings () {
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = '1';
        profDevConf.professionalDevelopmentCampList__c = '1,2,3';
        insert profDevConf;
    }    
}