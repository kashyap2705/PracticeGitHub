@isTest
public class ChatterTriggersTests {
   static Profile p;
   static User u;
	static void setupData(){
      p = [SELECT Id FROM Profile WHERE Name='Deactivated Users - Level 1']; 
      u = new User(Alias = 'newUser', Email='ChatterTriggersTests@ibo.org', 
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
         LocaleSidKey='en_US', ProfileId = p.Id, 
         TimeZoneSidKey='America/Los_Angeles', UserName='ChatterTriggersTests@ibo.org');
      insert u;
    }
   public static testMethod void preventChatterUploadFileForProfileTest() { 
      setupData();
      //Check for Exception when Propertie is not configured
      System.runAs(u) {
      	  try {
      	      FeedItem item =  new FeedItem (Body= 'Test', parentId = u.Id );
      	      insert item;
      	  } catch (DMLException exc) {
              System.assert(exc.getMessage().contains(Label.IBENPortal_Error_NoCustomSettingChatterPrevention + 'NotAllowedChatterProfiles.'));
      	  }
      	      
      }
   }

   public static testMethod void preventChatterPostForProfileTest1(){
      setupData();
      NotAllowedChatterProfiles__c prof = new NotAllowedChatterProfiles__c(name= 'NotAllowedChatterProfiles');
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      prof.ids__c = ((String)sysAdminProfile.Id).substring(0, 15);
      insert prof;
      System.runAs(u) {
           try {
               FeedItem item =  new FeedItem (Body= 'Test', parentId = u.Id );
              
               insert item;
               
               
           } catch (DMLException exc) {
              System.assert(exc.getMessage().contains('Chatter for our External Stakeholder'));
           }
     
               
      }
   }

   public static testMethod void preventChatterPostForProfileTest2(){
      setupData();
      NotAllowedChatterProfiles__c prof = new NotAllowedChatterProfiles__c(name= 'NotAllowedChatterProfiles');
      prof.ids__c = ((String)p.Id).substring(0, 15);
      insert prof;
      
      System.runAs(u) {
           try {
               FeedItem item =  new FeedItem (Body= 'Test', parentId = u.Id );
               insert item;
               //System.assert(false, 'Should not be this because current user not allow to to do this !' );
           } catch (DMLException exc) {
              System.assert(exc.getMessage().contains('Chatter for our External Stakeholder'));
           }
     
               
      }
   }
}