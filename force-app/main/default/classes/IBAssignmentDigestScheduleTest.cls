/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      08/01/2023         <<PRB0041114>> Apex Test Execution Failed (IBAssignmentDigestScheduleTest)
*******************************************************************************************/
@isTest (SeeAllData=false)


public class IBAssignmentDigestScheduleTest {
    
    private static Date tod = system.today();
	private static String years = String.valueof(tod.year() +1);
    //private static String CRON_EXP = '0 0 0 15 9 ? 2025';
    private static String CRON_EXP = '0 0 0 '+ tod.day() + ' ' + tod.month() + ' ? ' +    years; 
    @isTest static void testSchedulable () {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('IBAssignmentDigestScheduleTest',
                                       CRON_EXP, 
                                       new IBAssignmentDigestSchedule());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
      
        
        Test.stopTest();
    }
}