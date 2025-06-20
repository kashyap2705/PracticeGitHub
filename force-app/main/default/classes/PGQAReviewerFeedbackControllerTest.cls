/*
* <h1> PGQAReviewerFeedbackController </h1>
* This class is created to test the functionality of PGQAReviewerFeedback Page Controller
* 
* @author  Arbaz - Plumlogix
* @version 1.0
* @since   2021-06-07 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                     Version                          

* ------------------------------------------------------------------------------------------------- 
  Arbaz                    2021-10-06             Created the Controller            1.0

*/
@isTest
public with sharing class PGQAReviewerFeedbackControllerTest {
    
    public static testMethod void testMethod1(){
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        PGQA__c subject = new PGQA__c();
        subject.Name = 'PGQA school subject';
        subject.English__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.Spanish__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.French__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.Unavailable__c = false;
        insert subject;
        
        Case case1 = new Case();
        case1.Subject = 'PGQA – Nov 2021 - 01256958 – ALBANIAN A: Literature HL';
        // case1.PGQA_Subject_Level_Language__r.English__c ='Maths';
        case1.PGQA_Examiner_1__c=con.Id;
        case1.PGQA_Examiner_1_Review_Status__c='In-Progress';
        case1.PGQA_Subject_Level_Language__c = subject.id;
        insert case1;
        
        
        PGQA_Sample__c PGQA1 = new PGQA_Sample__c();
        PGQA1.PGQA_Case__c = case1.Id; 
        insert PGQA1;
        
        Test.startTest();
        PGQAReviewerFeedbackController.getuserLanguage();
        
        
        PageReference pageRef = Page.PGQAReviewerFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',case1.id);
        PGQAReviewerFeedbackController  controller = new PGQAReviewerFeedbackController();
        controller.init();
        controller.UpdateSample();
        System.assertNotEquals(null,controller.getoverall());
        Test.stopTest();
        
    }
    public static testMethod void testMethod2(){
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        
        PGQA__c subject = new PGQA__c();
        subject.Name = '1';
        subject.English__c = 'PGQA – Test';
        subject.Spanish__c = 'PGQA – Test';
        subject.French__c = 'PGQA – Test';
        subject.Unavailable__c = false;
        insert subject;
        
        Case case1 = new Case();
        
        case1.PGQA_Examiner_2__c=con.Id;
        case1.PGQA_Examiner_1_Review_Status__c='Complete';
        case1.PGQA_Examiner_2_Review_Status__c='In-Progress';
        case1.PGQA_Subject_Level_Language__c = subject.id;
        insert case1;
        
        
        PGQA_Sample__c sample1 = new PGQA_Sample__c();
        sample1.PGQA_Name__c='Sample 1';
        sample1.PGQA_Candidate_Full_Name__c='Ali Khan';
        sample1.PGQA_Candidate_Session_Number__c='1234';
        sample1.PGQA_Canidate_Predicted_Grade__c='3';
        sample1.PGQA_Case__c=case1.id;
        insert sample1;
        
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert contentVersion_1;
        ContentVersion contentVersion_2 = new ContentVersion(
            Title = 'Peng',
            PathOnClient = 'Peng.jpg',
            VersionData = Blob.valueOf('Test Content 2')
        );
        insert contentVersion_2;
        ContentVersion contentVersion_3 = new ContentVersion(
            Title = 'abc',
            PathOnClient = 'abc.jpg',
            VersionData = Blob.valueOf('Test Content 3')
        );
        insert contentVersion_3;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_1.id
        ].ContentDocumentId;
        cdl.LinkedEntityId = sample1.id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
        insert cdl;
        ContentDocumentLink cd2 = new ContentDocumentLink();
        cd2.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_2.id
        ].ContentDocumentId;
        cd2.LinkedEntityId = sample1.id;
        cd2.Visibility = 'AllUsers';
        cd2.ShareType = 'V';
        insert cd2;
        ContentDocumentLink cd3 = new ContentDocumentLink();
        cd3.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_3.id
        ].ContentDocumentId;
        cd3.LinkedEntityId = sample1.id;
        cd3.Visibility = 'AllUsers';
        cd3.ShareType = 'V';
        insert cd3;
        ContentVersion contentVersion_list = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        Test.startTest();
        
        PGQAReviewerFeedbackController.getuserLanguage();
        
        PageReference pageRef = Page.PGQAReviewerFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',case1.id);
        PGQAReviewerFeedbackController pgctrl1 = new PGQAReviewerFeedbackController();
        pgctrl1.init();
        pgctrl1.SampleData();
        pgctrl1.UpdateSample();
        pgctrl1.check_examiner_1=true;
        pgctrl1.check_examiner_2=true;
        PGQA_Sample__c mySample = new PGQA_Sample__c();
        mySample.PGQA_Case__c = case1.id;
        
        mySample.PGQA_Candidate_Full_Name__c = 'Test1';
        mySample.PGQA_Canidate_Predicted_Grade__c = '2';
        mySample.PGQA_Candidate_Full_Name__c = 'Test2';
        insert mySample;
        
        Sample samplerecord = new Sample(mySample,pgctrl1.check_examiner_1,pgctrl1.check_examiner_2);
        samplerecord.getgrade();
        samplerecord.getProposedGradeList(); 
        samplerecord.getRelatedFilesByRecordId(mySample.Id);
        
        PGQAReviewerFeedbackController  controller = new PGQAReviewerFeedbackController();
        
        controller.SubjectName='PGQA school subject';
        
        Test.stopTest();
        
    }
}