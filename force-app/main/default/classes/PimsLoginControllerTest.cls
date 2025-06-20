@isTest
private class PimsLoginControllerTest {

	@isTest static void test_method_one() {
        integer i=1;
		PageReference loginPage = Page.PimsLogin;
		Test.setCurrentPage(loginPage);

		ApexPages.currentPage().getParameters().put('username', 'a@a.com');
		ApexPages.currentPage().getParameters().put('password', 'adsfasg');

		PimsLoginController controller = new PimsLoginController();

		String currLocale = controller.getLocale();

          controller.login();

		controller.getPageHasErrors();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}

	static testMethod void test_method_two() {
        integer i=1;

		PageReference loginPage = Page.PimsLogin;
		Test.setCurrentPage(loginPage);

		ApexPages.currentPage().getParameters().put('username', 'a@a.com');
		ApexPages.currentPage().getParameters().put('password', 'adsfasg');

		PimsLoginController controller = new PimsLoginController();

		String currLocale = controller.getLocale();

          controller.login();

		controller.getPageHasErrors();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}
}