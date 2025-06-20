@isTest
public class IBConsultantFeedbackUpdaterTest {

    @isTest static void testBatch() {
         Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.Language_Of_Correspondance__c = 'Spanish';
        insert acc;
        
        IB_Application__c app = PimsTestUtil.createApplication();
        app.Name = 'PYP ' + app.Name + ' Application for Candidacy';
        app.RecordTypeId = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Candidacy').Id;
        app.Status__c = 'Submitted';

        app.OwnerId = UserInfo.getUserId();

        insert app;
        IB_Programme__c programme = IbProgramFactoryTest.createProgrammeForAccount(acc,'PYP');
        programme.StageName__c = 'Consultation process';
        programme.Status__c = 'Interested';
        insert programme;

        RecordType initialVisitRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'IB_Consultant_Feedback__c' AND Name = 'Initial Visit' LIMIT 1];
        IB_Consultant_Feedback__c initialVisit = new IB_Consultant_Feedback__c(
            RecordTypeId = initialVisitRecordType.Id,
            Status__c = 'Published',
            IB_Programme_Lookup__c = programme.Id,
            A1_Analysis_Findings__c = 'Clearly demonstrated',
            A1_CV_EOC_Findings_and_Next_Steps__c = 'Some next steps',
            IB_Application__c = app.id
        );
        insert initialVisit;

        RecordType endOfProcessRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'IB_Consultant_Feedback__c' AND Name = 'End of Process' LIMIT 1];
        IB_Consultant_Feedback__c endOfProcess = new IB_Consultant_Feedback__c(
            RecordTypeId = endOfProcessRecordType.Id,
            Status__c = 'Completed',
            IB_Programme_Lookup__c = programme.Id,
            IB_Application__c = app.id
        );
        insert endOfProcess;

        Test.startTest();
        IBConsultantFeedbackUpdater batch = new IBConsultantFeedbackUpdater();
        Database.executeBatch(batch, 1); // Use a batch size of 1 for testing
        
        ConsultantFeedbackUpdaterBatch feedbackBatch = new ConsultantFeedbackUpdaterBatch();
        feedbackBatch.endOfProcessRecordIds = new List<Id>{endOfProcess.Id}; // Passing the End of Process record ID
        Database.executeBatch(feedbackBatch, 1); // Use a batch size of 1 for testing
        Test.stopTest();

        endOfProcess = [SELECT Id, A1_IV_Analysis_For_Reporting__c, A1_IV_Next_Steps_for_Reporting__c FROM IB_Consultant_Feedback__c WHERE Id = :endOfProcess.Id];
        
        System.assertEquals('Clearly demonstrated', endOfProcess.A1_IV_Analysis_For_Reporting__c, 'Analysis findings should be copied to IV_Analysis_For_Reporting__c');
        System.assertEquals('Some next steps', endOfProcess.A1_IV_Next_Steps_for_Reporting__c, 'Next steps should be copied to IV_Next_Steps_for_Reporting__c');
        
        List<AsyncApexJob> jobs = [SELECT Status FROM AsyncApexJob WHERE ApexClass.Name = 'IBConsultantFeedbackUpdater'];
        System.assertEquals('Completed', jobs[0].Status, 'Batch job should complete successfully');
    }
}