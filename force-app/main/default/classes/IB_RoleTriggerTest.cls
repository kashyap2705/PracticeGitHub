/*******************************************************************************************
* @Name     IB_RoleTriggerTest 
* @Description  This is test class for IB_Role__c object
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/30/2023         Modified logic to cover code for IB_RoleTriggerHelper
*  2.0              Tarun Sharma              07/24/2024         US:222422 [Salesforce Technical Analysis and Design]Capture and Categorize Professional Learning Customers Unaffiliated with IB for Reporting and Business Development
*******************************************************************************************/

@isTest
private class IB_RoleTriggerTest {
    
    @future
    private static void addPermSet() {
        List<User> users = [SELECT Id FROM User WHERE Alias = 'st@e.com'];
        List<PermissionSet> ps = [SELECT Id, Name FROM PermissionSet WHERE Name = 'Teacher'];
        insert new PermissionSetAssignment(AssigneeId = users[0].id, PermissionSetId = ps[0].Id);
    }
    
    @isTest 
    static void permissionSetTestMethod() {
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        //Insert account
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        Insert new List<Account>{acc,acc2};
            
            //Insert contacts
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.IBEN_Active__c=true;
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        insert new List<contact>{con1,con2};
            
            //Insert Role Repository
            IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Teacher');
        theRoleRepo1.Role_Type__c = 'School Role';
        theRoleRepo1.Permission_Set_Name__c = 'Teacher';
        insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
            Profile p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          contactid=con1.id,
                          isActive=true,
                          timezonesidkey='America/Los_Angeles',username='testObama1@example.com'
                         );  
        insert u;
        IB_RoleTriggerTest.addPermSet();
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc2, 'MYP');
        prog2.Status__c = 'Interested';
        insert new List<IB_Programme__c>{prog,prog2};
            
            System.runAs(new User(Id = UserInfo.getUserId()))
        {
            Test.startTest();
            
            IB_Role__c TeacherRole = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);
            TeacherRole.Start_Date__c = Date.today();
            TeacherRole.IB_Programme_New__c=prog.Id;
            TeacherRole.End_Date__c = Date.today();
            TeacherRole.Status__c='Confirmed'; 
            TeacherRole.Active__c = false;
            insert new List<IB_Role__c>{TeacherRole};
                
                List<IB_Role__c> rollll= [SELECT id,Second_Referee_Professional_Relationship__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c FROM IB_Role__c WHERE id=:TeacherRole.id];
            List<IB_Role__c> listRoll=new List<IB_Role__c>();
            ListRoll.add(TeacherRole);
            
            Set<ID> contactIds = new Set<ID>();
            contactIds.add(con1.Id);
            
            PermissionSetMaintenance.permissionMaintenance(contactIds);
            
            Test.stopTest();
        }
    }
    
    @isTest 
    static void applicantPermissionSetTestMethod() {
        //Insert account
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        Insert new List<Account>{acc,acc2};
            
            //Insert contacts
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.IBEN_Active__c=true;
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        insert new List<contact>{con1,con2};
            
            Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con1.id, Email__c = 'test@test.com');
        insert ci;
            
            //Insert Role Repository
            IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
            System.runAs(new User(Id = UserInfo.getUserId()))
        {
            Test.startTest();
            
            IB_Role__c role7 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);
            role7.Start_Date__c = Date.today(); 
            role7.Status__c='Applicant'; 
            role7.Reason_For_Status__c = 'Applicant';
            role7.Contact_Information_Email__c = ci.id;
            role7.Programme_Selection__c = 'DP';
            insert new List<IB_Role__c>{role7};
                
                List<IB_Role__c> rollll= [SELECT id,Second_Referee_Professional_Relationship__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c FROM IB_Role__c WHERE id=:role7.id];
            List<IB_Role__c> listRoll=new List<IB_Role__c>();
            ListRoll.add(role7);
            
            Set<ID> contactIds = new Set<ID>();
            contactIds.add(con1.Id);
            
            PermissionSetMaintenance.permissionMaintenance(contactIds);
            
            Test.stopTest();
        }
    }
    
    @isTest
    static void testTriggerHandler(){
        TriggerHandlerBase trigMtd = new  CaseBeforeInsertTriggerHandler();
        List<Case> cases = TestDataFactory.createCase(1,IboUtil.SUPPORT_CASE_RT_ID, false);
        
        trigMtd.updateObjects();
       trigMtd.insertObjects();
    }

    @isTest 
    static void testIBRoleTrigger() {
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 300000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        IB_Role_Repository__c reppo=new IB_Role_Repository__c(
            Available__c=true,
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Professional Services Contractor|Session Observer',
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );
        insert reppo;
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        
        Insert new List<Account>{acc,acc2};
            
        RecordType rt = [select Id from RecordType where Name = 'Standard Contact' and SobjectType = 'Contact' limit 1];
        
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);      
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        
        con1.IBIS_contact_ID__c=null;
        con1.Global_IBEN_Number__c=null;
        con1.Contact_Type__c='IBEN';
        con1.RecordTypeId=rt.id;
        
        insert new List<contact>{con1,con2};
            
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc2, 'MYP');
        prog2.Status__c = 'Interested';
        IB_Programme__c prog3 = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
        prog3.Status__c = 'Interested';
        
        insert new List<IB_Programme__c>{prog,prog2,prog3};
            
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('School Visit Team Member');
        theRoleRepo2.Permission_Set_Name__c = 'School_Visit_Team_Member';
        IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Billing Contact');
        theRoleRepo3.Permission_Set_Name__c = 'Billing_Contact';
        insert new List<IB_Role_Repository__c> {theRoleRepo1,theRoleRepo2,theRoleRepo3};
            
        user u=new User(Id = UserInfo.getUserId());
        
        System.runAs(u)
        {
            Test.startTest();
            
            System.debug('Test  role: ');
            IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con1.Id, acc.Id);
            role1.Programme_Selection__c = 'PYP';
            role1.Start_Date__c = Date.today();
            role1.IB_Role__c=theRoleRepo2.id;
            role1.End_Date__c=Null;
            role1.IB_Account__c=null;
            role1.Status__c='Applicant';
            role1.IB_Contact__c=con1.id;
            insert role1;
            
            IB_Programme__c prog5 = PimsTestUtil.createProgrammeForAccount (acc, 'PYP');
            prog5.Status__c = 'Authorized';
            prog5.Date_Decision_on_Authorization__c = date.today();
            prog5.Owner__c = UserInfo.getUserId();
            insert new List<IB_Programme__c>{prog5};
                
            List<IB_Role__c> rollllps= [SELECT id,Email__c,UserID__c,IB_Role__r.Role_Name__c,Email_Confirmed__c,IB_Contact__c,Status__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c,Programme_Status__c FROM IB_Role__c WHERE id=:role1.id /*or id =:role2.id*/];
            List<IB_Role__c> listRollps=new List<IB_Role__c>();
            listRollps.add(role1);      
            
            Map<Id,IB_Role__c> rolMapps=new Map<Id,IB_Role__c>(listRollps);  
            List<IB_Role__c> listRollOldps=new List<IB_Role__c>();
            rollllps[0].Status__c = 'Confirmed';
            rollllps[0].Upskilled_in_PSP__c = '2014';
            listRollOldps.add(rollllps[0]);
            
            Map<Id,IB_Role__c> OldrolMapps= new Map<Id,IB_Role__c>(listRollOldps);
            
            IB_RoleAfterUpdateTriggerHandler.process(rolMapps, OldrolMapps);
            TriggerContextUtility.Firstrun = true;
            update rollllps;
            Test.stopTest();
            
        }
    }
    
    @isTest 
    static void testIBRoleTrigger2() {
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        insert new List<Account>{acc,acc2};      
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        
        insert new List<contact>{con1,con2};
            User u = PimsTestUtil.createPortalUserPYP('test4645@xyz.org.test', false);
        
        Contact con3 = [SELECT ID From Contact WHERE Email = 'test4645@xyz.org.test' LIMIT 1];
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        insert prog;
        
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc2, 'MYP');
        prog2.Status__c = 'Interested';
        insert prog2;
        
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert theRoleRepo1;
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Head of School');
        theRoleRepo2.Permission_Set_Name__c = 'Head_of_School';
        insert theRoleRepo2;
        IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Billing Contact');
        theRoleRepo3.Permission_Set_Name__c = 'Billing_Contact';
        insert theRoleRepo3;
        
       
        
        IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);
        role1.IB_Programme_New__c = prog.Id;
        role1.Start_Date__c = Date.today();
        
        IB_Role__c role2 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con2.Id, acc.Id);
        role2.IB_Programme_New__c = prog.Id;
        role2.Start_Date__c = Date.today();
        
        IB_Role__c role3 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con1.Id, acc.Id);
        role3.IB_Programme_New__c = prog.Id;
        role3.Start_Date__c = Date.today();
        
        IB_Role__c role4 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc.Id);
        role4.IB_Programme_New__c = prog.Id;
        role4.Start_Date__c = Date.today();
        
        IB_Role__c role5 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con1.Id, acc.Id);
        role5.IB_Programme_New__c = prog.Id;
        role5.Start_Date__c = Date.today();
        
        IB_Role__c role6 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con2.Id, acc.Id);
        role6.IB_Programme_New__c = prog.Id;
        role6.Start_Date__c = Date.today();
        
        Test.startTest();
        IB_Role__c role7 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con3.Id, acc.Id);
        role7.IB_Programme_New__c = prog.Id;
        role7.Start_Date__c = Date.today();
        
        IB_Role__c role8 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con3.Id, acc2.Id);
        role8.IB_Programme_New__c = prog2.Id;
        role8.Start_Date__c = Date.today();
        role8.Status__c = 'Confirmed';
        Test.stopTest();
        
    }    
    
    @isTest
    static void permissionSetMaintenanceTestMethod() {
        //Insert account
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        Insert new List<Account>{acc,acc2};
            
        //Insert contacts
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.IBEN_Active__c = true;        
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);        
        insert new List<contact>{con1,con2};
            
        Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con1.id, Email__c = 'test@test.com');
        insert ci;
            
        //Insert Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('School Visit Team Member');
        theRoleRepo2.Permission_Set_Name__c = 'School_Visit_Team_Member';
        IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Chief Examiner');
        theRoleRepo3.Permission_Set_Name__c = 'Chief_Examiner';
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2,theRoleRepo3};
            
            System.runAs(new User(Id = UserInfo.getUserId())) {
                
                Test.startTest();
                
                IB_Role__c role7 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);
                role7.Start_Date__c = Date.today();
                role7.IB_Role__c = theRoleRepo1.id;
                role7.Status__c = 'Confirmed';
                role7.IB_Contact__c = con1.id;
                role7.Reason_For_Status__c = 'Confirmed';
                role7.Contact_Information_Email__c = ci.id;
                role7.Programme_Selection__c = 'DP';
                insert role7;
                
                List<IB_Role__c> rollll = [SELECT id,Second_Referee_Professional_Relationship__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c FROM IB_Role__c WHERE id=:role7.id];
                List<IB_Role__c> listRoll = new List<IB_Role__c>();
                ListRoll.add(role7);
                
                Set<ID> contactIds = new Set<ID>();
                contactIds.add(con1.Id);
                
                PermissionSetMaintenance.updateIBENActiveStatus(contactIds);
                PermissionSetMaintenance.profileMaintenance(contactIds);
                PermissionSetMaintenance.contactTypeMaintenance(contactIds);
                
                Test.stopTest();
            }
    }    
    
    @isTest
    static void ib_RoleBeforeUpdateTriggerHandlerTestMethod() {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Profile p1 = [select Id,name from Profile where name='SCU + Advanced' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          
                          
                          timezonesidkey='america/los_angeles',username='testobama@example.com'
                         );  
        
        Map<Id,IB_Role__c> OldrolMap1;
        Map<Id,IB_Role__c> rolMap1;
        Contact con;
        Account acc = PimsTestUtil.createAccount('Test Account', 'School Account');
        Account acc1 = PimsTestUtil.createAccount('Test Account 1', 'School Account');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', 'School Account');
        Insert new List<Account>{acc, acc1,acc2};
            
            List<Account> Acc1_list= new List<Account>();
        Acc1_list = [select id,RecordType.Name from Account where ID =:acc.id];
        System.debug(' Record Type: '+Acc1_list[0].RecordType.Name);
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        insert new List<contact>{con1};
            
            User pu2 = new User(profileId = p1.id, username = 'rs2@email.com', email = 'rs2@email.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                alias='cspu', lastname='lastname', contactId = con1.id);
        
        insert pu2;                                                                           
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc, 'PYP');
        prog2.Status__c = 'Interested';
        
        IB_Programme__c prog3 = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
        prog3.Date_Decision_on_Authorization__c = date.today();
        prog3.Owner__c = UserInfo.getUserId();
        prog3.Status__c = 'Authorized';        
        insert new List<IB_Programme__c>{prog,prog2,prog3};
            
            IB_Role_Repository__c reppo=new IB_Role_Repository__c(
                Available__c=true,
                SF_Role_Application__c=true,
                Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                CurrencyIsoCode='USD',
                Role_Name__c='Head of School',
                Category__c='Learning Centre',
                Role_Level__c='Fully Qualified',
                Sub_Category__c='Administration',
                Related_Programmes__c='PYP;MYP;DP;IBCC',
                Available_in_Region__c='Global',
                Training_Model__c = 'Advanced Training',
                IB_Staff_Role__c=true  
            );    
        insert reppo;
        IB_Role_Repository__c reppo2=new IB_Role_Repository__c(
            Available__c=true,
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c='CAS Coordinator',
            Category__c='School Services',
            Role_Level__c='Fully Qualified;Shadow;',
            Sub_Category__c='Evaluation & Authorization',
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );    
        insert reppo2;
        
        IB_Role_Repository__c reppo3=new IB_Role_Repository__c(
            Available__c=true,
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c='Consultant',
            Category__c='School Services',
            Role_Level__c='Fully Qualified;Shadow;',
            Sub_Category__c='Evaluation & Authorization',
            Related_Programmes__c='DP',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true,
            Role_Type__c='IBEN Role'
            
        );    
        insert reppo3;
        
        Test.startTest();
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            IB_Role__c role7 = PimsTestUtil.createIbRole(reppo.Id, con1.Id, acc.Id);
            role7.IB_Account__c = acc.Id;
            role7.Account_ID__c = acc.id;
            role7.IB_Programme_New__c = prog2.Id;
            role7.Start_Date__c = Date.today();
            role7.Status__c='Applicant';
            
            IB_Role__c role8 = PimsTestUtil.createIbRole(reppo.Id, con1.Id, acc.Id);
            role8.IB_Account__c = acc.Id;
            role8.Account_ID__c = acc.id;
            
            role8.IB_Programme_New__c = prog.Id;
            role8.Start_Date__c = Date.today();
            role8.Status__c='Confirmed';
            
            IB_Role__c role9 = PimsTestUtil.createIbRole(reppo2.Id, con1.Id, acc.Id);
            role9.IB_Account__c = acc.Id;
            role9.Account_ID__c = acc.id;
            role9.IB_Role__c = reppo2.Id;
            role9.IB_Programme_New__c = prog3.Id;
            role9.Start_Date__c = Date.today();
            role9.Status__c='Applicant';
            
            IB_Role__c role10 = PimsTestUtil.createIbRole(reppo3.Id, con1.Id, acc.Id);
            role10.IB_Account__c = acc.Id;
            role10.Account_ID__c = acc.id;
            role10.IB_Role__c = reppo3.Id;
            role10.IB_Programme_New__c = prog3.Id;
            role10.Start_Date__c = Date.today();
            role10.Status__c='Applicant';
            role10.End_Date__c = Date.today()+1;
            role10.Active__c = false;
            role10.Reason_For_Status__c ='Inactive';
            
            insert new List<IB_Role__c>{role8,role9,role10};
                
                system.debug('role10**'+role10);
               
                List<IB_Role__c> role_list = new List<IB_Role__c>();
            rolMap1=new Map<Id,IB_Role__c>();
            rolMap1.put(role7.id,role7);
            role7.Status__c = 'Withdrawn';
            OldrolMap1 =new Map<Id,IB_Role__c>();
            OldrolMap1.put(role7.id,role7);
            IB_RoleBeforeUpdateTriggerHandler.process(rolMap1, OldrolMap1); 
            
            role10= [select id, IB_Role__c,Unregistered__c,Role_Type__c,IB_Contact__c,IB_Role_Name__c,Status__c,Start_Date__c,End_Date__c,Account_ID__c,Programme_Status__c,Programme_Type__c,IB_Account__c,IB_Programme_New__c from IB_Role__c where id=: role10.id];
            system.debug('role10 again**'+role10);
            
            rolMap1=new Map<Id,IB_Role__c>();
            rolMap1.put(role10.id,role10);
            role10.End_Date__c = Date.today();
            OldrolMap1 =new Map<Id,IB_Role__c>();
            OldrolMap1.put(role10.id,role10);
            IB_RoleBeforeUpdateTriggerHandler.process(rolMap1, OldrolMap1);
            
            rolMap1=new Map<Id,IB_Role__c>();
            rolMap1.put(role8.id,role8);
            role8.Role_Level__c = 'Withdrawn';
            OldrolMap1 =new Map<Id,IB_Role__c>();
            OldrolMap1.put(role8.id,role8);
            IB_RoleBeforeUpdateTriggerHandler.process(rolMap1, OldrolMap1);
            
            rolMap1=new Map<Id,IB_Role__c>();
            rolMap1.put(role9.id,role9);
            
            TriggerContextUtility.FirstRun = true;
            
            OldrolMap1 =new Map<Id,IB_Role__c>();
            IB_Role__c role = [Select id,IB_Role__c,IB_Contact__c,Unregistered__c,End_Date__c,Account_ID__c,Status__c,Programme_Status__c,IB_Role_Name__c,Programme_Type__c,IB_Account__c,IB_Programme_New__c from IB_Role__c where id = :role9.id Limit 1];
            role.Status__c='Confirmed';
            role.IB_Programme__c = null;
            OldrolMap1.put(role9.id,role);
            try{
                IB_RoleBeforeUpdateTriggerHandler.process(rolMap1, OldrolMap1);
            }catch(Exception ex){
                
            } 
            role.IB_Programme__c = prog2.id;
            role.IB_Account__c = null;
            OldrolMap1.put(role9.id,role);
            try{
                IB_RoleBeforeUpdateTriggerHandler.process(rolMap1, OldrolMap1);
            }catch(Exception ex){
                
            }
            Test.stopTest();
        }
        
    }
    
    @isTest
    static void ib_RoleBeforeUpdateTriggerHandlerTestMethod2() {
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        
        User u = new User(id = UserInfo.getUserId() );  
        Map<Id,IB_Role__c> OldrolMap1;
        Map<Id,IB_Role__c> rolMap1;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Online_Coordinator_Role'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            Contact con;
            Account acc = PimsTestUtil.createAccount('Test Account', 'Online Provider');
            acc.Country__c = 'Spain';
            Insert new List<Account>{acc};
                
                List<Account> Acc1_list= new List<Account>();
            Acc1_list = [select id,RecordType.Name from Account where ID =:acc.id];
            System.debug(' Record Type: '+Acc1_list[0].RecordType.Name);
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
            
            insert new List<contact>{con1};
                
                IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (Acc1_list[0], 'MYP');
            prog2.Status__c = 'Authorized';
            prog2.Date_Decision_on_Authorization__c = date.today();
            prog2.Owner__c = UserInfo.getUserId();
            insert new List<IB_Programme__c>{prog2};
                
                
                IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Online Coordinator');
            theRoleRepo1.Permission_Set_Name__c = 'Online_Coordinator';
            insert theRoleRepo1;
            IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Online Admin Assistant');
            
            theRoleRepo2.Permission_Set_Name__c = 'Online_Admin_Assistant';
            insert theRoleRepo2;
            IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Business Contact');
            theRoleRepo3.Permission_Set_Name__c = 'Business_Contact';
            
            insert theRoleRepo3;
            Test.startTest();
            Contact_information__c ci=new Contact_information__c(name='Ck',email__c='test111@abc.com',IB_Contact__c=con1.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
            insert ci;
            Contact_information__c cip=new Contact_information__c(name='Ck12',phone__c='+982232311212',IB_Contact__c=con1.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
            insert cip;
            IB_Role__c role7 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, Acc1_list[0].Id);
            role7.IB_Account__c = Acc1_list[0].Id;
            role7.Account_ID__c = Acc1_list[0].id;
            role7.IB_Programme_New__c = prog2.Id;
            role7.Start_Date__c = Date.today();
            role7.Status__c='Confirmed';
            role7.Job_Title__c = 'Test';
            role7.Email_Confirmed__c = true;
            role7.Contact_Information_Email__c = ci.id;
            role7.Contact_Information_Phone__c = cip.id;
            role7.Job_Title__c = 'BA';
            insert role7;
            
            IB_Role__c role8 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con1.Id, Acc1_list[0].Id);
            role8.IB_Account__c = Acc1_list[0].Id;
            role8.Account_ID__c = Acc1_list[0].id;
            role8.IB_Programme_New__c = prog2.Id;
            role8.Start_Date__c = Date.today();
            role8.Email_Confirmed__c = true;
            role8.Job_Title__c = 'Test';
            role8.Contact_Information_Email__c = ci.id;
            role8.Contact_Information_Phone__c = cip.id;
            role8.Job_Title__c = 'BA';
            role8.Status__c='Confirmed';
            
            IB_Role__c role9 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con1.Id, Acc1_list[0].Id);
            role9.Type__c = 'Online Provider';
            role9.IB_Account__c = Acc1_list[0].Id;
            role9.Account_ID__c = Acc1_list[0].id;
            role9.IB_Programme_New__c = prog2.Id;
            role9.Start_Date__c = Date.today();
            role9.Email_Confirmed__c = true;
            role9.Job_Title__c = 'Test';
            role9.Contact_Information_Email__c = ci.id;
            role9.Contact_Information_Phone__c = cip.id;
            role9.Job_Title__c = 'BA';
            role9.Status__c='Confirmed';
            
            insert new List<IB_Role__c>{role8,role9};
                
                role7.Status__c = 'Withdrawn';
            TriggerContextUtility.FirstRun = true;
            update role7;
            
            role8.Status__c = 'Withdrawn';
            TriggerContextUtility.FirstRun = true;
            update role8;
            
            role9.Status__c = 'Withdrawn';
            TriggerContextUtility.FirstRun = true;
            update role9;
        }
        Test.stopTest();
    }   
    
    @isTest 
    static void test_editRoleApplication() {
        
        Account acc = PimsTestUtil.createAccount('Test Account', 'School Account');
        acc.Region__c = 'IBAEM';
        Insert new List<Account>{acc};
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE',acc);
        insert country;
        
        Contact con = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con.Country__c = country.id;
        Insert new List<Contact>{con};
            
            IB_Role_Repository__c reppo4 =  TestsUtil.createRoleRepoWithParams('Programme Leader', 'Fully Qualified;', 'Learning Centre', 'Administration');
        insert reppo4;
        IB_Role__c role_old = PimsTestUtil.createIbRole(reppo4.Id, con.Id, null);
        role_old.Start_Date__c = Date.today();
        role_old.IB_Role__c = reppo4.id;
        role_old.Status__c = 'Applicant';
        role_old.IB_Contact__c = con.id;
        role_old.Unregistered__c = true;
        role_old.Programme_Selection__c = 'MYP';
        role_old.Referee_1_Last_Name__c = 'Test';
        role_old.Referee_1_First_Name__c = 'First';
        role_old.Referee_1_Email__c = 'firstTest@fjdklsjls.com';
        role_old.First_Referee_Professional_Relationship__c = 'fjdklsjls.com';
        role_old.Referee_2_Last_Name__c = 'Test';
        role_old.Referee_2_First_Name__c = 'Second';
        role_old.Referee_2_Email__c = 'secondTest@fjdklsjls.com';
        role_old.Second_Referee_Professional_Relationship__c = 'fjdklsjls.com';
        insert role_old;
        
        List<IB_Role__c> list_old_role = [SELECT id,Role_Type__c,UserID__c,IB_Role__r.Role_Name__c,Unregistered__c,Account_ID__c,IB_Role__c,Programme_Selection__c,Third_Referee_Title__c,Third_Referee_First_Name__c,Third_Referee_Last_Name__c,Third_Referee_Email__c,Third_Referee_Role__c,Second_Referee_Role__c,First_Referee_Role__c,Email_Confirmed__c,Second_Referee_Professional_Relationship__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c FROM IB_Role__c WHERE id=:role_old.id];
        Map<Id,IB_Role__c> Old_Role_Map = new Map<Id,IB_Role__c>(list_old_role);
        IB_Role__c PLRole = role_old;
        PLRole.Programme_Selection__c = 'PYP';
        PLRole.Unregistered__c = false;
        update PLRole;
        
        List<IB_Role__c> rolNew_PL = [SELECT id,Role_Type__c,UserID__c,IB_Role__r.Role_Name__c,Unregistered__c,Account_ID__c,IB_Role__c,Programme_Selection__c,Second_Referee_Role__c,Third_Referee_Title__c,Third_Referee_First_Name__c,Third_Referee_Last_Name__c,Third_Referee_Email__c,Third_Referee_Role__c,First_Referee_Role__c,Email_Confirmed__c,Second_Referee_Professional_Relationship__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c FROM IB_Role__c WHERE id=:PLRole.id];
        Map<Id,IB_Role__c> New_Role_Map = new Map<Id,IB_Role__c>(rolNew_PL);
        IB_RoleAfterInsertTriggerHandler.process(New_Role_Map, Old_Role_Map);
        
        initCampaigns_2();
        List<Campaign> camps = TestsUtil.getCampaigns();
        campaign camp1 = camps.get(0);
        camp1.Status = 'Staffed';//End
        camp1.Required_Number_of_Educators__c = 2;
        camp1.Training_Event_Type__c = 'Advance Training';
        camp1.Training_Language__c = 'English';
        camp1.Traing_Event_Published__c = true;  
        camp1.IB_Role__c = reppo4.id;
        camp1.IB_Programme__c = 'MYP';
        camp1.Venue_Account__c = acc.id;
        update camp1;
        
        Training_Event__c trainingEvent = TestsUtil.createTrainingEvent('test', reppo4.Id, camp1.id);
        trainingEvent.IB_Role__c = reppo4.id;
        insert trainingEvent;
        
        My_Training_Event__c myTrainEvent = TestsUtil.createMyTrainingEvent('Invited', con.id, trainingEvent.Id);
        myTrainEvent.IB_Role__c = reppo4.id;
        myTrainEvent.IB_Event__c = camp1.id;
        myTrainEvent.Invitation_Response__c = null;
        insert myTrainEvent;
        
        IBRoleTriggerHandler roletriggerhandler = new IBRoleTriggerHandler();
        roletriggerhandler.editRoleApplication(New_Role_Map , Old_Role_Map);
        System.debug('*****************************');
        IB_RoleBeforeUpdateTriggerHandler.process(New_Role_Map, Old_Role_Map);
    }     
    
    @isTest
    static void testUpdateSetTrainingResultToPassed() {
        init();
        
        initMoreRoleRepos();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        Contact cont = TestsUtil.getContacts().get(0);
        
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        
        myTrainingEvent.Application_Status__c = 'Confirmed';
        myTrainingEvent.Invitation_Response__c = 'Accept';
        myTrainingEvent.Level_of_Interest__c = 'Interested';
        myTrainingEvent.Release_Permission_Required__c = 'No'; 
        
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        myTrainingEvent.IB_Role__c = repos[0].id;
        myTrainingEvent.IB_Role_2__c = repos[1].id;
        myTrainingEvent.IB_Role_3__c = repos[2].id;                 
        myTrainingEvent.Training_Result__c = 'Passed';
        myTrainingEvent.Application_Status__c = 'Completed';
        myTrainingEvent.Role_Level__c = 'Fully Qualified';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
    }
    
   @isTest 
    static void testIBCIRoleTrigger() {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 300000;
        setting.Name = 'MaxContactIBCode';
        insert setting;

        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        
        Insert new List<Account>{acc,acc2};
            
        RecordType rt = [select Id from RecordType where Name = 'Standard Contact' and SobjectType = 'Contact' limit 1];
        
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        
        con1.IBIS_contact_ID__c=null;
        con1.Global_IBEN_Number__c=null;
        con1.Contact_Type__c='IBEN';
        con1.RecordTypeId=rt.id;
        
        insert new List<contact>{con1,con2};
            
            
        IB_Programme__c prog3 = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma_Programme');
        prog3.Status__c = 'Interested';
        
        insert new List<IB_Programme__c>{prog3};
            
            
            IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Chief Invigilator');
        theRoleRepo3.Permission_Set_Name__c = 'Chief_Invigilator';
        insert new List<IB_Role_Repository__c> {theRoleRepo3};
            
        user u=new User(Id = UserInfo.getUserId());
        
        System.runAs(u)
        {
            Test.startTest();
            
            System.debug('Test  role: ');
            IB_Role__c role1 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con1.Id, acc.Id);
            role1.IB_Programme_New__c = prog3.id;
            role1.Programme_Selection__c = 'DP';
            role1.Start_Date__c = Date.today();
            role1.IB_Role__c=theRoleRepo3.id;
            role1.End_Date__c=Null;
            role1.IB_Account__c=acc.id;
            role1.Status__c='Applicant';
            role1.IB_Contact__c=con1.id;
            insert role1;
            
            IB_Programme__c prog5 = PimsTestUtil.createProgrammeForAccount (acc, 'CP');
            prog5.Status__c = 'Authorized';
            prog5.Date_Decision_on_Authorization__c = date.today();
            prog5.Owner__c = UserInfo.getUserId();
            insert new List<IB_Programme__c>{prog5};
                
                
                List<IB_Role__c> rollllps= [SELECT id,Email__c,UserID__c,IB_Role__r.Role_Name__c,Email_Confirmed__c,IB_Contact__c,Status__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c,Programme_Status__c FROM IB_Role__c WHERE id=:role1.id ];
            List<IB_Role__c> listRollps=new List<IB_Role__c>();
            listRollps.add(role1);
            
            Map<Id,IB_Role__c> rolMapps=new Map<Id,IB_Role__c>(listRollps);  
            List<IB_Role__c> listRollOldps=new List<IB_Role__c>();
            rollllps[0].Status__c = 'Confirmed';
            rollllps[0].Upskilled_in_PSP__c = '2014';
            listRollOldps.add(rollllps[0]);
            
            
            Map<Id,IB_Role__c> OldrolMapps= new Map<Id,IB_Role__c>(listRollOldps);
            
            IB_RoleAfterUpdateTriggerHandler.process(rolMapps, OldrolMapps);
            TriggerContextUtility.Firstrun = true;
            update rollllps;
            Test.stopTest();
            
        }
    }
    
     @isTest 
    static void onlineProviderRolesTestConfirmed() {
        
        User u = new User(id = UserInfo.getUserId() );  
        Map<Id,IB_Role__c> OldrolMap1;
        Map<Id,IB_Role__c> rolMap1;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Online_Coordinator_Role'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        
        
        System.runAs(new User(Id = UserInfo.getUserId()))
        {
            Contact con;
            Account acc = PimsTestUtil.createAccount('Test Account', 'Online Provider');
            acc.Country__c = 'Spain';
            Insert new List<Account>{acc};
                
            List<Account> Acc1_list= new List<Account>();
            Acc1_list = [select id,RecordType.Name from Account where ID =:acc.id];
            System.debug(' Record Type: '+Acc1_list[0].RecordType.Name);
            
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
            Contact con2 = PimsTestUtil.createContact('Jones Test2', 'con2@home.com', 'con2@prof.com', Date.newInstance(1984, 09, 14), acc);
            insert new List<contact>{con1,con2};
                
            IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (Acc1_list[0], 'MYP');
            prog2.Status__c = 'Authorized';
            prog2.Date_Decision_on_Authorization__c = date.today();
            prog2.Owner__c = UserInfo.getUserId();
            insert new List<IB_Programme__c>{prog2};
                
                
            IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Online Coordinator');
            //theRoleRepo1.Name = 'Online Coordinator';
            theRoleRepo1.Permission_Set_Name__c = 'Online_Coordinator';
            insert theRoleRepo1;
            
            IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Online Admin Assistant');
            //theRoleRepo2.Name = 'Online Admin Assistantr';
            theRoleRepo2.Permission_Set_Name__c = 'Online_Admin_Assistant';
            insert theRoleRepo2;
            
            IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Teacher');
            //theRoleRepo3.Name = 'Teacher';
            insert theRoleRepo3;
            Contact_information__c ci2=new Contact_information__c(name='Ck2',email__c='test11122@abc.com',IB_Contact__c=con1.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
            insert ci2;
            Contact_information__c cip2=new Contact_information__c(name='Ck122',phone__c='+982222211212',IB_Contact__c=con1.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
            insert cip2;
            IB_Role__c role7 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, Acc1_list[0].Id);
            role7.IB_Account__c = Acc1_list[0].Id;
            role7.Account_ID__c = Acc1_list[0].id;
            role7.IB_Programme_New__c = prog2.Id;
            role7.Start_Date__c = Date.today();
            role7.Status__c='Confirmed';
            role7.Job_Title__c = 'Test';
            role7.Contact_Information_Email__c = ci2.id;
            role7.Contact_Information_Phone__c = cip2.id;
            role7.Email_Confirmed__c = true;
            TriggerContextUtility.FirstRun = true;
            insert role7;
            
            IB_Role__c role8 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con1.Id, Acc1_list[0].Id);
            role8.IB_Account__c = Acc1_list[0].Id;
            role8.Account_ID__c = Acc1_list[0].id;
            role8.IB_Programme_New__c = prog2.Id;
            role8.Start_Date__c = Date.today();
            role8.Email_Confirmed__c = true;
            role8.Job_Title__c = 'Test';
            role8.Contact_Information_Email__c = ci2.id;
            role8.Contact_Information_Phone__c = cip2.id;
            role8.Status__c='Confirmed';
            
            IB_Role__c role9 = PimsTestUtil.createIbRole(theRoleRepo3.Id, con1.Id, Acc1_list[0].Id);
            role9.Type__c = 'Online Provider';
            role9.IB_Account__c = Acc1_list[0].Id;
            role9.Account_ID__c = Acc1_list[0].id;
            role9.IB_Programme_New__c = prog2.Id;
            role9.Start_Date__c = Date.today();
            role9.Email_Confirmed__c = true;
            role9.Job_Title__c = 'Test';
            role9.Contact_Information_Email__c = ci2.id;
            role9.Contact_Information_Phone__c = cip2.id;
            role9.Status__c='Confirmed';
            
            Test.startTest();
            
            TriggerContextUtility.FirstRun = true;
            insert new List<IB_Role__c>{role8,role9};
                
            Contact_information__c ci3=new Contact_information__c(name='Ck1133',email__c='test151333@abc.com',IB_Contact__c=con2.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
            insert ci3;
            
            Contact_information__c cip3=new Contact_information__c(name='Ck12233',phone__c='+982233333212',IB_Contact__c=con2.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
            insert cip3;    
            IB_Role__c role10 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, Acc1_list[0].Id);
            role10.IB_Account__c = Acc1_list[0].Id;
            role10.Account_ID__c = Acc1_list[0].id;
            role10.IB_Programme_New__c = prog2.Id;
            role10.Start_Date__c = Date.today();
            role10.Email_Confirmed__c = true;
            role10.Job_Title__c = 'Test';
            role10.Contact_Information_Email__c = ci3.id;
            role10.Contact_Information_Phone__c = cip3.id;
            role10.Status__c='Confirmed';
            TriggerContextUtility.FirstRun = true;
            insert role10;
            
            Set<ID> acc_id = new Set<ID>(); 
            acc_id.add(acc.id);
            
            List<IB_Role__c> list_old_role = [SELECT id,Unregistered__c,Account_ID__c,IB_Role__c,Programme_Selection__c,Third_Referee_Title__c,Third_Referee_First_Name__c,Third_Referee_Last_Name__c,Third_Referee_Email__c,Third_Referee_Role__c,Second_Referee_Role__c,First_Referee_Role__c,Email_Confirmed__c,Second_Referee_Professional_Relationship__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c FROM IB_Role__c WHERE id=:role7.id];
            Map<Id,IB_Role__c> Old_Role_Map = new Map<Id,IB_Role__c>(list_old_role);
            
            IBRoleTriggerHandler roletriggerhandler = new IBRoleTriggerHandler();
            roletriggerhandler.countonlineProviderRole(list_old_role, acc_id, Old_Role_Map);
            
            List<IB_Role__c> list_old_role2 = [SELECT id,Unregistered__c,Account_ID__c,IB_Role__c,Programme_Selection__c,Third_Referee_Title__c,Third_Referee_First_Name__c,Third_Referee_Last_Name__c,Third_Referee_Email__c,Third_Referee_Role__c,Second_Referee_Role__c,First_Referee_Role__c,Email_Confirmed__c,Second_Referee_Professional_Relationship__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c FROM IB_Role__c WHERE id=:role8.id];
            Map<Id,IB_Role__c> Old_Role_Map2 = new Map<Id,IB_Role__c>(list_old_role2);
            
            IBRoleTriggerHandler roletriggerhandler2 = new IBRoleTriggerHandler();
            roletriggerhandler2.countonlineProviderRole(list_old_role2, acc_id, Old_Role_Map2);
            
            List<IB_Role__c> list_old_role3 = [SELECT id,Unregistered__c,Account_ID__c,IB_Role__c,Programme_Selection__c,Third_Referee_Title__c,Third_Referee_First_Name__c,Third_Referee_Last_Name__c,Third_Referee_Email__c,Third_Referee_Role__c,Second_Referee_Role__c,First_Referee_Role__c,Email_Confirmed__c,Second_Referee_Professional_Relationship__c,Contact_Information_Email_Text__c,Contact_Information_Email__c,Contact_Information_Phone__c,Referee_2_Title__c,Referee_2_First_Name__c,Referee_2_Email__c,Referee_2_Last_Name__c,Referee_1_Email__c,First_Referee_Professional_Relationship__c,IB_Programme_New__c,IB_Account__c,Email__c,RecordType.Name,Referee_1_First_Name__c,Referee_1_Last_Name__c,Title__c,IB_Contact__c,Status__c,IB_Role_Name__c ,ContactUserLanguage__c  ,Account_Name__c FROM IB_Role__c WHERE id=:role9.id];
            Map<Id,IB_Role__c> Old_Role_Map3 = new Map<Id,IB_Role__c>(list_old_role3);
            
            IBRoleTriggerHandler roletriggerhandler3 = new IBRoleTriggerHandler();
            roletriggerhandler3.countonlineProviderRole(list_old_role3, acc_id, Old_Role_Map3);
            new IBRoleTriggerHandler().handleMyProfileInfo(new List<IB_Role__c>{role10});
            Test.stopTest();
        }
        
    }     
    
    @isTest
    static void testIBProgrammeOnOnboardRoles() {
        Account acc = AccountFactoryTest.createAccountRecord(false);
        insert acc;
        List<Contact> conRecords = ContactFactoryTest.createContacts(3,false,acc);   
        if(!conRecords.isEmpty()){
            insert conRecords;
        }
        
        IB_Country_Segmentation__c country2= RoleRepoFactoryTest.createCountry(false, acc);
        insert country2;
        List<IB_Address__c> addresRec = RoleRepoFactoryTest.createAddress(3,country2.id,acc,false); 
        if(!addresRec.isEmpty()){
            insert addresRec;
        }
        
        
        List<IB_Role_Repository__c> repos = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c repoPC = PimsTestUtil.createRoleRepo('Programme Coordinator');
        repos.add(repoPC);
        IB_Role_Repository__c repoHOS = PimsTestUtil.createRoleRepo('Head of School');
        repoHOS.Permission_Set_Name__c = 'Head_of_School';
        repos.add(repoHOS);
        IB_Role_Repository__c repoBC = PimsTestUtil.createRoleRepo('Billing Contact');
        repoBC.Permission_Set_Name__c = 'Billing_Contact';
        repos.add(repoBC);
        
        insert repos;
        
        Test.startTest();
        
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'PYP');
        progRecList.add(progRec);
        insert progRecList;
        
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoHOS.Id, conRecords[0].id, conRecords[0].AccountId); 
        role.Programme_Selection__c = 'PYP';
        role.IB_Programme_New__c = progRec.Id;      // US-0001944 Change
        testRoles.add(role);
        
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repoPC.Id, conRecords[1].id, conRecords[0].AccountId); 
        role2.Programme_Selection__c = 'PYP';
        role2.IB_Programme_New__c = progRec.Id;     // US-0001944 Change
        testRoles.add(role2);
        
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repoBC.Id, conRecords[2].id, conRecords[0].AccountId); 
        role3.Programme_Selection__c = 'PYP';
        role3.IB_Programme_New__c = progRec.Id;     // US-0001944 Change
        testRoles.add(role3);
        
        insert testRoles;
        
        List<IB_Role__c> rolesWithProgramme = [select Id from IB_Role__c where IB_Programme_New__c = : progRec.Id];
        system.assertEquals(3, rolesWithProgramme.size());
        Test.stopTest();
    }
    
    // helper methods
    public static void initMoreRoleRepos()
    {
        Test.startTest();
        Contact cont1 = TestsUtil.getcontacts().get(0);
        Campaign camp = TestsUtil.getCampaigns().get(0);
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Programme Coordinator4','Fully Qualified','Assessment','Workshops');
        IB_Role_Repository__c repo3 = TestsUtil.createRoleRepoWithParams('Programme Coordinator5','Fully Qualified','Professional Development','Management');
        insert new List<IB_Role_Repository__c>{repo2,repo3};
            IB_Role__c ibRole2 = TestsUtil.createIbRole(repo2.Id, cont1.Id);
        ibRole2.Programme_Selection__c = camp.IB_Programme__c;
        ibRole2.Status__c = 'Applicant';
        ibRole2.Active__c = false;
        ibRole2.Role_Level__c = null;
        insert  ibRole2;
        
        IB_Role__c ibRole3 = TestsUtil.createIbRole(repo3.Id, cont1.Id);
        ibRole3.Programme_Selection__c = camp.IB_Programme__c;
        ibRole3.Status__c = 'Applicant';
        ibRole3.Active__c = false;
        ibRole3.Role_Level__c = null;
        insert  ibRole3;
        
        Training_Event__c trEvent1 = TestsUtil.getTrainingEvents().get(0);
        trEvent1.IB_Role_2__c = repo2.Id;
        trEvent1.IB_Role_3__c = repo3.Id;
        update trEvent1;
        Test.stopTest();
    }
    
    public static void init(){
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        initCampaigns();
        
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Programme Coordinator3','Fully Qualified','School Services','Evaluation & Authorization');
        insert repo1;
        
        Campaign camp = TestsUtil.getCampaigns().get(0);
        camp.IB_Role__c = repo1.Id;
        camp.IB_Programme__c = repo1.Related_Programmes__c;
        camp.Status = 'Staffed';
        update camp;
        
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        insert country;
        
        Contact cont1 = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.Id;
        insert cont1;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont1.Id);
        
        ibRole1.Programme_Selection__c = camp.IB_Programme__c;
        ibRole1.Status__c = 'Applicant';
        ibRole1.Active__c = false;
        ibRole1.Role_Level__c = null;
        insert ibRole1;
        
        
        Training_Event__c trEvent1 = TestsUtil.createTrainingEvent('test_name000', repo1.Id, camp.Id); 
        insert trEvent1;
        
    }
    
    private static void initCampaigns() 
    {
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '111111';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '222222';
        Account acc3 = TestsUtil.createAccount('test_acc_name_3');
        acc3.IBIS_ID__c = '333333';
        insert new List<Account> {acc1,acc2,acc3};
            
            Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        Opportunity opp3 = TestsUtil.createOpportunity('Test PYP 2', acc3.Id); 
        insert new List<Opportunity> {opp1,opp2,opp3};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        Campaign camp3 = TestsUtil.createCampaign('camp test name 2', acc3.Id, opp3.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2,camp3};
            }  
    
    public static void initCampaigns_2() 
    {
        
        List<Account> acc = TestsUtil.getAccounts();
        Account acc1 = acc.get(0);
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert new List<Opportunity> {opp1};
            
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test evaluation 1', acc1.Id, opp1.Id, recordTypeId);
        
        insert new List<Campaign>{camp1};
            
            }    
}