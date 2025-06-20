@isTest

public with sharing class IBActivityTest {
    public static testMethod void testIconControllerTest() {
        TestsUtil init = new TestsUtil();
        TestsUtil.initMyStaffingEvents();
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
        List<IB_Role_Repository__c> roleRepo = TestsUtil.getRoleRepos();
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        List<Contact> contacts = TestsUtil.getContacts();
        List<IBActivity> activities = new List<IBActivity>();

        Training_Event__c trainingEvent = TestsUtil.createTrainingEvent('Foo', roleRepo[0].Id, campaigns[0].Id);
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent(Label.IBENPortal_shared_NotApplied, contacts[0].Id, trainingEvent.Id);
        
        List<My_Training_Event__c> myTrainingEventList = new List<My_Training_Event__c>();
        myTrainingEventList.add(myTrainingEvent);
        
        List<Training_Event__c> trainingEventList = new List<Training_Event__c>();
        
        
        trainingEventList.add(trainingEvent);

        IBActivity IBAa = new IBActivity();
        
        Case c= new Case();
        c.subject= 'test';
        Id RecordTypeIdCampaign2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SIPGE Request').getRecordTypeId();
        c.recordtypeId=RecordTypeIdCampaign2;
        insert c;

        Test.startTest();
            IBActivity IBA = new IBActivity();
            IBA.IBActivity();
            String testString = IBActivity.removeInvalidChars('test\test');
            IB_Event_Role__c eventRole = IBActivity.loadIBEventAssignmentReqs(myStaffingEvents[0].IB_Event__c);
            IBActivity.hasIBEventRequirements(eventRole);
            
            IBActivity.translateText('Test',IBA);
            List<IB_Role__c> rs = TestsUtil.getIbRoles();
            rs[0].Continuum__c = true;
            update rs;
            //List<IB_Role__c> rs = IBActivity.loadMyIBRoles(null, 'Confirmed');
            system.debug('RS: ' + rs);
            IBActivity.getRoleIds(rs);
            IBActivity.getReleasePermissionItems();
            IBActivity.getInterestLevelItems();
            IBActivity.getWithdrawalReasons();
            IBActivity.filterAssignmentsByProgramme(staffingEvents,rs);
            IBActivity.filterAssignmentsByProgrammeAndSubject(staffingEvents,rs);

            IBA.ListColor = 'X';
            IBA.IBContact = null;
            IBA.RoleName = 'Test';

IBActivity.convertCamapign(campaigns);
        IBActivity.publishedStaffingEvent(staffingEvents);
        IBActivity.convertCase(c);

            IBActivity assignmentAct = IBActivity.convertAssignment(myStaffingEvents[0]);
            IBActivity.convertEligAssignment(staffingEvents[0]);
            IBActivity.convertEligAssignmentDetails(staffingEvents[0]);
            IBActivity myTrainingAct = IBActivity.convertMyTraining(MytrainingEvent);
            IBActivity trainingAct = IBActivity.convertEligTraining(trainingEvent);
            IBActivity.addAssignmentsToActivities(activities, myStaffingEvents);
            
            List<IBActivity> testList = IBActivity.addEligAssignmentsToActivities(activities, staffingEvents);
            List<IBActivity> testList2 = IBActivity.addMyTrainingsToActivities(activities, myTrainingEventList);
            List<IBActivity> testList3 = IBActivity.addEligTrainingsToActivities(activities, trainingEventList);
            
            IBActivity.refineActivities(activities);
            IBActivity.refineEligibleAssignments(staffingEvents);
            IBActivity.sortIBActivities(activities);
            IBActivity.isAssignment(trainingAct);
            IBActivity.isAssignment(assignmentAct);
            
            IBActivity.isMyAssignment(assignmentAct);
            IBActivity.isMyAssignment(trainingAct);

            IBActivity.filterIBActivities(activities, new List<String> {'Confirmed', 'Available'} );
            
            IBActivity.isEditMyCurrentAssignment(assignmentAct);
            assignmentAct.ApplicationStatus = 'Confirmed';
            IBActivity.isEditMyCurrentAssignment(assignmentAct);
            
            IBActivity.isTraining(trainingAct);
            IBActivity.isTraining(assignmentAct);

            IBActivity.isMyTraining(myTrainingAct);
            IBActivity.isMyTraining(trainingAct);

            IBActivity.isEditMyCurrentTraining(myTrainingAct);
            myTrainingAct.ApplicationStatus = 'Confirmed';
            IBActivity.isEditMyCurrentTraining(myTrainingAct);

            IBActivity.isEligibleTraining(trainingAct);
            IBActivity.isEligibleTraining(assignmentAct);
            
            IBActivity.hasEventCity(trainingAct);
            IBActivity.hasEventCountry(trainingAct);
            IBActivity.hasEventRegion(trainingAct);
            
            trainingAct.EventCity = 'Berlin';
            trainingAct.EventCountry = 'Germany';
            trainingAct.EventRegion = 'test';
            
            IBActivity.hasEventCity(trainingAct);
            IBActivity.hasEventCountry(trainingAct);
            IBActivity.hasEventRegion(trainingAct);
            
            Date myDate = Date.today();
            trainingAct.StartDate = myDate;
            trainingAct.EndDate = myDate;
            IBActivity.hasSameMonths(trainingAct);
            
            IBActivity.isNotSingleDay(trainingAct);

            Date weekStart = myDate.toStartofWeek();
            trainingAct.StartDate = weekStart;
            IBActivity.isNotSingleDay(trainingAct);
            

            List<String> roles = new List<string>();
            IBActivity.loadMyRoles(roles, null);
            

            IBActivity.loadMyIBRoles(null, 'Confirmed');//'Select IB_Role__c, Programme_Selection__c From IB_Role__c'
            
            IBActivity.loadSearchRoles(roles, 'Select Id, Name, Staffing_Event__c From IB_Event_Role__c');
            
            
            
            List<IB_Event_Role__c> li = TestsUtil.getIbEventRoles();
            //IBActivity.loadIBEventAssignmentReqs(String eventId)
            //IBActivity.hasIBEventRequirements(li[0]);
            //
            
        IBActivity.filterTrainingsByProgramme(new List<Training_Event__c>(), new List<IB_Role__c>());
        IBActivity.filterAssignmentsByProgramme(new List<Staffing_Event__c>(), new List<IB_Role__c>());
        system.debug('staffingEvents: ' + staffingEvents);
        system.debug('rs: ' + rs);
        
            
        Test.stopTest();
        /*System.assertEquals(null, IBA.Table);
        System.assertEquals(null, IBA.Id);
        System.assertEquals(null, IBA.ApplicationStatus);
        System.assertEquals(null, IBA.EndDate);
        System.assertEquals(null, IBA.IBContact);
        System.assertEquals(null, IBA.IBRoleName);
        System.assertEquals(null, IBA.Programme);
        System.assertEquals(null, IBA.StartDate);
        System.assertEquals(null, IBA.EventId);
        System.assertEquals(null, IBA.EventCity);
        System.assertEquals(null, IBA.EventCountry);
        System.assertEquals(null, IBA.EventSubregion);
        System.assertEquals(null, IBA.EventRegion);
        System.assertEquals(null, IBA.EventVenue);
        System.assertEquals(null, IBA.EventName);
        System.assertEquals(null, IBA.EventSubject);
        System.assertEquals(null, IBA.EventCategory);
        System.assertEquals(null, IBA.EventLanguage1);
        System.assertEquals(null, IBA.EventLanguage2);
        System.assertEquals(null, IBA.EventName);
        System.assertEquals(null, IBA.RoleName);
        System.assertEquals(null, IBA.PositionsLeft);*/

    }
}