/**
* <h1> UpdateContactLanguageTriggerTest </h1>
* Description this test class is made to test UpdateContactLanguageTrigger and UserTriggerHandler as part of us 11103 

* @author  Abd UR Rehman - Plumlogix
* @version 1.0
**/

@isTest
public class UpdateContactLanguageTriggerTest {
    
    @isTest
    static void testTrigger()
    {
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
            list<user> userlist = new list<user>();
            userlist.add(objuser);
            Map<Id , User> OldMap = new map<Id , User>(userlist);
            UserTriggerHandler.Disable_Id(userlist);
            UserTriggerHandler.UpdateContactLanguage1(userlist, oldmap );
            objuser.LanguageLocaleKey ='en_USS' ;     
            update objuser;  
            test.stopTest();    
        }
        catch (Exception x)
        {
            system.debug('Exception ' + x);
        }
    }
}