@isTest
public class IBPortalForgotUserNameLWCTest {

@isTest
    public static void testUsername(){
        account acct = new Account();
        acct.IBIS_ID__c = '717171';
        acct = AccountTestDataFactory.createAccount(null,acct);
        insert acct;
        
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country.IBEN_Independent_Account__c = acct.Id;
        country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(country);
        insert country;
            
        Contact contactib = new Contact();
        contactib.AccountId = acct.id;
        contactib.Country__c = country.id;
        contactib.FirstName = 'test1';
        contactib.LastName = 'test2';
        contactib.Country_of_Birth__c = 'test3';
        contactib.Birthdate = Date.today().addYears(-22);
        contactib = ContactTestDataFactory.createContact(null,contactib);
        insert contactib;
        
         Map<String, String>  testLabelsByLanguage = new Map<String, String>();
        testLabelsByLanguage.put('IBPortalUserName','st Label Va');
        User usr = new User();
        usr = UserTestDataFactory.createUser('Customer Community Basic', usr);
        usr.ContactId = contactib.Id;
        usr.IsActive = true;
        insert usr;
            Test.startTest();
            
            
            IBPortalForgotUserNameLWC.getPickListValuesIntoList();
            IBPortalForgotUserNameLWC.sendEmail(contactib.Id);
            IBPortalForgotUserNameLWC.getvaluesbyLanguage('fr'); 	
            IBPortalForgotUserNameLWC.getUserList('test1', 'test2', Date.today().addYears(-22), 'test3');

            System.assertEquals(16,IBPortalForgotUserNameLWC.getvaluesbyLanguage('fr').values().size());

            Test.stopTest();
        
    }
   
}