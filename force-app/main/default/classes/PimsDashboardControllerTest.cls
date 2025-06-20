@isTest
private class PimsDashboardControllerTest {
    
    @testSetup
    public static void createTestData() {
        Account acc = AccountFactoryTest.createAccountRecord(false);
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
        progRec.status__c='Interested';
        progRec.Programme_Decision_Owner__c= acc.owner.id;
        progRecList.add(progRec);
        IB_Programme__c progRec2 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'MYP');
        progRec2.status__c='Candidate';
        progRec2.Owner__c= UserInfo.getUserId() ;
        progRecList.add(progRec2);
        IB_Programme__c progRec3 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'Diploma Programme');
        progRec3.status__c='Authorized';
        progRec3.Date_Decision_on_Authorization__c= Date.newInstance(2024, 12, 9);
        progRec3.Owner__c= UserInfo.getUserId() ;
        progRecList.add(progRec3);
        IB_Programme__c progRec4 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'CP');
        progRec4.status__c='Authorized';
        progRec4.Date_Decision_on_Authorization__c= Date.newInstance(2024, 12, 9);
        progRec4.Owner__c= UserInfo.getUserId() ;
        progRecList.add(progRec4);
        if(!progRecList.isEmpty()){
            insert progRecList;
        }
        IB_Subject__c ib = RoleRepoFactoryTest.createSubject(false);
        insert ib;
        BulkDataFactoryTest.loadRoleRepoData();
        
        IB_Role_Repository__c repoEC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='Exam Contact' Limit 1];
        IB_Role_Repository__c repoBC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='Billing Contact' Limit 1];
        IB_Role_Repository__c repoPC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='Programme Coordinator' Limit 1];
        IB_Role_Repository__c repoHOS = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                         FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School' Limit 1];
        
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoBC.Id, conRecords[0].id, conRecords[0].AccountId); 
        testRoles.add(role);
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repoHOS.Id, conRecords[1].id, conRecords[0].AccountId); 
        testRoles.add(role2);
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repoPC.Id, conRecords[2].id, conRecords[0].AccountId); 
        testRoles.add(role3);
        IB_Role__c role4 = RoleRepoFactoryTest.createIbRole(repoEC.Id, conRecords[2].id, conRecords[0].AccountId); 
        testRoles.add(role4);
        insert testRoles;   
        
        
        
    }
    
    @isTest
    public static void testDashboardPage() {
        PageReference pageRef = Page.PimsDashboard;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        PimsDashboardController pdc = new PimsDashboardController();
        system.assertEquals(true, pdc.Check_EP_Programme());
        pdc.getUserLanguageKey();
        pdc.getShowPypSubDate();
        system.assertEquals(false, pdc.getDisplayIntentPanel());
        Test.stopTest();
    }
    
    //below method created by Prerna on 16-08-2023 for ECM00606 
    @isTest static void PimsDashboardControllerTestMethod_Modified(){
        
        Test.startTest();
        PimsDashboardController pims = new PimsDashboardController();
        pims.headOfSchoolContactRole = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                        FROM IB_Role__c WHERE IB_Role__r.Role_Name__c='Head of School'];
        pims.programmeContactRole = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                     FROM IB_Role__c WHERE IB_Role__r.Role_Name__c='Programme Coordinator'];
        pims.examContactRole = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                FROM IB_Role__c WHERE IB_Role__r.Role_Name__c='Exam Contact'];
        pims.billingContactRole = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                   FROM IB_Role__c WHERE IB_Role__r.Role_Name__c='Billing Contact'];
        Test.stopTest();
        
    }
    
    
    @isTest
    static void testPimsDashboardController() {
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='System Administrator'  and isActive=: true LIMIT 1];
        u.Bypass_Validation_Rules__c = true;
        u.LanguageLocaleKey='en_US';
        
        // Set the user's language to French  
        System.runAs(u) {
            Test.startTest();
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put('Programme Status','Programme Status');
            customLabelMap.put('IB Programme','IB Programme');
            customLabelMap.put('IB staff contact information','IB staff contact information');
            
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
            system.debug('customlabelList**'+customlabelList);
            
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
                transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty())
                insert transList;
            system.debug('transList**'+transList);
            //List<customlabel__c> customlabelList = [select id from customlabel__c];
            
            List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
            PimsDashboardController controller = new PimsDashboardController();
            Map<String, String> translationsMap = controller.getTranslationsMap();
            
            
            Test.stopTest();
        }
    }
    
    
}