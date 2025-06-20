@isTest
private class TBN_NewWorkshopOverideTest {
    
    @isTest
    static void TBN_NewWorkshopOverideTestController()  {
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',Billing_Currency__c = 'SGD',
                                         Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date bd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='test', LastName='test', AccountId=objAccount.Id,Homephone='123',Phone='123',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(),birthdate = bd);
        insert ObjContact;
        
        User objuser = new User(Alias = 'standt', Email='test@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='test', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test125@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        Object_Field_IDs__c objFI1 = new Object_Field_IDs__c(Name='Currency_PD_Provider_Workshop',Field_ID__c='CurrencyIsoCode',Object_API_Name__c='PD_Provider_Workshop__c');
        Object_Field_IDs__c objFI2 = new Object_Field_IDs__c(Name='PD_Provider_Event__c',Field_ID__c='00N20000003mYQB',Object_API_Name__c='PD_Provider_Workshop__c');
        
        insert new list<Object_Field_IDs__c>{objFI1,objFI2};
            
            System.runAs(objuser) {
                
                PD_Provider_Event__c objPE = new PD_Provider_Event__c(RecordTypeId = Schema.SObjectType.PD_Provider_Event__c.getRecordTypeInfosByName().get('PD Provider Event - New').getRecordTypeId(),Name = 'Test',PD_Provider_Event_Start_Date__c = Date.Today(),
                                                                      PD_Provider_Event_End_Date__c = Date.Today(),CurrencyIsoCode = 'USD',Event_City__c = 'UNITED STATES',Event_Country__c = 'UNITED STATES',Event_Region__c='IBAEM',Event_Sub_Region__c = 'NORTHERN AMERICA');
                insert objPE;
                Test.setCurrentPage(new PageReference ('/apex/TBN_NewWorkshopOveridePage?CF'+objFI2.Field_ID__c+'_lkid='+objPE.id));
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Workshop__c());
                TBN_NewPDWorkshopOveride objTBNNewPDWorkshopOveride = new TBN_NewPDWorkshopOveride(sc);
                objTBNNewPDWorkshopOveride.fetchRedirectUrl();   
            }
    }
}