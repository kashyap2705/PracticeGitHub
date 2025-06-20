@isTest
public class IB_ProgrammeAfterUpdateTriggerHelperTest {

 private static User createUser (String userName, String lastName, String email, Boolean isActive, Profile prof,String locale){
        return new User(
            alias = (userName + '123456781234').replace('.','').replace('@','').substring(0,8),  
            Email = email, emailencodingkey='UTF-8', LastName = lastName, languagelocalekey='en_US',
            localesidkey=locale, 
            timezonesidkey='America/Los_Angeles', Username = userName, 
            CommunityNickname = 'Nick_' + userName, IsActive = isActive, ProfileId = prof.Id);
        
    }
    
    @testSetup
    static void steupTestData() {
        
        
        
        Profile profile= [Select Id from profile where Name='System Administrator'];         
        User user = createUser('usertestname2@gmail.com', 'test23_user_lastName', 'yy34yyy@gmail.com', true,profile,'en_US');
        user.Department ='IBWS';
        insert user;
        
        
        Account acc = AccountFactoryTest.createAccountRecord(false);
        acc.OwnerId = user.id;//UserInfo.getUserId();
        
        insert acc;
        List<Contact> conRecords = ContactFactoryTest.createContacts(3,false,acc);   
        if(!conRecords.isEmpty()){
            insert conRecords;
        }
        IB_View_State_Contacts__c ib_View=new IB_View_State_Contacts__c(Contact_ID__c=conRecords[0].Id,Account_ID__c=acc.id,Active__c=true);                
        insert ib_View;
        IB_Country_Segmentation__c country2= RoleRepoFactoryTest.createCountry(false, acc);
        insert country2;
        List<IB_Address__c> addresRec = RoleRepoFactoryTest.createAddress(3,country2.id,acc,false); 
        if(!addresRec.isEmpty()){
            insert addresRec;
        }
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'PYP');
        progRec.StageName__c = 'Evaluation';
        progRec.Status__c = 'Authorized';
        progRec.Owner__c=user.id;
        progRec.Date_Decision_on_Authorization__c=Date.newInstance(2025, 12, 9);
        progRecList.add(progRec);
        
        
        IB_Programme__c progRec2 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'MYP');
        progRec2.StageName__c = 'Evaluation';
        progRec2.Status__c = 'Authorized';
        progRec2.Owner__c=user.id;
        progRec2.Date_Decision_on_Authorization__c=Date.newInstance(2025, 12, 9);
        progRecList.add(progRec2);
        
        
        IB_Programme__c progRec3 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'Diploma Programme');
        progRec3.StageName__c = 'Decision on Candidacy';
        progRec3.Status__c = 'Interested';
        progRecList.add(progRec3);
        
        
        
        if(!progRecList.isEmpty()){
            insert progRecList;
        }
        
        IB_Subject__c ib = RoleRepoFactoryTest.createSubject(false);
        insert ib;
        BulkDataFactoryTest.loadRoleRepoData();
        IB_Role_Repository__c repoHOSOverall = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                                FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School (Overall)' Limit 1];
        
        IB_Role_Repository__c repoBC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='Billing Contact' Limit 1];
        IB_Role_Repository__c repoPC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='Programme Coordinator' Limit 1];
        IB_Role_Repository__c repoHOS = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                         FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School' Limit 1];
        
        List<IB_Role_Repository__c> updateIBRoleRepository = new List<IB_Role_Repository__c>();
        repoHOSOverall.Programme_Association__c='Optional';
        repoHOS.Programme_Association__c='Optional';
        updateIBRoleRepository.add(repoHOSOverall);
          updateIBRoleRepository.add(repoHOS);
        update updateIBRoleRepository;
        
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoHOSOverall.Id, conRecords[0].id, conRecords[0].AccountId); 
        //below line modified by Prerna on 14-05-2025 to increase the code coverage while working on ECM00739-Phase 2
        role.IB_Programme_New__c= progRecList[2].id;
        testRoles.add(role);
        
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repoHOS.Id, conRecords[0].id, conRecords[0].AccountId);
        //below line modified by Prerna on 14-05-2025 to increase the code coverage while working on ECM00739-Phase 2 
        role2.IB_Programme_New__c= progRecList[2].id;       
        testRoles.add(role2);
        
        //Code added by Prerna on 14-05-2025 for ECM00739-Phase 2 -- Starts--
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repoPC.Id, conRecords[0].id, conRecords[0].AccountId); 
        role3.IB_Programme_New__c= progRecList[2].id;
        testRoles.add(role3);
        //Code added by Prerna on 14-05-2025 for ECM00739-Phase 2 -- Ends--
        
        Test.startTest();
        insert testRoles;
        Test.stopTest();
        
    }
    
    @isTest
    static void dpUpdateCheck() {
        
        
        
        test.startTest();
        
        IB_Programme__c dpProgramme = [select id,name,recordtype.name from IB_Programme__c where recordtype.name ='Diploma Programme' limit 1 ];
        User user1=[select id from user where email='yy34yyy@gmail.com' limit 1];
        dpProgramme.StageName__c = 'Evaluation';
        dpProgramme.Status__c = 'Authorized';
        dpProgramme.Date_Decision_on_Authorization__c=Date.newInstance(2025, 12, 9);
        dpProgramme.Owner__c=user1.id;
        update dpProgramme;
        
        Assert.areEqual(3, [select id from IB_Programme__c].size());
        Test.stopTest();
        
        
        
    }
    
}