@isTest
public class RolesCLassAssociationTest {
    
    public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3{get; set;}
    
    public static User u;
    
    @testSetup static void setup() {
        repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Association Admin';
        insert repo;
        
        repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Association User';
        insert repo2;
        
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        system.debug('connnn'+con.id);
        
        
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci2;
        
        ibRole1 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole1.Status__c = 'Applicant';
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Contact_Information_Email__c=ci.id;
        ibRole1.Contact_Information_Phone__c=ci2.id;
        ibRole1.Role_Level__c = 'Fully Qualified';
        ibRole1.Email_Confirmed__c=true;
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
        ibRole3.IB_Account__c = acc.id;
        ibRole3.Role_Level__c = 'Fully Qualified';
        ibRole3.Email_Confirmed__c=true;
        insert ibRole3;
     
        list<ib_role__c> rolelist=new list<ib_role__c>();
        rolelist.add(ibrole1);
    }    
    @isTest
    public static void testIbRoleBeforeInsert(){
        
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        acc=[select Id from Account limit 1];
        
        ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c from IB_Role__c limit 1][0];
        Test.startTest();
        System.runAs(u)
        { 
            list<ib_role__c> rolelist=new list<ib_role__c>();
            rolelist.add(ibrole1);    
            system.assertNotEquals(rolelist, RolesCLassAssociation.getRoleList(acc.id));
            system.assertNotEquals(rolelist, RolesCLassAssociation.getRoleListConfirmed(acc.id));
            system.assertNotEquals(rolelist, RolesCLassAssociation.getRoleListTransConfirmed());
            
            RolesCLassAssociation.AddSelectedItems(rolelist);
            RolesCLassAssociation.confirmSelectedItems(rolelist);
            RolesCLassAssociation.declineApplicantRoles(rolelist);
            RolesCLassAssociation.declineConfimedRoles(rolelist);
            RolesCLassAssociation.DeclinedApplicantRoles(rolelist);
            RolesCLassAssociation.DeclinedConfimRoles(rolelist);           
        }
        Test.stopTest();
    }
        @isTest
    public static void testIbRoleMethodException(){
        
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        acc = [Select Id from Account limit 1][0];
        
        ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c,End_Date__c from IB_Role__c limit 1][0];
        Test.startTest();
        System.runAs(u)
        { 
            

            list<ib_role__c> rolelist=new list<ib_role__c>();
            ibRole1.Id = null;
            rolelist.add(ibrole1);    
            system.assertNotEquals(rolelist, RolesCLassAssociation.getRoleList(acc.id));
            system.assertNotEquals(rolelist, RolesCLassAssociation.getRoleListConfirmed(acc.id));
        
            RolesCLassAssociation.confirmSelectedItems(rolelist);
            RolesCLassAssociation.declineConfimedRoles(rolelist);
            RolesCLassAssociation.declineApplicantRoles(rolelist);
            
        }
        Test.stopTest();
        
    }
   
}