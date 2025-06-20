@isTest
public class ContactEducatorBackgroundTests {

    static testMethod void pageLoadTest(){
        // Create a test contact
        Date dd = Date.newInstance(1999, 12, 9);
        Contact testContact = new Contact(FirstName='test', LastName='test',Homephone='123',Phone='123',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert(testContact);
        
        // Create Educator Background test records
        RecordType recType = [select Id, Name from RecordType where SobjectType = 'IB_E_Background__c' and DeveloperName = 'Educational_Degrees'];
        
       	IB_E_Background__c testBackground = new IB_E_Background__c(
            IB_Contact__c = testContact.Id,
            RecordTypeId = recType.Id,
            Language__c = 'English',
            Language_Delivery__c = 'English',
            Educational_Degree__c = 'Diploma', 
            Field_of_Study__c = 'Education', 
            School__c = 'Harvard', 
            Country__c = 'United States',
            IB_Workshop_Title__c = 'Sample Workshop Title', 
            Role__c = 'Teacher');
        insert(testBackground);

        
        
        
        // Create the page context
        Test.setCurrentPage(new PageReference ('/apex/ContactEducatorBackgroundRelatedList?Id=' + testContact.id));
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ContactEducatorBackgroundRelatedListCon objCA = new ContactEducatorBackgroundRelatedListCon(sc);

        // TEST: verify the controller extension returns the correct amount of Assignments for this Contact
        List<IB_E_Background__c> results = objCA.backgroundList;
        System.assertEquals(1, results.size());
        
    }
    
}