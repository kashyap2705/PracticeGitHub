/**
* @description       : Test class for CSM_UserRolesAndProgrammeController
* @author            : Charan Kumar
* @last modified on  : 03-21-2024
* @last modified by  : Satyanarayana Gajavalli
* @code coverage	  : 87% (27/31)
**/

@isTest
public class CSM_UserRolesAndProgrammeControllerTest {
    
    @testSetup
    static void makeData() {

        String testemail = 'testgck123@test.com';
        
        Account accOne = new Account();
        Account testAccount = AccountTestDataFactory.createAccount('School Account',accOne);
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.Email = testemail;
        testContact = ContactTestDataFactory.createContact(null,testContact);
        insert testContact;
        
        User commUser = new User();
        commUser.LastName = 'lastname';
        commUser.username = testemail;
        commUser.email = testemail;
        commUser.contactId = testContact.Id;
        commUser.IsActive = true;
        User communityUser = UserTestDataFactory.createUser('SCU + Advanced',commUser);
        insert communityUser;

        IB_Role_Repository__c repo1 = new IB_Role_Repository__c();
        repo1.Role_Name__c = 'Head of School';
        IB_Role_Repository__c headOfSchool = IBRoleRepositoryTestDataFactory.createIBRoleRepository(repo1);
        insert headOfSchool;
        
        IB_Role_Repository__c repo2 = new IB_Role_Repository__c();
        repo2.Role_Name__c = 'Head of School (Overall)';
        IB_Role_Repository__c headOfSchoolOverall = IBRoleRepositoryTestDataFactory.createIBRoleRepository(repo2);
        insert headOfSchoolOverall;
        
        List<IB_Role__c> rolesList = new List<IB_Role__c>(); 
        
        IB_Role__c ibRole = new IB_Role__c();
        ibRole.Status__c = 'Confirmed';
        ibRole.IB_Contact__c = testContact.Id;
        ibRole.IB_Role__c = headOfSchool.Id;
        ibRole.IB_Account__c = testAccount.Id;
        IB_Role__c headOfSchoolRole = IBRoleTestDataFactory.createRole(ibRole);
        rolesList.add(headOfSchoolRole);
        
        IB_Role__c ibRole2 = new IB_Role__c();
        ibRole2.Status__c = 'Confirmed';
        ibRole2.IB_Contact__c = testContact.Id;
        ibRole2.IB_Role__c = repo2.Id;
        ibRole2.IB_Account__c = testAccount.Id;
        ibRole2.Programme_Selection__c = 'DP';
        IB_Role__c headOfSchoolOverallRole = IBRoleTestDataFactory.createRole(ibRole2);
        rolesList.add(headOfSchoolOverallRole);
        insert rolesList;
    }
    
    @isTest
    static void testGetRoles() {
        
        User u = [SELECT id FROM User WHERE email = 'testgck123@test.com'];
        Map<String, CSM_UserRolesAndProgrammeController.RolesAndProgrammes> rolesAndProgrammes;
        Test.startTest();
        System.runAs(u) {
            rolesAndProgrammes = CSM_UserRolesAndProgrammeController.getConfirmedRolesMap();
        }
        Test.stopTest();
        System.assertEquals(2, rolesAndProgrammes.size(), 'There should be 2 role maps');
        System.assert(rolesAndProgrammes.containsKey('Head of School'), 'Head of School role should exist');
    }
}