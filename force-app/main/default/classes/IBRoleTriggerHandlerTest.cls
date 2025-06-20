@isTest
public class IBRoleTriggerHandlerTest {
    
   @isTest
    public static void testEditRoleApplication() {
        
        Account account = new Account();
        account.Region__c = 'IBA';
        account = AccountTestDataFactory.createAccount(null,account);
                insert account;
            
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = account.Id;
            
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
            
        Contact contact = new Contact();
        contact = ContactTestDataFactory.createContact(null, contact);
        contact.Country__c = ibCon.Id;
        insert contact;
            
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', account.Id);
        Insert opp;
            
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
                     
        Campaign camp = TestsUtil.createCampaign('camp test name 1', account.Id, opp.Id, recordTypeId);
        Insert camp;
            
        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
        roleRepo.Role_Name__c = 'Programme Coordinator';
        roleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo);
        roleRepo.Prevent_Duplicates__c = true;
        roleRepo.SF_Role_Application__c = true;
        roleRepo.Related_Programmes__c = 'PYP';
        insert roleRepo;
            
        IB_Role_Repository__c roleRepo2 = new IB_Role_Repository__c();
        roleRepo2.Role_Name__c = 'Administrator';
        roleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo2);
        roleRepo2.Prevent_Duplicates__c = true;
        roleRepo2.SF_Role_Application__c = true;
        roleRepo2.Related_Programmes__c = 'PYP';
        insert roleRepo2;
            
        IB_Role__c oldRole = new IB_Role__c(
            IB_Contact__c = contact.Id,
            IB_Role__c = roleRepo.Id,
            Programme_Selection__c = 'PYP',
            Active__c = true
        );
        insert oldRole;
            
        IB_Role__c newRole = oldRole.clone(false, true, true, true);
        newRole.IB_Role__c = roleRepo2.Id;
        newRole.Programme_Selection__c = 'PYP';
        insert newRole; 
            
        Map<Id, IB_Role__c> oldMap = new Map<Id, IB_Role__c>{ oldRole.Id => oldRole };
        Map<Id, IB_Role__c> newMap = new Map<Id, IB_Role__c>{ oldRole.Id => newRole };
 
            
        camp.IB_Role__c = roleRepo.Id;
        camp.IB_Programme__c = roleRepo.Related_Programmes__c;
        camp.Status = 'Staffed';
        update camp;
            
        Training_Event__c trEvent = TestsUtil.createTrainingEvent('test_name000', roleRepo.Id, camp.Id);
        insert trEvent;
            
        Contact contactvar = [SELECT id,IBEN_Region__c FROM contact where id=: contact.Id LIMIT 1];
        Training_Event__c trEventvar = [SELECT id,Training_Event_Region__c,IB_Programme__c FROM Training_Event__c where id=:trEvent.Id LIMIT 1];
            
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', contactvar.Id, trEventvar.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        myTrainingEvent.IB_Role__c = roleRepo.Id;
        insert myTrainingEvent;
            
            
            Test.startTest();
        try {
            // Call the method under test
            IBRoleTriggerHandler handler = new IBRoleTriggerHandler();
            handler.editRoleApplication(newMap, oldMap);
        } catch (DmlException ex) {
            System.assert(ex.getMessage().contains('Edit_Role_Application_Failure'), 'Expected error message not found.');
        }
        Test.stopTest();
            
    }
            
    @isTest
    public static void testUnregisterRoleApplication() {
            
        Account account = new Account();
        account.Region__c = 'IBA';
        account = AccountTestDataFactory.createAccount(null,account);
        insert account;
            
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = account.Id;
            
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
            
        Contact contact = new Contact();
        contact = ContactTestDataFactory.createContact(null, contact);
        contact.Country__c = ibCon.Id;
        insert contact;
            
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', account.Id);
        Insert opp;
            
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
            
        Campaign camp = TestsUtil.createCampaign('camp test name 1', account.Id, opp.Id, recordTypeId);
        Insert camp;
            
        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
        roleRepo.Role_Name__c = 'Programme Coordinator';
        roleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo);
        roleRepo.Prevent_Duplicates__c = true;
        roleRepo.SF_Role_Application__c = true;
        roleRepo.Related_Programmes__c = 'PYP';
        insert roleRepo;
            
        IB_Role__c oldRole = new IB_Role__c(
            IB_Contact__c = contact.Id,
            IB_Role__c = roleRepo.Id,
            Programme_Selection__c = 'PYP',
            Status__c = 'Applicant',
            Unregistered__c = false,
            Active__c = true
        );
        insert oldRole;
            
        IB_Role__c newRole = oldRole.clone(false, true, true, true);
        newRole.Id = oldRole.Id;
        newRole.Unregistered__c = true; // Mark as unregistered
        upsert newRole;
            
        Map<Id, IB_Role__c> oldMap = new Map<Id, IB_Role__c>{ oldRole.Id => oldRole };
        Map<Id, IB_Role__c> newMap = new Map<Id, IB_Role__c>{ oldRole.Id => newRole };
            
        camp.IB_Role__c = roleRepo.Id;
        camp.IB_Programme__c = roleRepo.Related_Programmes__c;
        camp.Status = 'Staffed';
        update camp;
            
        Training_Event__c trEvent = TestsUtil.createTrainingEvent('test_name000', roleRepo.Id, camp.Id);
        insert trEvent;
            
        Contact contactvar = [SELECT id,IBEN_Region__c FROM contact where id=: contact.Id LIMIT 1];
        Training_Event__c trEventvar = [SELECT id,Training_Event_Region__c,IB_Programme__c FROM Training_Event__c where id=:trEvent.Id LIMIT 1];
            
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', contactvar.Id, trEventvar.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        myTrainingEvent.IB_Role__c = roleRepo.Id;
        insert myTrainingEvent;
            
        Test.startTest();
        IBRoleTriggerHandler handler = new IBRoleTriggerHandler();
        handler.unregisterRoleApplication(newMap, oldMap);
            Test.stopTest();
        }
        
    @isTest
    public static void testCountOnlineProviderRole() {
        
        Account account = new Account();
        account.Region__c = 'IBA';
        account = AccountTestDataFactory.createAccount(null,account);
        insert account;
        
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = account.Id;
        
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
        
        Contact contact = new Contact();
        contact = ContactTestDataFactory.createContact(null, contact);
        contact.Country__c = ibCon.Id;
        insert contact;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = account.Id;
        ibAdd.Country__c = ibCon.id;
        
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        IB_Programme__c ibProg = new IB_Programme__c();
        ibProg.Account__c = account.Id;
        ibProg.Street_Address__c = address.id;
        ibProg.Owner__c = UserInfo.getUserId();
        
        IB_Programme__c authorizedprogramme = IBProgrammeTestDataFactory.createIBProgramme('PYP', ibProg);
        authorizedprogramme.StageName__c = IboUtil.PROGRAMME_CONSULTATION_PROCESS_STAGENAME;
        authorizedprogramme.Status__c = IboUtil.PROGRAMME_AUTHORIZED_STATUS;
        insert authorizedprogramme;
        
        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
        roleRepo.Role_Name__c = 'Online Admin Assistant';
        roleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo);
        roleRepo.Prevent_Duplicates__c = true;
        roleRepo.SF_Role_Application__c = true;
        roleRepo.Related_Programmes__c = 'PYP';
        insert roleRepo;
        
        IB_Role_Repository__c roleRepo2 = new IB_Role_Repository__c();
        roleRepo2.Role_Name__c = 'Billing Contact';
        roleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo2);
        roleRepo2.Prevent_Duplicates__c = true;
        roleRepo2.SF_Role_Application__c = true;
        roleRepo2.Related_Programmes__c = 'PYP';
        insert roleRepo2;
        
        IB_Role_Repository__c roleRepo3 = new IB_Role_Repository__c();
        roleRepo3.Role_Name__c = 'Online Coordinator';
        roleRepo3 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo3);
        roleRepo3.Prevent_Duplicates__c = true;
        roleRepo3.SF_Role_Application__c = true;
        roleRepo3.Related_Programmes__c = 'PYP';
        insert roleRepo3;
        
        IB_Role__c role1 = new IB_Role__c();
        role1.IB_Contact__c = contact.Id;
        role1.IB_Account__c = account.Id;
        role1.IB_Role__c = roleRepo.Id;
        role1.IB_Programme_New__c = authorizedprogramme.Id;
        role1.Status__c ='Confirmed';
        role1.Programme_Selection__c = 'PYP';
        insert role1;
        
        List<IB_Role__c> rolesToInsert = new List<IB_Role__c>();
        
        IB_Role__c role2 = role1.clone(false, true, true, true);
        role2.IB_Role__c = roleRepo2.Id;
        role2.Status__c ='Confirmed';
        role2.Programme_Selection__c = 'PYP';
        rolesToInsert.add(role2);
        
        IB_Role__c role3 = role1.clone(false, true, true, true);
        role3.IB_Role__c = roleRepo3.Id;
        role3.Status__c ='Confirmed';
        role3.Programme_Selection__c = 'PYP';
        rolesToInsert.add(role3);
        
        insert rolesToInsert;
        
        Map<Id, IB_Role__c> oldMap = new Map<Id, IB_Role__c>{ role1.Id => role1 };
            
        Test.startTest();
        
        List<IB_Role__c> roleList = new List<IB_Role__c>();
        roleList.add(role1);
        roleList.add(role2);
        
        Set<Id> accountIdSet = new  Set<Id>();
        accountIdSet.add(account.Id);
        IBRoleTriggerHandler handler = new IBRoleTriggerHandler();
        handler.countonlineProviderRole(roleList, accountIdSet, oldMap);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testCreateRefereeFeedbacks(){
        
        Account account = new Account();
        account = AccountTestDataFactory.createAccount(null,account);
        insert account;
        
        Contact contact = new Contact();
        contact = ContactTestDataFactory.createContact(null, contact);
        insert contact;
        
        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
        roleRepo.Role_Name__c = 'Programme Coordinator';
        roleRepo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo);
        roleRepo.Prevent_Duplicates__c = true;
        insert roleRepo;
        
        IB_Role_Repository__c roleRepo2 = new IB_Role_Repository__c();
        roleRepo2.Role_Name__c = 'Evaluation Leader';
        roleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo2);
        roleRepo2.Prevent_Duplicates__c = true;
        insert roleRepo2;
        
        Test.startTest();
        
        IB_Role__c role = new IB_Role__c();
        role.IB_Contact__c = contact.id;
        role.IB_Role__c = roleRepo.Id;
        role.IB_Account__c = account.Id;
        role.Status__c='Confirmed';
        role.Active__c = true;
        role.Programme_Selection__c='PYP;MYP;DP;IBCC';
        role.Title__c = 'Mr.';
        role.Referee_1_First_Name__c = 'test';
        role.Referee_1_Last_Name__c = 'ref 1';
        role.Referee_1_Email__c = 'testref1@iben.com';
        role.First_Referee_Professional_Relationship__c = 'test'; 
        role.Referee_2_Title__c = 'Mr.';
        role.Referee_2_First_Name__c = 'test';
        role.Referee_2_Last_Name__c = 'ref 2';
        role.Referee_2_Email__c = 'testref2@iben.com';
        role.Second_Referee_Professional_Relationship__c = 'test';
        insert role;
        
        IB_Role__c role2 = new IB_Role__c();
        role2.IB_Contact__c = contact.id;
        role2.IB_Role__c = roleRepo2.Id;
        role2.IB_Account__c = account.Id;
        role2.Status__c='Confirmed';
        role2.Active__c = true;
        role2.Programme_Selection__c='PYP;MYP;DP;IBCC';
        role2.Title__c = 'Mr.';
        role2.Referee_1_First_Name__c = 'test';
        role2.Referee_1_Last_Name__c = 'ref 1';
        role2.Referee_1_Email__c = 'testref1@iben.com';
        role2.First_Referee_Professional_Relationship__c = 'test'; 
        role2.Referee_2_Title__c = 'Mr.';
        role2.Referee_2_First_Name__c = 'test';
        role2.Referee_2_Last_Name__c = 'ref 2';
        role2.Referee_2_Email__c = 'testref2@iben.com';
        role2.Second_Referee_Professional_Relationship__c = 'test';
        insert role2;
        
                    List<IB_Role__c> roles = new List<IB_Role__c>();
                    roles.add(role);
        roles.add(role2);
                    new IBRoleTriggerHandler().handleMyProfileInfo(roles);
        list<IB_Referee_Feedback__c> result = [select id from IB_Referee_Feedback__c where My_Role__c =: role.Id and Status__c = 'Pending'];//Pending value has been change to mee the criteria
        
        role.Referee_2_First_Name__c='test2';
        update role;
        
        Test.stopTest();
    }
    
}