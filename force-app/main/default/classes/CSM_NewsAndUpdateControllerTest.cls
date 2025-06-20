/**
 * @description       : Test class for CSM_NewsAndUpdateController
 * @author            : Yatin Bajaj
 * @modified by       : Yatin Bajaj  | 03-25-2024
 * @modified by       : Charan Kumar | 05-10-2024
 **/
@isTest
private with sharing class CSM_NewsAndUpdateControllerTest {
  @TestSetup
  static void setupTestData() {
    String accountName = 'test account name';
    String contactName = 'test contact name';
    String testemail = 'testyb123@test.com';

    Account testAccount = new Account(
      Name = accountName,
      Language_Of_Correspondance__c = 'English',
      Legal_Status__c = 'Private',
      Lead_Account__c = true,
      Website = 'https://help.ibo.org'
    );
    insert testAccount;

    Contact testContact = new Contact(
      Salutation = 'Mr.',
      LastName = contactName,
      FirstName = contactName,
      Email = testemail,
      AccountId = testAccount.Id
    );
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

    // Service Alerts
    List<Service_Alert__c> serviceAlertList = new List<Service_Alert__c>();
    for (Integer i = 1; i <= 2; i++) {
      Service_Alert__c serviceAlert = new Service_Alert__c();
      serviceAlert.Title__c = 'Alert check' + i;
      serviceAlert.Alert_Level__c = 'High Priority';
      serviceAlert.Alert_Type__c = 'Icon_Warning';
      serviceAlert.Body__c = 'Alert check body' + i;
      serviceAlert.Start_Date__c = DateTime.now().addDays(-i);
      serviceAlert.End_Date__c = DateTime.now().addDays(i);
      serviceAlert.Audience__c = 'External - Authenticated';
      serviceAlert.Language__c = 'English';
      serviceAlertList.add(serviceAlert);
    }
    for (Integer i = 3; i <= 4; i++) {
      Service_Alert__c serviceAlert = new Service_Alert__c();
      serviceAlert.Title__c = 'Alert check' + i;
      serviceAlert.Alert_Level__c = 'Normal';
      serviceAlert.Alert_Type__c = 'Icon_Information';
      serviceAlert.Body__c = 'Alert check body' + i;
      serviceAlert.Start_Date__c = DateTime.now();
      serviceAlert.End_Date__c = DateTime.now().addDays(i);
      serviceAlert.Audience__c = 'External - Unauthenticated';
      serviceAlert.Language__c = 'English';
      serviceAlertList.add(serviceAlert);
    }

    if (!serviceAlertList.isEmpty()) {
      insert serviceAlertList;
    }
  }

  @isTest
  public static void testGetServiceAlertsForAU() {
    CSM_NewsAndUpdateController.isTest = false;
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com' limit 1
    ];

    System.runAs(userRecord) {
      Test.startTest();
      List<Service_Alert__c> serviceAlerts = CSM_NewsAndUpdateController.getServiceAlerts(
        false,
        'English'
      );
      Test.stopTest();

      Assert.areEqual(2, serviceAlerts.size(), 'Alerts size Not Equal');
    }
  }

  @isTest
  public static void testGetServiceAlertsForNAU() {
    CSM_NewsAndUpdateController.isTest = false;

    Test.startTest();
    List<Service_Alert__c> serviceAlerts = CSM_NewsAndUpdateController.getServiceAlerts(
      true,
      'English'
    );
    Assert.areEqual(2, serviceAlerts.size(), 'Not Equal for NAU');
    Test.stopTest();
  }

  @isTest
  static void testGetServiceAlertsException() {
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com' limit 1
    ];

    System.runAs(userRecord) {
      CSM_NewsAndUpdateController.isTest = true;
      try {
        List<Service_Alert__c> serviceAlerts = CSM_NewsAndUpdateController.getServiceAlerts(
          false,
          'English'
        );
      } catch (Exception exp) {
        Assert.isNotNull(exp, 'Exception is null');
      }
    }
  }
}