@isTest
public class onlineProviderSearchCtrlTest {
    
    public static IB_Role__c ibRole1 ;
    public static IB_Role__c ibRole2;
    public static IB_Role__c ibRole3; 
    public static  Contact_information__c ci ;
    public static IB_Role_Repository__c repo1 ;
    public static  Account acc1;
    public static Contact con;
    public static Profile p;
    public static user u;
    public static List<ib_role__c>roleList = new List<ib_role__c>();
    
    @testSetup static void setup() {
        
        acc1 = AccountTestDataFactory.createAccount('Online Provider', null);
        insert acc1;
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc1, 'Diploma Programme');
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c = date.today()+5;
        prog.Date_Decision_on_Candidacy__c = date.today()+2;
        prog.Owner__c = UserInfo.getUserId();
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc1, 'CP');
        prog2.Status__c = 'Authorized';
        prog2.Date_Decision_on_Authorization__c = date.today()+5;
        prog2.Date_Decision_on_Candidacy__c = date.today()+2;
        prog2.Owner__c = UserInfo.getUserId();
        insert new List<IB_Programme__c>{prog,prog2};
            
            Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp;
        
        repo1 = TestsUtil.createRoleRepo();
        repo1.Role_Name__c = 'Teacher';
        insert repo1;
        
        IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc1, 'PYP');
        insert ibprog;
        
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc1);
        insert con;
        con=[select id from contact limit 1][0];
        p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Advanced'];
        List<User> u = AccountFactoryTest.createUserTestData(1,p.Id,false,'testObama@example.com');
        u[0].ContactId = con.Id;
        insert u;
        ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c= con.id);
        insert ci;
        ibRole1 = PimsTestUtil.createIbRole(repo1.Id, con.id,acc1.Id);
        ibRole1.Status__c = 'Applicant';
        ibRole1.Role_Level__c = 'Fully Qualified';
        ibRole1.Contact_Information_Phone__c=ci.id;
        ibRole1.Contact_Information_Email__c=ci.id;
        ibRole1.Job_Title__c=ci.job__c;   
        insert ibRole1;
        
    }  
    private static testMethod void testOne() {
        con=[select id from contact limit 1];
   		u = [SELECT Id FROM User WHERE username='testObama@example.com'];
        repo1 = [Select id,Name from IB_Role_Repository__c][0];
        ci = [Select id,Name from Contact_information__c WHERE IB_Contact__r.id =: con.id Limit 1];
        roleList = [Select id from ib_role__c];
        Account acc2 = [Select id,RecordTypeId,Recordtype.Name,isPartner from Account WHERE Recordtype.Name='Online Provider' Limit 1];
        acc2.isPartner = true;
        update acc2;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Online_Coordinator_Role'];
        List<IB_Programme__c> programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE Status__c = 'Authorized'];
        system.runAs(u)
        {
            test.startTest();
            PageReference myVfPage = Page.onlineProviderSearch;
            Test.setCurrentPage(myVfPage);
            
            ApexPages.currentPage().getParameters().put('roleId',repo1.Id);
            ApexPages.currentPage().getParameters().put('AccountId',acc2.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(ci);
            onlineProviderSearchCtrl.jobTitle='Test';
            onlineProviderSearchCtrl.roleId=roleList[0].id;
            onlineProviderSearchCtrl  sobj = new onlineProviderSearchCtrl(sc);
            onlineProviderSearchCtrl obj=new onlineProviderSearchCtrl ();
            obj.PhoneVal='123456789';
            obj.currentRole=repo1;
            obj.Phone='+921121';
            obj.Email='test@xyz.com';
            obj.AccountName='test';
            obj.IBISCode='N050234';
            obj.selectedCountry='UNITED STATES';
            system.assertEquals('AFGHANISTAN',obj.getCountryNames()[1].getValue());
            system.assertNotEquals(null, obj.getCountryState());
            obj.showPopup();
            obj.closePopup();
            system.assertEquals('en_US',obj.getLocale());
            onlineProviderSearchCtrl.roleId=roleList[0].id;
            obj.showinnerpopup();
            obj.closeinnerpopup();
            obj.AccountName = '';
            obj.selectedState = '--None--';   
            obj.selectedCountry = '--None--';   
            obj.SearchInfo();
            obj.AccountName = 'Test';
            obj.SearchInfo();
            obj.AccountName = 'Test';
            obj.selectedCountry = '--Test--'; 
            obj.SearchInfo();
            obj.AccountName = '';   
            obj.SearchInfo();
            obj.selectedState = '--None--';    
            obj.SearchInfo();  
            obj.AccountName = 'Test';
            obj.selectedCountry = 'Test';
            obj.SearchInfo();
            obj.selectedState = 'Test';
            obj.SearchInfo();
            system.assertEquals('/ibportal/MyIBRoles', obj.cancelSearch().getUrl());
            onlineProviderSearchCtrl.lookupSchoolAccountByNameMulti('Test:test2:test3');
            obj.isLoggedIn();
            onlineProviderSearchCtrl.lookupInstituteSearchName('Test');
            obj.saveResult();
        }
        Test.stopTest();
    }
    
}