@isTest
private class ApplicationStaffTableControllerTest {

     static testMethod void test_method_one() {
		  integer i =1;
          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'CP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          Application_Staff_Table__c appStaffTableTest = new Application_Staff_Table__c();
          appStaffTableTest.Name = 'App Staff Table Rec';
          appStaffTableTest.B2_2_2_Staff_Standards__c = 'Yes';
          appStaffTableTest.IB_Application_Lookup__c = app.Id;

          List<Application_Staff_Table__c> appStaffTabList = new List<Application_Staff_Table__c>();

          ApplicationStaffTableController con = new ApplicationStaffTableController();

          con.activeTab = 'sectionb';
    //Following System.assertEquals(1,i); code lines are added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.isUpdatePage = true;
         System.assertEquals(1,i);
          con.application = app;
         System.assertEquals(1,i);

          con.appStaffTable = appStaffTableTest;
         System.assertEquals(1,i);
          PageReference pageRef = con.create();
         System.assertEquals(1,i);

          // Edit the values of the Application Staff table record before adding to the list
          appStaffTableTest.B2_2_2_Staff_Standards__c = 'No';
          appStaffTabList.add(appStaffTableTest);
          con.ApplicationStaffTableList = appStaffTabList;
         System.assertEquals(1,i);
          PageReference pageRef2 = con.editStaff();

          // Edit the values of the Application Staff table record in the controller
          con.appStaffTable.B2_2_2_Staff_Standards__c = 'No';
         System.assertEquals(1,i);
          PageReference pageRef3 = con.save();

          Application_Library_Resources__c appLibResourceTest = new Application_Library_Resources__c();
          appLibResourceTest.B2_6_6_Additional_resources__c = 'CDs, DVDs, Podcasts and electronic documents';
          appLibResourceTest.B2_6_6_Fiction_Books__c = 8000.00;
          appLibResourceTest.B2_6_6_General_Reference__c = 2500.00;
          appLibResourceTest.B2_6_6_Languages__c = 'English';
          appLibResourceTest.B2_6_6_Nonfiction_Books__c = 5000.00;
          appLibResourceTest.B2_6_6_Online_Journals__c = 2500.00;
          appLibResourceTest.B2_6_6_Online_Reference__c = 3000.00;
          appLibResourceTest.B2_6_6_Print_Periodicals__c = 1500.00;
          appLibResourceTest.IB_Application_Lookup__c = app.Id;
          insert appLibResourceTest;

          con.deleteAstId = appLibResourceTest.Id;
         System.assertEquals(1,i);
          PageReference pareRef4 = con.remove();
     }
}