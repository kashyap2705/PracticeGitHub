/**
* <h1>Contact Deletion Test Class</h1>
* This Test class is responsible to test DeleteNewContactMadeforRole,US-10851
* 
* @author  Abd ur Rehman
* @version 1.0
* @since   07-22-2019 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

  
*/
 @isTest
public class TestDeleteNewContactMadeforRole {
    
      /**
   * This test method to check functionlity of DeleteNewContactMadeforRole
   */
    private static testMethod void deletecontact(){
        try{
         Account theAccount = PimsTestUtil.createAccount('Test Account', 'School Account');
        insert theAccount;
        
        IB_Country_Segmentation__c theCountry = TestsUtil.createCountry('testname', 'EUROPE', theAccount);
        insert theCountry;
        
        Contact theContact = PimsTestUtil.createContact('Test Contact', 'example@gmail.com', 'example@gmail.com', Date.today(), theAccount);
        insert theContact;
        
        Test.startTest();
         //Throw Exception
        DeleteNewContactMadeforRole.DeleteContact(null);
        List<Contact> theContactList = [Select id from Contact where id =: theContact.id];
        system.debug('contact1 =' + theContactList.size());    
        System.assertEquals(1, theContactList.size());
        //Deleting Contact
        DeleteNewContactMadeforRole.DeleteContact(theContact.id);  
        Test.stopTest();
            
        theContactList = [Select id from Contact where id =: theContact.id];
        System.assertEquals(0, theContactList.size());
    }
    catch(Exception ex){
        System.debug('Exception: '+ex);
    }
    }

}