@isTest
private class DeleteBackgroundTest {
	
	@isTest static void test_method_one() {
		User usr = TestsUtil.createPortalUser('testUsrName');
     	insert usr;

     	Contact c = TestsUtil.getContacts()[0];
     	
 		final List<RecordType> rt = [select id from RecordType WHERE Name = 'Language Experience' ];
		
		IB_E_Background__c exp = TestsUtil.createMyProfileObject(c.Id,rt[0].id);

		insert exp;
					
		DeleteEducatorBackground controller = new DeleteEducatorBackground();
		controller.backgroundId = exp.Id;

		PageReference test = controller.deleteBackground();
	}
	
}