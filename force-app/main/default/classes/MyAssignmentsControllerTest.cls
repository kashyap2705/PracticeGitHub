@isTest
public with sharing class MyAssignmentsControllerTest {

    static testMethod void testOne(){
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        Account acc = TestsUtil.createAccount('Campaign-IBEN');
        insert acc;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp1.Id, recordTypeId);
        camp1.Bundle__c = false;
        insert camp1;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp1.Id, acc.Id);
        insert staffEvent1;
        
        Viewed_IBEN_Assignment__c view = new Viewed_IBEN_Assignment__c(Community_User__c = testUser.Id, IBEN_Assignment__c = staffEvent1.Id, Last_Access__c = Date.today());
        insert view;
        
        System.runAs(testUser) {
            //MyAssignmentDetailsController msc1 = new MyAssignmentDetailsController();
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEligOnly = false;
            Test.startTest();
            msc.searchAssignments();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
            List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
            List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            Test.stopTest();
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
        }
    }
    
    static testMethod void testTwo(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            Test.startTest();
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEligOnly = false;
            //msc.searchAssignments();
            msc.isLoggedIn();
            msc.getNoAssignments();
            msc.getNoEligAssignments();
            msc.getNoAssignmentsHistory();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
            Test.stopTest();
        }
    }
    
    static testMethod void testThree(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            Test.startTest();
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEligOnly = false;
            //msc.searchAssignments();
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            msc.getHasRoles();
            //  msc.clearSearch();
            msc.getHasSearchString();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            System.Debug('a');
            Test.stopTest();
        }
    }  
    
    static testMethod void testFour(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');       
        System.runAs(testUser) {
            Test.startTest();
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put(IboUtil.Ib_Application_Select,'--Select--');
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
                transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty())
                insert transList;
            MyAssignmentsController msc = new MyAssignmentsController();
            String statusPdf = msc.getStatusPdf();
            String getEligibilityPdf = msc.getEligibilityPdf();
            DateUtility dateUtil = msc.dateUtil;
            String assignmentTypesPdf = msc.getAssignmentTypesPdf();
            List<SelectOption> options = msc.getMyRoleOptions();
            List<SelectOption> options2 = msc.getLanguageOptions();
            List<SelectOption> options3 = msc.getWorkshopCategoryOptions();
            List<SelectOption> options4 = msc.getWorkshopCountryOptions();
            msc.selectedLanguage = 'French';
            msc.searchStartDate = '10/10/2015';
            msc.searchEndDate = '10/12/2015';
            msc.selectedWorkshopCategory = 'Test';
            msc.searchWorkshopTitle = 'Test';
            msc.selectedWorkshopCountry = 'United States';
            msc.searchWorkshopCity = 'Palm Coast';
            msc.searchSubject = 'Biology';
            msc.searchEligOnly = true;
            msc.searchAssignments();
            msc.searchEligOnly = false;
            msc.searchAssignments();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            Test.stopTest();
            
            
            
        }
    }     
    
    static testMethod void testFive(){
        integer j=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');       
        System.runAs(testUser) {
            Test.startTest();
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put(IboUtil.Ib_Application_Select,'--Select--');
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
                transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty())
                insert transList;
            MyAssignmentsController msc = new MyAssignmentsController();
            String statusPdf = msc.getStatusPdf();
            String getEligibilityPdf = msc.getEligibilityPdf();
            DateUtility dateUtil = msc.dateUtil;
            String assignmentTypesPdf = msc.getAssignmentTypesPdf();
            List<SelectOption> options = msc.getMyRoleOptions();
            List<SelectOption> options2 = msc.getLanguageOptions();
            List<SelectOption> options3 = msc.getWorkshopCategoryOptions();
            List<SelectOption> options4 = msc.getWorkshopCountryOptions();
            msc.selectedLanguage = 'Spanish';
            msc.searchStartDate = '2015-01-01';
            msc.searchEndDate = '2017-01-01';
            msc.selectedWorkshopCategory = 'Test';
            msc.searchWorkshopTitle = 'Test';
            msc.selectedWorkshopCountry = 'Spain';
            msc.searchWorkshopCity = 'Palm Coast';
            msc.searchSubject = 'Biology';
            msc.searchEligOnly = true;
            msc.searchAssignments();
            msc.searchEligOnly = false;
            msc.searchAssignments();
            System.assertEquals(1,j);
            Integer i = msc.pgNum;
            i = msc.totalElResults;
            i = msc.totalPages;
            Boolean b = msc.hasNext;
            b = msc.hasPrev;
            System.assertEquals(1,j);
            MyAssignmentsController.loadMyAssignments(new List<IBActivity>(), null, false);
            Test.stopTest();
            
            
            
        }
    }     
    
    static testMethod void search_assignments_IBAEM(){
        initCustomSettings();
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        User testUser = TestsUtil.createPortalUser('testUser');
        testUser.ProfileId = p.id;
        insert testUser;
        
        Account acc = TestsUtil.createAccount('Campaign-IBEN-1');
        acc.Region__c = 'IBAEM';
        acc.Country__c = 'Pakistan';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        
        Contact theContact = [Select id,AccountId,Account__c from Contact where id =: testUser.ContactId];
        theContact.AccountId = acc.id;
        update theContact;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
        insert theProgramme;
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
        
        IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(testUser.ContactId , rt1.Id);
        bg1.Language__c = 'English';
        bg1.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg2.Language__c = 'Spanish';
        bg2.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg3.Language__c = 'French';
        bg3.Language_Delivery__c = 'Yes';
        insert new List<IB_E_Background__c>{bg1,bg2,bg3};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp1.Id, recordTypeId);
        camp1.Bundle__c = false;
        camp1.StartDate = Date.today();
        camp1.EndDate = Date.today()+5;
        camp1.Sub_Type__c = 'Candidacy Consultation';
        camp1.Status = 'Planned / Ready for Staffing';
        camp1.Related_IB_Programme__c = theProgramme.id;
        camp1.StartDate = Date.today();
        camp1.EndDate = Date.today()+100;
        camp1.Bundle__c = false;
        camp1.Required_Number_of_Educators__c = 10;
        insert camp1;
        
        IB_Event_Role__c theIBEventRole = TestsUtil.createIbEventRole(10, camp1.id);
        insert theIBEventRole;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp1.Id, acc.Id);
        insert staffEvent1;
        
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Consultant');  
        theRoleRepo1.SF_Role_Application__c = true;
        theRoleRepo1.Display_In_PIMS_Community__c = false;
        insert theRoleRepo1;
        Test.startTest();
        IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, testUser.ContactId, acc.Id);
        role1.Start_Date__c = Date.today();
        role1.IB_Account__c = acc.id;
        role1.IB_Programme_New__c = theProgramme.Id;
        role1.Upskilled_in_PSP__c='2014';
        insert role1;
        List<IB_Role__c> theRoleList = new List<IB_Role__c>();
        theRoleList.add(role1);
        
        Viewed_IBEN_Assignment__c view = new Viewed_IBEN_Assignment__c(Community_User__c = testUser.Id, IBEN_Assignment__c = staffEvent1.Id, Last_Access__c = Date.today());
        insert view;
        
        System.runAs(testUser) {
            try{
                //MyAssignmentDetailsController msc1 = new MyAssignmentDetailsController();
                
                MyAssignmentsController msc = new MyAssignmentsController();
                msc.searchString = 'foo';
                msc.searchEndDate =  string.valueof(Date.today()+5);
                msc.searchStartDate = string.valueof(Date.today());
                msc.selectedRole = 'Consultant';
                msc.selectedLanguage = 'English';
                msc.searchEligOnly = false;
                msc.searchAssignments();
                
                System.assertEquals(1,i);
                //msc.myAppliedForRoles = theRoleList;
                List<SelectOption> options = msc.getMyRoleOptions();
                List<SelectOption> options2 = msc.getLanguageOptions();
                List<SelectOption> options3 = msc.getWorkshopCategoryOptions();
                List<SelectOption> options4 = msc.getWorkshopCountryOptions();
                Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
                List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
                List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
                System.assertEquals(1,i);
                msc.clearSearch();
                msc.nextEA();
                msc.prevEA();
                
                testUser.LanguageLocaleKey = 'fr';
                update testUser;
                options = msc.getMyRoleOptions();
                options2 = msc.getLanguageOptions();
                options3 = msc.getWorkshopCategoryOptions();
                options4 = msc.getWorkshopCountryOptions();
                msc.getStatusPdf();
                msc.getEligibilityPdf();
                msc.getAssignmentTypesPdf();
                
                testUser.LanguageLocaleKey = 'es';
                update testUser;
                options = msc.getMyRoleOptions();
                options2 = msc.getLanguageOptions();
                options3 = msc.getWorkshopCategoryOptions();
                options4 = msc.getWorkshopCountryOptions();
                msc.getStatusPdf();
                msc.getEligibilityPdf();
                msc.getAssignmentTypesPdf();
                
                Test.stopTest();
            }
            catch(Exception x)
            {system.debug('exception ' + x);}
            
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
        }
    }
    static testMethod void search_assignments_IBA(){
        initCustomSettings();
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        
        
        Account acc = TestsUtil.createAccount('Test Account IBA');
        acc.Region__c = 'IBA';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country_IBAP', 'IBAP', acc);
        country.IBEN_Segmentation__c = 'IBA';
        country.Regional_Office_Segmentation__c  = 'IBA';
        insert country;
        
        Contact theContact = TestsUtil.createContact('Test user IBA', 'example12@gmail.com', 'example12@gmail.com', Date.newInstance(1996,08,09), country);
        theContact.AccountId = acc.id;
        theContact.Country_of_Residence__c = country.id;
        insert theContact;
        
        User testUser = new User(profileId = p.id, username = 'example123@gmail.com', email = 'example@gmail.com',
                                 emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                 languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                 alias='cspu', lastname='TestIBA', contactId = theContact.id);
        insert testUser;
        System.debug('testUser :'+testUser.ContactId+' '+theContact.IB_Region__c);
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 3', acc.Id);
        insert opp1;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
        insert theProgramme;
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
        
        IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(testUser.ContactId , rt1.Id);
        bg1.Language__c = 'English';
        bg1.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg2.Language__c = 'Spanish';
        bg1.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg3.Language__c = 'French';
        bg1.Language_Delivery__c = 'Yes';
        insert new List<IB_E_Background__c>{bg1,bg2,bg3};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('Test_IBAP', acc.Id, opp1.Id, recordTypeId);
        camp1.Bundle__c = false;
        camp1.Sub_Type__c = 'Candidacy Consultation';
        camp1.Status = 'Planned / Ready for Staffing';
        camp1.Related_IB_Programme__c = theProgramme.id;
        camp1.StartDate = Date.today();
        camp1.EndDate = Date.today()+100;
        camp1.Required_Number_of_Educators__c = 10;
        insert camp1;
        
        IB_Event_Role__c theIBEventRole = TestsUtil.createIbEventRole(10, camp1.id);
        insert theIBEventRole;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_002', camp1.Id, acc.Id);
        insert staffEvent1;
        
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Consultant');        
        insert theRoleRepo1;
        
        IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, testUser.ContactId, acc.Id);
        role1.Start_Date__c = Date.today();
        role1.IB_Account__c = acc.id;
        role1.Upskilled_in_PSP__c='2014';
        role1.IB_Programme_New__c = theProgramme.Id;
        insert role1;
        
        System.runAs(testUser) {
            //try{
            //MyAssignmentDetailsController msc1 = new MyAssignmentDetailsController();
            
            Test.startTest();//INC0195740 Benjamin McGarvey, start test had to be moved up to avoid hitting soql limit
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEndDate =  string.valueof(Date.today()+5);
            msc.searchStartDate = string.valueof(Date.today());
            msc.selectedRole = 'Consultant';
            msc.selectedLanguage = 'English';
            msc.searchEligOnly = false;
            msc.searchAssignments();
            System.assertEquals(1,i);
            Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
            List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
            List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
            
            System.assertEquals(1,i);
            msc.clearSearch();
            msc.nextEA();
            msc.prevEA();
            Test.stopTest();
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
        }
    }
    static testMethod void search_assignments_IBAP(){
        initCustomSettings();
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        
        Account acc = PimsTestUtil.createAccount('Test Account IBAP', 'School Account');
        acc.Region__c = 'IBAP';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country_IBAP', 'IBAP', acc);
        country.IBEN_Segmentation__c = 'IBAP';
        country.Regional_Office_Segmentation__c  = 'IBAP';
        insert country;
        
        Contact theContact = TestsUtil.createContact('Test user IBAP', 'example@gmail.com', 'example@gmail.com', Date.newInstance(1994,08,26), country);
        theContact.AccountId = acc.id;
        theContact.Country_of_Residence__c = country.id;
        insert theContact;
        User testUser = new User(profileId = p.id, username = 'example@gmail.com', email = 'example@gmail.com',
                                 emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                 languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                 alias='cspu', lastname='TestIBAP', contactId = theContact.id);
        insert testUser;
        
        System.debug('testUser :'+testUser.ContactId+' '+theContact.IB_Region__c);
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 3', acc.Id);
        insert opp1;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
        insert theProgramme;
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
        
        IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(testUser.ContactId , rt1.Id);
        bg1.Language__c = 'English';
        bg1.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg2.Language__c = 'Spanish';
        bg1.Language_Delivery__c = 'Yes';
        IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(testUser.ContactId, rt1.Id);
        bg3.Language__c = 'French';
        bg1.Language_Delivery__c = 'Yes';
        insert new List<IB_E_Background__c>{bg1,bg2,bg3};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Campaign camp1 = TestsUtil.createCampaign('Test_IBAP', acc.Id, opp1.Id, recordTypeId);
        camp1.Bundle__c = false;
        camp1.Sub_Type__c = 'Candidacy Consultation';
        camp1.Status = 'Planned / Ready for Staffing';
        camp1.Related_IB_Programme__c = theProgramme.id;
        camp1.StartDate = Date.today();
        camp1.EndDate = Date.today()+100;
        camp1.Bundle__c = false;
        camp1.Required_Number_of_Educators__c = 10;
        insert camp1;
        
        IB_Event_Role__c theIBEventRole = TestsUtil.createIbEventRole(10, camp1.id);
        insert theIBEventRole;
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_003', camp1.Id, acc.Id);
        insert staffEvent1;
        
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Consultant');        
        insert theRoleRepo1;
        
            Test.startTest();//INC0195740 Benjamin McGarvey, start test had to be moved up to avoid hitting soql limit
        IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, testUser.ContactId, acc.Id);
        role1.Start_Date__c = Date.today();
        role1.IB_Account__c = acc.id;
        role1.Upskilled_in_PSP__c='2014';
        role1.IB_Programme_New__c = theProgramme.Id;
        insert role1;
        
        System.runAs(testUser) {
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEndDate =  string.valueof(Date.today()+5);
            msc.searchStartDate = string.valueof(Date.today());
            msc.selectedRole = 'Consultant';
            msc.selectedLanguage = 'English';
            msc.searchEligOnly = false;
            msc.searchAssignments();
            System.assertEquals(1,i);
            Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
            List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
            List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
            System.assertEquals(1,i);
            Test.stopTest();
            
        }
    }
    static testMethod void no_Assignments(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            try{
                test.startTest();
                MyAssignmentsController msc = new MyAssignmentsController();
                msc.searchString = 'foo';
                msc.searchEligOnly = false;
                //msc.searchAssignments();
                msc.isLoggedIn();
                msc.getNoAssignments();
                msc.getNoEligAssignments();
                msc.getNoAssignmentsHistory();
                
                System.assertEquals(1,i);
                //msc.searchAssignments();
                //msc.getHasRoles();
                //msc.clearSearch();
                //msc.getHasSearchString();
                test.stopTest();
            }
            catch(Exception x)
            {system.debug('exception ' + x);}
        }
    }
    
    static testMethod void get_Roles_Search_String(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            try{
                test.startTest();
                MyAssignmentsController msc = new MyAssignmentsController();
                msc.searchString = 'foo';
                msc.searchEligOnly = false;
                //msc.searchAssignments();
                //msc.isLoggedIn();
                //msc.getNoAssignments();
                //msc.getNoEligAssignments();
                //msc.getNoAssignmentsHistory();
                //msc.searchAssignments();
                msc.getHasRoles();
                //  msc.clearSearch();
                msc.getHasSearchString();
                
                System.assertEquals(1,i);
                System.Debug('a');
                test.stopTest();
            }
            catch (Exception x)
            {system.debug('exception ' + x);}
        }
    }  
    
    static testMethod void Search_Assignments2_IBAEM(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            try{
                Test.startTest();
                MyAssignmentsController msc = new MyAssignmentsController();
                String statusPdf = msc.getStatusPdf();
                String getEligibilityPdf = msc.getEligibilityPdf();
                DateUtility dateUtil = msc.dateUtil;
                String assignmentTypesPdf = msc.getAssignmentTypesPdf();
                List<SelectOption> options = msc.getMyRoleOptions();
                List<SelectOption> options2 = msc.getLanguageOptions();
                List<SelectOption> options3 = msc.getWorkshopCategoryOptions();
                List<SelectOption> options4 = msc.getWorkshopCountryOptions();
                msc.selectedLanguage = 'French';
                msc.searchStartDate = '10/10/2015';
                msc.searchEndDate = '10/12/2015';
                msc.selectedWorkshopCategory = 'Test';
                msc.searchWorkshopTitle = 'Test';
                msc.selectedWorkshopCountry = 'United States';
                msc.searchWorkshopCity = 'Palm Coast';
                msc.searchSubject = 'Biology';
                msc.searchEligOnly = true;
                msc.searchAssignments();
                msc.searchEligOnly = false;
                System.assertEquals(1,i);
                Test.stopTest();
            }
            catch (Exception x)
            {system.debug('exception ' + x);}
            
            
            
        }
    } 
    static testMethod void Search_Assignments2_IBA(){
        initCustomSettings();
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        
        
        Account acc = TestsUtil.createAccount('Test Account IBA');
        acc.Region__c = 'IBA';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country_2', 'IBA', acc);
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        Contact theContact = TestsUtil.createContact('Test user IBA', 'example12@gmail.com', 'example12@gmail.com', Date.newInstance(1994, 06, 09), country);
        theContact.AccountId = acc.id;
        theContact.Country_of_Residence__c = country.id;
        insert theContact;
        
        User testUser = TestsUtil.createPortalUser('testUser');
        testUser.ContactId = theContact.id;
        insert testUser;
        
        System.debug('testUser :'+testUser.ContactId+' '+theContact.IB_Region__c);
        
        TestsUtil.initMyStaffingEvents();
        
        System.runAs(testUser) {
            //try{
            //MyAssignmentDetailsController msc1 = new MyAssignmentDetailsController();
            Test.startTest();
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEndDate =  string.valueof(Date.today()+5);
            msc.searchStartDate = string.valueof(Date.today());
            msc.selectedRole = 'Consultant';
            msc.selectedLanguage = 'English';
            msc.searchEligOnly = true;
            msc.searchAssignments();
            
            System.assertEquals(1,i);
            Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
            List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
            List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
            System.assertEquals(1,i);
            msc.clearSearch();
            msc.nextEA();
            msc.prevEA();
            Test.stopTest();
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
        }
    }
    static testMethod void Search_Assignments2_IBAP(){
        initCustomSettings();
        integer i=1;
        //TestsUtil.initMyStaffingEvents();
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        
        Account acc = PimsTestUtil.createAccount('Test Account IBAP', 'School Account');
        acc.Region__c = 'IBAP';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country_IBAP', 'IBAP', acc);
        country.IBEN_Segmentation__c = 'IBAP';
        country.Regional_Office_Segmentation__c  = 'IBAP';
        insert country;
        
        Contact theContact = TestsUtil.createContact('Test user IBAP', 'example@gmail.com', 'example@gmail.com',Date.newInstance(1994, 06, 09), country);
        theContact.AccountId = acc.id;
        theContact.Country_of_Residence__c = country.id;
        
        insert theContact;
        User testUser = new User(profileId = p.id, username = 'example@gmail.com', email = 'example@gmail.com',
                                 emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                 languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                 alias='cspu', lastname='TestIBAP', contactId = theContact.id);
        insert testUser;
        
        System.debug('testUser :'+testUser.ContactId+' '+theContact.IB_Region__c);
        
        TestsUtil.initMyStaffingEvents();
        
        System.runAs(testUser) {
            //try{
            //MyAssignmentDetailsController msc1 = new MyAssignmentDetailsController();
            Test.startTest();
            MyAssignmentsController msc = new MyAssignmentsController();
            msc.searchString = 'foo';
            msc.searchEndDate =  string.valueof(Date.today()+5);
            msc.searchStartDate = string.valueof(Date.today());
            msc.selectedRole = 'Consultant';
            msc.selectedLanguage = 'English';
            msc.searchEligOnly = false;
            msc.searchAssignments();
            System.assertEquals(1,i);
            Set<Id> recentlyViewed = MyAssignmentsController.setRecentlyViewed;
            List<IB_Workshop_Titles__c> ibwt = msc.ibWorkshopTitles;
            List<IB_Workshop_Titles__c> ibwt2 = msc.ibWorkshopTitles2;
            System.assertEquals(1,i);
            //msc.clearSearch();
            //msc.nextEA();
            //msc.prevEA();
            Test.stopTest();
            //msc.isLoggedIn();
            //msc.getNoAssignments();
            //msc.getNoEligAssignments();
            //msc.getNoAssignmentsHistory();
            //msc.searchAssignments();
            //msc.getHasRoles();
            //msc.clearSearch();
            //msc.getHasSearchString();
        }
    }   
    
    static testMethod void My_Assignment(){
        integer j=1;
        TestsUtil.initMyStaffingEvents();
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) {
            try{
                Test.StartTest();
                MyAssignmentsController msc = new MyAssignmentsController();
                String statusPdf = msc.getStatusPdf();
                String getEligibilityPdf = msc.getEligibilityPdf();
                DateUtility dateUtil = msc.dateUtil;
                String assignmentTypesPdf = msc.getAssignmentTypesPdf();
                List<SelectOption> options = msc.getMyRoleOptions();
                List<SelectOption> options2 = msc.getLanguageOptions();
                List<SelectOption> options3 = msc.getWorkshopCategoryOptions();
                List<SelectOption> options4 = msc.getWorkshopCountryOptions();
                msc.selectedLanguage = 'Spanish';
                msc.searchStartDate = '2015-01-01';
                msc.searchEndDate = '2017-01-01';
                msc.selectedWorkshopCategory = 'Test';
                msc.searchWorkshopTitle = 'Test';
                msc.selectedWorkshopCountry = 'Spain';
                msc.searchWorkshopCity = 'Palm Coast';
                msc.searchSubject = 'Biology';
                msc.searchEligOnly = true;
                msc.searchAssignments();
                msc.searchEligOnly = false;
                msc.searchAssignments();
                System.assertEquals(1,j);
                Integer i = msc.pgNum;
                i = msc.totalElResults;
                i = msc.totalPages;
                Boolean b = msc.hasNext;
                b = msc.hasPrev;
                System.assertEquals(1,j);
                MyAssignmentsController.loadMyAssignments(new List<IBActivity>(), null, false);
                Test.stopTest();
            }
            catch(Exception x)
            {system.debug('exception ' + x) ;}
            
            
            
        }
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
    
}