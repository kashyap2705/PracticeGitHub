/**
* ECM-00336.
* @author  Plumlogix.
* @version 1.0
* @since   06-29-2022.
*/
@isTest
public class AssociatedSchoolClassTest { 
    public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static Account acc{get; set;}
    public static Account schoolacc{get; set;}
    public static Contact con{get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3{get; set;}
    public static IB_Role__c ibRole4{get; set;}
    public static SchoolAssociation__c schoolAssocition {get; set;}
    public static User u;
    public static List<Account> accList {get;set;}
    @testsetup
    public static void testdata(){
        // Added code by Atticus for IBEN Project as provided by Kevin
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;

        repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Association Admin';
        insert repo;
        
        repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Association User';
        insert repo2;
        
        acc = PimsTestUtil.createAccount('Test Association', 'IB World Schools Association Account' );
        //acc.ibis_id__c='N050234';
        acc.country__c='UNITED STATES';
        acc.State_Abbr__c ='AK';
        acc.Active__c='Active';
        acc.IBEC_University_Flag__c = true;
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB World Schools Association Account').getRecordTypeId();
       // insert acc;
       // acc.IsPartner=true;
       // update acc;
        
        schoolacc = PimsTestUtil.createAccount('Test Account', 'School Account' );
        //acc.ibis_id__c='N050234';
        schoolacc.country__c='UNITED STATES';
        schoolacc.State_Abbr__c ='AK';
        schoolacc.Active__c='Active';
        schoolacc.IBEC_University_Flag__c = true;
        schoolacc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId();
        schoolacc.IBIS_ID__c = '654312';
        schoolacc.IB_Transcript_Method__c = 'paper';
        insert schoolacc;
        schoolacc.IsPartner=true;
        update schoolacc;
        
        accList = new List<Account>();
        accList.add(schoolacc);
        
        schoolAssocition= new SchoolAssociation__c();
        schoolAssocition.Name='school Asscoiation';
        system.debug('association account : '+ acc.Name + ' school account: '+ schoolacc.name + 'acc.Id : ' + acc.Id);
        schoolAssocition.Association_id__c=acc.Id;
        schoolAssocition.school_id__c=schoolacc.Id;
        insert schoolAssocition;
        
        system.debug('schoolAssocition.size() : ' +  schoolAssocition);
        system.debug('schoolAssocition.Association : ' +  schoolAssocition.Association_id__c);
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        system.debug('Con.Id ealirest : ' +  con.Id);
        
        ibRole1 = TestsUtil.createIbRole(repo2.Id, con.id);
        ibRole1.Status__c = 'Applicant';
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Role_Level__c = 'Fully Qualified';        
        insert ibRole1;
        
        ibRole2 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole2.Status__c = 'Confirmed';
        ibRole2.IB_Account__c = acc.id;
        ibRole2.Role_Level__c = 'Fully Qualified';
        ibRole2.Email_Confirmed__c =true;
        insert ibRole2;
        
        ibRole3 = TestsUtil.createIbRole(repo2.Id,con.id);
        ibRole3.Status__c = 'Confirmed';
        ibRole3.IB_Account__c = acc.id;
        ibRole3.Role_Level__c = 'Fully Qualified';
        ibRole3.Email_Confirmed__c =true;
        insert ibRole3;
        
        ibRole4 = TestsUtil.createIbRole(repo.Id,con.id);
        ibRole4.Status__c = 'Applicant';
        ibRole4.IB_Account__c = acc.id;
        ibRole4.Role_Level__c = 'Fully Qualified';
        
        ibRole4.Email_Confirmed__c =true;
        insert ibRole4;   
        
    }
    @isTest static void testMethod1() {
        List<Account> accList = new List<Account>();      
        Account acct = [SELECT Id,Name FROM Account WHERE Name='Test Account' LIMIT 1];
          Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
        
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        u = new User(profileId = p.id, username = 'rs+s.a@em558861ail.com', email = 'rs+s.a@email.com',
                     emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',UserRoleId = userRole.Id,
                     alias='cspu', lastname='lastname');
        
        
        insert u;
        u.Bypass_Validation_Rules__c = false;
        update u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Association_Management_User'];
        
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        repo2 = [Select id,Role_Name__c from IB_Role_Repository__c where Role_Name__c = 'Association User'Limit 1];
        ibRole1 = [select id ,IB_Role__c from IB_Role__c where IB_Role_Name__c = 'Association User'Limit 1];
        
        Test.startTest();
        System.runAs(u)
        {
        
                      Account acc = new Account();
        acc = PimsTestUtil.createAccount('Test Association', 'IB World Schools Association Account' );
        //acc.ibis_id__c='N050234';
        acc.country__c='UNITED STATES';
        acc.State_Abbr__c ='AK';
        acc.Active__c='Active';
        acc.IBEC_University_Flag__c = true;
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB World Schools Association Account').getRecordTypeId();
        insert acc;
        acc.IsPartner=true;
        update acc;
        system.assertNotEquals(null, acct);
        
        acct.Phone = '555-1212';
        update acct;
        accList.add(acct);
        try{
            AssociatedSchoolClass.AddAssociationSchool(accList,acct.id);  
        }
        catch(Exception e){}
        }
    }
    @isTest
    public static void TestOne()
    {     
       
        contact con = [Select id from Contact limit 1];
        Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
        
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        u = new User(profileId = p.id, username = 'rs+s.a@em558861ail.com', email = 'rs+s.a@email.com',
                     emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',UserRoleId = userRole.Id,
                     alias='cspu', lastname='lastname');
        
        
        insert u;
        u.Bypass_Validation_Rules__c = false;
        update u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Association_Management_User'];
        
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        repo2 = [Select id,Role_Name__c from IB_Role_Repository__c where Role_Name__c = 'Association User'Limit 1];
        ibRole1 = [select id ,IB_Role__c from IB_Role__c where IB_Role_Name__c = 'Association User'Limit 1];
        
        Test.startTest();
        System.runAs(u)
        {
            
            try
            {
                 Account acc = new Account();
        acc = PimsTestUtil.createAccount('Test Association', 'IB World Schools Association Account' );
        //acc.ibis_id__c='N050234';
        acc.country__c='UNITED STATES';
        acc.State_Abbr__c ='AK';
        acc.Active__c='Active';
        acc.IBEC_University_Flag__c = true;
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB World Schools Association Account').getRecordTypeId();
        insert acc;
        acc.IsPartner=true;
        update acc;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.RemoveAssociationSchool(AssociatedSchoolClass.getAssociatedSchools(acc.id));
                AssociatedSchoolClass.wrapAssAccount  wrapAcc = new AssociatedSchoolClass.wrapAssAccount ();  
                wrapAcc.Country = '--None--';
                wrapAcc.Ibis = 'N050234';
                wrapAcc.Name = 'Test Account';
                wrapAcc.Authentic= true;
                AssociatedSchoolClass.searchInfoAssociation(wrapAcc.Name,wrapAcc.Ibis,wrapAcc.Country,'AK',acc.id);
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.renderTrue = true;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('Test One','098123','India','IN',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('Test','012348','--None--','',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('','012348','--None--','',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('','','NAMIBIA','AK',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('','','--None--','--None--',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('','032312','PAKISTAN',NULL,acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('Test One','','Iran','--None--',acc.id); 
                AssociatedSchoolClass.wrapAccountList = null;
                AssociatedSchoolClass.getAssociatedSchools(acc.id);
                AssociatedSchoolClass.searchInfoAssociation('','','','',acc.id);
                
                System.assert(AssociatedSchoolClass.wrapAccountList.size()==0);
            }
            catch(AuraHandledException e)
            {
                e.getMessage();
            }
        }
        
        Test.stopTest();
    }
    // Test method added by Atticus F for Bug 185244: on 8-12-2022 to increase the code coverage from 76% to 90%
    @isTest static void testMethodIncreaseCoverage() {
        List<Account> accList = [SELECT Id,IBIS_ID__c FROM Account WHERE RecordType.Name ='School Account'];      
        Account acct = [SELECT Id,Name FROM Account WHERE Name='Test Account' LIMIT 1];
        Profile p =  [SELECT Id FROM profile where Name = 'System Administrator' limit 1];
        
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        u = new User(profileId = p.id, username = 'rs+s.a@em558861ail.com', email = 'rs+s.a@email.com',
                     emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                     languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',UserRoleId = userRole.Id,
                     alias='cspu', lastname='lastname');
        insert u;
        
        u.Bypass_Validation_Rules__c = false;
        update u;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Association_Management_User'];
        
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        repo2 = [SELECT id,Role_Name__c FROM IB_Role_Repository__c where Role_Name__c = 'Association User'Limit 1];
        ibRole1 = [SELECT id ,IB_Role__c FROM IB_Role__c where IB_Role_Name__c = 'Association User'Limit 1];
        
        Test.startTest();
        
        System.runAs(u){
        
        Account acc = new Account();
        acc = PimsTestUtil.createAccount('Test Association', 'IB World Schools Association Account' );
        acc.country__c='UNITED STATES';
        acc.State_Abbr__c ='AK';
        acc.Active__c='Active';
        acc.IBEC_University_Flag__c = true;
        acc.IBEC_University_Flag__c = true;
        acc.RecordTypeId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('IB World Schools Association Account').getRecordTypeId();
        insert acc;
        acc.IsPartner=true;
        update acc;
        
        System.assertNotEquals(null, acct);
        
        acct.Phone = '555-1212';
        update acct;
        //accList.add(acct);
        
        SchoolAssociation__c testSchAssoc = new SchoolAssociation__c(Association_id__c = acc.Id);
        insert testSchAssoc;
        
        AssociatedSchoolClass testClass = new AssociatedSchoolClass();
        AssociatedSchoolClass.WrapAssAccount testWrapAcc = new AssociatedSchoolClass.WrapAssAccount();
        AssociatedSchoolClass.WrapAccount testWrapAcc1 = new AssociatedSchoolClass.WrapAccount();
        
        testWrapAcc.id =acct.Id;
        testWrapAcc.SchoolId =acct.Id;
        testWrapAcc.AssociationId =acct.Id;
        AssociatedSchoolClass.AddAssociationSchool(accList,acct.id);
        AssociatedSchoolClass.getAssociatedSchools(acc.Id);
        
        }
    }
}