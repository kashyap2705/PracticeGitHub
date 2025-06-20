@isTest public class IBECMgmRolesHandlerTest {
 public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3{get; set;}
    public static IB_Role__c ibRole4{get; set;}
    public static User u;
    
    public static IB_Address__c address {get; set;}
    @testSetup static void setup() {
        repo = TestsUtil.createRoleRepo();
        repo.Category__c = 'School Services';
        repo.Role_Name__c = 'IBEC University Administrator';
        insert repo;
        
        repo2 = TestsUtil.createRoleRepo();
        repo2.Category__c = 'School Services';
        repo2.Role_Name__c = 'IBEC Candidate';
        insert repo2;
        
        Account acc = PimsTestUtil.createAccount('test', 'School Account' );
        acc.ibis_id__c='012111';
        
        insert acc;
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
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
        
    Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci2;
        
        ibRole1 = TestsUtil.createIbRole(repo2.Id, con.Id);
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
        ibRole3.Status__c = 'Confirmed';
        ibRole3.Email_Confirmed__c=true;
        ibRole3.IB_Account__c = acc.id;
        ibRole3.End_date__c = date.today()+7;
        ibRole3.Contact_Information_Email__c=ci.id;
        ibRole3.Contact_Information_Phone__c=ci2.id;
        ibRole3.Role_Level__c = 'Fully Qualified';
        insert ibRole3;
        
        ibRole4 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole4.Contact_Information_Email__c=ci.id;
        ibRole4.Contact_Information_Phone__c=ci2.id;
        ibRole4.IB_Account__c = acc.id;
        ibRole4.status__c='Confirmed';
        ibRole4.Email_Confirmed__c=true;
        insert ibRole4;
    }
    @isTest
    public static void TestEngUser()
    {
        list<id> accList =  new list<Id>();
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
    con.User_Language__c = 'en_US';
    update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Institute_Administrator__c,Email__c,Contact_name__c,Institute_Administrator_Email__c,Institute_Administrator_Name__c,Status__c,Institute_Active_Status__c,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 3];
            List<ib_role__c>roleList1=[select id,Institute_Administrator__c,Email__c,Contact_name__c,Institute_Administrator_Email__c,Institute_Administrator_Name__c,Status__c,Institute_Active_Status__c,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c='Confirmed' limit 1];
            new IBECMgmRolesHandler().ProcessIBECRoles(roleList1);
            for(ib_role__c role: roleList){
                accList.add(role.IB_Account__c);
            }
            new IBECMgmRolesHandler().SendEmailtoIBECAdminForApplicant(roleList,accList);
        }
        Test.stopTest();
    }
  @isTest
    public static void TestSpUser()
    {
        list<id> accList =  new list<Id>();
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
    con.User_Language__c = 'es';
    update con;
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Status__c,Institute_Active_Status__c,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,Contact_name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 3];
            new IBECMgmRolesHandler().ProcessIBECRoles(roleList);
            for(ib_role__c role: roleList){
                accList.add(role.IB_Account__c);
            }
            new IBECMgmRolesHandler().SendEmailtoIBECAdminForApplicant(roleList,accList);
            
            
        }
        Test.stopTest();
    }
  @isTest
    public static void TestFrUser()
    {
        list<id> accList =  new list<Id>();
        u = new User(Id = UserInfo.getUserId());
        con=[select id,User_Language__c from contact limit 1][0];
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {
            List<ib_role__c>roleList=[select id,Status__c,Institute_Active_Status__c,IB_Contact__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,Role_Level__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Account_Name__c,Contact_name__c,IB_Role_Name__c,Job_Title__c,IB_Role__c,Active__c,Email_Confirmed__c,IB_Account__c,Contact_Information_Email__c,Contact_Information_Phone__c,Programme_Language_of_Correspondence__c from IB_Role__c where status__c!='Confirmed' limit 3];
            new IBECMgmRolesHandler().ProcessIBECRoles(roleList);
            for(ib_role__c role: roleList){
                accList.add(role.IB_Account__c);
            }
            new IBECMgmRolesHandler().SendEmailtoIBECAdminForApplicant(roleList,accList);
            
            
        }
        Test.stopTest();
    }
}