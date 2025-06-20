@isTest
public with sharing class PostSandboxGenerationTest {
    
    @TestSetup
    static void setup() {
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c(
            Name = 'MaxContactIBCode',
        MaxIBCode__c = 100000
            );
        insert setting;
    }
    
    @isTest
    public static void testLeadCreation(){
        
        Test.startTest();
        
        List<Lead> listOfLeads = PostSandboxGeneration.createLeads(3, 'School Lead');
        insert listOfLeads;
        
        Test.stopTest();
        
        System.assertEquals(3, listOfLeads.size());
    }
    
    @isTest
    public static void testAccountCreation(){
        
        Test.startTest();
        
        List<Account> listOfAccounts = PostSandboxGeneration.createAccounts(10, 'School Account');
        insert listOfAccounts;
        
        Test.stopTest();
        
        System.assertEquals(10, listOfAccounts.size());
    }
    
    @isTest
    public static void testContactCreation(){
        
        Test.startTest();
        
        List<Contact> listOfContacts = PostSandboxGeneration.createContacts(10, 'Standard Contact');
        insert listOfContacts;
        
        Test.stopTest();
        
        System.assertEquals(10, listOfContacts.size());
    }
    
    @isTest
    public static void testRolesApplicationsCreation(){
        
        Test.startTest();
        
        List<IB_Role_Repository__c> listOfRoles = PostSandboxGeneration.createRoleRepository();
        insert listOfRoles;
        
        Test.stopTest();
        
        System.assertEquals(3, listOfRoles.size());
    }
    
    @isTest
    public static void testCountrySegmentationCreation(){
        
        Test.startTest();
        
        IB_Country_Segmentation__c countries = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert countries;
        
        Test.stopTest();
        
        System.assertNotEquals(null, countries);
    }
    
    @isTest
    public static void testIbRoleRepoCreation(){
        
        Test.startTest();
        
        List<Account> accountRecords = PostSandboxGeneration.createAccounts(1, 'School Account');
        insert accountRecords;
        
        IB_Country_Segmentation__c segmentation = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert segmentation;
        
        IB_Address__c address = PostSandboxGeneration.createIBAddressInstance('Active', 'Brooklyn', 'New York', '10001', segmentation, accountRecords[0]);
        insert address;
        
        List<IB_Programme__c> listOfProgrammes = PostSandboxGeneration.createIBProgrammes('Diploma Programme', address, 1);
        insert listOfProgrammes;
        
        List<Contact> listOfContacts = PostSandboxGeneration.createContacts(10, 'Standard Contact');
        insert listOfContacts;
        
        List<IB_Role_Repository__c> listOfRoles = PostSandboxGeneration.createRoleRepository();
        insert listOfRoles;
        
        IB_Role_Repository__c hosRole = null;
        IB_Role_Repository__c hosOverallRole = null;
        IB_Role_Repository__c pcRole = null;
        
        for(IB_Role_Repository__c tempRepo : listOfRoles)
        {
            if(tempRepo.Role_Name__c == 'Programme Coordinator')
            {
                pcRole = tempRepo;
            }
            else if(tempRepo.Role_Name__c == 'Head of School (Overall)')
            {
                hosOverallRole = tempRepo;
            }
            else
            {
                hosRole = tempRepo;
            }
        }
        
        List<IB_Role__c> ibRoleRecords = PostSandboxGeneration.createIbRoles(hosRole, hosOverallRole, pcRole, listOfContacts, listOfProgrammes[0]);
        
        Test.stopTest();
        
        System.assertEquals(9, ibRoleRecords.size());
    }
    
    @isTest
    public static void testIbAddressCreation(){
        
        List<Account> accountRecords = PostSandboxGeneration.createAccounts(1, 'School Account');
        insert accountRecords;
        
        IB_Country_Segmentation__c segmentation = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert segmentation;
        
        Test.startTest();
        
        IB_Address__c address = PostSandboxGeneration.createIBAddressInstance('Active', 'Brooklyn', 'New York', '10001', segmentation, accountRecords[0]);
        insert address;
        
        Test.stopTest();
        
        System.assertNotEquals(null, address);
    }
    
    @isTest
    public static void testIbProgrammeCreation(){
        
        List<Account> accountRecords = PostSandboxGeneration.createAccounts(1, 'School Account');
        insert accountRecords;
        
        IB_Country_Segmentation__c segmentation = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert segmentation;
        
        IB_Address__c address = PostSandboxGeneration.createIBAddressInstance('Active', 'Brooklyn', 'New York', '10001', segmentation, accountRecords[0]);
        insert address;
        
        Test.startTest();
        
        List<IB_Programme__c> listOfProgrammes = PostSandboxGeneration.createIBProgrammes('Diploma Programme', address, 1);
        insert listOfProgrammes;
        
        Test.stopTest();
        
        System.assertNotEquals(null, listOfProgrammes);
        System.assertEquals(1, listOfProgrammes.size());
    }
    
    @isTest
    public static void testUserCreation(){
        
        // Create a test user for running setup object DML operations
        UserRole userRole = [SELECT Id FROM UserRole WHERE Name = 'System Administrator' LIMIT 1];
        
        User testAdminUser = UserTestDataFactory.createUser('System Administrator',null);
        testAdminUser.UserRoleId = userRole.Id;
        testAdminUser.IsActive = true;
        insert testAdminUser;
        
        Contact portalUserContact = null;
        
        // Use System.runAs to separate the transactions
        System.runAs(testAdminUser) {
            // Create an account and enable it as a partner
            Account partnerAccount = AccountTestDataFactory.createAccount('School Account', null);
            insert partnerAccount;
            
            // Enable the account as a partner
            partnerAccount.IsPartner = true;
            update partnerAccount;
            
            portalUserContact = ContactTestDataFactory.createContact('Standard Contact', null);
            portalUserContact.AccountId = partnerAccount.Id;
            insert portalUserContact;
        }
        
        Test.startTest();
        
        User tempUser = PostSandboxGeneration.createUser('SCU + Advanced', TestDataUtility.generateRandomString(10), TestDataUtility.generateRandomString(10));
        tempUser.ContactId = portalUserContact.Id;
        insert tempUser;
        
        Test.stopTest();
        
        System.assertNotEquals(null, tempUser);
    }
    
    @isTest
    public static void testPostSandboxGenerationQueueable1(){
        
        Test.startTest();
        System.enqueueJob(new PostSandboxGenerationQueueable1());
        Test.stopTest();
        
        System.assertEquals(4, ([SELECT Id FROM Lead]).size(), 'Shouldve seen 4 leads on this one');
        System.assertEquals(1, ([SELECT Id FROM Account]).size(), 'Shouldve seen 1 Account on this one');
        System.assertEquals(3, ([SELECT Id FROM Contact WHERE RecordType.Name = 'Standard Contact']).size(), 'Shouldve seen 3 Standard Contacts on this one');
    }
    
    @isTest
    public static void testPostSandboxGenerationQueueable2(){
        
        List<Account> listOfAccounts = PostSandboxGeneration.createAccounts(1, 'School Account');
        insert listOfAccounts;
        
        Test.startTest();
        System.enqueueJob(new PostSandboxGenerationQueueable2(listOfAccounts, null));
        Test.stopTest();
        
        System.assertEquals(1, ([SELECT Id FROM IB_Country_Segmentation__c]).size(), 'Shouldve seen 1 Country Segmentation on this one');
        System.assertEquals(1, ([SELECT Id FROM IB_Address__c]).size(), 'Shouldve seen 1 IB Address on this one');
        System.assertEquals(4, ([SELECT Id FROM IB_Programme__c ]).size(), 'Shouldve seen 4 Programmes on this one');
    }
    
    @isTest
    public static void testPostSandboxGenerationQueueable3(){
        
        List<Account> accountRecords = PostSandboxGeneration.createAccounts(1, 'School Account');
        insert accountRecords;
        
        List<Contact> listOfContacts = PostSandboxGeneration.createContacts(10, 'Standard Contact');
        for(Contact tempCon : listOfContacts)
        {
            tempCon.AccountId = accountRecords[0].Id;
        }
        insert listOfContacts;
        
        IB_Country_Segmentation__c segmentation = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert segmentation;
        
        IB_Address__c address = PostSandboxGeneration.createIBAddressInstance('Active', 'Brooklyn', 'New York', '10001', segmentation, accountRecords[0]);
        insert address;
        
        List<IB_Programme__c> listOfProgrammes = PostSandboxGeneration.createIBProgrammes('Diploma Programme', address, 1);
        insert listOfProgrammes;
        
        Test.startTest();
        System.enqueueJob(new PostSandboxGenerationQueueable3(listOfContacts, listOfProgrammes));
        Test.stopTest();
        
        System.assertEquals(3, ([SELECT Id FROM IB_Role_Repository__c]).size(), 'Shouldve seen 3 Role(s) and Application(s) on this one');
        System.assertEquals(1, ([SELECT Id FROM IB_Application__c]).size(), 'Shouldve seen 1 IB Application on this one');
    }
}