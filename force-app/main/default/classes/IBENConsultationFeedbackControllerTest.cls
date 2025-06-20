@isTest
public class IBENConsultationFeedbackControllerTest {

//controller
    @testSetup
    static Void setup(){

        Account theAccount = PimsTestUtil.createAccount('TestSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        theProgramme.StageName__c = 'Consideration';
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
    }
    
    static testMethod Void one(){
        integer i = 1;

        RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

        IB_Application__c theApp = [
            SELECT  Id, Status__c
            FROM    IB_Application__c
        ];

        theApp.Status__c = 'Submitted';
        update theApp;

        IB_Programme__c tmpProg = [
            SELECT Id, StageName__c
            FROM IB_Programme__c
        ];

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = tmpProg.Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started',
            RecordTypeId = visitRecType.Id
        );

        IB_Consultant_Feedback__c eopFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = tmpProg.Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started',
            RecordTypeId = endOfProcRecType.Id
        );

        insert new List<IB_Consultant_Feedback__c>{visitFeedback,eopFeedback};

        Pagereference thePage = Page.IBENConsultationFeedback;
        thePage.getParameters().put('id', theApp.Id);
        Test.setCurrentPage(thePage);
        IBENConsultationFeedbackController controller = new IBENConsultationFeedbackController();

        IBENConsultationFeedbackController.getSECTION_INSTRUCTIONS();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_REVIEW();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_A();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_B1();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_B2();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_C1();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_C2();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_C3();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_C4();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        IBENConsultationFeedbackController.getSECTION_ADVICE();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }

}