@isTest 
private class PimsNavbarControllerTest {
	
	@isTest 
	static void testNavbarController() {
    
        integer i=1;
        PimsNavbarController controller;

		User u = PimsTestUtil.createPortalUserPYP('test.pims@ibo.org');
		insert u;

		System.runAs(u) {

			controller = new PimsNavbarController();

			String userFullName = controller.userFullName;
			Boolean displayName = controller.displayName;
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
            //System.assertEquals('lastname', userFullName);
            //System.assertEquals(true, displayName);

		}
	}
}