/**
 * @description       : class for CSM_NotificationControllerTest
 * @author            : Yatin Bajaj
 * @modified by       : Yatin Bajaj  | 03-25-2024
 * @modified by       : Charan Kumar | 05-10-2024
**/
@isTest
private with sharing class CSM_NotificationControllerTest {
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
    Service_Alert__c serviceAlert = new Service_Alert__c();
    serviceAlert.Title__c = 'Alert check' + 3;
    serviceAlert.Alert_Level__c = 'High Priority';
    serviceAlert.Alert_Type__c = 'Icon_Warning';
    serviceAlert.Body__c = 'Alert check body' + 3;
    serviceAlert.Start_Date__c = DateTime.now();
    serviceAlert.End_Date__c = DateTime.now().addDays(3);
    serviceAlert.Audience__c = 'External - Unauthenticated';
    serviceAlert.Language__c = 'English';
    serviceAlertList.add(serviceAlert);

    if (!serviceAlertList.isEmpty()) {
      insert serviceAlertList;
    }
  }

  @isTest
  static void testHighPriorityAlertForNAU() {
    CSM_NotificationController.isException = false;
    Test.startTest();
    // Action
    Service_Alert__c serviceAlert = CSM_NotificationController.getHighPriorityServiceAlert(
      true,
      'English'
    );
    Test.stopTest();

    // Assert
    Assert.areEqual(
      'Alert check3',
      serviceAlert.Title__c,
      'Title does not match'
    );
    Assert.areEqual(
      'Alert check body3',
      serviceAlert.Body__c,
      'Alert body does not match'
    );
    Assert.areEqual(
      'High Priority',
      serviceAlert.Alert_Level__c,
      'Alert level does not match'
    );
    Assert.areEqual(
      'Icon_Warning',
      serviceAlert.Alert_Type__c,
      'Alert type does not match'
    );
    Assert.areEqual(
      Date.today(),
      serviceAlert.Start_Date__c.date(),
      'start date does not match'
    );
    Assert.areEqual(
      Date.today().addDays(3),
      serviceAlert.End_Date__c.date(),
      'end date does not match'
    );
  }

  @isTest
  static void testHighPriorityAlertForAU() {
    CSM_NotificationController.isException = false;

    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com'  LIMIT 1
    ];

    System.runAs(userRecord) {
      // Action
      Test.startTest();
      Service_Alert__c serviceAlert = CSM_NotificationController.getHighPriorityServiceAlert(
        false,
        'English'
      );
      Test.stopTest();

      // Assert
      Assert.areEqual(
        'Alert check1',
        serviceAlert.Title__c,
        'Title does not match'
      );

      Assert.areEqual(
        'High Priority',
        serviceAlert.Alert_Level__c,
        'Alert level does not match'
      );
    }
  }

  @isTest
  static void testhighPriorityAlertException() {
    User userRecord = [
      SELECT id, name
      FROM user
      WHERE email = 'testyb123@test.com' limit 1
    ];

    System.runAs(userRecord) {
      CSM_NotificationController.isException = true;
      try {
        Service_Alert__c serviceAlert = CSM_NotificationController.getHighPriorityServiceAlert(
          false,
          'English'
        );
      } catch (ListException exp) {
        Assert.isNotNull(exp, 'Exception is null');
      }
    }
  }
}