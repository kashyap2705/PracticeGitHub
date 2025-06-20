@isTest 
private class IB_ProgrammeAfterUpdateTriggerTest {
    
    @testSetup static void methodName() {
        AFA_Settings__c settings = new AFA_Settings__c(Name='AdminId',AFA_Owner_Id__c=UserInfo.getUserId());
        insert settings;
        IB_Application__c app1 = PimsTestUtil.createApplication();
        app1.Name = 'PYP ' + app1.Name + ' Application for Authorization';
        app1.RecordTypeId = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Authorization').Id;
        app1.Status__c = 'Submitted';
        
        app1.OwnerId = UserInfo.getUserId();
        
        insert app1;
        Standards_Practices__c practice = new Standards_Practices__c();
        practice.Practice__c = 'Support from authorities';
        practice.Standard__c = 'Documents';
        practice.Practice_ID__c = 'DOC-2';   
        insert practice;
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'Spanish';
        insert acc;
        
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acc,'PYP');
        prog.StageName__c = 'Consultation process';
        //below status modified on 05-06-2024 for ECM00501
        prog.Status__c = 'Interested';
        insert prog;
        
        //code added by prerna on 05-06-2024 for ECM00501 --START--
        prog.StageName__c = 'Request for Candidacy';
        prog.Status__c = 'Interested';
        update prog;
        //code added by prerna on 05-06-2024 for ECM00501 --END--
    }
    @isTest 
    static void testIBProgrammeTrigger2() {
        Test.startTest();
        
        IB_Programme__c prog = [SELECT ID,IBCC_Implementation_Phase__c,Sub_Stage__c,StageName__c,Exam_Session__c,Account__c
                                FROM IB_Programme__c LIMIT 1];
        IB_Application__c app = PimsTestUtil.createApplication();
        app.Name = 'PYP ' + app.Name + ' Application for Candidacy';
        app.RecordTypeId = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Candidacy').Id;
        app.Status__c = 'Submitted';
        app.OwnerId = UserInfo.getUserId();
        
        insert app;
        prog.StageName__c = 'Evaluation';
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c =date.today() -20;
        prog.Legal_Guarantee_Document__c=true;
        prog.Language_of_Correspondence__c='French';
        //prog.AFA_Initiation_Date__c = date.today() ;
        
        update prog;
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c = 'Decision on Authorization';
        prog.Status__c = 'Update Decision';
        update prog;
        IB_Application__c appl = IB_ProgrammeAfterUpdateTriggerHandler.removeFields(app); 
        Id oID = IB_ProgrammeAfterUpdateTriggerHandler.getOwnerId(app);
        Test.stopTest();
        
    }
    @isTest 
    static void testIBProgrammeTrigger() {
        Test.startTest();
        
        IB_Programme__c prog = [SELECT ID,IBCC_Implementation_Phase__c,Sub_Stage__c,StageName__c,Exam_Session__c,Account__c
                                FROM IB_Programme__c LIMIT 1];
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,Owner.isActive,RecordTypeId,OwnerId 
                                 FROM IB_Application__c
                                 LIMIT 1];
        
        prog.StageName__c = 'Evaluation';
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c =date.today() -20;
        prog.Legal_Guarantee_Document__c=true;
        prog.Language_of_Correspondence__c='French';
        
        update prog;
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        //System.assertEquals(1, [select id from IB_Application__c].size());
        //System.assertEquals(1, [select id from IB_Application_Assessment__c].size());
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c = 'Consultation process';
        prog.Status__c = 'Candidate';
        update prog;
        Test.stopTest();
        
    }
    @isTest
    static void testBeforeInsertTrigger1() {
        Test.startTest();
        IB_Programme__c prog = [SELECT ID,IBCC_Implementation_Phase__c,Sub_Stage__c,StageName__c,Exam_Session__c,Account__c
                                FROM IB_Programme__c  LIMIT 1];
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,Owner.isActive,RecordTypeId,OwnerId 
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization'
                                 LIMIT 1];
        
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.Projected_AFA_Submission_Date__c = System.today().addDays(-3);
        prog.StageName__c = 'Request for Authorization';
        prog.Sub_Stage__c='Allocate reader (App for Auth)';
        update prog;
        
        Test.stopTest();
    }  
    @isTest
    static void testBeforeInsertTrigger3() {
        Test.startTest();
        IB_Programme__c prog = [SELECT ID,IBCC_Implementation_Phase__c,Sub_Stage__c,StageName__c,Exam_Session__c,Account__c
                                FROM IB_Programme__c LIMIT 1];
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,Owner.isActive,RecordTypeId,OwnerId 
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization'
                                 LIMIT 1];
        
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c = 'Consultation process';
        prog.Status__c = 'Candidate';
        update prog;
        prog.Projected_AFA_Submission_Date__c = System.today().addDays(-3);
        prog.StageName__c = 'Request for Authorization';
        prog.Sub_Stage__c='Allocate reader (App for Auth)';
        update prog;
        
        Test.stopTest();
    }  
    
    @isTest
    static void testBeforeInsertTriggerFrench() {
        Test.startTest();
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'French';
        insert acc;
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acc,'PYP');
        prog.StageName__c = 'Verification visit';
        prog.Sub_Stage__c = 'Allocate visit team';
        insert prog;
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,RecordTypeId
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization' LIMIT 1];
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        update prog;
        
        Test.stopTest();
    }  
    @isTest
    static void testBeforeInsertTriggerSapnish() {
        Test.startTest();
        Account acc1 = [SELECT Id,Name,Language_Of_Correspondance__c FROM Account 
                        WHERE Language_Of_Correspondance__c = 'Spanish' LIMIT 1];
        IB_Programme__c prog = [SELECT ID, IBCC_Implementation_Phase__c, Sub_Stage__c, StageName__c, Account__c, Exam_Session__c
                                FROM IB_Programme__c
                                WHERE Account__c = :acc1.Id
                                LIMIT 1];
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,RecordTypeId
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization' LIMIT 1];
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c='Verification visit';
        prog.Sub_Stage__c='Allocate reader (App for Auth)';  
        update prog;
        
        Test.stopTest();
    } 
    @isTest
    static void testBeforeInsertTriggerEnglish() {
        Test.startTest();
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acc,'PYP');
        prog.StageName__c = 'Verification visit';
        prog.Sub_Stage__c = 'Allocate visit team';
        insert prog;
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,RecordTypeId
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization' LIMIT 1];
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c='Verification visit';
        prog.Sub_Stage__c='Allocate reader (App for Auth)';  
        update prog;
        
        Test.stopTest();
    }  
    @isTest
    static void testBeforeInsertTriggerFrench2() {
        Test.startTest();
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'French';
        insert acc;
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acc,'PYP');
        prog.StageName__c = 'Verification visit';
        prog.Sub_Stage__c = 'Allocate visit team';
        insert prog;
        IB_Application__c app = [SELECT ID,Application_Lookup_to_Programme__c,Status__c,RecordTypeId
                                 FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization' LIMIT 1];
        app.Application_Lookup_to_Programme__c=prog.Id;
        update app;
        prog.Id = app.Application_Lookup_to_Programme__c;
        prog.StageName__c='Verification visit';
        prog.Sub_Stage__c='Allocate reader (App for Auth)';  
        update prog;
        
        Test.stopTest();
    } 
    //below method writtened by Prerna on 10-06-2024 for ECM00501
    @isTest
    public static void testIbProgrammeUpdate() {
        
       Account acc1 = [SELECT Id,Name,Language_Of_Correspondance__c FROM Account 
                        WHERE Language_Of_Correspondance__c = 'Spanish' LIMIT 1];
        IB_Programme__c prog = [SELECT ID, IBCC_Implementation_Phase__c, Sub_Stage__c, StageName__c, Account__c, Exam_Session__c
                                FROM IB_Programme__c
                                WHERE Account__c = :acc1.Id
                                LIMIT 1];
        
        
        // Create and insert country segmentation
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c(
            Name = 'Test Country',
            Regional_Office_Segmentation__c = 'IBA',
            IBEN_Segmentation__c = 'IBA'
        );
        insert country;
        //Added by prerna to resolved an error as part of ECM00774
        Test.startTest();
        // Create and insert contact
        Contact contactib = new Contact(
            //Firstname added by prerna to resolved an error as part of ECM00774
            FirstName = 'Testing',
            LastName = 'Test Contact',
            Email = 'test@gmail.com',
            User_Language__c = 'en_US',
            Country__c = country.Id,
            AccountId = acc1.Id
        );
        insert contactib;
        
        
        prog.StageName__c = 'Request for Authorization';
        prog.Status__c = 'Candidate';
        update prog;
        
        IB_Role_Repository__c pcRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert pcRepo;
        IB_Role_Repository__c hosRepo = PimsTestUtil.createRoleRepo('Head of School');
        insert hosRepo;
        
        List<IB_Role__c> ibRoleList = new List<IB_Role__c> ();
        IB_Role__c pcRole = PimsTestUtil.createIbRole(pcRepo.Id, contactib.Id, acc1.Id);
        pcRole.IB_Programme_New__c = prog.Id;
        pcRole.Start_Date__c = Date.today();
        
        IB_Role__c hosRole = PimsTestUtil.createIbRole(hosRepo.Id, contactib.Id, acc1.Id);
        hosRole.IB_Programme_New__c = prog.Id;
        hosRole.Start_Date__c = Date.today();
        
        ibRoleList.add(pcRole);
        ibRoleList.add(hosRole);
        insert ibRoleList;
        
        Test.stopTest();
    }

}