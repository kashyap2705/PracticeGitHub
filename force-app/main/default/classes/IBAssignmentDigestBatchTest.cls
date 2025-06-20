/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      08/01/2023         <<PRB0041113>> Apex Test Execution Failed (IBAssignmentDigestBatchTest)
*******************************************************************************************/
@isTest
public class IBAssignmentDigestBatchTest {
    
    @testSetup 
    static void makeData () {
        
        IBEN_Assignment_Digest_Settings__c settings = new IBEN_Assignment_Digest_Settings__c ();
        settings.Number_of_Days__c = 14;
        settings.IBEN_Central_URL__c = 'www.google.com';
        
        insert settings;
        
		Account testAcct = AccountTestDataFactory.createAccount(null, null);
		testAcct.Name = 'Campaign-IBEN';
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
                Email = 't@t.com',
                Username = 'testuser@test.com',
                LastName = 'TestUser',
                isActive = true,
                Person_Code__c = '123456'
            ));
        insert testUser;
    }
    
    @isTest 
    static void testCreateAssignments() {
        
        Test.startTest();
     
        IBAssignmentDigestBatch batch = new IBAssignmentDigestBatch ();
        Database.executeBatch (batch);
        
        Test.stopTest();
    }
}