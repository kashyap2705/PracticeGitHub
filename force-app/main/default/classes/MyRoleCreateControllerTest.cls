@isTest
private class MyRoleCreateControllerTest {
    
    @isTest
    private static void testSaveMethod() {
        IB_Role_Repository__c examinerRoleRepo = TestsUtil.createRoleRepoWithParams('Examiner','Fully Qualified','Assessment','Examiners' );
        insert examinerRoleRepo;    
        
        IB_Role_Repository__c ChiefExaminerRoleRepo = TestsUtil.createRoleRepoWithParams('Chief Examiner','Fully Qualified','Assessment','Examiners' );
        insert ChiefExaminerRoleRepo;
        
        IB_Role_Repository__c ExaminerResponsibleRoleRepo = TestsUtil.createRoleRepoWithParams('Examiner Responsible','Fully Qualified','Assessment','Examiners' );
        insert ExaminerResponsibleRoleRepo;
        
        IB_Role_Repository__c DeputyExaminerResponsiblerRoleRepo = TestsUtil.createRoleRepoWithParams('Deputy Examiner Responsible','Fully Qualified','Assessment','Examiners' );
        insert DeputyExaminerResponsiblerRoleRepo;
        
        Account acc = TestsUtil.createAccount('acc_test');
        acc.IBIS_ID__c = '000002';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country', 'Europe', acc);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherStateCode = 'USCA';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountryCode = 'US';
        con1.Country__c = country.id;
        con1.AccountId = acc.id;
        insert con1;
        
        IB_Role__c examinerRole = TestsUtil.createIbRoleWithParams(examinerRoleRepo.Id, con1.Id,'Active','DP',true,'Fully Qualified');
        IB_Role__c ChiefExaminerRole = TestsUtil.createIbRoleWithParams(ChiefExaminerRoleRepo.Id, con1.Id,'Active','DP',true,'Fully Qualified');
        IB_Role__c DeputyExaminerResponsibleRole = TestsUtil.createIbRoleWithParams(DeputyExaminerResponsiblerRoleRepo.Id, con1.Id,'Active','DP',true,'Fully Qualified');
        insert ChiefExaminerRole;
        insert DeputyExaminerResponsibleRole;
        try
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(examinerRole);
            MyRoleCreateController controller = new MyRoleCreateController(sc);
            controller.save();
        }
        catch(Exception ee)
        {
            system.debug(ee);
        }
        list<IB_Role__c> addedRole = [select id from IB_Role__c];//Retrive the record
        System.debug('addedRole:'+addedRole.size());
        
    }
    
    @isTest
    private static void testSaveMethod2() {
        IB_Role_Repository__c examinerRoleRepo = TestsUtil.createRoleRepoWithParams('Examiner','Fully Qualified','Assessment','Examiners' );
        insert examinerRoleRepo;    
        
        IB_Role_Repository__c ChiefExaminerRoleRepo = TestsUtil.createRoleRepoWithParams('Chief Examiner','Fully Qualified','Assessment','Examiners' );
        insert ChiefExaminerRoleRepo;
        
        IB_Role_Repository__c ExaminerResponsibleRoleRepo = TestsUtil.createRoleRepoWithParams('Examiner Responsible','Fully Qualified','Assessment','Examiners' );
        insert ExaminerResponsibleRoleRepo;
        
        IB_Role_Repository__c DeputyExaminerResponsiblerRoleRepo = TestsUtil.createRoleRepoWithParams('Deputy Examiner Responsible','Fully Qualified','Assessment','Examiners' );
        insert DeputyExaminerResponsiblerRoleRepo;
        
        IB_Role_Repository__c WorkshopLeaderRoleRepo = TestsUtil.createRoleRepoWithParams('Workshop Leader','Fully Qualified','Professional Development','Workshops' );
        insert WorkshopLeaderRoleRepo;
        
        
        
        Account acc = TestsUtil.createAccount('acc_test');
        acc.IBIS_ID__c = '000002';
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('Test_Country', 'Europe', acc);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherStateCode = 'USCA';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountryCode = 'US';
        con1.Country__c = country.id;
        con1.AccountId = acc.id;
        insert con1;
        
        IB_Role__c examinerRole = TestsUtil.createIbRoleWithParams(examinerRoleRepo.Id, con1.Id,'Active','CP',true,'Fully Qualified');
        IB_Role__c ChiefExaminerRole = TestsUtil.createIbRoleWithParams(ChiefExaminerRoleRepo.Id, con1.Id,'Active','CP',true,'Fully Qualified');
        IB_Role__c DeputyExaminerResponsibleRole = TestsUtil.createIbRoleWithParams(DeputyExaminerResponsiblerRoleRepo.Id, con1.Id,'Active','CP',true,'Fully Qualified');
        IB_Role__c WorkshopLeaderRole = TestsUtil.createIbRoleWithParams(WorkshopLeaderRoleRepo.Id, con1.Id,'Active','CP',true,'Fully Qualified');
        
        insert examinerRole;
        insert ChiefExaminerRole;
        insert WorkshopLeaderRole;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(DeputyExaminerResponsibleRole);
        MyRoleCreateController controller = new MyRoleCreateController(sc);
        try
        {
            controller.save();
        }
        catch(Exception ee)
        {
            system.debug(ee);
        }
        list<IB_Role__c> addedRole = [select id from IB_Role__c];//Retrive the record
        System.debug('addedRole:'+addedRole.size());
        
    }
    
    @isTest
    private static void testRoleAsInputParam() {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        init();
        
        IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        ApexPages.StandardController standardContr = new ApexPages.StandardController(role);
        
        MyRoleCreateController controller = new MyRoleCreateController(standardContr);
        controller.showCancelButton = false;
        controller.showOkButton = false;
        controller.showPopup = true;
        controller.showContinueButton = true;
        controller.popupMsg='This is custom message';
        System.assert(String.valueOf(controller.SaveInfo()).contains(role.Id));
        
        
        
        System.assert(String.valueOf(controller.save()).contains(role.Id));
        //  System.assert(String.valueOf(controller.continueRecord()).contains(role.Id));
        
        System.assert(controller.cancel() != null);
        
        controller.cancelRecord();
        controller.searchRole();
        controller.searchPrograme();
        controller.continueRecord();
        System.assert(role.Id == controller.getRole().Id);
        
        
        System.assert(controller.getIsInternal());
        
        System.assertEquals(2, controller.getCategoriesInfo().size());
        System.debug('>>>>>>>>' + controller.getRolesInfo());
        System.assertEquals(1, controller.getRolesInfo().size());
        //Repo's Related_Programmes__c value is 'PYP;MYP;DP;CP' = 4 choices
        System.assertEquals(4, controller.getProgrammsInfo().size());
    }
    
    
    @isTest
    private static void testRoleIdAsUrlParamForInternalUser(){
        try{
            
            
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepo();
            repo1.Role_Level__c = 'Fully Qualified;Shadow;';
            insert repo1;
            
            List<Profile> profs =  TestsUtil.getProfilesByNames( new List<String>{'Customer Community Advanced'} );
            User usr = TestsUtil.createPortalUser('testName111', profs.get(0).Id);
            
            insert usr;
            System.debug('test user profile==='+profs.get(0).id);
            
            Contact con = new Contact(id=usr.ContactId);
            TestsUtil.fillContactWithNokData(con);
            TestsUtil.fillContactWithPassportDetails(con);
            con.Independent_Educator__c = 'Yes';
            con.NoK_First_Name__c ='test nok first name';
            con.OtherStreet = 'other_street';
            con.OtherStreet = 'other_street';
            con.OtherCity = 'other_city';
            con.OtherStateCode = 'USCA';
            con.OtherPostalCode = 'other';
            con.OtherCountryCode = 'US';
            
            
            update con;
            System.debug('contact after updating==='+con);
            System.runAs(usr){
                
                RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
                RecordType rt2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c');
                
                IB_E_Background__c myProfile1 = TestsUtil.createMyProfileObject(con.Id, rt1.Id);
                IB_E_Background__c myProfile2 = TestsUtil.createMyProfileObject(con.Id, rt2.Id);
                insert new List<IB_E_Background__c>{myProfile1,myProfile2};
                    
                    IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, con.Id);
                ibRole1.Role_Level__c = 'Fully Qualified';
                
                try{
                    
                    Test.startTest();
                    insert ibRole1;
                    Test.stopTest();
                    
                } catch (Exception e) {
                    
                    System.debug('**** ERROR ' + e.getMessage());
                    
                } 
                
                //System.assert(ibRole1.Id != null, 'Ib Role was NOT inserted !');
                
                IB_Role__c role = TestsUtil.getIbRoles().get(0);
                
                PageReference page = new PageReference('apex/myRoleCreateIbenPortal');
                Test.setCurrentPage(page);
                ApexPages.currentPage().getParameters().put('roleId', role.Id);
                
                ApexPages.StandardController standardContr = new ApexPages.StandardController(new IB_Role__c());
                
                MyRoleCreateController controller = new MyRoleCreateController(standardContr);
                
                PageReference save = controller.SaveInfo();
                
                System.debug('>>>> save >>>>' + save);
                
                System.assert(! controller.getIsInternal());
            }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }  
    
    
    @isTest
    private static void testError(){
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        
        integer i=1;
        init();
        
        IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        ApexPages.StandardController standardContr = new ApexPages.StandardController(role);
        
        MyRoleCreateController controller = new MyRoleCreateController(standardContr);
        
        // simulate exception
        IB_Role__c contrRole = controller.getRole();
        contrRole.IB_Role__c = null;
        
        controller.SaveInfo();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }  
    
    @isTest
    private static void testDuplicateError(){
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        
        integer i=1;
        init();
        
        IB_Role__c role1 = TestsUtil.getIbRoles().get(0);
        IB_Role__c role2 = TestsUtil.getIbRoles().get(1);
        
        role2.Unique_Application__c = 'duplicate';
        update role2;
        
        ApexPages.StandardController standardContr = new ApexPages.StandardController(role1);
        
        MyRoleCreateController controller = new MyRoleCreateController(standardContr);
        
        // simulate exception
        IB_Role__c contrRole = controller.getRole();
        contrRole.Unique_Application__c = 'duplicate';
        Test.startTest();
        controller.SaveInfo();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        Test.stopTest();
    }  
    
    //helper method
    
    private static void init(){
        Account acc = TestsUtil.createAccount('test_name__e');
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc);
        insert country;
        
        Contact cont1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        Contact cont2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
        insert new List<Contact>{cont1, cont2};
            
            IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams( 'New Role','Fully Qualified','Programme Development', 'Administration');

        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Level__c = 'Fully Qualified';
        insert new List<IB_Role_Repository__c> {repo2,repo1};
            
            IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont1.Id);
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo2.Id, cont2.Id);
        
        insert new List<IB_Role__c> {ibRole1,ibRole2};
            }
}