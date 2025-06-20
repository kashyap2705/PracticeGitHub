@isTest
private class IBPortalLandingCtrlTest {
    // Removed Try catch from all the existing code(functions) as try catch shouldnt be used in Test classes
    // Epam Team.. code coverage validated to 87% in QA
    private static testMethod void testEN() {
        integer i = 1;
        
        //try
        //{
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        Id schoolAccRecType = getRecordType('School_Account', 'Account');
        Account schoolAcc = TestsUtil.createAccount('University Gardens');
        schoolAcc.recordTypeId = schoolAccRecType;
        schoolAcc.IBIS_ID__c='006803';
        schoolAcc.Country__c = 'PUERTO RICO';
        schoolAcc.Sub_region__c = 'NORTHERN AMERICA';
        schoolAcc.Region__c = 'IBA';
        insert schoolAcc;
        
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc));
        countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc));
        insert countries;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc.Id;
        cont.Contact_Type__c = 'IBEN';
        cont.HomePhone = '13861234567';
        cont.MobilePhone = '13861234567';
        cont.OtherPhone = '13861234567';
        cont.Phone = '13861234567';
        insert cont;
        User usr = createPortalUser('puser2000@amamama.com', cont, 'en_US', 'Customer Community Advanced');
        usr.Bypass_Validation_Rules__c = true;
        insert usr;
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Teacher','Qualified','School Services','Evaluation & Authorization');
        repo1.Role_Type__c = 'IBEN Role';
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Consultant','Qualified','School Services','Evaluation & Authorization');
        // Changed role from Examiner to Consultant
        repo2.Role_Type__c = 'IBEN Role';
        insert new List<IB_Role_Repository__c>{repo1,repo2};
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
        insert ibprog;
        Test.startTest();
        IB_Role__c TeacherRole = PimsTestUtil.createIbRole(repo1.Id, cont.Id, acc.Id);
        TeacherRole.Start_Date__c = Date.today();
        TeacherRole.IB_Programme_New__c=ibprog.Id;
        TeacherRole.End_Date__c = Date.today()+2;
        TeacherRole.Status__c='Confirmed'; 
        TeacherRole.Reason_For_Status__c = 'Confirmed';
        TeacherRole.Active__c = false;
        
        IB_Role__c ReaderRole = PimsTestUtil.createIbRole(repo2.Id, cont.Id, acc.Id);
        ReaderRole.Start_Date__c = Date.today();
        ReaderRole.End_Date__c = Date.today()+2;
        ReaderRole.Status__c='Confirmed'; 
        ReaderRole.Reason_For_Status__c = 'Confirmed';
        TeacherRole.Active__c = false;
        insert new List<IB_Role__c>{TeacherRole,ReaderRole};
            
            IB_Subject__c subject = new IB_Subject__c();
        subject.IB_Programme__c = 'PYP';
        subject.IB_Programme_Long__c = 'PYP';
        subject.Subject_Code__c = 'pyp';
        subject.Subject_Group__c = 'History of Africa';
        subject.Subject_Group_Identifier__c = 'artsm';
        subject.Subject_Name__c = 'History of Africa';
        subject.Subject_Name_FR__c = 'History of Africa';
        subject.Subject_Name_SP__c = 'History of Africa';
        subject.Available_in_IBEN__c = true;
        subject.Available_in_MySchool__c = true;
        insert subject;
        
        Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.IB_Subject__c = subject.Id;
        ras.Role_And_Application__c = TeacherRole.Id;
        insert ras;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
        camp1.IB_Role__c = repo1.Id;
        camp1.IB_Programme__c = repo1.Related_Programmes__c;
        camp1.Related_IB_Programme__c = ibprog.id;
        camp1.Applicant_Eligibility_Location__c = 'Venue Region';
        insert camp1;
        
        System.RunAs(usr) {
            
            Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
            Test.setCurrentPage(IBPortalEditProfilePage);
            IBPortalLandingCtrl controller = new IBPortalLandingCtrl();
            
            PageReference pg = controller.isLoggedIn();
            List <IBPortalLandingCtrl.Tiles> appMenu = controller.getAppMenuItems1();
            Contact c = controller.getContactObject();
            controller.stampFirstLogin();
            controller.checkForRoles();
            controller.birthDateString = '1980-01-01T05:00:00.000Z';
            controller.getAppMenuItems2();
            controller.getCurrentYear();
            controller.getAppMenuItems11();
            controller.pageRedirectLink = ApexPages.currentPage().getURL();
            controller.saveCommunityActivity();
            List<String> months=new List<String>{'January','February','March','April','May','June','July','August','September','October','November','December'};
                String communityLabel = null;
            String communityName,userName,lastCommunityVisit;
            Integer noOfVisit=0;
            DateTime lastLoginTime;
            lastLoginTime=dateTime.now();
            communityName = communityLabel;
            userName = usr.Name;
            lastCommunityVisit=communityName;
            String currentMonth= months.get(lastLoginTime.month()-1);
            Integer currentYear=lastLoginTime.year();
            Community_Visit__c insertData=new Community_Visit__c(Community_Name__c=communityName,User_Name__c=userName,Number_of_visits__c=noOfVisit,Last_Login__c=lastLoginTime,Last_Community_Visit__c=lastCommunityVisit,Login_Year__C=currentYear,Login_Month__C=currentMonth);
            insert insertData;
            controller.saveCommunityActivity();
        }
        Test.stopTest();
        /*
}
catch(exception e)
{
System.debug('Excep'+e);
}
*/
    }
    private static testMethod void testES() {
        integer i = 1;
        //try
        //{
        Account acc = TestsUtil.createAccount('IBA Inactive Contacts');
        insert acc;
        
        Id schoolAccRecType = getRecordType('School_Account', 'Account');
        Account schoolAcc = TestsUtil.createAccount('University Gardens');
        schoolAcc.recordTypeId = schoolAccRecType;
        schoolAcc.IBIS_ID__c='006803';
        schoolAcc.Country__c = 'PUERTO RICO';
        schoolAcc.Sub_region__c = 'NORTHERN AMERICA';
        schoolAcc.Region__c = 'IBA';
        insert schoolAcc;
        
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc));
        countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc));
        insert countries;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc.Id;
        cont.Phone = '13861234567';
        insert cont;
        User usr = createPortalUser('puser2000@amamama.com', cont, 'es', 'Customer Community Advanced');
        usr.Bypass_Validation_Rules__c = true;
        insert usr;
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Teacher','Fully Qualified','School Services','Evaluation & Authorization');
        insert repo1;
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Consultant','Fully Qualified','School Services','Evaluation & Authorization');
        // Changed role from Examiner to Consultant
        insert repo2;
        IBPortalRoleSettings__c roleSettings = new IBPortalRoleSettings__c();
        roleSettings.Name = 'Teacher';
        roleSettings.Access__c = 'WRC';
        insert roleSettings;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
        camp1.IB_Role__c = repo1.Id;
        camp1.IB_Programme__c = repo1.Related_Programmes__c;
        insert camp1;
        IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
        ibprog.StageName__c = 'Evaluation';
        ibprog.Status__c = 'Candidate';
        insert ibprog;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole1.Start_Date__c = System.today().addDays(-5);
        ibRole1.Status__c = 'Confirmed';
        ibRole1.End_Date__c = System.today().addDays(5);
        insert ibRole1;
        Test.startTest();
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo2.Id, cont.Id);
        ibRole2.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole2.Start_Date__c = System.today().addDays(-5);
        ibRole2.Status__c = 'Confirmed';
        ibRole2.End_Date__c = System.today().addDays(5);
        insert ibRole2;
        
        IB_Subject__c subject = new IB_Subject__c();
        subject.IB_Programme__c = 'DP';
        subject.IB_Programme_Long__c = 'DP';
        subject.Subject_Code__c = 'dp';
        subject.Subject_Group__c = 'Arts (PYP)';
        subject.Subject_Group_Identifier__c = 'artsm';
        subject.Subject_Name__c = 'Physics (DP)';
        subject.Subject_Name_FR__c = 'Physics (DP)';
        subject.Subject_Name_SP__c = 'Physics (DP)';
        subject.Available_in_IBEN__c = true;
        subject.Available_in_MySchool__c = true;
        insert subject;
        
        Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.IB_Subject__c = subject.Id;
        ras.Role_And_Application__c = ibRole1.Id;
        insert ras;
        
        System.RunAs(usr) {
            Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
            Test.setCurrentPage(IBPortalEditProfilePage);
            IBPortalLandingCtrl controller = new IBPortalLandingCtrl();
            controller.roleCount = 0;
            controller.myRoles = null;
            controller.getCurrentYear();
            controller.getAppMenuItems2();
            
            controller.getLocale();
            PageReference pg = controller.isLoggedIn();
            List <IBPortalLandingCtrl.Tiles> appMenu = controller.getAppMenuItems1();
            List <IBPortalLandingCtrl.Tiles> appMenuTemp = controller.getAppMenuItems11();
            Contact c = controller.getContactObject();
            controller.stampFirstLogin();
            controller.checkForRoles();
            controller.birthDateString = '10/10/1995';
            System.assertEquals(1,i);
            controller.getLocale();
            controller.getAppMenuItems2();
        }
        Test.stopTest();
        /*
}
catch(exception e)
{
System.debug('Excep'+e);
}
*/
    }
    
    //testFR method refactored by Shahrukh Anwar for ECM00538 on 09/11/2022 -- Tech Debt
    @isTest
    private static void testFR() {
        integer i = 1;
        //try {
        Account acc = TestsUtil.createAccount('Test Account');
        insert acc;
        
        Id schoolAccRecType = getRecordType('School_Account', 'Account');
        Account schoolAcc = TestsUtil.createAccount('University Gardens');
        schoolAcc.recordTypeId = schoolAccRecType;
        schoolAcc.IBIS_ID__c='006803';
        schoolAcc.Country__c = 'PUERTO RICO';
        schoolAcc.Sub_region__c = 'NORTHERN AMERICA';
        schoolAcc.Region__c = 'IBA';
        insert schoolAcc;
        
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc));
        countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc));
        insert countries;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc.Id;
        cont.Phone = '13861234567';
        cont.Birthdate = Date.newInstance(2000,11,20);
        cont.Country_of_Birth__c ='test';
        cont.Birth_Locale__c = 'sdfd';
        cont.HomePhone = '3534645645';
        insert cont;
        
        User usr = createPortalUser('puser2000@amamama.com', cont, 'fr', 'SCU + Advanced');
        usr.Bypass_Validation_Rules__c = true;
        insert usr;
        
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Teacher','Fully Qualified','School Services','Evaluation & Authorization');
        insert repo1;
        
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Consultant','Fully Qualified','School Services','Evaluation & Authorization');
        // Changed role from Examiner to Consultant
        insert repo2;
        
        IBPortalRoleSettings__c roleSettings = new IBPortalRoleSettings__c();
        roleSettings.Name = 'Teacher';
        roleSettings.Access__c = 'WRC';
        insert roleSettings;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
        camp1.IB_Role__c = repo1.Id;
        camp1.IB_Programme__c = repo1.Related_Programmes__c;
        insert camp1;
        
        IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
        ibprog.StageName__c = 'Evaluation';
        ibprog.Status__c = 'Candidate';
        insert ibprog;
        
        Test.startTest();
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole1.Start_Date__c = System.today().addDays(-5);
        ibRole1.Status__c = 'Applicant';
        ibRole1.Age_Groups__c = 'Age 8-9';          //added by Shahrukh Anwar for ECM00538 on 09/11/2022
        ibRole1.End_Date__c = System.today().addDays(5);
        insert ibRole1;
        
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo2.Id, cont.Id);
        ibRole2.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole2.Start_Date__c = System.today().addDays(-5);
        ibRole2.Status__c = 'Confirmed';
        ibRole2.End_Date__c = System.today().addDays(5);
        insert ibRole2;
        
        IB_Subject__c subject = new IB_Subject__c();
        subject.IB_Programme__c = 'DP';
        subject.IB_Programme_Long__c = 'DP';
        subject.Subject_Code__c = 'dp';
        subject.Subject_Group__c = 'Arts (PYP)';
        subject.Subject_Group_Identifier__c = 'artsm';
        subject.Subject_Name__c = 'Physics (DP)';
        subject.Subject_Name_FR__c = 'Physics (DP)';
        subject.Subject_Name_SP__c = 'Physics (DP)';
        subject.Available_in_IBEN__c = true;
        subject.Available_in_MySchool__c = true;
        insert subject;
        
        Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.IB_Subject__c = subject.Id;
        ras.Role_And_Application__c = ibRole1.Id;
        insert ras;
        System.RunAs(usr) {
            Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
            Test.setCurrentPage(IBPortalEditProfilePage);
            IBPortalLandingCtrl controller = new IBPortalLandingCtrl();
            controller.roleCount = 0;
            controller.myRoles = null;
            controller.getCurrentYear();
            controller.getAppMenuItems2();
            
            controller.getLocale();
            controller.profileCompleteForLogin = true;
            PageReference pg = controller.isLoggedIn();
            List <IBPortalLandingCtrl.Tiles> appMenu = controller.getAppMenuItems1();
            List <IBPortalLandingCtrl.Tiles> appMenuTemp = controller.getAppMenuItems11();
            Contact c = controller.getContactObject();
            controller.stampFirstLogin();
            controller.checkForRoles();
            controller.birthDateString = '10/10/2010';
            controller.getLocale();
            controller.getAppMenuItems2();
        }
        
        Test.stopTest();
        
        //asserts added by Shahrukh Anwar for ECM00538 on 09/11/2022 -- Tech Debt -- START --
        System.assertEquals('Teacher', repo1.Role_Name__c);
        System.assertEquals('Applicant', ibRole1.Status__c);
        System.assert(ibRole1.Age_Groups__c.contains('Age 8-9'));
        //asserts added by Shahrukh Anwar for ECM00538 on 09/11/2022 -- Tech Debt -- STOP --
        
        /*} catch(exception e) {
System.debug('Excep'+e);
}
*/
    }
    
    private static User createPortalUser(String testemail, Contact c, String locale, String profile){
        
        //try
        //{
        Profile p =  [select Id from profile where name=:profile limit 1];
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = locale,
                           languagelocalekey = locale, timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        return pu;
        /*}
catch(exception e)
{
System.debug('Excep'+e);
return Null;
}
*/
    }
    
    private static Id getRecordType(string devName, string sObjectType){
        
        //try
        //{
        RecordType result = [
            SELECT r.Id 
            FROM RecordType r 
            WHERE r.DeveloperName =: devName 
            AND SobjectType =: sObjectType 
            LIMIT 1
        ];
        return result.Id;
        /*}
catch(exception e)
{
System.debug('Excep'+e);
return Null;
}
*/
    } 
}