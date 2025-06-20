@isTest
public class roleTriggersTest {
    
    @testSetup 
    static void setup() {
        
        Account testAcct = AccountTestDataFactory.createAccount(null, null);
        testAcct.Name = 'Test Account';
        insert testAcct;
        
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        Contact newCon1 = new Contact (
            AccountId = testAcct.Id, 
            Email = 'testcontact@test.com', 
            Country__c = country.Id
        );
        
        Contact testContact = ContactTestDataFactory.createContact(null, newCon1);
        insert testContact;
        
        User testUser = UserTestDataFactory.createUser('SCU + Advanced', 
                                                       new User(
                                                           ContactId = testContact.Id,
                                                           Email = 'testuser@test.com',
                                                           Username = 'testuser@test.com',
                                                           LastName = 'TestUser',
                                                           isActive = true,
                                                           Person_Code__c = '123456'
                                                       ));
        insert testUser;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = testAcct.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        Opportunity opp = IBOpportunityTestDataFactory.createOpportunity('Test Opp', testAcct.Id);
        insert opp;
        
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme('MYP', null);
        prog.Account__c = testAcct.Id;
        prog.Status__c = 'Interested';
        prog.Street_Address__c = address.Id;
        insert prog;
        
        IB_Role_Repository__c testRoleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Programme Field Representative',
                Role_Level__c = 'Fully Qualified',
                Related_Programmes__c = 'PYP;MYP;DP;CP',
                Category__c='Learning Centre',
                Sub_Category__c='Administration',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true
            ));
        insert testRoleRepo;
        
        IB_Programme__c prog1 = IBProgrammeTestDataFactory.createIBProgramme('MYP', 
                                                                             new IB_Programme__c(
                                                                                 Account__c = testAcct.Id,
                                                                                 Street_Address__c = address.Id,
                                                                                 Status__c = 'Interested',
                                                                                 Programme_Legal_Name__c = 'Test'
                                                                             ));
        
        IB_Role__c testRole = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = testAcct.Id,
                IB_Programme_New__c = prog1.Id,
                IB_Role__c = testRoleRepo.Id,
                IB_Contact__c = testContact.Id,
                IB_Programme__c = opp.Id,
                Status__c='Applicant',
                Active__c = true
            ));
        
        TriggerContextUtility.firstRun = true;
        insert testRole;
    }
    
    @isTest
    static void ibRoleTriggersTest() {
        Account testAcct = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Opportunity testOppt = [SELECT Id FROM Opportunity LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        IB_Role__c testRoleAndApp = [SELECT Id FROM IB_Role__c LIMIT 1];
        IB_Role_Repository__c testRoleRepo = [SELECT Id FROM IB_Role_Repository__c LIMIT 1];
        
        testRoleRepo.Prevent_Duplicates__c = true;
        testRoleRepo.DOB_Mandatory__c = true;
        update testRoleRepo;
        
        Test.startTest();
        // Test duplicate prevention
        try {
            IB_Role__c testRole = IBRoleTestDataFactory.createRole(
                new IB_Role__c(
                    IB_Account__c = testAcct.Id,
                    IB_Programme_New__c = prog.Id,
                    IB_Role__c = testRoleRepo.Id,
                    IB_Contact__c = testContact.Id,
                    IB_Programme__c = testOppt.Id,
                    Status__c='Applicant',
                    Active__c = true
                ));
            
            TriggerContextUtility.firstRun = true;
            insert testRole;
            
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('There already exists a Role and Application with the same Role and End Date associated with this Programme.');
            System.assert(expectedExceptionThrown, 'Expected duplicate role validation error but got: ' + e.getMessage());
        }
        
        // Test DOB mandatory validation
        Date dd = Date.newInstance(1999, 12, 9);
        testContact.Birthdate = dd;
        update testContact;
        
        try {
            testRoleAndApp.Programme_Selection__c ='PYP;MYP;DP';
            TriggerContextUtility.firstRun = true;
            
            update testRoleAndApp;
        }
        catch(Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Please select a Contact with a Birthdate populated or update the Birthdate on the Contact selected');
            System.assert(expectedExceptionThrown, 'Expected DOB validation error but got: ' + e.getMessage());
        }
        
        // Test delete and undelete
        delete testRoleAndApp;
        List<IB_Role__c> deletedRoles = [SELECT Id FROM IB_Role__c WHERE Id = :testRoleAndApp.Id ALL ROWS];
        System.assertEquals(1, deletedRoles.size(), 'Role should be deleted');
        
        undelete testRoleAndApp;
        List<IB_Role__c> undeletedRoles = [SELECT Id FROM IB_Role__c WHERE Id = :testRoleAndApp.Id];
        System.assertEquals(1, undeletedRoles.size(), 'Role should be restored after undelete');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testIBRoleTriggerUpdate() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        
        List<IB_Role__c> ibRoleList = new List<IB_Role__c>();
        List<IB_Role_Repository__c> roleRepoList = new List<IB_Role_Repository__c>();
        
        IB_Role_Repository__c theRoleRepo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'School Visit Team Member',
                Role_Level__c = 'Fully Qualified',
                Related_Programmes__c = 'PYP;MYP;DP;CP',
                Category__c='Learning Centre',
                Sub_Category__c='Administration',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true
            ));
        roleRepoList.add(theRoleRepo1);
        
        IB_Role_Repository__c theRoleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Session Observer',
                Role_Level__c = 'Fully Qualified',
                Related_Programmes__c = 'PYP;MYP;DP;CP',
                Category__c='Learning Centre',
                Sub_Category__c='Administration',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true
            ));
        roleRepoList.add(theRoleRepo2);
        
        Test.startTest();
        insert roleRepoList;
        System.assertEquals(2, roleRepoList.size(), 'Expected 2 role repositories to be inserted');
        
        IB_Role__c role1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo1.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Applicant',
                Active__c = true,
                Start_Date__c = Date.today()
            ));
        ibRoleList.add(role1);
        
        IB_Role__c role2 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Applicant',
                Active__c = true,
                Start_Date__c = Date.today()
            ));
        ibRoleList.add(role2);
        
        TriggerContextUtility.firstRun = true;
        insert ibRoleList;
        System.assertEquals(2, ibRoleList.size(), 'Expected 2 roles to be inserted');
        
        System.runAs(new User(Id = UserInfo.getUserId())) {
            role1.Motivation__c = 'Text';
            update role1;
            
            IB_Role__c updatedRole = [SELECT Motivation__c FROM IB_Role__c WHERE Id = :role1.Id];
            System.assertEquals('Text', updatedRole.Motivation__c, 'Motivation field should be updated');
        }
        
        Test.stopTest();
    }
    
    @isTest 
    static void testIBRoleTriggerBeforeInsert() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        
        IB_Role_Repository__c theRoleRepo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Programme Coordinator'
            ));
        
        IB_Role_Repository__c theRoleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Head of School',
                Permission_Set_Name__c = 'Head_of_School'
            ));
        
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2};
            
        Test.startTest();
        IB_Role__c role1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo1.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Applicant',
                Start_Date__c = Date.today()
            ));
        
        IB_Role__c role2 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Withdrawn',
                Start_Date__c = Date.today()
            ));
        
        TriggerContextUtility.FirstRun = true;
        insert role1;
        
        TriggerContextUtility.FirstRun = true;
        insert role2;
        
        // Verify role insertion
        List<IB_Role__c> insertedRoles = [SELECT Id, Status__c FROM IB_Role__c WHERE Id IN (:role1.Id, :role2.Id)];
        System.assertEquals(2, insertedRoles.size(), 'Expected both roles to be inserted');
        System.assertEquals('Confirmed', insertedRoles[0].Status__c, 'First role should have Confirmed status');
        System.assertEquals('Withdrawn', insertedRoles[1].Status__c, 'Second role should have Withdrawn status');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testIBRoleTriggerBeforeUpdate() {
        
        List<IB_Role__c> ibRoleList = new List<IB_Role__c>();
     
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        
        Test.startTest();
        IB_Role_Repository__c theRoleRepo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Programme Coordinator'
            ));
        
        IB_Role_Repository__c theRoleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Head of School',
                Permission_Set_Name__c = 'Head_of_School'
            ));
        
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2};
        
        IB_Role__c role1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo1.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Applicant',
                Start_Date__c = Date.today()
            ));
        
        IB_Role__c role2 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = testContact.Id,
                Status__c='Applicant',
                Start_Date__c = Date.today()
            ));
        
        TriggerContextUtility.FirstRun = true;
        insert new List<IB_Role__c>{role1,role2};
            
        // Update both roles in one DML operation
        role1.Status__c = 'Withdrawn';
        role2.Status__c = 'Invited';
        TriggerContextUtility.FirstRun = true;
        update new List<IB_Role__c>{role1, role2};
            
            // Verify results
            List<IB_Role__c> updatedRoles = [
                SELECT Id, Status__c, IB_Account__c 
                FROM IB_Role__c 
                WHERE Id IN (:role1.Id, :role2.Id)
            ];
        for (IB_Role__c role : updatedRoles) {
            if (role.Id == role1.Id) {
                System.assertEquals('Withdrawn', role.Status__c, 'Role status should be updated to Withdrawn');
            } else if (role.Id == role2.Id) {
                System.assertEquals('Invited', role.Status__c, 'Role status should be updated to Invited');
                System.assertEquals(acc.Id, role.IB_Account__c, 'Account reference should be updated');
            }
        }
        Test.stopTest();
    }
    
}