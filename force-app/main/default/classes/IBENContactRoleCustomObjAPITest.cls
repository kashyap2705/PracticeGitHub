@isTest
public class IBENContactRoleCustomObjAPITest {
    @testSetup static void setup()
    {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Account acc = PimsTestUtil.createAccount('IBEN Test', 'School Account');
        insert acc; 
        Account ibenAccount = PimsTestUtil.createAccount('IBEN Global', 'Office Account');
        insert ibenAccount; 
        
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        
        //Insert contact
        Contact con1 = new Contact();
        con1.AccountId = ibenAccount.Id;
        con1.Contact_Type__c = 'IBEN';
        con1.RecordTypeId = ContactRecordTypeId; 
        con1.FirstName = 'Robin';
        con1.LastName = 'API--PSO';
        con1.Legal_First_Name__c = 'Robin';
        con1.Legal_Last_Name__c = 'API--PSO';
        con1.Birthdate = Date.newInstance(1984, 09, 14);
        con1.Email = 'testPSO@test.com';
        con1.Alternative_Email__c  = 'testwwPSO@test.com';
        con1.Country_of_Birth__c = 'Afghanistan';
        con1.IBEN_Active__c=true;
        insert  con1;
        
        //Insert contact
        Contact con2 = new Contact();
        con2.AccountId = ibenAccount.Id;
        con2.Contact_Type__c = 'IBEN';
        con2.RecordTypeId = ContactRecordTypeId; 
        con2.FirstName = 'Ted';
        con2.LastName = 'Mosby';
        con2.Legal_First_Name__c = 'Ted';
        con2.Legal_Last_Name__c = 'Mosby';
        con2.Birthdate = Date.newInstance(1984, 09, 14);
        con2.Email = 'tedmosby@test.com';
        con2.Alternative_Email__c  = '';
        con2.Country_of_Birth__c = 'United States';
        con2.IBEN_Active__c=false;
        insert  con2;
        
        //Create Contact Information
        Contact_Information__c ci = new Contact_Information__c();
        ci.IB_Contact__c = con2.id;
        ci.Email__c = 'Test@test.com';
        ci.Name = 'Test@test.com';
        insert ci;
        
        //Insert 'Examiner' Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        
        //Insert 'Chief Examiner' Role Repository
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Chief Examiner');
        theRoleRepo2.Role_Type__c = 'IBEN Role';
        theRoleRepo2.Permission_Set_Name__c = 'Chief Examiner';
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2};
            
            //Insert Programme - Examiners can have only DP as their programme selection
            IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
        prog.Status__c = 'Interested';
        insert prog;
        
        //Insert Confirmed Examiner Role
        IB_Role__c examinerRole = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, ibenAccount.Id);  
        examinerRole.Programme_Selection__c = 'DP';
        examinerRole.Start_Date__c = Date.today();
        examinerRole.IB_Account__c = ibenAccount.Id;
        examinerRole.Status__c = 'Confirmed';
        examinerRole.Reason_For_Status__c='Confirmed'; 
        examinerRole.Active__c = true;
        examinerRole.Contact_Information_Email__c = ci.id;
        insert examinerRole;
        
    }
    static testMethod void newContactRole_doPost() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'Barney');
        dummyRequest.put('PreferredLastName', 'Stinson');
        dummyRequest.put('LegalFirstName', 'Barney');
        dummyRequest.put('LegalLastName', 'Stinson');
        dummyRequest.put('DateOfBirth',Date.newInstance(1988, 07, 24));
        dummyRequest.put('Email', 'barney@stinson.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'United States');
        dummyRequest.put('RoleName', 'Chief Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','United States');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','California');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void newRole_doPost() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'Robin');
        dummyRequest.put('PreferredLastName', 'API--PSO');
        dummyRequest.put('LegalFirstName', 'Robin');
        dummyRequest.put('LegalLastName', 'API--PSO');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'testPSO@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Afghanistan');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','United States');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','California');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
       
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    
    static testMethod void existingContactRole_doPost() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'Robin');
        dummyRequest.put('PreferredLastName', 'API--PSO');
        dummyRequest.put('LegalFirstName', 'Robin');
        dummyRequest.put('LegalLastName', 'API--PSO');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'testPSO@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Afghanistan');
        dummyRequest.put('RoleName', 'Chief Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','United States');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','California');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void incorrectvalues() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', '123');
        dummyRequest.put('PreferredLastName', '!@#$%');
        dummyRequest.put('LegalFirstName', '123!@#');
        dummyRequest.put('LegalLastName', '!@#123');
        dummyRequest.put('DateOfBirth', '!@#123');
        dummyRequest.put('Email', 'testPSOtest.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', '!@#');
        dummyRequest.put('RoleName', 'sample');
        dummyRequest.put('Programme', 'abcd');
        dummyRequest.put('Country','Canada');								//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    
    static testMethod void newNegativeContactRole_doPost() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'Robin 3');
        dummyRequest.put('PreferredLastName', 'API PSO');
        dummyRequest.put('LegalFirstName', 'Robin 3');
        dummyRequest.put('LegalLastName', 'API PSO');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'testPSO@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Afghanistan');
        dummyRequest.put('RoleName', 'Chief Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canada');								//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    static testMethod void NewContact() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('NewContactCreation');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', '123');
        dummyRequest.put('RoleName', 'abcd');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canada');								//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');						//Modified by Shahrukh for ECM00207 on 02/05/2024
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    //Added by Shahrukh for ECM00207 on 02/05/2024 -- START --
    static testMethod void dateCheckTest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('dateCheckTest');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', '08/23/21');
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', '123');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canada');
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void countryCheckTest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('countryCheckTest');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', '123');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canadaa');
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void residentialCountryCheckTest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('residentialCountryCheckTest');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Canada');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canadaa');
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontario');
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void stateCheckForUS_CA_AUTest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('stateCheckForUS_CA_AUTest');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Canada');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canada');
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontariooo');
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    
    static testMethod void stateProvinceCheckTest() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/IBENContactRoleCustomObjAPI';
        request.httpMethod = 'POST';
        
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('Accept', 'application/json');
        system.debug('stateProvinceCheckTest');
        Map<String,Object> dummyRequest = new Map<String,Object>();
        dummyRequest.put('PreferredFirstName', 'abcd');
        dummyRequest.put('PreferredLastName', 'abcd');
        dummyRequest.put('LegalFirstName', 'abcd');
        dummyRequest.put('LegalLastName', 'abcd');
        dummyRequest.put('DateOfBirth', Date.newInstance(1984, 09, 14));
        dummyRequest.put('Email', 'abcd@test.com');
        dummyRequest.put('AlternativeEmail', '');
        dummyRequest.put('CountryOfBirth', 'Canada');
        dummyRequest.put('RoleName', 'Examiner');
        dummyRequest.put('Programme', 'MYP');
        dummyRequest.put('Country','Canada');
        dummyRequest.put('Street','Street');
        dummyRequest.put('City','City');
        dummyRequest.put('StateProvince','Ontariooo');
        dummyRequest.put('PostalZipCode','123123');
        dummyRequest.put('Nationality','Nationality');
        request.requestBody = Blob.valueOf(JSON.serialize(dummyRequest));
        
        RestContext.request = request;
        RestResponse res = new RestResponse();
        RestContext.response = res;
        
        Test.startTest();
        IBENContactRoleCustomObjAPI.doPost();
        Test.stopTest();
        
    }
    //Added by Shahrukh for ECM00207 on 02/05/2024 -- END --
}