@isTest
private class RedirectionHandlerControllerTest {

	@isTest
    static void testRedirectionHandlerController() {
		
		PageReference ref = new PageReference('/apex/basePage');
		Test.setCurrentPage(ref);
		
		System.assertEquals(0, ApexPages.currentPage().getParameters().size());
		
		ApexPages.currentPage().getParameters().put('testParam', 'testValue');
		
		RedirectionHandlerController controller = new TestClass();
		
		System.debug(RedirectionHandlerController.INTERNAL_COMMUNITY);
		
		PageReference resultPage = controller.redirectTo();
		
		System.assert(resultPage.getParameters().get('testParam') == 'testValue');
    }
    
 
	@isTest
    static void testMyRoleRedirectionControllerCreateUrl() {
    	
    	initCustomSettings();
    	
    	MyRoleRedirectionController controller = new MyRoleRedirectionController();
    	
    	String url = controller.getUrl();
    	
    	System.debug('>>>> create URL >>> ' + url);
    } 
    
      
	@isTest
    static void testMyRoleRedirectionControllerEditUrl() {
    	
    	initCustomSettings();
    	init();
    	
    	IB_Role__c ibRole = TestsUtil.getIbRoles().get(0);
    	
    	ApexPages.StandardController st = new ApexPages.StandardController(ibRole);
    	
    	MyRoleRedirectionController controller = new MyRoleRedirectionController(st);
    	
    	String url = controller.getUrl();
    	
    	System.debug('>>>> edit URL >>> ' + url);
    }       
    
    
	@isTest
    static void testMyStaffingEventRedirectionController() {
    	
    	init();
    	
    	My_Staffing_Event__c instance = TestsUtil.getMyStaffingEvents().get(0);
    	
    	ApexPages.StandardController st = new ApexPages.StandardController(instance);
    	
    	MyStaffingEventRedirectionController controller = new MyStaffingEventRedirectionController(st);
    }    
    
    
    private class TestClass extends RedirectionHandlerController {
    	
    	public override String getUrl(){
    		return '/apex/testUrl';
    	}
    }
    
    
  	private static void initCustomSettings(){
    	
		List<String> ibenProfileNames = new List<String>{'IBAP IBEN', 'IBA IBEN', 'System Administrator'};
		List<String> custComm = new List<String>{'Customer Community Advanced','Learning & Teaching Level 1', 'System Administrator'};
    	
    	// create
		Map<Id, Profile> profs1 = new Map<Id, Profile>(TestsUtil.getProfilesByNames(custComm));
    	String profileIdsStr = getProfileIdsAsString( new List<Id>(profs1.keyset()) );
    	
  		Map<Id, Profile> profs2 = new Map<Id, Profile>(TestsUtil.getProfilesByNames(ibenProfileNames));
    	String profs2Str = getProfileIdsAsString( new List<Id>(profs2.keyset()) );
    	  	
    	MyRoleRedirectionRules__c myRoleRule1 = TestsUtil.createMyRoleRedirectionRule(
    		'Create_Internal', TestsUtil.COMMUNITY_NAME_INTERNAL, '/apex/myRoleCreateInternal', profileIdsStr );
        myRoleRule1.additional_ids__c = profileIdsStr;

    	MyRoleRedirectionRules__c myRoleRule2 = TestsUtil.createMyRoleRedirectionRule(
    		'Create_IB_Educator', TestsUtil.COMMUNITY_NAME_IB_EDUCATOR, '/apex/myRoleCreateIbenPortal', profileIdsStr );
   
   	    MyRoleRedirectionRules__c myRoleRuleEdit1 = TestsUtil.createMyRoleRedirectionRule(
    		'Edit_Confirmed_Internal', TestsUtil.COMMUNITY_NAME_INTERNAL, '/apex/myRoleEditApplicationInternal', profs2Str );  
    		
    	MyRoleRedirectionRules__c myRoleRuleEdit2 = TestsUtil.createMyRoleRedirectionRule(
    		'Edit_Confirmed_IB_Educator', TestsUtil.COMMUNITY_NAME_IB_EDUCATOR, '/apex/confirmedRoleApplicationEducator', profs2Str );
    		
    	insert new List<SObject> {myRoleRule1, myRoleRule2, myRoleRuleEdit1, myRoleRuleEdit2};  	
    }
       
        
	private static void init(){
		
		initCampaigns();
		
		List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType()); 
		List<Account> accounts = TestsUtil.getSObjectsByType(Account.getSobjectType());
		
		initStaffingEvents(campaigns, accounts);
		
		List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
		
		initIbEventRoles(staffingEvents);
		
		List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
		
		TestsUtil.initMyStaffingEvents(ibEventRoles, staffingEvents, accounts);
	}
	

	
	public static void initIbEventRoles(List<Staffing_Event__c> staffingEvents){
        //
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
        IB_Event_Role__c ibEventRole3 = TestsUtil.createIbEventRole(20, staffingEvents.get(2).IB_Event__c);
        
        ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
        ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
        ibEventRole3.Staffing_Event__c = staffingEvents.get(2).Id;
        
        insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2,ibEventRole3};
	}
	
	
	
	public static void initStaffingEvents(List<Campaign> campaigns, List<Account> accounts){
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', campaigns.get(0).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', campaigns.get(1).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent3 = TestsUtil.createStaffingEvent('test_name_st_event_003', campaigns.get(2).Id, accounts.get(0).Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        staffEvent3.RecordTypeId = staffEventRecTypeId;
        insert new List<Staffing_Event__c>{staffEvent1, staffEvent2, staffEvent3};
     }
    
	
	
	public static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '123457';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '123456';
        insert new List<Account> {acc1,acc2};
            
            Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id);
        insert new List<Opportunity> {opp1,opp2};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        Campaign camp3 = TestsUtil.createCampaign('camp test name 3', acc2.Id, opp2.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2,camp3};
            
            }
    
	
    private static String getProfileIdsAsString(List<Id> profileIds){
    	String idsStr = String.join(new List<Id>(profileIds), ',');
    	return idsStr;
    } 
}