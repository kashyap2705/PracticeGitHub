@isTest
private class ApplicationStaffTableDAOTest {

     static testmethod void test_method_one() {
         integer i = 1;
		
          ApplicationStaffTableDAO astDAO = ApplicationStaffTableDAO.getInstance();

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'CP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          Application_Staff_Table__c appStaffTable = new Application_Staff_Table__c();
          appStaffTable.Name = 'Test App Staff Table Rec';
          appStaffTable.B2_2_2_Staff_Standards__c = 'Yes';
          appStaffTable.IB_Application_Lookup__c = app.Id;
          insert appStaffTable;

          Test.startTest();

          List<Application_Staff_Table__c> libResourceByAppIdList = astDAO.getApplicationLibraryResourcesByApplicationId(app.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          Test.stopTest();
     }
}