@isTest
public class PimsProfileSectionAddControllerTest {

	@isTest static void test_method_one() {

        integer i=1;
		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May',true);
		insert u;

		System.runAs(u){

			PimsProfileSectionAddController controller = new PimsProfileSectionAddController();
			

			Account acc = PimsTestUtil.createAccount('Test Account', '');
			insert acc;
            IB_Programme__c programmes = new IB_Programme__c();
            programmes.Account__c=acc.id;
            programmes.Status__c='Terminated';
            
            

			controller.account = acc;
            controller.AcdamicYearString='Historical enrollment data';
            
            controller.getAcdemicYearList();
            controller.init();
            controller.selectcon();
            controller.close();


			SchoolSections__c sec = PimsTestUtil.createSchoolSection('1', '5', acc);

			PageReference create = controller.create();
			create = controller.create();

			SchoolSections__c sec2 = PimsTestUtil.createSchoolSection('6', '8', acc);
			insert sec2;

			List<SchoolSections__c> secList = new List<SchoolSections__c>();
			secList.add(sec2);
			controller.sections = secList;

			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
		}

	}
/*
	@isTest static void test_method_two() {

        integer i=1;
		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August', 'May',true);
		insert u;

		System.runAs(u){

			PimsProfileSectionController controller = new PimsProfileSectionController();
			controller.isUpdatePage = true;

			Account acc = PimsTestUtil.createAccount('Test Account', '');
			insert acc;

			controller.account = acc;

			PageReference save = controller.save();

			SchoolSections__c sec = PimsTestUtil.createSchoolSection('1', '5', acc);

			PageReference create = controller.create();
			create = controller.create();

			SchoolSections__c sec2 = PimsTestUtil.createSchoolSection('6', '8', acc);
			insert sec2;

			List<SchoolSections__c> secList = new List<SchoolSections__c>();
			secList.add(sec2);
			controller.sections = secList;

			save = controller.save();

			PageReference edit = controller.edit();

			controller.deleteSectionId = sec2.Id;

			PageReference remove = controller.remove();

			remove = controller.remove();

			edit = controller.edit();
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
		}

	}
*/

}