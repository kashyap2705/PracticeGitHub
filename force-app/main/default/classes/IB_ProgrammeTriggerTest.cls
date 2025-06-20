@isTest 
private class IB_ProgrammeTriggerTest {
    
    @testSetup
    static void setup() {
        Test.startTest();
        AFA_Settings__c settings = new AFA_Settings__c(Name='AdminId',AFA_Owner_Id__c=UserInfo.getUserId());
        insert settings;
        Account acc = AccountTestDataFactory.createAccount(null,null);
        insert acc;
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'Postal';
        add.IB_Account__c = acc.Id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(add);
        insert add;
        
        IB_Programme__c prog = new IB_Programme__c();
        prog.Account__c = acc.Id;
        prog.Exam_Session__c = 'May';
        prog.Status__c = 'Test';
        prog.IBCC_Implementation_Phase__c = 'Phase 1';
        prog.Primary_Language_of_Instruction__c = 'English';
        prog.Street_Address__c = add.id;
        insert prog;
        IB_Application__c app = new IB_Application__c(
            Application_Lookup_to_Programme__c = prog.Id
        );
        app.Name = 'PYP ' + app.Name + ' Application for Candidacy';
        app.RecordTypeId = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Candidacy').Id;
        app.Status__c = 'Submitted';

        app.OwnerId = UserInfo.getUserId();

        insert app;
        Test.stopTest();
    }
    
    @isTest 
    static void testIBProgrammeTrigger() {
        IB_Programme__c prog = [
            SELECT Id, Name, Projected_AFA_Submission_Date__c, StageName__c 
            FROM IB_Programme__c
        ][0];
        IB_Application__c app = [SELECT Id,OwnerId,Owner.isActive 
            FROM IB_Application__c Limit 1
        ][0];
        Test.startTest();
        prog.StageName__c = 'Evaluation';
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c =date.today() -20;

        prog.Legal_Guarantee_Document__c=true;
        
       	prog.Language_of_Correspondence__c='French';
        update prog;
        System.assertEquals(1, [select id from IB_Application__c].size());
        System.assertEquals(1, [select id from IB_Application_Assessment__c].size());
        prog.StageName__c = 'Consultation process';
        prog.Status__c = 'Candidate';
        update prog;
        
        Id oID = IB_ProgrammeAfterUpdateTriggerHandler.getOwnerId(app);
        System.assertEquals(UserInfo.getUserId(), app.OwnerId);
        prog.StageName__c='Consultation process';
        update prog;
        Test.stopTest();
        
    }
    
    @isTest 
    static void testIBProgrammeTriggerUpdate() {
        Test.startTest();
        IB_Programme__c prog = [
            SELECT Id, Name, Projected_AFA_Submission_Date__c, StageName__c 
            FROM IB_Programme__c
        ][0];
        IB_Application__c app = [SELECT Id,OwnerId 
            FROM IB_Application__c Limit 1
        ][0];
        list<IB_Programme__c> oldProglst= new list<IB_Programme__c>();
        oldProglst.add(prog);
        Map<ID,IB_Programme__C> newProgMap = new Map<ID,IB_Programme__C>(oldProglst);
        prog.Projected_AFA_Submission_Date__c = System.today().addDays(-3);
        prog.StageName__c = 'Request for Authorization';
        	prog.Sub_Stage__c='Allocate reader (App for Auth)';
        update prog;
			
      list<IB_Programme__c> newProglst= new list<IB_Programme__c>();
        prog.StageName__c = 'Evaluation';
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c =date.today() -20;
        update prog;
        newProglst.add(prog);
        Map<Id,IB_Programme__c> oldProgMap = new Map<ID,IB_Programme__C>(newProglst); 
      
            prog.StageName__c = 'Verification visit';
            prog.Sub_Stage__c = 'Allocate visit team';
            prog.Exam_Session__c = 'November';
            update prog;
        	prog.StageName__c = 'Verification visit';
        	prog.Status__c = 'Postponed';
        	update prog;
        	/*prog.StageName__c='Decision on Authorization';
        	prog.Sub_Stage__c='Update Decision';
        	update prog;*/
            IB_Application__c appl = IB_ProgrammeAfterUpdateTriggerHandler.removeFields(app); 
            IB_ProgrammeAfterUpdateTriggerHandler.createApplicationForAuthorization(oldProgMap, newProgMap);
           Test.stopTest();
    }
}