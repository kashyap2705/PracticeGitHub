@isTest
public class IBENContactRoleCustomObjAPIBatchTest {
    
    @isTest static void TestOne() {
        Account acc = TestsUtil.createAccount('IBEN Global');
        insert acc;
        String firstname = 'IBEN API';
        String lastname = 'Test';
        String Email = 'Testibenapi1@Ibo.org';
        Date birthdate = system.today()-36500;
        List<IBENApiRequest__c> records= new list<IBENApiRequest__c>();
        IBENApiRequest__c IbenApi = TestsUtil.IBENApiRequests(firstname,lastname,Email,birthdate);
        Test.startTest();
        records.add(IbenApi);
        Insert IbenApi;
        IBENContactRoleCustomObjAPIBatch b = new IBENContactRoleCustomObjAPIBatch ();
        Database.QueryLocator ql = b.start(null);
        b.execute(null,records);
        b.Finish(null);
        Test.stopTest();
    }
    
    @isTest static void Testtwo() {
        
        Account acc = TestsUtil.createAccount('IBEN Global');
        insert acc;
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        countries.add(country);
        country = null;
        country = TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc);
        country.IBEN_Independent_Account__c = acc.Id;
        countries.add(country);
        insert countries;
	 	Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
	 	insert cont1;
        
        String firstname = 'IBEN API';
        String lastname = 'Test';
        String Email = 'Testibenapi2@Ibo.org';
        Date birthdate = system.today()-36500;
        List<IBENApiRequest__c> records= new list<IBENApiRequest__c>();
        IBENApiRequest__c IbenApi = TestsUtil.IBENApiRequests(firstname,lastname,Email,birthdate);
        IbenApi.contact_id__c = cont1.Id;
        records.add(IbenApi);
        Insert IbenApi;
        
        Test.startTest();
        IBENContactRoleCustomObjAPIBatch b = new IBENContactRoleCustomObjAPIBatch ();
        Database.QueryLocator ql = b.start(null);
        b.execute(null,records);
        b.Finish(null);
        
        Test.stopTest();
    }
}