@isTest
public class AccountAssociationcontrollerTest {
    
    @isTest public  static void TestOne()
    {
        User thisUser = [ select Id from User where UserRoleId!=null and isActive=true and profileid!=null limit 1];
        Account acc ;
        Contact con;
        Profile p;
        user u;
        
          acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
            insert acc;
            con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
            con.AccountId=acc.id;
            insert con;
            
            con=[select id from contact limit 1][0];
            
            p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
            u= new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                        emailencodingkey='UTF-8', lastname='smiths', 
                        languagelocalekey='en_US', 
                        localesidkey='en_US',
                        timezonesidkey='America/Los_Angeles',username='testObama@example.com',ContactId=con.id
                       ); 
        
        Test.startTest();
        System.runAs(u)
        {
            system.assertNotEquals(null,AccountAssociationcontroller.getSelectedAccountData(acc.id));
            system.assertNotEquals(label.BASE_URL,AccountAssociationcontroller.getBaseUrl());
            system.assertNotEquals('smith',AccountAssociationcontroller.getUserDetails());
            system.assertEquals(false,AccountAssociationcontroller.isAdmin(acc.id)); 
             system.assertEquals(true,AccountAssociationcontroller.addAccountOnContact(acc.id));
            AccountAssociationcontroller.getAllAccounts();
        }
        Test.stopTest();
    }
}