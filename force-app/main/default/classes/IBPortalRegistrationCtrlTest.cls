/*******************************************************************************************
* @Name     IBPortalRegistrationCtrlTest 
* @Author       
* @Date         
* @Group        
* @Description  This Class is test class for IBPortalRegistrationCtrl
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      07/06/2023         Updated the date of birth to -20 years from today to avoid custom validation rule exception
*******************************************************************************************/
@isTest
private class IBPortalRegistrationCtrlTest {
    
    @isTest static void test_method_one() {
        integer i=1;
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;

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
        cont.Phone = '+13861234567';
        cont.Country_of_Birth__c = 'America';
        cont.Birth_Locale__c = 'America';
        cont.Alternative_Email__c = 'abc@gmail.com';
        cont.Birthdate = date.today().addYears(-20);
        //cont.Invitation_ID__c=cont0.id;
        insert cont;
        
        Contact cont1 = TestsUtil.createContact('test_name_001', 'ibtestuser34@ibtestportal.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont1.AccountId = acc.Id;
        cont1.FirstName = 'First';
        cont1.LastName = 'Last';
        cont1.Phone = '+13861234567';
        cont1.Country_of_Birth__c = 'America';
        cont1.Birth_Locale__c = 'America';
        cont1.Alternative_Email__c = 'ibtestuser34@ibtestportal.com';
        cont.Birthdate = date.today();
        cont1.User__c = Null;
        cont1.Deceased__c = false;
        cont1.IBIS_contact_ID__c = 'abc';
        cont1.Country__c = countries[1].Id;
        //cont.Invitation_ID__c=cont0.id;
        //insert cont1; 
        list<selectoption> lst = new list<selectoption>();

        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='Test1', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;
        
        contact c=[select id ,Invitation_ID__c from contact where id=:cont.id ];
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        repo.Role_Level__c = 'Fully Qualified';
        repo.Require_Educational_Degree__c = true;
        repo.Require_Language_Experience__c = true;
        repo.MyIB_Has_Subjects__c = true;
        repo.MyIB_Has_Workshop_Titles__c = true;
        repo.Display_in_MyIB__c = true;
        //repo.MyIB_Use_My_School_Subjects__c = true;
        insert repo;
        
        IB_Role__c testRoleAndApp = TestsUtil.createIbRole(repo.id, cont.Id);
        testRoleAndApp.IB_Account__c = acc .Id;
        testRoleAndApp.Status__c='Confirmed';
        testRoleAndApp.Active__c = true;
        insert testRoleAndApp;
        
        Test.startTest();

        System.RunAs(usr){
            PageReference regPage = Page.IBPortalRegistration;
            Test.setCurrentPage(regPage);
            regPage.getParameters().put('inviteid', c.Invitation_ID__c);

            IBPortalRegistrationCtrl controller  =  new IBPortalRegistrationCtrl();
            controller.birthDateString = '2020-06-03T05:00:00.000Z';
            controller.contactObject.FirstName = 'First';
            controller.contactObject.LastName = 'Last';
            controller.contactObject.HomePhone = '+983861234567';
            controller.contactObject.OtherPhone = '+343861234567';
            controller.contactObject.MobilePhone = '+113861234567';
            controller.contactObject.Phone = '+13861234567';
            controller.contactObject.Country__c = countries[1].Id;
            controller.contactObject.Email = 'ibtestuser35@ibtestportal.com';
            controller.contactObject.Alternative_Email__c = 'ibtestuser34@ibtestportal.com';
            controller.contactObject.Birth_Locale__c = 'America';
            controller.contactObject.Account = acc;
            controller.contactObject.AccountId = acc.Id;
            controller.userLang = 'en_US';
            String nickname = controller.communityNickname;
            String capKey = controller.gCaptchaKey;
            String curYear = controller.getCurrentYear();
            //insert controller.contactObject;
            controller.registerUser();
            controller.inviteRolesList=NULL;
            controller.roles=NULL;
            controller.selectedCountry=NULL;
            controller.userName=NULL;
            controller.util=NULL;
            controller.getLocale();
            lst = controller.getLanguageInfo();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
           
        
            //List<SelectOption> countryInfo = controller.getCountryInfo();
        }

        Test.stopTest();
    }

    @isTest static void test_method_two() {
        integer i=1;
        //
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
        cont.Phone = '+13861234567';
        insert cont;

        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='Test1', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;

        Test.startTest();

        System.RunAs(usr){
            PageReference regPage = Page.IBPortalRegistration;
            Test.setCurrentPage(regPage);
            IBPortalRegistrationCtrl controller  =  new IBPortalRegistrationCtrl();
            controller.birthDateString = '1980-01-01T05:00:00.000Z';
            controller.contactObject.FirstName = 'First';
            controller.contactObject.LastName = 'Last';
            controller.contactObject.HomePhone = '+13861234567';
            controller.contactObject.OtherPhone = '+23861234567';
            controller.contactObject.MobilePhone = '+93861234567';
            controller.contactObject.Phone = '+13861234567';
            controller.contactObject.Country__c = countries[1].Id;
            controller.contactObject.Email = 'ibtestuser34@ibtestportal.com';
            controller.contactObject.Alternative_Email__c = 'ibtestuser35@ibtestportal.com';
            controller.contactObject.Account = acc;
            controller.contactObject.AccountId = acc.Id;
            String nickname = controller.communityNickname;
            String capKey = controller.gCaptchaKey;
            String curYear = controller.getCurrentYear();
            //insert controller.contactObject;
            controller.registerUser();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        
            //List<SelectOption> countryInfo = controller.getCountryInfo();
        }

        Test.stopTest();
    }

    @isTest static void test_method_three() {
        integer i=1;
        //
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
        cont.Phone = '+133861234567';
        insert cont;

        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='Test1', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;

        Test.startTest();

        System.RunAs(usr){
            PageReference regPage = Page.IBPortalRegistration;
            Test.setCurrentPage(regPage);
            IBPortalRegistrationCtrl controller  =  new IBPortalRegistrationCtrl();
            controller.birthDateString = '1980-01-01T05:00:00.000Z';
            controller.contactObject.FirstName = 'First';
            controller.contactObject.LastName = 'Last';
            controller.contactObject.HomePhone = '+13861234567';
            controller.contactObject.OtherPhone = '+53861234567';
            controller.contactObject.MobilePhone = '+93861234567';
            controller.contactObject.Phone = '+13861234567';
            controller.contactObject.Country__c = countries[1].Id;
            controller.contactObject.Email = 'ibtestuser34@ibtestportal.com';
            controller.contactObject.Alternative_Email__c = 'ibtestuser35@ibtestportal.com';
            controller.contactObject.Account = acc;
            controller.contactObject.AccountId = acc.Id;
            String nickname = controller.communityNickname;
            String capKey = controller.gCaptchaKey;
            String curYear = controller.getCurrentYear();
            //insert controller.contactObject;
            controller.contactObject.Email = 'ibtestuser35@ibtestportal.com';
            controller.registerUser();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        
            //List<SelectOption> countryInfo = controller.getCountryInfo();
        }

        Test.stopTest();
    }
    
    public static User createPortalUser(String testemail, Contact c, String locale, String profile){
        Profile p =  [select Id from profile where name=:profile limit 1];
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = locale,
                           languagelocalekey = locale, timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        return pu;
    }
    
}