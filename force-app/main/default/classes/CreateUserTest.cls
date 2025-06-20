@isTest
private class CreateUserTest {
    @testsetup 
    static void testData(){
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Account acc = PimsTestUtil.createAccount('Test Account 1', '');
        insert acc; 
        
        //Insert contacts
        Contact con1 = PimsTestUtil.createContact('Jones', 'testemail121@yopmail.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.Legal_first_name__c ='Jones';
        con1.Legal_Last_name__c = 'Doe';
        con1.User_Language__c = 'en_US';
        con1.IBEN_Active__c=true;
        
        Contact con2 = PimsTestUtil.createContact('BrownTEST', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        con2.Legal_first_name__c ='Jones';
        con2.Legal_Last_name__c = 'Down';
        con2.User_Language__c = 'es';
        con2.IBEN_Active__c=true;
        
        Contact con3 = PimsTestUtil.createContact('khdsTEST', 'con4@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        con3.Legal_first_name__c ='Jones';
        con3.Legal_Last_name__c = 'Down';
        con3.User_Language__c = 'ko';
        con3.IBEN_Active__c=true;
        
        Contact con4 = PimsTestUtil.createContact('nbhTEST', 'con5@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        con4.Legal_first_name__c ='Jones';
        con4.Legal_Last_name__c = 'Down';
        con4.User_Language__c = 'ja';
        con4.IBEN_Active__c=true;
        
        Contact con5 = PimsTestUtil.createContact('letTEST', 'con6@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        con5.Legal_first_name__c ='Jones';
        con5.Legal_Last_name__c = 'Down';
        con5.User_Language__c = 'fr';
        con5.IBEN_Active__c=true;
        insert new List<contact>{con1,con2,con3,con4,con5};
            
        //Insert Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        theRoleRepo2.Role_Type__c = 'IBEN Role';
        theRoleRepo2.Permission_Set_Name__c = 'Programme Coordinator';
        
        IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Head of School');
        theRoleRepo3.Role_Type__c = 'IBEN Role';
        theRoleRepo3.Permission_Set_Name__c = 'Head of School';
        
        IB_Role_Repository__c theRoleRepo4 = PimsTestUtil.createRoleRepo('Billing Contact');
        theRoleRepo4.Role_Type__c = 'IBEN Role';
        theRoleRepo4.Permission_Set_Name__c = 'Billing Contact';
        
        IB_Role_Repository__c theRoleRepo5 = PimsTestUtil.createRoleRepo('Exam Contact');
        theRoleRepo5.Role_Type__c = 'IBEN Role';
        theRoleRepo5.Permission_Set_Name__c = 'Exam Contact';
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2,theRoleRepo3,theRoleRepo4,theRoleRepo5};
        
        
            
        //insert programme
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        insert prog;
    }
    
    @isTest 
    static void createUserTest(){
        //UserRole r = new UserRole(DeveloperName = 'ACSEghamInternationalSchoolPartnerUser1', Name = 'ACSEghamInternationalSchoolPartnerUser1');
		//insert r;
        //Insert account
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        Contact con1 = [select Id,IBIS_contact_ID__c  from Contact where email='testemail121@yopmail.com' limit 1];
        Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con1.id, Email__c = 'test@test.com');
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Type__c = 'IBEN Role' and Role_Name__c='Examiner' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            insert ci;
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            examiner1.Contact_Information_Email__c = ci.id;
            examiner1.Programme_Selection__c = 'DP';
            insert examiner1;
            
            IB_Role__c examiner2 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);  
            examiner2.IB_Programme_New__c = prog.Id;
            examiner2.Start_Date__c = Date.today();
            examiner2.IB_Account__c = acc.Id;
            examiner2.Status__c = 'Applicant';
            examiner2.Reason_For_Status__c = 'Applicant';
            examiner2.Contact_Information_Email__c = ci.id;
            examiner2.Programme_Selection__c = 'DP';
            insert examiner2;	
            
            System.assertEquals('Applicant', examiner2.Status__c);
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
    @isTest 
    static void createUserTest_spanish(){
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        List<Contact> con1 = [select Id,IBIS_contact_ID__c from Contact where name like '%TEST' limit 4];
        Contact_Information__c ci1 = new Contact_Information__c(IB_Contact__c = con1[0].id, Email__c = 'test@test.com');
        Contact_Information__c ci2 = new Contact_Information__c(IB_Contact__c = con1[1].id, Email__c = 'test@test.com');
        Contact_Information__c ci3 = new Contact_Information__c(IB_Contact__c = con1[2].id, Email__c = 'test@test.com');
        Contact_Information__c ci4 = new Contact_Information__c(IB_Contact__c = con1[3].id, Email__c = 'test@test.com');
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Type__c = 'IBEN Role' and Role_Name__c='Examiner' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            insert ci1;
            insert ci2;
            insert ci3;
            insert ci4;
            
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[0].Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            examiner1.Contact_Information_Email__c = ci1.id;
            examiner1.Programme_Selection__c = 'DP';
            insert examiner1;
            
            IB_Role__c examiner4 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[1].Id, acc.Id);  
            examiner4.IB_Programme_New__c = prog.Id;
            examiner4.Start_Date__c = Date.today();
            examiner4.IB_Account__c = acc.Id;
            examiner4.Status__c = 'Confirmed';
            examiner4.Reason_For_Status__c = 'Confirmed';
            examiner4.Contact_Information_Email__c = ci2.id;
            examiner4.Programme_Selection__c = 'DP';
            insert examiner4;
            
            IB_Role__c examiner3 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[2].Id, acc.Id);  
            examiner3.IB_Programme_New__c = prog.Id;
            examiner3.Start_Date__c = Date.today();
            examiner3.IB_Account__c = acc.Id;
            examiner3.Status__c = 'Confirmed';
            examiner3.Reason_For_Status__c = 'Confirmed';
            examiner3.Contact_Information_Email__c = ci3.id;
            examiner3.Programme_Selection__c = 'DP';
            insert examiner3;
            
            IB_Role__c examiner2 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[3].Id, acc.Id);  
            examiner2.IB_Programme_New__c = prog.Id;
            examiner2.Start_Date__c = Date.today();
            examiner2.IB_Account__c = acc.Id;
            examiner2.Status__c = 'Confirmed';
            examiner2.Reason_For_Status__c = 'Confirmed';
            examiner2.Contact_Information_Email__c = ci4.id;
            examiner2.Programme_Selection__c = 'DP';
            insert examiner2;
        	
            
            System.assertEquals('Confirmed', examiner2.Status__c);
            System.assertEquals('Confirmed', examiner3.Status__c);
            System.assertEquals('Confirmed', examiner4.Status__c);
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
     @isTest 
    static void createUserTest_2(){
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        List<Contact> con1 = [select Id,IBIS_contact_ID__c  from Contact where name like '%TEST' limit 4];
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Name__c = 'Programme Coordinator' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[0].Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            insert examiner1;
        	
            
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
     @isTest 
    static void createUserTest_3(){
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        List<Contact> con1 = [select Id,IBIS_contact_ID__c  from Contact where name like '%TEST' limit 4];
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Name__c = 'Head of School' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[0].Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            insert examiner1;
        	
            
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
     @isTest 
    static void createUserTest_4(){
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        List<Contact> con1 = [select Id,IBIS_contact_ID__c  from Contact where name like '%TEST' limit 4];
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Name__c = 'Billing Contact' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[0].Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            insert examiner1;
        	
            
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
     @isTest 
    static void createUserTest_5(){
        Account acc = [select Id, name from Account where name='Test Account 1' limit 1];
        List<Contact> con1 = [select Id,IBIS_contact_ID__c  from Contact where name like '%TEST' limit 4];
        IB_Role_Repository__c theRoleRepo1 = [select id from IB_Role_Repository__c where Role_Name__c = 'Exam Contact' limit 1] ;
        IB_Programme__c prog = [select id from IB_Programme__c where Status__c = 'Interested' limit 1];
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        UserRole roleToPopulateonUser= [SELECT Id FROM UserRole  where DeveloperName = 'System_Administrator'];
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        u.UserRoleId = roleToPopulateonUser.Id;
        System.runAs(u)
        {
            Test.startTest();
            IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1[0].Id, acc.Id);  
            examiner1.IB_Programme_New__c = prog.Id;
            examiner1.Start_Date__c = Date.today();
            examiner1.IB_Account__c = acc.Id;
            examiner1.Status__c = 'Confirmed';
            examiner1.Reason_For_Status__c = 'Confirmed';
            insert examiner1;
        	
            
            System.assertEquals('Confirmed', examiner1.Status__c);
            Test.stopTest();
        }
    }
    
}