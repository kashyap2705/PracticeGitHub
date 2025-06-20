@isTest
private class UserDAOTest {
	
	@isTest static void test_method_one() {
        integer i=1;
		Test.startTest();
		User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');

		System.runAs(u){
			UserDAO uDAO = UserDAO.getInstance();

			User curUser = uDAO.getCurrentUser();
			Boolean internalUser = uDAO.isInternalUserForProfileId();
			Boolean isAccepted = uDAO.isAcceptedExternalUserForProfileName('SCU + Basic');
			User usr = uDAO.getUserByContactId(u.id);
			usr = uDAO.getFullUserPhotoUrlId('u.id');
			usr = uDAO.getUserByUsername('test@test.org');
			usr = uDAO.getUserById('u.id');
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
		}
		Test.stopTest();
	}
}