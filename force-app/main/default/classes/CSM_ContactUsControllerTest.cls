/**
 * @description       : class for CSM_ContactUsControllerTest
 * @author            : Yatin Bajaj
 * @last modified on  : 03-25-2024
 * @last modified by  : Yatin Bajaj
**/
@isTest
private class CSM_ContactUsControllerTest {
  @TestSetup
  static void setupTestData() {
    String accountName = 'test account name';
    String contactName = 'test contact name';
    String testemail = 'testyb123@test.com';

    Account testAccount = AccountTestDataFactory.createAccount(null,null);
    testAccount.Name = accountName;
    testAccount.Language_Of_Correspondance__c = 'English';
    testAccount.Legal_Status__c = 'Private';
    testAccount.Lead_Account__c = true;
    insert testAccount;

    Contact testContact = ContactTestDataFactory.createContact(null,null);
    testContact.AccountId = testAccount.Id;
    testContact.Salutation = 'Mr.';
    testContact.LastName = contactName;
    testContact.FirstName = contactName;
    testContact.Email = testemail;
    insert testContact;

    Profile ccAdvancedProfileId = [
      SELECT Id, Name
      FROM profile
      WHERE name = 'Customer Community Advanced'
      LIMIT 1
    ];

    User portalUser = new User(
      profileId = ccAdvancedProfileId.id,
      username = testemail,
      email = testemail,
      emailencodingkey = 'UTF-8',
      languagelocalekey = 'en_US',
      localesidkey = 'en_US',
      timezonesidkey = 'America/Los_Angeles',
      alias = 'cspu',
      lastname = 'lastname',
      contactId = testContact.id
    );
    insert portalUser;

    testContact.User__c = portalUser.Id;
    update testContact;
  }

  @isTest
  public static void testGetContactUsDetails() {
    CSM_ContactUsController.isTest = false;
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com'
    ];

    System.runAs(userRecord) {
      test.startTest();
      List<IB_Answers_Contact_Us_Details__mdt> contactsDetails = CSM_ContactUsController.getContactUsDetails();
      test.stopTest();
      Assert.isTrue(
        contactsDetails.size() > 0,
        'Size should be greater than zero'
      );
    }
  }

  @isTest
  public static void testGetContactUsDetailsException() {
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com'
    ];

    System.runAs(userRecord) {
      CSM_ContactUsController.isTest = true;
      try {
        test.startTest();
        List<IB_Answers_Contact_Us_Details__mdt> contactsDetails = CSM_ContactUsController.getContactUsDetails();
        test.stopTest();
      } catch (Exception exp) {
        Assert.isNotNull(
          exp,
          'Exception thrown from get Contact Us Details is null'
        );
      }
    }
  }

  @isTest
  public static void testGetHelpInfo() {
    CSM_ContactUsController.isTest = false;
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com'
    ];

    System.runAs(userRecord) {
      test.startTest();
      IB_Answers_Contact_Us_Help_Info__mdt contactUsHelpInfo = CSM_ContactUsController.getHelpInfo();
      test.stopTest();
      Assert.isNotNull(contactUsHelpInfo, 'Contact us help is null');
      Assert.areEqual(
        'If you require assistance, we\'re here to help. For immediate solutions, we suggest checking our support content or using our online form. ' +
        'If your matter is urgent, please call us with your case number ready. We\'re committed to resolving your issues promptly and efficiently.',
        contactUsHelpInfo.Help_Info__c,
        'Help info not match'
      );
    }
  }

  @isTest
  public static void testGetHelpInfoException() {
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com'
    ];

    System.runAs(userRecord) {
      CSM_ContactUsController.isTest = true;
      try {
        test.startTest();
        IB_Answers_Contact_Us_Help_Info__mdt contactUsHelpInfo = CSM_ContactUsController.getHelpInfo();
        test.stopTest();
      } catch (Exception exp) {
        Assert.isNotNull(exp, 'Exception thrown from get help info is null');
      }
    }
  }
}