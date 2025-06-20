@isTest(SeeAllData=True)
public class caseOwnerChangeOnUserDeactivateTest {
    
    @isTest
    static void testScheduledJob()
    {
        Account testAccount = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        testAccount.Programme_Recognised__c='DP Courses';
        insert testAccount;
        
        Contact firstTestContact = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), testAccount);
        firstTestContact.AccountId=testAccount.id;
        insert firstTestContact;
        
        Contact secondTestContact = PimsTestUtil.createContact('Test Contact11', 'a@ab.com', 'a@ab.com', Date.newInstance(1981, 1, 1), testAccount);
        secondTestContact.AccountId=testAccount.id;
        insert secondTestContact;
        
        Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
        Id communityprofileId = [select Id from Profile where name='system administrator' and UserLicenseId=:userLicenseId].id;
        
        User systemUser = new User(Alias = 'ibport', Email='testeng1415@gmail.com',
                                   EmailEncodingKey='UTF-8',FirstName='TriagePageTest17', LastName='Testing17', LanguageLocaleKey='en_US',
                                   LocaleSidKey='en_US', ProfileId = communityprofileId,
                                   TimeZoneSidKey='America/Los_Angeles', UserName='testeng1415@gmail.com', IsActive = False);
        
        systemUser.Bypass_Validation_Rules__c = true;
        insert systemUser;
        User systemUserChanged = new User(Alias = 'ibport1', Email='testeng14135@gmail.com',
                                          EmailEncodingKey='UTF-8',FirstName='TriagePageTest137', LastName='Testing137', LanguageLocaleKey='en_US',
                                          LocaleSidKey='en_US', ProfileId = communityprofileId,
                                          TimeZoneSidKey='America/Los_Angeles', UserName='testeng14135@gmail.com', IsActive = False);
        
        systemUserChanged.Bypass_Validation_Rules__c = true;
        insert systemUserChanged;
        
        Profile profile =  [select Id from profile where Name='Customer Community Advanced' limit 1];
        User communityUser = new User(profileId = profile.id, username = 'testeng1213@gmail.com', email = 'testeng1213@gmail.com',
                                      emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                      languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                      alias='cspu', lastname='lastname', contactId = secondTestContact.id, IsActive = false);
        insert communityUser;
        
        Case userCase = new Case(Subject='Test11',OwnerId = communityUser.id,Status = 'Open');
        insert userCase;
        userCase.OwnerId = systemUser.id;
        update userCase;
        userCase.OwnerId = systemUserChanged.id;
        update userCase;
        Case userCaseSecond = new Case(Subject='Test113',OwnerId = communityUser.id,Status = 'Open');
        insert userCaseSecond;
        
        Group queueGroup = [select Id from Group where  Type = 'Queue' AND NAME = 'SO Customer Service' Limit 1];
        List<Case> caseList = [Select id from Case where ownerid =:queueGroup.id Limit 100];
        caseList.add(userCase);
        caseList.add(userCaseSecond);
        Set<ID> idList = new Set<ID>();
        for(Case caseValue : caseList)
        {
            idList.add(caseValue.id);
        }
        
        Test.startTest();
        caseOwnerChangeOnUserDeactivate classObjectUserDeactivate = new caseOwnerChangeOnUserDeactivate(); //ur batch class
        classObjectUserDeactivate.userCasesID = idList;
        classObjectUserDeactivate.userCases = caseList;
        database.executebatch(classObjectUserDeactivate);  
        ScheduledcaseOwnerChangeOnUserDeactivate scheduledTest = new ScheduledcaseOwnerChangeOnUserDeactivate();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, scheduledTest);
        Test.stopTest();
        
    }
}