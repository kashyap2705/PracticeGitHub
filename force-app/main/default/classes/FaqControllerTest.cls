@isTest
private class FaqControllerTest
{
    //This Part is being added by Suraj Parihar on 1-Jan-2023 for ECM00572
     @isTest
    static void testFaq() {
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        Profile p = [Select Id from Profile where name = 'System Administrator'];
        
        User thisUser = new User(Id=UserInfo.getUserId());
        thisUser.UserRoleId = r.Id;
        update thisUser;
        
        Contact con;
        
        System.runAs ( thisUser ) {
            Account acc = TestsUtil.createAccount('acctest');
            insert acc;
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country', 'Europe', acc);
            insert country;
            
            con = TestsUtil.createContact('Suraj', 'Test@gmail.com', 'TestPro@gmail.com', System.today(), country);  
            con.AccountId=acc.id;
            insert con;
            
            IB_Role_Repository__c roleRepo = TestsUtil.createRoleRepo();
            roleRepo.Role_Name__c='Consultant';
            insert roleRepo;
            
            IB_Role__c ibRole = TestsUtil.createIbRole(roleRepo.Id, con.Id);
            insert ibRole;
            
        }
        
        
        User user = new User();
        user.ProfileID = [Select Id From Profile Where Name='SCU + Advanced'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'test@uniquedomain.com';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'no@email.com';
        user.IsActive = true;
        user.ContactId = con.Id;
        
        insert user;
        
        System.runAs (user) {
            FaqController faq = new FaqController();
        }
      }
}