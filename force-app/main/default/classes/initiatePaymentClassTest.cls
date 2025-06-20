/*-
* This class is for initiatePaymentClass test class
* Modified By: Tarun Sharma
* Modified Date: Nov 21,2023
* Modified Changes: new method testRequestedEventRecordType and Line number 640-647,656,661,662,709,714,715
*/
@isTest
public class initiatePaymentClassTest {

    @testSetup
    static void setup(){
        List<Account> accounts= new List<Account>();
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';
        acc1.State_Abbr__c = 'NY';
        accounts.add(acc1);
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '727272';
        acc1.State_Abbr__c = 'CA';
        accounts.add(acc2);
        Test.startTest();
        insert accounts;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        List<Campaign> cList= new List<Campaign>();
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        cList.add(camp1);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        cList.add(camp2);
        //EMS - Tarun Sharma --203747 START 
        Id requestedEventRecordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Requested Event', 'Campaign').Id;
        Campaign camp3 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, requestedEventRecordTypeId);
        camp3.type = 'Face 2 Face';
        camp3.Sub_Type__c = '1 Day';
        camp3.Delivery_Mode__c = 'Face 2 Face';
        camp3.Workshop_Type__c='Multi-school workshop';
        camp3.IB_Programme__c ='DP+CP';
        cList.add(camp3);
        insert cList;
        //EMS - Tarun Sharma --203747 END
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        List<Staffing_Event__c> staffingEvents= new List<Staffing_Event__c>();
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', cList.get(0).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', cList.get(1).Id, accounts.get(0).Id);
    
        //EMS - Tarun Sharma --203747 
        Staffing_Event__c staffEvent3 = TestsUtil.createStaffingEvent('test_name_st_event_003', cList.get(2).Id, accounts.get(0).Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        //EMS - Tarun Sharma --203747
        staffEvent3.RecordTypeId = staffEventRecTypeId;
        staffingEvents.add(staffEvent1);
        staffingEvents.add(staffEvent2);
        staffingEvents.add(staffEvent3);
        insert staffingEvents;
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
        //EMS - Tarun Sharma --203747 START 
        IB_Event_Role__c ibEventRole3 = TestsUtil.createIbEventRole(20, staffingEvents.get(2).IB_Event__c);
        
        ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
        ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
        //EMS - Tarun Sharma --203747 START
        ibEventRole3.Staffing_Event__c = staffingEvents.get(2).Id;
        List<IB_Event_Role__c> ibEventRoles = new List<IB_Event_Role__c>();
        ibEventRoles.add(ibEventRole1);
        ibEventRoles.add(ibEventRole2);
        ibEventRoles.add(ibEventRole3);
        insert ibEventRoles;
        
        TestsUtil.initMyStaffingEvents(ibEventRoles, staffingEvents, accounts);
        Test.stopTest();
    }
	
    @isTest static void testNoAssignment() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);

        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Pending Selection';

        update staff1;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
	
    @isTest static void testScenario1() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';

        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Request for Candidacy', Fees_Name__c='Reader (Application For Candidacy)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Request for Candidacy';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenario2() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';

				update staff1;
		}
        list<IBEN_Honorarium_Fees_Table__c> listInsFees = new list<IBEN_Honorarium_Fees_Table__c>();
        for(integer i=0;i<=5;i++){
            IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                        Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                        Event_Sub_type__c='Request for Candidacy', Fees_Name__c='Reader (Application For Candidacy)'+i,
                                                        IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY 18/19',
                                                        Account__c='2812', Task_Code__c='M1.2.1.1');
            listInsFees.add(fees);
        }
        insert listInsFees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Request for Candidacy';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenario3() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';

				update staff1;
		}
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Request for Candidacy';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
	
    @isTest static void testScenarioVerVisit() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        List<IB_Role_Repository__c> repoList = TestsUtil.getRoleRepos();
        repoList[0].Role_Name__c = 'School Visit Team Leader';
        update repoList;
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				staff1.IB_Role__c = repoList[0].id;
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Verification Visit', Fees_Name__c='School Visiting Team Leader (Verification Visit)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Verification Visit';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenarioReturnVisit() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        List<IB_Role_Repository__c> repoList = TestsUtil.getRoleRepos();
        repoList[0].Role_Name__c = 'School Visit Team Leader';
        update repoList;
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				staff1.IB_Role__c = repoList[0].id;
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Evaluation', Event_Type__c='Evaluation',
                                                    Event_Sub_type__c='Return Visit', Fees_Name__c='School Visiting Team Leader (Follow up Visit, per day)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Sub_Type__c = 'Return Visit';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenarioSyncVisitChair() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        List<IB_Role_Repository__c> repoList = TestsUtil.getRoleRepos();
        repoList[0].Role_Name__c = 'School Visit Team Leader';
        update repoList;
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
		staff1.Chair__c = true;
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        staff1.IB_Role__c = repoList[0].id;
        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=650, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Evaluation', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Synchronized Visit', Fees_Name__c='School Visiting Team Chair (Evaluation Visit)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Unit_of_Measure__c='Event', Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        system.debug('IBENTest' +camp1);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.IB_Docs_ID__c = '2020';
		camp1.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Evaluation').getRecordTypeId();
		//camp1.Event_Type__c = 'Evaluation';
        camp1.Sub_Type__c = 'Synchronized Visit';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenarioCOR() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Course Outline Reading', Fees_Name__c='Course Outline Reader (per subject)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        
        IB_Subject__c subj = new IB_Subject__c(Subject_Name__c = 'Arabic123',IB_Programme__c ='PYP');
        insert subj;
        
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Sub_Type__c = 'Course Outline Reading';
        camp1.IB_Subject__c = subj.id;
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testCandidacyRemoteConsultation() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        system.debug(campaigns.size());
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Candidacy Remote Consultation', Fees_Name__c='Consultant (20 hours per year remote, per hour)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Candidacy Remote Consultation';
        update camp1;
		id campChildId = createChildEvents.createRemoteConsultation(camp1.id);
        initiatePaymentClass.initiatePayment(campChildId);
        Test.stopTest();
    }
    /*@isTest static void testCandidacyRemoteConsultationWithChild() {
        init();

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        List<Campaign> campaignsUpd = new List<Campaign>();
        system.debug('campaigns.size(): ' + campaigns.size());
        Campaign camp1 = campaigns.get(0);
        Campaign camp2 = campaigns.get(1);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);

        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        update staff1;
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Candidacy Remote Consultation', Fees_Name__c='Consultant (20 hours per year remote, per hour)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp2.Status = 'Staffed';
        camp2.StartDate = system.today() - 100;
        camp2.EndDate = system.today() + 100;
        camp2.Sub_Type__c = 'Candidacy Remote Consultation';
        camp1.Sub_Type__c = 'Candidacy Remote Consultation';
        camp1.ParentId = camp2.Id;
        campaignsUpd.add(camp1);
        campaignsUpd.add(camp2);
        update campaignsUpd;
        initiatePaymentClass.initiatePayment(camp2.id);
    }*/
    @isTest static void testCandidacyRemoteConsultationWithRevChild() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        List<Campaign> campaignsUpd = new List<Campaign>();
        system.debug('campaigns.size(): ' + campaigns.size());
        Campaign camp1 = campaigns.get(0);
        Campaign camp2 = campaigns.get(1);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Candidacy Remote Consultation', Fees_Name__c='Consultant (20 hours per year remote, per hour)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp2.Status = 'Staffed';
        camp2.StartDate = system.today() - 100;
        camp2.EndDate = system.today() + 100;
        camp2.Sub_Type__c = 'Candidacy Remote Consultation';
        camp1.Sub_Type__c = 'Candidacy Remote Consultation';
        camp2.ParentId = camp1.Id;
        campaignsUpd.add(camp1);
        campaignsUpd.add(camp2);
        update campaignsUpd;
        initiatePaymentClass.initiatePayment(camp2.id);
    }
    @isTest static void testCandidacyConsultationVisit() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Authorization',
                                                    Event_Sub_type__c='Candidacy Consultation Visit', Fees_Name__c='Consultant (Consultancy visit, per day)',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Sub_Type__c = 'Candidacy Consultation Visit';
        update camp1;
		id campChildId = createChildEvents.createConsultationVisit(camp1.id);
        Test.startTest();
        initiatePaymentClass.initiatePayment(campChildId);
        //camp1.Consultation_Visit_Date_Confirmed__c = system.today() - 50;
		Campaign campChild = new Campaign(id = campChildId);
        campChild.CV_End_Date__c = system.today() - 48;
        //update campChild;
        initiatePaymentClass.initiatePayment(campChild.id);
        Test.stopTest();
    }
    @isTest static void testExamVisit() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
        Contact con1 = [SELECT Id FROM Contact limit 1];
        CampaignMember member = new CampaignMember(CampaignId = camp1.id, ContactId = con1.Id, Invitation_Status__c = 'Confirmed', Honorarium_Payment_Order_Created__c = false, Exception_Created__c = false);
        insert member;
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Exam Visit',
                                                    Fees_Name__c='Unannounced Examination Inspection', IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Type = 'Exam Visit';
        camp1.Sub_Type__c = null;
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
        Test.stopTest();
    }
    @isTest static void testExamVisitException() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
        Contact con1 = [SELECT Id FROM Contact limit 1];
        CampaignMember member = new CampaignMember(CampaignId = camp1.id, ContactId = con1.Id, Invitation_Status__c = 'Confirmed', Honorarium_Payment_Order_Created__c = false, Exception_Created__c = false);
        insert member;
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Event_Type__c='Exam Visit',
                                                    Fees_Name__c='Unannounced Examination Inspection', IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        //insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        camp1.Type = 'Exam Visit';
        camp1.Sub_Type__c = null;
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
        Test.stopTest();
    }
    @isTest static void testRegionalEvent() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        system.debug(campaigns.size());
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Fees_Name__c='2 days',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Type = null;
        camp1.Sub_Type__c = null;
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testRegionalEventException() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        system.debug(campaigns.size());
        Campaign camp1 = campaigns.get(0);

        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
		if(staff1.Positions_Left_per_Role__c != 0){
				staff1.IB_Event__c = camp1.Id;
				staff1.Application_Status__c = 'Confirmed';
				update staff1;
		}
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Approval Process', Fees_Name__c='2 days',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBA', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='M1.2.1.1');
        insert fees;
        system.debug('camp1.Status: ' + camp1.Status);
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 95;
        camp1.Type = null;
        camp1.Sub_Type__c = null;
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
    }
    @isTest static void testScenarioLandTHourly() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
		//Id LTId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Learning and Teaching Programme Development','Campaign').Id;
		Id LTId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Learning and Teaching Programme Development').getRecordTypeId();
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=25, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Learning and Teaching Programme Development', Event_Type__c='Curriculum development participant (face to face meeting)',
                                                    Fees_Name__c='Curriculum development participant (face to face meeting): other', Unit_of_Measure__c = 'Hourly',
                                                    Quantity__c = 1, Venue_Region__c='IBA', Fiscal_year__c='FY 20/21',
                                                    Account__c='62254', Task_Code__c='IBCC2.3');
        insert fees;
        
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();//EMS - Tarun Sharma --203747 - Added start test and stop test to fix SOQL 101 error
		camp1.RecordTypeID = LTId;
		camp1.Type = 'Curriculum development participant (face to face meeting)';
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Sub_Type__c = '';
		camp1.Quantity__c = 'Hourly';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
		camp1.Quantity2__c = 3;
        update camp1;
		initiatePaymentClass.initiatePayment(camp1.id);
        Test.stopTest();//EMS - Tarun Sharma --203747 - Added start test and stop test to fix SOQL 101 error
    }
    @isTest static void testScenarioLandTHalfDay() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
		//Id LTId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Learning and Teaching Programme Development','Campaign').Id;
		Id LTId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Learning and Teaching Programme Development').getRecordTypeId();
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Learning and Teaching Programme Development', Event_Type__c='Curriculum development participant (face to face meeting)',
                                                    Fees_Name__c='Curriculum development participant (face to face meeting): other', Unit_of_Measure__c = 'Daily',
                                                    Quantity__c = 1, Venue_Region__c='IBA', Fiscal_year__c='FY 20/21',
                                                    Account__c='62254', Task_Code__c='IBCC2.3');
        insert fees;
        
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();
		camp1.RecordTypeID = LTId;
		camp1.Type = 'Curriculum development participant (face to face meeting)';
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Sub_Type__c = '';
		camp1.Quantity__c = 'Half Day';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
		camp1.Quantity2__c = 3;
        update camp1;
		initiatePaymentClass.initiatePayment(camp1.id);
        Test.stopTest();
    }
    @isTest static void testScenarioLandTQuarterDay() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
		//Id LTId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Learning and Teaching Programme Development','Campaign').Id;
		Id LTId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Learning and Teaching Programme Development').getRecordTypeId();
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);
        if(staff1.Positions_Left_per_Role__c != 0){
        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Confirmed';
        update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Learning and Teaching Programme Development', Event_Type__c='Curriculum development participant (face to face meeting)',
                                                    Fees_Name__c='Curriculum development participant (face to face meeting): other', Unit_of_Measure__c = 'Daily',
                                                    Quantity__c = 1, Venue_Region__c='IBA', Fiscal_year__c='FY 20/21',
                                                    Account__c='62254', Task_Code__c='IBCC2.3');
        insert fees;
        
        system.debug('camp1.Status: ' + camp1.Status);
        Test.startTest();
		camp1.RecordTypeID = LTId;
		camp1.Type = 'Curriculum development participant (face to face meeting)';
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() - 99;
        camp1.Sub_Type__c = '';
		camp1.Quantity__c = 'Quarter Day';
        update camp1;
        initiatePaymentClass.initiatePayment(camp1.id);
		camp1.Quantity2__c = 3;
        update camp1;
		initiatePaymentClass.initiatePayment(camp1.id);
        Test.stopTest();
        
    }
    //EMS - Tarun Sharma --203747 START
    @isTest static void testRequestedEventRecordType() {
        

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        List<Campaign> campaignsUpd = new List<Campaign>();
        Campaign camp1 = campaigns.get(2);
        
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(2);
        if(staff1.Positions_Left_per_Role__c != 0){
                staff1.IB_Event__c = camp1.Id;
                staff1.Application_Status__c = 'Confirmed';
                update staff1;
        }
        IBEN_Honorarium_Fees_Table__c fees = new IBEN_Honorarium_Fees_Table__c(Active__c=true, Amount__c=100, Effective_Start_Date__c=system.today() - 150,
                                                    Effective_End_Date__c=system.today() + 150, Event_Record_Type__c='Requested Event', Event_Type__c='Requested MS F2F_IBAEM (1306)',
                                                    Event_Sub_type__c='1 Day', Fees_Name__c='Request Event Fee Name',
                                                    IB_Programme__c='All', Quantity__c=1, Venue_Region__c='IBAEM', Fiscal_year__c='FY18/19',
                                                    Account__c='2812', Task_Code__c='RE1.2.1.1');
        insert fees;
        camp1.Status = 'Staffed';
        camp1.StartDate = system.today() - 100;
        camp1.EndDate = system.today() + 100;
        campaignsUpd.add(camp1);
        update campaignsUpd;
        Test.startTest();
		initiatePaymentClass.initiatePayment(camp1.id);
		initiatePaymentClass.ibProgrammeProcess('DP+CP',true);
        String programme = initiatePaymentClass.ibProgrammeProcess('IB Ed',true);
        system.assertEquals('Continuum',programme,'Expected');
        initiatePaymentClass.ibProgrammeProcess('DP',true);
        initiatePaymentClass.ibProgrammeProcess('DP+CP',false);
        initiatePaymentClass.ibProgrammeProcess('CP',false);
        initiatePaymentClass.ibProgrammeProcess('PYP',false);
        initiatePaymentClass.ibProgrammeProcess('MYP',false);
        initiatePaymentClass.ibProgrammeProcess('IB Ed',false);
        Test.stopTest();
    }
	//EMS - Tarun Sharma --203747 END
    private static void initCustomSettings (Campaign camp, Boolean isProffesionalDevelopment) {
        
        String recordTypeId = [select id,name from recordtype where sobjecttype = 'Staffing_Event__c' limit 1].Id;
        
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        if (! isProffesionalDevelopment ) {
            schoolServicesConf.schoolServiceForStuffEvent__c = recordTypeId;
        }
        schoolServicesConf.schoolServicesCampList__c = String.valueOf(camp.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp.RecordTypeId).substring(0,15);
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        if (isProffesionalDevelopment ) {
            profDevConf.profDevForStuffEvent__c = recordTypeId;
        }
        
        profDevConf.professionalDevelopmentCampList__c = String.valueOf(camp.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp.RecordTypeId).substring(0,15);
        insert profDevConf;
    }
}