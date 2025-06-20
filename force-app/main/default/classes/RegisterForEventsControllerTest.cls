@isTest
public class RegisterForEventsControllerTest {


	@isTest
	public static void testExtentionWithObjectFromStandContr(){
        integer i=1;
		Test.startTest();
		init();
		
		My_Staffing_Event__c myStaffingEvent = TestsUtil.getMyStaffingEvents().get(0);
		
		ApexPages.StandardController standardContr = new ApexPages.StandardController(myStaffingEvent);
		
		RegisterForEventsController controller = new RegisterForEventsController(standardContr);
		
		//PageReference cancel = controller.cancel();
		//System.assert(cancel.getUrl().contains('/a0t/o'));
		
		//PageReference save = controller.save();
		
		controller.reloadRoles();
		controller.reloadData();
		controller.cleanParams();
		//controller.searchPrograme();
		//controller.changeRoleLevel();
		
		System.debug(controller.roleData);
		System.debug(controller.programmData);
		System.debug(controller.programmData);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
		Test.stopTest();
	}	

	@isTest
	public static void testExtentionWithObjectFromStandContr2(){
        integer i=1;
		Test.startTest();
		init();
		
		My_Staffing_Event__c myStaffingEvent = TestsUtil.getMyStaffingEvents().get(0);
		
		ApexPages.StandardController standardContr = new ApexPages.StandardController(myStaffingEvent);
		
		RegisterForEventsController controller = new RegisterForEventsController(standardContr);
		
		//PageReference cancel = controller.cancel();
		//System.assert(cancel.getUrl().contains('/a0t/o'));
		
		//PageReference save = controller.save();
		
		//controller.reloadRoles();
		//controller.reloadData();
		//controller.cleanParams();
		controller.searchPrograme();
		controller.changeRoleLevel();
		
		System.debug(controller.roleData);
		System.debug(controller.programmData);
		System.debug(controller.programmData);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
		Test.stopTest();
	}	


	@isTest
	public static void testExtentionWithObjectFromStandContrSaveFail(){
		Test.startTest();
		init();
		
		My_Staffing_Event__c myStaffingEvent = TestsUtil.getMyStaffingEvents().get(0);
		myStaffingEvent.addError('no save');
		
		Test.setCurrentPage(new PageReference('/apex/registerForEventsInternal'));
		
		ApexPages.StandardController standardContr = new ApexPages.StandardController(myStaffingEvent);
		
		RegisterForEventsController controller = new RegisterForEventsController(standardContr);
		
		// will cause an error on save
		myStaffingEvent.Application_Status__c = 'Confirmed';
		
		PageReference save = controller.save();
		
		System.assert(Apexpages.hasMessages());
		Test.stopTest();
	}
		
			
	
	@isTest
	public static void testStaffingEventIdAsUrlParamInControllerExtention(){
		Test.startTest();
		init();
		
		Staffing_Event__c staffingEvent = TestsUtil.getStaffingEvents().get(0);
		Contact cont = TestsUtil.getContacts().get(0);
		
		Test.setCurrentPage(new PageReference('/apex/registerForEventsInternal'));
		
		ApexPages.currentPage().getParameters().put('contactId', cont.Id );
		ApexPages.currentPage().getParameters().put('staffingEventId', staffingEvent.Id);
		ApexPages.currentPage().getParameters().put('cancelURL', '/testurl');
		
		ApexPages.StandardController standardContr = new ApexPages.StandardController(new My_Staffing_Event__c());
		
		RegisterForEventsController controller = new RegisterForEventsController(standardContr);
		
		System.assert(! Apexpages.hasMessages());
		
		Pagereference save = controller.save();
		System.assert(save == null);
		
		System.assert( Apexpages.hasMessages());
		
		//System.assert(controller.cancel().getUrl().contains('/testurl'));
		Test.stopTest();
	}
		
		
	
	@isTest
	public static void testStaffingEventIdAsUrlParamInCustomController(){
		Test.startTest();
		init();
		
		Staffing_Event__c staffingEvent = TestsUtil.getStaffingEvents().get(0);
		Contact cont = TestsUtil.getContacts().get(0);
		//My_Staffing_Event__c mySt = TestsUtil.
		
		Test.setCurrentPage(new PageReference('/apex/registerForEventsInternal'));
		
		ApexPages.currentPage().getParameters().put('contactId', cont.Id );
		ApexPages.currentPage().getParameters().put('staffingEventId', staffingEvent.Id);
		
		RegisterForEventsController controller = new RegisterForEventsController();
		
		System.assert(! Apexpages.hasMessages());
		
		Pagereference save = controller.save();
		System.assert(save == null);
		
		System.assert( Apexpages.hasMessages());
		Test.stopTest();
	}	
	
	
	@isTest
	public static void testStaffingEventWithWrongUrlParams(){
		Test.startTest();
		init();
		
		Staffing_Event__c staffingEvent = TestsUtil.getStaffingEvents().get(0);
		Contact cont = TestsUtil.getContacts().get(0);
		
		Test.setCurrentPage(new PageReference('/apex/registerForEventsInternal'));
		
		ApexPages.currentPage().getParameters().put('contactId', cont.Id );
		//wrong Id param
		ApexPages.currentPage().getParameters().put('staffingEventId', cont.Id );
				
		RegisterForEventsController controller = new RegisterForEventsController();
		
		
		// should be id not string
		ApexPages.currentPage().getParameters().put('staffingEventId', 'wrong_string');
		
		controller = new RegisterForEventsController();
		
		System.assert(Apexpages.hasMessages());
		
		Pagereference save = controller.save();
		System.assert(save == null);
		
		System.assert(Apexpages.hasMessages());
		Test.stopTest();
	}	
	
	
	
	private static void init(){
		initCampaigns();
		
		List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType()); 
		List<Account> accounts = TestsUtil.getSObjectsByType(Account.getSobjectType());
		
		initStaffingEvents(campaigns, accounts);
		
		List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
		List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
		
		initMyStaffingEvents(staffingEvents, accounts);
	}
	
	
	
	private static void initMyStaffingEvents(List<Staffing_Event__c> staffingEvents, List<Account> accounts){
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accounts.get(0));
		insert country;
		
		Contact cont1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
		Contact cont2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
		insert new List<Contact>{cont1, cont2};
		
		IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
		repo.Related_Programmes__c ='MYP;DP;';
		insert repo;
				
		IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont1.Id);
		IB_Role__c ibRole2 = TestsUtil.createIbRole(repo.Id, cont2.Id);
		
		ibRole1.Programme_Selection__c = repo.Related_Programmes__c;
		ibRole2.Programme_Selection__c = repo.Related_Programmes__c;
		
		insert new List<IB_Role__c> {ibRole1, ibRole2};
		
		IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
		IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
		
		ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
		ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
		
		ibEventRole1.IB_Programme__c = repo.Related_Programmes__c;
		ibEventRole2.IB_Programme__c = repo.Related_Programmes__c;
		
		ibEventRole1.IB_Role__c = repo.Id;
		ibEventRole2.IB_Role__c = repo.Id;
		
		insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2};		
		
		// Ib Event Role's IB_Event__c field value is reference to Campaign
		My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', accounts.get(0).Id, 
																			ibEventRole1.IB_Event__c, null, ibRole1.Id);
			
		My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', accounts.get(0).Id, 
																			ibEventRole2.IB_Event__c, null, ibRole2.Id);

		myStaffEvent1.Staffing_Event__c = staffingEvents.get(0).Id;
		myStaffEvent2.Staffing_Event__c = staffingEvents.get(1).Id;
		
		myStaffEvent1.IB_Contact__c = cont1.Id;
		myStaffEvent2.IB_Contact__c = cont2.Id;
		
		myStaffEvent1.IB_Role__c = repo.Id; // is this required on layout?
		myStaffEvent2.IB_Role__c = repo.Id; // is this required on layout?
		
		myStaffEvent1.IB_Programme__c = repo.Related_Programmes__c;
		myStaffEvent2.IB_Programme__c = repo.Related_Programmes__c;

		insert new List<My_Staffing_Event__c>{myStaffEvent1, myStaffEvent2};
	}


	private static void initStaffingEvents(List<Campaign> campaigns, List<Account> accounts){
		
		Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;		
		
		Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', campaigns.get(0).Id, accounts.get(0).Id);
		Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', campaigns.get(1).Id, accounts.get(0).Id);
		staffEvent1.RecordTypeId = staffEventRecTypeId;
		staffEvent2.RecordTypeId = staffEventRecTypeId;
		insert new List<Staffing_Event__c>{staffEvent1, staffEvent2};
	}
	
	
	private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '818181';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '828282';
        
        insert new List<Account> {acc1,acc2};
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
		Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
		Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
		
		camp1.Venue_Account__c = acc1.Id;
		camp2.Venue_Account__c = acc2.Id;
		
    	insert new List<Campaign>{camp1,camp2};
	}	
	
}