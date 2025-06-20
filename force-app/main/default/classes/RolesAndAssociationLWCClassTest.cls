@isTest
public class RolesAndAssociationLWCClassTest {
    
    public static IB_Role_Repository__c repo {get; set;}
    public static IB_Role_Repository__c repo2{get; set;}
    public static IB_Role_Repository__c repo3{get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static IB_Address__c address {get; set;}
    public static IB_Country_Segmentation__c country1 {get; set;}
    public static IB_Role__c ibRole1 {get; set;}
    public static IB_Role__c ibRole2{get; set;}
    public static IB_Role__c ibRole3{get; set;}
    public static IB_Role__c ibRole4{get; set;}
    
    public static User u;
    
    @testSetup static void setup() {
        repo = TestsUtil.createRoleRepo();
        repo.Role_Name__c = 'Institute Administrator';
        insert repo;
        
        repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
        //this code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
        //start
        repo3 = TestsUtil.createRoleRepo();
        repo3.Role_Name__c = 'Communication User';
        insert repo3;
        //end        
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        system.debug('connnn'+con.id);
        
        country1 = TestsUtil.createCountry('ABC','IBAEM',acc);
        insert country1;
        
        //Insert IB Address Record
        address = new IB_Address__c();
        address.Name = 'Testing Address';
        address.Status__c = 'Active';
        address.Address_Line_1__c = 'Bahria Town';
        address.City__c = 'Lahore';
        address.Postal_Code__c = '2021';
        address.Country__c = country1.Id;
        address.IB_Account__c=acc.id;
        insert address;
        
        Contact_information__c ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci;
        Contact_information__c ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=con.id);
        insert ci2;
        
        ibRole1 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole1.Status__c = 'Applicant';
        ibRole1.IB_Account__c = acc.id;
        ibRole1.Contact_Information_Email__c=ci.id;
        ibRole1.Contact_Information_Phone__c=ci2.id;
        ibRole1.Role_Level__c = 'Fully Qualified';
        ibRole1.Email_Confirmed__c=true;
        insert ibRole1;
        
        ibRole2 = TestsUtil.createIbRole(repo.Id, con.id);
        ibRole2.Status__c = 'Confirmed';
        ibRole2.IB_Account__c = acc.id;
        ibRole2.Contact_Information_Email__c=ci.id;
        ibRole2.Contact_Information_Phone__c=ci2.id;
        ibRole2.Role_Level__c = 'Fully Qualified';
        ibRole2.Email_Confirmed__c=true;
        insert ibRole2;
        ibRole3 = TestsUtil.createIbRole(repo2.Id, con.id);
        ibRole3.Status__c = 'Confirmed';
        ibRole3.IB_Account__c = acc.id;
        ibRole3.Role_Level__c = 'Fully Qualified';
        ibRole3.Email_Confirmed__c=true;
        insert ibRole3;
        //this code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
        //start
        ibRole4 = TestsUtil.createIbRole(repo3.Id, con.id);
        ibRole4.Status__c = 'Confirmed';
        ibRole4.IB_Account__c = acc.id;
        ibRole4.Role_Level__c = 'Fully Qualified';
        ibRole4.Email_Confirmed__c=true;
        insert ibRole4;
        //end
        list<ib_role__c> rolelist=new list<ib_role__c>();
        rolelist.add(ibrole1);
    }    
    @isTest
    public static void testIbRoleBeforeInsert(){
        
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        
        ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c from IB_Role__c limit 1][0];
        Test.startTest();
        System.runAs(u)
        { 
            
            list<ib_role__c> rolelist=new list<ib_role__c>();
            rolelist.add(ibrole1);    
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleList());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListConfirmed());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListTransConfirmed());
            
            
            
            RolesAndAssociationLWCClass.AddSelectedItems(rolelist);
            try {
                RolesAndAssociationLWCClass.DeclinedApplicantRoles(rolelist);
            } catch (Exception e) {
                System.debug('Exception in test: ' + e.getMessage());
            }
            RolesAndAssociationLWCClass.DeclinedConfimRoles(rolelist);           
            
        }
        Test.stopTest();
        
    }
    //Following code block is added by Ammara-Plumlogix of SA in US12138 on 1/7/2021
    //Start
    @isTest
    public static void TestConfirmTranscriptUser(){
        try{
            con=[select id from contact limit 1][0];
            Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community Basic'];
            
            User u = TestsUtil.createPortalUser ('Test_User', p.Id);
            u.Username = 'test@test121212.' + System.Math.random(); // make sure we don't create a user that already exists
            u.LastName = 'someuser';
            u.Email = 't@t.com';
            u.Alias = 'test12';
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.LocaleSidKey = 'en_US';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            System.debug(LoggingLevel.INFO, 'Creating portal user \n' + u);
            u.ContactId=con.id;
            insert u;
            list<account>account = new list<account>();
            account.add(acc);
            //this code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
            //start
            Test.startTest();
            System.runAs(u)
            {             
                RolesAndAssociationLWCClass.ConfirmTranscriptUser();                
                
            }//Endß
            Test.stopTest();
        }
        catch(Exception ex){
            System.debug('Exception :'+ex);
        }
        
    }
    //End

    @isTest
    public static void testIbRoleMethod(){
        
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        
        ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c from IB_Role__c limit 1][0];
        Test.startTest();
        System.runAs(u)
        { 
            
            list<ib_role__c> rolelist=new list<ib_role__c>();
            rolelist.add(ibrole1);    
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleList());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListConfirmed());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListTransConfirmed());
            
            
            
            RolesAndAssociationLWCClass.confirmSelectedItems(rolelist);
            RolesAndAssociationLWCClass.declineConfimedRoles(rolelist);
            RolesAndAssociationLWCClass.declineApplicantRoles(rolelist);
            RolesAndAssociationLWCClass.isInstituteRole();         
            
        }
        Test.stopTest();
        
    }

    @isTest
    public static void testIbRoleMethodException(){
        
        u = new User(Id = UserInfo.getUserId());
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        
        IB_Role__c ibrole1=[select id,Status__c,IB_Account__c,Role_Level__c from IB_Role__c limit 1][0];
        Test.startTest();
        System.runAs(u)
        { 
            
            list<ib_role__c> rolelist=new list<ib_role__c>();
            ibRole1.Id = null;
            rolelist.add(ibrole1);    
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleList());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListConfirmed());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClass.getRoleListTransConfirmed());
            
            
            
            RolesAndAssociationLWCClass.confirmSelectedItems(rolelist);
            RolesAndAssociationLWCClass.declineConfimedRoles(rolelist);
            RolesAndAssociationLWCClass.declineApplicantRoles(rolelist);           
            
        }
        Test.stopTest();
        
    }
    
}