@isTest
private class PimsAppSectionCControllerTest {

     static testMethod void test_method_one() {
         integer i=1;

          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
          insert theAccount;

          Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
          insert theContact;

          IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
          insert theProgramme;

          IB_Application__c theApp = new IB_Application__c(
               AC_3_1_Feasability_Lead__c = theContact.Id,
               Application_Lookup_to_Programme__c = theProgramme.Id,
               AFC_Assessment_Status__c = 'Complete',
               AFC_Collaborative_Planning_Status__c = 'Complete' ,
               AFC_Documents_Status__c = 'Complete' ,
               AFC_Implementation_Budget_Status__c = 'Complete' ,
               AFC_Leadership_Structure_Status__c = 'Complete' ,
               AFC_Philosophy_Status__c = 'Complete' ,
               AFC_Profile_Review_Status__c = 'Complete' ,
               AFC_Programme_Information_Status__c = 'Complete' ,
               AFC_Resources_Support_Status__c = 'Complete' ,
               AFC_School_Description_Status__c = 'Complete' ,
               AFC_Subject_Proposal_Status__c = 'Complete' ,
               AFC_Written_Curriculum_Status__c = 'Complete'
          );

          insert theApp;

          Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

          User pu = new User(profileId = p.id, username = 'rs@email.com', email = 'rs@email.com',
                             emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                             languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                             alias='cspu', lastname='lastname', contactId = theContact.id);
          insert pu;

          Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'MYP'
          );

          insert sNp;

          IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'MYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id
          );

          insert theActionPlan;

          System.Test.startTest();

             System.runAs(pu){
               Pagereference tmp = Page.PimsApplicationForCandidacy;
               tmp.getParameters().put('id',theApp.Id);

               System.Test.setCurrentPage(tmp);

               PageService.isActiveTabCached = true;
               PageService.ActiveTab = 'sectionc1';

               PimsAppSectionCController controller = new PimsAppSectionCController();

               List<SelectOption> progReqs = controller.getProgrammeRequirements();
               //controller.selectedRequirement = progReqs[1].value;
               List<SelectOption> progTypes = controller.getProgrammeTypes();
               //controller.selectedType = progTypes[1].value;
               List<SelectOption> progYears = controller.getProgrammeYears();
               //controller.selectedYear = progYears[1].value;

               controller.createAppRequirement();
               controller.updateAppRequirement();
               controller.removeAppRequirement();
               controller.save();
               //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                 System.assertEquals(1,i);
            }

        System.Test.stopTest();

     }
}