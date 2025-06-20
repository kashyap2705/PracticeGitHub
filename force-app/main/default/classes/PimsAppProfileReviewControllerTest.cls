@isTest
private class PimsAppProfileReviewControllerTest {
    @TestSetup
    static void setupTestData() {
        String roleName = 'Head of School';
        String accountName = 'test account name';
        String contactName = 'test contact name';
        String testemail = 'testgck123@test.com'; 
        
		Account acc = AccountTestDataFactory.createAccount(null,null);
		acc.Name = accountName;
		acc.PIMS_Step_1__c = true;
        acc.PIMS_Step_2__c = true;
        acc.PIMS_Step_3__c = true;
        acc.PIMS_Step_4__c = true;
        acc.PIMS_Step_5__c = true;
        acc.Year_Founded__c = '1990';
        acc.Academic_Start_Month__c = 'August';
        acc.Academic_End_Month__c = 'May';
        acc.Month_Founded__c = 'January';
        acc.Language_Of_Correspondance__c = 'English';
        insert acc;
		
		Contact contactRecord = ContactTestDataFactory.createContact(null,null);
		contactRecord.AccountId = acc.Id;
		contactRecord.Salutation = 'Mr.';
        contactRecord.LastName = contactName;
        contactRecord.FirstName = contactName;
        contactRecord.Email = testemail;
        contactRecord.MobilePhone = '+30992907711';
        contactRecord.HomePhone = '+30992907711';
        contactRecord.Birthdate = Date.today().addYears(-22);
        contactRecord.Alternative_Email__c  = 'noname@example.commm';
        contactRecord.MailingCity = 'Palm Coast';
        contactRecord.MailingState = 'Florida';
        contactRecord.MailingCountry = 'United States';
        contactRecord.MailingPostalCode = '32137';
        contactRecord.MailingStreet = 'street';
        contactRecord.AccountId = acc.Id;
        contactRecord.Full_time_Part_time__c = 'Full Time';
        contactRecord.Number_of_years_at_school__c = '4';
        contactRecord.Phone = '+13861234567';
        contactRecord.Qualifications__c = 'BS';
        contactRecord.Job_Title__c = 'Blah';
        contactRecord.Birth_Locale__c   = 'sea';
        contactRecord.Country_of_Birth__c = 'Armenia';
		insert contactRecord;

        Integer year =  Date.Today().Year();   
        string Year1 =string.valueOf(year);
        year++;    
        string Year2 = string.valueof(year).right(2);
        String CurrentYear = Year1 + '-' + Year2;
		List<IB_Role_Repository__c> repoList = new List<IB_Role_Repository__c>();
		IB_Role_Repository__c repo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
		repo1.Role_Name__c = 'Programme Coordinator';
        repoList.add(repo1);
		IB_Role_Repository__c repo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
		repo2.Role_Name__c = 'Billing Contact';
        repoList.add(repo2);
		IB_Role_Repository__c repo3 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
		repo3.Role_Name__c = 'Exam Contact';
        repoList.add(repo3);
		IB_Role_Repository__c repo4 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
		repo4.Role_Name__c = 'Head of School';
        repoList.add(repo4);
		IB_Role_Repository__c repo5 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
		repo5.Role_Name__c = 'Head of School (Overall)';
        repoList.add(repo5);
		insert repoList;
		
		Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];
		
		User externalUser = UserTestDataFactory.createUser('SCU + Advanced',null);
		externalUser.contactId = contactRecord.id;
		externalUser.email = testemail;
		externalUser.IsActive = true;
        insert externalUser;	
		
		Account theAccount = AccountTestDataFactory.createAccount('School Account',null);
		theAccount.Name = accountName + ' new';
        theAccount.Language_Of_Correspondance__c = 'English';
        theAccount.Legal_Status__c = 'Private';
        theAccount.Lead_Account__c = true;
        insert theAccount;
		
		
		IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme(null,null); 
        insert prog;
		
		Account acc2 =[select id from account where id =:prog.Account__c];
        Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), acc2);
        insert theContact;
		
		IB_Role_Repository__c theRoleRepo = [select Id from  IB_Role_Repository__c where Role_Name__c = 'Programme Coordinator' limit 1];
		IB_Role__c theRole= IBRoleTestDataFactory.createRole(null);
        theRole.IB_Role__c = theRoleRepo.Id;
        theRole.IB_Programme_New__c = prog.Id;
        theRole.IB_Account__c = prog.Account__c;
        theRole.IB_Contact__c = theContact.Id;
        theRole.Programme_Selection__c = 'PYP';
        insert theRole; 
		
		IB_View_State_Contacts__c ib_View=new IB_View_State_Contacts__c(Contact_ID__c=theContact.Id,Account_ID__c=theAccount.id,Active__c=true);                
        insert ib_View;
		
		IB_Application__c app = new IB_Application__c();
        app.Name = 'Test1 App';
        app.AFC_Assessment_Status__c = 'Complete';
        app.AFC_Collaborative_Planning_Status__c = 'Complete';
        app.AFC_Documents_Status__c = 'Complete';
        app.AFC_Implementation_Budget_Status__c = 'Complete';
        app.AFC_Leadership_Structure_Status__c = 'Complete';
        app.AFC_Philosophy_Status__c = 'Complete';
        app.AFC_Profile_Review_Status__c = 'Complete';
        app.AFC_Programme_Information_Status__c = 'Complete';
        app.AFC_Resources_Support_Status__c = 'Complete';
        app.AFC_School_Description_Status__c = 'Complete';
        app.AFC_Subject_Proposal_Status__c = 'Complete';
        app.AFC_Written_Curriculum_Status__c = 'Complete';
        app.Application_Lookup_to_Programme__c = prog.Id;
        app.Is_Agreement_Confirmed__c=false;
        insert app;
		
		SchoolSections__c s1 = SchoolSectionTestDataFactory.createSchoolSection(null);
        s1.Account__c = theAccount.Id;
        s1.Academic_Year__c = CurrentYear;
		insert s1;
        
	}
	
	
    @isTest
    static void PimsAppProfileReviewControllerTestMethod()
    {	
		List<Account> theAccount =[select id,name,recordtype.developerName  from account where recordtype.developerName ='School_Account' and name = 'test account name new'];
        IB_Application__c app =[select id from IB_Application__c limit 1 ];
        
        Test.startTest();    
			SchoolSections__c sec2 = [select id from SchoolSections__c];          
			ApexPages.currentPage().getParameters().put('id', app.Id);
			ApexPages.currentPage().getParameters().put('tab', 'profile');
			PimsAppProfileReviewController obj = new PimsAppProfileReviewController();
			obj.account = theAccount[0];
			
			PageReference PimsApplicationForAuthorization = Page.PimsDashboard;
			Test.setCurrentPage(PimsApplicationForAuthorization);	
			List<SchoolSections__c> secList = new List<SchoolSections__c>();
			secList.add(sec2);
			obj.sections = secList;
			obj.prCompletionStatus=NULL;
			obj.activeTab=NULL;
			obj.redirectUrl=NULL;
			obj.roleCnt=NULL;
			obj.programme=NULL;
			obj.application=NULL;
			obj.addresses=NULL;
			obj.contacts=NULL;
			obj.getAcdemicYearList();
			obj.save();
			System.assertEquals(obj.account,theAccount[0]);
		Test.stopTest();       
    }
    
}