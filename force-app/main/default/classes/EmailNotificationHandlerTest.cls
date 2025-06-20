/*
* <h1>EmailNotificationHandlerTest</h1>    
* This class is responsible for test coverage for EmailNotificationHandler, for ECM00501.
* 
* @author  Prerna Sobti   
* @version 1.0   
* @since   10-06-2024
*/

@isTest
public class EmailNotificationHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test User for Programme Relationship Manager
        User prmUser = new User(
            FirstName = 'Test',
            LastName = 'PRM',
            Email = 'prm@test.com',
            Username = 'prm@test.com.ib',
            Alias = 'tprm',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert prmUser;
        
        // Create Account
        Account acc = AccountTestDataFactory.createAccount(null, null);
        acc.Language_Of_Correspondance__c = 'English'; // Default language
        insert acc;
        
        // Create IB Country Segmentation
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        // Create IB Address
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = acc.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        // Create IB Programme 
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme('PYP', null);
        prog.Account__c = acc.Id;
        prog.StageName__c = 'Request for Authorization';
        prog.Status__c = 'Candidate';
        prog.Street_Address__c = address.Id;
        prog.Owner__c = prmUser.Id;
        insert prog;
        
        // Create Contacts for different roles
        Contact headOfSchoolContact = ContactTestDataFactory.createContact(null, null);
        headOfSchoolContact.FirstName = 'Head';
        headOfSchoolContact.LastName = 'Of School';
        headOfSchoolContact.Email = 'hos@test.com';
        headOfSchoolContact.User_Language__c = 'en_US';
        headOfSchoolContact.Country__c = country.Id;
        headOfSchoolContact.AccountId = acc.Id;
        insert headOfSchoolContact;
        
        Contact programmeCoordinatorContact = ContactTestDataFactory.createContact(null, null);
        programmeCoordinatorContact.FirstName = 'Programme';
        programmeCoordinatorContact.LastName = 'Coordinator';
        programmeCoordinatorContact.Email = 'pc@test.com';
        programmeCoordinatorContact.User_Language__c = 'en_US';
        programmeCoordinatorContact.Country__c = country.Id;
        programmeCoordinatorContact.AccountId = acc.Id;
        insert programmeCoordinatorContact;
        
        Contact hosOverallContact = ContactTestDataFactory.createContact(null, null);
        hosOverallContact.FirstName = 'HOS';
        hosOverallContact.LastName = 'Overall';
        hosOverallContact.Email = 'hosoverall@test.com';
        hosOverallContact.User_Language__c = 'en_US';
        hosOverallContact.Country__c = country.Id;
        hosOverallContact.AccountId = acc.Id;
        insert hosOverallContact;
        
        // Create Role Repositories
        IB_Role_Repository__c pcRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
        pcRepo.Role_Name__c = 'Programme Coordinator';
        insert pcRepo;
        
        IB_Role_Repository__c hosRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
        hosRepo.Role_Name__c = 'Head of School';
        insert hosRepo;
    }
    
    @isTest
    public static void testEmailNotificationForEnglishLanguage() {
        // Get test data
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        Contact headOfSchoolContact = [SELECT Id FROM Contact WHERE FirstName = 'Head' LIMIT 1];
        Contact programmeCoordinatorContact = [SELECT Id FROM Contact WHERE FirstName = 'Programme' LIMIT 1];
        IB_Role_Repository__c pcRepo = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Programme Coordinator' LIMIT 1];
        IB_Role_Repository__c hosRepo = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Head of School' LIMIT 1];
        
        // Create test roles
        List<IB_Role__c> ibRoleList = new List<IB_Role__c>();
        
        IB_Role__c pcRole = IBRoleTestDataFactory.createRole(null);
        pcRole.IB_Role__c = pcRepo.Id;
        pcRole.IB_Contact__c = programmeCoordinatorContact.Id;
        pcRole.IB_Account__c = acc.Id;
        pcRole.IB_Programme_New__c = prog.Id;
        pcRole.Start_Date__c = Date.today();
        
        IB_Role__c hosRole = IBRoleTestDataFactory.createRole(null);
        hosRole.IB_Role__c = hosRepo.Id;
        hosRole.IB_Contact__c = headOfSchoolContact.Id;
        hosRole.IB_Account__c = acc.Id;
        hosRole.IB_Programme_New__c = prog.Id;
        hosRole.Start_Date__c = Date.today();
        
        ibRoleList.add(pcRole);
        ibRoleList.add(hosRole);
        
        Test.startTest();
        // Set mock for sending emails
        Messaging.SingleEmailMessage[] sentEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.sendEmail(sentEmails);
        
        insert ibRoleList;
        EmailNotificationHandler.sendEmail(ibRoleList);
        Test.stopTest();
        
        // Verify results
        List<Task> tasks = [SELECT Id, Subject FROM Task];
        System.assert(!tasks.isEmpty(), 'Tasks should be created for sent emails');
    }
    
    @isTest
    public static void testEmailNotificationForSpanishLanguage() {
        // Update account language to Spanish
        Account acc = [SELECT Id FROM Account LIMIT 1];
        acc.Language_Of_Correspondance__c = 'Spanish';
        update acc;
        
        // Get test data
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        Contact headOfSchoolContact = [SELECT Id FROM Contact WHERE FirstName = 'Head' LIMIT 1];
        IB_Role_Repository__c hosRepo = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Head of School' LIMIT 1];
        
        // Create test role
        IB_Role__c hosRole = IBRoleTestDataFactory.createRole(null);
        hosRole.IB_Role__c = hosRepo.Id;
        hosRole.IB_Contact__c = headOfSchoolContact.Id;
        hosRole.IB_Account__c = acc.Id;
        hosRole.IB_Programme_New__c = prog.Id;
        hosRole.Start_Date__c = Date.today();
        
        Test.startTest();
        // Set mock for sending emails
        Messaging.SingleEmailMessage[] sentEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.sendEmail(sentEmails);
        
        insert hosRole;
        EmailNotificationHandler.sendEmail(new List<IB_Role__c>{hosRole});
        Test.stopTest();
        
        // Verify results
        List<Task> tasks = [SELECT Id, Subject FROM Task];
        System.assert(!tasks.isEmpty(), 'Tasks should be created for sent emails');
    }
    
    @isTest
    public static void testEmailNotificationForFrenchLanguage() {
        // Update account language to French
        Account acc = [SELECT Id FROM Account LIMIT 1];
        acc.Language_Of_Correspondance__c = 'French';
        update acc;
        
        // Get test data
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        Contact headOfSchoolContact = [SELECT Id FROM Contact WHERE FirstName = 'Head' LIMIT 1];
        IB_Role_Repository__c hosRepo = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Head of School' LIMIT 1];
        
        // Create test role
        IB_Role__c hosRole = IBRoleTestDataFactory.createRole(null);
        hosRole.IB_Role__c = hosRepo.Id;
        hosRole.IB_Contact__c = headOfSchoolContact.Id;
        hosRole.IB_Account__c = acc.Id;
        hosRole.IB_Programme_New__c = prog.Id;
        hosRole.Start_Date__c = Date.today();
        
        Test.startTest();
        // Set mock for sending emails
        Messaging.SingleEmailMessage[] sentEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.sendEmail(sentEmails);
        
        insert hosRole;
        EmailNotificationHandler.sendEmail(new List<IB_Role__c>{hosRole});
        Test.stopTest();
        
        // Verify results
        List<Task> tasks = [SELECT Id, Subject FROM Task];
        System.assert(!tasks.isEmpty(), 'Tasks should be created for sent emails');
    }
    
    @isTest
    public static void testEmailNotificationWithNoContacts() {
        // Test with empty role list
        Test.startTest();
        EmailNotificationHandler.sendEmail(new List<IB_Role__c>());
        Test.stopTest();
        
        // Verify no tasks were created
        List<Task> tasks = [SELECT Id FROM Task];
        System.assert(tasks.isEmpty(), 'No tasks should be created when no roles are provided');
    }
    
    @isTest
    public static void testEmailNotificationWithNoEmailTemplates() {
        // Get test data
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IB_Programme__c prog = [SELECT Id FROM IB_Programme__c LIMIT 1];
        Contact headOfSchoolContact = [SELECT Id FROM Contact WHERE FirstName = 'Head' LIMIT 1];
        IB_Role_Repository__c hosRepo = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Head of School' LIMIT 1];
        
        // Create test role
        IB_Role__c hosRole = IBRoleTestDataFactory.createRole(null);
        hosRole.IB_Role__c = hosRepo.Id;
        hosRole.IB_Contact__c = headOfSchoolContact.Id;
        hosRole.IB_Account__c = acc.Id;
        hosRole.IB_Programme_New__c = prog.Id;
        hosRole.Start_Date__c = Date.today();
        
        Test.startTest();
        // Delete email templates to simulate missing templates
        delete [SELECT Id FROM EmailTemplate WHERE DeveloperName LIKE 'New_Notification_to_New_Head_of_School_and_Coordinators%'];
        
        insert hosRole;
        EmailNotificationHandler.sendEmail(new List<IB_Role__c>{hosRole});
        Test.stopTest();
        
        // Verify no tasks were created when templates are missing
        List<Task> tasks = [SELECT Id FROM Task];
        System.assert(tasks.isEmpty(), 'No tasks should be created when email templates are missing');
    }
}