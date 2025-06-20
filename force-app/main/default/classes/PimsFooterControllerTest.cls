@isTest
private class PimsFooterControllerTest {
	
	@isTest 
	static void testCurrentYear() {
		
		PimsFooterController controller = new PimsFooterController();
		System.assertEquals(controller.getCurrentYear(), Date.today().year());

	}
	
}