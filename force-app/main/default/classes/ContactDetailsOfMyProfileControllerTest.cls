@isTest
public class ContactDetailsOfMyProfileControllerTest {
    
    @testSetup 
    static void setup() {
        
        Account acc = AccountTestDataFactory.createAccount(null, null); 
        acc.Name = 'acc_test_test_name_000';
        acc.IBIS_ID__c = '000002';
        acc.Region__c = 'IBA';
        insert acc;
        
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Country_es__c = 'Test_Country';
        country.Geographical_Sub_Region_Segmentation__c = 'Europe';
        country.IBEN_Independent_Account__c = acc.Id;
        insert country;
        
        Contact con = ContactTestDataFactory.createContact(null, null);
        con.LastName = 'test_name_000';
        con.AccountId = acc.Id;
        con.email = 'test_name_000xxx@testtest.com';
        con.Alternative_Email__c = 'test_name_000xxx@testtest.com';
        con.country__c = country.Id;
        insert con;
        
        User usr = UserTestDataFactory.createUser('Customer Community Advanced', null);
        usr.ContactId = con.Id;
        usr.isActive = true;
        usr.Username = 'testuser333@email.com';
		insert usr;
        
        Account acc1 = AccountTestDataFactory.createAccount('School Account', null);
        acc1.Name = 'IB High';
        acc1.IBIS_ID__c = '123456';
        acc1.Short_Name__c = 'IB High';
        insert acc1;
    }
    
    @isTest
    private static void testInitialState(){
        
        User portalUser = [SELECT Id, ContactId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Customer Community Advanced') AND isActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        
        init(); 
        initAttachments(portalUser.ContactId);
        
        System.RunAs(portalUser) {
            
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            
            ContactDetailsOfMyProfileController profileDetailsController = new ContactDetailsOfMyProfileController();
            profileDetailsController.rerenderParents = 'AccountTabPanel';
            
            System.assert(profileDetailsController.getCountryInfo() != null);
            System.assertEquals(3, profileDetailsController.getCountryInfo().size());
            
            ContactDetailsOfMyProfileController.FileWraper fw = profileDetailsController.getCvDoc();
            System.assert(fw.body == null);
            System.assert(fw.name == null);
            System.assert(fw.size == null);
            System.assert(fw.contentType == null);
            
            String language = profileDetailsController.getUserLanguageKey();
            String userEmail = profileDetailsController.getUserEmail();
            String userProfile = profileDetailsController.getUserProfile();
            List<String> schoolAccounts = ContactDetailsOfMyProfileController.lookupSchoolAccount('IB High');
            String schoolAccountByName = ContactDetailsOfMyProfileController.lookupSchoolAccountByName('IB High');
            List<String> schoolAccountMulti = ContactDetailsOfMyProfileController.lookupSchoolAccountByNameMulti('IB High:123456');
            ContactDetailsOfMyProfileController.FileWraper unitPlanner = profileDetailsController.getsampleunitplannerDoc();
            ContactDetailsOfMyProfileController.FileWraper curriculumoverview = profileDetailsController.getcurriculumcourseoverviewDoc();
            ContactDetailsOfMyProfileController.FileWraper termsDoc = profileDetailsController.getTermsDoc();
            ContactDetailsOfMyProfileController.FileWraper annualRelease = profileDetailsController.getAnnualReleaseDoc();
        }
    }
    
    @isTest
    private static void testContactInfoUpdate() {
        
        Test.startTest();
        User portalUser = [SELECT Id, ContactId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Customer Community Advanced') AND isActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        System.debug('Portal User ContactId: ' + portalUser.ContactId);
        
        Contact userContact;
        try {
            userContact = [SELECT Id, LastName, Country__c FROM Contact WHERE Id = :portalUser.ContactId LIMIT 1];
            System.debug('User Contact: ' + userContact);
        } catch (Exception e) {
            System.debug('Error querying Contact: ' + e.getMessage());
        }
        
        init(); 
        initAttachments(portalUser.ContactId);
        
        System.RunAs(portalUser) {
            
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            ContactDetailsOfMyProfileController profileDetailsController = new ContactDetailsOfMyProfileController();
            profileDetailsController.rerenderParents = 'AccountTabPanel';
            Contact contactObject = profileDetailsController.getContactObject();
            contactObject.HomePhone = '+30101010101';
            
            profileDetailsController.edit();
            Contact contUpdated = getContactById(contactObject.Id);
            
            System.assert(contUpdated.HomePhone == contactObject.HomePhone, 'Error: Contact information was NOT updated');
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testAttachmentCreateDelete() {
        
        Test.startTest();
        User portalUser = [SELECT Id, ContactId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Customer Community Advanced') AND isActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        
        init(); 
        initAttachments(portalUser.ContactId);
        
        System.RunAs(portalUser) {
            
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            ContactDetailsOfMyProfileController profileDetailsController = new ContactDetailsOfMyProfileController();
            profileDetailsController.rerenderParents = 'AccountTabPanel';
            
            ContactDetailsOfMyProfileController.FileWraper fw = profileDetailsController.getCvDoc();
            fw.body = Blob.valueOf('test text');
            fw.name = 'att_name_1';
            fw.size = 1000;
            fw.contentType = 'text/html';
            fw.base64 = 'test base64';
            
            profileDetailsController.edit();
            
            System.assertEquals(2, profileDetailsController.attachments.size());
            profileDetailsController.remAttachId = null;
            profileDetailsController.removeCv();
            System.assertEquals(2, profileDetailsController.attachments.size());
            
            profileDetailsController.remAttachId = profileDetailsController.attachments.get(0).Id;
            profileDetailsController.removeCv();
            
            System.assertEquals(1, profileDetailsController.attachments.size());
        }
        Test.stopTest();
    }
    
    @isTest
    private static void testFileSizeIsTooBig() {
        
        User portalUser = [SELECT Id, ContactId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Customer Community Advanced') AND isActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        
        init(); 
        initAttachments(portalUser.ContactId);
        
        System.RunAs(portalUser) {
            
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            System.currentPageReference().getParameters().put('selectedTab', '');
            
            ContactDetailsOfMyProfileController profileDetailsController = new ContactDetailsOfMyProfileController();
            profileDetailsController.rerenderParents = 'AccountTabPanel';
            
            ContactDetailsOfMyProfileController.FileWraper fw = profileDetailsController.getCvDoc();
            fw.body = Blob.valueOf('test text');
            fw.name = 'att_name_1.jpg';
            fw.size = ContactDetailsOfMyProfileController.MAX_FILE_SIZE_FOR_UPLOAD * 2;
            fw.contentType = 'text/html';
            
            profileDetailsController.edit();
            
            System.assert(ApexPages.getMessages().get(0).getDetail().contains('maximum file size'));
            
            fw.description = 'profile photo';
            fw.size = ContactDetailsOfMyProfileController.MAX_PROFILEIMAGE_SIZE_FOR_UPLOAD + 1;
            profileDetailsController.edit();
            fw.size = ContactDetailsOfMyProfileController.MAX_PROFILEIMAGE_SIZE_FOR_UPLOAD - 1;
            profileDetailsController.edit();
            fw.name = 'profile photo';
            profileDetailsController.edit();
            profileDetailsController.cancel();
        }
    }
    
    @isTest
    private static void testExceptionOnEdit() {
        
        User portalUser = [SELECT Id, ContactId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'Customer Community Advanced') AND isActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        
        init(); 
        initAttachments(portalUser.ContactId);
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            portalUser.languageLocaleKey = 'es';
            update portalUser;
        }
        Test.stopTest();
        
        System.RunAs(portalUser) {
            
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            
            ContactDetailsOfMyProfileController profileDetailsController = new ContactDetailsOfMyProfileController();
            
            Contact contactObject = profileDetailsController.getContactObject();
            contactObject.LastName = null;
            
            profileDetailsController.edit();
            profileDetailsController.getconsent();
            profileDetailsController.getCorHelpText();
            profileDetailsController.getUserLanguageKey();
            profileDetailsController.getUserEmail();
            profileDetailsController.getUserProfile();
            profileDetailsController.getPrefPhone();
            profileDetailsController.getPrefAdd();
            profileDetailsController.getIBENComm();
            profileDetailsController.getMailingCountry();
            profileDetailsController.getResidentialCountry();
            profileDetailsController.getMailingZipPostalCode();
            profileDetailsController.getResidentialZipPostalCode();
            profileDetailsController.getMailingState();
            profileDetailsController.getResidentialState();
            profileDetailsController.getMailingCity();
            profileDetailsController.getResidentialCity();
            profileDetailsController.getMailingStreet();
            profileDetailsController.getResidentialAddress();
            profileDetailsController.getAddressDetails();
            profileDetailsController.getLegallastName();
            profileDetailsController.getLegalfirstName();
            profileDetailsController.getLegalinformation();
            profileDetailsController.getRetired();
            profileDetailsController.getJobTitle();
            profileDetailsController.getAdditionalContactDetails();
            profileDetailsController.getCommunicationPreference();
            profileDetailsController.getIBENId();
            System.assert(ApexPages.hasMessages());
        }
    }
    
    @isTest
    private static void testEqualsFileAndAttachmentDescriptions() {
     
        ContactDetailsOfMyProfileController controller = setupControllerForTest();
        Attachment att = controller.attachments.get(0);
        setupFileWraperAndEdit(controller, att.Description);
        validateControllerState(controller);
        
        System.assertEquals(0, [SELECT Id FROM Attachment WHERE Id = :att.Id].size(), 'Attachment should have been deleted');
    }
    
    private static ContactDetailsOfMyProfileController setupControllerForTest() {
        
        User portalUser = [SELECT Id, ContactId FROM User WHERE ProfileId IN (SELECT Id FROM Profile WHERE Name = 'Customer Community Advanced') AND IsActive = true AND Username = 'testuser333@email.com' LIMIT 1];
        
        init();
        initAttachments(portalUser.ContactId);
        
        Test.startTest();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            portalUser.languageLocaleKey = 'fr';
            update portalUser;
        }
        Test.stopTest();
        
        System.RunAs(portalUser) {
            Pagereference myProfile = Page.myProfile;
            Test.setCurrentPage(myProfile);
            
            ContactDetailsOfMyProfileController controller = new ContactDetailsOfMyProfileController();
            controller.rerenderParents = 'AccountTabPanel';
            return controller;
        }
        return null; // This line will never be reached due to System.RunAs
    }
    
    private static void setupFileWraperAndEdit(ContactDetailsOfMyProfileController controller, String attachmentDescription) {
        
        ContactDetailsOfMyProfileController.FileWraper fw = controller.getTermsDoc();
        fw.body = Blob.valueOf('test text');
        fw.name = 'att_name_1.doc';
        fw.size = ContactDetailsOfMyProfileController.MAX_FILE_SIZE_FOR_UPLOAD - 2;
        fw.contentType = 'text/html';
        fw.description = attachmentDescription;
        
        controller.edit();
    }
    
    private static void validateControllerState(ContactDetailsOfMyProfileController controller) {
        
        controller.getPhoto();
        controller.getIbenTermsDoc();
        controller.getReaderTermsDoc();
        controller.getSvTeamTermsDoc();
        controller.getSvLeadTermsDoc();
        controller.getConsultTermsDoc();
        controller.getWorkshopTermsDoc();
        controller.getFieldRepTermsDoc();
        controller.getProfilePhoto();
        controller.getconsent();
        controller.getUserLanguageKey();
        controller.getUserEmail();
        controller.getUserProfile();
        controller.getPrefPhone();
        controller.getPrefAdd();
        controller.getIBENComm();
        controller.getMailingCountry();
        controller.getResidentialCountry();
        controller.getMailingZipPostalCode();
        controller.getResidentialZipPostalCode();
        controller.getMailingState();
        controller.getResidentialState();
        controller.getMailingCity();
        controller.getResidentialCity();
        controller.getMailingStreet();
        controller.getResidentialAddress();
        controller.getAddressDetails();
        controller.getLegallastName();
        controller.getLegalfirstName();
        controller.getLegalinformation();
        controller.getRetired();
        controller.getJobTitle();
        controller.getAdditionalContactDetails();
        controller.getCommunicationPreference();
        controller.getIBENId();
    }
    
    private static void init() {
        Account acc = TestsUtil.createAccount('TestMethod Account Name');
        insert acc;
        
        IB_Country_Segmentation__c country1 = TestsUtil.createCountry('Ukraine', 'Europe', acc);
        IB_Country_Segmentation__c country2 = TestsUtil.createCountry('Polland', 'Europe', acc);
        insert new List<sObject> {country1, country2};
            }
    
    private static void initAttachments(Id contactId){
        Attachment att1 = TestsUtil.createAttachment('test_name1', contactId);
        Attachment att2 = TestsUtil.createAttachment('test_name2', contactId);
        att1.Description = ContactDetailsOfMyProfileController.TERMS_DESCRIPTION;
        att2.Description = ContactDetailsOfMyProfileController.ANNUALRELEASE_DESCRIPTION;
        insert new List<sObject> {att1, att2};
            }
    
    private static Contact getContactById(Id contId) {
        return [select Salutation, LastName, MobilePhone, HomePhone, OtherPhone, Email, Birthdate, Country__c,Alternative_Email__c
                from Contact
                where id = : contId];
    }
    
}