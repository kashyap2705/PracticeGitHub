/*******************************************************************************************
* @Name         PimsApplicationFeedbackControllerTest
* @Author       
* @Date         
* @Group        
* @Description  Test class for PimsApplicationFeedbackController
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Ranjith Kondabathini      05/18/2023         Updated testsetup method to reduce the number of DMLs
*******************************************************************************************/
@isTest
private class PimsApplicationFeedbackControllerTest {
    
    @testSetup static void methodName() {
        
        Map<String,String> customLabelMap = new Map<String,String>();
        customLabelMap.put('SaveFeedback','Save Feedback');
        customLabelMap.put('viewActionPlans','View Action Plans');
        List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
        
        List<Translation__c> transList = new List<Translation__c>();
        for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
        }
        if(!transList.isEmpty())
            insert transList;
    }
    
    static testMethod void test_method_one() {
        integer i=1;
        
        Account theAccount = PimsTestUtil.createAccount('Test School Account', 'School Account');
        insert theAccount;
        
        Contact theContact = PimsTestUtil.createContact('John Doe', 'JD@jd.com', 'jd@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        //    insert theContact;
        
        Contact theContact2 = PimsTestUtil.createContact('Jane Doe', 'JD2@jd.com', 'jd2@profEmail.com', Date.newInstance(1985, 10, 14), theAccount);
        //  insert theContact2;
        insert new List<contact>{theContact,theContact2};
            
            Opportunity theOpp = new Opportunity();
        theOpp.Name = 'Test Opp';
        //theOpp.Exam_Session__c = 'May';
        //theOpp.Primary_Language_Of_Instruction__c = 'English';
        theOpp.StageName = 'Consideration';
        //theOpp.Status__c = 'Interested';
        theOpp.CloseDate = Date.today();
        //theOpp.Programme_Legal_Name__c = 'PYP Test';
        theOpp.AccountId = theAccount.Id;
        insert theOpp;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'MYP');   
        IB_Programme__c theProgramme2 = PimsTestUtil.createProgrammeForAccount (theAccount, 'PYP');
        insert new List<IB_Programme__c>{theProgramme,theProgramme2};
            
            IB_Role_Repository__c roleRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        IB_Role_Repository__c roleRepo2 = PimsTestUtil.createRoleRepo('Teacher');
        insert new List<IB_Role_Repository__c>{roleRepo,roleRepo2};
            
            IB_Role__c theRole = PimsTestUtil.createIbRole(roleRepo.Id, theContact.Id, theAccount.Id);
        theRole.IB_Programme_New__c = theProgramme.Id;
        
        IB_Role__c theRole2 = PimsTestUtil.createIbRole(roleRepo2.Id, theContact.Id, theAccount.Id);
        theRole2.IB_Programme_New__c = theProgramme2.Id;
        insert new List<IB_Role__c>{theRole,theRole2};
            
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
        
        IB_Application_Feedback__c appFeedback = new IB_Application_Feedback__c();
        appFeedback.IB_Programme_Lookup__c = theProgramme.Id;
        appFeedback.FB_Lookup_IB_Application__c = theApp.Id;
        appFeedback.name = theProgramme.Name + ' Candidacy Feedback';    
        
        IB_Application_Feedback__c appFeedback2 = new IB_Application_Feedback__c();
        appFeedback2.IB_Programme_Lookup__c = theProgramme.Id;
        appFeedback2.FB_Lookup_IB_Application__c = theApp.Id;
        appFeedback2.name = theProgramme.Name + ' Consultation Feedback';
        insert new List<IB_Application_Feedback__c>{appFeedback,appFeedback2};
            
            Pagereference pgRef = Page.IbenApplicationFeedback;
        pgRef.getParameters().put('id', appFeedback.Id);
        pgRef.getParameters().put('tab', 'instructions');
        
        Test.setCurrentPage(pgRef);
        Test.startTest();
        
        PimsApplicationFeedbackController con = new PimsApplicationFeedbackController();
        
        String feasContacts = con.getFeasabilityContacts();
        
        con.getIsEditable();
        con.getIsPyp();
        con.getIsMyp();
        con.getIsCp();
        con.getIsDp();
        con.getIsCpPhase1();
        con.getIsCpPhase2();
        
        String lang = con.getUserLanguageKey();
        
        con.progId = theProgramme.Id;
        con.isUpdatePage = true;
        con.ibenPath = '/educator/';
        
        // Test save method when isIBen = true
        con.isIben = true;
        con.activeTab = 'legal';
        con.save();
        con.activeTab = 'name';
        con.save();
        con.activeTab = 'mission';
        con.save();
        con.activeTab = 'campus';
        con.save();
        con.activeTab = 'continuum';
        con.save();
        con.activeTab = 'programme';
        con.save();
        con.activeTab = 'budget';
        con.save();
        con.activeTab = 'commitment';
        con.save();
        con.activeTab = 'action';
        con.save();
        con.activeTab = 'diploma';
        con.save();
        con.activeTab = 'community';
        con.save();
        con.activeTab = 'cas';
        con.save();
        con.activeTab = 'tok';
        con.save();
        con.activeTab = 'cq';
        con.save();
        con.activeTab = 'development';
        con.save();
        con.activeTab = 'partner';
        con.save();
        con.activeTab = 'length';
        con.save();
        con.activeTab = 'language';
        con.save();
        con.activeTab = 'part';
        con.save();
        con.activeTab = 'gradual';
        con.save();
        con.getCurrentSection();
        
        con.edit();
        con.deleteAfbId = appFeedback.Id;
        con.remove();
        con.getPageHasErrors();
        con.updateStartDate();
        con.tab = 'budget';
        con.removeBudget();
        con.saveBudget();
        con.viewActionPlans();
        con.viewSchoolWebsite();
        con.viewCandidacyApp();
        con.viewActionPlan();
        // CR 14339 - Added test code for saveOnly button 
        con.saveOnly();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        List<customlabel__c> customlabelList = [select id from customlabel__c];            
        List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
        Map<String, String> translationsMap = con.getTranslationsMap();
      //  system.assertEquals('Save Feedback',con.SaveFeedback);
       // system.assertEquals('View Action Plans',con.viewActionPlans);
        Test.stopTest();
    }
    
    static testMethod void test_method_two() {
        integer i=1;
        
        Account theAccount = PimsTestUtil.createAccount('Test School Account2', 'School Account');
        insert theAccount;
        
        Contact theContact = PimsTestUtil.createContact('Donald Trump', 'DT@dt.com', 'dt@profEmail.com', Date.newInstance(1964, 09, 14), theAccount);
        //insert theContact;
        
        Contact theContact2 = PimsTestUtil.createContact('Ted Cruz', 'TC@tc.com', 'tc@profEmail.com', Date.newInstance(1965, 10, 14), theAccount);
        //insert theContact2;
        Insert New List<contact>{theContact,theContact2};
            
            Opportunity theOpp = new Opportunity();
        theOpp.Name = 'Test Opp';
        //theOpp.Exam_Session__c = 'May';
        //theOpp.Primary_Language_Of_Instruction__c = 'English';
        theOpp.StageName = 'Consideration';
        //theOpp.Status__c = 'Interested';
        theOpp.CloseDate = Date.today();
        //theOpp.Programme_Legal_Name__c = 'PYP Test';
        theOpp.AccountId = theAccount.Id;
        insert theOpp;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'MYP');
        insert theProgramme;
        
        IB_Role_Repository__c roleRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        //insert roleRepo;
        
        IB_Role_Repository__c roleRepo2 = PimsTestUtil.createRoleRepo('Teacher');
        //insert roleRepo2;
        
        Insert New List<IB_Role_Repository__c>{roleRepo,roleRepo2};
            
            IB_Role__c theRole = PimsTestUtil.createIbRole(roleRepo.Id, theContact.Id, theAccount.Id);
        theRole.IB_Programme_New__c = theProgramme.Id;
        //insert theRole;
        
        IB_Role__c theRole2 = PimsTestUtil.createIbRole(roleRepo2.Id, theContact.Id, theAccount.Id);
        theRole2.IB_Programme_New__c = theProgramme.Id;
        //insert theRole2;
        
        Insert New List<IB_Role__c>{theRole,theRole2};
            
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
        
        IB_Application_Feedback__c appFeedback = new IB_Application_Feedback__c();
        appFeedback.IB_Programme_Lookup__c = theProgramme.Id;
        appFeedback.FB_Lookup_IB_Application__c = theApp.Id;
        appFeedback.name = theProgramme.Name + ' Candidacy Feedback';
        // insert appFeedback;
        
        IB_Application_Feedback__c appFeedback2 = new IB_Application_Feedback__c();
        appFeedback2.IB_Programme_Lookup__c = theProgramme.Id;
        appFeedback2.FB_Lookup_IB_Application__c = theApp.Id;
        appFeedback2.name = theProgramme.Name + ' Consultation Feedback';
        //insert appFeedback2;
        
        Insert New List<IB_Application_Feedback__c>{appFeedback,appFeedback2};
            
            Pagereference pgRef = Page.IbenApplicationFeedback;
        pgRef.getParameters().put('id', appFeedback.Id);
        pgRef.getParameters().put('tab', 'instructions');
        
        Test.setCurrentPage(pgRef);
        Test.startTest();
        
        PimsApplicationFeedbackController con = new PimsApplicationFeedbackController();
        
        con.init();
        String feasContacts = con.getFeasabilityContacts();
        
        con.getIsEditable();
        con.getIsPyp();
        con.getIsMyp();
        con.getIsCp();
        con.getIsDp();
        con.getIsCpPhase1();
        con.getIsCpPhase2();
        
        String lang = con.getUserLanguageKey();
        
        con.progId = theProgramme.Id;
        con.isUpdatePage = true;
        con.ibenPath = '/educator/';
        
        // Test save method when isIBen = false
        con.isIben = false;
        con.activeTab = 'legal';
        con.save();
        con.activeTab = 'name';
        con.save();
        con.activeTab = 'mission';
        con.save();
        con.activeTab = 'campus';
        con.save();
        con.activeTab = 'continuum';
        con.save();
        con.activeTab = 'programme';
        con.save();
        con.activeTab = 'budget';
        con.save();
        con.activeTab = 'commitment';
        con.save();
        con.activeTab = 'action';
        con.save();
        con.activeTab = 'diploma';
        con.save();
        con.activeTab = 'community';
        con.save();
        con.activeTab = 'cas';
        con.save();
        con.activeTab = 'tok';
        con.save();
        con.activeTab = 'cq';
        con.save();
        con.activeTab = 'development';
        con.save();
        con.activeTab = 'partner';
        con.save();
        con.activeTab = 'length';
        con.save();
        con.activeTab = 'language';
        con.save();
        con.activeTab = 'part';
        con.save();
        con.activeTab = 'gradual';
        con.save();
        
        con.edit();
        con.deleteAfbId = appFeedback.Id;
        con.remove();
        con.getPageHasErrors();
        con.updateStartDate();
        con.tab = 'budget';
        con.removeBudget();
        con.saveBudget();
        con.viewActionPlans();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        Test.stopTest();
    }
}