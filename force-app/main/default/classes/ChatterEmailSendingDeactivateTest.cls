/**
* <h1>Test ChatterEmailSendingDeactivate</h1>
* This Test Class will test the ChatterEmailSendingDeactivate and SchduleChatterEmailSendingDeactivate.
* 
* @author  Ahmad Shakeel
* @version 1.0
* @since   2019-10-10 
  
*/
@isTest
public class ChatterEmailSendingDeactivateTest {
    
    
     public static String CRON_EXP = '0 0 0 14 7 ? 2040';
     /**
   * This method will create test data to to deactivate email sending.
   * @param No parameters.
   * @return Void.
   */
    
    
    
    @isTest
    static void testScheduledJob()
    {
        List<User> uu=new List<User>();
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        
       
         
        
        IB_Address__c tmpAdd = new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = theAccount.Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        );
        insert tmpAdd;
          IB_Programme__c tmpProg = new IB_Programme__c(
            Exam_Session__c = 'STRUNK',
            Primary_Language_of_Instruction__c = 'English',
            Status__c = 'Invited',
            Street_Address__c = tmpAdd.Id,
            Account__c = theAccount.Id
        );
       

        insert tmpProg;
         Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
           
          
          user pu=PimsTestUtil.createPortalUserPYP('tes@yeee.com', true);
          insert pu;
        uu.add(pu);
      System.runAs(pu)
        {
            Test.startTest();
            // Schedule the test job
            String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new SchduleChatterEmailSendingDeactivate());    
            ChatterEmailSendingDeactivate ce=new ChatterEmailSendingDeactivate();
            Database.QueryLocator ql = ce.start(null);
            ce.execute(null,uu);
			ce.Finish(null);
   
            Test.stopTest();
        }
        
    }
    
    

}