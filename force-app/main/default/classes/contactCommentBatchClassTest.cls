@isTest
public class contactCommentBatchClassTest {

    public static List<IB_Role__c> role_list {get; set;}
     @TestSetup
    static void setupdata() { 
        role_list = new List<IB_Role__c>();
        Profile p1 = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        User u = new User(ProfileId=p1.id,alias = 'rrt', email='rejectroletest@example.com', 
                          emailencodingkey='UTF-8', lastname='rejectroletest', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          isActive=true,UserRoleId = userRole.Id,
                          timezonesidkey='America/Los_Angeles',username='rejectroletest@example.com'
                         );  
        insert u;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Online_Provider_Internal_User'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = u.id;
        psa1.PermissionSetId = ps1.Id;
        insert new List<PermissionSetAssignment>{psa1,psa};
        System.runAs(u)
        {
            
         Account TestAccount = AccountTestDataFactory.createAccount('School Account', null);
        Account TestAccount1 = AccountTestDataFactory.createAccount('Online Provider', null);
        Account TestAccount2 = AccountTestDataFactory.createAccount('IB Institute', null);
        Account TestAccount3 = AccountTestDataFactory.createAccount('IB Office Account', null);
        insert new List<Account>{TestAccount,TestAccount1,TestAccount2,TestAccount3};
            
            IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (TestAccount, 'Diploma Programme');
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c = date.today()+5;
        prog.Account__c = TestAccount.id;
        prog.Date_Decision_on_Candidacy__c = date.today()+2;
        prog.Owner__c = UserInfo.getUserId();
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (TestAccount1, 'Diploma Programme');
        prog2.Status__c = 'Authorized';
        prog2.Date_Decision_on_Authorization__c = date.today()+5;
        prog2.Account__c = TestAccount1.id;
        prog2.Date_Decision_on_Candidacy__c = date.today()+2;
        prog2.Owner__c = UserInfo.getUserId();
        insert new List<IB_Programme__c>{prog,prog2};
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Basic'];
        
        List<IB_Role_Repository__c> role_repo_list = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c role =  TestsUtil.createRoleRepoWithParams('Institute Administrator', 'Fully Qualified', 'Learning Centre', 'Administration');
        role.Permission_Set_Name__c = 'Institute_Administrator';
        role_repo_list.add(role);
        
        IB_Role_Repository__c role1 =  TestsUtil.createRoleRepoWithParams('Institute Transcript User', 'Fully Qualified', 'Learning Centre', 'Administration');
        role1.Permission_Set_Name__c = 'Institute_Transcript_User';
        role_repo_list.add(role1);
        
        IB_Role_Repository__c role2 =  TestsUtil.createRoleRepoWithParams('Communication User', 'Fully Qualified', 'Learning Centre', 'Administration');
        role2.Permission_Set_Name__c = 'Communication_User';
        role_repo_list.add(role2);
        
        IB_Role_Repository__c role3 =  TestsUtil.createRoleRepoWithParams('Teacher', 'Fully Qualified', 'Learning Centre', 'Administration');
        role3.Permission_Set_Name__c = 'Teacher';
        role3.MyIB_Require_My_School_Approval__c = true;
        role_repo_list.add(role3);
        
        IB_Role_Repository__c role4 =  TestsUtil.createRoleRepoWithParams('Librarian', 'Fully Qualified', 'Learning Centre', 'Administration');
        role4.Permission_Set_Name__c = 'Librarian';
        role4.MyIB_Require_My_School_Approval__c = true;
        role_repo_list.add(role4);
        
        IB_Role_Repository__c PC_role =  TestsUtil.createRoleRepoWithParams('Programme  Coordinator', 'Fully Qualified', 'Learning Centre', 'Administration');
        PC_role.Permission_Set_Name__c = 'Programme_Coordinator';
        role_repo_list.add(PC_role);
        
        IB_Role_Repository__c OC_role =  TestsUtil.createRoleRepoWithParams('Online Coordinator', 'Fully Qualified', 'Learning Centre', 'Administration');
        OC_role.Permission_Set_Name__c = 'Online_Coordinator_Role';
        role_repo_list.add(OC_role);
        
        insert role_repo_list;
        LIst<Contact> contact_list = new List<Contact>();
        LIst<User> user_list = new List<User>();
        
        Contact TestContact = PimsTestUtil.createContact('Thomas Shelby '+1,'TS'+1+'@ts.com','ts'+1+'@profEmail.com', Date.newInstance(1984, 09, 14), TestAccount3);
        contact_list.add(TestContact);
        Contact TestContact1 = PimsTestUtil.createContact('Thomas Shelby '+2,'TS'+2+'@ts.com','ts'+2+'@profEmail.com', Date.newInstance(1984, 09, 14), TestAccount3);
        contact_list.add(TestContact1);
        Contact TestContact2 = PimsTestUtil.createContact('Thomas Shelby '+3,'TS'+3+'@ts.com','ts'+3+'@profEmail.com', Date.newInstance(1984, 09, 14), TestAccount3);
        contact_list.add(TestContact2);
        Contact TestContact3 = PimsTestUtil.createContact('Thomas Shelby '+3,'TS'+3+'@ts.com','ts'+3+'@profEmail.com', Date.newInstance(1984, 09, 14), TestAccount3);
        contact_list.add(TestContact3);
        
        insert contact_list;
        
        User user = new User(Alias = 'standt', Email='standarduser'+1+'@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id,ContactId = contact_list[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+1+'@testorg.com');
        user_list.add(user);
        User user1 = new User(Alias = 'standt', Email='standarduser'+2+'@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',LocaleSidKey='es', ProfileId = p.Id,ContactId = contact_list[1].id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+2+'@testorg.com');
        user_list.add(user1);
        User user2 = new User(Alias = 'standt', Email='standarduser'+3+'@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr',LocaleSidKey='fr', ProfileId = p.Id,ContactId = contact_list[2].id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser'+3+'@testorg.com');
        user_list.add(user2);
        
        insert user_list;
        
        
        Contact_information__c ci=new Contact_information__c(name='Ck',email__c='test111@abc.com',IB_Contact__c=contact_list[3].id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
        insert ci;
        Contact_information__c cip=new Contact_information__c(name='Ck12',Country_Code__c = 'Israel (+972)',Phone_Number__c = '12345',IB_Contact__c=contact_list[3].id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
        insert cip;
        
        IB_Role__c ibrole3 = TestsUtil.createIbRole(OC_role.id,contact_list[3].id);
        ibrole3.Start_Date__c = Date.today();
        ibrole3.Status__c = 'Confirmed';
        ibrole3.Email_Confirmed__c = true;
        ibrole3.IB_Programme_New__c = prog2.id;
        ibrole3.IB_Account__c = TestAccount1.id;
        
        ibrole3.Contact_Information_Email__c = ci.id;
        ibrole3.Contact_Information_Phone__c = cip.id;
        ibrole3.Job_Title__c = 'Developer';
        TriggerContextUtility.FirstRun = true;
        
        IB_Role__c ibrole4 = TestsUtil.createIbRole(PC_role.id,contact_list[3].id);
        ibrole4.Start_Date__c = Date.today();
        ibrole4.Status__c = 'Confirmed';
        ibrole4.IB_Account__c = TestAccount.id;
        ibrole4.IB_Programme_New__c = prog.id;
        TriggerContextUtility.FirstRun = true;
        
        IB_Role__c ibrole5 = TestsUtil.createIbRole(role.id,contact_list[3].id);
        ibrole5.Start_Date__c = Date.today();
        ibrole5.Status__c = 'Confirmed';
        ibrole5.Email_Confirmed__c = true;
        ibrole5.IB_Account__c = TestAccount2.id;        
        ibrole5.Job_Title__c = 'Developer';
        ibrole5.Contact_Information_Email__c = ci.id;
        ibrole5.Contact_Information_Phone__c = cip.id;
        ibrole5.Active__c = true;
        TriggerContextUtility.FirstRun = true;
        insert new List<IB_Role__c> {ibrole3,ibrole4,ibrole5};
         contactCommentBatchClassTest.insertRoles(contact_list[0].id,TestAccount.id,TestAccount1.id,TestAccount2.id,prog.id,prog2.id);
 
                
    }
    }
    @future
    public static void insertRoles(ID ContactId, ID SchoolAccount, ID OPAccount, ID INSTAccount,ID SchoolProg, ID OPprog){
        List<IB_Role_Repository__c> role_repo_list = [Select Role_Name__c from IB_Role_Repository__c];
        Contact_information__c ci2=new Contact_information__c(name='Ck',email__c='test111@abc.com',IB_Contact__c=ContactId,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
                insert ci2;
                Contact_information__c cip2=new Contact_information__c(name='Ck12',Country_Code__c = 'Israel (+972)',Phone_Number__c = '12345',IB_Contact__c=ContactId,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
                insert cip2;
                for(integer j=1;j<role_repo_list.size();j++){
                    IB_Role__c ibrole2 = TestsUtil.createIbRole(role_repo_list[j].id,ContactId);
                    ibrole2.Start_Date__c = Date.today();
                    ibrole2.Status__c = 'Applicant';
                    if(role_repo_list[j].Role_Name__c == 'Teacher'){
                        ibrole2.Type__c = 'Online Provider';
                        ibrole2.IB_Account__c = OPAccount;     
                        ibrole2.Job_Title__c = 'Developer';
                        ibrole2.Contact_Information_Email__c = ci2.id;
                        ibrole2.Contact_Information_Phone__c = cip2.id;
                        ibrole2.IB_Programme_New__c = OPprog;
                    }
                    else if(role_repo_list[j].Role_Name__c == 'Institute Transcript User' || role_repo_list[j].Role_Name__c == 'Communication User'){
                        ibrole2.IB_Account__c = INSTAccount;
                        ibrole2.Job_Title__c = 'Developer';
                        ibrole2.Contact_Information_Email__c = ci2.id;
                        ibrole2.Contact_Information_Phone__c = cip2.id;
                    }
                    else{
                        ibrole2.IB_Account__c = SchoolAccount;
                        ibrole2.IB_Programme_New__c = SchoolProg;
                    }
                    role_list.add(ibrole2);
            }
        
        
        TriggerContextUtility.FirstRun = true;
        insert role_list;
    }
    public static testMethod void TestClass()
    {
        Test.startTest();
        contactCommentBatchClass RR = new contactCommentBatchClass();
        DataBase.executeBatch(RR);
        Test.stopTest();
        
    }
}