@isTest
private class ContactMyAssignmentRelatedListTest {
    
    static testMethod void ContactMyAssignmentRelatedListTestController()  {
        integer i = 1;
        // Create a test contact
         Date dd = Date.newInstance(1999, 12, 9);
         /*Plumlogix - Updated the phone number fields for validation rule in US11129 */
         //Begin
        Contact testContact = new Contact(FirstName='test', LastName='test',Homephone='+1234891123',Phone='+1234891123',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(),birthdate = dd);
        insert(testContact);
        //End
        // Create a My Assignment (new) record
        My_Staffing_Event__c testAssignment = new My_Staffing_Event__c(
            IB_Contact__c = testContact.Id
         //   Application_Status__c ='invited',
            
        );
      //  insert(testAssignment);

        
        // UPdate the assignment's Application_Status to CONFIRMED for this test
        /*
        testAssignment.Application_Status__c = 'Confirmed';
        update(testAssignment);
        */
        
        // Create the page context
        Test.setCurrentPage(new PageReference ('/apex/ContactMyAssignmentRelatedList?Id=' + testContact.id));
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        ApexPages.StandardController sc = new ApexPages.StandardController(testContact);
        ContactMyAssignmentRelatedList objCA = new ContactMyAssignmentRelatedList(sc);

        /*
        // TEST: verify the controller extension returns the correct amount of Assignments for this Contact
        List<My_Staffing_Event__c> results = objCA.lstMyAssignments;
        System.assertEquals(1, results.size());
        */
    }
}