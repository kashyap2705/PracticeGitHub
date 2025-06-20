@isTest
private class IBENServicesTest {
    
    @testSetup static void setup()
    {
        
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        
        Account acc = PimsTestUtil.createAccount('IBEN Test', 'School Account');
        insert acc; 
        
        //Insert contacts
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.Legal_first_name__c ='Jones';
        con1.Legal_Last_name__c = 'Doe';
        con1.IBEN_Active__c=true;
        
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        con2.Legal_first_name__c ='Jones';
        con2.Legal_Last_name__c = 'Down';
         
            
            List<Contact> testContactList = new List<contact>{con1,con2};
        for(integer i=0 ; i<10 ; i++){
            Contact c = new Contact();
            c = PimsTestUtil.createContact('Test'+i, 'test'+i+'@home.com', 'test'+i+'@home.com', Date.newInstance(1992, 12, 10), acc);
            c.RecordtypeId =ContactRecordTypeId;
            c.IBIS_contact_ID__c = '';
            testContactList.add(c);
        }
        insert testContactList;
        //Insert 'Examiner' Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        //insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
            //Insert 'Teacher' Role Repository
            IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Teacher');
        theRoleRepo2.Role_Type__c = 'School Role';
        theRoleRepo2.Permission_Set_Name__c = 'Teacher';
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2};
            
            Contact_Information__c CI = new Contact_Information__c();
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Email', 'Contact_Information__c');
        CI.RecordType = rt1;
        CI.Email__c = 'Test@test.com';
        CI.Name =   'Test@test.com';  
        CI.IB_Contact__c = con1.id;
        insert CI;
            
            //Insert Programme - Examiners can have only DP as their programme selection
            IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma_Programme');
        prog.Status__c = 'Interested';
        insert prog;
        
        //Insert Confirmed Examiner Role
        IB_Role__c examinerRole = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);  
        examinerRole.IB_Programme_New__c = prog.Id;
        examinerRole.Start_Date__c = Date.today();
        examinerRole.IB_Account__c = acc.Id;
        examinerRole.Status__c = 'Confirmed';
        examinerRole.Programme_Selection__c = 'DP';
        examinerRole.Reason_For_Status__c='Confirmed'; 
        examinerRole.Contact_Information_Email__c = CI.ID;
        //insert examinerRole;
        
        //Insert Confirmed Teacher Role
        IB_Role__c teacherRole = PimsTestUtil.createIbRole(theRoleRepo2.Id, con1.Id, acc.Id);  
        teacherRole.IB_Programme_New__c = prog.Id;
        teacherRole.Start_Date__c = Date.today();
        teacherRole.IB_Account__c = acc.Id;
        teacherRole.Status__c = 'Confirmed';
        teacherRole.Reason_For_Status__c='Confirmed'; 
        //insert teacherRole
        
        //Insert Confirmed Teacher Role to con2
        IB_Role__c con2teacherRole = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc.Id);  
        con2teacherRole.IB_Programme_New__c = prog.Id;
        con2teacherRole.Start_Date__c = Date.today();
        con2teacherRole.IB_Account__c = acc.Id;
        con2teacherRole.Status__c = 'Confirmed';
        con2teacherRole.Reason_For_Status__c='Confirmed'; 
        insert new List<IB_Role__c>{examinerRole,teacherRole,con2teacherRole};
        
        //Fetch Examiner Role
        List<IB_Role__c> examinerRecord= [SELECT id,IB_Contact__c,Start_Date__c,Status__c,Reason_For_Status__c, IB_Role_Name__c,IB_Account__c,End_Date__c FROM IB_Role__c WHERE id=:examinerRole.id];
        
        //System Admin User 
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        //SCU + Basic User 
        Profile scuBasicProfile = [select Id,name from Profile where name='SCU + Basic' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'barneys', email='barney@stinson.com', 
                          emailencodingkey='UTF-8', firstname='Barney', lastname='Stinson', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='barney@stinson.com'
                         );  
        u.Bypass_Validation_Rules__c = true;
        insert u;
        
        User basicUser = new User(ProfileId=scuBasicProfile.id,alias = 'welcome', email='con1@home.com',
                                  ContactId = con1.Id,
                                  emailencodingkey='UTF-8', firstname='Jones', lastname='Down', 
                                  languagelocalekey='en_US', 
                                  localesidkey='en_US',
                                  timezonesidkey='America/Los_Angeles',username='con1@home.com'
                                 );  
        insert basicUser;
        
        
    }
    
    
    @isTest
    static void testIBCodeGeneration(){
        
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecordList = [SELECT id, IBIS_contact_ID__c,RecordTypeId FROM Contact WHERE AccountId = :accountRecord[0].Id and LastName like 'Test%'];
        System.debug('IBENServicesTest contactRecordList.size(): '+ contactRecordList.size());
        
        Test.startTest();
        IBENServicesHelper.contactIBCodeGeneration(contactRecordList);
        Test.stopTest();
    }
    
    @isTest
    static void testTrueValidExaminerRoleHolder(){
        
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecord = [SELECT id FROM Contact WHERE AccountId = :accountRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Contact ID: '+ contactRecord[0].ID);
        
        Test.startTest();
        Boolean roleExists = IBENServicesHelper.validExaminerRoleHolder(contactRecord[0].ID);
        System.assertEquals(true, roleExists);
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testFalseValidExaminerRoleHolder(){
        
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecord = [SELECT id FROM Contact WHERE AccountId = :accountRecord[0].Id AND Email ='con2@home.com' LIMIT 1];
        System.debug('IBENServicesTest Contact ID: '+ contactRecord[0].ID);
        
        Test.startTest();
        Boolean roleExists = IBENServicesHelper.validExaminerRoleHolder(contactRecord[0].ID);
        System.assertEquals(false, roleExists);
        
        Test.stopTest();
        
    }
    
    @isTest
    static void testcreateCOIOnRoleUpsert(){
        Boolean exceptionOccurred = false;
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecord = [SELECT id FROM Contact WHERE AccountId = :accountRecord[0].Id and LastName like 'Jones'  LIMIT 1];
        System.debug('IBENServicesTest Contact ID: '+ contactRecord[0].ID);
        
        List<IB_Role__c> examinerRecord = [SELECT id, IB_Contact__c, Status__c, Reason_For_Status__c, IB_Role_Name__c, Start_Date__c, End_Date__c FROM IB_Role__c WHERE IB_Role_Name__c='Examiner'
                                           AND IB_Contact__c = :contactRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Examiner Record ID: '+ examinerRecord[0].ID);
        
        
        Test.startTest();
        
        IBENServicesHelper.createCOIOnRoleUpsert(examinerRecord[0]);
        List<Conflict_of_Interest__c> conflictList = new List<Conflict_of_Interest__c>();
        conflictList = [SELECT id FROM Conflict_of_Interest__c WHERE IB_contact__c =:contactRecord[0].Id];
        system.debug('COIList' +conflictList.size());
        //System.assertEquals(2, conflictList.size());
        
        
        Test.stopTest();
    }
    
    @isTest
    static void testcreateCOIUpsert(){
        User u = [SELECT Id FROM User WHERE username='barney@stinson.com' LIMIT 1];
        System.debug('IBENServicesTest User ID: '+ u.ID);
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecord = [SELECT id FROM Contact WHERE AccountId = :accountRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Contact ID: '+ contactRecord[0].ID);
        
        List<IB_Role__c> examinerRecord = [SELECT id, IBIS_contact_ID__c, IB_Contact__c, Status__c, Reason_For_Status__c, IB_Role_Name__c FROM IB_Role__c WHERE IB_Role_Name__c='Examiner'
                                           AND IB_Contact__c = :contactRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Examiner Record ID: '+ examinerRecord[0].ID);
        
        System.runAs(u)
        {
            Test.startTest();
            
            //Insert 'ATL Coordinator' Role Repository
            IB_Role_Repository__c atlCoordinator = PimsTestUtil.createRoleRepo('ATL Coordinator');
            atlCoordinator.Role_Type__c = 'School Role';
            atlCoordinator.Permission_Set_Name__c = 'ATL_Coordinator';
            insert new List<IB_Role_Repository__c>{atlCoordinator};
                
                
                //Insert 'Confirmed ATL Coordinator' Role
                IB_Role__c atlCoordinatorRole = PimsTestUtil.createIbRole(atlCoordinator.Id, contactRecord[0].Id, accountRecord[0].Id);  
            atlCoordinatorRole.Start_Date__c = Date.today();
            atlCoordinatorRole.IB_Account__c = accountRecord[0].Id;
            atlCoordinatorRole.Status__c = 'Applicant';
            insert atlCoordinatorRole;
            
            List<IB_Role__c> atlCoordinatorRecord= [SELECT id,IBIS_contact_ID__c,IB_Contact__c,Start_Date__c,Status__c,IB_Role_Name__c,IB_Account__c,End_Date__c FROM IB_Role__c WHERE id=:atlCoordinatorRole.id];
            List<IB_Role__c> oldList=new List<IB_Role__c>();
            oldList.addAll(atlCoordinatorRecord);
            
            Map<Id,IB_Role__c> oldRoleMap=new Map<Id,IB_Role__c>(oldList);
            atlCoordinatorRole.Status__c='Confirmed';
            System.debug('## atlCoordinatorRole.Status__c : '+ atlCoordinatorRole.Status__c);
            update atlCoordinatorRole ;
            System.debug('## atlCoordinatorRole.Status__c : '+ atlCoordinatorRole.Status__c);
            
            List<IB_Role__c> newList= [SELECT id,IBIS_contact_ID__c,IB_Contact__c,End_Date__c,Start_Date__c,Status__c,IB_Role_Name__c,IB_Account__c,Programme_Status__c FROM IB_Role__c WHERE id=:atlCoordinatorRole.id];
            
            Map<Id,IB_Role__c> newRoleMap= new Map<Id,IB_Role__c>(newList);
            
            IB_RoleAfterUpdateTriggerHandler.process(oldRoleMap, newRoleMap);
            
            Test.stopTest();
        }
    } 
    
    /*@isTest
    static void testWelcomeEmailVFTemplate(){
        User u = [SELECT Id, ContactId FROM User WHERE username='con1@home.com' LIMIT 1];
        System.debug('IBENServicesTest User ID: '+ u.ID);
        List<Account> accountRecord = [SELECT id FROM Account WHERE Name = 'IBEN Test' LIMIT 1];
        System.debug('IBENServicesTest Account ID: '+ accountRecord[0].ID);
        List<Contact> contactRecord = [SELECT id, FirstName, LastName FROM Contact WHERE Id = :u.ContactId LIMIT 1];
        //AccountId = :accountRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Contact ID: '+ contactRecord[0].ID);
        
        List<IB_Role__c> examinerRecord = [SELECT id, IBIS_contact_ID__c, IB_Contact__c, Status__c, Reason_For_Status__c, IB_Role_Name__c FROM IB_Role__c WHERE IB_Role_Name__c='Examiner'
                                           AND IB_Contact__c = :contactRecord[0].Id LIMIT 1];
        System.debug('IBENServicesTest Examiner Record ID: '+ examinerRecord[0].ID);
        Id uID;
        Boolean userSetup;
        
        IBENWelcomeEmailVFTemplateController vfcontroller = new IBENWelcomeEmailVFTemplateController();
        vfcontroller.setUserId(u.Id);
        uID = vfcontroller.getUserId();
        
        vfcontroller.setisUserSetup(true);
        userSetup = vfcontroller.getisUserSetup();
        
        vfcontroller.setuserLanguage('en_US');
        String lang = vfcontroller.getuserLanguage();
        
    }*/
    
}