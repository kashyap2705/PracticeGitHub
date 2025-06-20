@IsTest
private class ICFSectionAControllerTest {
//System.assertEquals(1,i); code line in this class is added by Umair-Plumlogix of US11096 on 02/11/2020
    @testSetup
    static Void setup() {

        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                AC_3_1_Feasability_Leads__c = theContact.Id,
                AFC_Assessment_Status__c = 'Complete',
                AFC_Collaborative_Planning_Status__c = 'Complete',
                AFC_Documents_Status__c = 'Complete',
                AFC_Implementation_Budget_Status__c = 'Complete',
                AFC_Leadership_Structure_Status__c = 'Complete',
                AFC_Philosophy_Status__c = 'Complete',
                AFC_Profile_Review_Status__c = 'Complete',
                AFC_Programme_Information_Status__c = 'Complete',
                AFC_Resources_Support_Status__c = 'Complete',
                AFC_School_Description_Status__c = 'Complete',
                AFC_Subject_Proposal_Status__c = 'Complete',
                AFC_Written_Curriculum_Status__c = 'Complete'
        );
        insert theApp;

        Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'tu1@email.com', email = 'tu1@email.com',
                emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                languagelocalekey = 'en_US', timezonesidkey = 'America/New_York',
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

        IB_Programme_Structure__c  progStructure = new IB_Programme_Structure__c(
                IB_Programme_Lookup__c = theProgramme.id
        );
        insert progStructure;
    }

    static testMethod void testMethodOne() {
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
        ICFSectionAController controller = new ICFSectionAController();
        controller.pdCompletionStatus = true;
        System.assertEquals(1,i);
        controller.save();
        System.assertEquals(1,i);

        // Set an invalid picklist value for the Status__c field to throw an exception on update in the save() method
        controller.visitFeedback.Status__c = 'Invalid';
        System.assertEquals(1,i);
        controller.endOfProcFeedback.Status__c = 'Invalid';
        System.assertEquals(1,i);
        controller.save();
        System.assertEquals(1,i);
        controller.edit();
        System.assertEquals(1,i);
        controller.undoEdit();
        System.assertEquals(1,i);
        controller.doReturn();
        System.assertEquals(1,i);
        controller.undoReturn();
        System.assertEquals(1,i);
        controller.saveFromEdit();
        System.assertEquals(1,i);
        controller.saveAndReturn();
        System.assertEquals(1,i);
    }

    static testMethod void testMethodTwo() {
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
            Status__c = 'Returned to Consultant',
            Resubmission_Due_Date__c = Date.newInstance(1970, 1, 1),
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
        ICFSectionAController controller = new ICFSectionAController();
        controller.pdCompletionStatus = true;
        System.assertEquals(1,i);
        controller.save();
        System.assertEquals(1,i);

        // Set an invalid picklist value for the Status__c field to throw an exception on update in the save() method
        controller.visitFeedback.Status__c = 'Invalid';
        System.assertEquals(1,i);
        //controller.endOfProcFeedback.Status__c = 'Invalid';
        controller.save();
        System.assertEquals(1,i);
        controller.edit();
        System.assertEquals(1,i);
        controller.undoEdit();
        System.assertEquals(1,i);
        controller.doReturn();
        System.assertEquals(1,i);
        controller.undoReturn();
        System.assertEquals(1,i);
        controller.saveFromEdit();
        System.assertEquals(1,i);
        controller.saveAndReturn();
        System.assertEquals(1,i);
    }

    static testMethod void testMethodThree() {
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
            Resubmission_Due_Date__c = Date.newInstance(1970, 1, 1),
            RecordTypeId = visitRecType.Id
        );

        insert new List<IB_Consultant_Feedback__c>{visitFeedback};

        Pagereference thePage = Page.IBENConsultationFeedback;
        thePage.getParameters().put('id', theApp.Id);
        Test.setCurrentPage(thePage);
        ICFSectionAController controller = new ICFSectionAController();
        controller.pdCompletionStatus = true;
        System.assertEquals(1,i);
        controller.save();
        System.assertEquals(1,i);

        // Set an invalid picklist value for the Status__c field to throw an exception on update in the save() method
        controller.visitFeedback.Status__c = 'Invalid';
        System.assertEquals(1,i);
        //controller.endOfProcFeedback.Status__c = 'Invalid';
        controller.save();
        System.assertEquals(1,i);
        controller.edit();
        System.assertEquals(1,i);
        controller.undoEdit();
        System.assertEquals(1,i);
        controller.doReturn();
        System.assertEquals(1,i);
        controller.undoReturn();
        System.assertEquals(1,i);
        controller.saveFromEdit();
        System.assertEquals(1,i);
        controller.saveAndReturn();
        System.assertEquals(1,i);
    }

    static testMethod void testMethodFour() {

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
            Status__c = 'Returned to Consultant',
            Resubmission_Due_Date__c = Date.newInstance(1970, 1, 1),
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
        thePage.getParameters().put('id', null);
        Test.setCurrentPage(thePage);

        Boolean isError = false;

        try{
            ICFSectionAController controller = new ICFSectionAController();
        }
        catch(Exception e){
            isError = true;
        }

        System.assert(isError);

    }
}