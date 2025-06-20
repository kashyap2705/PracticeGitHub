@isTest
private class IBENConflictOfInterestControllerTest {
    
    static testMethod void conflictsOfInterestCheck() {
        integer i = 1;
        User objuser = new user();
        Account ibSchool = new Account ();
        Contact ibContact = new Contact ();
        Date d1 = Date.newInstance(1992, 10, 12);   
        Date d2 = Date.newInstance(1992, 09, 06);
        Date d3 = Date.newInstance(1992, 07, 08);
        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' AND  IsActive = true Limit 1];

        System.runAs(adminUser){
            UserRole adminRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'System_Administrator' LIMIT 1];
            adminUser.UserRoleID = adminRole.id;
            update adminUser;
            system.debug('Kevin - adminRole: ' + adminRole);
        Id schoolRecordTypeId = Schema.Sobjecttype.account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
       
            ibSchool = new Account(Name = 'Test Account', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', CurrencyIsoCode = 'USD', IBIS_ID__c = '678901', RecordTypeId = schoolRecordTypeId, Language_Of_Correspondance__c='English', Legal_Status__c='State');
            insert ibSchool;
    
            
    
            ibContact = new Contact(FirstName = 'testing', LastName = 'Firsttest', AccountId = ibSchool.Id, Homephone = '+9212345678', Phone = '+9212345678', Email = 'a@a.com', Contact_Type__c = 'IBEN', RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = d1);
            insert ibContact;
            
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
			insert r;
            List<UserRole> userRoles = [SELECT Id FROM UserRole];
            system.debug('Kevin - UserRolesList: ' + userRoles);
            
            UserRole userRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'NewMyIBRegistrantPartnerUser' LIMIT 1];
            system.debug('Kevin - UserRole: ' + userRole);
            objuser = new User(Alias = 'standt', Email = 'test@gmail.com',
                EmailEncodingKey = 'UTF-8', LastName = 'test', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = [Select Id from Profile where Name = 'SCU + Advanced'].id,
                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test125@ibotestorg.com', ContactId = ibContact.Id);
            insert objuser;
        }
        
        
        Conflict_of_Interest__c conflict1 = new Conflict_of_Interest__c(Description__c='Conflict 1 Description',End_Date__c=Date.today(),IB_Account__c=ibSchool.Id,IB_Contact__c=ibContact.Id,Start_Date__c=d1,Type_of_Conflict__c='Connection to a school');
        Conflict_of_Interest__c conflict2 = new Conflict_of_Interest__c(Description__c='Conflict 2 Description',End_Date__c=Date.today(),IB_Account__c=ibSchool.Id,IB_Contact__c=ibContact.Id,Start_Date__c=d2,Type_of_Conflict__c='Leading an event/workshop');
        Conflict_of_Interest__c conflict3 = new Conflict_of_Interest__c(Description__c='Conflict 3 Description',End_Date__c=Date.today(),IB_Account__c=ibSchool.Id,IB_Contact__c=ibContact.Id,Start_Date__c=d3,Type_of_Conflict__c='Other');
       
        List<Object> newList= new list < Conflict_of_Interest__c > {conflict1,conflict2,conflict3};
        
        System.runAs(objuser) {

            test.startTest();
            String currentUser = IBENConflictOfInterestController.getUserLocale();
            list < Conflict_of_Interest__c > allConflicts = IBENConflictOfInterestController.getConflictOfInterests();
            list < Conflict_of_Interest__c > schoolConflicts = IBENConflictOfInterestController.getConnectionConflicts();
            list < Conflict_of_Interest__c > nonsSchoolConflicts = IBENConflictOfInterestController.getNonConnectionConflicts();
            String msg = IBENConflictOfInterestController.updateConnectionConflicts(newList);

            test.stopTest();
        }
    }

}