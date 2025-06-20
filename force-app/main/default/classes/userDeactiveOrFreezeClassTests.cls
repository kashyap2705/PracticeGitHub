/**
* <h1>Test Class For UserDeactiveOrFreezeClass. </h1>
* This Class Will test ScheduleUserFreezeAndDeactivate Class
* and userDeactiveOrFreezeClass,DE6118.
* @author  Ahmad Shakeel.
* @version 1.0
* @since   10-10-2019.
Modification Log     :                                                                              
*-------------------------------------------------------------------------------------------------- 
* Developer                   Date                   Description          Version                          
* ------------------------------------------------------------------------------------------------- 
*/
@isTest
public class userDeactiveOrFreezeClassTests 
{
 public static String CRON_EXP = '0 0 0 14 8 ? 2040';
    /**
   * This method creates list of Users having salesforce License and Will test ScheduleUserFreezeAndDeactivate Class
   * and userDeactiveOrFreezeClass.
   * @param Null
   * @return Void.
   */
    
    @isTest
    static void testScheduledJob()
    {
       
        
     List<Profile> p =  [select Id from profile where Profile.UserLicense.Name='Salesforce' Limit 1]; //OR Profile.UserLicense.Name='Salesforce Platform' is not a correct profile so it is removed
     list<User>pu=new List<User>();
     for(integer i=0;i<2;i++)
     {
        User puIn = new User(profileId = p[0].id, username = 'r@em558861ail.com'+i, email = 'r@imail.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspuwer'+i, lastname='lastnam'+i);
         pu.add(puIn);
     }
        insert pu;
        
        system.debug('leng'+pu.size());
        System.runAs(pu[0])
        {
            Test.startTest();
            String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new ScheduleUserFreezeAndDeactivate());         
            Test.stopTest();
        }
        
    }
    
}