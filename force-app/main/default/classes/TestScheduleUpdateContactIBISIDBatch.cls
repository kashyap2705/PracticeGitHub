@isTest
private class TestScheduleUpdateContactIBISIDBatch {
    @isTest static void test() {
        Test.startTest();
        ScheduleUpdateContactIBISIDBatch schedule = new ScheduleUpdateContactIBISIDBatch();
        String sch = '0 0 23 * * ?'; // schedule to run every day at 11 PM
        String jobID = system.schedule('Schedule_Update_Contact_IBIS_ID', sch, schedule);
        Test.stopTest();
    }
}