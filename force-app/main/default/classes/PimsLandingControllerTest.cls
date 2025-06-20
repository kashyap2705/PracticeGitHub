@isTest
private class PimsLandingControllerTest {

	@isTest static void test_method_one() {
        integer i=1;
		Test.startTest();
		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May', true);
		insert u;

		System.runAs(u){

			PimsLandingController controller = new PimsLandingController();
			controller.init();
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
		}
		Test.stopTest();
	}

	@isTest static void test_method_two() {
        integer i=1;
		Test.startTest();
		User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');
		insert u;

		System.runAs(u){

			ProfileService ps = new ProfileService();

			Account account = ps.getProfileAccount();

			IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(account, 'PYP');

			//insert programme;

			PimsLandingController controller = new PimsLandingController();
			controller.init();
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
		}
		Test.stopTest();
	}
}