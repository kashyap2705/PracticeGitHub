@IsTest
public class TriggerFeedbackUpdatesTest {
    
    @testSetup
    static Void setup() {
        Test.startTest();
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
        
        //this creates the Auth_Feedback__c record via IB_ProgrammeAfterUpdateTriggerHandler
        //theProgramme.Sub_Stage__c='Allocate reader (App for Auth)';
        //update theProgramme;
        
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
        
        Campaign camp= new Campaign();
        camp.Related_IB_Programme__c= theProgramme.Id;
        camp.Status = 'Staffed';
        camp.Sub_Type__c = 'Candidacy Consultation';
        camp.Name='MCamp';
        insert camp;
        
        Campaign camp1= new Campaign();
        camp1.Related_IB_Programme__c= theProgramme.Id;
        camp1.Status = 'Staffed';
        camp1.Sub_Type__c = 'Request for authorization';
        camp1.Name='MCamp1';
        insert camp1;
        Test.stopTest();
    }
    
    static testMethod void authFeedbackUpdate()
    {
        test.startTest();
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
        
        
        Auth_Feedback__c authFeedback = new Auth_Feedback__c(
            IB_Programme__c = tmpProg.Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started'
        );
        
        insert authFeedback;
        
        
        authFeedback.Status__c = 'Submitted';
        update authFeedback;
        Test.stopTest();
        
    }
    
    static testMethod void consultantFeedbackUpdate() {
        Test.startTest();
        RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];
        
        IB_Application__c theApp = [
            SELECT  Id, Status__c
            FROM    IB_Application__c
        ];
        
        
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
        
       List<IB_Consultant_Feedback__c> consultantFeedbackList= new List<IB_Consultant_Feedback__c>();
        consultantFeedbackList.add(visitFeedback);
        consultantFeedbackList.add(eopFeedback);
        insert consultantFeedbackList;
        
        system.debug('before update****');
        for(IB_Consultant_Feedback__c cb: consultantFeedbackList)
        {
            cb.Status__c = 'Published';
            
        }
        
        update consultantFeedbackList;
        Test.stopTest();
        system.debug('after update****');
    }
}