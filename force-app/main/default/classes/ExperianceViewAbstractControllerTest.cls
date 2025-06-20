@isTest
public class ExperianceViewAbstractControllerTest { 
 
	private static final Integer RECORDS_NUMBER_PER_RECORD_TYPE = 15;

	private static final String RT_NAME_EDUCATIONAL_DEGREES = 'Educational Degrees';
	private static final String RT_NAME_PUBLICATIONS = 'Publications';
	private static final String RT_NAME_NATIONAL_EDUCATION_WORKING_KNOWLEDGE = 'National Education Working Knowledge';
	private static final String RT_NAME_ACCREDITATION_KNOWLEDGE = 'Accreditation Knowledge';
	private static final String RT_NAME_LANGUAGE_EXPERIENCE = 'Language Experience';
	private static final String RT_NAME_GENERAL_TEACHING_EXPERIENCE = 'General Teaching Experience';
	private static final String RT_NAME_IB_TEACHING_EXPERIENCE = 'IB Teaching Experience';
	private static final String RT_NAME_IB_CONFERENCE_EXPERIENCE = 'IB Conference Experience';
	private static final String RT_NAME_IB_TRAININGS_ATTENDED  = 'IB Trainings Attended';
	

	@isTest
	public static void testEducationalDegreesViewsController(){
		runTestsForClass(EducationalDegreesViewController.class);
	}

	@isTest
	public static void testPublicationsViewController(){
		runTestsForClass(PublicationsViewController.class);
	}

	@isTest
	public static void testIBTrainingsAttendedViewController(){
		runTestsForClass(IBTrainingsAttendedViewController.class);
	}
	/*
	@isTest
	public static void testAccreditationKnoweledgeViewController(){
		runTestsForClass(AccreditationKnoweledgeViewController.class);
	}
	
	@isTest
	public static void testLanguageExperianceViewController(){
		runTestsForClass(LanguageExperianceViewController.class);
	}
	
	@isTest
	public static void testGeneralTeachingExperianceViewController(){
		runTestsForClass(GeneralTeachingExperianceViewController.class);
	}
	
	@isTest
	public static void testIBTeachingExperianceViewController(){
		runTestsForClass(IBTeachingExperianceViewController.class);
	}
	
	@isTest
	public static void testConferenceExperianceViewController(){
		runTestsForClass(ConferenceExperianceViewController.class);
	}
	*/
	
	@isTest
	public static void testExtentionsInitialState(){
		NationalEducationViewController contr1 = new NationalEducationViewController();
		AccreditationKnoweledgeViewController contr2 = new AccreditationKnoweledgeViewController();
		LanguageExperianceViewController contr3 = new LanguageExperianceViewController();
		GeneralTeachingExperianceViewController contr4 = new GeneralTeachingExperianceViewController();
		IBTeachingExperianceViewController contr5 = new IBTeachingExperianceViewController();
		ConferenceExperianceViewController contr6 = new ConferenceExperianceViewController();
		IBTrainingsAttendedViewController contrr7 = new IBTrainingsAttendedViewController(); 
	}
	
	
	
	@isTest
	public static void testWrongRecordTypePassedInConstructor(){
		
		try{
		
			runTestsForClass(TestErrorClass.class);
			
		} catch (Exception e) {
			
			System.debug('>>>> err ' + e.getMessage());
		}
	}	


	// helper methods

	private static void runTestsForClass(Type t){
		User usr = TestsUtil.createPortalUser('testUsrName');
		insert usr;
		
		System.runAs(usr){
			ExperianceViewAbstractController controller = (ExperianceViewAbstractController)t.newInstance();
			testInitialState(controller);
			
			init();
			controller = (ExperianceViewAbstractController)t.newInstance();
			
			testPagesNavigation(controller);
			testChangeDisplaySize(controller);	
		}
	}

	
	private static void testchangeDisplaySize (ExperianceViewAbstractController obj){
		
		System.assert(obj.tableRecordList != null);
		System.assertEquals(obj.maxperPage, obj.tableRecordList.size());
		
		obj.maxperPage = 5;
		obj.changeDisplaySize();
		System.assertEquals(3, obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		obj.maxperPage = 10;
		obj.changeDisplaySize();
		System.assertEquals(2, obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		obj.maxperPage = 25;
		obj.changeDisplaySize();
		System.assertEquals(1, obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		obj.maxperPage = 5;
		obj.changeDisplaySize();
		System.assertEquals(3, obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		System.debug(obj.getTotal_size());
	}


	private static void testPagesNavigation (ExperianceViewAbstractController obj){
		
		System.assert(obj.tableRecordList != null);
		System.assertEquals(5, obj.tableRecordList.size());
		
		obj.maxperPage = 5;
		obj.changeDisplaySize();
		
		System.assertEquals(3, obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		System.assert(obj.getDisablePrevious());
		System.assert(! obj.getDisableNext());
		
		//2nd page
		obj.Next();
		
		System.assertEquals(2, obj.getCurrentPage());
		System.assert(! obj.getDisablePrevious());
		System.assert(! obj.getDisableNext());
		
		//3rd page - last
		obj.Next();
		
		System.assertEquals(3, obj.getCurrentPage());
		System.assert(! obj.getDisablePrevious());
		System.assert(obj.getDisableNext());
		
		obj.first();
		
		System.assertEquals(1, obj.getCurrentPage());
		System.assert(obj.getDisablePrevious());
		System.assert(!obj.getDisableNext());

		obj.last();
		
		System.assertEquals(3, obj.getCurrentPage());
		System.assert(! obj.getDisablePrevious());
		System.assert(obj.getDisableNext());		
	}


	private static void testInitialState(ExperianceViewAbstractController obj){
		
		System.assert(obj.getCounts() != null && obj.getCounts().size() != 0);
		
		System.assertEquals(5 ,obj.maxperPage);
		System.assertEquals(0, obj.pageNumberParam);
		System.assertEquals(0,obj.getTotalPages());
		System.assertEquals(1, obj.getCurrentPage());
		
		obj.first();
		obj.last();
		obj.Previous();
		obj.Next();
		obj.changeDisplaySize();
		obj.doSearch(); 
		
		System.assert(obj.getDisablePrevious());
		System.assert(obj.getDisableNext());
	}
	


	private static void init(){
		
		List<String> recordTypeNames = new List<String> {
			RT_NAME_EDUCATIONAL_DEGREES,
			RT_NAME_PUBLICATIONS,
			RT_NAME_NATIONAL_EDUCATION_WORKING_KNOWLEDGE,
			RT_NAME_ACCREDITATION_KNOWLEDGE,
			RT_NAME_LANGUAGE_EXPERIENCE,
			RT_NAME_GENERAL_TEACHING_EXPERIENCE,
			RT_NAME_IB_TEACHING_EXPERIENCE,
			RT_NAME_IB_CONFERENCE_EXPERIENCE,
			RT_NAME_IB_TRAININGS_ATTENDED
		};
		
		List<RecordType> recordTypes = [select id from RecordType WHERE Name In : recordTypeNames ];
		System.debug('>>>>>>>>>>' + recordTypes.size());
		
		List<IB_E_Background__c> myProfiles = new List<IB_E_Background__c>();
		
		User usr = [select ContactId from User where Id = :UserInfo.getUserId()];
		
		for (RecordType rt :recordTypes){
			
			for (Integer i=0; i<RECORDS_NUMBER_PER_RECORD_TYPE; i++){
				
				myProfiles.add(TestsUtil.createMyProfileObject(usr.ContactId, rt.Id));
			}
		}
		
		insert myProfiles;
	}
	
	
	private class TestErrorClass extends ExperianceViewAbstractController {
		public TestErrorClass(){
			super('test text');
		}
	}
}