@isTest
private class Contact_allTesting {
    
    @isTest
    static void updateContactsTest()  {
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing1', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+15141516123',Phone='+45454542123',Email='a1@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd, Alternative_Email__c = 'abcd@gmail.com' ,Birth_Locale__c  = 'Mumbai' , Country_of_Birth__c = 'India');
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'SCU + Advanced'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        ObjContact.User__c=objuser.id;
        update ObjContact;
        System.runAs(objuser) {
            
            Contact ObjContact2 = new Contact(FirstName='testing2', LastName='Firsttest', birthdate = dd, Birth_Locale__c = 'Mumbai', Email='a2@a.com');
            insert ObjContact2;
            TriggerContextUtility.setFirstRunTrue();
            
            system.debug('Entered');
            ObjContact.LastName='secondtest';
            ObjContact.FirstName='secondtes11';
            update ObjContact;
            TriggerContextUtility.setFirstRunTrue();
            ObjContact2.LastName='secondtest1';
            ObjContact2.FirstName='secondtest1111';
            update ObjContact2;
            
            TriggerContextUtility.setFirstRunFalseTest();
            
            List<Id> cont_ids= new list<id>{ ObjContact.Id };
                
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
            Utils.updateContacts(cont_ids);
        }
    }  
    
    @isTest
    static void updateUserProfileTest()  {
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        Set<Id> user_ids= new Set<id>{ objuser.Id };
            
            System.runAs(objuser) {
                
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                
                Set<Id> conIds = new Set<Id>();
                conIds.add(ObjContact.Id);
                
                Utils.updateUserProfile(user_ids, conIds);            
            }
    }
    
    @isTest
    static void updateUserProfileThroughContactTest()  {
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        List<Id> contact_ids= new list<id>{ ObjContact.Id };
            
            System.runAs(objuser) {
                
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                Utils.updateUserProfileThroughContact(contact_ids);
            }
    } 
    
    @isTest
    static void updateContactCreatedFromLead(){
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        ObjContact.Lead_Type__c = 'Web';
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        List<Id> contact_ids= new list<id>{ ObjContact.Id };
            
            System.runAs(objuser) {
                
                ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                Utils.updateContactCreatedFromLead(contact_ids);
            }
    } 
    
    @isTest
    static void updateRolesTest()  {
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        repo.Role_Level__c = 'Fully Qualified';
        repo.Require_Educational_Degree__c = true;
        repo.Require_Language_Experience__c = true;
        repo.MyIB_Has_Subjects__c = true;
        repo.MyIB_Has_Workshop_Titles__c = true;
        repo.Display_in_MyIB__c = true;
        
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Level__c = 'Fully Qualified';
        repo2.Require_Educational_Degree__c = true;
        repo2.Require_Language_Experience__c = true;
        repo2.MyIB_Has_Subjects__c = true;
        repo2.MyIB_Has_Workshop_Titles__c = true;
        repo2.Custom_Application__c = 'TeacherApp';
        repo2.MyIB_Use_My_School_Subjects__c = true;
        repo2.Role_Name__c = 'Teacher';
        repo2.Display_in_MyIB__c = true;
        repo2.Application_Available_in_MyIB__c = true;
        
        insert new List<IB_Role_Repository__c> {repo,repo2};
            
            IB_Event_Role__c eventRole = new IB_Event_Role__c(
                Number_of_Required_Educators__c = 1,
                IB_Role__c = repo.Id
            );
        insert eventRole;
        
        IB_Subject__c subject = new IB_Subject__c();
        subject.IB_Programme__c = 'PYP';
        subject.IB_Programme_Long__c = 'PYP';
        subject.Subject_Code__c = 'pyp';
        subject.Subject_Group__c = 'Arts (PYP)';
        subject.Subject_Group_Identifier__c = 'artsm';
        subject.Subject_Name__c = 'Dance';
        subject.Subject_Name_FR__c = 'Dance';
        subject.Subject_Name_SP__c = 'Dance';
        subject.Available_in_IBEN__c = true;
        subject.Available_in_MySchool__c = true;
        insert subject;
        
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        ObjContact.Global_IBEN_Number__c = 1234;
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        IB_Role__c UserRole= TestsUtil.createIbRole(repo.Id, objuser.contactId); 
        UserRole.Programme_Selection__c = 'PYP';
        insert UserRole;
        
        List<String> prg_sel= new list<String>{ UserRole.Programme_Selection__c};
            List<String> role_name= new list<String>{ objuser.UserRole.Name };
                List<Id> Contact_ids= new list<id>{ ObjContact.Id };
                    
                    System.runAs(objuser) {
                        
                        ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                        Utils.updateRoles(Contact_ids, prg_sel, role_name);
                    }
    }
    
    @isTest
    static void updateContactsTriggerUserTest()  {
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        List<Id> user_ids= new list<id>{ objuser.Id };
            List<Id> Contact_ids= new list<id>{ ObjContact.Id };
                
                System.runAs(objuser) {
                    
                    ApexPages.StandardController sc = new ApexPages.StandardController(new PD_Provider_Event__c());
                    Utils.updateContactsTriggerUser(user_ids,Contact_ids);
                }
    }
    
    @isTest
    static void updateContact_UserTest()  {
        
        Account objAccount = new Account(Name='utilsClass Test',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',Website = 'www.test.com',
                                         IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        system.debug('Account Object'+ objAccount.Name);
        Date dd = Date.newInstance(1995, 11, 9);
        Contact ObjContact = new Contact(FirstName='UtilsTestC', LastName='UtilsClass', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='ali@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        system.debug('Contact Object' + ObjContact.FirstName);
        
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id);
        insert objuser;
        
        Set<id> ids_cntct= new Set<id>{ ObjContact.Id};
            System.runAs(objuser) {
                
                Utils.updateContact_User(ids_cntct);   
            }
    }  
}