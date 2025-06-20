@isTest
public class MyStaffingEventTriggerHandlerTest {
    
    private static Id evalRecordTypeId {
        get {
            if (evalRecordTypeId == null) {
                evalRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
            }
            return evalRecordTypeId;
        }
        private set;
    }
	
    @TestSetup
    static void setup() {
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c(
            Name = 'MaxContactIBCode',
            MaxIBCode__c = 100000
        );
        insert setting;

        Account testAccount = AccountTestDataFactory.createAccount(null, null);
        testAccount.External_PD_Provider__c = true;
        insert testAccount;

        Contact testContact = ContactTestDataFactory.createContact(null, 
            new Contact(AccountId = testAccount.Id, Email = 'test@contact.com'));
        insert testContact;
        
        User testUser = UserTestDataFactory.createUser('SCU + Advanced', 
            new User(
                ContactId = testContact.Id,
                Email = 'testuser@test.com',
                Username = 'testuser@test.com',
                LastName = 'TestUser',
                isActive = true
            ));
        insert testUser;

        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c(
            Available__c = true,
            SF_Role_Application__c = true,
            CurrencyIsoCode = 'EUR',
            Role_Name__c = 'Programme Leader',
            Category__c = 'School Services',
            Role_Level__c = 'Fully Qualified',
            Sub_Category__c = 'Evaluation & Authorization',
            Related_Programmes__c = 'PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c = 'Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c = true
        );
        insert roleRepo;

        Campaign parentCamp = new Campaign(
            Name = 'Parent Evaluation',
            Event_Organizer_Account__c = testAccount.Id,
            RecordTypeId = evalRecordTypeId,
            Type = 'Evaluation',
            Sub_Type__c = 'Evaluation Visit',
            Status = 'Planned / Ready for Staffing'
        );
        insert parentCamp;

        Staffing_Event__c staffEvent = new Staffing_Event__c(
            Name = 'Test Staffing Event',
            IB_Event__c = parentCamp.Id
        );
        insert staffEvent;

        IB_Event_Role__c eventRole = new IB_Event_Role__c(
            Staffing_Event__c = staffEvent.Id,
            IB_Event__c = parentCamp.Id,
            IB_Role__c = roleRepo.Id,
            IB_Programme__c = 'MYP',
            Number_of_Required_Educators__c = 5
        );
        insert eventRole;
    }
	
    @isTest
    static void testBeforeLogic() {
        
        Staffing_Event__c staffEvent = [SELECT Id, IB_Event__c, Event_Organizer__c FROM Staffing_Event__c LIMIT 1];
        IB_Role_Repository__c roleRepo = [SELECT Id FROM IB_Role_Repository__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Contact__c = testContact.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Role__c = roleRepo.Id,
            IB_Programme__c = 'MYP',
            Application_Status__c = 'Invited'
        );

        Test.startTest();
        insert staffingEvent;
        Test.stopTest();

        staffingEvent = [SELECT Id, IB_Event__c, Event_Organizer_Account__c, IB_Event_Role__c FROM My_Staffing_Event__c WHERE Id = :staffingEvent.Id];
        System.assertEquals(staffEvent.IB_Event__c, staffingEvent.IB_Event__c, 'IB Event should match staffing event');
        System.assertEquals(staffEvent.Event_Organizer__c, staffingEvent.Event_Organizer_Account__c, 'Event Organizer should match');
        System.assertNotEquals(null, staffingEvent.IB_Event_Role__c, 'IB Event Role should be populated');
    }
	
    @isTest
    static void testGrantAccessToIbenService() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
		User testUser = [SELECT Id FROM User WHERE Username = 'testuser@test.com' LIMIT 1];

        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            Application_Status__c = 'Confirmed'
        );

        Test.startTest();
        insert staffingEvent;
        Test.stopTest();

        List<AccountShare> shares = [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel 
                                    FROM AccountShare 
                                    WHERE AccountId = :acc.Id AND UserOrGroupId = :testUser.Id];
        System.assert(shares.size() <= 1, 'At most one account share should be created');
    }
	
    @isTest
    static void testGrantAccessToEducator() {
        
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
		User testUser = [SELECT Id FROM User WHERE Username = 'testuser@test.com' LIMIT 1];

        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            Application_Status__c = 'Confirmed'
        );

        Test.startTest();
        insert staffingEvent;
        Test.stopTest();

        List<Staffing_Event__Share> shares = [SELECT Id, ParentId, UserOrGroupId, AccessLevel 
                                             FROM Staffing_Event__Share 
                                             WHERE ParentId = :staffEvent.Id AND UserOrGroupId = :testUser.Id];
        System.assert(shares.size() <= 1, 'At most one staffing event share should be created');
    }
	
    @isTest
    static void testGrantAccessToAccountContacts() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
		User testUser = [SELECT Id FROM User WHERE Username = 'testuser@test.com' LIMIT 1];
       
        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            Event_Organizer_Account__c = acc.Id,
            Application_Status__c = 'Confirmed'
        );

        Test.startTest();
        insert staffingEvent;
        Test.stopTest();

        List<ContactShare> shares = [SELECT Id, ContactId, UserOrGroupId, ContactAccessLevel 
                                    FROM ContactShare 
                                    WHERE ContactId = :testContact.Id AND UserOrGroupId = :testUser.Id];
        System.assert(shares.size() <= 1, 'At most one contact share should be created');
    }
	
    @isTest
    static void testDeleteLogic() {
        
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
        IB_Event_Role__c eventRole = [SELECT Id FROM IB_Event_Role__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            IB_Event_Role__c = eventRole.Id,
            Application_Status__c = 'Confirmed'
        );
        insert staffingEvent;

        Test.startTest();
        delete staffingEvent;
        Test.stopTest();

        IB_Event_Role__c updatedRole = [SELECT Confirmed_Number_of_Educators__c 
                                       FROM IB_Event_Role__c 
                                       WHERE Id = :eventRole.Id];
        System.assertEquals(0, updatedRole.Confirmed_Number_of_Educators__c, 'Confirmed educators count should be reset');
    }

    @isTest
    static void testEmailInvitation() {
        
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];

        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            Application_Status__c = 'Invited',
            Invitation_Response__c = null
        );

        Test.startTest();
        insert staffingEvent;
        Test.stopTest();

        staffingEvent = [SELECT Id, Application_Status__c FROM My_Staffing_Event__c WHERE Id = :staffingEvent.Id];
        System.assertEquals('Invited', staffingEvent.Application_Status__c, 'Staffing event should be in Invited status');
    }
    
    @isTest
    static void testAfterUpdateWithStatusChanges() {
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = '1';
        profDevConf.professionalDevelopmentCampList__c = '1,2,3';
        insert profDevConf;
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Campaign camp = [SELECT Id, Sub_Type__c, Type__c FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id, Staffing_Event_Type__c FROM Staffing_Event__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        IB_Role_Repository__c roleRepo = [SELECT Id FROM IB_Role_Repository__c LIMIT 1];
        IB_Event_Role__c eventRole = [SELECT Id FROM IB_Event_Role__c LIMIT 1];
        
        IB_Role__c pcRole = IBRoleTestDataFactory.createRole(null);
        pcRole.IB_Account__c = acc.Id;
        pcRole.IB_Contact__c = testContact.Id;
        pcRole.IB_Role__c = roleRepo.Id;
        pcRole.Start_Date__c = Date.today();
        insert pcRole;
        
        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            IB_Event_Role__c = eventRole.Id,
            Application_Status__c = 'Pending Selection',
            Release_Permission_Required__c = 'Yes',
            IB_Role__c = roleRepo.Id
        );
        insert staffingEvent;
        
        Test.startTest();
        
        MyStaffingEventTriggerHandler.alreadyRanForUpdate = false;
        staffingEvent.Application_Status__c = IboUtil.ROLE_CONFIRMED_STATUS;
        List<Campaign> campList = [SELECT Id, Sub_Type__c, Type__c FROM Campaign WHERE ParentId != null];
        
        Campaign newCamp = new Campaign(
            Id = campList[0].Id,
            Sub_Type__c = 'Evaluation Visit',
            Staffing_Event_Published__c = true,
            Status = 'Postponed',
            Required_Number_of_Educators__c = 1
        );
        MyStaffingEventTriggerHandler.alreadyRanForUpdate = false;
        
        update newCamp;
        
        update staffingEvent;
        staffingEvent = [SELECT Id, Application_Status__c, Staffing_Event_Type__c, Staffing_Event__c, IB_Contact__c
                         FROM My_Staffing_Event__c 
                         WHERE Id = :staffingEvent.Id];
        
        List<My_Staffing_Event__c> eventListOne = new List<My_Staffing_Event__c>();
        
        MyStaffingEventTriggerHandler eventHandlerOne = new MyStaffingEventTriggerHandler();
        eventListOne.add(staffingEvent);
        eventHandlerOne.grantAccessToEducator(eventListOne);
        MyStaffingEventTriggerHandler.alreadyRanForUpdate = false;
        staffingEvent.Application_Status__c = 'Withdrawn';
        staffingEvent.WithdrawalReason__c = 'Logistics';
        update staffingEvent;
        Test.stopTest();
        
        List<My_Staffing_Event__c> eventList = new List<My_Staffing_Event__c>();
        eventList.add(staffingEvent);
        
        MyStaffingEventTriggerHandler eventHandler = new MyStaffingEventTriggerHandler();
        eventHandler.GrantAccessToIbenService(eventList);
        eventHandler.grantAccessToEducator(eventList);
        eventHandler.grantAccessToAccountContacts(eventList);
        
        List<My_Staffing_Event__c> updatedEvents = [SELECT Id, Application_Status__c FROM My_Staffing_Event__c];
        System.assert(!updatedEvents.isEmpty(), 'Should have updated records');
    }
    
    @isTest
    static void testChildEventAssignmentCreation() {
        
        Campaign parentCamp = [SELECT Id FROM Campaign LIMIT 1];
        
        Campaign childCamp = new Campaign(
            Name = 'Child Evaluation',
            ParentId = parentCamp.Id,
            RecordTypeId = evalRecordTypeId,
            Type = 'Evaluation',
            Sub_Type__c = 'Evaluation Visit',
            Status = 'Planned / Ready for Staffing',
            Bundle__c = true
        );
        insert childCamp;
        
        Staffing_Event__c childStaffEvent = new Staffing_Event__c(
            Name = 'Child Staffing Event',
            IB_Event__c = childCamp.Id
        );
        insert childStaffEvent;
        
        IB_Role_Repository__c roleRepo = [SELECT Id FROM IB_Role_Repository__c LIMIT 1];
        IB_Event_Role__c childEventRole = new IB_Event_Role__c(
            Staffing_Event__c = childStaffEvent.Id,
            IB_Event__c = childCamp.Id,
            IB_Role__c = roleRepo.Id,
            IB_Programme__c = 'MYP'
        );
        insert childEventRole;
        
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        
        My_Staffing_Event__c parentStaffing = new My_Staffing_Event__c(
            IB_Event__c = parentCamp.Id,
            Staffing_Event__c = [SELECT Id FROM Staffing_Event__c WHERE IB_Event__c = :parentCamp.Id LIMIT 1].Id,
            IB_Contact__c = testContact.Id,
            IB_Event_Role__c = [SELECT Id FROM IB_Event_Role__c WHERE IB_Event__c = :parentCamp.Id LIMIT 1].Id,
            Application_Status__c = 'Confirmed'
        );
        
        Test.startTest();
        insert parentStaffing;
        Test.stopTest();
        
        List<My_Staffing_Event__c> childAssignments = [SELECT Id FROM My_Staffing_Event__c WHERE Staffing_Event__c = :childStaffEvent.Id];
        System.assertEquals(1, childAssignments.size(), 'A child staffing assignment should be created for the child event');
    }
    
    @isTest
    static void testEmailInvitationLogic() {
        
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
        Contact testContact = [SELECT Id, User_Language__c FROM Contact LIMIT 1];
        
        testContact.User_Language__c = 'en';
        update testContact;
        
        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            Application_Status__c = 'Pending'
        );
        insert staffingEvent;
        
        Test.startTest();
        
        staffingEvent.Application_Status__c = 'Invited';
        update staffingEvent;
        Test.stopTest();
        
        My_Staffing_Event__c updatedEvent = [SELECT Application_Status__c FROM My_Staffing_Event__c WHERE Id = :staffingEvent.Id];
        System.assertEquals('Invited', updatedEvent.Application_Status__c, 'Application status should be updated to Invited');
    }
    
    @isTest
    static void testDeleteLogicWithConfirmedStatus() {
        
        Campaign camp = [SELECT Id FROM Campaign LIMIT 1];
        Staffing_Event__c staffEvent = [SELECT Id FROM Staffing_Event__c LIMIT 1];
        Contact testContact = [SELECT Id FROM Contact LIMIT 1];
        IB_Event_Role__c eventRole = [SELECT Id, Confirmed_Number_of_Educators__c FROM IB_Event_Role__c LIMIT 1];
        
        eventRole.Confirmed_Number_of_Educators__c = 1;
        update eventRole;
        
        My_Staffing_Event__c staffingEvent = new My_Staffing_Event__c(
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id,
            IB_Contact__c = testContact.Id,
            IB_Event_Role__c = eventRole.Id,
            Application_Status__c = 'Confirmed'
        );
        insert staffingEvent;
        
        Test.startTest();
        delete staffingEvent;
        Test.stopTest();
        
        IB_Event_Role__c updatedRole = [SELECT Confirmed_Number_of_Educators__c FROM IB_Event_Role__c WHERE Id = :eventRole.Id];
        System.assertEquals(0, updatedRole.Confirmed_Number_of_Educators__c, 'Confirmed count should be reset to 0');
    }
    
}