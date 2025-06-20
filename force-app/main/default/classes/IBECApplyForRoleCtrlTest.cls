@isTest public class IBECApplyForRoleCtrlTest {
    public static  Contact_information__c ci {get; set;}
    public static  Contact_information__c ci2 {get; set;}
    public static IB_Role_Repository__c repo1 {get; set;}
    private static testMethod void testOne() {
        Account acc1 ;
        Contact con;
        Profile p;
        user u;
        Test.startTest();

            
        acc1 = PimsTestUtil.createAccount('test', 'School Account' );
        acc1.ibis_id__c='012111';
        
        insert acc1;
            
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
            //insert cont;
        
            repo1 = TestsUtil.createRoleRepo();
            repo1.Category__c = 'School Services';
            repo1.Role_Name__c = 'IBEC University Administrator';
            insert repo1;
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc1, 'PYP');
            insert ibprog;
            
            con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc1);
            con.AccountId=acc1.id;
            insert con;
            
            con=[select id from contact limit 1][0];
            p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
            
            u= new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                        emailencodingkey='UTF-8', lastname='smith', 
                        languagelocalekey='en_US', 
                        localesidkey='en_US',
                        timezonesidkey='America/Los_Angeles',username='testObama@example.com',ContactId=con.id
                       );  
            insert u;
        
            ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c= con.id);
            insert ci;
            ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo1.id),IB_Contact__c=con.id);
            insert ci2;
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, con.Id);
            ibRole1.IB_Account__c = acc1.id;
            ibRole1.IB_Programme_New__c = ibprog.id;
            ibRole1.Email_Confirmed__c=true;
            ibRole1.Status__c = 'Confirmed';
            ibRole1.End_Date__c = Date.today();
            insert ibRole1;
        
            PageReference myVfPage = Page.IBECApplyForRole;
            Test.setCurrentPage(myVfPage);
            ContactDetailsWrapper.SetFirstLoadComplete();

            // Put Id into the current page Parameters
            ApexPages.currentPage().getParameters().put('AccountId',acc1.Id);
           ApexPages.currentPage().getParameters().put('roleId',repo1.id);
            IBECApplyForRoleCtrl ip= new IBECApplyForRoleCtrl();
            //ip.CurrentContact=con;
            ip.JobTitle='Software Engineer';
            ip.Email='test@abc.com';
            ip.Phone='+981212';
            ip.phonenumber = '1231231230';
            ip.Country_Code = 'Israel (+972)';
            ip.ibecadminName = '';
            ip.Phonenumber = '';
            ip.SaveJobTitle();
            system.runAs(u)
            {
                ip.CurrentContact=ip.getCurrentUsersContact();
            }
            ip.getcitynames();
            ip.submitRole();
            system.assertEquals('/ibportal/InstituteRoleApplicationSubmitted?EmailMatch=false&RoleName=IBEC+University+Administrator',ip.submitRole().getUrl());
            system.assertEquals('/apex/InstituteSearch?roleId='+repo1.id,ip.changeInstitute().getUrl());
            system.assertEquals('/ibportal/MyIBRoles',ip.cancelRole().getUrl());
            system.assertEquals(UserInfo.getLanguage(),ip.getLocale());
            ip.getLocale();
            ip.changeInstitute();
            ip.cancelRole();
            
        Test.stopTest();
        
    }
    //below method created by Prerna on 08-11-2023 for ECM00566
    private static testMethod void ibecCertificateHolderRoleTest() {
        Account acc ;
        Contact con;
        Profile p;
        user u;
        Test.startTest();

            
        acc = PimsTestUtil.createAccount('test', 'School Account' );
        acc.ibis_id__c='012111';
        
        insert acc;
            
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
            //insert cont;
        
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
            IB_Programme__c ibprog = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
            insert ibprog;
            
            con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
            con.AccountId=acc.id;
            insert con;
            
            con=[select id from contact limit 1][0];
            p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
            
            u= new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                        emailencodingkey='UTF-8', lastname='smith', 
                        languagelocalekey='en_US', 
                        localesidkey='en_US',
                        timezonesidkey='America/Los_Angeles',username='testObama@example.com',ContactId=con.id
                       );  
            insert u;
        
            IB_Role_Repository__c certificateHolderRepo = TestsUtil.createRoleRepo();
            certificateHolderRepo.Role_Name__c = 'IBEC Certificate Holder';
            certificateHolderRepo.Display_in_MyIB__c=true;
            certificateHolderRepo.Available_From__c=Null;
            insert certificateHolderRepo;
            
            ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(certificateHolderRepo.id),IB_Contact__c= con.id);
            insert ci;
            ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(certificateHolderRepo.id),IB_Contact__c=con.id);
            insert ci2;
            
            IB_Role__c certificateHolderRole = TestsUtil.createIbRole(certificateHolderRepo.Id, con.id);
            certificateHolderRole.Email_Confirmed__c = true;
            insert certificateHolderRole;
        
            PageReference myVfPage = Page.IBECApplyForRole;
            Test.setCurrentPage(myVfPage);
            ContactDetailsWrapper.SetFirstLoadComplete();

            // Put Id into the current page Parameters
            ApexPages.currentPage().getParameters().put('AccountId',acc.Id);
            ApexPages.currentPage().getParameters().put('roleId',certificateHolderRepo.id);
            IBECApplyForRoleCtrl ip= new IBECApplyForRoleCtrl();
            //ip.CurrentContact=con;
            ip.JobTitle='Software Engineer';
            ip.Email='test@abc.com';
            ip.Phone='+981212';
            ip.phonenumber = '1231231230';
            ip.Country_Code = 'Israel (+972)';
            system.runAs(u)
            {
                ip.CurrentContact=ip.getCurrentUsersContact();
            }
            ip.getcitynames();
            ip.submitRole();
            system.assertEquals('/ibportal/InstituteRoleApplicationSubmitted?EmailMatch=false&RoleName=IBEC+Certificate+Holder',ip.submitRole().getUrl());
            system.assertEquals('/apex/InstituteSearch?roleId='+certificateHolderRepo.id,ip.changeInstitute().getUrl());
            system.assertEquals('/ibportal/MyIBRoles',ip.cancelRole().getUrl());
            system.assertEquals(UserInfo.getLanguage(),ip.getLocale());
            ip.getLocale();
            ip.changeInstitute();
            ip.cancelRole();
        
            Case cs = new Case();
            cs.Subject = 'IBEC Certificate Holder';
            cs.Status = 'Open';
            cs.ContactId = con.id;
            insert cs;
            System.assertEquals('IBEC Certificate Holder',cs.subject);
            Test.stopTest();
        
    }

}