@isTest
public class ContentVersionTriggerHandlerTest {
	@testSetup
    static void testData() {
        Contact theContact = ContactTestDataFactory.createContact('Standard Contact', null);
        insert theContact;
        
        IB_Programme__c theProgramme = IbProgramFactoryTest.createProgrammeForAccount (new Account(Id=theContact.AccountId),'PYP');
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

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
            IB_Programme_Lookup__c = theProgramme.Id,
            IB_Application__c = theApp.Id,
            Status__c = 'Not Started',
            RecordTypeId = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit' LIMIT 1].Id
        );
        insert visitFeedback;
    }
    
    @isTest
    static void validateIBCFfiles(){
        ContentVersion contentVersion = new ContentVersion(Title           = 'IBCF',
                                                            PathOnClient   = 'Pic.jpg',
                                                            VersionData    = Blob.valueOf('Test Content'),
                                                            IsMajorVersion = true);
        insert contentVersion;
        
        ContentDocument cd = [SELECT id FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = [SELECT Id FROM IB_Consultant_Feedback__c LIMIT 1].id;
        insert cdl;
        
        Test.startTest();
        	update contentVersion;
        Test.stopTest();
        System.assert([SELECT Id FROM IB_Application_Attachment__c].size() > 0);
    }
    
    @isTest
    static void validateIBPfiles(){
        ContentVersion contentVersion = new ContentVersion(Title           = 'ELT28 RRR',
                                                            PathOnClient   = 'Pic.jpg',
                                                            VersionData    = Blob.valueOf('Test Content'),
                                                            IsMajorVersion = true);
        insert contentVersion;
        
        ContentDocument cd = [SELECT id FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = [SELECT Id FROM IB_Programme__c LIMIT 1].id;
        insert cdl;
        
        Test.startTest();
        	update contentVersion;
        Test.stopTest();
        System.assert([SELECT Id FROM IB_Application_Attachment__c].size() > 0);
    }
    
    @isTest
    static void validateAFfiles(){
        Auth_Feedback__c authFeedback = new Auth_Feedback__c(
            IB_Programme__c = [SELECT Id FROM IB_Programme__c LIMIT 1].id,
            IB_Application__c = [SELECT Id FROM IB_Application__c LIMIT 1].id,
            Status__c = 'Not Started'
        );
        insert authFeedback;
        
        IB_Application_Attachment__c unit_plan = new IB_Application_Attachment__c(); 
        unit_plan.IB_Programme__c = [SELECT Id FROM IB_Programme__c LIMIT 1].id;
        unit_Plan.Name = 'Arts_Unit_1_Unit_Plan.docx';
        insert unit_plan; 
        
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Programme__c = [SELECT Id FROM IB_Programme__c LIMIT 1].id;  
        cor.Status__c = 'Submitted';
        cor.Application_Attachment__c = unit_plan.id;
        insert cor;
        
        ContentVersion contentVersion = new ContentVersion(Title           = 'ELT28 RRR',
                                                            PathOnClient   = 'Pic.jpg',
                                                            VersionData    = Blob.valueOf('Test Content'),
                                                            IsMajorVersion = true);
        insert contentVersion;
        
        ContentDocument cd = [SELECT id FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = [SELECT Id FROM Auth_Feedback__c LIMIT 1].id;
        insert cdl;
        
        Test.startTest();
        	update contentVersion;
        Test.stopTest();
        System.assert([SELECT Id FROM IB_Application_Attachment__c].size() > 0);
    }
    
    @isTest
    static void validateVVFfiles(){
        IB_Verification_Visit_Feedback__c verificationVisit = new IB_Verification_Visit_Feedback__c(
                IB_Programme__c = [SELECT Id FROM IB_Programme__c LIMIT 1].id,
                IB_Application__c = [SELECT Id FROM IB_Application__c LIMIT 1].id
        );
        insert verificationVisit;
        
        ContentVersion contentVersion = new ContentVersion(Title           = 'ELT28 RRR',
                                                            PathOnClient   = 'Pic.jpg',
                                                            VersionData    = Blob.valueOf('Test Content'),
                                                            IsMajorVersion = true);
        insert contentVersion;
        
        ContentDocument cd = [SELECT id FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = [SELECT Id FROM IB_Verification_Visit_Feedback__c LIMIT 1].id;
        insert cdl;
        
        Test.startTest();
        	update contentVersion;
        Test.stopTest();
        System.assert([SELECT Id FROM IB_Application_Attachment__c].size() > 0);
    }
}