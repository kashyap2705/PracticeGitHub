@isTest
private class IbenRegistrationWizardControllerTest {
    
    @isTest
    static void veryfyInointialState() {
        
        IbenRegistrationWizardController controller  =  new IbenRegistrationWizardController();
        
        Contact contact  = controller.contactObject;
        controller.getMillisecNow();
        System.assert(contact.Contact_Type__c == 'IBEN');
        System.assert(! controller.getIsErrorPage1());
        System.assert(! controller.getIsErrorPage2());
        System.assert(! controller.getIsErrorPage3());
        System.assert(! controller.getIsErrorPage4());
        System.assert(! controller.getIsErrorPage5());
        System.assert(! controller.getIsNextPage2());
        System.assert(! controller.getIsNextPage3());
        System.assert(! controller.getIsNextPage4());
        System.assert(! controller.getIsNextPage5());
        System.assert(! controller.getisMatchByUserHomeEmail());
        System.assert(! controller.getisMatchByUserWorkEmail());
        System.assert(controller.publicKey != null);
        System.assert(controller.getCountryInfo() != null &&  controller.getCountryInfo().size() == 0);
        System.assert(controller.getSelectedCountry() == null);
        System.assert(controller.getShowAgreementBlock() == false);
        System.assert(controller.verified == false);
        
        controller.isLoggedIn(); 
        
        controller.birthDay = NULL;
        controller.birthMonth = NULL;
        controller.birthYear = NULL;
        Boolean b =controller.getDisplayDuplicateForm();
        controller.getDualProfile();
        controller.dateOfBirth = NULL;
        
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                         Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+9212345678',Phone='+9212345678',Email='abc@gmail.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact; 
        
        User usr = new User(Alias = 'ibport', Email='abc@gmail.com',
                            EmailEncodingKey='UTF-8',Username='abc@gmail.com.ibotest',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId =  [Select Id from  Profile where Name = 'Customer Community Basic'].id,
                            TimeZoneSidKey='America/Los_Angeles',ContactId=ObjContact.Id,Bypass_Validation_Rules__c=true);
        
        insert usr;
        
        controller.submitDupeData();
        IbenRegistrationWizardController.updatePortalUser(NULL);
        IbenRegistrationWizardController.updatePortalUser(NULL, NULL, NULL, NULL, NULL, NULL);
        controller.cancelDupeData();
    }
    
    @isTest
    static void veryfyInointialState1() 
    {
        IbenRegistrationWizardController controller  =  new IbenRegistrationWizardController();
        Account objAccount = new Account(Name='test record',Region__c='IBAP',Sub_region__c= 'SOUTH ASIA',CurrencyIsoCode = 'SGD',
                                         Website = 'www.test.com',IBIS_ID__c = '123456',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        objAccount.IsPartner=true;
        update objAccount;
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=objAccount.Id,Homephone='+9212345678',Phone='+9212345678',Email='abc@gmail.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact; 
        controller.submitDupeData();
    }
    
    @isTest
    static void testFieldsAreValid() {
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        controller.validate();
        
        controller.getLocale();    
        
        Boolean isFirstNameEmpty = false,
            isLastNameEmpty = false,
            isSalutationEmpty = false,
            isEmailEmpty = false,
            isBirthdateEmpty = false,
            isCountryEmpty = false;
        
        for (ApexPages.Message msg: ApexPages.getMessages()) {
            if (msg.getDetail().contains('title')) isSalutationEmpty = true;
            if (msg.getDetail().contains('First Name')) isFirstNameEmpty = true;
            if (msg.getDetail().contains('Last Name')) isLastNameEmpty = true;
            if (msg.getDetail().contains('email')) isEmailEmpty = true;
            if (msg.getDetail().contains('Date of Birth')) isBirthdateEmpty = true;
            if (msg.getDetail().contains('Date of Birth')) isCountryEmpty = true;
        }
        
        System.assert(!isFirstNameEmpty);
        System.assert(!isLastNameEmpty);
    }
    
    @isTest
    static void testFieldsAreValidUserIsOlder18 () {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPage(cont, null);
        cont.Birthdate = Date.today().addYears(-15);
        
        Test.startTest();
        controller.validate();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages());
        
        Boolean isYounger18 = false;
        for (ApexPages.Message msg: ApexPages.getMessages()){
            if (msg.getDetail().contains('18')) isYounger18 = true;
        }
        System.assert(isYounger18);
    }
    
    @isTest
    static void testValidateCaptchaIsNotValid() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = '';
        controller.response = '';
        
        Contact cont = controller.contactObject;
        fillObjectFromPage(cont, null);
        
        controller.validate(); 	
        
        Boolean hasErrorMessage = false;
        for (ApexPages.Message msg: ApexPages.getMessages()){
            if (msg.getDetail().contains('reCaptcha')) hasErrorMessage = true;
        }
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImplError());
        
        controller.challenge = 'challenge';
        controller.response = 'not_captcha';
        
        Test.startTest();
        controller.validate();
        Test.stopTest();
        
        hasErrorMessage = false;
        for (ApexPages.Message msg: ApexPages.getMessages()){
            if (msg.getDetail().contains('reCaptcha')) hasErrorMessage = true;
        }  	
    }
    
    @isTest
    static void testValidateCaptchaIsValid() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'test_text';
        controller.response = 'test_text';
        
        Contact cont = controller.contactObject;
        fillObjectFromPage(cont, null);
        
        Test.startTest();
        controller.validate();
        Test.stopTest(); 
    }
    
    @isTest
    static void testContactsHaveDifferentEmails() {	 
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        insert cont1;
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);
        cont.MobilePhone = cont1.MobilePhone;
        
        PageReference redirectedPage;
        
        Test.startTest();
        redirectedPage = controller.validate();
        Test.stopTest();
        
        redirectedPage = controller.submitIssue();
    }
    
    @isTest
    static void testNoMatchesFound() {	
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPage(cont, null);	    
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.validate();
        Test.stopTest();  		
    }	
    
    @isTest
    static void testContactsHomeEmailsMatchAndNoUserFound() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        insert cont1;
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);	
        cont.Email = cont1.Email;
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.validate();
        Test.stopTest();
    }
    
    @isTest
    static void testContactsHomeEmailAndProffEmailsMatch() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        insert cont1;
        
        PageReference regStep0 = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep0);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);	
        cont.Email = cont1.Email;
        cont.Alternative_Email__c = cont1.Alternative_Email__c;
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.validate();
        Test.stopTest();
    }	 
    
    @isTest
    static void testSubmitData() {
        
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        List<Profile> profiles = getProfilesWhereUserLicenseNameContains('Customer Portal');
        
        PortalUserInfo__c pi = createPortalUserInfoCustomSetting('IbenPublicPortal', acc, profiles.get(0));
        insert pi;
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.xxx', 'axxx@xxx.com', Date.today().addYears(-20), country);
        insert cont1;
        
        PageReference regStep1 = new PageReference('/apex/regStep1');
        Test.setCurrentPage(regStep1);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);
        cont.Contract_Signed__c = true;
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.submitData();
        Test.stopTest();
        
        System.debug('>>>>> see no data = redirectedPage >>>' + redirectedPage);
    }
    
    @isTest
    static void testSubmitDataNoCustomSetting() {
        
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        List<Profile> profiles = getProfilesWhereUserLicenseNameContains('Customer Portal');
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.xxx', 'axxx@xxx.com', Date.today().addYears(-20), country);
        insert cont1;
        
        PageReference regStep1 = new PageReference('/apex/regStep1');
        Test.setCurrentPage(regStep1);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);
        cont.Contract_Signed__c = true;
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.submitData();
        Test.stopTest();
        
        System.debug('>>>>> see no data = redirectedPage >>>' + redirectedPage);
    }
    
    @isTest
    static void testRecreateUser() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        System.debug('AccountIS'+acc);							  
        List<Profile> profiles = getProfilesWhereUserLicenseNameContains('Customer Portal');
        
        PortalUserInfo__c pi = createPortalUserInfoCustomSetting('IbenPublicPortal', acc, profiles.get(0));
        insert pi;
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.Id;
        insert cont1;
        
        PageReference regStep = new PageReference('/apex/regStep0');
        Test.setCurrentPage(regStep);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        
        Contact cont = controller.contactObject;
        fillObjectFromPageNoCreate(cont, country);
        cont.Email = cont1.Email;
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.validate();
        Test.stopTest();
        
        System.assert(!controller.getIsNextPage2() );
        
        regStep = new PageReference('/apex/regStep2');
        Test.setCurrentPage(regStep);
        
        cont.Contract_Signed__c = false;
        redirectedPage = controller.reCreateUser();
        
        cont.Contract_Signed__c = true;
        redirectedPage = controller.reCreateUser();		
        
        System.debug('>>>>>testRecreateUser redirectedPage >>>' + redirectedPage);
    }
    
    @isTest
    static void testCheckUserName() {
        
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        
        List<Profile> profiles = [Select Id from  Profile where Name = 'Customer Community Basic'];
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.Id;
        insert cont1;
        
        User user = createUser('usertestname2@xxx.com', 'test_user_lastName', 'yyyyy@yyyy.com', true, profiles.get(0), cont1);
        insert user;
        
        PageReference regStep1 = new PageReference('/apex/regStep1');
        Test.setCurrentPage(regStep1);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        
        controller.setUserName('test2@test2.com');
        controller.checkUsername();
        controller.setUserName(user.Name);
        controller.checkUsername();
    }  
    
    @isTest
    static void testCheckUserNameNoName() {     
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        
        List<Profile> profiles = [Select Id from  Profile where Name = 'Customer Community Basic'];
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.Id;
        insert cont1;
        
        User user = createUser('usertestname@xxx.com', 'test_user_lastName', 'yyyyy@yyyy.com', true, profiles.get(0), cont1);
        insert user;
        
        PageReference regStep1 = new PageReference('/apex/regStep1');
        Test.setCurrentPage(regStep1);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        
        controller.setUserName('test2@test2.com');
        controller.checkUsername();
        controller.getLocale();					
        controller.setUserName(user.Name);
        controller.checkUsername();
    }  
    
    @isTest
    static void testResetPasswordNotValidUser() {	
        init();
        
        IB_Country_Segmentation__c country = getCountryByName('Ukraine');
        Account acc = getAccountById(country.IBEN_Independent_Account__c);
        
        Contact cont1 = TestsUtil.createContact('test_name_2', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.id;
        insert cont1;
        
        List<Profile> profiles = [Select Id from  Profile where Name = 'Customer Community Basic'];
        
        Boolean isActive = true;
        User user = createUser('usertestname@xxx.com', 'test_user_lastName', cont1.Email, isActive, profiles.get(0), cont1);
        insert user;
        
        PageReference page = new PageReference('/apex/siteHomePage');
        Test.setCurrentPage(page);
        
        IbenRegistrationWizardController controller = new IbenRegistrationWizardController();
        
        PageReference redirectedPage;
        Test.startTest();
        redirectedPage = controller.resetPassword();
        Test.stopTest();
    }
    
    @isTest
    static void validateWithMoreThat2Matched() {
        
        ApexPages.currentPage().getHeaders().put('x-original-remote-addr','test');
        ApexPages.currentPage().getHeaders().put('X-Salesforce-SIP', 'Test');
        
        final PageReference errorPage = new PageReference('/apex/regErrorPage');
        
        final IbenRegistrationWizardController controller  =  new IbenRegistrationWizardController();
        controller.challenge = 'chalenge';
        controller.response = 'chalenge';
        fillObjectFromPage(controller.contactObject, null);
        Test.setMock(HttpCalloutMock.class, new CaptchaHttpCalloutMockImpl());
        
        final List <Contact> cons  = getContacts();
        cons.get(1).email = 123 + cons.get(1).email; 
        cons.get(2).email = 'newtesting@example.com'; 
        
        insert cons;
        
        Test.startTest();
        final PageReference result = controller.validate();
        Test.stopTest();
        
        system.assertEquals(false, controller.getIsErrorPage1() , 'Should be redirected to error page with error message 1!');
    }
    
    @isTest
    static void  redirectToLandingPageTest() {
        
        final PageReference regStep0 = new PageReference('/apex/regStep0');
        final IbenRegistrationWizardController controller  =  new IbenRegistrationWizardController();
        
        system.assertEquals(true, regStep0.getUrl().equals(controller.redirectToLandingPage().getUrl()) ,' User did not do validation step! ');
    }
    
    @isTest
    static void testSiteValidationHelper() {
        Contact emptyContact = new Contact();
        List<Contact> conn=new List<Contact>();
        conn.add(emptyContact);
        
        try{
            SiteValidationHelper.findMatches(conn);
        } catch (Exception e) {
            System.debug('***** +++ >> ' + e.getMessage());
        }
        
        conn[0].FirstName = 'testname';
        
        try{
            SiteValidationHelper.findMatches( conn );
        } catch (Exception e) {
            System.debug('***** ++ + >> ' + e.getMessage());
        }
        
        conn[0].LastName = 'test last name';
        
        try{
            SiteValidationHelper.findMatches( conn );
        } catch (Exception e) {
            System.debug('***** +++ >> ' + e.getMessage());
        }
        
        conn[0].Email = 'xxxxx@xxxx.com';
        
        try{
            SiteValidationHelper.findMatches( conn );
        } catch (Exception e) {
            System.debug('***** +++ >> ' + e.getMessage());
        }	
        
        conn[0].HomePhone = '+9212345678';	
        try{
            SiteValidationHelper.findMatches( conn );
        } catch (Exception e) {
            System.debug('***** +++ >> ' + e.getMessage());
        }	   
    }
    
    private static void alert(IbenRegistrationWizardController controller) {
        
        system.debug('ALERTSTART'+controller.getIsErrorPage1());
        system.debug(controller.getIsErrorPage2());
        system.debug(controller.getIsErrorPage3());
        system.debug(controller.getIsErrorPage4());
        system.debug(controller.getIsErrorPage5());
        system.debug(controller.getIsNextPage2());
        system.debug(controller.getIsNextPage3());
        system.debug(controller.getIsNextPage4());
        system.debug(controller.getIsNextPage5());
    }
    
    private static IB_Country_Segmentation__c getCountryByName(String name) {
        return [SELECT Id, IBEN_Independent_Account__c
                FROM IB_Country_Segmentation__c 
                WHERE Name = : name];
    }
    
    private static List<Profile> getProfilesWhereUserLicenseNameContains(String name){
        return [SELECT p.name, p.id 
                FROM Profile p 
                WHERE p.UserLicense.Name LIKE : ('%'+name.trim()+'%')];
    }
    
    private static Account getAccountById(Id accId){
        return [SELECT Id 
                FROM Account 
                WHERE Id = : accId];
    }
    
    private static List <Contact> getContacts() {
        
        Contact one = new Contact ();
        Contact two = new Contact ();
        Contact three = new Contact ();
        
        fillObjectFromPage(one,'123123');
        fillObjectFromPage(two,'234234');
        fillObjectFromPage(three,'345345');
        
        return new List <Contact> {one,two,three};
            }
    
    private static void fillObjectFromPage(Contact contactObject, String ibis) {
        
        Account acc = TestsUtil.createAccount('TestMethod Account Name');
        if (ibis == null) {
            acc.IBIS_ID__c = '121212';
        }
        else {
            acc.IBIS_ID__c = ibis;
        }
        insert acc;
        
        final IB_Country_Segmentation__c country = createCountry('Ukraine', 'Europe', acc);
        insert country;
        
        fillObjectFromPageNoCreate(contactObject, country);
    }
    
    private static void fillObjectFromPageNoCreate(Contact contactObject, IB_Country_Segmentation__c country) {
        
        contactObject.Salutation = 'Prof';
        contactObject.FirstName  = 'First Name';
        contactObject.LastName   = 'Last  Name';
        contactObject.Email      = 'test@test.com';
        contactObject.Alternative_Email__c = 'atest@test.com';
        contactObject.HomePhone  = '+9212345678';
        contactObject.OtherPhone = '+9212345678';
        contactObject.MobilePhone= '+9212345678';
        contactObject.Phone = '+9212345678';								 
        contactObject.Birthdate = Date.today().addYears(-25);
        contactObject.Country__c = country.id;
    }
    
    class CaptchaHttpCalloutMockImplError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals(IbenRegistrationWizardController.baseUrl, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            HTTPResponse response = new HTTPResponse();
            response.setBody('wrong result');
            response.setStatusCode(400);
            return response; 
        }
    }   
    
    private static void init() {
        
        Account acc = TestsUtil.createAccount('TestMethod Account Name');
        acc.IBIS_ID__c = '454545';
        insert acc;
        
        final IB_Country_Segmentation__c country = createCountry('Ukraine', 'Europe', acc);
        insert country;
    }
    
    private static IB_Country_Segmentation__c createCountry(String name, String region, Account acc){
        return new IB_Country_Segmentation__c (
            Name = name, 
            Geographical_Sub_Region_Segmentation__c = region,
            Regional_Office_Segmentation__c ='IBAP', 
            IBEN_Segmentation__c = 'IBAP',
            IBEN_Independent_Account__c = acc.Id
        );
    }
    
    private static PortalUserInfo__c createPortalUserInfoCustomSetting(String name, Account acc, Profile prof){
        return new PortalUserInfo__c(
            Name = name, 
            ProfileId__c = prof.Id
        );
    }
    
    private static Contact createContact(String name, String homeEmail, String profEmail, Date birthdate, IB_Country_Segmentation__c country){
        return new Contact(
            LastName = name,
            Email = homeEmail,
            Phone = '+9212345678',
            Birthdate = birthdate,
            Country__c = (country == null?null : country.id)
        );
    }
    
    private static User createUser (String userName, String lastName, String email, Boolean isActive, Profile prof, Contact cont){
        return new User(
            alias = (userName + '123456781234').replace('.','').replace('@','').substring(0,8),  
            Email = email, emailencodingkey='UTF-8', LastName = lastName, languagelocalekey='en_US',
            localesidkey='en_US', 
            timezonesidkey='America/Los_Angeles', Username = userName, 
            CommunityNickname = 'Nick_' + userName, IsActive = isActive, ProfileId = prof.Id ,
            contactId = (cont.id==null?null:cont.id)
        );
    }
}