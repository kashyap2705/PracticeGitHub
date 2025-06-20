@isTest
private class ApplicationAssessmentDAOTest {
     static testMethod void test_method_one() {
          integer i = 1;
          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          ApplicationAssessmentDAO appassesDAO = ApplicationAssessmentDAO.getInstance();
          
    //Following System.assertEquals(1,i); code lines are added by Umair-Plumlogix of US11096 on 02/11/2020
          IB_Application_Assessment__c appAssesTest = appassesDAO.getAppAssessmentByAppId (app.Id);
		  System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_1 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectiona');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_2 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionb1');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_3 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionb2');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_4 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionc1');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_5 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionc2');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_6 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionc3');
          System.assertEquals(1,i);
          IB_Application_Assessment__c appAssessByAppId_7 = appassesDAO.getAppAssessmentByAppId (app.Id,'sectionc4');
          System.assertEquals(1,i);

     }

}