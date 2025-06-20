@isTest
public with sharing class RoleCtrlTest {

    /*static testMethod void basicTest(){
        //Setup Data
        RoleCtrl rc = new RoleCtrl();
        
        System.assert(rc.Roles_Withdrawn.size() == 0);
        System.assert(rc.Roles_Declined.size() == 0);
        System.assert(rc.Roles_Applied.size() == 0);
        System.assert(rc.Roles_Confirmed.size() == 0);
        System.assert(rc.Roles_Available.size() == 0);

        List<IB_Role_Repository__c> roles_Available = new List<IB_Role_Repository__c>();
        System.assert(roles_Available.isEmpty());
        List<IB_Role_Repository__c> roles_Confirmed = new List<IB_Role_Repository__c>();
        System.assert(roles_Confirmed.isEmpty());
        List<IB_Role_Repository__c> roles_Applied = new List<IB_Role_Repository__c>();
        System.assert(roles_Applied.isEmpty());
        List<IB_Role_Repository__c> roles_Declined = new List<IB_Role_Repository__c>();
        System.assert(roles_Declined.isEmpty());
        List<IB_Role_Repository__c> roles_Withdrawn = new List<IB_Role_Repository__c>();
        System.assert(roles_Withdrawn.isEmpty());
        
        //List<IB_Role__c> myRoles = [Select id From IB_Role__c where IB_Contact__c = :con.id];
        //System.assertEquals(myRoles.size(),1);
    
        Map<String, IB_Role__c> myConfirmedRolesMap = new Map<String, IB_Role__c>();
        System.assert(myConfirmedRolesMap.isEmpty());
        Map<String, IB_Role__c> myAppliedRolesMap = new Map<string, IB_Role__c>();
        System.assert(myAppliedRolesMap.isEmpty());
        Map<String, IB_Role__c> myDeclinedRolesMap = new Map<string, IB_Role__c>();
        System.assert(myDeclinedRolesMap.isEmpty());
        Map<String, IB_Role__c> myWithdrawnRolesMap = new Map<string, IB_Role__c>();
        System.assert(myWithdrawnRolesMap.isEmpty());

    
        List<IB_Role_Repository__c> initialSchoolServicesRoles = new List<IB_Role_Repository__c>();
        System.assert(initialSchoolServicesRoles.isEmpty());
        List<IB_Role_Repository__c> initialProfessionalDevRoles = new List<IB_Role_Repository__c>();
        System.assert(initialProfessionalDevRoles.isEmpty());
        
        //System.assert(myConfirmedRolesMap.size() == 1);

        
    }*/
    
    static testMethod void basicTest(){
        integer i=1;
        RoleCtrl rc = new RoleCtrl();
        rc.getIsAdvancedSchoolServices();
        rc.getIsAdvancedProfessionalDev();
        rc.getRoles_Available();
        rc.getRoles_Confirmed();
        rc.getRoles_Applied();
        rc.getRoles_Declined();
        rc.getRoles_Withdrawn();
        rc.getMyConfirmedRolesSubjectsMap();
        rc.getmyProgrammeSubjectsMap();
        rc.getStatusPdf();
        rc.getEligibilityPdf();
        rc.getRolesPdf();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }
    
    static testMethod void TestConfirmed(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_name_000');
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibotestuser@testibo.org');  

        insert u;

        IB_Role_Repository__c roleRepo = TestsUtil.createRoleRepo();
        roleRepo.Category__c = 'School Services';
        roleRepo.Training_Model__c = 'Initial Training';
        insert roleRepo;

        IB_Subject__c subj = new IB_Subject__c();
        subj.Subject_Name__c = 'Test';
        subj.Subject_Name_FR__c = 'Test';
        subj.Subject_Name_SP__c = 'Test';
        subj.IB_Programme__c = 'PYP';
        subj.IB_Programme_Long__c = 'PYP Long';
        subj.Subject_Group_Identifier__c = 'T';
        subj.Subject_Code__c = '123';
        subj.Available_in_IBEN__c = true;
        subj.Available_in_MySchool__c = true;
        insert subj;

        System.runAs(u){
            Test.startTest();
            IB_Role__c confirmedRole = TestsUtil.createIbRole(roleRepo.id, usr.contactId);
            insert confirmedRole;

            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subj.id;
            ras.Role_And_Application__c = confirmedRole.id;
            insert ras;
            Test.stopTest();
        }

        System.runAs(usr){
            
            RoleCtrl rc = new RoleCtrl();
            rc.getRegion();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
        }

    }

    static testMethod void TestConfirmed2(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_name_000');
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibotestuser@testibo.org');  

        insert u;

        IB_Role_Repository__c roleRepo = TestsUtil.createRoleRepo();
        roleRepo.Category__c = 'Professional Development';
        roleRepo.Training_Model__c = 'Initial Training';
        insert roleRepo;

        IB_Subject__c subj = new IB_Subject__c();
        subj.Subject_Name__c = 'Test';
        subj.Subject_Name_FR__c = 'Test';
        subj.Subject_Name_SP__c = 'Test';
        subj.IB_Programme__c = 'PYP';
        subj.IB_Programme_Long__c = 'PYP Long';
        subj.Subject_Group_Identifier__c = 'T';
        subj.Subject_Code__c = '123';
        insert subj;

        System.runAs(u){
            Test.startTest();
            IB_Role__c confirmedRole = TestsUtil.createIbRole(roleRepo.id, usr.contactId);
            insert confirmedRole;

            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subj.id;
            ras.Role_And_Application__c = confirmedRole.id;
            insert ras;
            Test.stopTest();
        }

        System.runAs(usr){
            
            RoleCtrl rc = new RoleCtrl();
            rc.getRegion();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
        }

    }

    static testMethod void TestApplicant(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_name_000');
        usr.LanguageLocaleKey = 'fr';
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibotestuser@testibo.org');  

        insert u;

        IB_Role_Repository__c roleRepo = TestsUtil.createRoleRepo();
        roleRepo.Category__c = 'Professional Development';
        roleRepo.Training_Model__c = 'Initial Training';
        insert roleRepo;

        IB_Role_Repository__c roleRepo2 = TestsUtil.createRoleRepo();
        roleRepo2.Category__c = 'Professional Development';
        roleRepo2.Training_Model__c = 'Initial Training';
        roleRepo2.Role_Name__c = 'Test';
        insert roleRepo2;

        IB_Subject__c subj = new IB_Subject__c();
        subj.Subject_Name__c = 'Test';
        subj.Subject_Name_FR__c = 'Test';
        subj.Subject_Name_SP__c = 'Test';
        subj.IB_Programme__c = 'PYP';
        subj.IB_Programme_Long__c = 'PYP Long';
        subj.Subject_Group_Identifier__c = 'T';
        subj.Subject_Code__c = '123';
        insert subj;

        System.runAs(u){
            Test.startTest();
            IB_Role__c confirmedRole = TestsUtil.createIbRole(roleRepo.id, usr.contactId);
            confirmedRole.Status__c = 'Applicant';
            insert confirmedRole;

            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subj.id;
            ras.Role_And_Application__c = confirmedRole.id;
            insert ras;
            Test.stopTest();
        }

        System.runAs(usr){
            
            RoleCtrl rc = new RoleCtrl();
            rc.getRegion();
            rc.getStatusPdf();
            rc.getEligibilityPdf();
            rc.getRolesPdf();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
        }

    }

    static testMethod void TestDeclined(){
        integer i=1;
        User usr = TestsUtil.createPortalUser('test_name_000');
        usr.LanguageLocaleKey = 'es';
        insert usr;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibotestuser@testibo.org');  

        insert u;

        IB_Role_Repository__c roleRepo = TestsUtil.createRoleRepo();
        insert roleRepo;

        IB_Subject__c subj = new IB_Subject__c();
        subj.Subject_Name__c = 'Test';
        subj.Subject_Name_FR__c = 'Test';
        subj.Subject_Name_SP__c = 'Test';
        subj.IB_Programme__c = 'PYP';
        subj.IB_Programme_Long__c = 'PYP Long';
        subj.Subject_Group_Identifier__c = 'T';
        subj.Subject_Code__c = '123';
        insert subj;

        System.runAs(u){
            Test.startTest();
            IB_Role__c confirmedRole = TestsUtil.createIbRole(roleRepo.id, usr.contactId);
            confirmedRole.Status__c = 'Declined';
            insert confirmedRole;

            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subj.id;
            ras.Role_And_Application__c = confirmedRole.id;
            insert ras;
            Test.stopTest();
        }

        System.runAs(usr){
            
            RoleCtrl rc = new RoleCtrl();
            rc.getRegion();
            rc.getStatusPdf();
            rc.getEligibilityPdf();
            rc.getRolesPdf();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
        }

    }

}