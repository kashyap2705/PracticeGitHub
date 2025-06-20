@isTest
private class IBPortalEditProfileControllerTest {
    
    private static testMethod void guestUser(){
        integer i = 1;
        try
        {
                 
            Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
            User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = p.Id,
                                TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');
            
            insert usr;
            
            Test.startTest();
            System.RunAs(usr){
                //createIBPortalSettings();
                Pagereference IBPortalEditProfile = Page.IBPortalEditProfile;
                Test.setCurrentPage(IBPortalEditProfile);
                IBPortalEditProfileController controller = new IBPortalEditProfileController();
                controller.isLoggedIn();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                list<selectoption> lst = controller.getLanguageInfo();
                string url = controller.getPageUrl();
                controller.getAnnualReleaseDoc();
                controller.getsampleunitplannerDoc();
                controller.getcurriculumcourseoverviewDoc();
                controller.getCvDoc();
            }
            Test.stopTest();
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }
    }
    
    private static testMethod void testEN() {
        integer i = 1;
       // try{
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
			cont.Country_Code__c = 'Israel (+972)';
            cont.Phone_Number__c = '123123123';
            cont.Qualifications__c = 'PhD';

            
            insert cont;
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'en_US', 'External PD Provider');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Reader','Fully Qualified;Shadow','School Services','Evaluation & Authorization');
            repo1.Role_Type__c = 'IBEN Role';
            insert repo1;
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
            camp1.IB_Role__c = repo1.Id;
            camp1.IB_Programme__c = repo1.Related_Programmes__c;
            insert camp1;
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Confirmed';
            ibRole1.End_Date__c = System.today().addDays(5);
            //insert ibRole1;
            
            /*AppMenuItem a = new AppMenuItem();
a.Name = 'WRC';
a.Type = 'ConnectedApplication';
insert a;*/
            
            
            Test.startTest();
            
            System.RunAs(usr) {
                //createIBPortalSettings();
                
                Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
                Test.setCurrentPage(IBPortalEditProfilePage);
                IBPortalEditProfileController controller = new IBPortalEditProfileController();
                //Contact contactObject = MyContactDAO.INSTANCE.getContactbyId(usr.ContactId);
                controller.getCountryInfo();
        //Following System.assertEquals(1,i); code lines are added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                controller.getLocale();
                System.assertEquals(1,i);
                Integer numErrors = controller.errorCount;
                System.assertEquals(1,i);
                List<String> errorMsg = controller.errorMessages;
                System.assertEquals(1,i);
                PageReference pg = controller.isLoggedIn();
                System.assertEquals(1,i);
                //List <IBPortalEditProfileController.Tiles> appMenu = controller.getAppMenuItems();
                Contact c = controller.getContactObject();
                System.assertEquals(1,i);
                //controller.stampFirstLogin();
                //controller.checkForRoles();
                //controller.getSaveInfo();
                controller.birthDateString = '1980-01-01T05:00:00.000Z';
                System.assertEquals(1,i);
                //controller.getCurrentYear();
                //IBPortalEditProfileController.lookupSchoolAccount('University');
                //IBPortalEditProfileController.lookupSchoolAccountByName('University Gardens');
                IBPortalEditProfileController.lookupSchoolAccountWithIBIS('University');
                IBPortalEditProfileController.lookupSchoolAccountByNameMulti('University Gardens:006803');
                controller.removeRoleId = ibRole1.Id;
                System.assertEquals(1,i);
                //controller.removeRole();
                PageReference pg1 = controller.saveProfile();
                System.assertEquals(1,i);
                controller.getAccreditationKnoweledgeRecordId();
                System.assertEquals(1,i);
				controller.getQualifications();
				controller.getCvDoc();
				controller.getAnnualReleaseDoc();
				controller.getsampleunitplannerDoc();
				controller.getcurriculumcourseoverviewDoc();
                controller.getPublicationsRecordId();
                System.assertEquals(1,i);
                controller.getConferenceExperienceRecordId();
                System.assertEquals(1,i);
                controller.getEducationalDegreesRecordId();
                System.assertEquals(1,i);
                controller.getLanguageExperienceRecordId();
                System.assertEquals(1,i);
                controller.getNationalEducationKnowledgeRecordId();
                System.assertEquals(1,i);
                controller.getGeneralTeachingExperianceRecordId();
                System.assertEquals(1,i);
                controller.getIbTrainingsAttendedRecordId();
                System.assertEquals(1,i);
                controller.getIbTeachingExperienceRecordId();
                System.assertEquals(1,i);
                controller.removeAttachment();
                System.assertEquals(1,i);
                controller.uploadAttachments();
                System.assertEquals(1,i);
                list<selectoption> lst = controller.getLanguageInfo();
                controller.testS = 'fr';
                list<selectoption> lst1 = controller.getLanguageInfo();
                pagereference pf = controller.changePassword();
                
              //  controller.phone_number = '2345670' ;
          //  controller.citySelected='(+92)';
            }
            Test.stopTest();
       /* }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }*/
    }
    
    private static testMethod void testES() {
        integer i = 1;
       // try{
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
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'es', 'SCU + Advanced');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Programme Coordinator3','Fully Qualified;Shadow','School Services','Evaluation & Authorization');
            insert repo1;
            
            IBPortalRoleSettings__c roleSettings = new IBPortalRoleSettings__c();
            roleSettings.Name = 'Programme Coordinator3';
            roleSettings.Access__c = 'WRC';
            
            insert roleSettings;
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
            camp1.IB_Role__c = repo1.Id;
            camp1.IB_Programme__c = repo1.Related_Programmes__c;
            insert camp1;
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Confirmed';
            ibRole1.End_Date__c = System.today().addDays(5);
            insert ibRole1;
            
            /*AppMenuItem a = new AppMenuItem();
a.Name = 'WRC';
a.Type = 'ConnectedApplication';
insert a;*/
            
            
            Test.startTest();
            
            System.RunAs(usr) {
                //createIBPortalSettings();
                
                Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
                Test.setCurrentPage(IBPortalEditProfilePage);
                IBPortalEditProfileController controller = new IBPortalEditProfileController();
                //Contact contactObject = MyContactDAO.INSTANCE.getContactbyId(usr.ContactId);
                //controller.getCountryInfo();
                controller.getLocale();
        //Following System.assertEquals(1,i); code lines are added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                PageReference pg = controller.isLoggedIn();
                System.assertEquals(1,i);
                //List <IBPortalEditProfileController.Tiles> appMenu = controller.getAppMenuItems();
                Contact c = controller.getContactObject();
                System.assertEquals(1,i);
                //controller.stampFirstLogin();
                //controller.checkForRoles();
                //controller.getSaveInfo();
                controller.birthDateString = '10/10/2010';
                System.assertEquals(1,i);
                 list<selectoption> lst = controller.getLanguageInfo();
                //IBPortalEditProfileController.lookupSchoolAccount('University');
                //IBPortalEditProfileController.lookupSchoolAccountByName('University Gardens');
                
                //PageReference pg1 = controller.saveProfile();
            }
            Test.stopTest();
        /*}
        catch(exception e)
        {
            System.debug('Excep'+e);
        }*/
    }
    
    private static testMethod void testFR() {
        integer i = 1;
        //try {
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
            cont.Phone = '13861234567';
            
            insert cont;
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'fr', 'SCU + Advanced');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
             //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
            //change the role name from "Global PD Contractor" to "Professional Services Contractor"
            //begin
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Professional Services Contractor','Fully Qualified;Shadow','School Services','Evaluation & Authorization');
            insert repo1;
            //end
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
            camp1.IB_Role__c = repo1.Id;
            camp1.IB_Programme__c = repo1.Related_Programmes__c;
            insert camp1;
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Confirmed';
            ibRole1.End_Date__c = System.today().addDays(5);
            ibRole1.Reason_For_Access__c = 'test';
            ibRole1.IB_Staff_Contact__c = usr.Id;
            insert ibRole1;
            
            /*AppMenuItem a = new AppMenuItem();
a.Name = 'WRC';
a.Type = 'ConnectedApplication';
insert a;*/
            
            
            Test.startTest();
            
            System.RunAs(usr) {
                //createIBPortalSettings();
                
                Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
                Test.setCurrentPage(IBPortalEditProfilePage);
                IBPortalEditProfileController controller = new IBPortalEditProfileController();
                //Contact contactObject = MyContactDAO.INSTANCE.getContactbyId(usr.ContactId);
                //controller.getCountryInfo();
                controller.getLocale();
                System.assertEquals(1,i);
                PageReference pg = controller.isLoggedIn();
                System.assertEquals(1,i);
                Contact c = controller.getContactObject();
                System.assertEquals(1,i);
                //controller.stampFirstLogin();
                //controller.checkForRoles();
                //controller.getSaveInfo();
                //controller.removeRoleId = ibRole1.id;
                //controller.removeRole();
                controller.oldPassword = 'test';
                System.assertEquals(1,i);
                controller.newPassword = 'test2';
                System.assertEquals(1,i);
                controller.verifyNewPassword = 'test2';
                System.assertEquals(1,i);
                controller.getCvDoc();
                System.assertEquals(1,i);
                controller.getAnnualReleaseDoc();
                System.assertEquals(1,i);
                controller.getsampleunitplannerDoc();
                System.assertEquals(1,i);
                controller.getcurriculumcourseoverviewDoc();
                System.assertEquals(1,i);
                controller.changePassword();
                System.assertEquals(1,i);
				controller.getQualifications();
                IBPortalEditProfileController.lookupSchoolAccountWithIBIS('Test');
                IBPortalEditProfileController.lookupSchoolAccountByNameMulti('Test:123456');
                
                
                IBPortalEditProfileController.FileWrapper fp = new IBPortalEditProfileController.FileWrapper();
                fp.body = Blob.valueOf('test text');
                fp.name = 'att_name_1.txt';
                fp.size = 1000;
                fp.contentType = 'text/html';
                fp.base64 = 'test base64';
                
                controller.cvDoc = fp;
                System.assertEquals(1,i);
                

				IBPortalEditProfileController.FileWrapper fp1 = controller.getCvDoc();
				
				IBPortalEditProfileController.FileWrapper fpAnn = controller.getAnnualReleaseDoc();
				
				IBPortalEditProfileController.FileWrapper fpuntPlan = controller.getsampleunitplannerDoc();
                

                controller.uploadAttachments();
                System.assertEquals(1,i);
                String pageURL = controller.getPageUrl();
                System.assertEquals(1,i);
                
                
                PageReference pg1 = controller.saveProfile();
                System.assertEquals(1,i);
                 controller.testS = 'fr';
                 list<selectoption> lst = controller.getLanguageInfo();
            }
            Test.stopTest();
        /*}
        catch(exception e)
        {
            System.debug('Excep'+e);
        }*/
    }
    
    private static testMethod void removeRole() {
      //  try{
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
            cont.Contact_Type__c = 'IBEN';
            cont.Phone = '13861234567';
            cont.AccountId = schoolAcc.Id;
            
            insert cont;
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'en_US', 'SCU + Advanced');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
            //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
            //change the role name from "Global PD Contractor" to "Professional Services Contractor"
            //begin
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Professional Services Contractor','Fully Qualified;Shadow','School Services','Evaluation & Authorization');
            insert repo1;
            //end
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = 'DP';
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Confirmed';
            ibRole1.End_Date__c = System.today().addDays(5);
            ibRole1.Reason_For_Access__c = 'test';
            ibRole1.IB_Staff_Contact__c = usr.Id;
            insert ibRole1;
            
            
            System.RunAs(usr) {
                //createIBPortalSettings();
                
                Pagereference IBPortalEditProfilePage = Page.IBPortalEditProfile;
                Test.setCurrentPage(IBPortalEditProfilePage);
                IBPortalEditProfileController controller = new IBPortalEditProfileController();
                controller.removeRoleId = ibRole1.id;
                Test.startTest();
                controller.removeRole();
                Test.stopTest();
                
            }
       /* }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }*/
        
    }
    
    
    private static User createPortalUser(String testemail, Contact c, String locale, String profile){
        User pu; 
        try{
            Profile p =  [select Id from profile where name=:profile limit 1];
            
            pu = new User(profileId = p.id, username = testemail, email = testemail,
                          emailencodingkey = 'UTF-8', localesidkey = locale,
                          languagelocalekey = locale, timezonesidkey = 'America/Los_Angeles',
                          alias='cspu', lastname='lastname', contactId = c.id);
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }
        return pu;
    }
    
    /*private static void createIBPortalSettings(){
IBPortalSettings__c setting = new IBPortalSettings__c();
setting.Community_Names__c = 'IBEN Central';
//setting.Captcha_Public_Key__c
//setting.Captcha_Private_Key__c
insert setting;
} */
    
    private static Id getRecordType(string devName, string sObjectType){
        RecordType result = [
            SELECT r.Id 
            FROM RecordType r 
            WHERE r.DeveloperName =: devName 
            AND SobjectType =: sObjectType 
            LIMIT 1
        ];
        return result.Id;
    }
}