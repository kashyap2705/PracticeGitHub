@isTest
private class IBPortalEditRoleInfoControllerTest {
    
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
    
    private static testMethod void testEditRoleInfo() {
        integer i = 1;
        try{
            Account acc = TestsUtil.createAccount('twretwretr');
            insert acc;
            
            Id schoolAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
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
            insert cont;
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'en_US', 'External PD Provider');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Reader','Fully Qualified','School Services','Evaluation & Authorization');
            repo1.Role_Type__c = 'IBEN Role';
            insert repo1;
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
            camp1.IB_Role__c = repo1.Id;
            camp1.IB_Programme__c = repo1.Related_Programmes__c;
            insert camp1;
            
            Contact_Information__c newConInfoEmail = new Contact_Information__c(IB_Contact__c = cont.Id, Email__c = 'abc@abc.test',
                                                                                    Name = 'abc@abc.test', 
                                                                                    RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId());
            insert newConInfoEmail;
            Contact_Information__c newConInfoPhone = new Contact_Information__c(IB_Contact__c = cont.Id, Phone__c = '(+972)1231231233',
                                                                                    Name = '+65123456789', Phone_Number__c='1231231233', Country_Code__c='Israel (+972)',
                                                                                    RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
            insert newConInfoPhone;
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Applicant';
            ibRole1.Email_Confirmed__c = true;
            ibRole1.End_Date__c = System.today().addDays(5);
            ibRole1.Reason_For_Status__c = 'Confirmed';
            ibRole1.Contact_Information_Email__c = newConInfoEmail.Id;
            ibRole1.Contact_Information_Email_Text__c = newConInfoEmail.Email__c;
            ibRole1.Contact_Information_Phone__c = newConInfoPhone.Id;
            
            insert ibRole1;
            Test.startTest();
            
            System.RunAs(usr) {
                Pagereference IBPortalEditRoleInfoPage = Page.IBPortalEditRoleInfo;
                Test.setCurrentPage(IBPortalEditRoleInfoPage);
                system.debug('ibRole1.Id: ' + ibRole1.Id);
                ApexPages.currentPage().getParameters().put('id',ibRole1.Id);
                IBPortalEditRoleInfoController controller = new IBPortalEditRoleInfoController();
                controller.isLoggedIn();
                List<String> errorMsg = controller.errorMessages;
                Integer errCount = controller.errorCount;
                string lang = controller.getLocale();
                controller.conInfoEmail.Email__c = 'abcd@abc.test';
                controller.conInfoPhone.phone__c = '+65123456798';
                Pagereference pr1 = controller.saveProfile();
                Pagereference pr2 = controller.cancelProfile();
                
                controller.citySelected = 'Israel (+972)';
                controller.phone = '1231231230';
                
                /*EditRolePhoneComponentController controller1 = new EditRolePhoneComponentController();
                system.debug('ibRole1.Id: ' + ibRole1.Id);
                controller1.roleAppId = ibRole1.Id;
                //controller = new EditRolePhoneComponentController();
                //controller1.getcitynames();
                Pagereference pr3 = controller1.create();*/
            }
            Test.stopTest();
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }
    }
    private static testMethod void testEditPhone() {
        integer i = 1;
        try{
            Account acc = TestsUtil.createAccount('twretwretr');
            insert acc;
            
            Id schoolAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
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
            
            User usr = createPortalUser('puser2000@amamama.com', cont, 'en_US', 'External PD Provider');
            usr.Bypass_Validation_Rules__c = true;
            insert usr;
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Reader','Fully Qualified','School Services','Evaluation & Authorization');
            repo1.Role_Type__c = 'IBEN Role';
            insert repo1;
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            
            Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc.Id, opp.Id, recordTypeId);
            camp1.IB_Role__c = repo1.Id;
            camp1.IB_Programme__c = repo1.Related_Programmes__c;
            insert camp1;
            
            Contact_Information__c newConInfoEmail = new Contact_Information__c(IB_Contact__c = cont.Id, Email__c = 'abc@abc.test',
                                                                                    Name = 'abc@abc.test', 
                                                                                    RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId());
            insert newConInfoEmail;
            Contact_Information__c newConInfoPhone = new Contact_Information__c(IB_Contact__c = cont.Id, Phone__c = '+65123456789',
                                                                                    Name = '+65123456789', 
                                                                                    RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
            insert newConInfoPhone;
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont.Id);
            ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
            ibRole1.Start_Date__c = System.today().addDays(-5);
            ibRole1.Status__c = 'Applicant';
            ibRole1.Email_Confirmed__c = true;
            ibRole1.End_Date__c = System.today().addDays(5);
            ibRole1.Contact_Information_Email__c = newConInfoEmail.Id;
            ibRole1.Contact_Information_Email_Text__c = newConInfoEmail.Email__c;
            ibRole1.Contact_Information_Phone__c = newConInfoPhone.Id;
            insert ibRole1;
            Test.startTest();
                EditRolePhoneComponentController controller1 = new EditRolePhoneComponentController();
                system.debug('ibRole1.Id: ' + ibRole1.Id);
                controller1.roleAppId = ibRole1.Id;
                //controller = new EditRolePhoneComponentController();
                controller1.getcitynames();
                controller1.citySelected = 'Singapore (+65)';
                controller1.Phone = '123456798';
                Pagereference pr3 = controller1.create();
                controller1.Phone = '+65123456798';
                Pagereference pr4 = controller1.create();
            Test.stopTest();
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }
    }
}