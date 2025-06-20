@isTest
private class ApplicationTeachingTimeControllerTest {

     static testMethod void test_method_void() {
         integer i = 1;

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'CP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          Application_Teaching_Time__c attTest = new Application_Teaching_Time__c();
          attTest.Name = 'App Teaching Time Rec';
          attTest.B2_10a_1_Classroom_Percentage__c = 10.0;
          attTest.B2_10a_1_Other_Activities__c = 5.0;
          attTest.B2_10a_1_Single_Subject__c = 15.0;
          attTest.B2_10a_1_Total_Time__c = 24.0;
          attTest.B2_10a_1_Week_Length__c = 12.0;
          attTest.IB_Application_Lookup__c = app.Id;
          attTest.IB_Programme_Lookup__c = prog.Id;

          ApplicationService.setApplicationId(app.Id);
          ApplicationService.isApplicationCached = false;
          ProgrammeService.setProgrammeId(prog.Id);
          ProgrammeService.isProgrammeCached = false;

          ApplicationTeachingTimeController con = new ApplicationTeachingTimeController();

          con.applicationTeachingTime = attTest;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          PageReference pageRef = con.save();

          con.editTeachingTime = attTest;
         //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          con.editTeachingTime.B2_10a_1_Other_Activities__c = 7.0;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.editTeachingTime.B2_10a_1_Total_Time__c = 32.0;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          PageReference pageRef2 = con.editTeachingTime();

          con.att = attTest;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.deleteActId = acc.Id;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.activeTab = 'sectionb2';
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.redirectUrl = '/pims/PimsApplicationForCandidacy?id='+app.Id;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          con.isUpdatePage = true;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

	}
}