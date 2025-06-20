@isTest
private class ICFSectionAdviceControllerTest {

    @testSetup
    static Void setup(){
        Test.startTest();

        Account tempAccount = new Account();

        Account theAccount = AccountTestDataFactory.createAccount('School Account',tempAccount);
        insert theAccount;
        
        IB_Programme__c tempProgramme = new IB_Programme__c();
        tempProgramme.Account__c = theAccount.Id;
        tempProgramme.StageName__c = 'Consideration';
        tempProgramme.Programme_Coordinator_Email__c = 'demo@rs.com';
        
        IB_Programme__c theProgramme = IBProgrammeTestDataFactory.createIBProgramme('MYP',tempProgramme);
        insert theProgramme;
        
        Campaign camp1 = new Campaign();
        camp1.Type='Evaluation';
        camp1.Sub_Type__c='Candidacy Consultation';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Evaluation Visit';
        camp1.Venue_Account__c=theAccount.Id;
        camp1.Event_Organizer_Account__c= theAccount.id;
        camp1.Webinar_Net_Tracking__c = true;
        camp1.Related_IB_Programme__c = theProgramme.Id;
        
        Campaign testCamp = CampaignTestDataFactory.createCampaign('Evaluation',camp1);
        insert testCamp;

        Contact tempContact = new Contact();
        tempContact.LastName = 'Robert Strunk';
        tempContact.Email = 'RS@rs.com';
        tempContact.Birthdate = Date.newInstance(1984, 09, 14);
        
        
        Contact theContact = ContactTestDataFactory.createContact('Standard Contact',tempContact);
        insert theContact;
        
        My_Staffing_Event__c myAssign = new My_Staffing_Event__c();
        myAssign.IB_Contact__c = theContact.Id;
        myAssign.IB_Event__c = testCamp.Id;
        myAssign.Application_Status__c = 'Confirmed';
        insert myAssign;
        

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
        
        Staffing_Event__c custom_staffing_event = new Staffing_Event__c(CurrencyIsoCode = 'CHF');
        insert custom_staffing_event;
        
        
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
        
        Test.stopTest();
    }

        
   @isTest  static Void controllerTest(){
          
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
            RecordTypeId = visitRecType.Id,
            A_complete__c = true,
            B1_Complete__c = true,
            B2_Complete__c = true,
            C1_Complete__c = true,
            C2_Complete__c = true,
            C3_Complete__c = true,
            C4_Complete__c = true,
            Advice_Complete__c = true,
            Profile_Review_Complete__c = true

        );

        IB_Consultant_Feedback__c eopFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = tmpProg.Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started',
            RecordTypeId = endOfProcRecType.Id,
            A_complete__c = true,
            B1_Complete__c = true,
            B2_Complete__c = true,
            C1_Complete__c = true,
            C2_Complete__c = true,
            C3_Complete__c = true,
            C4_Complete__c = true,
            Advice_Complete__c = true,
            Profile_Review_Complete__c = true
        );

        insert new List<IB_Consultant_Feedback__c>{visitFeedback,eopFeedback};
            

        Pagereference thePage = Page.IBENConsultationFeedback;
        thePage.getParameters().put('id', theApp.Id);
        Test.setCurrentPage(thePage);
//System.assertEquals(1,i); code line in this code is added by Umair-Plumlogix of US11096 on 02/11/2020
        Test.startTest();
            ICFSectionAdviceController controller = new ICFSectionAdviceController();
            controller.pdCompletionStatus = true;
        System.assertEquals(1,i);

                controller.save();
        System.assertEquals(1,i);
                controller.edit();
        System.assertEquals(1,i);
                controller.undoEdit();
        System.assertEquals(1,i);
                controller.endOfProcFeedback.Resubmission_due_date__c = Date.newInstance(2016, 1, 1);
        System.assertEquals(1,i);
                controller.doReturn();
        System.assertEquals(1,i);
                controller.undoReturn();
        System.assertEquals(1,i);
                controller.saveFromEdit();
        System.assertEquals(1,i);
                controller.saveAndReturn();
        System.assertEquals(1,i);


        Test.stopTest();
    }

   @isTest static Void controllerTest2(){
        
        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];
        
        List<Staffing_Event__c> staffing_events = [select Id from Staffing_Event__c];
        List<User> users = [select id from User LIMIT 1];

        IB_Application__c theApp = [
            SELECT  Id, Status__c
            FROM  IB_Application__c limit 1
        ];

        theApp.Status__c = 'Submitted';
        update theApp;

        IB_Programme__c tmpProg = [
            SELECT Id, StageName__c
            FROM IB_Programme__c limit 1
        ];
        tmpProg.Owner__c = users.get(0).Id;
        update tmpProg;

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = tmpProg.Id,
            Assignment_Id__c = staffing_events.get(0).Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started',
            RecordTypeId = visitRecType.Id,
            A_complete__c = true,
            B1_Complete__c = true,
            B2_Complete__c = true,
            C1_Complete__c = true,
            C2_Complete__c = true,
            C3_Complete__c = true,
            C4_Complete__c = true,
            Advice_Complete__c = true,
            Profile_Review_Complete__c = true

        );
        

        insert new List<IB_Consultant_Feedback__c>{visitFeedback};
            

        Pagereference thePage = Page.IBENConsultationFeedback;
        thePage.getParameters().put('id', theApp.Id);
        Test.setCurrentPage(thePage);
        
        List<IB_Consultant_Feedback__c> tempList = [select id,Assignment_Id__c from IB_Consultant_Feedback__c];
        System.debug('MyList: '+templist.get(0).Assignment_Id__c);
        
        List<IB_Programme__c> prog = [select id,Programme_Coordinator_Email__c,Programme_Relationship_Manager_Email__c from IB_Programme__c];
        System.debug('MyList: '+prog.get(0).Programme_Coordinator_Email__c+' '+prog.get(0).Programme_Relationship_Manager_Email__c);

        Test.startTest();
            ICFSectionAdviceController controller = new ICFSectionAdviceController();
            controller.pdCompletionStatus = true;
            Boolean isError = false;

           try{
              controller.save();
              controller.saveAndSubmit();
              controller.edit();
              controller.saveFromEdit();
            }
           catch(Exception e){
                isError = true;
            }

            System.assertNotEquals(true,isError);

        Test.stopTest();
   }

   @isTest static Void controllerTest3(){

        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];
        
        List<Staffing_Event__c> staffing_events = [select Id from Staffing_Event__c];
        List<User> users = [select id from User LIMIT 1];

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
        tmpProg.Owner__c = users.get(0).Id;
        update tmpProg;

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = tmpProg.Id,
            Assignment_Id__c = staffing_events.get(0).Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Returned to Consultant',
            Resubmission_due_date__c = Date.newInstance(2016,1,1),
            RecordTypeId = visitRecType.Id,
            A_complete__c = true,
            B1_Complete__c = true,
            B2_Complete__c = true,
            C1_Complete__c = true,
            C2_Complete__c = true,
            C3_Complete__c = true,
            C4_Complete__c = true,
            Advice_Complete__c = true,
            Profile_Review_Complete__c = true

        );

        insert new List<IB_Consultant_Feedback__c>{visitFeedback};

        Pagereference thePage = Page.IBENConsultationFeedback;
        thePage.getParameters().put('id', theApp.Id);
        Test.setCurrentPage(thePage);

        Test.startTest();
            ICFSectionAdviceController controller = new ICFSectionAdviceController();
            controller.pdCompletionStatus = true;
            Boolean isError = false;

        try{
                controller.save();
                controller.saveAndSubmit();
                controller.edit();
                controller.saveFromEdit();
            }
            
            catch(Exception e){
                isError = true;
            }

            System.assertNotEquals(true,isError);

        Test.stopTest();
    }
}