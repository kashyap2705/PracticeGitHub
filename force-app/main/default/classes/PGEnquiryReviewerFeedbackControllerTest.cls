@isTest
public with sharing class PGEnquiryReviewerFeedbackControllerTest {
    
    public static testMethod void testMethod1(){
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        Case case1 = new Case();
        case1.Subject='SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        case1.Examiner_1__c=con.Id;
        case1.Examiner_1_Review_Status__c='In-Progress';
        insert case1;
        
        Subject__c subject = new Subject__c();
        subject.Name = '1';
        subject.English__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.Spanish__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.French__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.Unavailable__c = false;
        insert subject;
        
        
        Test.startTest();
        //PGEnquiryReviewerFeedbackController controller1= new PGEnquiryReviewerFeedbackController();
        PGEnquiryReviewerFeedbackController.getuserLanguage();
        //List<SelectOption> options = controller1.getPredictedList();
        PageReference pageRef = Page.PGEnquiryReviewerFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',case1.id);
        PGEnquiryReviewerFeedbackController  controller = new PGEnquiryReviewerFeedbackController();
        controller.Decision_value='Flag';
        System.assertNotEquals(null,controller.UpdateCase());
        controller.Decision_value='rejected';
        System.assertNotEquals(null,controller.UpdateCase());
        System.assertNotEquals(null,controller.getPredictedList());
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
        Case case1 = new Case();
        case1.Subject='SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        case1.Examiner_2__c=con.Id;
        case1.Examiner_1_Review_Status__c='Complete';
        case1.Examiner_2_Review_Status__c='In-Progress';
        case1.Examiner_2_Decision__c='Flag for Assessment escalation – predicted grade should be lower or higher';
        insert case1;
        
        Subject__c subject = new Subject__c();
        subject.Name = '1';
        subject.English__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.Spanish__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.French__c = 'SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH';
        subject.Unavailable__c = false;
        insert subject;
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert contentVersion_1;
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_1.id
        ].ContentDocumentId;
        cdl.LinkedEntityId = case1.id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
        insert cdl;
        ContentDistribution cd = new ContentDistribution();
        cd.ContentVersionId = contentVersion_1.id;
        cd.Name = contentVersion_1.Title;
        cd.PreferencesNotifyOnVisit = false;
        insert cd;
        Test.startTest();
        //PGEnquiryReviewerFeedbackController controller1= new PGEnquiryReviewerFeedbackController();
        PGEnquiryReviewerFeedbackController.getuserLanguage();
        PGEnquiryReviewerFeedbackController.getSiPGESubject('SIPGE – May 2021 - 01042693 – MATHEMATICS APPLICATIONS AND INTERP SL in ENGLISH');
        //List<SelectOption> options = controller1.getPredictedList();
        PageReference pageRef = Page.PGEnquiryReviewerFeedback;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id',case1.id);
        PGEnquiryReviewerFeedbackController  controller = new PGEnquiryReviewerFeedbackController();
        controller.Decision_value='Flag';
        controller.AgreeChk=true;
        controller.SubjectName='';
        System.assertNotEquals(null,controller.UpdateCase());
        
        controller.Decision_value='rejected';
        System.assertNotEquals(null,controller.UpdateCase());
        controller.Decision_value='upheld';
        System.assertNotEquals(null,controller.UpdateCase());
        System.assertNotEquals(null,controller.getPredictedList());
        Test.stopTest();
        
    }
    
}