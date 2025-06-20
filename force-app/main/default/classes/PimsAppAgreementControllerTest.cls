@isTest
private class PimsAppAgreementControllerTest {
    @testSetup static void setup() {
        Test.startTest();
        Account acc = AccountTestDataFactory.createAccount(null,null);
        acc.External_PD_Provider__c = true;
        acc.Lead_Account__c = true;
        insert acc;

        Contact con = new Contact();
        con = ContactTestDataFactory.createContact('', con);
        con.AccountId = acc.Id;
        insert con;

        IB_Address__c add = new IB_Address__c();
        add.Name = 'Postal';
        add.IB_Account__c = acc.Id;
        add = IBAddressTestDataFactory.createIBAddressInstance(add);
        insert add;
        
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme('CP', null);
        prog.Account__c = acc.Id;
        prog.Street_Address__c = add.Id;
        insert prog;

        IB_Role_Repository__c repo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
        repo.Role_Name__c = 'Programme Coordinator'; 
        repo.Category__c = 'Programme Development';
        insert repo;

        IB_Role__c theRole = new IB_Role__c(
                IB_Role__c = repo.Id,
                IB_Programme_New__c = prog.Id,
                IB_Account__c = acc.Id,
                IB_Contact__c = con.Id
            );
            theRole = IBRoleTestDataFactory.createRole(theRole);
            insert theRole;


        Test.stopTest();
    }
    @isTest static  void test_method_one() {
          //integer i =1;
          
          IB_Programme__c prog = [Select id from IB_Programme__c Limit 1][0];
          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
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

          app.AFC_Assessment_Status__c = 'Complete';
         
         
          system.debug('app ====> '+app);

          Pagereference pgRef = Page.PimsApplicationForCandidacy;
          Test.setCurrentPage(pgRef);
          pgRef.getParameters().put('id',app.Id);
          pgRef.getParameters().put('tab','agreement');

          PageService.isActiveTabCached = true;
          PageService.activeTab = 'agreement';

          PimsAppAgreementController con = new PimsAppAgreementController();

        
          con.isChanged=true;
       
         boolean flag=con.isChanged;
          con.agmtCompletionStatus = 'Complete';
         con.confirmChange();
          con.saveAgreement();
          }
     
     //This part is being added by Ali-Plumlogix on 7/23/2020,US-11961
     //This change is done because for AFC Section C1,C2,C3 and C4 is removed
     //Begin
     @isTest static void test_method_two() {
            Contact theContact= [Select id from Contact Limit 1][0];
            IB_Programme__c theProgramme = [Select id from IB_Programme__c Limit 1][0];
            
            IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                RecordTypeId = Schema.SObjectType.IB_Application__c.getRecordTypeInfosByName().get('Application for Authorization').getRecordTypeId(),
                AFC_Assessment_Status__c = 'Complete',
                AFC_Collaborative_Planning_Status__c = 'Complete' ,
                AFC_Documents_Status__c = 'Complete' ,
                AFC_Implementation_Budget_Status__c = 'Complete' ,
                AFC_Leadership_Structure_Status__c = 'Complete' ,
                AFC_Philosophy_Status__c = 'Complete' ,
                AFC_Profile_Review_Status__c = 'Complete' ,
                AFC_Programme_Information_Status__c = 'Complete' ,
                AFC_Resources_Support_Status__c = 'Complete' ,
                AFC_School_Description_Status__c = 'Complete' ,
                AFC_Subject_Proposal_Status__c = 'Complete' ,
                AFC_Written_Curriculum_Status__c = 'Complete',
                Is_Agreement_Confirmed__c=true
            );
            insert theApp;
           theApp.AFC_Assessment_Status__c = 'Complete';
            Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
                Type__c = 'Programme coordinator',
                IB_Application_Lookup__c = theApp.Id
            );
            insert progCoordTime;
            
            Test.startTest();
         
         
          system.debug('app ====> '+theApp);

          Pagereference pgRef = Page.PimsApplicationForAuthorization;
          Test.setCurrentPage(pgRef);
          pgRef.getParameters().put('id',theApp.Id);
          pgRef.getParameters().put('tab','agreement');

          PageService.isActiveTabCached = true;
          PageService.activeTab = 'agreement';

          PimsAppAgreementController con = new PimsAppAgreementController();

        
          con.isChanged=true;
       
         boolean flag=con.isChanged;
          con.agmtCompletionStatus = 'Complete';
          con.confirmChange();
          con.saveAgreement();
          Test.stopTest();

	}//End
    @isTest static void test_method_one_fail() {//these 3 tests made for INC0183856
          IB_Programme__c prog = [Select id from IB_Programme__c Limit 1][0];
          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.AFC_Assessment_Status__c = 'In Progress';
          app.AFC_Collaborative_Planning_Status__c = 'In Progress';
          app.AFC_Documents_Status__c = 'In Progress';
          app.AFC_Implementation_Budget_Status__c = 'In Progress';
          app.AFC_Leadership_Structure_Status__c = 'In Progress';
          app.AFC_Philosophy_Status__c = 'In Progress';
          app.AFC_Profile_Review_Status__c = 'In Progress';
          app.AFC_Programme_Information_Status__c = 'In Progress';
          app.AFC_Resources_Support_Status__c = 'In Progress';
          app.AFC_School_Description_Status__c = 'In Progress';
          app.AFC_Subject_Proposal_Status__c = 'In Progress';
          app.AFC_Written_Curriculum_Status__c = 'In Progress';
          app.Application_Lookup_to_Programme__c = prog.Id;
          app.Is_Agreement_Confirmed__c=false;
          insert app;

         app.AFC_Assessment_Status__c = 'Complete';
         
         
          system.debug('app ====> '+app);
          Test.startTest();
          Pagereference pgRef = Page.PimsApplicationForCandidacy;
          Test.setCurrentPage(pgRef);
          pgRef.getParameters().put('id',app.Id);
          pgRef.getParameters().put('tab','agreement');

          PageService.isActiveTabCached = true;
          PageService.activeTab = 'agreement';

          PimsAppAgreementController con = new PimsAppAgreementController();

        
          con.isChanged=true;
       
         boolean flag=con.isChanged;
          con.agmtCompletionStatus = 'Complete';
         con.confirmChange();
          con.saveAgreement();
          Test.stopTest();

	}
    @isTest static void test_method_two_fail() {//these 3 tests made for INC0183856 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usrfr = new User(Alias = 'ibport', Email='ibportaluserfr@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr',
                            LocaleSidKey='en_US', ProfileId = p.Id,IsActive=true,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuserfr@testorg.com');
        
        insert usrfr;
          IB_Programme__c prog = [Select id from IB_Programme__c Limit 1][0];
          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.AFC_Assessment_Status__c = 'In Progress';
          app.AFC_Collaborative_Planning_Status__c = 'In Progress';
          app.AFC_Documents_Status__c = 'In Progress';
          app.AFC_Implementation_Budget_Status__c = 'In Progress';
          app.AFC_Leadership_Structure_Status__c = 'In Progress';
          app.AFC_Philosophy_Status__c = 'In Progress';
          app.AFC_Profile_Review_Status__c = 'In Progress';
          app.AFC_Programme_Information_Status__c = 'In Progress';
          app.AFC_Resources_Support_Status__c = 'In Progress';
          app.AFC_School_Description_Status__c = 'In Progress';
          app.AFC_Subject_Proposal_Status__c = 'In Progress';
          app.AFC_Written_Curriculum_Status__c = 'In Progress';
          app.Application_Lookup_to_Programme__c = prog.Id;
          app.Is_Agreement_Confirmed__c=false;
          insert app;

         app.AFC_Assessment_Status__c = 'Complete';
         
          Test.startTest();
          system.debug('app ====> '+app);
          system.runAs(usrfr){
          Pagereference pgRef = Page.PimsApplicationForCandidacy;
          Test.setCurrentPage(pgRef);
          pgRef.getParameters().put('id',app.Id);
          pgRef.getParameters().put('tab','agreement');

          PageService.isActiveTabCached = true;
          PageService.activeTab = 'agreement';

          PimsAppAgreementController con = new PimsAppAgreementController();

        
          con.isChanged=true;
       
         //boolean flag=con.isChanged;
          con.agmtCompletionStatus = 'Complete';
         //con.confirmChange();
          con.saveAgreement();
          Test.stopTest();
         }

	}
    @isTest static void test_method_three_fail() {//these 3 tests made for INC0183856
         
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
         User usres = new User(Alias = 'ibport', Email='ibportaluseres@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
                            LocaleSidKey='en_US', ProfileId = p.Id,IsActive=true,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuseres@testorg.com');
          insert usres;
          IB_Programme__c prog = [Select id from IB_Programme__c Limit 1][0];
          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.AFC_Assessment_Status__c = 'In Progress';
          app.AFC_Collaborative_Planning_Status__c = 'In Progress';
          app.AFC_Documents_Status__c = 'In Progress';
          app.AFC_Implementation_Budget_Status__c = 'In Progress';
          app.AFC_Leadership_Structure_Status__c = 'In Progress';
          app.AFC_Philosophy_Status__c = 'In Progress';
          app.AFC_Profile_Review_Status__c = 'In Progress';
          app.AFC_Programme_Information_Status__c = 'In Progress';
          app.AFC_Resources_Support_Status__c = 'In Progress';
          app.AFC_School_Description_Status__c = 'In Progress';
          app.AFC_Subject_Proposal_Status__c = 'In Progress';
          app.AFC_Written_Curriculum_Status__c = 'In Progress';
          app.Application_Lookup_to_Programme__c = prog.Id;
          app.Is_Agreement_Confirmed__c=false;
          insert app;

         app.AFC_Assessment_Status__c = 'Complete';
         
         Test.startTest();
         System.runAs(usrEs){
          Pagereference pgRef = Page.PimsApplicationForCandidacy;
          Test.setCurrentPage(pgRef);
          pgRef.getParameters().put('id',app.Id);
          pgRef.getParameters().put('tab','agreement');

          PageService.isActiveTabCached = true;
          PageService.activeTab = 'agreement';

          PimsAppAgreementController con = new PimsAppAgreementController();

        
          con.isChanged=true;
       
         //boolean flag=con.isChanged;
          con.agmtCompletionStatus = 'Complete';
         //con.confirmChange();
          con.saveAgreement();
          Test.stopTest();
         }

	}
}