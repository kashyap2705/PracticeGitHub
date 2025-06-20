@isTest
public class SharingContactBatchTest {

    @isTest static void TestOne() {
		TestsUtil.initMyStaffingEvents();
        Test.startTest();
		
        SharingContactBatchSch scbcs = new SharingContactBatchSch();
        String newExeTime = '0 0 3 * * ?';
        String jobId = System.schedule('Scheduler Test', newExeTime, scbcs);
		
		Test.stopTest();
	}
}