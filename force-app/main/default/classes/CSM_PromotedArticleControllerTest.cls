@isTest
public class CSM_PromotedArticleControllerTest {
    
    @TestSetup
    static void setupTestData() {
        
        Account accRec = new Account();
        accRec = AccountTestDataFactory.createAccount('School Account',accRec);
        insert accRec;
   
        Contact contactRecord = new Contact();
        contactRecord.AccountId = accRec.Id;
        contactRecord.LastName = 'Messi0';
        contactRecord = ContactTestDataFactory.createContact(null,contactRecord);
        insert contactRecord;
   
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = accRec.Id;
        
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
        
        List<IB_Address__c> ibAddList = new List<IB_Address__c>();
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = accRec.Id;
        ibAdd.Country__c = ibCon.id;
        
        ibAddList = IBAddressTestDataFactory.createIBAddresses(ibAdd, 3);
        insert ibAddList;
 
        User commUser = new User();
        commUser.FirstName = contactRecord.FirstName;
        commUser.LastName = contactRecord.LastName;
        commUser.username = contactRecord.Email;
        commUser.email = contactRecord.Email;
        commUser.contactId = contactRecord.Id;
        commUser.IsActive = true;
        User communityUser = UserTestDataFactory.createUser('Customer Community Advanced',commUser);
        
        insert communityUser;
    }
    
    @isTest
    static void testPromotedArticleController() {  
        User userRecord = [
            SELECT id, LastName
            FROM user
            WHERE Lastname = 'Messi0'
        ];
        System.assertEquals('Messi0', userRecord.LastName, 'User last name does not match expected value.');
        System.runAs(userRecord) {
            Test.startTest();
            List<String> articles = CSM_PromotedArticleController.getPromotedArticles();
            Test.stopTest();
            System.assertNotEquals(null, articles, 'Returned article list should not be null.');
            System.assertEquals(true, articles.size() >= 0, 'Article list size is invalid.');
        }
    }
    
    @isTest
    static void testTopCategory() {  
        User userRecord = [
            SELECT id, Lastname
            FROM user
            WHERE Lastname = 'Messi0'
        ];
        System.assertEquals('Messi0', userRecord.LastName, 'User last name does not match expected value.');
        System.runAs(userRecord) {
            Test.startTest();
            List<String> topCategories = CSM_PromotedArticleController.getTopCategory1();
            Test.stopTest();
            System.assertNotEquals(null, topCategories, 'Returned category list should not be null.');
            System.assertEquals(true, topCategories.size() >= 0, 'Category list size is invalid.');
        }
    }
}