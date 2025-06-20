@isTest
private class IBPortalLoginCtrlTest {
    
    @isTest 
    static void test_method_one() {
        
        integer i=1;
        
        PageReference loginPage = Page.IBPortalLogin;
        Test.setCurrentPage(loginPage);
        IBPortalLoginCtrl controller = new IBPortalLoginCtrl();
        
        Boolean showbanner = controller.getshowbanner();
        String currLocale = controller.getLocale();
        
        IBPortalLoginCtrl.invitationID = 'ID';
        controller.labelWelcom = 'test';
        
        account acct = TestsUtil.createAccount('Test Account');
        acct.IBIS_ID__c = '717171';
        acct.Country__c = 'UNITED STATES';
        acct.Sub_region__c = 'NORTHERN AMERICA';
        acct.Region__c = 'IBAEM';
        acct.Language_Of_Correspondance__c = 'English';
        
        insert acct;
        
        System.debug('ID: '+acct.id);
        
        controller.isLoggedIn();
        IBPortalLoginCtrl.errorCount = null;
        Integer errors = IBPortalLoginCtrl.errorCount;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','IBAEM',acct);
        insert country;
        
        Contact contactib = TestsUtil.createContact('Dummyeng', 'dummyeng@gmail.com','dummyeng@yahoo.com',Date.valueOf('2001-01-01'), country);
        contactib.AccountId = acct.id;
        contactib.Country__c = country.id;
        contactib.Invitation_ID__c  ='test';
        insert contactib;
        
        Contact contactibsp = TestsUtil.createContact('Dummysp', 'dummysp@gmail.com','dummysp@yahoo.com',Date.valueOf('2001-01-02'), country);
        contactibsp.AccountId = acct.id;
        contactibsp.Country__c = country.id;
        insert contactibsp;
        
        Contact contactibfr = TestsUtil.createContact('Dummyfr', 'dummyfr@gmail.com','dummyfr@yahoo.com',Date.valueOf('2001-01-03'), country);
        contactibfr.AccountId = acct.id;
        contactibfr.Country__c = country.id;
        insert contactibfr;
        
        
        
        IB_Role_Repository__c role =  TestsUtil.createRoleRepoWithParams('Chief Examiner', 'Fully Qualified', 'Learning Centre', 'Administratio');
        insert role;
        
        IB_Role_Repository__c role1 =  TestsUtil.createRoleRepoWithParams('Examiner', 'Fully Qualified', 'Learning Centre', 'Administratio');
        insert role1;
        
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test123@abc.com',job__c='Job',roleId__c=String.valueof(role.id),IB_Contact__c=contactib.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck',phone__c='+981212',job__c='Job',roleId__c=String.valueof(role.id),IB_Contact__c=contactibsp.id);
        insert ci2;
        
        IB_Role__c ibrole1 = TestsUtil.createIbRole(role1.id,contactib.id);
        ibrole1.Programme_Selection__c = 'DP';
        ibrole1.Upskilled_in_PSP__c = '2020';
        ibRole1.Contact_Information_Email__c=ci.id;
        insert ibrole1;
        
       	IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        theRoleRepo2.Role_Type__c = 'School Role';
        theRoleRepo2.Permission_Set_Name__c = 'Programme Coordinator';
        insert new List<IB_Role_Repository__c>{theRoleRepo2};
            
        IB_Role__c ibrole2 = TestsUtil.createIbRole(theRoleRepo2.id,contactib.id);
        ibrole2.Programme_Selection__c = 'DP';
        ibrole2.Upskilled_in_PSP__c = '2020';
        ibrole2.Contact_Information_Email__c=ci.id;
        insert ibrole2;
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Basic'];
        
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', contactid = contactib.id,UserName='ibportaltestuser@test.com');
        User usrfr = new User(Alias = 'ibport', Email='ibportaluserfr@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr',
                              LocaleSidKey='en_US', ProfileId = p.Id,contactid = contactibfr.id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuserfr@test.com');
        usrfr.isActive=false;
        User usrsp = new User(Alias = 'ibport', Email='ibportalusersp@testorg.com',
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
                              LocaleSidKey='en_US', ProfileId = p.Id,contactid = contactibsp.id,
                              TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestusersp@test.com');
        usrsp.isActive=false;
        insert new List<User>{usrfr,usrsp,usr};      
            
         IBPortalLoginCtrl.invitationContact = contactib;
        IBPortalLoginCtrl.userContact =contactib;
        
        User createPortalUser = TestsUtil.createPortalUser('test123');
        createPortalUser.isActive = false;
        insert createPortalUser;
        
        System.setPassword(usr.Id, 'Hello@123');
        
        Test.startTest();
        
        PageReference pagelogin = Page.IBPortalLogin;
        Test.setCurrentPage(pagelogin); 
        String startUrl = pagelogin.getUrl();
        pagelogin.getParameters().put('username', usr.UserName);
        pagelogin.getParameters().put('password', 'Hello@123');
        pagelogin.getParameters().put('startUrl', startUrl);
        pagelogin.getParameters().put('inviteID', 'test');
        Test.setCurrentPage(pagelogin);      
        
        controller.username = usr.Username;
        controller.password = 'Hello@123';
        
        IBPortalLoginCtrl.inviteRolesList = new List<IB_Role__c>();
        //IBPortalLoginCtrl.inviteRolesList.add(headOfSchoolRole);
        IBPortalLoginCtrl.inviteRolesList.add(ibrole1);
        IBPortalLoginCtrl.invitationContact = contactib;
        IBPortalLoginCtrl.userContact =contactib;
        IBPortalLoginCtrl.rolesList = new List<IB_Role__c>();
        //IBPortalLoginCtrl.rolesList.add(headOfSchoolRole);
        IBPortalLoginCtrl.rolesList.add(ibrole1);
        IBPortalLoginCtrl.getvaluesbyLanguage('fr');
        IBPortalLoginCtrl.login(createPortalUser.username,'Hello@123','fr','Test');
        IBPortalLoginCtrl.login(usr.username,'12345','es','Test');
        IBPortalLoginCtrl.login(usrfr.username,'12345','en_US','Test');
        IBPortalLoginCtrl.login(usrsp.username,'12345','en_US','Test');
        IBPortalLoginCtrl.iblogin(usrsp.username,'12345','en_US','Test');
        controller.isLoggedIn();
        IBPortalLoginCtrl.saveCommunityActivity(usr.username);
        IBPortalLoginCtrl.errorCount = null;
        
        System.assertEquals(22,IBPortalLoginCtrl.getvaluesbyLanguage('fr').values().size());
        
        Integer IBPortalLoginCtrl = IBPortalLoginCtrl.errorCount;
        
        
        
        Test.stopTest();
    }
    @istest
    static void test_method_Else() {
        test.starttest();
        User createPortalUser = TestsUtil.createPortalUser('test123');
        createPortalUser.isActive = false;
        insert createPortalUser;
        List<String> months=new List<String>{'January','February','March','April','May','June','July','August','September','October','November','December'};
            String communityLabel = null;
        String communityName,userName,lastCommunityVisit;
        Integer noOfVisit=0;
        DateTime lastLoginTime;
        lastLoginTime=dateTime.now();
        communityName = 'ibportal';//communityLabel;
        userName = createPortalUser.Name;
        lastCommunityVisit=null;
        String currentMonth= months.get(lastLoginTime.month()-1);
        Integer currentYear=lastLoginTime.year();
        Community_Visit__c insertData=new Community_Visit__c(Community_Name__c=communityName,User_Name__c=createPortalUser.UserName,Number_of_visits__c=noOfVisit,Last_Login__c=lastLoginTime,Last_Community_Visit__c=lastCommunityVisit,Login_Year__C=currentYear,Login_Month__C=currentMonth);
        insert insertData;
        IBPortalLoginCtrl.saveCommunityActivity(createPortalUser.userName);
        test.stopTest();
    }
}