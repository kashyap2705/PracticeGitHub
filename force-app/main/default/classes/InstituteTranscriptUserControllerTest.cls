/**
 * @description Test class for InstituteTranscriptUserController. This class contains unit tests to validate the functionality
 * of the InstituteTranscriptUserController, including searching for institutes, saving roles, and handling various edge cases.
 */
@isTest
private class InstituteTranscriptUserControllerTest {
    
    public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Address__c address {get; set;}
    public static IB_Country_Segmentation__c country1 {get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3 {get; set;}
    public static IB_Role__c ibRole4 {get; set;}
    public static Contact_information__c ci {get; set;}
    public static Contact_information__c ci2 {get; set;}
    public static User u;
    
    /** @description Sets up test data for all test methods in this class */
    @testSetup
    public static void testdata() {
        
        User currentUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User' LIMIT 1];
        
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = currentUser.Id,
            PermissionSetId = ps.Id
        );
        insert psa; 
        
        System.runAs(currentUser) {
            
            List<IB_Role_Repository__c> roleRepositories = new List<IB_Role_Repository__c>();
            
            IB_Role_Repository__c repo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            repo.Role_Name__c = 'Institute Administrator';
            roleRepositories.add(repo);
            
            IB_Role_Repository__c repo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            repo2.Role_Name__c = 'Institute Transcript User';
            roleRepositories.add(repo2);
            
            IB_Role_Repository__c ibecCertRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            ibecCertRole.Role_Name__c = 'IBEC Certificate Holder';
            roleRepositories.add(ibecCertRole);
            
            IB_Role_Repository__c ibecAdminRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            ibecAdminRole.Role_Name__c = 'IBEC University Administrator';
            roleRepositories.add(ibecAdminRole);
            
            IB_Role_Repository__c policyUserRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            policyUserRole.Role_Name__c = 'Institute Policy User';
            roleRepositories.add(policyUserRole);
            
            IB_Role_Repository__c facultyMemberRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            facultyMemberRole.Role_Name__c = 'IBEC Faculty Member';
            roleRepositories.add(facultyMemberRole);
            
            IB_Role_Repository__c candidateRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            candidateRole.Role_Name__c = 'IBEC Candidate';
            roleRepositories.add(candidateRole);
            
            IB_Role_Repository__c communicationUserRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            communicationUserRole.Role_Name__c = 'Communication User';
            roleRepositories.add(communicationUserRole);
            
            IB_Role_Repository__c associationUserRole = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
            associationUserRole.Role_Name__c = 'Association User';
            roleRepositories.add(associationUserRole);
            
            insert roleRepositories;
            
            Account accOne = new Account(
                Name = 'Test',
                ibis_id__c = 'N050234',
                IBEC_University_Flag__c = true
            );
            List<Account> accounts = AccountTestDataFactory.createAccounts('IB Institute', accOne, 1);
            insert accounts;
            accounts[0].IsPartner = true;
            update accounts[0];
            Account acc = accounts[0];
            
            Contact conTemplate = new Contact(
                FirstName = 'Test',
                LastName = 'Contact',
                Email = 'a@a.com',
                Birthdate = Date.newInstance(1980, 1, 1),
                AccountId = acc.Id
            );
            List<Contact> contacts = ContactTestDataFactory.createContacts(null, conTemplate, 1);
            insert contacts;
            Contact con = contacts[0];
            
            country1 = TestsUtil.createCountry('ABC', 'IBAEM', acc);
            insert country1;
            
            List<IB_Address__c> addresses = new List<IB_Address__c>();
            IB_Address__c address = new IB_Address__c(
                Name = 'Testing Address',
                Status__c = 'Active',
                Address_Line_1__c = 'Bahria Town',
                City__c = 'Lahore',
                Postal_Code__c = '2021',
                Country__c = country1.Id,
                IB_Account__c = acc.Id
            );
            addresses.add(address);
            insert addresses;
            
            List<Contact_information__c> contactInfos = new List<Contact_information__c>();
            
            Contact_information__c ci = new Contact_information__c(
                RecordTypeId = Schema.SObjectType.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId(),
                Name = 'Ck',
                Email__c = 'test@abc.com',
                Job__c = 'Job',
                RoleId__c = String.valueOf(repo.Id),
                IB_Contact__c = con.Id
            );
            contactInfos.add(ci);
            
            Contact_information__c ci2 = new Contact_information__c(
                RecordTypeId = Schema.SObjectType.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),
                Name = 'Ck',
                Phone__c = '+923070989740',
                Job__c = 'Job',
                RoleId__c = String.valueOf(repo.Id),
                IB_Contact__c = con.Id
            );
            contactInfos.add(ci2);
            
            insert contactInfos;
            
            List<IB_Role__c> ibRoles = new List<IB_Role__c>();
            
            IB_Role__c ibRoleTemplate1 = new IB_Role__c(
                IB_Role__c = repo2.Id,
                IB_Contact__c = con.Id,
                Status__c = 'Applicant',
                IB_Account__c = acc.Id,
                Role_Level__c = 'Fully Qualified',
                Contact_Information_Phone__c = ci2.Id,
                Contact_Information_Email__c = ci.Id,
                Job_Title__c = ci2.Job__c
            );
            ibRoles.add(IBRoleTestDataFactory.createRole(ibRoleTemplate1));
            
            IB_Role__c ibRoleTemplate2 = new IB_Role__c(
                IB_Role__c = repo.Id,
                IB_Contact__c = con.Id,
                Status__c = 'Confirmed',
                IB_Account__c = acc.Id,
                Role_Level__c = 'Fully Qualified',
                Email_Confirmed__c = true,
                Contact_Information_Phone__c = ci2.Id,
                Contact_Information_Email__c = ci.Id,
                Job_Title__c = ci.Job__c
            );
            ibRoles.add(IBRoleTestDataFactory.createRole(ibRoleTemplate2));
            
            IB_Role__c ibRoleTemplate3 = new IB_Role__c(
                IB_Role__c = repo2.Id,
                IB_Contact__c = con.Id,
                Status__c = 'Confirmed',
                IB_Account__c = acc.Id,
                Role_Level__c = 'Fully Qualified',
                Email_Confirmed__c = true,
                Contact_Information_Phone__c = ci2.Id,
                Contact_Information_Email__c = ci.Id,
                Job_Title__c = ci2.Job__c
            );
            ibRoles.add(IBRoleTestDataFactory.createRole(ibRoleTemplate3));
            
            IB_Role__c ibRoleTemplate4 = new IB_Role__c(
                IB_Role__c = repo.Id,
                IB_Contact__c = con.Id,
                Status__c = 'Applicant',
                IB_Account__c = acc.Id,
                Role_Level__c = 'Fully Qualified',
                Email_Confirmed__c = true,
                Contact_Information_Phone__c = ci2.Id,
                Contact_Information_Email__c = ci.Id,
                Job_Title__c = ci2.Job__c
            );
            ibRoles.add(IBRoleTestDataFactory.createRole(ibRoleTemplate4));
            
            IB_Role__c ibRoleTemplate5 = new IB_Role__c(
                IB_Role__c = ibecAdminRole.Id,
                IB_Contact__c = con.Id,
                Status__c = 'Confirmed',
                IB_Account__c = acc.Id,
                Role_Level__c = 'Fully Qualified',
                Email_Confirmed__c = true,
                Contact_Information_Phone__c = ci2.Id,
                Contact_Information_Email__c = ci.Id,
                Job_Title__c = ci.Job__c
            );
            ibRoles.add(IBRoleTestDataFactory.createRole(ibRoleTemplate5));
            
            insert ibRoles;
            
            ibRole1 = ibRoles[0];
            ibRole2 = ibRoles[1];
            ibRole3 = ibRoles[2];
            ibRole4 = ibRoles[3];
            ibRole2 = ibRoles[4]; 
        }
    }
    
    /** @description Tests the constructor with a StandardController */
    @isTest
    static void testConstructorWithStdController() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact_Information__c conInfo = [SELECT Id FROM Contact_Information__c LIMIT 1];
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(conInfo);
        ApexPages.currentPage().getParameters().put('AccountId', acc.Id);
        ApexPages.currentPage().getParameters().put('errorId', '404'); // Test error message
        
        Test.startTest();
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController(stdCtrl);
        Test.stopTest();
        
        System.assertNotEquals(null, ctrl.accountNam, 'Account should be populated');
        System.assertEquals(true, ctrl.displayinnerPopup, 'Inner popup should be true');
        System.assertEquals(1, ApexPages.getMessages().size(), 'Error message should be added');
    }
    
    /** @description Tests the SearchInfo method with institute-specific criteria */
    @isTest
    static void testSearchInfoInst() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.AccountName = 'Test';
        ctrl.IBISCode = 'N050234'; 
        ctrl.selectedCountry = 'ABC';
        ctrl.selectedState = null;
        ctrl.roleName = 'Institute Transcript User';
        
        Test.startTest();
        ctrl.SearchInfo();
        Test.stopTest();
        
        System.assertEquals(true, ctrl.renderTrue, 'Render should be true');
        System.assertNotEquals(0, ctrl.wrapAccountList.size(), 'Accounts should be found');
    }
    
    /** @description Tests the saveResult method when no admin role exists across various scenarios */
    @isTest
    static void testSaveResultNoAdminRoleAllScenarios() {
        
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = 'Test' AND IBIS_ID__c = 'N050234' LIMIT 1];
        Account testAccount = !accounts.isEmpty() ? accounts[0] : null;
        System.assertNotEquals(null, testAccount, 'Test account should exist from setup');
        
        List<IB_Role_Repository__c> roleRepos = [SELECT Id, Role_Name__c 
                                                 FROM IB_Role_Repository__c 
                                                 WHERE Role_Name__c IN ('Institute Transcript User', 'Institute Policy User', 
                                                                        'IBEC Faculty Member', 'IBEC Candidate', 
                                                                        'Communication User', 'Association User')];
        System.assert(!roleRepos.isEmpty(), 'At least one role repository should exist');
        Map<String, Id> roleNameToIdMap = new Map<String, Id>();
        for (IB_Role_Repository__c repo : roleRepos) {
            roleNameToIdMap.put(repo.Role_Name__c, repo.Id);
        }
        System.assertEquals(6, roleNameToIdMap.size(), 'All six roles should be present');
        
        List<IB_Role__c> existingAdminRoles = [SELECT Id 
                                               FROM IB_Role__c 
                                               WHERE IB_Account__c = :testAccount.Id 
                                               AND (IB_Role_Name__c = 'Institute Administrator' 
                                                    OR IB_Role_Name__c = 'IBEC University Administrator' 
                                                    OR IB_Role_Name__c = 'Association Admin') 
                                               AND Status__c = 'Confirmed'];
        if (!existingAdminRoles.isEmpty()) {
            delete existingAdminRoles;
        }
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
            new InstituteTranscriptUserController.wrapAccount(new Account(Id = testAccount.Id))
                };
                    ctrl.wrapAccountList[0].selected = true; 
        
        Test.startTest();

        for (String roleName : new List<String>{'Institute Transcript User', 'Institute Policy User', 
            'IBEC Faculty Member', 'IBEC Candidate', 
            'Communication User', 'Association User'}) {
                System.assert(roleNameToIdMap.containsKey(roleName), 'Role ' + roleName + ' should exist in map');
                ApexPages.currentPage().getParameters().put('roleId', roleNameToIdMap.get(roleName));
                ctrl.currentRole = new IB_Role_Repository__c(Role_Name__c = roleName, Id = roleNameToIdMap.get(roleName));
                
                PageReference result = ctrl.saveResult();
                
                String expectedMessage = '';
                if (roleName == 'Institute Transcript User' || roleName == 'Institute Policy User') {
                    expectedMessage = ' ' + System.Label.Confirmed_Institute_Admin_Not_Exist;
                } else if (roleName == 'IBEC Faculty Member' || roleName == 'IBEC Candidate') {
                    expectedMessage = ' ' + System.Label.IBEN_RoleApplication_IBEC_Admin_does_not_exist;
                } else if (roleName == 'Communication User' || roleName == 'Association User') {
                    expectedMessage = ' ' + System.Label.Confirmed_Institute_Admin_Not_Exist_Community_User;
                }
                
                ApexPages.getMessages().clear();
            }
        Test.stopTest();
    }
    
    /** @description Tests the SearchInfo method with only country specified */
    @isTest
    static void testSearchInfoInstOnlyCountry() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.AccountName = '';
        ctrl.IBISCode = '';
        ctrl.selectedCountry = 'ABC';
        ctrl.selectedState = '--None--';
        ctrl.roleName = 'Institute Transcript User';
        
        Test.startTest();
        ctrl.SearchInfo();
        Test.stopTest();
        
        System.assertEquals(true, ctrl.renderTrue, 'Render should be true');
    }
    
    /** @description Tests the SearchInfo method with IBEC-specific criteria */
    @isTest
    static void testSearchInfoIbec() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.AccountName = 'Test';
        ctrl.IBISCode = 'N050234';
        ctrl.selectedCountry = 'ABC';
        ctrl.selectedState = null;
        ctrl.roleName = 'IBEC Certificate Holder'; // Test IBEC role
        
        Test.startTest();
        ctrl.SearchInfo();
        Test.stopTest();
        
        System.assertEquals(true, ctrl.renderTrue, 'Render should be true');
        System.assertNotEquals(0, ctrl.wrapAccountList.size(), 'Accounts should be found for IBEC role');
    }
    
    /** @description Tests the SearchInfo method with association-specific criteria */
    @isTest
    static void testSearchInfoAssociation() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.AccountName = 'Test';
        ctrl.roleName = 'Association Admin';
        
        Test.startTest();
        ctrl.SearchInfo();
        Test.stopTest();
        
        System.assertEquals(true, ctrl.renderTrue, 'Render should be true');
    }
    
    /** @description Tests the SearchInfo method with association role and no name */
    @isTest
    static void testSearchInfoAssociationNoName() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.AccountName = '';
        ctrl.roleName = 'Association User';
        
        Test.startTest();
        ctrl.SearchInfo();
        Test.stopTest();
        
        System.assertEquals(true, ctrl.renderTrue, 'Render should be true');
        System.assertEquals(0, ctrl.wrapAccountList.size(), 'No accounts should be found');
        System.assertEquals(1, ApexPages.getMessages().size(), 'Warning message should be added');
    }
    
    /** @description Tests the saveResult method with a valid selection */
    @isTest
    static void testSaveResult() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
        ApexPages.currentPage().getParameters().put('roleId', role.Id);
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
            new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id))
                };
                    ctrl.wrapAccountList[0].selected = true;
        
        Test.startTest();
        PageReference result = ctrl.saveResult();
        Test.stopTest();
    }
    
    /** @description Tests the saveResult method with an inactive institute */
    @isTest
    static void testSaveResultInactiveInstitute() {
        
        User testUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        System.runAs(testUser) {
            Account acc = [SELECT Id FROM Account LIMIT 1];
            update new Account(
                Id = acc.Id, 
                Active__c = 'Inactive', 
                Inactive_Notes__c = 'test', 
                Alternate_Transcript_Institute__c = 'Contact Institute Directly'
            ); 
            
            IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
            ApexPages.currentPage().getParameters().put('roleId', role.Id);
            
            InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
            ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
                new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id))
                    };
                        ctrl.wrapAccountList[0].selected = true;
            
            Test.startTest();
            PageReference result = ctrl.saveResult();
            Test.stopTest();
            
            System.assertEquals(null, result, 'Should return null for inactive institute');
            System.assertEquals(1, ApexPages.getMessages().size(), 'Error message should be added');
        }
    }
    
    /** @description Tests the saveResult method with multiple selections */
    @isTest
    static void testSaveResultMultipleSelections() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
        ApexPages.currentPage().getParameters().put('roleId', role.Id);
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
            new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id)),
                new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id))
                };
                    ctrl.wrapAccountList[0].selected = true;
        ctrl.wrapAccountList[1].selected = true;
        
        Test.startTest();
        PageReference result = ctrl.saveResult();
        Test.stopTest();
        
        System.assertEquals(null, result, 'Should return null for multiple selections');
        System.assertEquals(1, ApexPages.getMessages().size(), 'Warning message should be added');
    }
    
    /** @description Tests the getCountryNames method */
    @isTest
    static void testGetCountryNames() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        
        Test.startTest();
        List<SelectOption> countries = ctrl.getCountryNames();
        Test.stopTest();
        
        System.assertNotEquals(0, countries.size(), 'Country list should not be empty');
        System.assertEquals('--None--', countries[0].getValue(), 'First option should be None');
    }
    
    /** @description Tests the getCountryState method */
    @isTest
    static void testGetCountryState() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.selectedCountry = 'ABC';
        
        Test.startTest();
        List<SelectOption> states = ctrl.getCountryState();
        Test.stopTest();
    }
    
    /** @description Tests the lookupInstituteSearchName method */
    @isTest
    static void testLookupInstituteSearchName() {
        
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c LIMIT 1];
        
        Test.startTest();
        List<String> names = InstituteTranscriptUserController.lookupInstituteSearchName('Test', role.Id);
        Test.stopTest();
        
        System.assertEquals(1, names.size(), 'Should find one matching name');
    }
    
    /** @description Tests popup-related methods */
    @isTest
    static void testPopupMethods() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        
        Test.startTest();
        ctrl.showPopup();
        System.assertEquals(true, ctrl.displayPopup, 'Popup should be shown');
        
        ctrl.closePopup();
        System.assertEquals(false, ctrl.displayPopup, 'Popup should be closed');
        
        ctrl.showinnerpopup();
        System.assertEquals(true, ctrl.displayinnerPopup, 'Inner popup should be shown');
        
        ctrl.closeinnerpopup();
        System.assertEquals(false, ctrl.displayinnerPopup, 'Inner popup should be closed');
        Test.stopTest();
    }
    
    /** @description Tests the cancelSearch method */
    @isTest
    static void testCancelSearch() {
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        
        Test.startTest();
        PageReference result = ctrl.cancelSearch();
        Test.stopTest();
        
        System.assertEquals('/ibportal/MyIBRoles', result.getUrl(), 'Should redirect to MyIBRoles');
    }
    
    /** @description Tests the no-argument constructor */
    @isTest
    static void testNoArgConstructor() {
        
        ApexPages.currentPage().getParameters().put('errorId', '404CON');
        
        Test.startTest();
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        Test.stopTest();
        
        System.assertNotEquals(null, ctrl.conInfo, 'Contact info should be initialized');
        System.assertEquals(false, ctrl.renderTrue, 'renderTrue should be false by default');
    }
    
    /** @description Tests the saveResult method with a duplicate role */
    @isTest
    static void testSaveResultDuplicateRole() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
        ApexPages.currentPage().getParameters().put('roleId', role.Id);
        
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
            new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id))
                };
                    ctrl.wrapAccountList[0].selected = true;
        ctrl.rolesList = new List<IB_Role__c>{new IB_Role__c(IB_Account__c = acc.Id, Status__c = 'Applicant')};
            
            Test.startTest();
        PageReference result = ctrl.saveResult();
        Test.stopTest();
        
        System.assertEquals(null, result, 'Should return null due to duplicate role');
        System.assertEquals(1, ApexPages.getMessages().size(), 'Error message should be added');
    }
    
    /** @description Tests the lookupSchoolAccountByNameMulti method */
    @isTest
    static void testLookupSchoolAccountByNameMulti() {
        
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
        
        Test.startTest();
        List<String> accounts = InstituteTranscriptUserController.lookupSchoolAccountByNameMulti('Test:N050234', role.Id);
        Test.stopTest();
    }
    
    /** @description Tests the lookupSchoolAccountByNameMulti method with IBEC role */
    @isTest
    static void testLookupSchoolAccountByNameMultiIBEC() {
        
        IB_Role_Repository__c role = [SELECT Id FROM IB_Role_Repository__c WHERE Role_Name__c = 'Institute Transcript User' LIMIT 1];
        
        Test.startTest();
        List<String> accounts = InstituteTranscriptUserController.lookupSchoolAccountByNameMulti('Test:N050234', role.Id);
        Test.stopTest();
    }
    
    /** @description Tests the isLoggedIn method for a guest user scenario */
    @isTest
    static void testIsLoggedInGuest() {
        
        Test.startTest();
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        PageReference result = ctrl.isLoggedIn();
        Test.stopTest();
        
        System.assertEquals(null, result, 'Should return null for logged-in user');
    }
    
    /** @description Tests the getLocale method */
    @isTest
    static void testGetLocale() {
        
        Test.startTest();
        InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
        String locale = ctrl.getLocale();
        Test.stopTest();
        
        System.assertEquals(UserInfo.getLanguage(), locale, 'Locale should match user language');
    }
    
    /** @description Tests the saveResult method with an IBEC role redirect */
    @isTest
    static void testSaveResultIBECRoleRedirect() {
        
        User testUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        
        System.runAs(testUser) {
            
            Account acc = [SELECT Id FROM Account LIMIT 1];
            List<IB_Role_Repository__c> roles = [SELECT Id, Role_Name__c FROM IB_Role_Repository__c WHERE Role_Name__c IN ('IBEC Certificate Holder', 'IBEC University Administrator')];
            IB_Role_Repository__c ibecRole = (roles.size() > 0 && roles[0].Role_Name__c == 'IBEC Certificate Holder') ? roles[0] : null;
            IB_Role_Repository__c adminRole = (roles.size() > 1 && roles[1].Role_Name__c == 'IBEC University Administrator') ? roles[1] : null;
            
            if (ibecRole == null || adminRole == null) {
                System.assert(false, 'Test setup failed to create required IBEC roles');
                return;
            }
            
            ApexPages.currentPage().getParameters().put('roleId', ibecRole.Id);
            InstituteTranscriptUserController ctrl = new InstituteTranscriptUserController();
            
            ctrl.wrapAccountList = new List<InstituteTranscriptUserController.wrapAccount>{
                new InstituteTranscriptUserController.wrapAccount(new Account(Id = acc.Id))
                    };
                        ctrl.wrapAccountList[0].selected = true;
            
            ctrl.rolesList = new List<IB_Role__c>(); 
            
            Test.startTest();
            PageReference result = ctrl.saveResult();
            Test.stopTest();
            
            System.assertNotEquals(null, result, 'Page reference should be returned');
            System.assertEquals('/apex/IBECApplyForRole', result.getUrl().substring(0, 22), 'Should redirect to IBECApplyForRole');
            System.assertEquals(acc.Id, result.getParameters().get('AccountId'), 'AccountId should be in URL parameters');
        }
    }
}