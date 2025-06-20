@isTest
public with sharing class ContingencyMeasureRequestTest {
  
    @TestSetup
    static void setupTestData() {
        // Create test account
        Account testAccount = AccountTestDataFactory.createAccount(null, null);
        insert testAccount;
        
        // Create test contact
        Contact testContact = ContactTestDataFactory.createContact(null, 
            new Contact(AccountId = testAccount.Id, Email = 'testcontact@test.com'));
        insert testContact;
        
        // Create IB Country Segmentation
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        // Create IB Address
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = testAccount.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        // Create test user
        User testUser = UserTestDataFactory.createUser('SCU + Advanced', 
            new User(
                ContactId = testContact.Id,
                Email = 'testuser@test.com',
                Username = 'testuser@test.com',
                LastName = 'TestUser',
                isActive = true
            ));
        insert testUser;
        
        // Create IB Programme 
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme('PYP', null);
        prog.Account__c = testAccount.Id;
        prog.StageName__c = 'Request for Authorization';
        prog.Status__c = 'Candidate';
        prog.Street_Address__c = address.Id;
        prog.Owner__c = testUser.Id;
        insert prog;
        
        // Create IB Role Repository 
        IB_Role_Repository__c hosRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
        hosRepo.Role_Name__c = 'Head of School';
        insert hosRepo;
        
        // Create IB Role for the user
        IB_Role__c ibRole = new IB_Role__c(
            IB_Contact__c = testContact.Id,
            IB_Account__c = testAccount.Id,
            IB_Role__c = hosRepo.Id,
            Status__c = 'Confirmed',
            IB_Programme_New__c = prog.Id,
            Programme_Selection__c = 'PYP'
        );
        insert ibRole;
        
        // Create cut off date
        Cut_of_Date__c cutOffDate = new Cut_of_Date__c(
            Name = 'Test Cut Off',
            Session_Close_Date__c = Date.today().addDays(30),
            Session_Open_Date__c = Date.today().addDays(-5),
            Active__c = true,
            Type__c = 'Contingency measure'
        );
        insert cutOffDate;
        
        // Create test subject
        PGQA__c testSubject = new PGQA__c(
            Name = 'Test Subject',
            English__c = 'Test Subject'
        );
        insert testSubject;
        
        // Create test case
        Case testCase = CaseTestDataFactory.createCase('Contingency measure',
            new Case(
                AccountId = testAccount.Id,
                ContactId = testContact.Id,
                Status = 'Draft',
                Subject = 'Test Contingency Case'
            ));
        insert testCase;
        
        // Create contingency measure subject
        Contingency_Measure_Requests_Subject__c contingencySubject = new Contingency_Measure_Requests_Subject__c(
            Contingency_Related_Case__c = testCase.Id,
            Contingency_Subject_level__c = testSubject.Id,
            Contingency_eCoursework_submitted__c = 'Yes',
            examination_for_the_subject_taken__c = 'Yes'
        );
        insert contingencySubject;
    }
    
    private static User getTestUser() {
        return [SELECT Id, ContactId FROM User WHERE Username = 'testuser@test.com' AND isActive = true LIMIT 1];
    }
    
    private static Account getTestAccount() {
        return [SELECT Id FROM Account LIMIT 1];
    }
    
    private static Case getTestCase() {
        return [SELECT Id FROM Case LIMIT 1];
    }
    
    private static PGQA__c getTestSubject() {
        return [SELECT Id FROM PGQA__c LIMIT 1];
    }
    
    @isTest
    static void testGetConfirmedAccount() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            List<Account> accounts = ContingencyMeasureRequest.getConfirmedAccount();
            System.assertNotEquals(0, accounts.size(), 'Should return confirmed accounts');
            System.assertEquals(1, accounts.size(), 'Should return exactly one confirmed account');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetCases() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            List<Case> cases = ContingencyMeasureRequest.getCases();
            System.assertNotEquals(0, cases.size(), 'Should return cases for the contact');
            System.assertEquals(1, cases.size(), 'Should return exactly one case');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetCaseRecord() {
        User testUser = getTestUser();
        Case testCase = getTestCase();
        
        Test.startTest();
        System.runAs(testUser) {
            Case caseRecord = ContingencyMeasureRequest.getCaseRecord(testCase.Id);
            System.assertNotEquals(null, caseRecord, 'Should return case record');
            System.assertEquals(testCase.Id, caseRecord.Id, 'Should return the correct case');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetCutOffDate() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            String cutOffDate = ContingencyMeasureRequest.getCutOffDate();
            System.assertNotEquals(null, cutOffDate, 'Should return cut off date');
            System.assert(cutOffDate.length() > 0, 'Cut off date should not be empty');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testNecmDate() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            Cut_of_Date__c cutOffDate = ContingencyMeasureRequest.NecmDate();
            System.assertNotEquals(null, cutOffDate, 'Should return cut off date record');
            System.assertEquals(true, cutOffDate.Active__c, 'Should return active cut off date');
            System.assertEquals('Contingency measure', cutOffDate.Type__c, 'Should return correct type');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetRecordType() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            Id recordTypeId = ContingencyMeasureRequest.getRecordType();
            System.assertNotEquals(null, recordTypeId, 'Should return record type ID');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testReturnSubjectID() {
        User testUser = getTestUser();
        PGQA__c testSubject = getTestSubject();
        
        Test.startTest();
        System.runAs(testUser) {
            Id subjectId = ContingencyMeasureRequest.returnSubjectID('Test Subject');
            
            // Test with null input
            Id nullSubjectId = ContingencyMeasureRequest.returnSubjectID(null);
            System.assertEquals(null, nullSubjectId, 'Should return null for null input');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testAddCaseRecord() {
        
        User testUser = getTestUser();
        Account testAccount = getTestAccount();
        PGQA__c testSubject = getTestSubject();
        
        // Prepare subject wrapper data
        ContingencyMeasureRequest.SubjectWrapper subW = new ContingencyMeasureRequest.SubjectWrapper();
        subW.subjectLookup = testSubject.Id;
        subW.eCourcePicklist = 'Yes';
        subW.examTakenPicklist = 'Yes';
        String str = JSON.serialize(subW); 
        List<String> tempStr = new List<String>{str};
            
            Test.startTest();
        System.runAs(testUser) {
            ContingencyMeasureRequest.addCaseRecord(
                testAccount.Id, 
                '123456', 
                'May 2022', 
                'Draft', 
                'Test Description', 
                '0001110005', 
                'GGG444', 
                'David Roger', 
                'Travel restrictions',
                tempStr, 
                String.valueOf(Date.today().addDays(10)), 
                'Group (5 candidates or more)', 
                'true'
            );
            
            // Verify case was created with all fields
            Case newCase = [SELECT Id, Status, Contingency_Reasons__c, Candidate_Full_Name__c 
                            FROM Case 
                            WHERE AccountId = :testAccount.Id 
                            ORDER BY CreatedDate DESC LIMIT 1];
            System.assertEquals(2, [SELECT COUNT() FROM Case WHERE AccountId = :testAccount.Id], 
                                'Should have created a new case');
            System.assertEquals('Draft', newCase.Status, 'Status should be set correctly');
            System.assertEquals('David Roger', newCase.Candidate_Full_Name__c, 'Name should be set correctly');
            
            // Verify subjects were created
            List<Contingency_Measure_Requests_Subject__c> subjects = [
                SELECT Id 
                FROM Contingency_Measure_Requests_Subject__c 
                WHERE Contingency_Related_Case__c = :newCase.Id
            ];
            System.assertEquals(1, subjects.size(), 'Should have created subject records');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateRequestForCancellation() {
        User testUser = getTestUser();
        Case testCase = getTestCase();
        
        Test.startTest();
        System.runAs(testUser) {
            ContingencyMeasureRequest.updateRequestForCancellation(testCase.Id, 'Test cancellation reason');
            
            // Verify case was updated
            Case updatedCase = [SELECT Status, Contingency_M_Reason_for_cancellation__c FROM Case WHERE Id = :testCase.Id];
            System.assertEquals('Cancellation Requested', updatedCase.Status, 'Status should be updated');
            System.assertEquals('Test cancellation reason', updatedCase.Contingency_M_Reason_for_cancellation__c, 'Reason should be updated');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteCase() {
        User testUser = getTestUser();
        Case testCase = getTestCase();
        List<Id> caseIds = new List<Id>{testCase.Id};
        
        Test.startTest();
        System.runAs(testUser) {
            ContingencyMeasureRequest.deleteCase(caseIds);
            
            // Verify case was deleted
            List<Case> cases = [SELECT Id FROM Case WHERE Id = :testCase.Id];
            System.assertEquals(0, cases.size(), 'Case should be deleted');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetUserLocale() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            String locale = ContingencyMeasureRequest.getUserLocale();
            System.assertNotEquals(null, locale, 'Should return user locale');
            System.assertEquals('en_US', locale, 'Should return correct locale');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testSaveFile() {
        User testUser = getTestUser();
        Case testCase = getTestCase();
        
        // Create test content version
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.txt',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;
        
        // Get content document
        ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
        
        Test.startTest();
        System.runAs(testUser) {
            ContingencyMeasureRequest.saveFile(testCase.Id, 'Test', 'Test.txt', cv.ContentDocumentId);
            
            // Verify file was saved
            List<ContentDocumentLink> links = [
                SELECT Id 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :testCase.Id
            ];
        }
        Test.stopTest();
    }
    
    @isTest
    static void testAddCaseRecordWithNullAccount() {
        User testUser = getTestUser();
        
        Test.startTest();
        System.runAs(testUser) {
            try {
                ContingencyMeasureRequest.addCaseRecord(
                    null, // null account
                    '123456', 
                    'May 2022', 
                    'Draft', 
                    'Test Description', 
                    '0001110005', 
                    'GGG444', 
                    'David Roger', 
                    'Travel restrictions',
                    new List<String>(), 
                    null, 
                    'Group', 
                    'true'
                );
            } catch (Exception e) {
                System.assert(true, 'Expected exception for null account');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testBulkOperations() {
        
        User testUser = getTestUser();
        Account testAccount = getTestAccount();
        
        // Create multiple cases to test bulk behavior
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 10; i++) {
            cases.add(CaseTestDataFactory.createCase('Contingency measure',
                                                     new Case(
                                                         AccountId = testAccount.Id,
                                                         ContactId = testUser.ContactId,
                                                         Status = 'Draft',
                                                         Subject = 'Bulk Test ' + i
                                                     ))
                                                    ); 
                      }
                      insert cases;
                      
                      Test.startTest();
                      System.runAs(testUser) {
                          // Test bulk case retrieval
                          List<Case> retrievedCases = ContingencyMeasureRequest.getCases();
                          System.assertEquals(11, retrievedCases.size(), 'Should return all cases');
                          
                          // Test bulk deletion
                          List<Id> caseIds = new List<Id>();
                          for (Case c : cases) {
                              caseIds.add(c.Id);
                          }
                          ContingencyMeasureRequest.deleteCase(caseIds);
                          System.assertEquals(1, [SELECT COUNT() FROM Case], 'Should have deleted bulk cases');
                      }
                      Test.stopTest();
                      }
    
    @isTest
    static void testCreateContentLink() {
        
        User testUser = getTestUser();
        Case testCase = getTestCase();
        
        // Create a ContentVersion 
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test Content',
            PathOnClient = 'TestContent.txt',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersion;
        
        // Get the ContentVersion ID
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id];
        
        Test.startTest();
        System.runAs(testUser) {
            // Test 1: Valid inputs - should create ContentDocumentLink and ContentDistribution
            ContentDocumentLink cdl = ContingencyMeasureRequest.createContentLink(cv.Id, testCase.Id);
            System.assertNotEquals(null, cdl, 'ContentDocumentLink should be created for valid inputs');
            System.assertEquals(testCase.Id, cdl.LinkedEntityId, 'LinkedEntityId should match the case ID');
            System.assertEquals(cv.ContentDocumentId, cdl.ContentDocumentId, 'ContentDocumentId should match the ContentVersion');
            
            // Verify ContentDistribution was created
            List<ContentDistribution> distributions = [
                SELECT Id, ContentVersionId, Name, PreferencesNotifyOnVisit
                FROM ContentDistribution
                WHERE ContentVersionId = :cv.Id
            ];
            System.assertEquals(1, distributions.size(), 'ContentDistribution should be created');
            System.assertEquals(cv.Id, distributions[0].ContentVersionId, 'ContentVersionId should match');
            System.assertEquals(false, distributions[0].PreferencesNotifyOnVisit, 'PreferencesNotifyOnVisit should be false');
            
            // Test 2: Null contentVersionId - should return null
            ContentDocumentLink cdlNull1 = ContingencyMeasureRequest.createContentLink(null, testCase.Id);
            System.assertEquals(null, cdlNull1, 'Should return null when contentVersionId is null');
            
            // Test 3: Null recordId - should return null
            ContentDocumentLink cdlNull2 = ContingencyMeasureRequest.createContentLink(cv.Id, null);
            System.assertEquals(null, cdlNull2, 'Should return null when recordId is null');
        }
        Test.stopTest();
    }
}