/**
* <h1> ContactInformationTriggerTest </h1>
* This class is created to test the functionality of ContactInformationTrigger class
* 
* @author  Ammara - Plumlogix
* @version 1.0
* @since   2020-05-20 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
@isTest
private class ContactInformationTriggerTest {
   @isTest
     static void addphone(){
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Institute Administrator';
        insert repo;
        
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
        
        Account acc = PimsTestUtil.createAccount('test', 'School Account' );
        acc.ibis_id__c='012111';
        insert acc;
         List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
            countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc));
            countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc));
            insert countries;
                Contact con= TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
            con.AccountId = acc.Id;
            con.Contact_Type__c = 'IBEN';
            con.HomePhone = '13861234567';
            con.MobilePhone = '13861234567';
            con.OtherPhone = '13861234567';
            con.Phone = '13861234567';
			con.Country_Code__c = 'Israel (+972)';
            con.Phone_Number__c = '123123123';
            con.Qualifications__c = 'PhD';            
            insert con;

        
        Contact_information__c contact_info=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),name='Ck',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        contact_info.Country_Code__c = 'Algeria (+213)';
        contact_info.Phone_Number__c = '123456789';
        contact_info.IB_Contact__c = con.id;
        contact_info.Name = '+213';
         Test.startTest();
        TriggerContextUtility.firstRun = true;
        insert (contact_info);
        TriggerContextUtility.firstRun = true;
        contact_info.Country_Code__c = 'Algeria (+213)';
        contact_info.Phone_Number__c = '1234567847';
        update contact_info;
         
        
        Contact_information__c contact_info_test = new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
        contact_info_test.IB_Contact__c = con.id;
        TriggerContextUtility.firstRun = true;
        insert contact_info_test;
         Test.stopTest();
    }
       @isTest
     static void updatephone(){
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Institute Administrator';
        insert repo;
        
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
        
        Account acc = PimsTestUtil.createAccount('test', 'School Account' );
        acc.ibis_id__c='012111';
        insert acc;
         List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
            countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc));
            countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc));
            insert countries;
                Contact con= TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
            con.AccountId = acc.Id;
            con.Contact_Type__c = 'IBEN';
            con.HomePhone = '13861234567';
            con.MobilePhone = '13861234567';
            con.OtherPhone = '13861234567';
            con.Phone = '13861234567';
			con.Country_Code__c = 'Israel (+972)';
            con.Phone_Number__c = '123123123';
            con.Qualifications__c = 'PhD';            
            insert con;

        
        Contact_information__c contact_info=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),name='Ck',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        contact_info.Country_Code__c = 'Algeria (+213)';
        contact_info.Phone_Number__c = '123456789';
        contact_info.IB_Contact__c = con.id;
        contact_info.Name = '+213';
        Test.startTest();
         
        TriggerContextUtility.firstRun = true;
        insert (contact_info);
         
        TriggerContextUtility.firstRun = true;
        contact_info.Country_Code__c = 'Algeria (+213)';
        contact_info.Phone_Number__c = '1234567849';
        update contact_info;
         Test.stopTest();
    }
}