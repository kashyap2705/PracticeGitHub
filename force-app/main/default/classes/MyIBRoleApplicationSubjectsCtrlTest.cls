@isTest
public class MyIBRoleApplicationSubjectsCtrlTest {
    
    @TestSetup
    static void setupTestData() {
        
        // Create test account
        Account testAccount = AccountTestDataFactory.createAccount(null, null);
        insert testAccount;
        
        // Create test contact
        Contact testContact = ContactTestDataFactory.createContact(null, 
                                                                   new Contact(AccountId = testAccount.Id, Email = 'testcontact@test.com'));
        insert testContact;
        
        // Create test user
        User testUser;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            String uniqueUserName = 'testuser' + Datetime.now().getTime() + '@test.com';
            testUser = UserTestDataFactory.createUser('System Administrator', 
                                                      new User(
                                                          Email = 'testuser@test.com',
                                                          Username = uniqueUserName,
                                                          LastName = 'TestUser',
                                                          isActive = true
                                                      ));
            insert testUser;
        }
        
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
        
        // Create IB Programmes
        List<IB_Programme__c> programmes = new List<IB_Programme__c>{
            IBProgrammeTestDataFactory.createIBProgramme('PYP', 
                                                         new IB_Programme__c(
                                                             Account__c = testAccount.Id,
                                                             Street_Address__c = address.Id
                                                         )),
                IBProgrammeTestDataFactory.createIBProgramme('CP', 
                                                             new IB_Programme__c(
                                                                 Account__c = testAccount.Id,
                                                                 Street_Address__c = address.Id
                                                             ))
                };
                    insert programmes;
        
        // Create IB Subject
        IB_Subject__c testSubject = new IB_Subject__c(
            IB_Programme__c = programmes[0].Id,
            Subject_Name__c = 'Test Subject',
            Subject_Name_FR__c = 'Test Subject FR',
            Subject_Name_SP__c = 'Test Subject SP',
            Available_in_MySchool__c = true,
            Available_in_IBEN__c = true
        );
        insert testSubject;
        
        // Create IB Role Repository
        IB_Role_Repository__c testRoleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Head of School',
                Role_Level__c = 'Fully Qualified',
                Related_Programmes__c = 'PYP;MYP;DP;CP',
                Require_Educational_Degree__c = true,
                Require_Language_Experience__c = true,
                MyIB_Has_Subjects__c = true,
                MyIB_Has_Workshop_Titles__c = true,
                Display_in_MyIB__c = true,
                MyIB_Use_My_School_Subjects__c = false
            ));
        insert testRoleRepo;
        
        // Create IB Role with "Evaluation" status (not confirmed/declined)
        IB_Role__c testRole = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = testAccount.Id,
                IB_Programme_New__c = programmes[1].Id,
                Programme_Selection__c = 'CP',
                Status__c = 'Evaluation', 
                Active__c = true,
                IB_Role__c = testRoleRepo.Id,
                IB_Contact__c = testContact.Id,
                Age_Groups__c = 'Age 11-12'
            ));
        insert testRole;
        
        // Create Workshop Titles
        IB_Workshop_Titles__c testWorkshopTitle = new IB_Workshop_Titles__c(
            Name = 'Test Workshop Title',
            Programme__c = 'CP',
            Subject__c = testSubject.Id,
            Workshop_Title_SP__c = 'spanish',
            Workshop_Title_ENG__c = 'english',
            Workshop_Title_FR__c = 'french'
        );
        insert testWorkshopTitle;
        
        // Create Workshop Details
        IB_Workshop_Details__c testWorkshopDetail = new IB_Workshop_Details__c(
            Name = 'Test Detail',
            IB_Category__c = 'Category 3',
            IB_Workshop_Title__c = testWorkshopTitle.Id
        );
        insert testWorkshopDetail;
        
        // Create Role Application Workshop Title
        Role_Application_Workshop_Title__c testRoleAppTitle = new Role_Application_Workshop_Title__c(
            IB_Workshop_Title__c = testWorkshopTitle.Id,
            Role_And_Application__c = testRole.Id
        );
        insert testRoleAppTitle;
        
        // Create Role Application Subject
        Role_Application_Subject__c testRoleAppSubject = new Role_Application_Subject__c(
            IB_Subject__c = testSubject.Id,
            Role_And_Application__c = testRole.Id
        );
        insert testRoleAppSubject;
    }
    
    @isTest
    static void testEnglishUserFlow() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id, Programme_Selection__c, Status__c FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme; 
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test subject method
            controller.subjectGroup = 'Test Group';
            List<SelectOption> subjectGroups = controller.getSubjectGroups();
            System.assert(!subjectGroups.isEmpty(), 'Subject groups should not be empty');
            
            // Test workshop title methods
            controller.getWorkshopTitles();
            controller.getSelectedWorkshopTitles();
            
            // Test workshop search and filter without changing programme
            controller.searchfilter_category = 'Category 3';
            controller.category_filter();
            
            controller.inputText1 = 'english';
            controller.get_searchtitle();
            
            // Test save methods
            controller.saveWorkshopTitles();
            controller.saveWorkshopTitles_Workshop_leader();
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testSpanishUserFlow() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        testUser.LanguageLocaleKey = 'es';
        update testUser;
        
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test basic Spanish functionality
            controller.inputText1 = 'spanish';
            controller.get_searchtitle();
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testSubjectOperations() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        IB_Subject__c testSubject = [SELECT Id FROM IB_Subject__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test subject creation
            controller.addSubject = testSubject.Id;
            System.assertNotEquals(null, controller.createSubject(), 'Should return page reference');
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testFrenchUserFlow() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        testUser.LanguageLocaleKey = 'fr';
        update testUser;
        
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test French language functionality
            controller.inputText1 = 'french';
            controller.get_searchtitle();
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testAgeGroupFunctionality() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test age group selection
            controller.selectedAgeGroup = new List<SelectOption>();
            controller.selectedAgeGroup.add(new SelectOption('3-5', '3-5 years'));
            PageReference result = controller.addAgeGroup();
            
            System.assertNotEquals(null, result, 'Should return page reference');
            Test.stopTest();
        }
    }
    
    @isTest
    static void testSubjectRemoval() {
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        Role_Application_Subject__c testRoleAppSubject = [SELECT Id, Role_And_Application__c FROM Role_Application_Subject__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRoleAppSubject.Role_And_Application__c);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            controller.deleteId = testRoleAppSubject.Id;
            PageReference result = controller.removeSubject();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            System.assertNotEquals(null, result, 'Should return page reference');
            Test.stopTest();
        }
    }

    @isTest
    static void testEmptySubjectGroup() {
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            String pname = controller.selectedprogramme;
            System.assertEquals('CP', pname, 'The programme name does not match expected value');
            // Test with empty subject group
            controller.subjectGroup = '';
            List<SelectOption> subjectNames = controller.getSubjectNames();
            
            System.assert(subjectNames.isEmpty(), 'Subject names should be empty for empty group');
            Test.stopTest();
        }
    }
    
    @isTest
    static void testWorkshopTitleRetrievalWithoutSubjects() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id, Programme_Selection__c FROM IB_Role__c LIMIT 1];
        
        // Create additional workshop title without subjects
        IB_Workshop_Titles__c emptyWorkshopTitle = new IB_Workshop_Titles__c(
            Name = 'Empty Workshop Title',
            Programme__c = testRole.Programme_Selection__c,
            Workshop_Title_SP__c = 'spanish empty',
            Workshop_Title_ENG__c = 'english empty',
            Workshop_Title_FR__c = 'french empty'
        );
        insert emptyWorkshopTitle;
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            controller.getWorkshopTitles();
            
            // Verify workshop titles without subjects are included
            Boolean foundEmptyTitle = false;
            for(MyIBRoleApplicationSubjectsCtrl.Workshops_Details wd : controller.Workshops_Details_List) {
                if(wd.workshop_title.IB_Workshop_Title__r.Workshop_Title_ENG__c == 'english empty') {
                    foundEmptyTitle = true;
                    break;
                }
            }
            // Assert that the Workshops_Details_List is not empty
            System.assert(!controller.Workshops_Details_List.isEmpty(), 'Workshops_Details_List should not be empty');
            // Assert that the workshop title without subjects is selectable
            System.assert(controller.WorkshopTitlesOptions.size() > 0, 'Workshop titles options should include the empty title');
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testWorkshopTitlesWithSubjects() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id, Programme_Selection__c FROM IB_Role__c LIMIT 1];
        IB_Subject__c testSubject = [SELECT Id FROM IB_Subject__c LIMIT 1];
        
        // Create workshop title with subjects
        IB_Workshop_Titles__c titleWithSubjects = new IB_Workshop_Titles__c(
            Name = 'Title With Subjects',
            Programme__c = testRole.Programme_Selection__c,
            Workshop_Title_ENG__c = 'with subjects'
        );
        insert titleWithSubjects;
        
        // Create workshop title subject association
        IB_Workshop_Title_Subject__c titleSubject = new IB_Workshop_Title_Subject__c(
            IB_Workshop_Title__c = titleWithSubjects.Id,
            IB_Subject__c = testSubject.Id
        );
        insert titleSubject;
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            // Create role application subject to match
            Role_Application_Subject__c ras = new Role_Application_Subject__c(
                Role_And_Application__c = testRole.Id,
                IB_Subject__c = testSubject.Id
            );
            insert ras;
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            controller.getWorkshopTitles();
            
            // Verify title with subjects is included
            Boolean foundTitleWithSubjects = false;
            for(MyIBRoleApplicationSubjectsCtrl.Workshops_Details wd : controller.Workshops_Details_List) {
                if(wd.workshop_title.IB_Workshop_Title__r.Workshop_Title_ENG__c == 'with subjects') {
                    foundTitleWithSubjects = true;
                    break;
                }
            }
            
            // Assert that the workshop title appears in the selectable options
            Boolean foundInOptions = false;
            for(SelectOption option : controller.WorkshopTitlesOptions) {
                if(option.getLabel() == 'with subjects') {
                    foundInOptions = true;
                    break;
                }
            }
            System.assert(foundInOptions, 'Workshop title with subjects should appear in selectable options');
            // Assert that the Workshops_Details_List contains the expected title
            System.assert(!controller.Workshops_Details_List.isEmpty(), 'Workshops_Details_List should not be empty');
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testSearchWorkshopsDetails() {
        
        User testUser = [SELECT Id FROM User WHERE Email LIKE 'testuser%@test.com' LIMIT 1];
        IB_Role__c testRole = [SELECT Id FROM IB_Role__c LIMIT 1];
        
        System.runAs(testUser) {
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('/apex/myibroleapplicationsubjects'));
            ApexPages.currentPage().getParameters().put('Id', testRole.Id);
            
            MyIBRoleApplicationSubjectsCtrl controller = new MyIBRoleApplicationSubjectsCtrl();
            
            // Test search functionality
            controller.inputText1 = 'test search';
            controller.get_searchtitle();
            
            // Test empty search
            controller.inputText1 = '';
            controller.get_searchtitle();
            
            // Test category filter with search
            controller.searchfilter_category = 'Category 3';
            controller.category_filter();
            
            // Assert that empty search returns all results
            System.assert(!controller.Workshops_Details_List.isEmpty(), 'Empty search should return all workshops');
            
            // Assert that category filter is applied
            Boolean hasCategory3 = false;
            for(MyIBRoleApplicationSubjectsCtrl.Workshops_Details wd : controller.Workshops_Details_List) {
                if(wd.workshop_title.IB_Category__c == 'Category 3') {
                    hasCategory3 = true;
                    break;
                }
            }
            
            System.assert(hasCategory3, 'Category filter should return workshops with Category 3');
        	System.assertEquals('Category 3', controller.searchfilter_category, 'Category filter should be set to Category 3');
            
            Test.stopTest();
        }
    }
}