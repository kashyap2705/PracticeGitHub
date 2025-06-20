@isTest
public with sharing class ExperienceExtControllerTest {
	

    private static final String RT_NAME_LANGUAGE_EXPERIENCE = 'Language Experience';
      
    @isTest 
	static void testSaveAction() {
		final User usr = TestsUtil.createPortalUser('testUsrName');
		insert usr;
		
		System.runAs(usr) {
			
			final List<RecordType> rt = [select id from RecordType WHERE Name =: RT_NAME_LANGUAGE_EXPERIENCE ];
			
			ApexPages.currentPage().getParameters().put('RecordType', rt[0].Id);
			ApexPages.currentPage().getParameters().put('retURL', 'test');
			
			final ExperienceExtController  controller =  new ExperienceExtController (new ApexPages.StandardController(TestsUtil.createMyProfileObject(usr.ContactId, rt[0].Id)));
			controller.save();
            system.assert(true, 'Save PROBLEM !!');
            
            String lang = controller.getUserLanguageKey();
			String locale = controller.getLocale();
            DateUtility du = controller.dateUtil;
            String photo = controller.getPhoto();
		}
		
	}

	@isTest 
	static void testSaveActionNoRetURL() {
		final User usr = TestsUtil.createPortalUser('testUsrName');
		insert usr;
		
		System.runAs(usr) {
			
			final List<RecordType> rt = [select id from RecordType WHERE Name =: RT_NAME_LANGUAGE_EXPERIENCE ];
			
			ApexPages.currentPage().getParameters().put('RecordType', rt[0].Id);
			//ApexPages.currentPage().getParameters().put('retURL', 'test');
			
			final ExperienceExtController  controller =  new ExperienceExtController (new ApexPages.StandardController(TestsUtil.createMyProfileObject(usr.ContactId, rt[0].Id)));
			controller.save();
			
			system.assert(true, 'Save PROBLEM !!');
		}
		
	}
	@isTest 
	static void testSaveActionDMLException() {
		final User usr = TestsUtil.createPortalUser('testUsrName');
		insert usr;
		
		System.runAs(usr) {
			
			final List<RecordType> rt = [select id from RecordType WHERE Name =: RT_NAME_LANGUAGE_EXPERIENCE ];
			String wrongRTId = Account.SObjectType.getDescribe().getRecordTypeInfos().get(0).getRecordTypeId();
			ApexPages.currentPage().getParameters().put('RecordType', wrongRTId);

			//ApexPages.currentPage().getParameters().put('retURL', 'test');
			IB_E_Background__c myProfile = TestsUtil.createMyProfileObject(usr.ContactId, wrongRTId);

			final ExperienceExtController  controller =  new ExperienceExtController (new ApexPages.StandardController(myProfile));
			controller.save();
			
			System.assertEquals(null,myProfile.id);
		}
		
	}

	@isTest 
	static void testSaveActionGeneralException() {
		

		/*Profile noAccessProfile = [select id from profile where name='Read Only - System Admin'];

		final User usr = TestsUtil.createNonPortalUser('testUsrName',noAccessProfile.Id);
		insert usr;*/
		final User usr = TestsUtil.createPortalUser('testUsrName');
		insert usr;
		
		
		System.runAs(usr) {
			
			final List<RecordType> rt = [select id from RecordType WHERE Name =: RT_NAME_LANGUAGE_EXPERIENCE ];
			
			//ApexPages.currentPage().getParameters().put('retURL', 'test');
			IB_E_Background__c myProfile = TestsUtil.createMyProfileObject(usr.ContactId, rt[0].Id);
			/*PageReference pageRef = Page.IBENAccreditationExperience;
    		Test.setCurrentPage(pageRef);
    		*/
    		ApexPages.currentPage().getParameters().put('npeURL', 'npeURL');

			final ExperienceExtController  controller =  new ExperienceExtController (new ApexPages.StandardController(myProfile));
			controller.save();
			
			System.assertEquals(null,myProfile.id);
		}
		
	}

}