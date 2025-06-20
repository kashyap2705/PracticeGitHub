@isTest
private class PimsApplicationRedirectControllerTest {
    
    @testSetup static void setup() {
        Account accOne = new Account();
        Account acc = AccountTestDataFactory.createAccount('School Account',accOne);
        insert acc;
        
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = acc.Id;
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = acc.Id;
        ibAdd.Country__c = ibCon.id;
        
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        IB_Programme__c ibProg = new IB_Programme__c();
        ibProg.Account__c = acc.Id;
        ibProg.Street_Address__c = address.id;
        ibProg.Owner__c = UserInfo.getUserId();
        
        IB_Programme__c programme = IBProgrammeTestDataFactory.createIBProgramme('PYP', ibProg);
        programme = PimsTestUtil.associateAddressWithProgramme(programme, address, 'billing');
        insert programme;
        
        String authRecordType = Schema.SObjectType.IB_Application__c.getRecordTypeInfosByDeveloperName().get('Application_for_Authorization').getRecordTypeId();
        String canRecordType = Schema.SObjectType.IB_Application__c.getRecordTypeInfosByDeveloperName().get('Application_for_Candidacy').getRecordTypeId();
        
        
        IB_Application__c appAuth = new IB_Application__c(Name = 'Auth App',Application_Lookup_to_Programme__c = programme.Id, RecordTypeId = authRecordType);
        IB_Application__c appCan = new IB_Application__c(Name = 'Can App',Application_Lookup_to_Programme__c = programme.Id, RecordTypeId = canRecordType);
        insert new List<IB_Application__c>{appAuth, appCan};
            }
    
    @isTest
    static void testRedirectWithoutId() {
        Test.startTest();
        PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
        PageReference result = controller.init();
        Test.stopTest();
        System.assertEquals('/pims/PimsDashboard', result.getUrl(), 'Should redirect to dashboard when no ID is provided.');
    }
    
    @isTest
    static void testRedirectWithAuthType() {
        IB_Application__c app = [SELECT Id,RecordType.Name FROM IB_Application__c WHERE Name = 'Auth App' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/TestPage'));
        ApexPages.currentPage().getParameters().put('id', app.Id);
        ApexPages.currentPage().getParameters().put('type', 'auth');
        
        Test.startTest();
            PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
            controller.appList = new List<IB_Application__c> {app};
            PageReference result = controller.init();
        Test.stopTest();
        
        System.assert(result.getUrl().contains('/pims/PimsApplicationForAuthorization'), 'Should redirect to Authorization page.');
    }
    
    @isTest
    static void testRedirectWithCanType() {
        IB_Application__c app = [SELECT Id,RecordType.Name FROM IB_Application__c WHERE Name = 'Can App' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/TestPage'));
        ApexPages.currentPage().getParameters().put('id', app.Id);
        ApexPages.currentPage().getParameters().put('type', 'can');
        
        Test.startTest();
            PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
            controller.appList = new List<IB_Application__c> {app};
            PageReference result = controller.init();
        Test.stopTest();
        
        System.assert(result.getUrl().contains('/pims/PimsApplicationForCandidacy'), 'Should redirect to Candidacy page.');
    }
    
    @isTest
    static void testRedirectWithAuthorizationNoType() {
        IB_Application__c app = [SELECT Id, RecordType.Name FROM IB_Application__c WHERE Name = 'Auth App' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/TestPage'));
        ApexPages.currentPage().getParameters().put('id', app.Id);
        
        Test.startTest();
            PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
            controller.appList = new List<IB_Application__c> {app};
            PageReference result = controller.init();
        Test.stopTest();
        
        System.assert(result.getUrl().contains('/pims/PimsApplicationForAuthorization'), 'Should redirect to Authorization page by default.');
    }
    
    @isTest
    static void testRedirectToCandidacyWithoutType() {
        IB_Application__c app = [SELECT Id,RecordType.Name FROM IB_Application__c WHERE Name = 'Can App' LIMIT 1];
        Test.setCurrentPageReference(new PageReference('/apex/TestPage'));
        ApexPages.currentPage().getParameters().put('id', app.Id); 
        
        Test.startTest();
            PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
            controller.appList = new List<IB_Application__c> {app};
            PageReference result = controller.init();
        Test.stopTest();
        
        System.assert(result.getUrl().contains('/pims/PimsApplicationForCandidacy'), 'Should redirect to Candidacy page when no type is provided.');
    }
    
}