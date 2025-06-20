@isTest
public class UserManagementHandlerTest {
    @testSetup
    static void setup() {
        // Create a test user for running setup object DML operations
        UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'System Administrator' LIMIT 1];
        
        User testAdminUser = UserTestDataFactory.createUser('System Administrator',null);
		testAdminUser.UserRoleId = userRole.Id;
        testAdminUser.IsActive = true;
        insert testAdminUser;

        // Use System.runAs to separate the transactions
        System.runAs(testAdminUser) {
            // Create an account and enable it as a partner
            Account partnerAccount = AccountTestDataFactory.createAccount('School Account', null);
            insert partnerAccount;

            // Enable the account as a partner
            partnerAccount.IsPartner = true;
            update partnerAccount;
            
            Contact portalUserContact = ContactTestDataFactory.createContact('Standard Contact', null);
			portalUserContact.AccountId = partnerAccount.Id;
        	insert portalUserContact;

            User portalUser = UserTestDataFactory.createUser('SCU + Advanced',null);
            portalUser.FirstName = 'UserManagementHandlerTest';
            portalUser.ContactId = portalUserContact.Id;
            portalUser.IsActive = true;
            insert portalUser;

            // Create test case
            Case testCase = CaseTestDataFactory.createCase('Support', null);
            insert testCase;
        }
    }

    @isTest
    static void testUnfreezeAndResetPassword() {
        // Retrieve test data
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'SCU + Advanced' AND FirstName = 'UserManagementHandlerTest' LIMIT 1];
        Case testCase = [SELECT Id FROM Case LIMIT 1];

        // Freeze the user
        UserLogin testUserLogin = [SELECT Id, IsFrozen FROM UserLogin WHERE UserId = :testUser.Id LIMIT 1];
        testUserLogin.IsFrozen = true;
        update testUserLogin;

        // Create input record
        UserManagementHandler.Input inputRecord = new UserManagementHandler.Input();
        inputRecord.caseId = testCase.Id;
        inputRecord.userId = testUser.Id;
        inputRecord.disposition = 'Resolved';
        inputRecord.passwordResetDate = Date.today();
        inputRecord.caseClosureStatus = 'Closed';

        List<UserManagementHandler.Input> inputRecords = new List<UserManagementHandler.Input>{inputRecord};

        // Call the method
        Test.startTest();
        UserManagementHandler.unfreezeAndResetPassword(inputRecords);
        Test.stopTest();

        // Verify UserLogin is unfrozen
        UserLogin updatedUserLogin = [SELECT IsFrozen FROM UserLogin WHERE UserId = :testUser.Id];
        System.assertEquals(false, updatedUserLogin.IsFrozen, 'User should be unfrozen');

        // Verify Case is updated
        Case updatedCase = [SELECT Disposition__c, Password_Reset_Date__c, Status FROM Case WHERE Id = :testCase.Id];
        System.assertEquals('Resolved', updatedCase.Disposition__c, 'Case disposition should be updated');
        System.assertEquals(Date.today(), updatedCase.Password_Reset_Date__c, 'Password reset date should be updated');
        System.assertEquals('Closed', updatedCase.Status, 'Case status should be updated');
    }
}