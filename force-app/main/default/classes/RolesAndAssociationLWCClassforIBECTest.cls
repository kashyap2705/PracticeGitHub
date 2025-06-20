@isTest
public class RolesAndAssociationLWCClassforIBECTest {
    
    @testSetup 
    static void setup() {
        
        Account acc = AccountTestDataFactory.createAccount('Association Account', null);
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = ContactTestDataFactory.createContact(null, new Contact(AccountId = acc.Id, Email = 'a@a.com'));
        insert con;
        
        IB_Role_Repository__c repo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'IBEC University Administrator',
                Role_Level__c = 'Fully Qualified'
            ));
        insert repo;
        
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId(),
                                                             name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci;
        
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),
                                                              name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci2;
    
        IB_Role__c ibRole1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                Status__c = 'Applicant', 
                IB_Role__c = repo.Id,
                Contact_Information_Email__c=ci.id,
                Contact_Information_Phone__c=ci2.id,
                IB_Contact__c = con.Id,
                Role_Level__c = 'Fully Qualified',
                Email_Confirmed__c=true
            ));
    
        insert ibRole1;
    }    
    
    @isTest
    public static void testIbRoleBeforeInsert() {
        
        IB_Role__c ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c,End_Date__c from IB_Role__c limit 1];
        
        Test.startTest();
        list<ib_role__c> rolelist=new list<ib_role__c>();
        rolelist.add(ibrole1);    
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleList(), 'The role list should not match the returned value from getRoleList()');
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleListConfirmed(), 'The role list should not match the returned value from getRoleListConfirmed()');
        
        RolesAndAssociationLWCClassforIBEC.fetchAccounts();
        RolesAndAssociationLWCClassforIBEC.updateAccounts(rolelist);
        RolesAndAssociationLWCClassforIBEC.AddSelectedItems(rolelist);
        RolesAndAssociationLWCClassforIBEC.DeclinedConfirmRoles(rolelist);         
        Test.stopTest();
    }
    
    @isTest
    public static void testIbRoleMethod() {
        
        IB_Role__c ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c,End_Date__c from IB_Role__c limit 1];
        
        Test.startTest();
        
        list<ib_role__c> rolelist=new list<ib_role__c>();
        rolelist.add(ibrole1);    
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleList(), 'The role list should not match the returned value from getRoleList()');
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleListConfirmed(), 'The role list should not match the returned value from getRoleListConfirmed()');
        
        RolesAndAssociationLWCClassforIBEC.saveRoles(rolelist);
        RolesAndAssociationLWCClassforIBEC.confirmSelectedItems(rolelist);
        RolesAndAssociationLWCClassforIBEC.declineConfimedRoles(rolelist);
        RolesAndAssociationLWCClassforIBEC.declineApplicantRoles(rolelist);
        RolesAndAssociationLWCClassforIBEC.DeclinedApplicantRoles(rolelist);
        Test.stopTest();
    }
    
    @isTest
    public static void testIbRoleMethodException() {
        
        IB_Role__c ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c,End_Date__c from IB_Role__c limit 1];
        Test.startTest();
        
        list<ib_role__c> rolelist=new list<ib_role__c>();
        ibRole1.Id = null;
        rolelist.add(ibrole1);    
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleList(), 'The role list should not match the returned value from getRoleList()');
        system.assertNotEquals(rolelist, RolesAndAssociationLWCClassforIBEC.getRoleListConfirmed(), 'The role list should not match the returned value from getRoleListConfirmed()');
        
        RolesAndAssociationLWCClassforIBEC.saveRoles(rolelist);
        RolesAndAssociationLWCClassforIBEC.confirmSelectedItems(rolelist);
        RolesAndAssociationLWCClassforIBEC.declineConfimedRoles(rolelist);
        RolesAndAssociationLWCClassforIBEC.declineApplicantRoles(rolelist);
        
        Test.stopTest();
    }
    
}