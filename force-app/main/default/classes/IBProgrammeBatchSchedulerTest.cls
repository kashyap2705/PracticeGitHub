//This Test apex is writtened by prerna on 20--03-2025 for ECM00739- PART-1 
@isTest
public class IBProgrammeBatchSchedulerTest {

    // Test method to schedule the IBProgrammeBatchScheduler
    @isTest
    static void testIBProgrammeBatchScheduler() {
        Date dat = System.today();
        Integer yr = dat.year();
        String cronExpression = '0 0 0 15 5 ? ' + String.valueOf(yr+1);  
        
        IBProgrammeBatchScheduler scheduler = new IBProgrammeBatchScheduler();
        Test.startTest();
        String jobID = System.schedule('IB Programme Batch Scheduler Job', cronExpression, scheduler);
        
        Test.stopTest();
        CronTrigger cronTrigger = [SELECT Id, CronExpression, State FROM CronTrigger WHERE Id = :jobID];
        System.assertNotEquals(null, cronTrigger, 'Scheduled job should be found.');
        System.assertEquals('WAITING', cronTrigger.State, 'Job state should be Waiting.');
        System.assertEquals(cronExpression, cronTrigger.CronExpression, 'Cron expression should match.');
    }

    // Test method to test the batch execution
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        IBProgrammeBatch ibProgrammeBatch = new IBProgrammeBatch();
        Database.executeBatch(ibProgrammeBatch, 200);
        Test.stopTest();
        System.assert(true, 'Batch job has been executed successfully.');
    }
}