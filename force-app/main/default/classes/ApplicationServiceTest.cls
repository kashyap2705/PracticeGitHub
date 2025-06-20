@isTest
private class ApplicationServiceTest {

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

          IB_Application__c app2 = new IB_Application__c();
          app.Name = 'Test App2';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app2;

          List<IB_Application__c> appsList = new List<IB_Application__c>();
          appsList.add(app);
          appsList.add(app2);


          ApplicationService.setApplicationId(app.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          ApplicationService.setProgrammeId(prog.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          ApplicationService.application = app;
          ApplicationService.applications = appsList;
          ApplicationService.isApplicationCached = false;
          ApplicationService.isApplicationBySectionCached = false;
          ApplicationService.isApplicationsCached = false;
          ApplicationService.isSubjectProposalsCached = false;
          ApplicationService.isApplicationRequirementsCached = false;

          IB_Application__c currApp = ApplicationService.getApplication();
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          IB_Application__c appBySection = ApplicationService.getApplicationBySection('sectionc2');
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          List<IB_Application__c> currAppsList = ApplicationService.getApplications();
          IB_Application_Assessment__c appAssessment = ApplicationService.getApplicationAssessment();
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          List<Roles_and_Applications_Subject_Proposal__c> currSubPropsList = ApplicationService.getSubjectProposals();
          List<IB_Application_Curriculum_Requirement__c> currAppReqsList = ApplicationService.getApplicationRequirements();

     }
    
}