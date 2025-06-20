@isTest
public class InstituteSearchEmailComponentTest {
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static User u;
    @testSetup static void setup() {
        Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        
        insert acc;
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
    }
    @isTest public static void EmailTest()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        PageReference IBECRole = Page.IBECApplyForRole;
            Test.setCurrentPage(IBECRole);
        List<IB_Role_Repository__c> repo = [Select id from IB_Role_Repository__c];
        ApexPages.currentPage().getParameters().put('roleId',repo[0].Id);
        Test.startTest();
        System.runAs(u)
        {   
            InstituteSearchEmailComponent ct=new InstituteSearchEmailComponent();
            InstituteSearchEmailComponent.ConfirmEmail='a@a.com';
            InstituteSearchEmailComponent.email='a@a.com';
            ct.create().getUrl();
            
            
            
            
        }    
        Test.stopTest();
    }
    @isTest public static void EmailTest2()
    {
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        List<IB_Role_Repository__c> repo = [Select id from IB_Role_Repository__c];
        ApexPages.currentPage().getParameters().put('roleId',repo[0].Id);
        Test.startTest();
        System.runAs(u)
        {   
            InstituteSearchEmailComponent controller=new InstituteSearchEmailComponent();
            InstituteSearchEmailComponent.ConfirmEmail='a@a.com';
            InstituteSearchEmailComponent.email='a@a1.com';
            controller.create().getUrl();
            controller.Cancel1().getUrl();
            
            
        } 
        Test.stopTest();
    }
}