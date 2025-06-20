@isTest
private class Disable_IdTest {
  
  @isTest static void test_method_one() {
    Test.startTest();
//    User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');



 Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
 
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;
        
        
        user u = [select Name from user where email = 'ibportaluser@testorg.com'];
        u.email = 'test@plum.com';
        
        update u;

    System.runAs(usr){

/*      UserDAO uDAO = UserDAO.getInstance();

      User curUser = uDAO.getCurrentUser();
      Boolean internalUser = uDAO.isInternalUserForProfileId();
      Boolean isAccepted = uDAO.isAcceptedExternalUserForProfileName('SCU + Basic');
      User usr = uDAO.getUserByContactId(u.id);
      usr = uDAO.getFullUserPhotoUrlId('u.id');
      usr = uDAO.getUserByUsername('test@test.org');
      usr = uDAO.getUserById('u.id');
      */
    }
    Test.stopTest();
  }
}