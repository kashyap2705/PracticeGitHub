@isTest
public class ContentDocumentTriggerHandlerTest {
    
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
    static void validateFileDeletion(){
        ContentVersion contentVersion = new ContentVersion(Title           = 'IBCF',
                                                            PathOnClient   = 'Pic.jpg',
                                                            VersionData    = Blob.valueOf('Test Content'),
                                                            IsMajorVersion = true);
        insert contentVersion;
        
        ContentDocument cd = [SELECT id FROM ContentDocument LIMIT 1];
        
        IB_Application_Attachment__c ibaa = new IB_Application_Attachment__c(); 
        ibaa.Attachment__c = cd.Id;
        ibaa.IB_Programme__c = [SELECT Id FROM IB_Programme__c LIMIT 1].Id;
        insert ibaa; 
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = [SELECT Id FROM IB_Consultant_Feedback__c LIMIT 1].id;
        insert cdl;
        Test.startTest();
    		Delete([SELECT id FROM ContentDocument]);
        Test.stopTest();
        System.assert([SELECT id FROM IB_Application_Attachment__c].size() == 0);
    }
}