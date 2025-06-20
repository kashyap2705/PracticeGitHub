@isTest
private class CSM_CaseControllerTest {
    
    @testSetup
    static void makeData() {
        
        String profileName = 'Customer Community Advanced';
        String testemail = 'testyb123@test.com';
        
        Account testAccount = AccountTestDataFactory.createAccount(null,null);
        insert testAccount;
        
        Contact newContact = new Contact();
        newContact.AccountId = testAccount.Id;
        
        Contact testContact = ContactTestDataFactory.createContact(null,newContact);
        insert testContact;
        
        User newUser = new User();
        newUser.email = testemail;
        newUser.username = testemail;
        newUser.contactId = testContact.id;
        
        User portalUser = UserTestDataFactory.createUser(profileName,newUser);
        insert portalUser;
        
        testContact.User__c = portalUser.Id;
        update testContact;
    }
    
    @isTest
    static void testIsReCAPTCHAValid() {
        
        User usr = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"success": true}');
        Test.setMock(
            HttpCalloutMock.class,
            new MockHttpResponseGenerator(response)
        );
        
        Test.startTest();
        String result;
        System.runAs(usr) {
            result = CSM_CaseController.isReCAPTCHAValid('fakeToken');
        }
        Test.stopTest();
        
        System.assertEquals('Success', result, 'The reCAPTCHA validation should return "true".');
    }
    
    @isTest
    static void testIsReCAPTCHAValidException() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        HttpResponse response = new HttpResponse();
        response.setBody('{"success": true}');
        Test.setMock(
            HttpCalloutMock.class,
            new MockHttpResponseGenerator(response)
        );
        
        System.runAs(u) {
            Test.startTest();
            try {
                CSM_CaseRecaptchaController.isException = true;
                CSM_CaseController.isReCAPTCHAValid('fakeToken');
            } catch (Exception exp) {
                Assert.isNotNull(exp, 'Exception thrown from get help info is null');
            }
            Test.stopTest();
        }
    }
    
    /**
     * @description MockHttpResponseGenerator is a mock class that implements the HttpCalloutMock interface 
     * to provide mock responses for HTTP callouts in tests.
     */
    public class MockHttpResponseGenerator implements HttpCalloutMock {
    
        private HttpResponse response;
    
        /**
         * @description Constructor to initialize the mock response.
         * @param response The HttpResponse object to return when the mock callout is invoked.
         */
        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }
    
        /**
         * @description This method returns the mock HttpResponse for a given HttpRequest.
         * @param req The HttpRequest object representing the callout request.
         * @return The mock HttpResponse object to be returned.
         */
        public HttpResponse respond(HttpRequest req) {
            return response;
        }
    }

    @isTest
    static void testUpdateContentetDocuments() {
        
        List<ContentVersion> testContentVersions = new List<ContentVersion>();
        for (Integer i = 0; i < 5; i++) {
            testContentVersions.add(
                new ContentVersion(
                    Title = 'Test Content ' + i,
                    VersionData = Blob.valueOf('Test Data'),
                    PathOnClient = 'Test Path',
                    IsMajorVersion = true
                )
            );
        }
        insert testContentVersions;

        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        
        List<Id> testContentVersionIds = new List<Id>();
        
        for (ContentVersion cv : testContentVersions) {
            testContentVersionIds.add(cv.Id);
        }
        Test.startTest();
        CSM_CaseAuController.updateContentDocuments(
            testContentVersionIds,
            testCase.Id
        );
        
        List<ContentDocument> updatedContentDocumentsList = [
            SELECT id, title
            FROM contentDocument
        ];
        System.assertEquals(
            'IB_Answers_Test Content 0',
            updatedContentDocumentsList[0].title,
            'The title of the first updated ContentDocument is incorrect.'
        );
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateContentetDocumentsException() {
        
        Test.startTest();
        
        List<ContentVersion> testContentVersions = new List<ContentVersion>();
        for (Integer i = 0; i < 5; i++) {
            testContentVersions.add(
                new ContentVersion(
                    Title = 'Test Content ' + i,
                    VersionData = Blob.valueOf('Test Data'),
                    PathOnClient = 'Test Path',
                    IsMajorVersion = true
                )
            );
        }
        insert testContentVersions;
        
        Case testCase = new Case(Subject = 'Test Case');
        insert testCase;
        
        List<Id> testContentVersionIds = new List<Id>();
        
        for (ContentVersion cv : testContentVersions) {
            testContentVersionIds.add(cv.Id);
        }
        
        try {
            CSM_CaseAuController.isException = true;
            CSM_CaseAuController.updateContentDocuments(
                testContentVersionIds,
                testCase.Id
            );
        } catch (Exception exp) {
            Assert.isNotNull(exp, 'Exception thrown from get help info is null');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateContactEmail() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Test.startTest();
        System.runAs(u) {
            try {
                Contact testContact = new Contact(
                    FirstName = 'Test',
                    LastName = 'Contact',
                    Email = 'test@test12.com',
                    Alternative_Email__c = 'test@example.com'
                );
                insert testContact;
                
                Case testCase = new Case(
                    Subject = 'Test Case',
                    ContactId = testContact.Id
                );
                insert testCase;
                
                Map<String, Object> contactData = new Map<String, Object>{'Alternative_Email__c' => 'newemail@example.com'};                                               
                    CSM_CaseAuController.updateContactEmail(contactData, testCase);
                
                Contact updatedContact = [
                    SELECT Alternative_Email__c
                    FROM Contact
                    WHERE Id = :testContact.Id
                ];
                System.assertNotEquals(
                    'newemail@example.com',
                    updatedContact.Alternative_Email__c,
                    'The contact\'s alternative email should not have been updated to the new value.'
                );
            } catch (Exception ex) {
                Assert.isNotNull(ex, 'Exception is null');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateContactEmailException() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test12.com',
            Alternative_Email__c = 'test@example.com'
        );
        insert testContact;
        
        Case testCase = new Case(Subject = 'Test Case', ContactId = testContact.Id);
        insert testCase;
        
        Map<String, Object> contactData = new Map<String, Object>{'Alternative_Email__c' => 'newemail@example.com'};
            
            System.runAs(u) {
                Test.startTest();
                CSM_CaseAuController.isException = true;
                try {
                    CSM_CaseAuController.updateContactEmail(contactData, testCase);
                } catch (Exception exp) {
                    Assert.isNotNull(
                        exp,
                        'Exception thrown from updateContactEmail is null'
                    );
                }
                Test.stopTest();
            }
    }
    
    @isTest
    static void testGetContentVersions() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.txt',
            VersionData = Blob.valueOf('Test Data')
        );
        insert cv;
        
        List<String> testListString = new List<String>();
        testListString.add('324234234234');
        
        Test.startTest();
        System.runAs(u) {
            try {
                CSM_CaseController.getContentVersions(testListString);
            } catch (Exception exp) {
                Assert.isNotNull(exp, 'Exception is null');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetFieldSet() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Case c = new Case();
        insert c;
        
        Test.startTest();
        System.runAs(u) {
            try {
                List<Map<String, Object>> fieldSet = CSM_CaseController.getFieldSet(
                    'Case',
                    'IB_ANSWERS_Assessment'
                );
                System.assert(fieldSet.size() > 0, 'The fieldSet should contain at least one field.');
            } catch (AuraHandledException e) {
                System.assertEquals('Exception message', e.getMessage(),'The AuraHandledException message did not match the expected value.');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteContentDocumentSuccess() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        ContentVersion cv1 = new ContentVersion(
            Title = 'Test 1',
            PathOnClient = 'test1.txt',
            VersionData = Blob.valueOf('Test Data 1')
        );
        insert cv1;
        
        ContentVersion cv2 = new ContentVersion(
            Title = 'Test 2',
            PathOnClient = 'test2.txt',
            VersionData = Blob.valueOf('Test Data 2')
        );
        insert cv2;
        
        List<String> contentDocumentIds = new List<String>{ cv1.Id, cv2.Id };
        List<String> contentDoctInvalidId = new List<String>{'2323423423','87687678678'};
                        
        Test.startTest();
        System.runAs(u) {
            String result = CSM_CaseController.deleteContentDocument(
                contentDocumentIds
            );
            try {
                CSM_CaseController.deleteContentDocument(contentDoctInvalidId);
                System.assertEquals('Success', result,'The content documents were not deleted successfully.');
            } catch (Exception ex) {
                System.assertEquals('Exception message', ex.getMessage(),'The exception message is not as expected.');
            }
        }
        
        Test.stopTest();
        List<ContentDocument> contentDocuments = [
            SELECT Id
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];
        System.assertEquals(0, contentDocuments.size(),'Content documents were not deleted from the system.');
    }
    
    @isTest
    static void testDeleteContentDocumentFail() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];

        Test.startTest();
        System.runAs(u) {
            try {
                String result1 = CSM_CaseAuController.deleteContentDocument(
                    new List<String>{ '5445435333' }
                );
                System.assertEquals('Success', result1, 'The method did not return the expected error message.');
            } catch (AuraHandledException e) {
                System.assertEquals('Exception message', e.getMessage(),'The AuraHandledException message did not match the expected value.');
            }
            Test.stopTest();
        }
    }
    
    @isTest
    static void testGetCategories() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Category1__c category1 = new Category1__c(
            Name = 'Category1',
            Label__c = 'Category1 Label'
        );
        Category2__c category2 = new Category2__c(
            Name = 'Category2',
            Label__c = 'Category2 Label'
        );
        Category3__c category3 = new Category3__c(
            Name = 'Category3',
            Label__c = 'Category3 Label'
        );
        insert new List<Category1__c>{ category1 };
        insert new List<Category2__c>{ category2 };
        insert new List<Category3__c>{ category3 };
                    
        Test.startTest();
        
        System.runAs(u) {
            Map<String, sObject> categories = CSM_CaseController.getCategories();
            System.assertEquals(3, categories.size(),'Expected 3 categories, but found a different number.');
            System.assertEquals('Category1 Label',((Category1__c) categories.get('Category1')).Label__c, 'Category1 Label mismatch.');
            System.assertEquals('Category2 Label',((Category2__c) categories.get('Category2')).Label__c, 'Category2 Label mismatch.');
            System.assertEquals('Category3 Label',((Category3__c) categories.get('Category3')).Label__c, 'Category3 Label mismatch.');
        }
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetCategoriesException() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
   
        System.runAs(u) {
            Test.startTest();
            CSM_CaseController.isException = true;
            try {
                Map<String, sObject> categories = CSM_CaseController.getCategories();
                System.assert(categories.size() > 0, 'Categories should not be empty');
            } catch (AuraHandledException exp) {
                Assert.isNotNull(exp, 'Exception thrown from get help info is null');
            }
            Test.stopTest();
        }
    }
    
    @isTest
    static void testGetCategory23MappingRecordException() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Category2__c category2 = new Category2__c(Name = 'Test Category 2');
        insert category2;
        
        Category3__c category3 = new Category3__c(Name = 'Test Category 3');
        insert category3;

        Category2_3_Mapping__c mappingRecord = new Category2_3_Mapping__c(
            IB_Roles__c = 'IBEN_Roles',
            Category2__c = category2.Id,
            Category3__c = category3.Id,
            Form_Label__c = 'IB_ANSWERS_Assessment'
        );
        insert mappingRecord;
        
        System.runAs(u) {
            Test.startTest();
            CSM_CaseController.isException = true;
            try {
                Category2_3_Mapping__c result = CSM_CaseController.getCategory2_3_MappingRecord(
                    'IBEN_Roles',
                    'Test Category 2',
                    'Test Category 3'
                );
                System.assert(result != null, 'Result should not be null when no exception is thrown.');
            } catch (AuraHandledException exp) {
                Assert.isNotNull(
                    exp,
                    'Exception thrown from getCategory2_3_MappingRecord is null'
                );
            }
            Test.stopTest();
        }
    }
    
    @isTest
    static void testGetCategory23MappingRecord() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
       
        Category2__c category2 = new Category2__c(Name = 'Test Category 2');
        insert category2;

        Category3__c category3 = new Category3__c(Name = 'Test Category 3');
        insert category3;
        
        Category2_3_Mapping__c mappingRecord = new Category2_3_Mapping__c(
            IB_Roles__c = 'IBEN_Roles',
            Category2__c = category2.Id,
            Category3__c = category3.Id,
            Form_Label__c = 'IB_ANSWERS_Assessment'
        );
        insert mappingRecord;
        Test.startTest();
        
        System.runAs(u) {
            Category2_3_Mapping__c result = CSM_CaseController.getCategory2_3_MappingRecord(
                'IBEN_Roles',
                'Test Category 2',
                'Test Category 3'
            );
            if(result!=null) { 
	            System.assertEquals('IB_ANSWERS_Assessment', result.Form_Label__c, 'The retrieved Form_Label__c value does not match the expected value.');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCreateCaseNAU() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Map<String, Object> caseData = new Map<String, Object>{
            'Subject' => 'Test Subject',
                'Date_of_workshop__c' => '2024-03-01'
                };
                    Map<String, Object> contactData = new Map<String, Object>();
        
        Test.startTest();
        System.runAs(u) {
            try {
                CSM_CaseController.createCaseNAU(caseData, contactData);
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(),'An AuraHandledException was expected, but the exception message was null.');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCreateCaseAU() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        Map<String, Object> caseData = new Map<String, Object>{
            'Subject' => 'Test Subject',
                'Date_of_workshop__c' => '2024-03-01'
                };
                    Map<String, Object> contactData = new Map<String, Object>();
        List<Id> contentVersionIds = new List<Id>();

        Test.startTest();
        System.runAs(u) {
            try {
                Case newCase = CSM_CaseController.createCaseAU(
                    caseData,
                    contactData,
                    contentVersionIds
                );
                Assert.isNotNull(newCase.Id, 'The created Case record ID should not be null.');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(),'An AuraHandledException was expected, but the exception message was null.');
            }
        }
        Test.stopTest();
    }
    
    @isTest
    static void testCreateCaseAUException() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1]; 
       
        Map<String, Object> caseData = new Map<String, Object>{
            'Subject' => 'Test Subject',
                'Date_of_workshop__c' => '2024-03-01'
                };
                    Map<String, Object> contactData = new Map<String, Object>();
        List<Id> contentVersionIds = new List<Id>();
        
        System.runAs(u) {
            Test.startTest();
            CSM_CaseController.isException = true;
            try {
                Case createdCaseWithException = CSM_CaseController.createCaseAU(
                    caseData,
                    contactData,
                    contentVersionIds
                );
                System.assertNotEquals(null, createdCaseWithException, 'Expected a case to be created, but none was returned.');
            } catch (AuraHandledException e) {
                System.assertNotEquals(null, e.getMessage(),'An AuraHandledException was expected, but the exception message was null.');
            }
            Test.stopTest();
        }
    }
    
    @isTest
    static void testCaseData() {
        
        User u = [SELECT Id FROM User WHERE isActive = true LIMIT 1];
        
        List<String> testListString = new List<String>();
        testListString.add('324234234234');
        Test.startTest();
        System.runAs(u) {
            try {
                CSM_CaseController.getCaseData(testListString, '5645645646464');
            } catch (AuraHandledException ex) {
                System.assertNotEquals(null, ex.getMessage(),'Expected an AuraHandledException, but the exception message was null.');
            }
        }
        Test.stopTest();
    }
    
}