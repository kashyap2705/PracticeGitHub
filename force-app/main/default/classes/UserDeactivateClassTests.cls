@isTest(SeeAllData=False)
public class UserDeactivateClassTests 
{
    public static String CRON_EXP = '0 0 0 14 7 ? 2040';
    @isTest
    static void testScheduledJob()
    {
        try{
          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        }
        Catch(exception e){
            
        }
        Profile p =  [select Id from profile where Name='Customer Community Basic' limit 1];
        
        /* User pu = new User(profileId = p.id, username = 'rs@email.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);
          insert pu;*/
         
          user pu=PimsTestUtil.createPortalUserPYP('tes@yeee.com', true);
          pu.ProfileId = p.id;
          insert pu;
        
        
   //    System.runAs(pu)
     //   {
            Test.startTest();
            // Schedule the test job
            try{
            String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new ScheduleUserDeactivate());
            String jobId2 = System.schedule('ScheduledApexTest2',CRON_EXP, new ScheduleUserDeactivation5DayWarning()); 
            String jobId3 = System.schedule('ScheduledApexTest3',CRON_EXP, new ScheduleUserDeactivation30DayWarning()); 
            }
            catch(Exception e){
                
     //       }
            // Verify the scheduled job has not run yet.
            
            // Stopping the test will run the job synchronously
            Test.stopTest();
        }
        
    }
    
    @isTest
    static void testBatchJob(){
        test.startTest();
        Database.executeBatch(new UserDeactivateClass());
        Database.executeBatch(new UserDeactivation30DayWarning());
        Database.executeBatch(new UserDeactivation5DayWarning());
        test.stopTest();
    }
    
}