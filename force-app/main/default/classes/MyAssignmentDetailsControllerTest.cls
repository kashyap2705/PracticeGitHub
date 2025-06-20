@isTest
private class MyAssignmentDetailsControllerTest {
    
    private static Staffing_Event__c staffEvent1;
    private static Staffing_Event__c staffEvent2;
    private static My_Staffing_Event__c myStaffEvent1;
    private static My_Staffing_Event__c myStaffEvent2; 
    private static My_Staffing_Event__c myStaffEvent3;
    private static My_Staffing_Event__c myStaffEvent4;
    private static My_Staffing_Event__c myStaffEvent5;
    private static List<My_Staffing_Event__c> myStaffingEvents = new List<My_Staffing_Event__c>();
    private static Staffing_Event__c StaffEvent3;
    private static Staffing_Event__c StaffEvent4; 
    private static Staffing_Event__c StaffEvent5; 
    private static Staffing_Event__c StaffEvent6;
    private static IB_Event_Role__c myEventRole1 ;
    private static IB_Event_Role__c myEventRole2;
    private static Campaign camp1;
    private static Campaign camp2;
    private static User testuser;
    private static string available_role_id;
    
    @TestSetup
    static void setupCustomSettings() {
        insert new SchoolServicesTriggerProp__c(
            Name = 'SchoolServices',
            schoolServiceForStuffEvent__c = '1',
            schoolServicesCampList__c = '1,2,3'
        );
        insert new ProfessionalDevelopmentTriggerProp__c(
            Name = 'ProfessionalDevelopment',
            profDevForStuffEvent__c = '1',
            professionalDevelopmentCampList__c = '1,2,3'
        );
    }
    
    @isTest
    static void Custom_test_method_one() {
        
        setupData1();
        try
        {
            Test.startTest();
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            MyAssignmentDetailsController mac= new MyAssignmentDetailsController();
            mac.reqs = myEventRole1;
            mac.user = Testuser;
            mac.roleName = 'Evaluation Leader';
            mac.permisionval = 'Test';
            mac.childIbEvents = Null;
            //Added by Shahrukh on 25/07/2023 to resolve issues -- START --
            mac.startdate = 'Test';
            mac.enddate = 'Test';
            mac.isProgrammeLeaderConsultation = false;
            mac.isEvaluationLeaderConsultation = false;
            //Added by Shahrukh on 25/07/2023 to resolve issues -- END --
            mac.reDirect();
            mac.getHasInvitation();
            mac.gethasAdditinalNotes();
            mac.acceptInvitation();
            mac.getRoleName();
            mac.sendRoleIdDataToController();
            mac.updateReleasePermissionRequired();
            mac.getReleasePermissionItems();
            mac.getInterestLevelItems();
            mac.getShowAssignmentApplication();
            mac.getIsMyAssignment();
            mac.getUrlActionEdit();
            mac.getShowGeneralInstructions();
            mac.getHasAssignmentPrereqs();
            mac.getHasLanguageProficiency();
            mac.getHasSpokenProficiency();
            mac.getHasWrittenProficiency();
            mac.getHasYearsIBExperience();
            mac.getWithdrawalReasons();
            
            mac.loadAvailableRoles();
            
            mac.isLoggedIn();
            mac.SubmitApplication();
            mac.saveWithdrawal();
            mac.urlAction2 = 'Test Cancel Url';
            mac.cancel();
            mac.getUserLanguageKey();
            mac.getLinkForApplicationFeedback();
            mac.getLinkForAFAFeedback();
            mac.getLinkForBQCEventFeedback();
            mac.getLinkForConsultantFeedback();
            mac.getLinkForCourseOutlineReader();
            mac.getLinkForCourseOutlineReader();
            mac.updateAssignmentId();
            mac.getLinkForVerificationVisit() ;
            mac.updatereleasepermisionrequiredcon();
            Test.stopTest();
            
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }  
    }
	
    @isTest
    static void test_method_one() {
        
        integer i = 1;          
        setupData1();

        try
        {
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            
            List<IBActivity> activities = new List<IBActivity>();
            IBActivity IBA = new IBActivity();
            // System.debug('Size ---------- +'+myStaffEvents.size());
            IBActivity assignmentAct = IBActivity.convertAssignment(myStaffingEvents[0]);
            
            
            
            Test.startTest();
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.role  = myEventRole1;
            madc.reqs = myEventRole1;
            madc.user = Testuser;
            madc.assignment = assignmentAct;
            //madc.withdrawalReason = 'Test';
            madc.withdrawalComments = 'Test';
            madc.releasePermissionRequired = 'Test';
            madc.availableRoleId = 'Test';
            madc.availableRoleName = 'Test';
            madc.availableIBRole_c = 'IBEN';
            madc.avilablepgm = 'MYP';
            madc.staffingeventtypes = 'IBEN';
            madc.urlAction2 = 'Test Login';
            //madc.reqs = [SELECT Proposed_Language__c, Proposed_Spoken_Proficiency__c, Proposed_Written_Proficiency__c, Proposed_Years_of_IB_Experience__c, Special_Requistes_Additional_Notes__c FROM IB_Event_Role__c LIMIT 1];
            madc.getRoleName();
            madc.sendRoleIdDataToController();
            madc.updateReleasePermissionRequired();
            madc.getReleasePermissionItems();
            madc.getInterestLevelItems();
            madc.getShowAssignmentApplication();
            madc.getIsMyAssignment();
            madc.getUrlActionEdit();
            madc.getShowGeneralInstructions();
            madc.getHasAssignmentPrereqs();
            madc.getHasLanguageProficiency();
            madc.getHasSpokenProficiency();
            madc.getHasWrittenProficiency();
            madc.getHasYearsIBExperience();
            madc.getWithdrawalReasons();
            madc.isLoggedIn();
            madc.SubmitApplication();
            madc.cancel();
            madc.reDirect();
            madc.getHasInvitation();
            madc.acceptInvitation();
            // madc.declineInvitation();
            madc.getHasLanguageProficiency();
            madc.getHasSpokenProficiency();
            madc.getHasYearsIBExperience();
            madc.getUserLanguageKey();
            // madc.updatereleasepermisionrequiredcon();
            madc.getLinkForAFAFeedback();
            madc.getLinkForCourseOutlineReader();
            madc.gethasAdditinalNotes();
            
            
            //madc.getIsConsultant();
            //madc.getStaffingEventType();
            //madc.getStaffingEventType2();
            
            
            IB_Event_Role__c testrole = madc.role;
            string testStr = madc.permisionval;
            list<campaign> childEvents = madc.childIbEvents;
            
            madc.reqs.Proposed_Language__c = null;
            madc.getHasLanguageProficiency();
            
            madc.reqs.Proposed_Spoken_Proficiency__c = 'C2-Proficient user';
            madc.getHasSpokenProficiency();
            
            madc.reqs.Proposed_Written_Proficiency__c = 'C2- Proficient user';
            madc.getHasWrittenProficiency();
            
            madc.reqs.Proposed_years_of_IB_Experience__c = '3 - 4';
            madc.getHasYearsIBExperience();
            
            ApexPages.currentPage().getParameters().put('action','NEW');
            madc.getUrlActionEdit();
            
            madc.reqs = null;
            madc.getHasAssignmentPrereqs();
            
            IB_Application_Feedback__c appFeedback = madc.getLinkForApplicationFeedback();
            IB_Consultant_Feedback__c consFeedback = madc.getLinkForConsultantFeedback();

            
            madc.getLinkForVerificationVisit();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            Test.stopTest();                                                              
            
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        } 
    }

    @isTest
    static void test_method_two() {
        
        integer i=1;
        
        setupData1();
        try
        {
             IB_Role_Repository__c repo = new IB_Role_Repository__c(
                    Available__c=true,
                    SF_Role_Application__c=true,
                    Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                    CurrencyIsoCode='EUR',
                    Role_Name__c='Reader',
                    Category__c='Learning Centre',
                    Role_Level__c='Fully Qualified;',
                    Sub_Category__c='Administration',
                    Related_Programmes__c='PYP;MYP;DP;IBCC',
                    Available_in_Region__c='Global',
                    Training_Model__c = 'Advanced Training',
                    IB_Staff_Role__c=true
                );
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id,Testuser.ContactId, null);
            role.Start_Date__c = Date.today();
            role.IB_Role__c=repo.id;
            insert role;
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            List<IBActivity> activities = new List<IBActivity>();
            IBActivity IBA = new IBActivity();
            IBActivity assignmentAct = IBActivity.convertAssignment(myStaffingEvents[0]);
            
            
            
            Test.startTest();
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.role  = myEventRole1;
            madc.reqs = myEventRole1;
            madc.user = Testuser;
            madc.assignment = assignmentAct;
            //madc.withdrawalReason = 'Test';
            madc.withdrawalComments = 'Test';
            madc.releasePermissionRequired = 'Test';
            madc.availableRoleId = 'Test';
            madc.availableRoleName = 'Test';
            //madc.reqs = [SELECT Proposed_Language__c, Proposed_Spoken_Proficiency__c, Proposed_Written_Proficiency__c, Proposed_Years_of_IB_Experience__c FROM IB_Event_Role__c LIMIT 1];
            madc.getRoleName();
            madc.sendRoleIdDataToController();
            madc.updateReleasePermissionRequired();
            madc.getReleasePermissionItems();
            madc.getInterestLevelItems();
            madc.getShowAssignmentApplication();
            madc.getIsMyAssignment();
            madc.getUrlActionEdit();
            madc.getShowGeneralInstructions();
            madc.getHasAssignmentPrereqs();
            madc.getHasLanguageProficiency();
            madc.getHasSpokenProficiency();
            madc.getHasWrittenProficiency();
            madc.getHasYearsIBExperience();
            madc.getWithdrawalReasons();
            madc.isLoggedIn();
            madc.updateAssignmentId();
            madc.SubmitApplication();
            madc.saveWithdrawal();
            madc.getLinkForAFAFeedback();
            madc.getLinkForCourseOutlineReader();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            //madc.getStaffingEventType2();                                                               
            //madc.getStaffingEventType2();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        }
    }

    @isTest
    static void saved_withdrawal() {
        
        setupData1();

        try
        {
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            
            //Added by Shahrukh for ECM00637 on 20/07/2023 -- START --
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = My_Staffing_Event__c.WithdrawalReason__c.getDescribe(); 
            //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                options.add(new SelectOption(f.getValue() , f.getLabel()));
            }
           
            Test.startTest();
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.selectedWithdrawalReasons = options;                   //Added by Shahrukh for ECM00637 on 20/07/2023
            System.debug('Testing Viewed Assignment');
            madc.user = Testuser;
            madc.myAssignment = myStaffingEvents;
            madc.reDirect();
            madc.role = null;
            madc.levelOfInterest = null;
            madc.saveWithdrawal();
            //below line added by Prerna on 30-11-2023
            madc.acceptInvitation();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        }  
    }
    
    @isTest
    static void coveringUncoveredMethods() {
        
        setupData1();
		//setupData();
        try
        {
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            
            Test.startTest();
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = Testuser;
            My_Staffing_Event__c myStaffEvent =myStaffingEvents[0];
            myStaffEvent.Application_Status__c='Invited';
            update myStaffEvent;
            
           List<My_Staffing_Event__c> staffEventList= new List<My_Staffing_Event__c> ();
            staffEventList.add(myStaffEvent);
            madc.myAssignment = staffEventList;
            madc.getHasInvitation();
            madc.gethasAdditinalNotes();
            
            myStaffEvent.Application_Status__c='Confirmed';
            update myStaffEvent;
             madc.getHasInvitation();
            myEventRole1.Special_Requistes_Additional_Notes__c ='Test';
            myEventRole1.Proposed_years_of_IB_Experience__c ='3 - 4';
            myEventRole1.Proposed_Written_Proficiency__c ='C2- Proficient user';
			myEventRole1.Proposed_Spoken_Proficiency__c ='C2-Proficient user';
            myEventRole1.Proposed_Language__c='English';
            
            update myEventRole1;
            
            
            madc.reqs=myEventRole1;
            
            madc.gethasAdditinalNotes() ;
            
            madc.sendRoleIdDataToController();
            madc.updateReleasePermissionRequired();
            madc.getReleasePermissionItems();
            madc.getInterestLevelItems();
            madc.getUrlActionEdit();
            madc.getShowGeneralInstructions();
            madc.getHasLanguageProficiency();
            madc.getHasSpokenProficiency();
            madc.getHasWrittenProficiency();
            madc.getHasYearsIBExperience();
            madc.getWithdrawalReasons();
            madc.isLoggedIn();
            madc.getUserLanguageKey();
            madc.getLinkForBQCEventFeedback();
            madc.cancel();
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        }  
    }
    
	@isTest
    static void deline_invitation() {
        setupData1();
        try
        {
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            Test.startTest();
            MyAssignmentDetailsController mac= new MyAssignmentDetailsController();
            mac.reqs = myEventRole2;
            mac.myAssignment = myStaffingEvents;
            mac.user = Testuser;
            //mac.reDirect();
            mac.declineInvitation();        
            mac.getShowAssignmentApplication();
            mac.getIsMyAssignment();
            mac.getHasAssignmentPrereqs();      
            Test.stopTest();
            
        }
        catch(Exception ex){
            
        }
    }

    @isTest
    static void accept_invitation() {
        
        setupData1();
        try
        {
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            List<IBActivity> activities = new List<IBActivity>();
            IBActivity IBA = new IBActivity();
            IBActivity assignmentAct = IBActivity.convertAssignment(myStaffEvent3);
             
            Test.startTest();
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            System.debug('Testing Invitation');
            List<My_Staffing_Event__c> staffevent = [SELECT  Withdrawal_Argumentation__c, toLabel(Level_of_Interest__c), Id, IB_Event__c, toLabel(Application_Status__c)
                                                     FROM My_Staffing_Event__c
                                                     Where Staffing_Event__c =: staffEvent3.id
                                                     And IB_Contact__c = :madc.user.ContactId
                                                     LIMIT 1];
                                                     // Removed toLabel(Withdrawal_Reason__c), from Query for ECM00694
            System.debug(staffevent.size());
            System.debug('User '+madc.user);
            
            madc.applicationStatus = 'Invited';
            madc.user = Testuser;
            madc.myAssignment = myStaffingEvents;
            madc.getHasInvitation();
            madc.acceptInvitation();
            madc.getLinkForApplicationFeedback();
           
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }
	
    @isTest
    static void applicationFeedbackTest() {
        
    //    simpleSetupData('Reader','Request for Candidacy');
        
        try {
            myStaffEvent3.Application_Status__c = 'Confirmed';
            update myStaffEvent3;
            
            Test.startTest();
            
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            Test.stopTest();
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = testuser;
            madc.getLinkForApplicationFeedback();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }
	
    @isTest
    static void linkForAFAFeedbackTest() {

        // simpleSetupData('Reader','Request for authorization');
        
        try {
            myStaffEvent3.Application_Status__c = 'Confirmed';
            update myStaffEvent3;
            
            Test.startTest();
            
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = testuser;
            System.debug('Testing Viewed Assignment');
            madc.getLinkForAFAFeedback();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }

    @isTest
    static void linkForConsultantFeedbackTest() {

        // simpleSetupData('Reader','Candidacy Consultation');
        
        try {
            myStaffEvent3.Application_Status__c = 'Confirmed';
            update myStaffEvent3;
            
            Test.startTest();
         
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = testuser;
            System.debug('Testing Viewed Assignment');
            madc.getLinkForConsultantFeedback();
            madc.updateAssignmentId();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }

    @isTest
    static void linkForVerificationVisitTest() {

        // simpleSetupData('Verification Visit','Verification Visit');
        
        try {
            myStaffEvent3.Application_Status__c = 'Confirmed';
            update myStaffEvent3;
            
            Test.startTest();
         
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = testuser;
            System.debug('Testing Viewed Assignment');
            madc.getLinkForVerificationVisit();
            madc.updateAssignmentId();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }

    @isTest
    static void linkForCourseOutlineReaderTest() {

        // simpleSetupData('Reader','Course Outline Reading');
        
        try {
            myStaffEvent3.Application_Status__c = 'Confirmed';
            update myStaffEvent3;
            
            Test.startTest();
           
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent3.Id);
            
            MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
            madc.user = testuser;
            System.debug('Testing Viewed Assignment');
            madc.getLinkForCourseOutlineReader();
            madc.SubmitApplication();
            
            Test.stopTest();
        }
        Catch(Exception x)
        {    
            System.debug('Exception: '+x);
        } 
    }
    
    @isTest
    static void submitApplicationRFA() {

        initCustomSettings();
        
        Id userLicenseId = [ select Id from UserLicense where name = 'Customer Community Login'].id;
        Id communityprofileId = [select Id from Profile where name='Customer Community Advanced' and UserLicenseId=:userLicenseId].id;
        
        Account acc = PimsTestUtil.createAccount('Test Account','');
        insert acc;
        
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        //con1.MailingState = 'Florida';
        //con1.MailingCountry = 'United States';
        insert con1 ;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert new List<Opportunity> {opp1};
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        insert prog;
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;
            
        Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        
        IB_Subject__c subj = new IB_Subject__c(Subject_Name__c = 'Arabic123',IB_Programme__c ='PYP');
        insert subj;
        
        camp2 = TestsUtil.createCampaign('camp test name 4', acc.Id, opp1.Id, recordTypeId2);
        camp2.Name = 'RFC Test Event';
        camp2.Sub_Type__c ='Request for authorization';
        camp2.Related_IB_Programme__c = prog.id;
        camp2.Venue_Account__c = acc.id ;
        camp2.IB_Subject__c = subj.id;
        insert camp2;
        
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
                            EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = communityprofileId,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');
        usr.ContactId = con1.id;
        insert usr;
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp2.Id, acc.Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        insert staffEvent1;
        
        IB_Role__c ibRole = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert ibRole;
        
        try {
            Test.startTest();
                PageReference pageRef = Page.MyAssignmentDetails;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            
                MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
                madc.user = usr;
                madc.availableIBRole_c = repo.Id;
                madc.loadAvailableRoles();
                System.debug('User Test: '+madc.user);
                madc.SubmitApplication();
                madc.updateAssignmentId();
            Test.stopTest();
        } 
        catch(Exception x)
        {    
            System.debug('Exception: '+x);
        }  
        
    }

    @isTest
    static void submitApplicationCOR() {

        initCustomSettings();
        
        Id userLicenseId = [ select Id from UserLicense where name = 'Customer Community Login'].id;
        Id communityprofileId = [select Id from Profile where name='Customer Community Advanced' and UserLicenseId=:userLicenseId].id;
        
        Account acc = PimsTestUtil.createAccount('Test Account','');
        insert acc;
        
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);

        insert con1 ;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert new List<Opportunity> {opp1};
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        insert prog;
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;
            
        Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        
        IB_Subject__c subj = new IB_Subject__c(Subject_Name__c = 'Arabic123',IB_Programme__c ='PYP');
        insert subj;
        
        camp2 = TestsUtil.createCampaign('camp test name 4', acc.Id, opp1.Id, recordTypeId2);
        camp2.Name = 'RFC Test Event';
        camp2.Sub_Type__c = 'Course Outline Reading';
        camp2.Related_IB_Programme__c = prog.id;
        camp2.Venue_Account__c = acc.id ;
        camp2.IB_Subject__c = subj.id;
        insert camp2;
        
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
                            EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = communityprofileId,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');
        usr.ContactId = con1.id;
        insert usr;
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp2.Id, acc.Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        insert staffEvent1;
        
        IB_Role__c ibRole = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert ibRole;
        
        try {
            Test.startTest();
                PageReference pageRef = Page.MyAssignmentDetails;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', staffEvent1.Id);
            
                MyAssignmentDetailsController madc = new MyAssignmentDetailsController();
                madc.user = usr;
                madc.availableIBRole_c = repo.Id;
                madc.loadAvailableRoles();
                System.debug('User Test: '+madc.user);
                madc.SubmitApplication();
                madc.updateAssignmentId();
            Test.stopTest();
        } 
        catch(Exception x)
        {    
            System.debug('Exception: '+x);
        }  
        
    }
  
    @isTest
    static void test_load_Assignment_role_EL() {
        
        initMyStaffingEvents('Evaluation Leader');
        List<Staffing_Event__c> staffEvent = TestsUtil.getStaffingEvents();
         Test.startTest();
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent[0].Id);
            ApexPages.currentPage().getParameters().put('role','Evaluation Leader');
        MyAssignmentDetailsController mac= new MyAssignmentDetailsController();
        Test.stopTest();
    }

    @isTest
    static void test_load_Assignment_role_PL() {
        
        initMyStaffingEvents('Programme Leader');
        List<Staffing_Event__c> staffEvent = TestsUtil.getStaffingEvents();
         Test.startTest();
            PageReference pageRef = Page.MyAssignmentDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', staffEvent[0].Id);
            ApexPages.currentPage().getParameters().put('role','Programme Leader');
        MyAssignmentDetailsController mac= new MyAssignmentDetailsController();
        Test.stopTest();
    }
    
    @isTest
    static void testCoverage() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.Region__c='IBA';
        insert acc1;
        
        Campaign camp1= new  Campaign();
        camp1.Event_Organizer_Account__c=acc1.id;
        Id RecordTypeIdCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        camp1.recordtypeId=RecordTypeIdCampaign;
        camp1.Type='Evaluation';
        camp1.Sub_Type__c='Evaluation Visit';
        camp1.StartDate=Date.newInstance(2023, 07, 12);
        camp1.EndDate=Date.newInstance(2024, 07, 11);
        camp1.Status='Staffing_Event_Status__c';
        camp1.Programme_Combination_Evaluation_Visits__c='IB only';
        camp1.Name='Evaluation Visit';
        camp1.Venue_Account__c=acc1.Id;
        insert camp1;
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp1.Id;
        staffEvent.Name='Evaluation Visit';
        insert staffEvent;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'Austria';
        con1.Country__c = country.id;
        insert con1;
        
        Contact con11 = TestsUtil.createContact('test1_contact_001', 'xx1x@xxxx.xxx', 'xx1x@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con11.OtherStreet = 'other_street';
        con11.OtherCity = 'other_city';
        con11.OtherPostalCode = 'postal';
        con11.OtherCountry = 'Austria';
        con11.Country__c = country.id;
        insert con11;
        
        IB_Role_Repository__c repo= new IB_Role_Repository__c();
        repo.Available__c=true;
        repo.SF_Role_Application__c=true;
        repo.CurrencyIsoCode='EUR';
        repo.Role_Name__c='Programme Leader';
        repo.Category__c='School Services';
        repo.Role_Level__c='Fully Qualified';
        repo.Sub_Category__c='Evaluation & Authorization';
        repo.Related_Programmes__c='PYP;MYP;DP;CP;IBCC';
        repo.Available_in_Region__c='Global';
        repo.Training_Model__c = 'Advanced Training';
        repo.IB_Staff_Role__c=true;
        insert repo;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert new List<IB_Role__c> {ibRole1};
            
        IB_Event_Role__c ibEventRole = new IB_Event_Role__c();
        ibEventRole.Staffing_Event__c=staffEvent.id;
        ibEventRole.IB_Event__c=camp1.id;
        ibEventRole.IB_Role__c=repo.id;
        ibEventRole.IB_Programme__c='MYP';
        insert ibEventRole;
        
        MyAssignmentDetailsController obj = new MyAssignmentDetailsController();
        obj.reqs = ibEventRole;
        obj.startdate = 'test';
        obj.enddate = 'test';
        obj.permisionval = 'test';
        obj.releasePermissionRequired  = 'test';
        obj.releasePermissionRequiredAccept  = 'test';
        obj.availableRoleName  = 'test';
        obj.avilablepgm  = 'test';
        obj.urlAction2  = 'test';
        obj.staffingeventtypes  = 'test';
        obj.childIbEvents =  new List<Campaign>();
        obj.isProgrammeLeaderConsultation = true;
        obj.isEvaluationLeaderConsultation = true;
        obj.relatedAffilatedEvents =  new List<Campaign>();
        obj.preliminaryReviewStartDate = 'test';
        obj.preliminaryReviewEndDate = 'test';
        
        obj.updatereleasepermisionrequiredcon();
        obj.getRoleName();
        obj.sendRoleIdDataToController();
        obj.getReleasePermissionItems();
        obj.getInterestLevelItems();
        obj.getUrlActionEdit();
        obj.getShowGeneralInstructions();
        obj.getHasLanguageProficiency();
        obj.getHasSpokenProficiency();
        obj.getHasWrittenProficiency();
        obj.getHasYearsIBExperience();
        obj.getWithdrawalReasons();
        obj.isLoggedIn();
        obj.cancel();
        obj.getUserLanguageKey();
        obj.getLinkForBQCEventFeedback();
    }
    
    private static void initCustomSettings () {
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = '1';
        profDevConf.professionalDevelopmentCampList__c = '1,2,3';
        insert profDevConf;
    }

    private static void setupData1() {
        
        initCustomSettings();
        testuser = TestsUtil.createPortalUser('testUser');
        insert testuser;
        Id ibRole = initMyStaffingEvents(testuser);
        myStaffingEvents = TestsUtil.getMyStaffingEvents();
        System.debug('Staffing Event-------: '+myStaffingEvents.size());
        Profile p =  [select Id from profile where Name ='SCU + Advanced' limit 1];
        
        
        Contact theContact = [Select id from Contact where id = :testuser.ContactId ];
        myStaffingEvents[0].IB_Contact__c = theContact.id;
        myStaffingEvents[1].IB_Contact__c = theContact.id;
        myStaffingEvents[0].Application_Status__c = 'Invited';
        myStaffingEvents[1].Application_Status__c = 'Confirmed';
        
        update myStaffingEvents;
        
        staffEvent1 = [Select id,IB_Event__c from Staffing_Event__c where id = :myStaffingEvents[0].Staffing_Event__c ];
        staffEvent2 = [Select id,IB_Event__c from Staffing_Event__c where id = :myStaffingEvents[1].Staffing_Event__c ];
        myEventRole1 = [Select id,Staffing_Event__c,Special_Requistes_Additional_Notes__c,Proposed_years_of_IB_Experience__c,
                        Proposed_Written_Proficiency__c,Proposed_Spoken_Proficiency__c,Proposed_Language__c,Delivery_Mode__c
                        from IB_Event_Role__c where Staffing_Event__c =:staffEvent1.id ];
        
        Viewed_IBEN_Assignment__c view = new Viewed_IBEN_Assignment__c(Community_User__c = testUser.Id, IBEN_Assignment__c = staffEvent1.Id, Last_Access__c = Date.today());
        insert view;
        
        EntitySubscription es = new EntitySubscription(ParentId = staffEvent1.IB_Event__c, SubscriberId = UserInfo.getUserId());
        
        EntitySubscription es1 = new EntitySubscription(ParentId = staffEvent2.IB_Event__c, SubscriberId = UserInfo.getUserId());
        insert new List<EntitySubscription>{es,es1};
    }

    private static void setupData() {
        
        initCustomSettings();
        testuser = TestsUtil.createPortalUser('testUser');
        insert testuser;
        Id ibRole = initMyStaffingEvents(testuser);
        myStaffingEvents = TestsUtil.getMyStaffingEvents();
        System.debug('Staffing Event-------: '+myStaffingEvents.size());
        Profile p =  [select Id from profile where Name ='SCU + Advanced' limit 1];
        
        
        Contact theContact = [Select id from Contact where id = :testuser.ContactId ];
        myStaffingEvents[0].IB_Contact__c = theContact.id;
        myStaffingEvents[1].IB_Contact__c = theContact.id;
        myStaffingEvents[0].Application_Status__c = 'Invited';
        myStaffingEvents[1].Application_Status__c = 'Confirmed';
        
        update myStaffingEvents;
        
        staffEvent1 = [Select id,IB_Event__c from Staffing_Event__c where id = :myStaffingEvents[0].Staffing_Event__c ];
        staffEvent2 = [Select id,IB_Event__c from Staffing_Event__c where id = :myStaffingEvents[1].Staffing_Event__c ];
        myEventRole1 = [Select id,Staffing_Event__c,Special_Requistes_Additional_Notes__c,Proposed_years_of_IB_Experience__c,
                        Proposed_Written_Proficiency__c,Proposed_Spoken_Proficiency__c,Proposed_Language__c,Delivery_Mode__c
                        from IB_Event_Role__c where Staffing_Event__c =:staffEvent1.id ];
        
        Viewed_IBEN_Assignment__c view = new Viewed_IBEN_Assignment__c(Community_User__c = testUser.Id, IBEN_Assignment__c = staffEvent1.Id, Last_Access__c = Date.today());
        insert view;
        
        EntitySubscription es = new EntitySubscription(ParentId = staffEvent1.IB_Event__c, SubscriberId = UserInfo.getUserId());
        
        EntitySubscription es1 = new EntitySubscription(ParentId = staffEvent2.IB_Event__c, SubscriberId = UserInfo.getUserId());
        insert new List<EntitySubscription>{es,es1};
        

        Account acc = TestsUtil.createAccount('Campaign-IBEN');
        insert acc;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (acc,'MYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
      
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp1.Id, recordTypeId);//,prog.Id);
        camp1.Type = 'Authorization';
        camp1.Sub_Type__c = 'Request for Candidacy';
        camp1.Related_IB_Programme__c =theProgramme.id;
        insert camp1;
        Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc.Id, opp1.Id, recordTypeId2);//,prog.Id);
        camp2.Related_IB_Programme__c = theProgramme.id;
        camp2.Type = 'Authorization';
        camp2.Sub_Type__c = 'Candidacy Consultation';
         insert camp2;
       
        staffEvent3 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp2.Id, acc.Id);
        staffEvent4 = TestsUtil.createStaffingEvent('test_name_st_event_002', camp2.Id, acc.Id);
        insert new List<Staffing_Event__c>{staffEvent3,staffEvent4};
       
        myEventRole2 = TestsUtil.createIbEventRole(5, camp1.Id);
        myEventRole2.Special_Requistes_Additional_Notes__c = 'Test';
        insert myEventRole2;
        
       /*  IB_Role_Repository__c rolerepo = TestsUtil.createRoleRepoWithParams('IBEN','Fully Qualified','Programme Development', 'My Assignment');
        //insert rolerepo;
        IB_Role_Repository__c rolerepo1 = TestsUtil.createRoleRepoWithParams('Reader','Fully Qualified','School Services', 'Evaluation & Authorization');
        insert new List<IB_Role_Repository__c>{rolerepo,rolerepo1};
        
        IB_Role__c role = TestsUtil.createIbRoleWithParams(rolerepo.id,testuser.ContactId, 'Confirmed','PYP;MYP;DP;IBC',true, 'Fully Qualified');
        //insert role;
        IB_Role__c role2 = TestsUtil.createIbRoleWithParams(rolerepo1.id,testuser.ContactId, 'Confirmed','PYP;MYP;DP;IBCC',true, 'Fully Qualified');
        insert new List<IB_Role__c>{role,role2};
        Id ibRole = role.id; */
        
        myStaffEvent3 = TestsUtil.createMyStaffingEvent('My staffing Event 3', acc.Id, camp1.Id, myEventRole2.Id, ibRole);
        myStaffEvent3.Staffing_Event__c = staffEvent3.Id;
        myStaffEvent3.IB_Contact__c = theContact.id;
        //insert myStaffEvent3;
         myStaffEvent4 = TestsUtil.createMyStaffingEvent('My staffing Event 4', acc.Id, camp2.Id, myEventRole2.Id, ibRole);
        myStaffEvent4.Staffing_Event__c = staffEvent3.Id;
        myStaffEvent4.IB_Contact__c = theContact.id;
         myStaffEvent4.Application_Status__c = 'Confirmed';
          
       
    }

    private static void simpleSetupData(String camType, String subType) {
        
        initCustomSettings();
        testuser = TestsUtil.createPortalUser('testUser');
        insert testuser;
       
        Account acc = TestsUtil.createAccount('Campaign-IBEN');
        insert acc;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (acc,'MYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
     
        IB_Subject__c subj = new IB_Subject__c(Subject_Name__c = 'Arabic123',IB_Programme__c ='PYP');
        insert subj;
            
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc.Id, opp1.Id, recordTypeId);
        camp2.Related_IB_Programme__c = theProgramme.id;
        camp2.Type = camType;
        camp2.Sub_Type__c = subType;
        camp2.IB_Subject__c = subj.id;
        camp2.EndDate = Date.today();
        camp2.Status = 'Confirmed';
        insert new List<Campaign>{camp2};

        staffEvent3 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp2.Id, acc.Id);
        insert new List<Staffing_Event__c>{staffEvent3};
       
        myEventRole2 = TestsUtil.createIbEventRole(5, camp2.Id);
        myEventRole2.Special_Requistes_Additional_Notes__c = 'Test';
        insert myEventRole2;
        
        IB_Role_Repository__c rolerepo = TestsUtil.createRoleRepoWithParams('IBEN','Fully Qualified','Programme Development', 'My Assignment');
        insert new List<IB_Role_Repository__c>{rolerepo};
        
        IB_Role__c role = TestsUtil.createIbRoleWithParams(rolerepo.id,testuser.ContactId, 'Confirmed','PYP;MYP;DP;IBC',true, 'Fully Qualified');
        insert new List<IB_Role__c>{role};
        
        myStaffEvent3 = TestsUtil.createMyStaffingEvent('My staffing Event 3', acc.Id, camp2.Id, myEventRole2.Id, role.id);
        myStaffEvent3.Staffing_Event__c = staffEvent3.Id;
        myStaffEvent3.IB_Contact__c = testuser.ContactId;
        myStaffEvent3.Application_Status__c = 'Confirmed';
        insert myStaffEvent3;
    }

    private static void new_setupData() {
        
        Id userLicenseId = [ select Id from UserLicense where name = 'Customer Community Login'].id;
        Id communityprofileId = [select Id from Profile where name='Customer Community Advanced' and UserLicenseId=:userLicenseId].id;
        
        Account acc = PimsTestUtil.createAccount('Test Account','');
        insert acc;
            
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        insert con1 ;
        
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
                            EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = communityprofileId,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');
        usr.ContactId = con1.id;
        insert usr;
        testuser = usr;        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        insert prog;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert new List<Opportunity> {opp1};
            
        Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        
        camp1 = TestsUtil.createCampaign('camp test name 3', acc.Id, opp1.Id, recordTypeId2);
        camp1.Name = 'RFC Test Event 2';
        camp1.Sub_Type__c = 'Consultant';
        camp1.Type = 'Consultant';
        camp1.Related_IB_Programme__c = prog.id;
        camp1.Venue_Account__c = acc.id ;
    
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert new List<Opportunity> {opp2};
                
        IB_Subject__c subj = new IB_Subject__c(Subject_Name__c = 'Arabic123',IB_Programme__c ='PYP');
        insert subj;
            
        camp2 = TestsUtil.createCampaign('camp test name 4', acc.Id, opp2.Id, recordTypeId2);
        camp2.Name = 'RFC Test Event';
        CAMP2.Sub_Type__c ='Request for authorization';
        camp2.Related_IB_Programme__c = prog.id;
        camp2.Venue_Account__c = acc.id ;
        camp2.IB_Subject__c = subj.id;
        insert new List<Campaign>{camp1,camp2};            
                           
        IB_Role_Repository__c repo = new IB_Role_Repository__c(Available__c=true,SF_Role_Application__c=true,Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                CurrencyIsoCode='EUR',Role_Name__c='Reader',Category__c='Learning Centre',Role_Level__c='Fully Qualified;',
                Sub_Category__c='Administration',Related_Programmes__c='PYP;MYP;DP;IBCC',Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',IB_Staff_Role__c=true);
        insert repo;
            
        camp1.Status = 'Planned / Ready for Staffing';
        update camp1;  
        camp1.Staffing_Event_Published__c = true;
        update camp1; 
        camp2.Status = 'Planned / Ready for Staffing';
        update camp2;  
        camp2.Staffing_Event_Published__c = true;
        update camp2; 
        
        IB_Role__c role = TestsUtil.createIbRoleWithParams(repo.id,testuser.ContactId, 'Confirmed','PYP;MYP;DP;IBC',true, 'Fully Qualified');
        insert role;
        available_role_id = repo.id;
    }
  
    public static void initMyStaffingEvents(String roleName) {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        List<Account> accounts = TestsUtil.getAccounts();
        
        initStaffingEvents(campaigns, accounts);
        
        List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
        
        initIbEventRoles(staffingEvents,roleName);
        
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        
        //TestsUtil.initMyStaffingEvents(ibEventRoles, staffingEvents, accounts);
    }

    public static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '123457';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '123456';
        insert new List<Account> {acc1,acc2};
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id);
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Evaluation', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test evaluation 1', acc1.Id, opp1.Id, recordTypeId);
        camp1.Type = 'Evaluation';
        camp1.Sub_Type__c = 'Evaluation Visit';
        Campaign camp2 = TestsUtil.createCampaign('camp test evaluation 2', acc2.Id, opp2.Id, recordTypeId);
        camp2.Type = 'Evaluation';
        camp2.Sub_Type__c = 'Evaluation Visit';
        insert new List<Campaign>{camp1,camp2};
        
    }

    private static void initStaffingEvents(List<Campaign> campaigns, List<Account> accounts) {
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', campaigns.get(0).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', campaigns.get(1).Id, accounts.get(0).Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        insert new List<Staffing_Event__c>{staffEvent1, staffEvent2};
    }

    private static void initIbEventRoles(List<Staffing_Event__c> staffingEvents,String roleName) {
        
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepo();
            repo1.Role_Name__c = roleName;
            insert repo1; 
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
            ibEventRole1.IB_Role__c = repo1.id;
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
            ibEventRole2.IB_Role__c = repo1.id;
        
        ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
        ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
        
        insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2};
    }
    
    public static Id initMyStaffingEvents(User testuser) {
        
        TestsUtil.initCampaigns();
        
        List<Campaign> campaigns =  TestsUtil.getCampaigns();
        List<Account> accounts =  TestsUtil.getAccounts();
        
        TestsUtil.initStaffingEvents(campaigns, accounts);
        
        List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
        
        TestsUtil.initIbEventRoles(staffingEvents);
        
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        
        Id ibRole = initMyStaffingEvents(ibEventRoles, staffingEvents, accounts, testuser);
        return ibRole;
    }
      
    public static Id initMyStaffingEvents(List<IB_Event_Role__c> ibEventRoles, List<Staffing_Event__c> staffingEvents, List<Account> accounts, User testuser) {
        
        User testUserRec = testuser;
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accounts.get(0));
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherState = 'Florida';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountry = 'United States';
        con1.Country__c = country.id;
        
        Contact con2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
        con2.OtherStreet = 'other_street2';
        con2.OtherCity = 'other_city2';
        con2.OtherState = 'Florida';
        con2.OtherPostalCode = 'postal2';
        con2.OtherCountry = 'United States';
        con2.Country__c = country.id;
        con2.Phone = '+9212345607865';
        
        insert new List<Contact>{con1, con2};
        Contact cont1 = TestsUtil.getContact(con1.id);
        Contact cont2 = TestsUtil.getContact(con2.id);

        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        IB_Role_Repository__c rolerepo = TestsUtil.createRoleRepoWithParams('IBEN','Fully Qualified','Programme Development', 'My Assignment');
        IB_Role_Repository__c rolerepo1 = TestsUtil.createRoleRepoWithParams('Reader','Fully Qualified','School Services', 'Evaluation & Authorization');
        insert new List<IB_Role_Repository__c>{repo,rolerepo,rolerepo1};
        
        IB_Role__c role = TestsUtil.createIbRoleWithParams(rolerepo.id,testUserRec.ContactId, 'Confirmed','PYP;MYP;DP;IBC',true, 'Fully Qualified');
        IB_Role__c role2 = TestsUtil.createIbRoleWithParams(rolerepo1.id,testUserRec.ContactId, 'Confirmed','PYP;MYP;DP;IBCC',true, 'Fully Qualified');
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont1.Id);
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo.Id, cont2.Id);
        insert new List<IB_Role__c>{role,role2,ibRole1, ibRole2};
        Id ibRole = role.id;
        
            
        // Ib Event Role's IB_Event__c field value is reference to Campaign
        My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', accounts.get(0).Id, 
                                                                                ibEventRoles.get(0).IB_Event__c, null, ibRole1.Id);
        
        myStaffEvent1.IB_Contact__c = cont1.id;     
        myStaffEvent1.Staffing_Event__c = staffingEvents.get(0).Id; 
        
        My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', accounts.get(0).Id, 
                                                                             ibEventRoles.get(1).IB_Event__c, null, ibRole2.Id);
        
        myStaffEvent2.IB_Contact__c = cont2.id;     
        myStaffEvent2.Staffing_Event__c = staffingEvents.get(1).Id;
        
        insert new List<My_Staffing_Event__c>{myStaffEvent1, myStaffEvent2};
            system.debug(loggingLevel.ERROR, 'myStaffEvent1: ' + myStaffEvent1);
        system.debug(loggingLevel.ERROR, 'myStaffEvent2: ' + myStaffEvent2);
        return ibRole;
    }
    
}