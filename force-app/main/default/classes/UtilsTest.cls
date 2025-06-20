@isTest
private class UtilsTest {
    
    @isTest
    static void Test1() {  
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        PortalUserInfo__c portalUserInfo = new PortalUserInfo__c();
        portalUserInfo.Name = 'IbenPublicPortal';
        portalUserInfo.ProfileId__c = '00e20000001ApEj';
        
        insert portalUserInfo;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        countries.add(country);
        country = null;
        country = TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc);
        country.IBEN_Independent_Account__c = acc.Id;
        countries.add(country);
        insert countries;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc.Id;
        cont.Phone = '13861234567';
        
        Contact cont2 = TestsUtil.createContact('test_name_002', 'xxx1@xxx.com', 'axxx2@xxx.com', Date.today().addYears(-20), countries[0]);
        cont2.AccountId = acc.Id;
        cont2.Phone = '138612345678';
        
        insert new List<contact>{cont,cont2};
            
        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
                            EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');
        
        usr.Bypass_Validation_Rules__c = true;
        
        insert usr;
        
        IB_Role_Repository__c tmpRepo = TestsUtil.createRoleRepo();
        tmpRepo.Role_Name__c = 'Programme Coordinator';
        
        IB_Role_Repository__c tmpRepo2 = TestsUtil.createRoleRepo();
        tmpRepo2.Role_Name__c = 'Billing Contact';
        
        Insert new List<IB_Role_Repository__c>{tmpRepo,tmpRepo2};
            
            IB_Address__c tmpAdd = new IB_Address__c(
                Name = 'STRUNK',
                IB_Account__c = acc.Id,
                Address_Line_1__c = 'Test',
                City__c = 'Test city',
                Postal_Code__c = '12345'
            );
        insert tmpAdd;
        
        IB_Programme__c tmpProg = new IB_Programme__c(
            Exam_Session__c = 'STRUNK',
            Primary_Language_of_Instruction__c = 'English',
            Status__c = 'Invited',
            Street_Address__c = tmpAdd.Id,
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = acc.Id
        );
        insert tmpProg;
        
        IB_Role__c tmpRole = TestsUtil.createIbRole(tmpRepo.Id, cont.Id);
        tmpRole.IB_Programme_New__c = tmpProg.Id;
        tmpRole.IB_Account__c = acc.Id;
        
        IB_Role__c tmpRole2 = TestsUtil.createIbRole(tmpRepo2.Id, cont2.Id);
        tmpRole2.IB_Programme_New__c = tmpProg.Id;
        tmpRole2.IB_Account__c = acc.Id;
        
        insert new List<IB_Role__c>{tmpRole,tmpRole2}; 
            
            List<Id> newContactIds = new List<Id>();
        newContactIds.add(cont.Id);
        
        List<Id> userIds = new List<Id>();
        userIds.add(usr.Id);
        
        Set<Id> userIds1 = new Set<Id>();
        userIds1.add(usr.Id);
        
        List<String> strProgrammeSelection = new List<String>();
        strProgrammeSelection.add('PYP');
        List<String> roleName = new List<String>();
        roleName.add(tmpRepo2.Role_Name__c);
        roleName.add(tmpRepo.Role_Name__c);
        Set<Id> cnt_ids = new Set<Id>();
        cnt_ids.add(cont.Id);
        cnt_ids.add(cont2.Id);
        System.RunAs(usr){  
            test.startTest();  
            Utils cs = new Utils();
            Utils.updateContacts(newContactIds);
            Utils.updateUserProfile(userIds1,cnt_ids);
            Utils.updateRoles(newContactIds,strProgrammeSelection,roleName);
            Utils.updateContactsTriggerUser(newContactIds,userIds);
            Utils.updateContact_User(cnt_ids);
            test.stopTest();  
        }  
    }  
    
    @isTest
    private static void updateCont_User_test()
    {
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                         Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date date1 = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = date1);
        insert ObjContact;
        User objuser = new User(Alias = 'sspp', Email='testutils@gmail.com', 
                                EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'External PD Provider'].id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=ObjContact.Id,Bypass_Validation_Rules__c=true);
        
        insert objuser;
        
        try
        {
            Test.startTest();  
            Contact cntct=new contact(firstName='steven',lastName='smith',email='test@test.com' ,
                                      Possible_Duplicate__c=true, Deceased__c = true  );
            cntct.Country_of_Birth__c = 'America';
            cntct.Birth_Locale__c = 'America';
            Date ddd = Date.newInstance(1999, 12, 9);
            cntct.Birthdate = ddd;
            cntct.Alternative_Email__c = 'test@test.com';
            insert cntct;
            map<id,id> contactMap = new map<id,id>();
            contactMap.put(objuser.id,cntct.id);
            utils.updateCont_User(contactMap);
            Test.stopTest();  
        }
        catch (Exception x) {
            system.debug('exception = ' + x);
        }
    }
}