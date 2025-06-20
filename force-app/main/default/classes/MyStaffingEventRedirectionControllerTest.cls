@isTest
private class MyStaffingEventRedirectionControllerTest {
	
	@isTest
	static void test(){
		
		TestsUtil.initMyStaffingEvents();
		TestsUtil.initMyStaffingEventRedirectionRules(null);
			
		My_Staffing_Event__c myStafEvent = TestsUtil.getMyStaffingEvents().get(0);
		
		ApexPages.StandardController standContr = new ApexPages.StandardController(myStafEvent);
		
		MyStaffingEventRedirectionController controller = new MyStaffingEventRedirectionController(standContr);
		
		System.assert(controller.getUrl() != null);
		
	}

	@isTest
	static void testWithMatchingRules(){
		
		TestsUtil.initMyStaffingEvents();

		Profile p = [SELECT id, name
						FROM Profile
						WHERE id=:UserInfo.getProfileId()];
		TestsUtil.initMyStaffingEventRedirectionRules(p.name);
			
		My_Staffing_Event__c myStafEvent = TestsUtil.getMyStaffingEvents().get(0);
		
		ApexPages.StandardController standContr = new ApexPages.StandardController(myStafEvent);
		
		MyStaffingEventRedirectionController controller = new MyStaffingEventRedirectionController(standContr);
		
		System.assert(controller.getUrl() != null);
		
	}
}