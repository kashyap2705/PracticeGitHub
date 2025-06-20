@isTest
private class InstituteApplyforRoleCtrlTest {
    
    private static testMethod void testOne() {
        Account acc1 = AccountTestDataFactory.createAccount('Association Account', null );
        acc1.External_PD_Provider__c = true;
        acc1.Lead_Account__c = true;
        insert acc1;
        Account schoolAcc = AccountTestDataFactory.createAccount('School Account', null);
        schoolAcc.IBIS_ID__c='006803';
        schoolAcc.Country__c = 'PUERTO RICO';
        schoolAcc.Sub_region__c = 'NORTHERN AMERICA';
        schoolAcc.Region__c = 'IBA';
        insert schoolAcc;
        
        Opportunity opp = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        countries.add(TestsUtil.createCountry('testname', 'EUROPE', acc1));
        countries.add(TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc1));
        insert countries;
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepo();
        repo1.Role_Name__c = 'Institute Administrator';
        insert repo1;
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc1, 'PYP');
        insert ibprog;
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp.Id, recordTypeId);
        camp1.IB_Role__c = repo1.Id;
        camp1.IB_Programme__c = repo1.Related_Programmes__c;
        camp1.Related_IB_Programme__c = ibprog.id;
        insert camp1;
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc1);
        con.AccountId=acc1.id;
        insert con;
        User u = new User();
        u = UserTestDataFactory.createUser('SCU + Advanced', u);
        u.ContactId = con.Id;
        u.IsActive = true;
        insert u;
        Test.startTest();
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, con.Id);
        ibRole1.IB_Account__c = acc1.id;
        ibRole1.IB_Programme_New__c = ibprog.id;
        ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole1.Email_Confirmed__c=true;
        ibRole1.Status__c = 'Confirmed';
        
        insert ibRole1;
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c= con.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c=con.id);
        insert ci2;
        
        system.runAs(u)
        {
            PageReference myVfPage = Page.InstituteApplyforRole;
            Test.setCurrentPage(myVfPage);
            ContactDetailsWrapper.SetFirstLoadComplete();
            
            // Put Id into the current page Parameters
            ApexPages.currentPage().getParameters().put('AccountId',acc1.Id);
            InstituteApplyforRoleCtrl ip= new InstituteApplyforRoleCtrl();
            ip.CurrentContact=con;
            ip.JobTitle='Software Engineer';
            ip.Email='test@abc.com';
            ip.Phone='+981212';
            ip.phonenumber = '1231231230';
            ip.Country_Code = 'Israel (+972)';
            ip.CurrentContact = ip.getCurrentUsersContact();
            ip.getcitynames();
            ip.submitRole();
            system.assertEquals('/ibportal/InstituteRoleApplicationSubmitted?EmailMatch=false',ip.submitRole().getUrl());
            system.assertEquals('/apex/InstituteSearch',ip.changeInstitute().getUrl());
            system.assertEquals('/ibportal/MyIBRoles',ip.cancelRole().getUrl());
            system.assertEquals(UserInfo.getLanguage(),ip.getLocale());
            ip.getLocale();
            ip.changeInstitute();
            ip.cancelRole();
        }
        Test.stopTest();
    }
  }