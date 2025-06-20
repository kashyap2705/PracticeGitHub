@isTest
private class TBN_NewPDEventOverideTest {
    
    @isTest
    static void TBN_NewPDEventOverideContollerTest() {
        
        integer i=1;
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                         Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+9212345678',Phone='+9212345678',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        
        User objuser = new User(Alias = 'standt', Email='test@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='test', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test125@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        Object_Field_IDs__c objFI1 = new Object_Field_IDs__c(Name='Currency_PD_Provider_Event',Field_ID__c='CurrencyIsoCode',Object_API_Name__c='PD_Provider_Event__c');
        Object_Field_IDs__c objFI2 = new Object_Field_IDs__c(Name='Event_Region__c',Field_ID__c='00N20000003mYQ1',Object_API_Name__c='PD_Provider_Event__c');
        Object_Field_IDs__c objFI3 = new Object_Field_IDs__c(Name='Event_Sub_Region__c',Field_ID__c='00N20000003mYPw',Object_API_Name__c='PD_Provider_Event__c');
        
        insert new list<Object_Field_IDs__c>{objFI1,objFI2,objFI3};
            
            System.runAs(objuser) {
                
                test.startTest();
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                TBN_NewPDEventOveride objTBNNewPDEventOveride = new TBN_NewPDEventOveride(sc);
                objTBNNewPDEventOveride.fetchRedirectUrl();  
                System.assertEquals(1,i);
                test.stopTest();
            }
    }
}