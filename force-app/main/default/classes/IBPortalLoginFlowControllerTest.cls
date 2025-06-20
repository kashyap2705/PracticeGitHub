@isTest
private class IBPortalLoginFlowControllerTest {
	static testMethod void Test1() {  
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
        insert cont;

        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;

        System.RunAs(usr){  
               test.startTest();  
                IBPortalLoginFlowController cs = new IBPortalLoginFlowController();
                cs.birthDateString = '01/01/1990';
                cs.isIben = true;
            	cs.getContactObject();
            	cs.saveProfile();
               test.stopTest();  
           }  
      }  
}