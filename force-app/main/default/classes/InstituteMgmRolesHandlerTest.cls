@isTest
public class InstituteMgmRolesHandlerTest {
    public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static IB_Role_Repository__c repo3{get; set;}
    public static IB_Role_Repository__c repo4{get; set;}
        public static IB_Role_Repository__c repo5{get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3{get; set;}
    public static IB_Role__c ibRole4{get; set;}
    public static IB_Role__c ibRole5{get; set;}
    public static IB_Role__c ibRole6{get; set;}
        public static IB_Role__c ibRole7{get; set;}

    public static User u;
    
    public static IB_Address__c address {get; set;}
    @testSetup static void setup() {
        repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Institute Administrator';
        insert repo;
        
        repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
        
        repo3 = TestsUtil.createRoleRepo();
        repo3.Role_Name__c = 'IBEC University Administrator';
        insert repo3;
        
        repo4 = TestsUtil.createRoleRepo();
        repo4.Role_Name__c = 'IBEC Candidate';
        insert repo4;
         repo5 = TestsUtil.createRoleRepo();
        repo5.Role_Name__c = 'Association Admin';
        insert repo5;
        Account acc = PimsTestUtil.createAccount('test', 'School Account' );
        acc.ibis_id__c='012111';
        
        insert acc;
        Contact con = PimsTestUtil.createContact('Test Contact', 'a112@a.com', 'a112@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
    //con.User_Language__c = 'en_US';
        insert con;
        
        IB_Country_Segmentation__c country1 = TestsUtil.createCountry('ABC','IBAEM',acc);
        insert country1;
        
        //Insert IB Address Record
        address = new IB_Address__c();
        address.Name = 'Testing Address';
        address.Status__c = 'Active';
        address.Address_Line_1__c = 'Bahria Town';
        address.City__c = 'Lahore';
        address.Postal_Code__c = '2021';
        address.Country__c = country1.Id;
        address.IB_Account__c=acc.id;
        insert address;
        
    Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test123@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci2;
        
        ibRole1 = TestsUtil.createIbRole(repo.Id, con.Id);
        ibRole1.Status__c = 'Applicant';
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Contact_Information_Email__c=ci.id;
        ibRole1.Contact_Information_Phone__c=ci2.id;
        ibRole1.Email_Confirmed__c=true;
        ibRole1.Role_Level__c = 'Fully Qualified';
        insert ibRole1;
        
        ibRole2 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole2.Status__c = 'Confirmed';
        ibRole2.IB_Account__c = acc.id;
        ibRole2.Contact_Information_Email__c=ci.id;
        ibRole2.Contact_Information_Phone__c=ci2.id;
        ibRole2.Role_Level__c = 'Fully Qualified';
        ibRole2.Email_Confirmed__c=true;
        insert ibRole2;
        
        ibRole3 = TestsUtil.createIbRole(repo2.Id, con.id);
        ibRole3.Status__c = 'Applicant';
        ibRole3.Email_Confirmed__c=false;
        ibRole3.IB_Account__c = acc.id;
        ibRole3.Email_Confirmed__c=true;
        ibRole3.Contact_Information_Email__c=ci.id;
        ibRole3.Contact_Information_Phone__c=ci2.id;
        ibRole3.Role_Level__c = 'Fully Qualified';
        insert ibRole3;
        
        ibRole4 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole4.Contact_Information_Email__c=ci.id;
        ibRole4.Contact_Information_Phone__c=ci2.id;
        ibRole4.status__c='Confirmed';
        ibRole4.Email_Confirmed__c=true;
        //ibRole4.Role_Name__c='Institute Administrator';
        //ibRole4.Role_Level__c = 'Fully Qualified';
        insert ibRole4;
        
        ibRole5 = TestsUtil.createIbRole(repo3.Id, con.id);
        ibRole5.Status__c = 'Confirmed';
        ibRole5.IB_Account__c = acc.id;
        ibRole5.Contact_Information_Email__c=ci.id;
        ibRole5.Contact_Information_Phone__c=ci2.id;
        ibRole5.Role_Level__c = 'Fully Qualified';
        ibRole5.Email_Confirmed__c=true;
        insert ibRole5;
        
        ibRole6 = TestsUtil.createIbRole(repo4.Id, con.id);
        ibRole6.Status__c = 'Applicant';
        ibRole6.Email_Confirmed__c=false;
        ibRole6.IB_Account__c = acc.id;
        ibRole6.Email_Confirmed__c=true;
        ibRole6.Contact_Information_Email__c=ci.id;
        ibRole6.Contact_Information_Phone__c=ci2.id;
        ibRole6.Role_Level__c = 'Fully Qualified';
        insert ibRole6;
        
           ibRole7 = TestsUtil.createIbRole(repo5.Id, con.id);
        ibRole7.Status__c = 'Confirmed';
        ibRole7.Email_Confirmed__c=true;
        ibRole7.IB_Account__c = acc.id;
        ibRole7.Email_Confirmed__c=true;
        ibRole7.Contact_Information_Email__c=ci.id;
        ibRole7.Contact_Information_Phone__c=ci2.id;
        ibRole7.Role_Level__c = 'Fully Qualified';
        insert ibRole7;
        
    }
    @isTest
    public static void TestEngUser()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
    	con.User_Language__c = 'en_US';
    	update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Institute_Administrator__c,Contact_Information_Email__r.email__c,
                                      IB_Contact__r.User__r.Email,Email__c,Contact_name__c,Institute_Administrator_Email__c,
                                      Institute_Administrator_Name__c,Status__c,Institute_Active_Status__c,IB_Contact__c,
                                      ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,
                                      IB_Role_Name_es__c,Account_Name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,
                                      Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,
                                      Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 4 ];
            InstituteMgmRolesHandler.isFirstRun=false;
            system.debug('show the roles data'+roleList);
            new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
            new InstituteMgmRolesHandler().SendEmailtoAdminForApplicant(roleList);
            new InstituteMgmRolesHandler().sendEmailtoAdminsForApplicantEmailConfirmedMatched(roleList);
                         new InstituteMgmRolesHandler().SendEmailtoAIBWSAdminForApplicant(roleList);
            for(IB_Role__c r : roleList)
            {
                r.Email_Confirmed__c = false;
            }
            update roleList;
            new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(roleList);
            new InstituteMgmRolesHandler().updateInstituteAdmin(roleList);
            new InstituteMgmRolesHandler().updateInstituteroles(roleList);
         //   for(IB_Role__c r : roleList)
           // {
             //   r.status__c = 'Confirmed';
            //}
            //update roleList;
              //new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
        }
        Test.stopTest();
    }
  @isTest
    public static void TestSpUser()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
    con.User_Language__c = 'es';
    update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Status__c,Institute_Active_Status__c,Contact_Information_Email__r.email__c,IB_Contact__r.User__r.Email,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,Contact_name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 4];
            InstituteMgmRolesHandler.isFirstRun=false;
            new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
            new InstituteMgmRolesHandler().SendEmailtoAdminForApplicant(roleList);
            new InstituteMgmRolesHandler().sendEmailtoAdminsForApplicantEmailConfirmedMatched(roleList);
            for(IB_Role__c r : roleList)
            {
                r.Email_Confirmed__c = false;
            }
            update roleList;
            new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(roleList);
            
            
        }
        Test.stopTest();
    }
  @isTest
    public static void TestFrUser()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
        con.User_Language__c = 'fr';
        update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Status__c,Institute_Active_Status__c,Contact_Information_Email__r.email__c,IB_Contact__r.User__r.Email,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,Contact_name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 4];
            InstituteMgmRolesHandler.isFirstRun=false;
            new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
            new InstituteMgmRolesHandler().SendEmailtoAdminForApplicant(roleList);
            new InstituteMgmRolesHandler().sendEmailtoAdminsForApplicantEmailConfirmedMatched(roleList);
            for(IB_Role__c r : roleList)
            {
                r.Email_Confirmed__c = false;
            }
            update roleList;
            new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(roleList);
            
            
        }
        Test.stopTest();
    }
     @isTest
    public static void TestEngUser2()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
    	con.User_Language__c = 'en_US';
    	update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Institute_Administrator__c,Contact_Information_Email__r.email__c,
                                      IB_Contact__r.User__r.Email,Email__c,Contact_name__c,Institute_Administrator_Email__c,
                                      Institute_Administrator_Name__c,Status__c,Institute_Active_Status__c,IB_Contact__c,
                                      ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,
                                      IB_Role_Name_es__c,Account_Name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,
                                      Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,
                                      Programme_Language_of_Correspondence__c from IB_Role__c limit 4 ];
            InstituteMgmRolesHandler.isFirstRun=false;
            system.debug('show the roles data'+roleList);
            new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
            new InstituteMgmRolesHandler().SendEmailtoAdminForApplicant(roleList);
            new InstituteMgmRolesHandler().sendEmailtoAdminsForApplicantEmailConfirmedMatched(roleList);

            new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(roleList);
            new InstituteMgmRolesHandler().updateInstituteAdmin(roleList);
            new InstituteMgmRolesHandler().updateInstituteroles(roleList);
         //   for(IB_Role__c r : roleList)
           // {
             //   r.status__c = 'Confirmed';
            //}
            //update roleList;
              //new InstituteMgmRolesHandler().ProcessInstitueRoles(roleList);
        }
        Test.stopTest();
    }
}