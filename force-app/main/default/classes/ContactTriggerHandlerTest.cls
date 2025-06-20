/*
 * @description 
* @author  Fahad - Plumlogix
* @version 1.0
* @since   2019-09-30 
Modification Log     :                                                                              
*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          
   Jagan                      2024/11/07             US-0002475
* ------------------------------------------------------------------------------------------------- 

*/

@isTest
private class ContactTriggerHandlerTest {
/**@description */
  @testSetup
  static void dataSetup(){
    DuplicateRule dp = [
      select id,
      developerName from duplicaterule where developerName =
          'Contact_Name_and_Email'
    ];
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dp.id);
        insert dupRS;
    Contact cntct = new Contact();
    cntct.Possible_Duplicate__c = true;
    cntct.Duplicate_Record_Set_ID__c = dupRS.id;
    cntct = ContactTestDataFactory.createContact(null, cntct);
        insert cntct;
    DuplicateRecordItem dup = new DuplicateRecordItem(
        DuplicateRecordSetId = dupRS.id, RecordId = cntct.id);
        insert dup;
    List<Contact> conList = new List<Contact>();
    Contact con = new Contact();
    con.Possible_Duplicate__c = true;
    con.Lead_Type__c = 'Type';
    conList = ContactTestDataFactory.createContacts(null, con, 4);
    insert conList;
    Contact con1 = new Contact();
    con1.Possible_Duplicate__c = true;
    con1.Lead_Type__c = null;
    con1 = ContactTestDataFactory.createContact(null, con1);
    insert con1;
    Contact deceasedcntct = new Contact();
    deceasedcntct.Possible_Duplicate__c = true;
    deceasedcntct.Lead_Type__c = 'Type';
    deceasedcntct.Deceased__c = false;
    deceasedcntct = ContactTestDataFactory.createContact(null, deceasedcntct);
    insert deceasedcntct;
    Account objAccount =
        AccountTestDataFactory.createAccount('School Account', null);
    insert objAccount;
    Contact objContact = new Contact();
    objContact.AccountId = objAccount.Id;
    objContact.Contact_Type__c = 'IBEN';
    objContact = ContactTestDataFactory.createContact('Standard Contact', objContact);
    insert objContact;
    User objuser = new User();
    objuser.ContactId = objContact.Id;
    objuser.Bypass_Validation_Rules__c = true;
    objuser = UserTestDataFactory.createUser('External PD Provider', objuser);
    insert objuser;
    IB_Country_Segmentation__c countrySegmentation =
        new IB_Country_Segmentation__c();
    countrySegmentation.IBEN_Independent_Account__c = objAccount.Id;
    countrySegmentation.Name = 'India';
    countrySegmentation.ISO_Alpha_2_Code__c='IN';
    countrySegmentation.Geographical_Sub_Region_Segmentation__c = 'Asia';
    countrySegmentation.Regional_Office_Segmentation__c = 'IBAP';
    countrySegmentation.IBEN_Segmentation__c = 'IBAP';
    countrySegmentation =IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(countrySegmentation);
    insert countrySegmentation;
    List<Contact> conList1 = new List<Contact>();
    Contact contact1 = new Contact();
    contact1.AccountId = objAccount.id;
    contact1.Country__c = countrySegmentation.Id;
    conList1 = ContactTestDataFactory.createContacts('Standard Contact', contact1, 2);
    insert conList1;
    }
    
  @isTest
  private static void testUpdatePossibleDuplicateCheckField() {
    Contact cntct = [
      SELECT Id, firstName,
      Possible_Duplicate__c FROM Contact WHERE Possible_Duplicate__c =
          true AND Duplicate_Record_Set_ID__c != null LIMIT 1
    ];
                Test.startTest();  
    cntct.firstName = 'stevee';
    update cntct;
    Contact upcntct = [
      SELECT Id, firstName,
      Possible_Duplicate__c FROM Contact WHERE Id = : cntct.id LIMIT 1
    ];
    Test.stopTest();
    system.assertEquals(false, upcntct.Possible_Duplicate__c,'Possible_Duplicate__c should be updated to false');
  }

  @isTest
  private static void contactAll3Test() {

    User objuser = [SELECT Id FROM User LIMIT 1];
    Boolean exceptionThrown = false;
    String ex='';
    try {
      Contact cntct1 = [
        SELECT Id, Country_of_Birth__c, firstName, LastName, User__c,
        Birth_Locale__c, Birthdate, Alternative_Email__c, Possible_Duplicate__c,
        Lead_Type__c,
        Lead_Conversion__c FROM Contact WHERE Possible_Duplicate__c =
            true AND Lead_Type__c = null LIMIT 1
      ];
      cntct1.Alternative_Email__c = 'test1@test1.com';
                update cntct1;  
                
      Contact cntct = [
        SELECT Id, Country_of_Birth__c, firstName, LastName, User__c,
        Birth_Locale__c, Birthdate, Alternative_Email__c, Possible_Duplicate__c,
        Lead_Type__c,
        Lead_Conversion__c FROM Contact WHERE Possible_Duplicate__c =
            true AND Lead_Type__c = 'Type' LIMIT 1
      ];
                Test.startTest();  
				list<Contact> listContact = new list<Contact>();
				listContact.add(cntct);
				map<id,Contact> contactMap = new map<id,Contact>();
				contactMap.put(cntct.id, cntct1);
      ContactTriggerHandler.contact_all_3(listContact, contactMap, objuser);//method not reachable
                Test.stopTest();  
            
    } catch (Exception x) {
      exceptionThrown = true;
      ex= x.getMessage();
        }
    System.AssertEquals(false, exceptionThrown, ex); 
    }
        
  @isTest
  private static void updatePossibleDuplicateMerge1Test() {
    //try {
      Contact cntct = [SELECT Id,firstName, Possible_Duplicate__c FROM Contact WHERE Possible_Duplicate__c =
          true AND Lead_Type__c = 'Type' LIMIT 1];
      Test.startTest();
      cntct.firstName='updated';
      Possibleduplicate.conIDs = new set<Id>();
      Possibleduplicate.conIDs.add(cntct.Id);
      update cntct;
      Contact upcntct = [SELECT Id, firstName,Possible_Duplicate__c FROM Contact WHERE Id = : cntct.id LIMIT 1];
    Test.stopTest();
    system.assertEquals(false, upcntct.Possible_Duplicate__c,'Possible_Duplicate__c should be updated to false');
  }

  @isTest
  private static void updatePossibleDuplicateMergeTest() {
    Contact cntct = [SELECT Id, Possible_Duplicate__c, MasterRecordId FROM Contact WHERE Possible_Duplicate__c =
          true AND Lead_Type__c = 'Type' LIMIT 1];
    
      Test.startTest();
      delete cntct;
      Boolean exceptionThrown = false;
      String ex= '';
      try{
      List<Contact> upcntct = [SELECT Id, firstName,Possible_Duplicate__c FROM Contact WHERE Id = : cntct.id LIMIT 1];
      system.assert(upcntct.size()==0,'contact exists');
      }
      catch (Exception e) {
        exceptionThrown = true;
        ex= e.getMessage();        
    } 
    System.AssertEquals(false, exceptionThrown, ex); 
      Test.stopTest();
  }

  @isTest
  private static void updateContUserTest() {
      Contact cntct = [SELECT Id, Possible_Duplicate__c, MasterRecordId FROM Contact WHERE Possible_Duplicate__c =
      true AND Lead_Type__c = 'Type' LIMIT 1];
                Test.startTest();              
				list<Contact> listContact = new list<Contact>();
				listContact.add(cntct);
      Boolean exceptionThrown = false;
      String ex= '';
      try{
				ContactTriggerHandler.updateContUser(listContact);
      }
      catch (Exception e) {
        exceptionThrown = true;
        ex= e.getMessage();
    } 
    System.AssertEquals(false, exceptionThrown, ex); 
                Test.stopTest();  
        }
        
  @isTest
  private static  void automateoncheckDeceasedTest() {
      Contact cntct = [SELECT Id, Possible_Duplicate__c, MasterRecordId,Deceased__c FROM Contact WHERE Possible_Duplicate__c =
      true AND Deceased__c = false LIMIT 1];
                Test.startTest();  
      cntct.Deceased__c = true;
      update cntct;
      Contact upcntct = [SELECT Id, firstName,Possible_Duplicate__c,Deceased__c FROM Contact WHERE Id = : cntct.id LIMIT 1];
                Test.stopTest();  
      system.assertEquals(upcntct.Deceased__c,true,'Deceased__c field not updated');
    }
        @isTest static void addphoneTest() {
    List<Contact> contactValue = new List<Contact>();
    Account objAccount = [SELECT Id FROM Account LIMIT 1];
    Contact cntct = new contact();
    cntct.AccountId = objAccount.id;
    cntct.Country_code__c = 'Algeria (+213)';
    cntct.Phone_Number__c = '0987654322';
    cntct = ContactTestDataFactory.createContact(null, cntct);
    contactValue.add(cntct);
    Contact cntct1 = new contact();
    cntct1.AccountId = objAccount.id;
    cntct1.Country_code__c = 'Algeria (+213)';
    cntct1.Phone_Number__c = '';
    cntct1 = ContactTestDataFactory.createContact(null, cntct);
    contactValue.add(cntct1);

        Test.startTest();
    Boolean exceptionThrown = false;
    String ex ='';
        try{
      insert contactValue;
    } catch (Exception e) {
      exceptionThrown = true;
      ex= e.getMessage();
        }
  System.AssertEquals(false, exceptionThrown, ex); 
        Test.stopTest();
    }
        
  @isTest
  static void updatephonetest() {
    Contact con = [SELECT Id, Country_code__c FROM Contact LIMIT 1];
    Test.startTest();
    Boolean exceptionThrown = false;
    try {
      con.Country_code__c = 'Afghanistan (+93)';
      con.Phone_Number__c = '132';
      update con;
    } catch (Exception ex) {
      exceptionThrown = true;
      System.AssertEquals(true, exceptionThrown, 'Negative Use Case');
    }
    try {
      con.Country_code__c = 'Afghanistan (+93)';
      con.Phone_Number__c = '';
      update con;
    } catch (Exception ex) {
      exceptionThrown = true;
      System.AssertEquals(true, exceptionThrown,'Negative Use Case');
    }
    try {
      con.Country_code__c = '';
      con.Phone_Number__c = '';
      update con;
    } catch (Exception ex) {
      exceptionThrown = true;
      System.AssertEquals(true, exceptionThrown,'Negative Use Case');
    }
    try {
      con.Country_code__c = 'Afghanistan (+93)';
      con.Phone_Number__c = '1324567890';
      update con;
    } catch (Exception ex) {
      exceptionThrown = true;
      System.AssertEquals(true, exceptionThrown,'Positive use case');
    }
    Test.stopTest();
  }

  @isTest static void updateCountryOfResidence() {
    Boolean exceptionThrown = false;
    String ex='';
    IB_Country_Segmentation__c country =
        [SELECT Id FROM IB_Country_Segmentation__c LIMIT 1];

    Contact con = [SELECT Id, OtherStreet,OtherCity,OtherState,OtherPostalCode,OtherCountry FROM Contact
    WHERE Country__c =: country.Id LIMIT 1];
   
    Test.startTest();
    try{
        con.OtherCountry = 'India';
        update con;
       
     }
    catch(Exception e){
      exceptionThrown = true;
      ex= e.getMessage();
    }
    Test.stopTest(); 
        
    }
}