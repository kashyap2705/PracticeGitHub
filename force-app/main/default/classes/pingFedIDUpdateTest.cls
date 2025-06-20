@istest(SeeAllData=false)
public class pingFedIDUpdateTest {
	static testmethod void pingFedIDUpdateTestWithIBISContID(){
        try{
            
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Venue Account').getRecordTypeId());
            insert objAccount;
            
            Date dd = Date.newInstance(1988, 12, 9);
            Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;    
            
            User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
            User objAdminUser = new User(Alias = 'sspp', Email='testAdmin@ibotestorg.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = '00e20000001EEFO', 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testAdmin@ibotestorg.com');
			list<user> usrInsertList = new list<user>();
			usrInsertList.add(objuser);
			usrInsertList.add(objAdminUser);
			insert usrInsertList;
			test.startTest();
			System.runAs(objAdminUser){
				ObjContact.IBIS_Contact_ID__c='654321';
				update ObjContact;
                system.debug('ObjContact: ' + ObjContact);
				User usr = [select Person_Code__c,PingFed_Identifier__c,Organization_ID__c from User where id =: objuser.id];
				system.debug('usr: ' + usr);
				system.debug('usr.Person_Code__c: ' + usr.Person_Code__c);
				system.debug('usr.PingFed_Identifier__c: ' + usr.PingFed_Identifier__c);
				system.debug('usr.Organization_ID__c: ' + usr.Organization_ID__c);
				pingFedIDUpdate tb = new pingFedIDUpdate();
				Id batchId = Database.executeBatch(tb);  
				test.stopTest();
				User usr1 = [select Person_Code__c,PingFed_Identifier__c,Organization_ID__c from User where id =: objuser.id];
				system.debug('usr1: ' + usr1);
				system.debug('usr1.Person_Code__c: ' + usr1.Person_Code__c);
				system.debug('usr1.PingFed_Identifier__c: ' + usr1.PingFed_Identifier__c);
				system.debug('usr1.Organization_ID__c: ' + usr1.Organization_ID__c);
			}
        }
        catch (Exception x){
            system.debug('Exception ' + x);
        }
    }
	static testmethod void pingFedIDUpdateTestWithoutIBISContID(){
        try{
            
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Venue Account').getRecordTypeId());
            insert objAccount;
            
            Date dd = Date.newInstance(1988, 12, 9);
            Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;
            User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
            insert objuser;
			test.startTest();
			pingFedIDUpdate tb = new pingFedIDUpdate();
			Id batchId = Database.executeBatch(tb);  
            test.stopTest();
			User usr = [select Person_Code__c,PingFed_Identifier__c,Organization_ID__c from User where id =: objuser.id];
			system.debug('usr: ' + usr);
			system.debug('usr.Person_Code__c: ' + usr.Person_Code__c);
			system.debug('usr.PingFed_Identifier__c: ' + usr.PingFed_Identifier__c);
			system.debug('usr.Organization_ID__c: ' + usr.Organization_ID__c);
        }
        catch (Exception x){
            system.debug('Exception ' + x);
        }
    }
    static testmethod void pingFedIDUpdateBatchSchedulerTest1() {
        String CRON_EXP = '0 0 0 15 3 ? 2026';
		try{
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Venue Account').getRecordTypeId());
            insert objAccount;
            
            Date dd = Date.newInstance(1988, 12, 9);
            Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;
            User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                    EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                    LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
            insert objuser;
			system.debug('Count: ' + [select count() from User]);
			Test.startTest();
			//pingFedIDUpdatedBatchScheduler sch = new pingFedIDUpdatedBatchScheduler();
			String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new pingFedIDUpdatedBatchScheduler());
			//sch.execute(null);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
			Test.stopTest();
		}
        catch (Exception x){
            system.debug('Exception ' + x);
        }
    }
}