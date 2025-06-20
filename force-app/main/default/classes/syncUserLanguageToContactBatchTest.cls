@isTest
public class syncUserLanguageToContactBatchTest {

    @isTest
    static void testBatchMethod(){
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibo.org');
        insert u;
        
        Database.executeBatch(new syncUserLanguageToContactBatch(), 200);
    }
    
    @isTest
    static void testScheduleBatch(){
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibo.org');
        insert u;
        
        String CRON_EXP = '0 0 0 14 7 ? 2040';
        System.schedule('ScheduledApexTest',CRON_EXP, new SchedulesyncUserLanguageToContactBatch());
    }
}