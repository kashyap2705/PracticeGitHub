@isTest
public class onlineProviderApplyForRoleCtrlTest {
    
    
    private static testMethod void testOne() {
		
        Account acc1 = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc1;
        
        Id schoolAccRecType = getRecordType('School_Account', 'Account');        
        Account schoolAcc = TestsUtil.createAccount('University Gardens');
        schoolAcc.recordTypeId = schoolAccRecType;
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
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc1.Id;
        cont.Contact_Type__c = 'IBEN';
        cont.HomePhone = '13861234567';
        cont.MobilePhone = '13861234567';
        cont.OtherPhone = '13861234567';
        cont.Phone = '13861234567';
        insert cont;
        
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepo();
        repo1.Role_Name__c = 'Teacher';        
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
                
        Profile p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
        
        User u= new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                    emailencodingkey='UTF-8', lastname='smith', 
                    languagelocalekey='en_US', 
                    localesidkey='en_US',
                    timezonesidkey='America/Los_Angeles',username='testObama@example.com',ContactId=con.id,Bypass_Validation_Rules__c = true
                   );  
        insert u;
        
        List <IB_Subject__c> subject_list = new List<IB_Subject__c>();
        
        IB_Subject__c ib_subject1= new IB_Subject__c();
        ib_subject1.Subject_Name__c= 'English';
        ib_subject1.Subject_Name_FR__c= 'English';
        ib_subject1.Subject_Name_SP__c='English';
        ib_subject1.IB_Programme__c='PYP';
        ib_subject1.IB_Programme_Long__c='Primary Years Programme';
        ib_subject1.Available_in_IBEN__c=true;
        ib_subject1.Subject_Group__c='Arts (PYP)';
        ib_subject1.Subject_Group_Identifier__c='artsx';
        
        IB_Subject__c ib_subject2= new IB_Subject__c();
        ib_subject2.Subject_Name__c= 'English';
        ib_subject2.Subject_Name_FR__c= 'English';
        ib_subject2.Subject_Name_SP__c='English';
        ib_subject2.IB_Programme__c='PYP';
        ib_subject2.IB_Programme_Long__c='Primary Years Programme';
        ib_subject2.Available_in_IBEN__c=true;
        ib_subject2.Subject_Group__c='Arts (PYP)';
        ib_subject2.Subject_Group_Identifier__c='artsx';
        
        subject_list.add(ib_subject1);
        subject_list.add(ib_subject2);
        
        
        insert subject_list;
        
        Test.startTest();
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, con.Id);
        ibRole1.IB_Account__c = acc1.id;
        ibRole1.IB_Programme_New__c = ibprog.id;
        ibRole1.Programme_Selection__c = camp1.IB_Programme__c;
        ibRole1.Email_Confirmed__c=true;
        ibRole1.Status__c = 'Confirmed';
        
        insert ibRole1;
        
        List<Contact_information__c> listCI = new List<Contact_information__c>();
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c= con.id);
        listCI.add(ci);
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c=con.id);
        listCI.add(ci2);
        
        insert listCI;
        
        
        
        PageReference myVfPage = Page.onlineProviderApplyForRole;
        Test.setCurrentPage(myVfPage);
        ContactDetailsWrapper.SetFirstLoadComplete();
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('roleId',repo1.Id);
        ApexPages.currentPage().getParameters().put('AccountId',acc1.Id);
        onlineProviderApplyForRoleCtrl  ip= new onlineProviderApplyForRoleCtrl();
        //ip.CurrentContact=con;
        ip.JobTitle='Software Engineer';
        ip.Email='test@abc.com';
        ip.Phone='+981212';
        ip.selectedProgramme='pyp';
        ip.phonenumber = '1231231230';
        ip.Country_Code = 'Israel (+972)';
        
        system.runAs(u)
        {
            ip.CurrentContact = ip.getCurrentUsersContact();
        }
        ip.getCurrentUsersContact();
        ip.initSubjects();
        ip.initSubjectGroups();
        ip.getSubjects();
        ip.getSubjectGroups();
        ip.selectProgramme();
        ip.getcitynames();
        ip.edit_phone();
        ip.SaveJobTitle();
        ip.submitRole();
        onlineProviderApplyForRoleCtrl.validateEmail('abc@gmail.com');
        onlineProviderApplyForRoleCtrl.emailE='abc@gmail.com';
        onlineProviderApplyForRoleCtrl.ConfirmEmail='abc@gmail.com';
        List<SelectOption> options = ip.getChooseProgramme();
        List<SelectOption> options1 = ip.getSubjectGroupOpts();
        List<SelectOption> options2 = ip.getSubjectOptsLeft();
        
        List<SelectOption> options3 = ip.programmesForSchool;
        ip.OnlineCoordinator='';
        //system.assertEquals('/ibportal/InstituteRoleApplicationSubmitted?EmailMatch=false&RoleName=Teacher',ip.submitRole().getUrl());
        system.assertEquals('/apex/onlineProviderSearch?roleId='+ repo1.Id ,ip.changeInstitute().getUrl());
        system.assertEquals('/ibportal/MyIBRoles',ip.cancelRole().getUrl());
        system.assertEquals(UserInfo.getLanguage(),ip.getLocale());
        
        
        Test.stopTest();
    }
    private static Id getRecordType(string devName, string sObjectType){
        
        try
        {
            RecordType result = [
                SELECT r.Id 
                FROM RecordType r 
                WHERE r.DeveloperName =: devName 
                AND SobjectType =: sObjectType 
                LIMIT 1
            ];
            return result.Id;
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
            return Null;
        }
    }
    
}