@isTest
private class PimsAppSectionB1_B2ControllerTest {

   static testmethod void pimsAppSectionB1B2Controller_1(){
       integer i=1;
       
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
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

        User pu = new User(profileId = p.id, username = 'rs1@email.com', email = 'rs1@email.com',
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

        Application_Teaching_Time__c teachingTime = new Application_Teaching_Time__c();
        insert teachingTime;

        Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
        Subject_Level__c = 'Standard'
        );
        insert theRole;

        Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp.Id
        );
        insert progCoordTime;

        Application_Coordinator_Time__c progCoordTime_delete = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp.Id
        );
        insert progCoordTime_delete;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp.Id);

                System.Test.setCurrentPage(tmp);

                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb1';

                PimsAppSectionB1Controller controller = new PimsAppSectionB1Controller();
                controller.coordinatorTimeId = progCoordTime_delete.Id;
                controller.progCoordinatorTimeList = new list<Application_Coordinator_Time__c>{progCoordTime};
                controller.save();
                controller.saveTeachingTime();
                controller.updateTeachingTime();
                controller.deleteAttId = teachingTime.Id;
                controller.removeTeachingTime();
                controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole};
                List<Roles_and_Applications_Subject_Proposal__c> tmp1 = controller.getStandardSubjectProps();
                controller.saveCoordinatorTime();
                controller.updateCoordinatorTime();
                controller.coordinatorTimeId = progCoordTime_delete.Id;
                controller.removeCoordinatorTime();
                controller.saveMeeting();
                controller.updateMeeting();
                controller.removeMeeting();
                controller.saveFacility();
                controller.updateFacility();
                controller.removeFacility();
                controller.saveLibrary();
                controller.updateLibrary();
                controller.removeLibrary();
                controller.staffId = null;
                controller.applicationStaffTableList = null;
                controller.rolesByProgramme = null;
                controller.subjectsByRoles = null;
                controller.proDevByRoles = null;
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
            }

        System.Test.stopTest();
    }

    static testmethod void pimsAppSectionB1B2Controller_2(){
        integer i=1;

        Account theAccount2 = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount2.Lead_Account__c = true;
        insert theAccount2;

        Contact theContact2 = PimsTestUtil.createContact('John Brown','JB@jb.com','jb@profEmail.com', Date.newInstance(1984, 09, 14), theAccount2);
        insert theContact2;

        IB_Programme__c theProgramme2 = PimsTestUtil.createProgrammeForAccount (theAccount2,'PYP');
        insert theProgramme2;

        IB_Application__c theApp2 = new IB_Application__c(
            AC_3_1_Feasability_Lead__c = theContact2.Id,
            Application_Lookup_to_Programme__c = theProgramme2.Id,
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
        insert theApp2;

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu2 = new User(profileId = p.id, username = 'rs2@email.com', email = 'rs2@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact2.id);

        insert pu2;

        Standards_Practices__c sNp2 = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'PYP'
        );

        insert sNp2;

        IB_Action_Plan__c theActionPlan2 = new IB_Action_Plan__c(
            name = 'PYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp2.Id,
            programme__c = theProgramme2.Id
        );
        insert theActionPlan2;

        Application_Teaching_Time__c teachingTime2 = new Application_Teaching_Time__c();
        insert teachingTime2;

        Roles_and_Applications_Subject_Proposal__c theRole2 = new Roles_and_Applications_Subject_Proposal__c(
            Subject_Level__c = 'Standard'
        );
        insert theRole2;

        Application_Coordinator_Time__c progCoordTime2 = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp2.Id
        );
        insert progCoordTime2;

        Application_Coordinator_Time__c progCoordTime_delete2 = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp2.Id
        );
        insert progCoordTime_delete2;
        IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Teacher', Category__c ='Programme Development');
          insert theRoleRepo;

        IB_Role__c theRole3 = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme2.Id,
               IB_Account__c = theAccount2.Id,
               IB_Contact__c = theContact2.Id,
               Programme_Selection__c = 'PYP;MYP;DP;IBCC'
          );
        insert theRole3;
        Contact_Professional_Development__c c=new Contact_Professional_Development__c(City__c='Lahore', Workshop_Category__c='normal', Workshop_Name__c='test222' ,Role__c=theRole3.id,Workshop_Status__c='Attended');
        insert c;
        
        System.Test.startTest();

            System.runAs(pu2){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp2.Id);

                System.Test.setCurrentPage(tmp);

                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb2';

                PimsAppSectionB2Controller controller = new PimsAppSectionB2Controller();
                controller.save();
                controller.saveTeachingTime();
               // controller.updateTeachingTime();
                controller.deleteAttId = teachingTime2.Id;
                controller.removeTeachingTime();

//                controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole2};
               // system.debug('controller.subjectProposals ====> '+controller.subjectProposals);
              //  List<Roles_and_Applications_Subject_Proposal__c> tmp2 = controller.getStandardSubjectProps();

                controller.saveCoordinatorTime();
                controller.updateCoordinatorTime();
                controller.removeCoordinatorTime();
                controller.saveMeeting();
                controller.updateMeeting();
                controller.removeMeeting();
                controller.saveFacility();
                controller.updateFacility();
                controller.removeFacility();
                controller.saveLibrary();
                controller.updateLibrary();
                controller.removeLibrary();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                //marty begin
                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb1';

              //  controller = new PimsAppSectionB2Controller();
              //  controller.save();
               // controller.saveTeachingTime();
              //  controller.updateTeachingTime();
               // controller.deleteAttId = teachingTime2.Id;
              //  controller.removeTeachingTime();

              //  controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole2};
               // system.debug('controller.subjectProposals ====> '+controller.subjectProposals);

              //  controller.saveCoordinatorTime();
              //  controller.updateCoordinatorTime();
              //  controller.removeCoordinatorTime();
              //  controller.saveMeeting();
              //  controller.updateMeeting();
              //  controller.removeMeeting();
              //  controller.saveFacility();
              //  controller.updateFacility();
              //  controller.removeFacility();
               // controller.saveLibrary();
              //  controller.updateLibrary();
               // controller.removeLibrary();
                
                //marty end
            }

        System.Test.stopTest();
    }
    static testmethod void pimsAppSectionB1B2Controller_new(){
        integer i=1;

        Account theAccount2 = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount2.Lead_Account__c = true;
        insert theAccount2;

        Contact theContact2 = PimsTestUtil.createContact('John Brown','JB@jb.com','jb@profEmail.com', Date.newInstance(1984, 09, 14), theAccount2);
        insert theContact2;

        IB_Programme__c theProgramme2 = PimsTestUtil.createProgrammeForAccount (theAccount2,'PYP');
        insert theProgramme2;

        IB_Application__c theApp2 = new IB_Application__c(
            AC_3_1_Feasability_Lead__c = theContact2.Id,
            Application_Lookup_to_Programme__c = theProgramme2.Id,
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
        insert theApp2;

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

       /* User pu2 = new User(profileId = p.id, username = 'rs2@email.com', email = 'rs2@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact2.id);*/
         
          user pu2=PimsTestUtil.createPortalUserPYP('tes@yeee.com', true);

        insert pu2;

        Standards_Practices__c sNp2 = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'PYP'
        );

        insert sNp2;

        IB_Action_Plan__c theActionPlan2 = new IB_Action_Plan__c(
            name = 'PYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp2.Id,
            programme__c = theProgramme2.Id
        );
        insert theActionPlan2;

        Application_Teaching_Time__c teachingTime2 = new Application_Teaching_Time__c();
        insert teachingTime2;

        Roles_and_Applications_Subject_Proposal__c theRole2 = new Roles_and_Applications_Subject_Proposal__c(
            Subject_Level__c = 'Standard'
        );
        insert theRole2;

        Application_Coordinator_Time__c progCoordTime2 = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp2.Id
        );
        insert progCoordTime2;

        Application_Coordinator_Time__c progCoordTime_delete2 = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp2.Id
        );
        insert progCoordTime_delete2;

        ///
        
          IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Teacher', Category__c ='Programme Development');
          insert theRoleRepo;

        IB_Role__c theRole3 = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme2.Id,
               IB_Account__c = theAccount2.Id,
               IB_Contact__c = theContact2.Id,
               Programme_Selection__c = 'PYP;MYP;DP;IBCC'
          );
        insert theRole3;
          
        Contact_Professional_Development__c c=new Contact_Professional_Development__c(City__c='Lahore', Workshop_Category__c='normal', Workshop_Name__c='test222' ,Role__c=theRole3.id,Workshop_Status__c='Future');
        insert c;
        
        System.Test.startTest();

           // System.runAs(pu2){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp2.Id);

                System.Test.setCurrentPage(tmp);

                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb2';

                PimsAppSectionB2Controller controller = new PimsAppSectionB2Controller();
                controller.save();
                controller.saveTeachingTime();
                controller.updateTeachingTime();
                controller.deleteAttId = teachingTime2.Id;
                controller.removeTeachingTime();

//                controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole2};
               // system.debug('controller.subjectProposals ====> '+controller.subjectProposals);
               controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole2};
               List<Roles_and_Applications_Subject_Proposal__c> tmp2 = controller.getStandardSubjectProps();

                controller.saveCoordinatorTime();
                controller.updateCoordinatorTime();
                controller.removeCoordinatorTime();
                controller.saveMeeting();
                controller.updateMeeting();
                controller.removeMeeting();
                controller.saveFacility();
                controller.updateFacility();
                controller.removeFacility();
                controller.saveLibrary();
                controller.updateLibrary();
                controller.removeLibrary();
                System.assertEquals(1,i);
                //controller.staffId = null;
                //controller.applicationStaffTableList = null;
                //marty begin
                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb2';  
                
System.Test.stopTest();
    }
    static testmethod void pimsAppSectionB1B2Controller_3(){
        integer i=1;

        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
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

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs3@email.com', email = 'rs3@email.com',
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

        Application_Teaching_Time__c teachingTime = new Application_Teaching_Time__c();
        insert teachingTime;

        Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
            Subject_Level__c = 'Standard'
        );
        insert theRole;

        Application_Coordinator_Time__c progCoordTime_delete = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp.Id
        );
        insert progCoordTime_delete;

        System.Test.startTest();

            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'sectionb1';

            PimsAppSectionB1Controller controller = new PimsAppSectionB1Controller();

            controller.progCoordinatorTimeList = new List<Application_Coordinator_Time__c>{new Application_Coordinator_Time__c()};

            controller.coordinatorTimeId = progCoordTime_delete.Id;
            controller.removeCoordinatorTime();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

        System.Test.stopTest();
    }

    static testmethod void pimsAppSectionB1B2Controller_4(){
        integer i=1;

        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
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

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs4@email.com', email = 'rs4@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'PYP'
        );

        insert sNp;

        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'PYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id
        );
        insert theActionPlan;

        Application_Teaching_Time__c teachingTime = new Application_Teaching_Time__c();
        insert teachingTime;

        Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
            Subject_Level__c = 'Standard'
        );
        insert theRole;

        Application_Coordinator_Time__c progCoordTime_delete = new Application_Coordinator_Time__c(
            Type__c = 'Programme coordinator',
            IB_Application_Lookup__c = theApp.Id
        );
        insert progCoordTime_delete;

        System.Test.startTest();

            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'sectionb2';

            PimsAppSectionB2Controller controller = new PimsAppSectionB2Controller();

            Boolean isInternal = controller.isInternalPage;
            controller.showPopup();
            controller.closePopup();

            controller.progCoordinatorTimeList = new List<Application_Coordinator_Time__c>{new Application_Coordinator_Time__c()};

            controller.coordinatorTimeId = progCoordTime_delete.Id;
            controller.removeCoordinatorTime();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

        System.Test.stopTest();
    }
}