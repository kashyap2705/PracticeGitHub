@isTest
private class CSM_OpenNewCaseTest {
	   @testSetup
    static void makeData(){
        User u = PimsTestUtil.createPortalUserPYP('testgck123@test.com', false);
        insert u;
        IB_Role_Repository__c headOfSchool = PimsTestUtil.createRoleRepo('Head of School');
        insert headOfSchool;
        Account acc = [select id from Account where name = 'test acc name'];
        IB_Role__c headOfSchoolRole = PimsTestUtil.createIbRole(headOfSchool.Id, u.contactId, acc.Id);
        insert headOfSchoolRole;
    }
    
    @isTest
    static void testGetContentVersions() {
        User u = [select id from User where email = 'testgck123@test.com'];
        // Create a ContentDocument and ContentVersion
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.txt',
            VersionData = Blob.valueOf('Test Data')
        );
        insert cv;

        // Call the getContentVersions method
        Test.startTest();
        System.runAs(u){
			List<ContentVersion> versions = CSM_OpenNewCase.getContentVersions(new List<String>{cv.ContentDocumentId});
               }
        
        Test.stopTest();
    }
    @isTest
    static void testGetFieldSet() {
        // Create test data
        Case c = new Case();
        insert c;

        // Call the getFieldSet method
        Test.startTest();
        List<Map<String, Object>> fieldSet = CSM_OpenNewCase.getFieldSet('Case', 'IB_ANSWERS_Assessment');
        Test.stopTest();
         try {
        List<Map<String, Object>> fieldSet1 = CSM_OpenNewCase.getFieldSet('324234', '234234');
    } catch (AuraHandledException e) {
        // Verify that the exception message is as expected
        System.assertEquals('Exception message', e.getMessage());
    }

    }
     @isTest
    static void testDeleteContentDocument_Success() {
        // Create test data
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

        List<String> contentDocumentIds = new List<String>{cv1.Id, cv2.Id};

        // Call the method
        Test.startTest();
        String result = CSM_OpenNewCase.deleteContentDocument(contentDocumentIds);
        Test.stopTest();

        // Verify the results
        System.assertEquals('Success', result);
        List<ContentDocument> contentDocuments = [
            SELECT Id
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];
        System.assertEquals(0, contentDocuments.size());
    }

    @isTest
    static void testDeleteContentDocument_Fail() {
        // Call the deleteContentDocument method with an invalid ContentDocumentId
        Test.startTest();
         try {
       String result1 =CSM_OpenNewCase.deleteContentDocument(new List<String>{'5445435333'});
    } catch (AuraHandledException e) {
        // Verify that the exception message is as expected
        System.assertEquals('Exception message', e.getMessage());
    }
        Test.stopTest();

        // Verify that the method returns 'fail'
        
    }
     @isTest
    static void testGetCategories() {
        // Create test data
        Category1__c category1 = new Category1__c(Name='Category1', Label__c='Category1 Label');
        Category2__c category2 = new Category2__c(Name='Category2', Label__c='Category2 Label');
        Category3__c category3 = new Category3__c(Name='Category3', Label__c='Category3 Label');
        insert new List<Category1__c>{category1};
        insert new List<Category2__c>{category2};
        insert new List<Category3__c>{category3};

        // Call the method
        Test.startTest();
        Map<String, sObject> categories = CSM_OpenNewCase.getCategories();
        Test.stopTest();
        

        // Verify the results
        System.assertEquals(3, categories.size());
        System.assertEquals('Category1 Label', ((Category1__c)categories.get('Category1')).Label__c);
        System.assertEquals('Category2 Label', ((Category2__c)categories.get('Category2')).Label__c);
        System.assertEquals('Category3 Label', ((Category3__c)categories.get('Category3')).Label__c);
        
        try {
        CSM_OpenNewCase.getCategories();
    } catch (AuraHandledException e) {
        // Verify that the exception message is as expected
        System.assertEquals('Exception message', e.getMessage());
    }
    }
 @isTest
    static void testGetCategory2_3_MappingRecord() {
        // Create test data for Category2__c
        Category2__c category2 = new Category2__c(Name = 'Test Category 2');
        insert category2;

        // Create test data for Category3__c
        Category3__c category3 = new Category3__c(Name = 'Test Category 3');
        insert category3;

        // Create test data for Category2_3_Mapping__c
        Category2_3_Mapping__c mappingRecord = new Category2_3_Mapping__c(
            IB_Roles__c = 'IBEN_Roles',
            Category2__c = category2.Id,
            Category3__c = category3.Id,
            Form_Label__c = 'IB_ANSWERS_Assessment'
        );
        insert mappingRecord;

        // Call the method with test data
        Category2_3_Mapping__c result = CSM_OpenNewCase.getCategory2_3_MappingRecord('IBEN_Roles', 'Test Category 2', 'Test Category 3');
			
        // Assert the result
        System.assertEquals('IB_ANSWERS_Assessment', result.Form_Label__c);
        try {
        Category2_3_Mapping__c result1 = CSM_OpenNewCase.getCategory2_3_MappingRecord('Invalid Role', 'Test Category 2', 'Test Category 3');
    } catch (AuraHandledException e) {
        // Verify that the exception message is as expected
        System.assertEquals('Exception message', e.getMessage());
    }
        
    }
}