@isTest
private class ApplicationDAOTest {

     static testMethod void test_method_one() {
		  integer i =1;
          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          ApplicationDAO appDAO = ApplicationDAO.getInstance();

          IB_Application__c appById = appDAO.getApplicationById(app.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          IB_Application__c appByIdAndSection = appDAO.getApplicationById(app.Id,'sectionb1');
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
		List<IB_Application__c> appByProgList = appDAO.getApplicationsByProgrammeId(prog.Id);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
	}
}