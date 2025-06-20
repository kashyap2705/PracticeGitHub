/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Michael D Khan      08/01/2023        PRB0041124: Apex Test Execution Failed (RejectRoleApplicationScheduleTest)
*******************************************************************************************/

@isTest (SeeAllData=false)
public class RejectRoleApplicationScheduleTest {

	public static String CRON_EXP = '0 0 0 15 3 ? 2099';

	@isTest static void testSchedulable () {
		Test.startTest();
		// Schedule the test job
      	String jobId = System.schedule('RejectRoleApplicationScheduleTest',
                        CRON_EXP, 
                        new RejectRoleApplicationSchedule());
         
      	// Get the information from the CronTrigger API object
      	CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      	// Verify the expressions are the same
      	System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      	// Verify the job has not run
      	System.assertEquals(0, ct.TimesTriggered);

      	// Verify the next time the job will run
      	System.assertEquals('2099-03-15 00:00:00', 
        String.valueOf(ct.NextFireTime));
      	
      	Test.stopTest();
	}
}