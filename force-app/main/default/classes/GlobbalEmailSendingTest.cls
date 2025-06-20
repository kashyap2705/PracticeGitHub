@isTest
private class GlobbalEmailSendingTest {
    
    @testSetup
    static void steupTestData() {
        Account account = PimsTestUtil.createAccount('Test School', 'School Account');
        insert account;      
        
        Contact contact = PimsTestUtil.createContact('Test Contact','test@gmail.com', 'test@gmail.com',Date.newInstance(1984, 09, 14), account);
        insert contact;
        
        IB_Programme__c prg = PimsTestUtil.createProgrammeForAccount (account, 'Diploma_Programme');
        prg.Name = 'Testing Programmme';
        prg.StageName__c = 'Consultation';
        prg.Status__c = 'Candidate';
        prg.Sub_Stage__c = 'Candidacy Approved';
        prg.Date_Decision_on_Candidacy__c = Date.today();
        prg.Exam_Session__c = 'May';
        prg.Invoice_Date__c = 'Aug 1 2019';
        prg.Account__c = account.id;
        prg.Contact_Programme_Coordinator__c = contact.id;
        prg.Contact_Head_of_School__c= contact.id;
        prg.IBCC_Implementation_Phase__c = 'Phase 2';      
        insert prg;
        
        Id campaignRecordTypeId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByName().get('Authorization').getRecordTypeId();      
        Campaign cmp = TestsUtil.createRFCCampaign('Testing event',account.Id,prg.Id,campaignRecordTypeId, 'Staffed-Pending L1');
        cmp.Sub_Type__c = 'Candidacy Consultation';
        //below startdate, enddate and delivery mode added by prerna for ECM00508
        cmp.Status = 'Planned / Ready for Staffing';
        cmp.Related_IB_Programme__c = prg.Id;
        cmp.StartDate = System.Today()-10;
        cmp.EndDate = System.Today()+10;
        cmp.Delivery_Mode__c = 'Remote';
        cmp.Related_IB_Programme__c = prg.Id;
        insert cmp;
        
        List<Id> Ids = new List<Id>();
        Ids.add(cmp.id);
        /*BulkDataFactoryTest.loadRoleRepoData();
        IB_Role_Repository__c repoSchool = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                            FROM IB_Role_Repository__c WHERE Role_Name__c='School Visit Team Leader' Limit 1];
        IB_Role_Repository__c repoMember = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                            FROM IB_Role_Repository__c WHERE Role_Name__c='School Visit Team Member' Limit 1];
         
         */
         
        //Code added by prerna for ECM00508 ---START---   
        IB_Role_Repository__c role = TestsUtil.createRoleRepoForTeamLeader();
        insert role;
        IB_Role_Repository__c teamMemberRole = TestsUtil.createRoleRepoForTeamLeader();
        teamMemberRole.Role_Name__c='School Visit Team Member';
        insert teamMemberRole; 
        //Code added by Prerna for ECM00508 ---ENDS---                                   
        
        My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', account.Id, 
                                                                             cmp.id, null, null);
        myStaffEvent1.Application_Status__c = 'Confirmed';
        //myStaffEvent1.IB_Role__c = repoSchool.id;
        myStaffEvent1.IB_Role__c = role.id;
       
        insert myStaffEvent1;
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', cmp.Id, account.Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        insert staffEvent1;
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, cmp.Id);
        My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', account.Id, 
                                                                             cmp.id, null, null);
        myStaffEvent2.Application_Status__c = 'Confirmed';
        //myStaffEvent2.IB_Role__c = repoMember.id;
        myStaffEvent2.IB_Role__c = teamMemberRole.id; 
        myStaffEvent2.Staffing_Event__c = staffEvent1.Id;
        insert myStaffEvent2;
    }    
    @isTest
    static void testOne() {
        //Test.startTest();
        
        campaign cmp = [SELECT Id,Related_IB_Programme__c,Status,Sub_Type__c,name FROM campaign ];
        
        //Code added by prerna for ECM00508 ---START---   
        IB_Role_Repository__c teamLeaderRole = [SELECT Id,Role_Name__c
                                                FROM IB_Role_Repository__c 
                                                WHERE Role_Name__c='School Visit Team Leader' 
                                                Limit 1];
        
        IB_Role_Repository__c teamMemberRole = [SELECT Id,Role_Name__c
                                                FROM IB_Role_Repository__c 
                                                WHERE Role_Name__c='School Visit Team Member' 
                                                Limit 1];
        Test.startTest();
        Account account = [SELECT ID, Name from Account WHERE Name = 'Test School' LIMIT 1];
        Contact contact = [SELECT ID from Contact LIMIT 1];
        IB_Programme__c prg = [SELECT ID FROM IB_Programme__c LIMIT 1];
       
        List<My_Staffing_Event__c> myAssignment = new List<My_Staffing_Event__c>();
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_001', account.Id, cmp.Id, null, teamLeaderRole.Id, contact.id));
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_002', account.Id, cmp.Id, null, teamMemberRole.Id, contact.id));
        
        insert myAssignment;
        System.debug('myAssignment====>'+myAssignment);
        
        
        IB_Role_Repository__c pcRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert pcRepo;
        System.debug('pcRepo====>'+pcRepo);
        IB_Role__c pcRole = PimsTestUtil.createIbRole(pcRepo.Id, contact.Id, account.Id);
        pcRole.IB_Programme_New__c = prg.Id;
        pcRole.Start_Date__c = Date.today();
        insert pcRole;
        //Test.stopTest();
       //Code added by prerna for ECM00508 ---ENDS---   
        
        List<GlobalEmailSending.eventIdAndEmailType> testData = new List<GlobalEmailSending.eventIdAndEmailType>();
        GlobalEmailSending.eventIdAndEmailType testCase1 = new GlobalEmailSending.eventIdAndEmailType();
        testCase1.eventIds = cmp.id ;
        testCase1.emailMethodName = 'VerificationConfirmedVisitEmail';
        testData.add(testCase1);
        GlobalEmailSending.VerificationVisitEmail(cmp.id);
        GlobalEmailSending.VerificationConfirmedVisitEmail(cmp.id);
        GlobalEmailSending.IBENVerificationVisitEmail(cmp.id);
        GlobalEmailSending.sendEmail(testData);
        //code added by Prerna for ECM00508 ---START---  
        GlobalEmailSending.VVTentativeDatesEmail(cmp.id);
        GlobalEmailSending.VVTentativeDatesEmail(null);
        //code added by prerna for ECM00508 ---ENDS--- 
        Test.stopTest();
    }
}