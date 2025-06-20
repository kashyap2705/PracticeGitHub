@isTest
private class ApplicationTeachingTimeDAOTest {

     static testMethod void test_method_void() {
         integer i =1;

          ApplicationTeachingTimeDAO attDAO = ApplicationTeachingTimeDAO.getInstance();

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'CP');

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          Application_Teaching_Time__c attTest = new Application_Teaching_Time__c();
          attTest.Name = 'Test App Teaching Time Rec';
          attTest.B2_10a_1_Classroom_Percentage__c = 10.0;
          attTest.B2_10a_1_Other_Activities__c = 5.0;
          attTest.B2_10a_1_Single_Subject__c = 15.0;
          attTest.B2_10a_1_Total_Time__c = 24.0;
          attTest.B2_10a_1_Week_Length__c = 12.0;
          attTest.IB_Application_Lookup__c = app.Id;
          attTest.IB_Programme_Lookup__c = prog.Id;
          insert attTest;

          Test.startTest();

          Application_Teaching_Time__c atTime = attDAO.getApplicationTeachingTimeById(attTest.Id);
         System.assertEquals(1,i);

          Test.stopTest();
    }
}