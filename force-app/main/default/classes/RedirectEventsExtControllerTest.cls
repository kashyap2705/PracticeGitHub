@isTest
private class RedirectEventsExtControllerTest {


	@isTest
	private static void test(){
		
		User usr = TestsUtil.createPortalUser('test_user_name_123');
        insert usr;
        
        System.runAs(usr) {
        	
        	ApexPages.Standardcontroller stContr = new ApexPages.Standardcontroller(usr); 
        	RedirectEventsExtController controller = new RedirectEventsExtController(stContr);
        	
        	System.assert(controller.getUserInfo().Id == usr.Id);
        }
	}
	
	
}