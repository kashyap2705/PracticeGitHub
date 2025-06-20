@isTest
private class IBPortalValidationUtilTesting {
    
    static testMethod void checkExistingUserRecordTest()  {
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'New school Partner User');
        insert r;
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User thisUser = new User(Id=UserInfo.getUserId());
        thisUser.UserRoleId = r.Id;
        update thisUser;
        
        Contact ObjContact;
        
        System.runAs ( thisUser ) {
            Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                             Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
            insert objAccount;
            Date dd = Date.newInstance(1999, 12, 9);
            ObjContact = new Contact(FirstName='testing', LastName='Firsttest',country_of_Birth__c = 'Pakistan', AccountId=objAccount.Id,Homephone='123',Phone='123',Email='aeret@a.com', Alternative_Email__c = 'ab@aa.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
            insert ObjContact;
        }
        
        User objuser = new User(Alias = 'sspp', Email='aeret@a.com',EmailEncodingKey='UTF-8', 
                                LastName='testUu', LanguageLocaleKey='en_US',LocaleSidKey='en_US', 
                                ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtilsppp@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        System.runAs(objuser) {
            IBPortalValidationUtil.findOrphanContact( ObjContact.FirstName, ObjContact.LastName, ObjContact.Email, ObjContact.Alternative_Email__c, ObjContact.Birthdate, ObjContact.Birth_Locale__c);
        }
        
        System.runAs(objuser) {
            IBPortalValidationUtil.findContactWithInActiveUser( ObjContact.FirstName, ObjContact.LastName, ObjContact.Email, ObjContact.Alternative_Email__c, ObjContact.Birthdate, ObjContact.Birth_Locale__c);
        }
        
        System.runAs(objuser) {
            IBPortalValidationUtil.updateTheUser(objuser.id, 'newTesting@example.com');
        }
        
        System.runAs(objuser) {
            try{
                IBPortalValidationUtil.checkContactWithActiveUser('es', 'Teria', 'Jonathon','teria@example.com', ObjContact.Alternative_Email__c, ObjContact.Birthdate, ObjContact.Birth_Locale__c);
            }catch(Exception e) {}
        }
        
        System.runAs(objuser) {
            try{
                IBPortalValidationUtil.checkContactWithActiveUser('fr', 'Teria', 'Jonathon','teria@example.com', ObjContact.Alternative_Email__c, ObjContact.Birthdate, ObjContact.Birth_Locale__c);
            }catch(Exception e) {}
        }
        
        System.runAs(objuser) {
            try{
                IBPortalValidationUtil.checkContactWithActiveUser('en_US', 'Teria', 'Jonathon','teria@example.com', ObjContact.Alternative_Email__c, ObjContact.Birthdate, ObjContact.Birth_Locale__c);
            }catch(Exception e) {}
        }
        
        System.runAs(objuser) {
            try{
                IBPortalValidationUtil.checkExistingActiveUserRecord('en_US',ObjContact.Email);
            }catch(Exception e){}
        }
        
        System.runAs(objuser) {
            try{
                IBPortalValidationUtil.checkExistingActiveUserRecord('fr',ObjContact.Email);
            }catch(Exception e){}
        }
        
        System.runAs(objuser) {   
            try{
                IBPortalValidationUtil.updatePortalContact( 'en_US',true,ObjContact.Id ,' 12344' ,ObjContact.Salutation ,ObjContact.Title ,ObjContact.FirstName , ObjContact.LastName ,ObjContact.Email ,ObjContact.Alternative_Email__c , ObjContact.Birthdate, ObjContact.Country_of_Birth__c, ObjContact.Birth_Locale__c );
            }catch(Exception e){}
        }
        
        System.runAs(objuser) {   
            try{
                IBPortalValidationUtil.updatePortalContact( 'fr', true,ObjContact.Id ,'' ,ObjContact.Salutation ,ObjContact.Title ,ObjContact.FirstName , ObjContact.LastName ,ObjContact.Email ,ObjContact.Alternative_Email__c , ObjContact.Birthdate, ObjContact.Country_of_Birth__c, ObjContact.Birth_Locale__c );
            }catch(Exception e){}
        }
        
        System.runAs(objuser) {   
            IBPortalValidationUtil.checkContactEmailForExistingUser('fr','qwerty@example.com');
        }
        
        System.runAs(objuser) {   
            IBPortalValidationUtil.checkContactEmailForExistingUser('en_US','qwerty@example.com');
        }
        
        System.runAs(objuser) {   
            try{
                IBPortalValidationUtil.checkContactForDuplicateRegistration('es','newOne', ObjContact.lastName, ObjContact.birthdate,ObjContact.Country_of_Birth__c,ObjContact.Birth_Locale__c);
            }catch(Exception e){}            
        }
        
        System.runAs(objuser) {   
            try{
                IBPortalValidationUtil.checkContactForDuplicateRegistration('fr','newOne', ObjContact.lastName, ObjContact.birthdate,ObjContact.Country_of_Birth__c,ObjContact.Birth_Locale__c);
            }catch(Exception e){}            
        }
        
        System.runAs(objuser) {   
            try{
                IBPortalValidationUtil.checkContactForDuplicateRegistration('en_US','newOne', ObjContact.lastName, ObjContact.birthdate,ObjContact.Country_of_Birth__c,ObjContact.Birth_Locale__c);
            }catch(Exception e){} 
        }
        
        System.runAs(objuser) {
            IBPortalValidationUtil.markContactDuplicateBasedOnBirth( ObjContact.lastName, ObjContact.birthdate,ObjContact.Country_of_Birth__c,ObjContact.Birth_Locale__c);
        }
    }  
}