@isTest
public class PimsForgotPasswordControllerTest {

	@IsTest(SeeAllData=true)
	public static void testPimsForgotPasswordController() {

    	PimsForgotPasswordController controller = new PimsForgotPasswordController();
    	controller.username = 'test@salesforce.com';

    	System.assertEquals(controller.forgotPassword(), null);

     String currLocale = controller.getLocale();

    }

}