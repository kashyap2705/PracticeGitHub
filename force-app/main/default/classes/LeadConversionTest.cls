/**
* <h1>LeadConversion Test Class</h1>
* This Test class is responsible to test LeadConversion,US-11329
* 
* @author  Ammara
* @version 1.0
**/

@isTest
public class LeadConversionTest { 
   
    @TestSetup
    static void setupdata() {
        
        Account objAccount = AccountFactoryTest.createAccountRecord(false);
        objAccount.Phone = '9234571236';
        objAccount.IBIS_ID__c = '123456';
        objAccount.Website = 'www.test.com';
        objAccount.Legal_Status__c = 'Private';
        objAccount.Language_Of_Correspondance__c = 'English';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId();
        insert objAccount;   
        
        Date dd = Date.newInstance(1999, 12, 9);
        List<Contact> ObjContact = ContactFactoryTest.createContacts(1,false,objAccount); 
        ObjContact[0].RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        ObjContact[0].birthdate = dd;
        ObjContact[0].Lead_Type__c = 'Web';
        insert ObjContact;
        
        List<Lead> ibLead = LeadFactoryTest.createLeads(1,false,objAccount);
        ibLead[0].Existing_Contact_Related__c = ObjContact[0].Id;
        ibLead[0].PYP_Interest__c = true;
        insert ibLead;
    }
    
    @isTest
    static void test_leadconversion() {
        
        Lead lead_record = [select id,Existing_Contact_Related__c,Existing_Account_Related__c from Lead Limit 1];
        System.assert(lead_record != Null);
        Test.startTest();
        LeadConversion.LeadConversiontoExistingContact(lead_record.id);
        Test.stopTest();
        Lead lead_record_Converted = [select id,IsConverted,ConvertedContactId,ConvertedAccountId from Lead where id =: lead_record.id Limit 1];
        System.assert(lead_record_Converted.IsConverted == true);
        System.assert(lead_record_Converted.ConvertedContactId == lead_record.Existing_Contact_Related__c);
        System.assert(lead_record_Converted.ConvertedAccountId == lead_record.Existing_Account_Related__c);
    }
}