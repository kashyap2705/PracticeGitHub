@isTest
public class IBENBQCEventFeedbackControllerTest {
    
    private static My_Staffing_Event__c getStaffingEvent(String roleName) {
        return [SELECT Id FROM My_Staffing_Event__c WHERE IB_Role__r.Role_Name__c = :roleName LIMIT 1];
    }
    
    @TestSetup
    static void setupTestData() {
        
        // Create test account
        Account testAccount = AccountTestDataFactory.createAccount(null, null);
        insert testAccount;
        
        // Create test contact
        Contact testContact = ContactTestDataFactory.createContact(null, 
            new Contact(AccountId = testAccount.Id, Email = 'testcontact@test.com'));
        insert testContact;
        
        // Create a unique username using timestamp or org ID
    	String uniqueUserName = 'testuser' + Datetime.now().getTime() + '@test.com';
        
        // Create test user
        User testUser = UserTestDataFactory.createUser('System Administrator', 
            new User(
                Email = 'testuser@test.com',
                Username = uniqueUserName,
                LastName = 'TestUser',
                isActive = true
            ));
        insert testUser;
        
        // Create IB Country Segmentation
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        // Create IB Address
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = testAccount.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        // Create IB Programme
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme('MYP', null);
        prog.Account__c = testAccount.Id;
        prog.Street_Address__c = address.Id;
        insert prog;
        
        // Create Campaign (IB Event)
        Campaign camp = new Campaign(
            Name = 'BQC Test Event',
            Sub_Type__c = 'BQC Event',
            Related_IB_Programme__c = prog.Id,
            Venue_Account__c = testAccount.Id,
            BQC_Subject__c = 'Arts',
            Unit_Plan__c = 'Unit 1',
            StartDate = Date.today(),
            BQC_Status__c = 'Pending Feedback from Reviewer'
        );
        insert camp;
        
        // Create IB Role Repository for different reviewer types
        List<IB_Role_Repository__c> roles = new List<IB_Role_Repository__c>();
        
        // Reviewer role
        roles.add(new IB_Role_Repository__c(
            Role_Name__c = 'Building Quality Curriculum Reviewer',
            Category__c = 'Learning Centre',
            Related_Programmes__c = 'PYP;MYP;DP;IBCC',
            Available_in_Region__c = 'Global',
            IB_Staff_Role__c = true
        ));
        
        // Senior Reviewer role
        roles.add(new IB_Role_Repository__c(
            Role_Name__c = 'Building Quality Curriculum Senior Reviewer',
            Category__c = 'Learning Centre',
            Related_Programmes__c = 'PYP;MYP;DP;IBCC',
            Available_in_Region__c = 'Global',
            IB_Staff_Role__c = true
        ));
        
        // School Reviewer role
        roles.add(new IB_Role_Repository__c(
            Role_Name__c = 'Building Quality Curriculum School Reviewer',
            Category__c = 'Learning Centre',
            Related_Programmes__c = 'PYP;MYP;DP;IBCC',
            Available_in_Region__c = 'Global',
            IB_Staff_Role__c = true
        ));
        
        insert roles;
        
        // Create My Staffing Event for each role type
        List<My_Staffing_Event__c> staffingEvents = new List<My_Staffing_Event__c>();
        
        for(IB_Role_Repository__c role : roles) {
            staffingEvents.add(new My_Staffing_Event__c(
                IB_Programme__c = prog.Id,
                IB_Event__c = camp.Id,
                IB_Contact__c = testContact.Id,
                IB_Role__c = role.Id
            ));
        }
        insert staffingEvents;
        
        // Create attachments
        List<IB_Application_Attachment__c> attachments = new List<IB_Application_Attachment__c>();
        
        // Unit Plan
        attachments.add(new IB_Application_Attachment__c(
            IB_Programme__c = prog.Id,
            Name = 'Arts_Unit_1_Unit_Plan.docx',
            Type__c = 'Unit Plan',
            BQC_Subject__c = 'Arts',
            Unit_Plan__c = 'Unit 1'
        ));
        
        // Self-assessment
        attachments.add(new IB_Application_Attachment__c(
            IB_Programme__c = prog.Id,
            Name = 'Arts_Unit_1_Self_assessment.docx',
            Type__c = 'Self-assessment',
            BQC_Subject__c = 'Arts',
            Unit_Plan__c = 'Unit 1'
        ));
        
        // Reviewer Feedback
        attachments.add(new IB_Application_Attachment__c(
            IB_Programme__c = prog.Id,
            Name = 'BQC_Reviewer_Feedback.docx',
            Type__c = 'BQC Reviewer Feedback',
            BQC_Subject__c = 'Arts',
            Unit_Plan__c = 'Unit 1'
        ));
        
        // Senior Reviewer Feedback
        attachments.add(new IB_Application_Attachment__c(
            IB_Programme__c = prog.Id,
            Name = 'BQC_Senior_Reviewer_Feedback.docx',
            Type__c = 'BQC Senior Reviewer Feedback',
            BQC_Subject__c = 'Arts',
            Unit_Plan__c = 'Unit 1'
        ));
        
        // School Reviewer Feedback
        attachments.add(new IB_Application_Attachment__c(
            IB_Programme__c = prog.Id,
            Name = 'BQC_School_Reviewer_Feedback.docx',
            Type__c = 'BQC School Reviewer Feedback'
        ));
        
        insert attachments;
    }
    
    @isTest 
    static void testReviewerFeedback() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum Reviewer');
        
        Test.startTest();
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        
        // Test initial state
        System.assertEquals(false, controller.alreadySubmitted, 'Should not be already submitted');
        System.assertEquals(true, controller.reviewer_role, 'Should be reviewer role');
        System.assertEquals(false, controller.senior_reviewer_role, 'Should not be senior reviewer role');
        System.assertEquals(false, controller.school_reviewer_role, 'Should not be school reviewer role');
        
        // Test file upload
        controller.fileBody = Blob.valueOf('Test file content');
        controller.fileName = 'testfile.doc';
        controller.description = 'Test description';
        controller.upload();
        
        // Test save
        controller.save();
        
        // Verify campaign status was updated
        Campaign updatedCamp = [SELECT BQC_Status__c FROM Campaign LIMIT 1];
        System.assertEquals('Pending Feedback from Senior Reviewer', updatedCamp.BQC_Status__c, 'Status should be updated');
        
        Test.stopTest();
    }
    
    @isTest 
    static void testSeniorReviewerFeedback() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum Senior Reviewer');
        Test.startTest();
        // Update campaign status to pending senior reviewer feedback
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        camp.BQC_Status__c = 'Pending Feedback from Senior Reviewer';
        update camp;
        
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        
        // Test initial state
        System.assertEquals(false, controller.alreadySubmitted, 'Should not be already submitted');
        System.assertEquals(false, controller.reviewer_role, 'Should not be reviewer role');
        System.assertEquals(true, controller.senior_reviewer_role, 'Should be senior reviewer role');
        System.assertEquals(false, controller.school_reviewer_role, 'Should not be school reviewer role');
        
        // Test file upload
        controller.fileBody = Blob.valueOf('Test file content');
        controller.fileName = 'testfile.doc';
        controller.description = 'Test description';
        controller.upload();
        
        // Test save
        controller.save();
        
        // Verify campaign status was updated
        Campaign updatedCamp = [SELECT BQC_Status__c FROM Campaign LIMIT 1];
        System.assertEquals('Feedback Submitted by Senior Reviewer', updatedCamp.BQC_Status__c, 'Status should be updated');
        
        Test.stopTest();
    }
    
    @isTest
    static void testSchoolReviewerFeedback() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum School Reviewer');
        Test.startTest();
        // Update campaign status to pending school reviewer feedback
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        camp.BQC_Status__c = 'Pending Feedback from School Reviewer';
        update camp;
        
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        Test.stopTest();
        // Test initial state
        System.assertEquals(false, controller.alreadySubmitted, 'Should not be already submitted');
        System.assertEquals(false, controller.reviewer_role, 'Should not be reviewer role');
        System.assertEquals(false, controller.senior_reviewer_role, 'Should not be senior reviewer role');
        System.assertEquals(true, controller.school_reviewer_role, 'Should be school reviewer role');
        
        // Test file upload
        controller.fileBody = Blob.valueOf('Test file content');
        controller.fileName = 'testfile.doc';
        controller.description = 'Test description';
        controller.upload();
        
        // Test save
        controller.save();
    }
    
    @isTest
    static void testCancel() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum Reviewer');
        
        Test.startTest();
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        
        // Set attachment for cancel test
        controller.attachment = [SELECT Id FROM IB_Application_Attachment__c WHERE Type__c = 'BQC Reviewer Feedback' LIMIT 1];
        
        // Test cancel
        controller.Cancel();
        
        // Verify attachment was deleted
        List<IB_Application_Attachment__c> remainingAttachments = [
            SELECT Id FROM IB_Application_Attachment__c WHERE Type__c = 'BQC Reviewer Feedback'
        ];
        System.assertEquals(0, remainingAttachments.size(), 'Attachment should be deleted');
        
        Test.stopTest();
    }
    
    @isTest
    static void testInvalidFileUpload() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum Reviewer');
        
        Test.startTest();
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        
        // Test invalid file type
        controller.fileBody = Blob.valueOf('Test file content');
        controller.fileName = 'testfile.txt'; // Invalid extension
        controller.description = 'Test description';
        controller.upload();
        
        // Verify error message
        System.assertEquals(1, ApexPages.getMessages().size(), 'Should show error for invalid file type');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetIDUSubjectName() {
        
        My_Staffing_Event__c staffEvent = getStaffingEvent('Building Quality Curriculum Reviewer');
        
        Test.startTest();
        PageReference pageRef = Page.IBENBQCEventFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', staffEvent.Id);
        
        IBENBQCEventFeedbackController controller = new IBENBQCEventFeedbackController();
        
        // Test English
        System.assertEquals(
            'Interdisciplinary (IDU)', 
            controller.get_IDU_SubjectName(),
            'English version should return "Interdisciplinary (IDU)"'
        );
        
        // Test Spanish
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        currentUser.LanguageLocaleKey = 'es';
        update currentUser;
        System.assertEquals(
            'Unidad Interdisciplinaria', 
            controller.get_IDU_SubjectName(),
            'Spanish version should return "Unidad Interdisciplinaria"'
        );
        
        // Test French
        currentUser.LanguageLocaleKey = 'fr';
        update currentUser;
        System.assertEquals(
            'Unité de travail interdisciplinaire', 
            controller.get_IDU_SubjectName(),
            'French version should return "Unité de travail interdisciplinaire"'
        );
        
        Test.stopTest();
    }
}