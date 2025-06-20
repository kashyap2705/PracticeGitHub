//This Test apex is writtened by prerna on 20--03-2025 for ECM00739- PART-1 
@isTest
private class IBProgrammeBatchTest {

    private static User createUser (String userName, String lastName, String email, Boolean isActive, Profile prof,String locale){
        return new User(
            alias = (userName + '123456781234').replace('.','').replace('@','').substring(0,8),  
            Email = email, emailencodingkey='UTF-8', LastName = lastName, languagelocalekey='en_US',
            localesidkey=locale, 
            timezonesidkey='America/Los_Angeles', Username = userName, 
            CommunityNickname = 'Nick_' + userName, IsActive = isActive, ProfileId = prof.Id);
        
    }

    // This method will create test data required for batch processing, reusing data creation from IB_ProgrammeAfterUpdateTriggerTest
    @testSetup
    static void setupTestData() {
        
        Profile profile= [Select Id from profile where Name='System Administrator'];         
        User user = createUser('usertestname2@gmail.com', 'test23_user_lastName', 'yy34yyy@gmail.com', true,profile,'en_US');
        user.Department ='IBWS';
        insert user;
        
        // Reusing the testSetup from IB_ProgrammeAfterUpdateTriggerTest for data creation
        AFA_Settings__c settings = new AFA_Settings__c(Name = 'AdminId', AFA_Owner_Id__c = UserInfo.getUserId());
        insert settings;
        
        IB_Application__c app1 = PimsTestUtil.createApplication();
        app1.Name = 'PYP ' + app1.Name + ' Application for Authorization';
        app1.RecordTypeId = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Authorization').Id;
        app1.Status__c = 'Submitted';
        app1.OwnerId = user.Id;
        insert app1;
        
        Id cpRecordType = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('IBCC').getRecordTypeId();
        Id dpRecordType = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('Diploma_Programme').getRecordTypeId();
        Test.startTest();
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'Spanish';
        acc.OwnerId = user.id;
        insert acc;
		
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acc, 'PYP');
        prog.Owner__c=user.id;
        insert prog;
       Test.stopTest();
    }

    // Batch test method to check the processing of IB_Programme__c records
    @isTest
    static void testIBProgrammeBatch() {
        Account acc1 = [SELECT Id,Name,Language_Of_Correspondance__c FROM Account 
                        WHERE Language_Of_Correspondance__c = 'Spanish' LIMIT 1];
        IB_Programme__c prog = [SELECT ID, IBCC_Implementation_Phase__c, Sub_Stage__c, StageName__c, Account__c, Exam_Session__c
                                FROM IB_Programme__c
                                WHERE Account__c = :acc1.Id
                                LIMIT 1];
        User user = [SELECT Id, Name, Department FROM User WHERE Department = 'IBWS' Limit 1];
        
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
         prog.StageName__c = 'Evaluation';
        prog.Status__c = 'Authorized';
        //prog.Authorized_Date__c = System.now().addDays(-6); // 6 days ago to be eligible for batch
        prog.Date_Decision_on_Authorization__c = System.now().addDays(-6).date();
        prog.Processed_By_Batch__c = false;
        prog.AFA_Initiation_Date__c = System.today();
        prog.Exam_Session__c = 'May';
        prog.Owner__c=user.id;
        update prog;
        prog.Authorized_Date__c = System.now().addDays(-6);
        prog.Owner__c=user.id;
        update prog;
        
        IBProgrammeBatch batch = new IBProgrammeBatch();
        ID batchProcessId = Database.executeBatch(batch, 200);
        
        Assert.isNotNull(batchProcessId, 'batchProcessId should not be null');
        Test.stopTest();
    }
}