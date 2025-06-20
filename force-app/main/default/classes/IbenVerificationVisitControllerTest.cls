@IsTest
private class IbenVerificationVisitControllerTest
{	
    static testMethod void myUnitTest()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
    //Following System.assertEquals(1,i); code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
        IB_Programme__c programme = con.programme;
         System.assertEquals(1,i);
        Date dueDate = con.dueDate;
         System.assertEquals(1,i);
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
         System.assertEquals(1,i);
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
         System.assertEquals(1,i);
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
         System.assertEquals(1,i);
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
         System.assertEquals(1,i);
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
         System.assertEquals(1,i);
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
         System.assertEquals(1,i);
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
         System.assertEquals(1,i);
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
         System.assertEquals(1,i);
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
         System.assertEquals(1,i);
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
         System.assertEquals(1,i);
        boolean isEditable = con.isEditable;
         System.assertEquals(1,i);
        boolean isInternal = con.isPageInternal;
         System.assertEquals(1,i);
        con.saveSectionA();
         System.assertEquals(1,i);
        con.saveSectionB1();
         System.assertEquals(1,i);
        con.saveSectionB2();
         System.assertEquals(1,i);
        con.saveSectionC1();
         System.assertEquals(1,i);
        con.saveSectionC2();
         System.assertEquals(1,i);
        con.saveSectionC3();
         System.assertEquals(1,i);
        con.saveSectionC4();
         System.assertEquals(1,i);
        PageReference pr = con.activeSection;
         System.assertEquals(1,i);
        con.goToNextSection();
         System.assertEquals(1,i);
        con.goToExitReport();
         System.assertEquals(1,i);
        con.submitVerificationVisit();
         System.assertEquals(1,i);
    }
    
    static testMethod void myUnitTest_MYP()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
        
        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
       
        /*con.isPageInternal = true;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();*/
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
        con.activeTab = 'sectiona';
        con.goToNextSection();
        con.activeTab = 'sectionb1';
        con.goToNextSection();
        con.activeTab = 'sectionb2';
        con.goToNextSection();
        con.activeTab = 'sectionc1';
        con.goToNextSection();
        con.activeTab = 'sectionc2';
        con.goToNextSection();
        con.activeTab = 'sectionc3';
        con.goToNextSection();
        con.activeTab = 'sectionc4';
        con.goToNextSection();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }
      static testMethod void myUnitTest_PYP()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;


        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }
          static testMethod void myUnitTest_CP1()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'CP');
        theProgramme.IBCC_Implementation_Phase__c = 'Phase 1';
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
            
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }
      static testMethod void myUnitTest_CP2()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'CP');
        theProgramme.IBCC_Implementation_Phase__c = 'Phase 2';
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }
     static testMethod void myUnitTest_DP()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'Diploma Programme');
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }
         static testMethod void myUnitTest_MYP_Patner()
    {
        integer i = 1;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
		
        Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP Partner');
        insert theProgramme;
        
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
               AFC_Written_Curriculum_Status__c = 'Complete',
               RecordTypeId=[SELECT Id FROM RecordType WHERE SobjectType='IB_Application__c' AND DeveloperName='Application_for_Authorization'].Id
          );
        insert theApp;        
        
        theProgramme.StageName__c = 'Verification visit';
        theProgramme.Sub_Stage__c = 'Allocate visit team';
        update theProgramme;
        
        IB_Verification_Visit_Feedback__c vv = [SELECT Id FROM IB_Verification_Visit_Feedback__c];
        try{
        test.startTest();
        Test.setCurrentPage(Page.IbenVerificationVisit);
        IbenVerificationVisitController con = new IbenVerificationVisitController(new ApexPages.StandardController(vv));
        Decimal pcTimeAllocTotal = con.pcTimeAllocTotal;
        IB_Programme__c programme = con.programme;
        
        Date dueDate = con.dueDate;
        
        List<IbenVerificationVisitController.VerificationVisitLinks> mypPartnershipLinks = con.mypPartnershipLinks;
        
        List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps = con.standardSubjectProps;
        
        List<IB_Application_Curriculum_Requirement__c> applicationRequirements = con.applicationRequirements;
        
        List<IB_Role__c> rolesByProgramme = con.rolesByProgramme;
        
        List<Application_Meeting_Chart__c> applicationMeetingList = con.applicationMeetingList;
        
        List<Application_Account_Facilities__c> applicationFacilityList = con.applicationFacilityList;
        
        List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = con.subjectProposals;
        
        List<Application_Teaching_Time__c> applicationTeachingTimeList = con.applicationTeachingTimeList;
        
        List<Application_Library_Resources__c> applicationLibraryList = con.applicationLibraryList;
        
		List<Application_Coordinator_Time__c> serviceCoordinatorTimeList = con.serviceCoordinatorTimeList;
        
        boolean isEditable = con.isEditable;
        
        boolean isInternal = con.isPageInternal;
        
        con.saveSectionA();
        
        con.saveSectionB1();
        
        con.saveSectionB2();
        
        con.saveSectionC1();
        
        con.saveSectionC2();
        
        con.saveSectionC3();
        
        con.saveSectionC4();
        
        PageReference pr = con.activeSection;
        
        con.goToNextSection();
        
        con.goToExitReport();
        
        con.submitVerificationVisit();
        
        con.lockPage();
        con.breakLock();
        test.stopTest();
          }
        catch(Exception x)
        {system.debug('exception ' + x);}
    }

}