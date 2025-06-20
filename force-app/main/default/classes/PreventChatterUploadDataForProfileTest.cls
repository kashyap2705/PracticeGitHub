@isTest
private class PreventChatterUploadDataForProfileTest {
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
    public static testMethod void preventChatterPostForProfileTest1(){
      setupData();
      NotAllowedChatterProfiles__c prof = new NotAllowedChatterProfiles__c(name= 'NotAllowedChatterProfiles');
      Profile sysAdminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      prof.ids__c = ((String)sysAdminProfile.Id).substring(0, 15);
      insert prof;
      System.runAs(u) {
           try {
               FeedItem item =  new FeedItem (Body= 'Test', parentId = u.Id );
               PreventChatterUploadDataForProfile obj = new PreventChatterUploadDataForProfile();
        
        obj.isAllowedUserProfile();
               insert item;
               
               
           } catch (DMLException exc) {
              System.assert(exc.getMessage().contains('Chatter for our External Stakeholder'));
           }
     
               
      }
   }
    @isTest
    static void PreventChatterUploadDataForProfileTestMethod()
    {
        PreventChatterUploadDataForProfile obj = new PreventChatterUploadDataForProfile();
        
        obj.isAllowedUserProfile();
        
    }

}