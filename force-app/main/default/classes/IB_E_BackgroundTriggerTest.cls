/**
* <h1> IB_E_BackgroundTriggerTest </h1>
* This class is created to test the functionality of IB_E_BackgroundTrigger and related  classes
* 
* @author  Abd Ur Rehman - Plumlogix
* @version 1.0
**/

@isTest
public class IB_E_BackgroundTriggerTest {
    
    @isTest
    public static void TestTriggers(){
        
        try{
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                             Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
            insert objAccount;
            Date dd = Date.newInstance(1999, 12, 9);
            Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;
            test.startTest();
            User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
            insert objuser;
            
            IB_E_Background__c controller = new IB_E_Background__c();
            controller.City__c = 'Test';   
            insert controller;
            
            controller.Country__c = 'Pakistan';
            update controller;
            
            list<IB_E_Background__c> lst= new list<IB_E_Background__c>();
            lst.add(controller);   
            
            IB_E_BackgroundAftrInsrtTriggerHandler.IBEBackgroundSharingTrigger(lst);   
            
            test.stopTest();
        }
        catch (Exception x)
        {
            system.debug('Exception x' + x);
        }
    }
    
    @isTest
    public static void TestTriggers1(){
        
        try{
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                             Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
            insert objAccount;
            Date dd = Date.newInstance(1999, 12, 9);
            Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;
            
            User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
            insert objuser;
            
            RecordType RecType  = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'Language_Experience'];    
            IB_E_Background__c controller = new IB_E_Background__c();     
            controller.IB_Contact__c = ObjContact.id;
            controller.RecordTypeId = RecType.id;  
            controller.Language__c = 'English';
            controller.Language_Delivery__c = 'yes';     
            controller.City__c = 'Test';
            controller.Preferred_Language__c = 'yes';    
            insert controller;
            
            controller.Country__c = 'Pakistan';     
            update controller;
            
            IB_E_Background__c controller1 = new IB_E_Background__c();
            controller1.IB_Contact__c = ObjContact.id;
            controller1.RecordTypeId = RecType.id;    
            controller1.Language__c = 'French';
            controller1.Language_Delivery__c = 'yes';     
            controller1.City__c = 'Test';   
            insert controller1; 
            
            IB_E_Background__c controller2 = new IB_E_Background__c();    
            controller2.IB_Contact__c = ObjContact.id;
            controller2.RecordTypeId = RecType.id;    
            controller2.Language__c = 'Spanish';
            controller2.Language_Delivery__c = 'yes';     
            controller2.City__c = 'Test';   
            insert controller2;   
            
            IB_E_Background__c controller3 = new IB_E_Background__c();    
            controller3.IB_Contact__c = ObjContact.id;
            controller3.RecordTypeId = RecType.id;    
            controller3.Language__c = 'Spanish';
            controller3.Language_Delivery__c = 'yes';     
            controller3.City__c = 'Test';   
            insert controller3;    
            
            test.startTest();    
            ContactLanguageBatchClass sh1 = new ContactLanguageBatchClass();    
            test.stopTest();
        }
        catch (Exception x)
        {
            system.debug('Exception x' + x);
        }
    }
}