@isTest
private class PimsAppSubjectProposalControllerTest {
 
   static testmethod void testMYPPartner(){

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP Partner');
        insert theProgramme;
             system.debug('theProgramme###'+theProgramme);

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
            system.debug('theApp###'+theApp);

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
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

        String newSubjectProposalSubjectGroup = 'test';

        IB_Subject__c theSubject = new IB_Subject__c(
            IB_Programme__c = 'CP',
            Subject_Group__c = newSubjectProposalSubjectGroup,
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
        insert theSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            system.debug('theApp##'+theApp);
            system.debug('theApp.Id##'+theApp.Id);
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';

            PimsAppSubjectProposalController controller = new PimsAppSubjectProposalController();
            controller.newSubjectProposalSubjectGroup = newSubjectProposalSubjectGroup;
            Roles_and_Applications_Subject_Proposal__c tmp_1 = controller.editSubjectProposal;
            controller.save();
            controller.createSubjectProposal();
            controller.updateSubjectProposal();
            Roles_and_Applications_Subject_Proposal__c tmp1 = new Roles_and_Applications_Subject_Proposal__c();
            insert tmp1;
            controller.subjectProposalId = tmp1.Id;
            controller.removeSubjectProposal();
            controller.getSubjectGroups();
            controller.getSubjects();
            List<SelectOption> options = new List<SelectOption>();
            options = controller.getLanguageofInstruction();
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void testDiplomaProgramme(){

        try
        {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'Diploma Programme');
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

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
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

        String newSubjectProposalSubjectGroup = 'test';

        IB_Subject__c theSubject = new IB_Subject__c(
            IB_Programme__c = 'CP',
            Subject_Group__c = newSubjectProposalSubjectGroup,
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
        insert theSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';

            PimsAppSubjectProposalController controller = new PimsAppSubjectProposalController();
            controller.newSubjectProposalSubjectGroup = newSubjectProposalSubjectGroup;
            Roles_and_Applications_Subject_Proposal__c  tmp_1 = controller.editSubjectProposal;
            controller.save();
            controller.createSubjectProposal();
            controller.updateSubjectProposal();
            Roles_and_Applications_Subject_Proposal__c tmp1 = new Roles_and_Applications_Subject_Proposal__c();
            insert tmp1;
            controller.subjectProposalId = tmp1.Id;
            controller.removeSubjectProposal();
            controller.getSubjectGroups();
            controller.getSubjects();
            List<SelectOption> options = new List<SelectOption>();
            options = controller.getLanguageofInstruction();
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void testMYPPartnerSectionb(){

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP Partner');
        insert theProgramme;
             system.debug('theProgramme###'+theProgramme);

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
            system.debug('theApp###'+theApp);

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'es',
                           languagelocalekey = 'es', timezonesidkey = 'America/Los_Angeles',
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

        String newSubjectProposalSubjectGroup = 'test';

        IB_Subject__c theSubject = new IB_Subject__c(
            IB_Programme__c = 'MYP',
            Subject_Group__c = newSubjectProposalSubjectGroup,
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
        insert theSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            system.debug('theApp##'+theApp);
            system.debug('theApp.Id##'+theApp.Id);
            tmp.getParameters().put('id',theApp.Id);
			tmp.getParameters().put('tab','sectionb2');
            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'sectionb2';

            PimsAppSubjectProposalController controller = new PimsAppSubjectProposalController();
            controller.newSubjectProposalSubjectGroup = newSubjectProposalSubjectGroup;
            Roles_and_Applications_Subject_Proposal__c tmp_1 = controller.editSubjectProposal;
            controller.save();
            controller.createSubjectProposal();
            controller.updateSubjectProposal();
            Roles_and_Applications_Subject_Proposal__c tmp1 = new Roles_and_Applications_Subject_Proposal__c();
            insert tmp1;
            controller.subjectProposalId = tmp1.Id;
            controller.removeSubjectProposal();
            controller.getSubjectGroups();
            controller.getSubjects();
            List<SelectOption> options = new List<SelectOption>();
            options = controller.getLanguageofInstruction();
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
     
      static testmethod void testDPProgramme(){

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'DP');
        insert theProgramme;
             system.debug('theProgramme###'+theProgramme);

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
            system.debug('theApp###'+theApp);

        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'fr',
                           languagelocalekey = 'fr', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);
      
        insert pu;
       

        Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'DP'
        );

        insert sNp;

        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'MYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id
        );

        insert theActionPlan;

        String newSubjectProposalSubjectGroup = 'test';

        IB_Subject__c theSubject = new IB_Subject__c(
            IB_Programme__c = 'DP',
            Subject_Group__c = newSubjectProposalSubjectGroup,
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
        insert theSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            system.debug('theApp##'+theApp);
            system.debug('theApp.Id##'+theApp.Id);
            tmp.getParameters().put('id',theApp.Id);
			tmp.getParameters().put('tab','sectionb2');
            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'sectionb2';

            PimsAppSubjectProposalController controller = new PimsAppSubjectProposalController();
            controller.newSubjectProposalSubjectGroup = newSubjectProposalSubjectGroup;
            Roles_and_Applications_Subject_Proposal__c tmp_1 = controller.editSubjectProposal;
            controller.save();
            controller.createSubjectProposal();
            controller.updateSubjectProposal();
            Roles_and_Applications_Subject_Proposal__c tmp1 = new Roles_and_Applications_Subject_Proposal__c();
            insert tmp1;
            controller.subjectProposalId = tmp1.Id;
            controller.removeSubjectProposal();
            controller.getSubjectGroups();
            controller.getSubjects();
            List<SelectOption> options = new List<SelectOption>();
            options = controller.getLanguageofInstruction();
            system.debug('options##'+options);
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

}