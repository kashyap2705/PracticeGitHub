@isTest

public class RedirectToRecognitionPageTest{
        
    public static testMethod void redirectToRecognitionPage () {
        Profile profile= [Select Id from profile where Name='System Administrator'];         
        User user = createUser('usertestname2@xxx.com', 'test23_user_lastName', 'yy34yyy@yyyy.com', true,profile,'en_US');
        insert user;
       
        system.runAs(user)
        {
            redirectToRecognitionPage redirectToRecognition = new redirectToRecognitionPage();
            pageReference pagereference = redirectToRecognition .redirectToRecognitionURL();
            Test.setCurrentPage(pagereference);
        }
     }
    
    public static testMethod void redirectToRecognitionPageForFrenchUser ()
    {
        Profile profile= [Select Id from profile where Name='System Administrator'];         
        User user = createUser('usertestname212@xxx.com', 'test23_user_lastName', 'yy343yyy@yyyy.com', true,profile,'fr');
        insert user;
        
        system.runAs(user)
        {
            redirectToRecognitionPage redirectToRecognition = new redirectToRecognitionPage();
            pageReference pagereference = redirectToRecognition .redirectToRecognitionURL();
            Test.setCurrentPage(pagereference);
        }
        
    }
    
    public static testMethod void redirectToRecognitionPageForSpanishUser ()
    {
        Profile profile= [Select Id from profile where Name='System Administrator'];         
        User user = createUser('usertestname2@cnx.com', 'test23_user_lastName', 'yy434yyy@yyyy.com', true,profile,'es');
        insert user;
        
        system.runAs(user)
        {
            redirectToRecognitionPage redirectToRecognition = new redirectToRecognitionPage();
            pageReference pagereference = redirectToRecognition .redirectToRecognitionURL();
            Test.setCurrentPage(pagereference);
        }
        
    }
    
    private static User createUser (String userName, String lastName, String email, Boolean isActive, Profile prof,String locale){
        return new User(
            alias = (userName + '123456781234').replace('.','').replace('@','').substring(0,8),  
            Email = email, emailencodingkey='UTF-8', LastName = lastName, languagelocalekey='en_US',
            localesidkey=locale, 
            timezonesidkey='America/Los_Angeles', Username = userName, 
            CommunityNickname = 'Nick_' + userName, IsActive = isActive, ProfileId = prof.Id );
        
    }
}