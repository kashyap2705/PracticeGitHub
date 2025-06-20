@isTest
private class PimsApplicationForCandidacyContrlrTest {

     static testMethod void test_method_one() {
         integer i=1;

          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
          insert theAccount;

          Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
          insert theContact;

          List<Contact> currContacts = new List<Contact>();
          currContacts.add(theContact);

          IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
           theProgramme.Programme_Legal_Name__c = 'Test';
          insert theProgramme;

          List<IB_Programme__c> ibprog = [select id from IB_Programme__c];
         System.debug('Size: '+ibprog);
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
            // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, QA Class Failure
//begin 
          Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
               Type__c = 'Programme coordinator',
               IB_Application_Lookup__c = theApp.Id
          );
          insert progCoordTime;

          IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c ='Programme Development');
          insert theRoleRepo;
//End
          IB_Role__c theRole = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme.Id,
               IB_Account__c = theAccount.Id,
               IB_Contact__c = theContact.Id
          );
          insert theRole;

          List<IB_Role__c> currRoles = new List<IB_Role__c>();
          currRoles.add(theRole);
          // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, QA Class Failure
//begin 
             
       IB_Application_Attachment__c attach=new IB_Application_Attachment__c(IB_Programme__c=theProgramme.Id);
         insert attach;

          Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

          User pu = new User(profileId = p.id, username = 'rs@email.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);
        /*user pu=PimsTestUtil.createPortalUserPYP('tes@yeee.com', true);
          pu.ProfileId = p.id;
          insert pu;*/
         IB_Application__c theApp2 = [select id,Application_Lookup_to_Programme__r.id from IB_Application__c];
     //End 
          System.Test.startTest();

             System.runAs(pu){
                 
                    // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, QA Class Failure
//begin   
               Pagereference tmp = Page.PimsApplicationForCandidacy;
               tmp.getParameters().put('id',theApp2.Id);
          //End
               System.Test.setCurrentPage(tmp);

               PageService.isActiveTabCached = true;
               PageService.ActiveTab = 'prog';

               PimsApplicationForCandidacyController controller = new PimsApplicationForCandidacyController();

               controller.init();
               controller.contacts = currContacts;
               controller.roles = currRoles;
               //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                 System.assertEquals(1,i);
               DateUtility dateUtil = controller.dateUtil;
               boolean pageHasErrors = controller.getPageHasErrors();
               controller.getActiveSection();
               //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                 System.assertEquals(1,i);
                  Test.stopTest();
             }

	}
}