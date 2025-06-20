@isTest
public class CaseTriggerTest {
    @isTest
    static void CaseBeforeUpdateTriggerHandlerTestMethod()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'standt', email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', username='sta48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
        insert user;
        User user2 = new User(Alias = 'standdt', email='standardduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testings', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', username='stasas48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
        insert user2;
        
        Account acc,acc2;
        Contact con ;
        
        acc = PimsTestUtil.createAccount('Test Account', 'IB_Institute' );

        acc2 = PimsTestUtil.createAccount('Test Account 2', 'IB_Institute' );
        insert new List<Account> {acc,acc2};
        
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c = date.today()+5;
        prog.Date_Decision_on_Candidacy__c = date.today()+2;
        prog.Owner__c = UserInfo.getUserId();
        
        IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc2, 'Diploma Programme');
        prog2.Status__c = 'Authorized';
        prog2.Date_Decision_on_Authorization__c = date.today()+5;
        prog2.Date_Decision_on_Candidacy__c = date.today()+2;
        prog2.Owner__c = UserInfo.getUserId();
        insert new List<IB_Programme__c>{prog,prog2};
         
         IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Institute Administrator');
        insert new List<IB_Role_Repository__c>{repo};
        
        Contact_information__c ci=new contact_information__c(name='ck',email__c='test111@abc.com',ib_contact__c=con.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'email'].id);
        Contact_information__c cip=new Contact_information__c(name='Ck12',Country_Code__c = 'Israel (+972)',Phone_Number__c = '12345',IB_Contact__c=con.id,recordtypeid=[Select id From RecordType Where sObjectType = 'Contact_information__c' and RecordType.DeveloperName= 'phone'].id);
        insert new List<Contact_information__c>{cip,ci};
        IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, acc.id );
            role.Job_Title__c='test';
          role.Contact_Information_Email__c=ci.Id;
          role.Contact_Information_Phone__c=cip.Id;
            role.Status__c ='Confirmed';
          role.Email_Confirmed__c=true;
        insert role;
       
        String recordTypeName = 'Salesforce Support';
        Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
       
        Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
 
        Case c = new Case(Name__c='Support Request Title', Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases');
        c.OwnerId=user.id;
        insert c;
        
        c.AccountId=acc.id;
        
        //c.OwnerId = 
        /*//Added by Shahrukh on 15/06/23 for ECM00423 -- START --
        c.Q1_Did_we_resolve_your_support_request__c='No'; 
        c.Is_Survey_Unresolved__c=false;
        //Added by Shahrukh on 15/06/23 for ECM00423 -- END --*/
        
        /*//Added by Shahrukh on 15/06/23 for ECM00423 -- START --
        Case cs = [SELECT Id, Status, Is_Survey_Unresolved__c FROM Case WHERE Id =: c.Id];
        System.assertEquals('Unresolved (Survey)', cs.Status);
        System.assertEquals(true, cs.Is_Survey_Unresolved__c);
        //Added by Shahrukh on 15/06/23 for ECM00423 -- END --*/
        
        
        
        
        System.runAs(user){
            List<Case> relatedCases = new List<Case>();//[SELECT  Id,OwnerId  FROM  Case Limit 1];
            relatedCases.add(c);
            
            Map<Id,Case> OldCaseMap = new Map<Id,Case>(relatedCases);
            user.UserPermissionsSupportUser = true;
            update user;
            
            user2.UserPermissionsSupportUser = true;
            update user2;
            
            c.OwnerId=user2.id;
            update c;
            
            Map<Id,Case> NewCaseMap = new Map<Id,Case>(relatedCases);
            
           
            Test.startTest();
                CaseBeforeUpdateTriggerHandler.process(NewCaseMap, OldCaseMap);    
            Test.stopTest();  
        }
    }
    //Below Method added by Prerna on 25-07-2023 for ECM00489 
    @isTest
    static void CaseBeforeUpdateHandlerTest(){
        Profile profile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user = new User(Alias = 'standt', email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = profile.Id,
            TimeZoneSidKey='America/Los_Angeles', username='sta48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
        insert user;
        
        Case newCase = new Case(Name__c='Support Request Title', Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases');
        newCase.OwnerId=user.id;
        insert newCase;
        
        Group queue = new Group(Name = 'FEO Global School System Support', Type = 'Queue'); //changed
        insert queue;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = queue.id, SObjectType = 'Case');
            insert testQueue;
        }
        
        newCase.OwnerId = CaseTriggerHelper.gsssQueueId;
        update newCase;
        
        newCase.Status = 'Closed';
        update newCase;
        
        String ownerIdValue = String.valueof(newCase.OwnerId);
        System.assert(ownerIdValue.startsWith('00G'));
        System.assertEquals('Closed', newCase.Status);
    }
    
    //Below Method added by Prerna on 25-07-2023 for ECM00489 
    @isTest
    static void CaseAfterInsertTriggerHandlerTestMethod()
    {
        Group queue = new Group(Name = 'SO Customer Service', Type = 'Queue');
        insert queue;
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = queue.id, SObjectType = 'Case');
            insert testQueue;
        }    
        Case newCase = new Case(Name__c='Support Request Title2', Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases');
        newCase.OwnerId=queue.id;
        insert newCase;
    }
    
    //Method Added by Shahrukh on 15/06/23 for ECM00423
    @isTest
    static void caseAfterUpdateTriggerHandlerTestMethod() {
        Test.startTest();
            Case newCase = new Case(Name__c='Qualtrics Test', Status='Closed', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases', Q2_Unresolved_request_for_follow_up__c='Yes');
            newCase.OwnerId=UserInfo.getUserId();
            insert newCase;
            
            Voice_of_Customer__c voc = new Voice_of_Customer__c();
            voc.Case__c = newCase.Id;
            insert voc;
            
            newCase.Q2_Unresolved_request_for_follow_up__c = 'Updated';
            newCase.Q1_Did_we_resolve_your_support_request__c = 'Yes';
            newCase.Survey_Date__c = datetime.now();
            update newCase;
        Test.stopTest();
        
        for(Voice_of_Customer__c vocRecord : [SELECT Id, Name, Case__c, Q2_Unresolved_request_for_follow_up__c, Q8_Suggestions_for_improvement__c, Survey_Date__c
                                    FROM Voice_of_Customer__c 
                                    WHERE Case__c =: newCase.Id]) {
                                        System.assertEquals('Updated', vocRecord.Q2_Unresolved_request_for_follow_up__c);
                                        System.assert(vocRecord.Survey_Date__c != NULL);
        }
        
        
    }

    @isTest
    static void CasePGQAMethod()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Account acc;
        Contact con ;
        
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        
        Account acc2;
        acc2 = PimsTestUtil.createAccount('Test Account 2', 'Association Account' );
        insert new List<Account>{acc,acc2};
        
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
         IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c = date.today()+5;
        prog.Date_Decision_on_Candidacy__c = date.today()+2;
        prog.Owner__c = UserInfo.getUserId();
        
         IB_Programme__c prog2 = PimsTestUtil.createProgrammeForAccount (acc2, 'Diploma Programme');
        prog2.Status__c = 'Authorized';
        prog2.Date_Decision_on_Authorization__c = date.today()+5;
        prog2.Date_Decision_on_Candidacy__c = date.today()+2;
        prog2.Owner__c = UserInfo.getUserId();
        insert new List<IB_Programme__c>{prog,prog2};
            
        String recordTypeName = 'PGQA';

        IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert new List<IB_Role_Repository__c>{repo};
            
        IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, acc.id );
            role.IB_Programme_New__c = prog.Id;
        
        IB_Role__c role2 = PimsTestUtil.createIbRole(repo.Id, con.id, acc2.id );
            role2.IB_Programme_New__c = prog2.Id;
            role2.Status__c ='Confirmed';
        insert new List<IB_Role__c>{role,role2};



        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'PGQA'];
        PGQA__c subject = new PGQA__c();
        subject.Name = 'PGQA – Test';
        subject.English__c = 'PGQA – Test';
        subject.Spanish__c = 'PGQA – Test';
        subject.French__c = 'PGQA – Test';
        subject.Unavailable__c = false;
        insert subject;
        
        Test.startTest();
        
        Profile pi = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User user3 = new User(Alias = 'standt', email='standarduser@testorg.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = pi.Id,
                             TimeZoneSidKey='America/Los_Angeles', username='sta48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
        user3.UserPermissionsSupportUser  = true;
        insert user3;

        Case c = new Case(Name__c='Support Request Title', Status='New', Priority='Low', Description='Testing Change Request', Area_of_Application__c='Cases');
        c.RecordTypeId = RecType.id;
        c.AccountId = acc.id;
        c.PGQA_Subject_Level_Language__c = subject.id;
        c.OwnerId = user3.Id;
        c.Status = 'Draft';
        insert c;
         
        c.Status = 'Evidence Required';
        c.AccountId = acc2.id;
        update c;
        
        Test.stopTest();

    }

}