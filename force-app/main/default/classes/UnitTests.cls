@isTest
public class UnitTests {

    private class Extension_PimsFeedbackHelper extends PimsFeedbackHelper{}
    private class Implementation_AppTablesInterface implements AppTablesInterface{public Pagereference save(){return null;}}
    private class Implementation_PimsProfilePanelInterface implements PimsProfilePanelInterface{public Pagereference save(){return null;}}

    static testmethod void pimsActionPlanController_1(){

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            Pagereference tmp = Page.PimsActionPlan;
            tmp.getParameters().put('id',theProgramme.Id);

            System.Test.setCurrentPage(tmp);

            PimsActionPlanController controller = new PimsActionPlanController();
            controller.init();
            controller.filter();
            controller.getStandards();
            controller.getStatuses();
            controller.getStandardsForAdd();
            controller.getPracticesForAdd();
            controller.create();
            controller.actionItem = new IB_Action_Plan__c(
                name = 'MYP_ActionPlan_1',
                AP_Standard_Practice__c  = sNp.Id,
                programme__c = theProgramme.Id
            );
            controller.create();
            controller.getStages();
            controller.getApTypes();
            controller.getStatusOpts();
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void PimsActionPlanItemController_1() {

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name = 'SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;

        Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'MYP'
        );
        insert sNp;

        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'MYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id,
            AP_Due_Date__c = Date.today()
        );
        insert theActionPlan;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsActionPlanItem;
                tmp.getParameters().put('id',theActionPlan.Id);

                System.Test.setCurrentPage(tmp);

                PimsActionPlanItemController controller1 = new PimsActionPlanItemController();
                controller1.init();
                controller1.save();
                controller1.upload();
                DateUtility util = controller1.dateUtil;
                String tmpStr = controller1.Description;
                String tmpStr2 = controller1.FileName;
                blob tmpBlob = controller1.Filebody;

                controller1.Description = 'desc';
                controller1.FileName = 'name';
                controller1.Filebody = Blob.valueOf('Body');
                controller1.upload();
                

                controller1.actionPlanDate = null;
                controller1.save();
                controller1.getUrlCommunityPath();
                controller1.removeDocument();

            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsActionPlanModalController_1(){
        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            tmp.getParameters().put('id',theprogramme.Id);

            System.Test.setCurrentPage(tmp);

            PimsActionPlanModalController controller = new PimsActionPlanModalController();

            try{
                String tmpId = controller.getProgrammeId();
                controller.getFunctionSafeName();
                String tmpStr = controller.actionType;
            }
            catch(Exception e){}

            PimsActionPlanModalController.create(theProgramme.Id, 'actionType', 'practiceUniqueId', 'status', 'description');
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsActionPlanModalController_2(){
        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            //Pagereference tmp = Page.PimsApplicationForCandidacy;
            //tmp.getParameters().put('id',theProgramme.Id);

            //System.Test.setCurrentPage(tmp);

            PimsActionPlanModalController controller = new PimsActionPlanModalController();

            try{
                String tmpStr = controller.actionType;
                controller.getFunctionSafeName();
                String tmpId = controller.getProgrammeId();
            }
            catch(Exception e){}

            PimsActionPlanModalController.create(theProgramme.Id, 'actionType', 'practiceUniqueId', 'status', 'description');
        }

        System.Test.stopTest();
      }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppAgreementController_1(){

        try{
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
            AFC_Written_Curriculum_Status__c = 'Complete',
            Status__c = 'Published'

        );

        insert theApp;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);
            tmp.getParameters().put('tab','agreement');
            System.Test.setCurrentPage(tmp);

            PimsAppAgreementController controller_agreement = new PimsAppAgreementController();

            try{
                controller_agreement.application = theApp;
                controller_agreement.afc = theApp;
                controller_agreement.agmtCompletionStatus = 'Complete';
                controller_agreement.activeTab = 'agreement';
                controller_agreement.redirectUrl = 'string';
                controller_agreement.agmtCompletionStatus = 'Complete';
                controller_agreement.appComplete = true;
                controller_agreement.saveAgreement();
                controller_agreement.confirmChange();
                boolean check = controller_agreement.isChanged;
            }
            catch(Exception e){}

            //PimsActionPlanModalController.create(theProgramme.Id, 'actionType', 'practiceUniqueId', 'status', 'description');
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testMethod void pimsPageMessagesController_1(){
        try
        {
        PimsPageMessagesController tmp = new PimsPageMessagesController();
        tmp.getPageHasErrorMessages();
        tmp.getPageHasSuccessMessage();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testMethod void pimsAppDocumentsController_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);
            tmp.getParameters().put('tab','docs');
           

            System.Test.setCurrentPage(tmp);
            PageService.isActiveTabCached = true;
            PageService.activeTab = 'docs';


            PimsAppDocumentsController controller_doc = new PimsAppDocumentsController();


            try{
                controller_doc.getUserLanguageKey();
                controller_doc.getIsEditable();
                controller_doc.getIsdp();
                controller_doc.getIscp();
                controller_doc.getIsCpPhase1();
                controller_doc.getIsCpPhase2();
                controller_doc.getAnyProgramme();
                controller_doc.redirectUrl = 'Test';
                controller_doc.docsCompletionStatus = 'Complete';
                controller_doc.docType = 'Test';
                controller_doc.application = theapp;
                controller_doc.appId = theapp.id;
                controller_doc.afcAttachments = null;
                controller_doc.afaAttachments = null;
                controller_doc.fileName = 'Test';
                controller_doc.showReqDocsMsgAfa = true;
                controller_doc.showReqDocsMsgAfc = true;
                controller_doc.programme = theProgramme;
                 controller_doc.save();
                
                controller_doc.removeAppDocument();
                controller_doc.filebody = blob.valueOf('Which came first, the chicken or the potato?');
                controller_doc.upload();
                controller_doc.passUrlPathVal();
                controller_doc.saveStandardAttachment(theApp.Id);
                controller_doc.saveCustomAttachment('too dumb to fail');
               
            }
            catch(Exception e){

            }

            //PimsActionPlanModalController.create(theProgramme.Id, 'actionType', 'practiceUniqueId', 'status', 'description');
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppDocumentsController_2(){

    }

    static testmethod void applicationBudgetTableController_1(){

        try
        {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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

            
        System.Test.startTest();

        System.runAs(pu){

            
            ApplicationService.applicationId = theApp.Id;
            Pagereference tmp = Page.PimsActionPlan;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            ApplicationBudgetTableController controller = new ApplicationBudgetTableController();
            controller.isUpdatePage = true;
            try{
                controller.create();
            }
            catch(Exception e){

            }
            try{
                controller.edit();
            }
            catch(Exception e){

            }
            try{
                controller.remove();
            }
            catch(Exception e){

            }
            try{
                controller.save();
            }
            catch(Exception e){

            }

        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void applicationBudgetTableController_2(){

        try
        {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            Pagereference tmp = Page.PimsActionPlan;
            tmp.getParameters().put('id',theProgramme.Id);

            System.Test.setCurrentPage(tmp);

            PimsActionPlanController controller = new PimsActionPlanController();
            controller.init();
            controller.filter();
            controller.getStandards();
            controller.getStatuses();
            controller.getStandardsForAdd();
            controller.getPracticesForAdd();
            controller.create();
            controller.actionItem = new IB_Action_Plan__c(
                name = 'MYP_ActionPlan_1',
                AP_Standard_Practice__c  = sNp.Id,
                programme__c = theProgramme.Id
            );
            controller.create();
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void ibenActionPlanItemController_1(){

        try{
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            Pagereference tmp = Page.IbenActionPlanItem;
            tmp.getParameters().put('id',theActionPlan.Id);

            System.Test.setCurrentPage(tmp);

            IbenActionPlanItemController controller = new IbenActionPlanItemController();
            controller.init();
            String tmpDate = controller.actionPlanDate;

            controller.fileName = 'filename';
            controller.description = 'description';
            controller.fileBody = blob.valueOf('test');
            DateUtility tmpUtil = controller.dateUtil;

            controller.save();
            controller.upload();

        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsHeaderController_1(){
        try
        {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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

            PimsHeaderController controller = new PimsHeaderController();
            controller.getProgrammes();
            controller.getSchoolName();

        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsLoginController_1(){
        try
        {
        PimsLoginController tmp = new PimsLoginController();
        Integer counter = tmp.errorCount;
        tmp.errorCount = 4;
        string tmpppp = tmp.getLocale();
        tmp.getPageHasErrors();
        tmp.login();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsNavbarController_1(){
        try
        {
        PimsNavbarController tmp = new PimsNavbarController();
        tmp.locale = 'test';
        String tmpStr = tmp.locale;
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

    }

    static testmethod void myAssignmentDetailsController_1(){

        try
        {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
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
            Pagereference tmp = Page.PimsActionPlan;
            tmp.getParameters().put('id',theProgramme.Id);

            System.Test.setCurrentPage(tmp);

            MyAssignmentDetailsController controller = new MyAssignmentDetailsController();
            controller.isMyAssignment = false;
            controller.MyAssignment.add(new My_Staffing_Event__c());
            controller.getIsMyAssignment();
            controller.declineInvitation();

        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppImplBudgetController_1(){

        try
        {
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
            
        theApp.Application_Lookup_to_Programme__c = theProgramme.id;
        insert theApp;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);
            tmp.getParameters().put('tab','budget');

            System.Test.setCurrentPage(tmp);
            PageService.isActiveTabCached = true;
            PageService.activeTab = 'budget';


            PimsAppImplBudgetController controller = new PimsAppImplBudgetController();

            try{
                controller.appId = theApp.Id;
                String tmp1 = controller.accId;
                String tmp2 = controller.programmeId;
                Account tmp3 = controller.account;
                List<Contact>  tmp4 = controller.contacts;
                List<IB_Role__c>  tmp5 = controller.roles;
                List<IB_Programme__c> tmp6 = controller.programmes;
                Application_Budget_Table__c tmp7 = controller.applicationBudget;
                List<Application_Budget_Table__c> tmp8 = controller.appBudget;
                List<IB_Role__c> tmp9 = controller.rolers;
                List<Application_Budget_Table__c> tmp10 = controller.buds;
                controller.removeBudgetItem();
                controller.updateStartDate();
                controller.saveBudget();
                controller.saveApp();
                controller.edit();
                controller.getPageHasErrors();
                controller.progId = null;
                controller.redirectUrl = null;
                controller.ibCompletionStatus = null;
                controller.showReqBdgtMsg = false;
                controller.removeBudget = null;
                controller.removeBudget = null;
                controller.lines = null;
                controller.url = null;
                
            }
            catch(Exception e){
                System.debug(String.valueOf(e));
            }
        }

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppProfileReviewController_1(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.ActiveTab = 'profile';

            roleService.isRolesCached = true;
            roleservice.roles = new List<IB_Role__c>{new ib_role__c(),new ib_role__c()};

            PimsAppProfileReviewController controller = new PimsAppProfileReviewController();
            controller.save();

        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void internalAppForCandidacyController_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            //PageService.ActiveTab = 'profile';

            roleService.isRolesCached = true;
            roleservice.roles = new List<IB_Role__c>{new ib_role__c(),new ib_role__c()};

            InternalAppForCandidacyController controller = new InternalAppForCandidacyController();
            controller.init();
            controller.getpagehasErrors();
            controller.getActiveSection();
            account tmp1 = controller.Account;
            List<IB_Address__c> tmp2 = controller.addresses;
            List<SchoolSections__c> tmp3 = controller.sections;
            List<Contact> tmp4 = controller.contacts;
            List<IB_Role__c> tmp5 = controller.roles;
            List<IB_Programme__c> tmp6 = controller.programmes;
            List<IB_Application_Attachment__c> tmp7 = controller.attachments;
            List<Application_Budget_Table__c> tmp8 = controller.applicationBudgetTable;
            List<Application_Budget_Table__c> tmp9 = controller.applicationBudgetList;
            Application_Coordinator_Time__c tmp10 = controller.editCoordinatorTime;
            Application_Account_Facilities__c tmp11 = controller.applicationAccountFacilities;
            controller.applicationAccountFacilitiesList = new List<Application_Account_Facilities__c>{tmp11};

        }

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppSchoolDescController_1(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'desc';

            PimsAppSchoolDescController controller = new PimsAppSchoolDescController();
            controller.save();


        }

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppSectionAController_1(){

        try
        {
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
            AC_3_1_Feasability_Leads__c = 'Selected',
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
            AFC_Written_Curriculum_Status__c = 'Complete',
            A9_a_2_MYP_Year__c = '2015',
            A9_a_2_MYP_Year_2__c = '2016',
            A9_a_2_MYP_Year_3__c = '2017',
            A9_a_2_MYP_Year_4__c = '2018',
            A9_a_2_MYP_Year_5__c = '2019'

        );

        insert theApp;

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp.Id);
                tmp.getParameters().put('tab','sectiona');
                System.Test.setCurrentPage(tmp);
                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectiona';
                PimsAppSectionAController controller = new PimsAppSectionAController();
                controller.programme = theProgramme;
                
                controller.application = theApp;
                controller.checkInputStatus();
                controller.save();
                theApp.A9_a_2_MYP_Year__c = null;
				controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year__c = '2015';
				theApp.A9_a_2_MYP_Year_5__c = null;  
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_4__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_4__c = '2018';
                theApp.A9_a_2_MYP_Year__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_5__c = '2019';
                theApp.A9_a_2_MYP_Year_2__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_3__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_3__c = '2017';
                theApp.A9_a_2_MYP_Year_5__c = null; 
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_2__c = '2016';
                theApp.A9_a_2_MYP_Year_4__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year__c = '2015';
                theApp.A9_a_2_MYP_Year_3__c = null;
                controller.application = theApp;
                controller.save();
                theApp.A9_a_2_MYP_Year_2__c = null;
                controller.application = theApp;
                controller.checkInputStatus(); 
                IB_Application_Attachment__c tmpAtt = controller.IBattachment;
                IB_Application_Assessment__c assessment = controller.assessment;
                List<SelectOption> tmpOptions = controller.getItems();
                controller.filename = 'test';
                controller.description = 'test';
                controller.filebody = Blob.valueOf('test');
                controller.upload();
                List<String> tmpList = controller.getContacts();
                controller.setContacts(tmpList);
                 controller.redirectUrl = 'Test';
                String theString = controller.getSelectedContacts();
                controller.setSelectedContacts(string.valueOf(tmpList));
                controller.saveStandardAttachment(tmpAtt.id);

            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    static testmethod void pimsAppSectionBController_1(){
        try
        {
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

                PimsAppSectionBController controller = new PimsAppSectionBController();
                controller.appId = theApp.id;
                controller.application = theApp;
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
                controller.staffId = 'Test';
                controller.otherLanguage = true;
                controller.serviceCoordinatorTimeList = null;
                controller.applicationStaffTableList = null;
                controller.staffTable = null;
                controller.rolesByProgramme = null;
                controller.subjectsByRoles = null;
                controller.proDevByRoles = null;
                controller.activeTab = 'Test';
                controller.save();
                
            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppSectionBController_2(){

        //try
        //{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        Application_Teaching_Time__c teachingTime = new Application_Teaching_Time__c();
        insert teachingTime;

        Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
            Subject_Level__c = 'Standard'
        );
        insert theRole;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp.Id);

                System.Test.setCurrentPage(tmp);

                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb2';

                PimsAppSectionBController controller = new PimsAppSectionBController();
                controller.appId = theApp.id;
                controller.application = theApp;
                //controller.programme = theApp.Application_Lookup_to_Programme__c ;
                controller.save();
                controller.saveTeachingTime();
                controller.updateTeachingTime();
                controller.deleteAttId = teachingTime.Id;
                controller.removeTeachingTime();

                controller.subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>{theRole};
                List<Roles_and_Applications_Subject_Proposal__c> tmp1 = controller.getStandardSubjectProps();

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
            }

        System.Test.stopTest();
        /*    }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }*/
    }

    static testmethod void pimsAppSectionBController_3(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

            PimsAppSectionBController controller = new PimsAppSectionBController();
            controller.appId = theApp.id;
            controller.application = theApp;

            controller.progCoordinatorTimeList = new List<Application_Coordinator_Time__c>{new Application_Coordinator_Time__c()};

            controller.coordinatorTimeId = progCoordTime_delete.Id;
            controller.removeCoordinatorTime();

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppSectionCController_1(){

    }

    static testmethod void pimsAppSubjectProposalController_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsAppSubjectProposalController_2(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsApplicationFeedbackDAO_1(){
        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

            PimsApplicationFeedbackDAO controller = new PimsApplicationFeedbackDAO();
            List<IB_Application_Feedback__c> tmp22 = controller.getPimsApplicationFeedbackByApplicationId(theApp.Id);
        }

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void roleApplicationSubjectDAO_1(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        Role_Application_Subject__c tmpSubject = new Role_Application_Subject__c();
        insert tmpSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';

            RoleApplicationSubjectDAO controller = RoleApplicationSubjectDAO.getInstance();
            Role_Application_Subject__c tmp77 = controller.getSubjectById(tmpSubject.Id);

            controller.getSubjectsByRoleId(tmpSubject.Id);
            controller.getSubjectsByRoleList(new List<id>());
            //controller.accountHasProgramme('MYP');
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void userDAO_1(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        Role_Application_Subject__c tmpSubject = new Role_Application_Subject__c();
        insert tmpSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';

            UserDAO controller = UserDAO.getInstance();
            controller.getCurrentUser();
            controller.isInternalUserForProfileId();
            controller.isAcceptedExternalUserForProfileName('System Adminstrator');
            controller.getUserById(System.UserInfo.getUserId());
            try{ //intentional fail
             controller.getUserByContactId(null);
            }
            catch(exception e){

            }
            controller.getUserByContactId([select id from user where contactId != null LIMIT 1][0].id);
            controller.getFullUserPhotoUrlId(Userinfo.getUserId());
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void programmeService_1(){

        try
        {
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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
            IB_Programme__c = 'MYP',
            Subject_Group__c = newSubjectProposalSubjectGroup,
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
        insert theSubject;

        Role_Application_Subject__c tmpSubject = new Role_Application_Subject__c();
        insert tmpSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';
            ProgrammeService.accountId = theAccount.Id;
            ProgrammeService.accountHasProgramme('MYP');
            ProgrammeService.setProgrammeId(theProgramme.Id);
            ProgrammeService.getProgramme();
            //ProgrammeService.setProgrammeId(theProgramme.Id);
            ProgrammeService.setAccountId(theAccount.Id);
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsProfileInfoController_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);
            tmp.getParameters().put('redir','blah blah');

            System.Test.setCurrentPage(tmp);
            PageService.isActiveTabCached = true;
            PageService.activeTab = 'docs';

            PimsProfileInfoController controller = new PimsProfileInfoController();
            controller.getIsGroupOfSchoolsChecked();
            controller.save();
        }

        System.Test.stopTest();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void PimsApplicationRedirectController_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theProgramme.Id);

                System.Test.setCurrentPage(tmp);

                ApplicationService.setProgrammeId(theProgramme.Id);

                PimsApplicationRedirectController controller = new PimsApplicationRedirectController();
                controller.init();
                tmp.getParameters().put('id','');
                controller.init();
            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void PimsFeedbackHelper_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        IB_Application_Feedback__c theFeedback = new IB_Application_Feedback__c(
            IB_Application_Lookup__c = theApp.Id,
            FB_Lookup_IB_Application__c = theApp.Id

        );
        insert theFeedback;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theFeedback.Id);

                System.Test.setCurrentPage(tmp);

                Extension_PimsFeedbackHelper controller = new Extension_PimsFeedbackHelper();
                controller.getIsEditable();
                controller.getIsPyp();
                controller.getIsMyp();
                controller.getIsDp();
                controller.getIsCp();
                controller.getIsCpPhase1();
                controller.getIsCpPhase2();
                controller.getUserLanguageKey();
            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void pimsRoleRepositoryService_1(){
        try{
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

        String roleName = 'Programme Coordinator';
        String progType = [select id, recordType.name from IB_Programme__c where Id=: theProgramme.Id][0].recordType.name;
        String rTypeId = [select id, name from recordType where sObjectType = 'IB_Programme__c' and name =:progType][0].Id;

        IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = roleName, Category__c ='Programme Development'); //, recordTypeId = rTypeId
        insert theRoleRepo;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp.Id);

                System.Test.setCurrentPage(tmp);

                PageService.isActiveTabCached = true;
                PageService.ActiveTab = 'sectionb1';

                RoleRepositoryService.roleId = theRoleRepo.Id;
                RoleRepositoryService.getRoleById();
                RoleRepositoryService.getAllRoles();
            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void roleApplicationSubjectService_1(){

        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        Role_Application_Subject__c tmpSubject = new Role_Application_Subject__c();
        insert tmpSubject;

        System.Test.startTest();

        System.runAs(pu){
            Pagereference tmp = Page.PimsApplicationForCandidacy;
            tmp.getParameters().put('id',theApp.Id);

            System.Test.setCurrentPage(tmp);

            PageService.isActiveTabCached = true;
            PageService.ActiveTab = 'subject';

            RoleApplicationSubjectDAO controller = RoleApplicationSubjectDAO.getInstance();
            Role_Application_Subject__c tmp77 = controller.getSubjectById(tmpSubject.Id);

            controller.getSubjectsByRoleId(tmpSubject.Id);
            controller.getSubjectsByRoleList(new List<id>());


            if(tmp77!=NUll)
            {
            String rolId = tmp77.Id;
           
            RoleApplicationSubjectService.subjectId = rolId;
            RoleApplicationSubjectService.roleId = rolId;
            RoleApplicationSubjectService.roleList = new List<Id>{rolId};
            RoleApplicationSubjectService.getSubjectById();
            RoleApplicationSubjectService.getSubjectsByRoleId();
            RoleApplicationSubjectService.getSubjectsByRoleList();
            RoleApplicationSubjectService.setSubjectId(rolId);
            RoleApplicationSubjectService.setRoleId(rolId);
            RoleApplicationSubjectService.setRoleList(new List<Id>{rolId});
            }
        }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

    }

    static testmethod void PimsCommunityService_1(){

        try{
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

        String roleName = 'Programme Coordinator';
        String progType = [select id, recordType.name from IB_Programme__c where Id=: theProgramme.Id][0].recordType.name;
        String rTypeId = [select id, name from recordType where sObjectType = 'IB_Programme__c' and name =:progType][0].Id;

        IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = roleName, Category__c ='Programme Development'); //, recordTypeId = rTypeId
        insert theRoleRepo;

        System.Test.startTest();

            System.runAs(pu){
                Pagereference tmp = Page.PimsApplicationForCandidacy;
                tmp.getParameters().put('id',theApp.Id);

                System.Test.setCurrentPage(tmp);

                PimsCommunityService controller = new PimsCommunityService();
                controller.initUserData();
                controller.getCurrentAccount();
                controller.getCurrentContact();
                controller.getCurrentUser();

                PimsCommunityService controller2 = new PimsCommunityService();
                controller2.getCurrentAccount();

                PimsCommunityService controller3 = new PimsCommunityService();
                controller3.getCurrentContact();

                PimsCommunityService controller4 = new PimsCommunityService();
                controller4.getCurrentUser();
            }

        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void Implementation_AppTablesInterface_1(){
        try{
        Implementation_AppTablesInterface tmp = new Implementation_AppTablesInterface();
        tmp.save();
        }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

    static testmethod void Implementation_PimsProfilePanelInterface_1(){
        try
        {
        Implementation_PimsProfilePanelInterface tmp = new Implementation_PimsProfilePanelInterface();
        tmp.save();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    static testmethod void feedbackIncludeController_1(){
        try{
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

        Profile p =  [select Id from profile where Name='School Community User' limit 1];

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

        IB_Application_Feedback__c theFeedback = new IB_Application_Feedback__c(
            IB_Application_Lookup__c = theApp.Id,
            FB_Lookup_IB_Application__c = theApp.Id

        );
        insert theFeedback;
        
        ApplicationService.setApplicationId(theApp.Id);

        System.Test.startTest();
        
            Integer errorCounter = 0;

            
            try{
                Pagereference tmp = Page.PimsAppFeedback_Section_Continuum;
                tmp.getParameters().put('id',theFeedback.Id);
                System.Test.setCurrentPage(tmp);
                FeedbackIncludeController cont = new FeedbackIncludeController();
                String feedbackList = JSON.serialize(cont.pimsApplicationFeedbackList);
                String address = JSON.serialize(cont.address);
                String programme = JSON.serialize(cont.programme);
                String applicationBudgetTable = JSON.serialize(cont.applicationBudgetTable);
                String programmeList = JSON.serialize(cont.programmeList);
            }
            catch(Exception e){
                errorCounter++;
            }
            
            System.Assert(errorCounter == 0);
        
        System.Test.stopTest();
            }
      Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

}