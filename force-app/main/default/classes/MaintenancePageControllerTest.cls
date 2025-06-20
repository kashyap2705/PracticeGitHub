@isTest
private class MaintenancePageControllerTest {
    @isTest static void test_method_one() {
        MaintenancePageController controller = new MaintenancePageController();
		String currLocale = controller.getLocale();
    }

}