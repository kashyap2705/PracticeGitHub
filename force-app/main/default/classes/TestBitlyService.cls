@isTest
private class TestBitlyService {

    private static testMethod void testBitlyServiceForAccountInsert() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMock());
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Language_Of_Correspondance__c = 'English';
        acc.IBIS_ID__c  = '052451';
        acc.Short_Name__c = 'test';
        acc.Legal_Status__c = 'Private';
        acc.Country__c = 'UNITED STATES';
        acc.State_Abbr__c = 'AK';
        acc.Sub_region__c = 'EUROPE';
        acc.Region__c = 'IBA';
        acc.Website = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm';
        test.startTest();
        insert acc;
        test.stopTest();
        Account result = [Select Website from Account where id =: acc.Id];
    }
    
    private static testMethod void testBitlyServiceForAccountUpdate() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMock());
        
        Account acc = new Account();
        acc.Name = 'test';
        acc.Language_Of_Correspondance__c = 'English';
        acc.IBIS_ID__c  = '052451';
        acc.Short_Name__c = 'test';
        acc.Legal_Status__c = 'Private';
        acc.Country__c = 'UNITED STATES';
        acc.State_Abbr__c = 'AK';
        acc.Sub_region__c = 'EUROPE';
        acc.Region__c = 'IBA';
        acc.Website = 'login.salesforce.com';
        insert acc;
        
        test.startTest();
        acc.Website = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm';
        update acc;
        test.stopTest();
        Account result = [Select Website from Account where id =: acc.Id];
     //   system.assertEquals(result.Website,'http://sforce.co/2cCk3Uz');
    }
    
    private static testMethod void testBitlyServiceForLeadInsert() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMock());
        
        Date dd = Date.newInstance(1990, 11, 2);
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'Lead';
        l.Date_of_birth__c= dd;
        l.Rating = 'Hot';
        l.Status = 'Open';
        l.Company = 'test';
        l.Account_Short_Name__c = 'test';
        l.Email = 'test@apex.com';
        l.Lead_Type__c = 'New';
        l.IB_Programme_Interest__c = 'DP';
        l.AE_Country__c = 'US';
        l.Country__c = 'UNITED STATES';
        l.CountryCode = 'US';
        l.StateCode = 'USCA';
        l.Sub_region__c = 'NORTHERN AMERICA';
        l.Region__c = 'IBA';
        l.LeadSource = 'Other';
        l.Language_of_Correspondence_with_IB__c = 'English';
        l.Language__c = 'English';
        l.Website = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm';
        l.Legal_Status__c = 'Private';
        l.Position_with_School__c = 'Other';
        l.DP_Interest__c = true;
        test.startTest();
        insert l;
        test.stopTest();
        Lead result = [Select Website from Lead where id =: l.Id];
        system.assertEquals(result.Website,'http://sforce.co/2cCk3Uz');
    }
    
    private static testMethod void testBitlyServiceForLeadUpdate() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new BitlyServiceMock());
        
        Date dd = Date.newInstance(1991, 10, 3);
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'Lead';
        l.Date_of_birth__c= dd;
        l.Rating = 'Hot';
        l.Status = 'Open';
        l.Company = 'test';
        l.Account_Short_Name__c = 'test';
        l.Email = 'test@apex.com';
        l.Lead_Type__c = 'New';
        l.IB_Programme_Interest__c = 'DP';
        l.AE_Country__c = 'US';
        l.Country__c = 'UNITED STATES';
        l.CountryCode = 'US';
        l.StateCode = 'USCA';
        l.Sub_region__c = 'NORTHERN AMERICA';
        l.Region__c = 'IBA';
        l.LeadSource = 'Other';
        l.Language_of_Correspondence_with_IB__c = 'English';
        l.Language__c = 'English';
        l.Website = 'login.salesforce.com';
        l.Legal_Status__c = 'Private';
        l.Position_with_School__c = 'Other';
        l.DP_Interest__c = true;
        insert l;
        
        test.startTest();
        l.Website = 'https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_restful_http_testing_httpcalloutmock.htm';
        update l;
        test.stopTest();
        Lead result = [Select Website from Lead where id =: l.Id];
        system.assertEquals(result.Website,'http://sforce.co/2cCk3Uz');
    }
    
}