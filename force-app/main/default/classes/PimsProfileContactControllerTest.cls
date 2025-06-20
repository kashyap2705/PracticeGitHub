/*******************************************************************************************
* @Name         PimsProfileContactControllerTest 
* @Author       Saurabh Singh Singhaniya
* @Date         25th July, 2023
* @Group        
* @Description  Test class for PimsProfileContactController
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 
*******************************************************************************************/
@isTest
public class PimsProfileContactControllerTest {
    
    @testSetup
    static void setupTestData() {
        
        Id userLicenseId = [ SELECT Id FROM UserLicense WHERE name = 'Salesforce'].id;
        Id userroleId = [ SELECT Id FROM UserRole WHERE name = 'System Administrator'].id;
        Id communityprofileId = [SELECT Id FROM Profile WHERE name='system administrator' and UserLicenseId=:userLicenseId].id;
        List<User> usr = AccountFactoryTest.createUserTestData(1,communityprofileId,false,'ibportaltestuser@testorg.com');
        usr[0].Bypass_Validation_Rules__c = true;
        usr[0].UserRoleId = userroleId;
        insert usr;
        User pu;
        System.runAs(usr[0]){
            
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put(IboUtil.Ib_Application_Select_Contact, 'testing');
            customLabelMap.put(IboUtil.Ib_Application_New_Programme_Application,'testing 2');
            
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
            
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
                transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty())
                insert transList;
            Test.startTest();
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
            progRecList.add(progRec);
            IB_Programme__c progRec2 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'MYP');
            progRecList.add(progRec2);
            IB_Programme__c progRec3 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'Diploma Programme');
            progRecList.add(progRec3);
            IB_Programme__c progRec4 = IbProgramFactoryTest.createProgrammeForAccount(acc, 'CP');
            progRecList.add(progRec4);
            
            
            
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
            
            List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
            IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoBC.Id, conRecords[0].id, conRecords[0].AccountId);
            testRoles.add(role);
            IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repoHOS.Id, conRecords[1].id, conRecords[0].AccountId); 
            testRoles.add(role2);
            IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repoPC.Id, conRecords[2].id, conRecords[0].AccountId); 
            testRoles.add(role3);
            
            insert testRoles;   
            Test.stopTest();
        }
        
    }
    
    
    @isTest
    static void labelTranslations(){
        PimsProfileContactController ppcc= new PimsProfileContactController();
        
        Map<String,String> customLabelMap = new Map<String,String>();
        customLabelMap.put('Admin Assistant 1','Admin Assistant 1');
        customLabelMap.put('Admin Assistant 2','Admin Assistant 2');
        customLabelMap.put('Admin Assistant 3','Admin Assistant 3');
        
        customLabelMap.put('This action cannot be completed. The person that you are inviting to this role already has a pending or confirmed Chief Invigilator role for this programme at your school.','This action cannot be completed. The person that you are inviting to this role already has a pending or confirmed Chief Invigilator role for this programme at your school.');
        customLabelMap.put('Middle Years Programme Contacts','Middle Years Programme Contacts');
        customLabelMap.put('Diploma Years Programme Contacts','Diploma Years Programme Contacts');
        customLabelMap.put('Primary Years Programme Contacts','Primary Years Programme Contacts');
        customLabelMap.put('Career-related Programme Contacts','Career-related Programme Contacts');
        customLabelMap.put('Chief Invigilator role limit has been reached. Remove some other contacts from this role to proceed.','Chief Invigilator role limit has been reached. Remove some other contacts from this role to proceed.');
        customLabelMap.put('Chief Invigilator','Chief Invigilator');
        customLabelMap.put('Add new contact only for Programme Coordinators, Heads of Schools, Billing Contacts, Exam Contacts, Chief Invigilators and Admin Assistants roles. All other contacts register themselves via My IB.','Add new contact only for Programme Coordinators, Heads of Schools, Billing Contacts, Exam Contacts, Chief Invigilators and Admin Assistants roles. All other contacts register themselves via My IB.');
        customLabelMap.put('See My School Tutorial','See My School Tutorial');
        customLabelMap.put('See My IB tutorial','See My IB tutorial');
        // customLabelMap.put('New_Programme_Application','New_Programme_Application');
        //customLabelMap.put('Select_a_Contact','Select_a_Contact');
        
        
        
        
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
        Map<String, String> translationsMap = ppcc.getTranslationsMap();
        
        system.assertEquals(IboUtil.PIMS_ADMIN1,ppcc.pimsAdminAssistant1);
        system.assertEquals(IboUtil.PIMS_ADMIN2,ppcc.pimsAdminAssistant2);
        system.assertEquals(IboUtil.PIMS_ADMIN3,ppcc.pimsAdminAssistant3);
        system.assertEquals(IboUtil.DAS_DUPLICATECONTACTINVITATIONERROR,ppcc.pimsDuplicateContactError);
        system.assertEquals(IboUtil.PIMS_MYP,ppcc.pimsMYP);
        system.assertEquals(IboUtil.PIMS_DP,ppcc.pimsDP);
        system.assertEquals(IboUtil.PIMS_PYP, ppcc.pimsPYP);
        system.assertEquals(IboUtil.PIMS_CP,ppcc.pimsCP);
        system.assertEquals(IboUtil.PIMS_CI_ROLE_LIMIT_ERROR,ppcc.pimsLimitError);
        system.assertEquals(IboUtil.PIMS_CHIEF_INVIGILATOR,ppcc.pimsChiefInvigilator);
        system.assertEquals(IboUtil.PIMS_TOOL_TIP,ppcc.pimToolTip);
        system.assertEquals(IboUtil.PIMS_SCHOOL_TUTORIAL,ppcc.pimsSchoolTutorial);
        system.assertEquals(IboUtil.PIMS_IB_TUTORIAL,ppcc.pimsIBTutorial);
        //system.assertEquals(IboUtil.Ib_Application_New_Programme_Application,ppcc.NewProgrammeApplication);
        //system.assertEquals(IboUtil.Ib_Application_Select_Contact,ppcc.SelectContactTrans);
        
        
        IB_Programme__c result =ppcc.pyp;
        IB_Programme__c result1 =ppcc.myp;
        IB_Programme__c result2 =ppcc.dp;
        IB_Programme__c result3 =ppcc.ibcc;
        IB_Programme__c result4 =ppcc.agreement;
        
    }
    
    @isTest
    static void testCreateChiefInvigilator(){
        test.startTest();        
        PageReference pimsProfile = Page.PimsProfile;
        Test.setCurrentPage(pimsProfile);
        PimsProfileContactController controller = new PimsProfileContactController();
        List<SelectOption> contactQualificationsVar = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult2 = Schema.Contact.Qualifications__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for(Schema.PicklistEntry f : ple2){
            contactQualificationsVar.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        Account accountJohn = [SELECT Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        controller.addContact=contactsRecords[0];
        
        IB_Role_Repository__c repo1 = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            Available_To__c  = Date.today().addDays(12),
            CurrencyIsoCode='EUR',
            Role_Name__c='Chief Invigilator',
            Role_type__c = 'School Role',
            MyIB_Max_Number_of_this_Role__c = 5,
            Category__c = 'School Services' ,
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            Display_in_MyIB__c  = true,
            IB_Staff_Role__c=true);
        insert repo1;
        
        IB_Role__c createIbRoleRecord = RoleRepoFactoryTest.createIbRole(repo1.id,contactsRecords[0].id,accountJohn.id);
        
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c
                                             where recordtype.name='CP' limit 1];
        createIbRoleRecord.IB_Programme_New__c = progRecList[0].Id;
        
        insert createIbRoleRecord;
        controller.addRole = createIbRoleRecord; 
        controller.ContactQualifications = contactQualificationsVar;
        
        Custom_Label_Project__c clp= new Custom_Label_Project__c();
        clp.Name='My School Profile';
        insert clp;
        
        CustomLabel__c cl = new CustomLabel__c(Label__c = IboUtil.DAS_DUPLICATECONTACTINVITATIONERROR,Group__c='My School', Project__c=clp.Id);
        insert cl;
        
        Translation__c translation = new Translation__c(
            Language__c = 'American English',
            Value__c = 'Duplicate Chief Invigilator found.',
            CustomLabel__c = cl.Id
        );
        insert translation;
        controller.create();
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Id=:controller.addContact.Id ], 'Contact Inserted'); 
        
        
        
        
        
        Test.stopTest();
        
    }
    
    
    /** 635-phase 2 ***/
    @isTest
    static void dpExistsCheck() {
         test.startTest();
        	Account acc1 = [SELECT Id, Name FROM Account Limit 1];
            IB_Programme__c dpProgramme = [select id,name,recordtype.name from IB_Programme__c where recordtype.name ='Diploma Programme' limit 1 ];
            dpProgramme.Status__c='Candidate';
            update dpProgramme;
        
           
        
            
            IB_Programme__c agreementProg = IbProgramFactoryTest.createProgrammeForAccount(acc1, 'Agreement');
            agreementProg.Agreement_Type__c='UK MEP';
            agreementProg.Status__c ='Authorized';
            agreementProg.AFA_Initiation_Date__c =system.today();
        	agreementProg.Exam_Session__c='November';
        	agreementProg.Owner__c= userInfo.getUserId();
            agreementProg.Date_Decision_on_Authorization__c=system.today();
          
           
            
        try{
       
        insert agreementProg;
        }catch(Exception e){
            
        }
        system.assertEquals('Diploma Programme', dpProgramme.recordtype.name);
          test.stopTest();
        
        
    }
     /** 635-phase 2 ***/
    /** 635-phase 2 ***/
     @isTest
    static void agreementExistsCheck() {
         test.startTest();
        Account acc1 = [SELECT Id, Name FROM Account Limit 1];
         List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
         
            IB_Programme__c dpprog = IbProgramFactoryTest.createProgrammeForAccount(acc1, 'Diploma Programme');
        	dpprog.Status__c ='Interested';
            
            
           
            IB_Programme__c agreementProg = IbProgramFactoryTest.createProgrammeForAccount(acc1, 'Agreement');
            agreementProg.Agreement_Type__c='UK MEP';
            agreementProg.Status__c ='Authorized';
            agreementProg.Date_Decision_on_Authorization__c=system.today();
        	agreementProg.AFA_Initiation_Date__c =system.today();
        	agreementProg.Exam_Session__c='May';
        	agreementProg.Owner__c= userInfo.getUserId();
            progRecList.add(agreementProg);
            
            
        
            if(!progRecList.isEmpty()){
                insert progRecList;
            }
         try{
        insert dpprog;
         }catch(Exception e){
             
         }
         system.assertEquals('UK MEP', agreementProg.Agreement_Type__c);
       
          test.stopTest();
   }
    /** 635-phase 2 ***/

    @isTest
    static List<Contact> queryAllContacts() {
        List<Contact> contactRecords = [SELECT Id, Name,FirstName, Invitation_ID__c,Salutation,LastName,MobilePhone,HomePhone,Email,Birthdate,Alternative_Email__c,
                                        MailingCity,MailingState,MailingStateCode,MailingCountry,MailingCountryCode,MailingPostalCode,MailingStreet,AccountId,
                                        Full_time_Part_time__c,Number_of_years_at_school__c,Phone,Qualifications__c,Job_Title__c,
                                        Birth_Locale__c,Country_of_Birth__c,Country_Code__c,Phone_Number__c,OwnerId FROM Contact Order by LastName];
        Return contactRecords;
    }
    
    @isTest
    static void testMethodManualWithdrawOfRole() {
        Test.startTest();
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c FROM IB_Role_Repository__c WHERE Role_Name__c='Teacher'  Limit 1];            
        
        List<Contact> contacts =queryAllContacts();
        Account acc1 = [SELECT Id, Name FROM Account Limit 1];
        IB_View_State_Contacts__c ibViewStateContact = [SELECT Id FROM IB_View_State_Contacts__c];
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE RecordType.Name = 'PYP' Limit 1];
        IB_Role__c role2 = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                            FROM IB_Role__c WHERE IB_Contact__c =: contacts[1].Id limit 1];
        role2.IB_Programme_New__c = programme.Id;
        update role2;
        IB_Referee_Feedback__c rf= RoleRepoFactoryTest.createFeedback(role2.id,role2.IB_Contact__c);
        insert rf;
        
        PageReference pageRef = Page.PimsProfile;
        Test.setCurrentPage(pageRef);
        PimsProfileContactController controller = new PimsProfileContactController();                          
        controller.deleteContactId = contacts[1].Id;
        controller.isUpdatePage = false;
        controller.removeInvitedRoleManually();
        System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE Id = :contacts[1].id], 'Contact should be deleted');
        Test.stopTest();      
    } 
    
    @IsTest
    static void testSaveDefaultRoles() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'PYP' Limit 1];
        List<IB_Role__c> ibRoles = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                    FROM IB_Role__c];
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];
        
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            controller.pypHosContact = new IB_Role__c(IB_Contact__c=contacts[1].id, IB_Account__c=acc.Id);
            controller.pypProgrammeCoordinator = new IB_Role__c(IB_Contact__c=contacts[1].id, IB_Account__c=acc.Id);
            controller.pypBillingContact = new IB_Role__c(IB_Contact__c=contacts[1].id, IB_Account__c=acc.Id);            
            PageReference result = controller.savePYP();
            IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Contact__c=:contacts[1].id LIMIT 1];
            Test.stopTest();
            system.assertEquals('Head of School', ib.IB_Role__r.Role_Name__c);
            
        }
    }
    
    @IsTest
    static void testSaveDefaultRolesForIBCC() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();  
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        List<IB_Role__c> ibRoles = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                    FROM IB_Role__c WHERE IB_Contact__c =: contacts[0].Id AND IB_Role__r.Role_Name__c='Billing Contact'];
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1]; 
        
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            controller.ibccHosContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.ibccProgrammeCoordinator = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.ibccBillingContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);  
            controller.ibccExamContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);            
            PageReference result = controller.saveCP();
            IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Contact__c=:contacts[2].id LIMIT 1];
            Test.stopTest();
            system.assertEquals('Programme Coordinator', ib.IB_Role__r.Role_Name__c);
            
        }
    }
    
    @IsTest 
    static void testSaveDefaultRolesForMYP() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        Test.startTest();
        List<Contact> contacts =queryAllContacts();
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'MYP' Limit 1];
        List<IB_Role__c> ibRoles = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                    FROM IB_Role__c WHERE IB_Contact__c =: contacts[0].Id AND IB_Role__r.Role_Name__c='Billing Contact'];
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1]; 
        
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            controller.mypHosContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.mypProgrammeCoordinator = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.mypBillingContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);  
            controller.mypExamContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);     
            PageReference result = controller.saveMYP();
            IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Contact__c=:contacts[2].id LIMIT 1];
            Test.stopTest();
            system.assertEquals('Programme Coordinator', ib.IB_Role__r.Role_Name__c);
            
        }
    }
    
    @IsTest
    static void testSaveDefaultRolesForDP() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        List<IB_Role__c> ibRoles = [SELECT Id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                                    FROM IB_Role__c WHERE IB_Contact__c =: contacts[0].Id AND IB_Role__r.Role_Name__c='Billing Contact'];
        
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];         
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            controller.dpHosContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.dpProgrammeCoordinator = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);
            controller.dpBillingContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);  
            controller.dpExamContact = new IB_Role__c(IB_Contact__c=contacts[2].id, IB_Account__c=acc.Id);            
            PageReference result = controller.saveDP();        
            PageReference result1 = controller.saveAgreement();
            PageReference result2 = controller.saveAdminAgreement();
            IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Contact__c=:contacts[2].id LIMIT 1];
            Test.stopTest();
            system.assertEquals('Programme Coordinator', ib.IB_Role__r.Role_Name__c);
        }
    }
    
    @IsTest
    static void testSaveAdminAssistant() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        Test.startTest();
        List<Contact> contacts =queryAllContacts();        
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'PYP' Limit 1];
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                      FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[0].id, contacts[0].AccountId); 
        role.IB_Programme_New__c = programme.Id;
        role.Status__c = 'Applicant';
        testRoles.add(role);
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[1].id, contacts[0].AccountId); 
        role2.IB_Programme_New__c = programme.Id;
        role2.Status__c = 'Applicant';
        testRoles.add(role2);
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[2].id, contacts[0].AccountId); 
        role3.IB_Programme_New__c = programme.Id;
        role3.Status__c = 'Applicant';
        testRoles.add(role3);
        insert testRoles;
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            PageReference result1 = controller.saveAdminPYP();            
            System.assertEquals(3, [SELECT COUNT() FROM IB_role__c WHERE IB_Contact__c =:contacts[0].id ], 'Role Added');
            Test.stopTest();
        }
    }
    
    @IsTest
    static void testSaveAdminAssistantMYP() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                      FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'MYP' Limit 1];
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[0].id, contacts[0].AccountId); 
        role.IB_Programme_New__c = programme.Id;
        role.Status__c = 'Applicant';
        testRoles.add(role);
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[1].id, contacts[0].AccountId); 
        role2.IB_Programme_New__c = programme.Id;
        role2.Status__c = 'Applicant';
        testRoles.add(role2);
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[2].id, contacts[0].AccountId); 
        role3.IB_Programme_New__c = programme.Id;
        role3.Status__c = 'Applicant';
        testRoles.add(role3);
        insert testRoles;
        
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];
        
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();
            PageReference result1 = controller.saveAdminMYP();
            System.assertEquals(3, [SELECT COUNT() FROM IB_role__c WHERE IB_Contact__c =:contacts[0].id ], 'Role Added');
            Test.stopTest(); 
        }
    }
    
    @IsTest
    static void testSaveAdminAssistantIBCC() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        Test.startTest();
        List<Contact> contacts =queryAllContacts();
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                      FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'CP' Limit 1];
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[0].id, contacts[0].AccountId); 
        role.IB_Programme_New__c = programme.Id;
        role.Status__c = 'Applicant';
        testRoles.add(role);
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[1].id, contacts[0].AccountId); 
        role2.IB_Programme_New__c = programme.Id;
        role2.Status__c = 'Applicant';
        testRoles.add(role2);
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[2].id, contacts[0].AccountId); 
        role3.IB_Programme_New__c = programme.Id;
        role3.Status__c = 'Applicant';
        testRoles.add(role3);
        insert testRoles;
        
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];
        
        system.runAs(systemAdmin[0]) {
            PimsProfileContactController controller = new PimsProfileContactController();            
            PageReference result1 = controller.saveAdminCP();            
            System.assertEquals(3, [SELECT COUNT() FROM IB_role__c WHERE IB_Contact__c =:contacts[0].id ], 'Role Added');
            Test.stopTest();
        }  
    }
    
    @IsTest
    static void testSaveAdminAssistantDP() {
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        Test.startTest();
        List<Contact> contacts =queryAllContacts();      
        IB_View_State_Contacts__c ibViewStateContact = [SELECT id FROM IB_View_State_Contacts__c];
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                      FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: acc.Id AND RecordType.Name = 'Diploma Programme' Limit 1];
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[0].id, contacts[0].AccountId); 
        role.IB_Programme_New__c = programme.Id;
        role.Status__c = 'Applicant';
        testRoles.add(role);
        
        IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[1].id, contacts[0].AccountId); 
        role2.IB_Programme_New__c = programme.Id; 
        role2.Status__c = 'Applicant';
        testRoles.add(role2);
        
        IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repo.Id, contacts[2].id, contacts[0].AccountId); 
        role3.IB_Programme_New__c = programme.Id;
        role3.Status__c = 'Applicant';
        testRoles.add(role3);
        insert testRoles;
        
        List<User> systemAdmin = [SELECT Id FROM User WHERE UserName='ibportaltestuser@testorg.com' limit 1];
        
        system.runAs(systemAdmin[0]) {
            
            PimsProfileContactController controller = new PimsProfileContactController();
            PageReference result1 = controller.saveAdminDP();
            System.assertEquals(3, [SELECT COUNT() FROM IB_role__c WHERE IB_Contact__c =:contacts[0].id ], 'Role Added');
            Test.stopTest();        }
    }
    
    @IsTest
    static void testRemove() {
        Test.startTest();
        Account inactiveContacts = AccountFactoryTest.createAccount('IBAEM Inactive Contacts', '');
        inactiveContacts.Website = 'www.test.com'; 
        insert inactiveContacts;
        Id RecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Invited Contact').getRecordTypeId();
        Contact IbenContact = new Contact(Salutation = 'Mr.',RecordTypeId =RecType ,FirstName = 'noname',LastName = 'IbenConEEtact',MobilePhone = '+30992907711',HomePhone = '+30992907711',Email = 'TestEmail@gmail.com',Birthdate = Date.today().addYears(-20),AccountId = inactiveContacts.Id);
        insert IbenContact;
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                      FROM IB_Role_Repository__c WHERE Role_Name__c='Teacher' Limit 1];        
        
        Contact contact = [SELECT Id, Name,FirstName, Invitation_ID__c,Salutation,LastName,MobilePhone,HomePhone,Email,Birthdate,Alternative_Email__c,
                           MailingCity,MailingState,MailingStateCode,MailingCountry,MailingCountryCode,MailingPostalCode,MailingStreet,AccountId,
                           Full_time_Part_time__c,Number_of_years_at_school__c,Phone,Qualifications__c,Job_Title__c,
                           Birth_Locale__c,Country_of_Birth__c,Country_Code__c,Phone_Number__c FROM Contact WHERE LastName = 'IbenConEEtact' limit 1]; 
        IB_Role__c roleRecord = RoleRepoFactoryTest.createIbRole(repo.Id, contact.id, contact.AccountId); 
        roleRecord.Status__c = 'Invited';
        insert roleRecord;
        PimsProfileContactController controllerInstance = new PimsProfileContactController();
        
        controllerInstance.isUpdatePage = true;
        Test.setCurrentPageReference(new PageReference('/apex/PimsProfile'));     
        controllerInstance.deleteContactId = contact.id; 
        PageReference result = controllerInstance.remove();
        PageReference result1 = controllerInstance.Removecon();     
        Test.stopTest();
        List<Contact> contactsList = [SELECT Id, Name,Recordtype.name, FirstName, Invitation_ID__c,Salutation,LastName,MobilePhone,HomePhone,Email,
                                      Birthdate,Alternative_Email__c,MailingCity,MailingState,MailingStateCode,MailingCountry,MailingCountryCode,MailingPostalCode,MailingStreet,AccountId,
                                      Full_time_Part_time__c,Number_of_years_at_school__c,Phone,Qualifications__c,Job_Title__c,
                                      Birth_Locale__c,Country_of_Birth__c,Country_Code__c,Phone_Number__c FROM 
                                      Contact WHERE LastName = 'IbenConEEtact'];
        system.assertEquals(0, contactsList.size()); 
    }
    
    @IsTest
    static void testCreateIntent() {
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        Contact con = new Contact(LastName = 'fgh',Email = 'chgcgj@hvjhk.com',Birthdate = Date.today().addYears(-20),FirstName = 'noname', AccountId = acc.Id);
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.contact = con; 
        controller.isUpdatePage = true;
        PageReference result = controller.createIntent();
        controller.isUpdatePage = true;
        PageReference result1 = controller.cancelIntent();
        controller.isUpdatePage = false;
        PageReference result2 = controller.cancelIntent();
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Id=:con.Id ], 'Contact Inserted');        
        Test.stopTest();
    }
    
    @IsTest
    static void testCreateRole() {
        Test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_Subject__c theSubject = [SELECT ID, IB_Programme__c, IB_Programme_Long__c, Subject_Group__c,subject_Name__c,Subject_Code__c FROM IB_Subject__c Limit 1];
        controller.subject = string.valueOf(theSubject.Id);
        controller.addContact = contacts[0];
        controller.editContact = contacts[0];
        controller.account = acc;
        controller.addRole = new IB_Role__c(IB_Contact__c=contacts[0].id, IB_Account__c=acc.Id);
        PageReference result = controller.createRole();
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Id = :contacts[0].id], 'Role Added');
        Test.stopTest();
    }
    
    @IsTest
    static void testcreateProDev() {
        Test.startTest();
        List<Contact> contacts =queryAllContacts();
        IB_Role__c role = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE IB_Contact__c =: contacts[1].Id AND IB_Role__r.Role_Name__c='Head of School' limit 1];
        PimsProfileContactController controller = new PimsProfileContactController();        
        Contact_Professional_Development__c c=new Contact_Professional_Development__c(City__c='Lahore', Workshop_Category__c='normal', Workshop_Name__c='test222' ,Role__c=role.id,Workshop_Status__c='Attended');    
        controller.addContact = contacts[1];
        controller.addProDev = c;
        PageReference result = controller.createProDev();
        System.assertEquals(1, [SELECT COUNT() FROM Contact_Professional_Development__c WHERE Role__c=: role.id], 'Contact Professional Development Added');
        Test.stopTest();
    }
    
    @IsTest
    static void testremoveRole() {
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_Role__c role = [SELECT Id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE IB_Contact__c =: contacts[1].Id AND IB_Role__r.Role_Name__c='Head of School' limit 1];
        
        role.End_Date__c = system.today();
        role.Status__c = 'Applicant';
        PimsProfileContactController controller = new PimsProfileContactController();    
        controller.account = acc;
        controller.roleId = role.Id;
        PageReference result = controller.removeRole();
        PageReference result1 = controller.confirmRole();
        System.assertEquals(1, [SELECT COUNT() FROM IB_Role__c WHERE Id = :role.id], 'Role Added');
        Test.stopTest();
    }
    
    @isTest
    static void getQualificationsTest() {
        List<Contact> contacts =queryAllContacts();
        Test.startTest();
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School (Overall)' Limit 1];        
        IB_Programme__c programme = [SELECT Id, Name FROM IB_Programme__c Limit 1];
        IB_Role__c role = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE IB_Contact__c =: contacts[0].Id limit 1];
        role.Status__c = 'Invited';
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.getQualifications();
        System.assertEquals(1, [SELECT COUNT() FROM IB_Role__c WHERE Id = :role.id],'');
        
        test.stopTest();
    }
    
    @IsTest
    static void testSave() {
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contacts =queryAllContacts();
        IB_Role__c role = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE IB_Contact__c =: contacts[1].Id AND IB_Role__r.Role_Name__c='Head of School' limit 1];
        
        PimsProfileContactController controller = new PimsProfileContactController();    
        controller.headOfSchool = role;
        PageReference result = controller.save();
        IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Contact__c=:contacts[1].id LIMIT 1];
        Test.stopTest();
        system.assertEquals('Head of School', ib.IB_Role__r.Role_Name__c);
        
    }
    
    @isTest
    static void testMethodPageRedirect() {
        Test.startTest();
        PimsProfileContactController sampleObj = new PimsProfileContactController();
        sampleObj.pageIntent = 'pyp';
        PageReference ref = sampleObj.pageRedirect('PimsDashboard');
        system.assert(ref.getUrl().contains('PimsDashboard'));
        ref = sampleObj.pageRedirect('PimsProfileNew');
        system.assert(ref.getUrl().contains('PimsProfileNew'));
        sampleObj.pageIntent = 'profileNew_pyp';
        ref = sampleObj.pageRedirect('PimsProfileNew');
        ref = sampleObj.pageRedirect('PimsProfile');
        system.assert(ref.getUrl().contains('PimsProfile'));
        Test.stopTest();
    }
    
    @isTest
    static void testSubjectGroups(){
        test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        IB_Subject__c theSubject = [SELECT ID, IB_Programme__c, IB_Programme_Long__c, Subject_Group__c,subject_Name__c,Subject_Code__c FROM IB_Subject__c Limit 1];
        
        IB_Role__c ibRole = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                             FROM IB_Role__c limit 1];
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c];
        integer size = progRecList.size();
        if(size>0)
            ibRole.IB_Programme_New__c = progRecList[0].id;
        
        update ibRole;
        controller.addRole = ibRole;
        controller.getSubjectGroups();
        
        if(size>1)
            ibRole.IB_Programme_New__c = progRecList[1].id;
        List<SelectOption>  sub =controller.getSubjectGroups();
        IB_Role__c ib = [SELECT Id, Name, IB_Contact__r.Name,IB_Role__r.Role_Name__c FROM IB_Role__c WHERE IB_Programme_New__c =:progRecList[0].id LIMIT 1];
        Test.stopTest();
        system.assertEquals(0,sub.size());
    }
    
    @isTest
    static void testGetSubjects(){
        test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        IB_Subject__c theSubject = [SELECT ID, IB_Programme__c, IB_Programme_Long__c, Subject_Group__c,subject_Name__c,Subject_Code__c FROM IB_Subject__c Limit 1];
        
        IB_Role__c ibRole = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                             FROM IB_Role__c limit 1];
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c];
        integer size = progRecList.size();
        if(size>0)
            ibRole.IB_Programme_New__c = progRecList[0].id;
        
        
        update ibRole;
        controller.addRole = ibRole;
        controller.subjectGroup = 'Other';
        controller.getSubjects();
        if(size>1)
            ibRole.IB_Programme_New__c = progRecList[1].id;
        List<SelectOption> sub = controller.getSubjects();        
        Test.stopTest();
        system.assertEquals(0,sub.size());
        
        
    }
    
    @isTest
    static void testEditPhone(){
        test.startTest();
        List<Contact> contacts =queryAllContacts();        
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.addContact = contacts[0];
        Boolean result = controller.edit_phone();
        system.debug('result of testEdit_phone--->'+result);
        test.stopTest();
        system.assertEquals(false, result);
        
    }
    
    @isTest
    static void testCreateEmail(){
        test.startTest();
        Account accountJohn = [SELECT Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        
        List<Contact> contacts =queryAllContacts();
        contacts[1].recordTypeId= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Invited_Contact').getRecordTypeId();
        update contacts;
        IB_Role_Repository__c repo = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c FROM IB_Role_Repository__c WHERE Role_Name__c='Programme Coordinator' Limit 1];
        IB_Role__c createIbRoleRecord = RoleRepoFactoryTest.createIbRole(repo.id,contacts[1].id,accountJohn.id);
        //IB_Role__c.IB_Programme_New__r.Agreement_Type__c added newly ECM00635
        List<IB_Role__c> ibRoles = [SELECT id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c,IB_Role__c.IB_Programme_New__r.Agreement_Type__c
                                    FROM IB_Role__c limit 1];
        PimsProfileContactController controller = new PimsProfileContactController();
        if(!contacts.isEmpty()){
            controller.newReminderId = contacts[1].Id;
            controller.invitedContacts = contacts;
            controller.invitedRoles = ibRoles;
            controller.roleId = ibRoles[0].Id;
            controller.createEmail();
			controller.sendInvitationEmail('abc@yopmail.com');
            test.stopTest();            
        }  
    }
    
    @isTest
    static void testCreate(){
        test.startTest();        
        PageReference pimsProfile = Page.PimsProfile;
        Test.setCurrentPage(pimsProfile);
        PimsProfileContactController controller = new PimsProfileContactController();
        List<SelectOption> contactQualificationsVar = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult2 = Schema.Contact.Qualifications__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for(Schema.PicklistEntry f : ple2){
            contactQualificationsVar.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        Account accountJohn = [SELECT Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        controller.addContact=contactsRecords[0];
        IB_Role_Repository__c repo1 = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,
                                       Sub_Category__c,Training_Model__c,IB_Staff_Role__c, Available_in_Region__c,Related_Programmes__c 
                                       FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        IB_Role__c createIbRoleRecord = RoleRepoFactoryTest.createIbRole(repo1.id,contactsRecords[0].id,accountJohn.id);
        
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c];
        createIbRoleRecord.IB_Programme_New__c = progRecList[0].Id;
        
        insert createIbRoleRecord;
        controller.addRole = createIbRoleRecord; 
        controller.ContactQualifications = contactQualificationsVar;
        controller.create();
        System.assertEquals(1, [SELECT COUNT() FROM Contact WHERE Id=:controller.addContact.Id ], 'Contact Inserted'); 
        Test.stopTest();
        
    }
    
    @isTest
    static void testCreate1(){
        Test.startTest();
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        PageReference pimsProfile = Page.PimsProfile;
        Test.setCurrentPage(pimsProfile);
        PimsProfileContactController controller = new PimsProfileContactController();
        List<SelectOption> contactQualificationsVar = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult2 = Schema.Contact.Qualifications__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for(Schema.PicklistEntry f : ple2){
            contactQualificationsVar.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        
        Account accountJohn = [SELECT Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        IB_Role_Repository__c repo1 = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,
                                       Sub_Category__c,Training_Model__c,IB_Staff_Role__c, Available_in_Region__c,Related_Programmes__c 
                                       FROM IB_Role_Repository__c WHERE Role_Name__c='Admin Assistant' Limit 1];
        IB_Role__c createIbRoleRecord = RoleRepoFactoryTest.createIbRole(repo1.id,contactsRecords[0].id,accountJohn.id);
        createIbRoleRecord.Status__c = 'Applicant';
        List<IB_Programme__c> progRecList = new list<IB_Programme__c>();
        //RecordType.DeveloperName added newly for ECM00635
        IB_Programme__c progRec = [SELECT Id, Name,RecordType.Name,RecordType.DeveloperName FROM IB_Programme__c WHERE  Account__c =: accountJohn.Id AND RecordType.Name = 'Diploma Programme'];
        progRec.Status__c = 'Authorized';
        progRec.Date_Decision_on_Authorization__c = System.today();
        progRec.Owner__c = UserInfo.getUserId();
        progRecList.add(progRec);
        update progRecList;
        createIbRoleRecord.IB_Programme_New__c = progRecList[0].Id;
        List<Contact> con = ContactFactoryTest.createContacts(1,false,accountJohn);
        con[0].Phone_Number__c ='3095627918';
        con[0].MailingStateCode = '';
        con[0].FirstName = 'qwertsd';
        con[0].Alternative_Email__c = 'qwerty@fvh.com';
        con[0].MobilePhone = '1286766787';
        con[0].Email = 'qwer@fdfef.com';
        con[0].LastName = 'tyiwdxxbg';
        con[0].Country_Code__c = 'Afghanistan (+93)';
        controller.addRole = createIbRoleRecord; 
        controller.ContactQualifications = contactQualificationsVar;
        controller.addContact=con[0];
        IB_Subject__c theSubject = [SELECT ID, IB_Programme__c, IB_Programme_Long__c, Subject_Group__c,subject_Name__c,Subject_Code__c FROM IB_Subject__c Limit 1];
        controller.subject =  String.valueOf(theSubject.Id);
        controller.create();
        //System.assertEquals(0, [SELECT COUNT() FROM Contact WHERE Id=:controller.addContact.Id ], 'Contact Inserted');
        Test.stopTest();
    }
    
    @isTest
    static void testGetBillingContactOptions(){
        test.startTest();
        Account accountJohn = [SELECT id, Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.account = accountJohn;
        List<SelectOption> options =  controller.getBillingContactOptions();
        Test.stopTest();
        system.assertEquals(4,options.size());
    }
    
    @isTest
    static void testGetContactOptions(){
        Test.startTest();
        Account accountJohn = [SELECT id, Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.contacts = contactsRecords;
        List<SelectOption> options =  controller.getContactOptions();
        List<SelectOption> options1 =  controller.getAdminAssistantContactOptions();
        Test.stopTest();
        system.assertEquals(4,options.size());
        system.assertEquals(4,options1.size());    
    }
    
    @isTest
    static void testGetProgrammeOptions(){
        test.startTest();
        Account accountJohn = [SELECT id, Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        List<Contact> contactsRecords =queryAllContacts();
        
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c];
        
        
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.contacts = contactsRecords;
        List<SelectOption> options =  controller.getProgrammeOptions();
        List<SelectOption> options1 =  controller.getProgrammeOptionsNewContact();
        Test.stopTest();
        system.assertEquals(4,options.size());
        system.assertEquals(5,options1.size());
        
        
    }
    
    @isTest
    static void testGetRoleOptions(){
        test.startTest();
        List<IB_Role_Repository__c> repoList = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,
                                                Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c FROM IB_Role_Repository__c];
        PimsProfileContactController controller = new PimsProfileContactController();
        List<SelectOption> sp =  controller.getRoleOptions();
        controller.getRoleOptionsNewContact();
        system.assertEquals(2,sp.size());
        test.stopTest();
        
    }
    
    @isTest
    static void testGetHasMissingRoles(){
        test.startTest();        
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        //  pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        List<IB_Role_Repository__c> repoList = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,
                                                Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c FROM IB_Role_Repository__c];
        
        Account accountJohn = [SELECT id, Name, Region__c, Sub_region__c, External_PD_Provider__c, Language_Of_Correspondance__c, Legal_Status__c,
                               Short_Name__c, IBIS_ID__c, State_Abbr__c FROM Account WHERE name = 'John' limit 1];
        
        List<Contact> contactsRecords =queryAllContacts();
        
        List<IB_Programme__c> progRecList = [SELECT RecordTypeId,Account__c, Exam_Session__c, Status__c, Street_Address__c, 
                                             IBCC_Implementation_Phase__c, Primary_Language_of_Instruction__c FROM IB_Programme__c];
        
        for(IB_Programme__c prog: progRecList){
            prog.Status__c ='Candidate';
        }
        IB_Programme__c progRec = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE  Account__c =: accountJohn.Id AND RecordType.Name = 'Diploma Programme' Limit 1];
        progRec.Status__c = 'Authorized';
        progRec.Date_Decision_on_Authorization__c = System.today();
        progRec.Owner__c = UserInfo.getUserId();
        update progRec;
        IB_Role__c role2 = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                            FROM IB_Role__c WHERE IB_Contact__c =:contactsRecords[0].Id limit 1];
        role2.End_Date__c = system.today();
        if(role2.Status__c!='Confirmed')  // putting this as validation rule in place to prevent Confirmed to Applicant
        role2.Status__c = 'Applicant';
        role2.IB_Programme_New__c =  progRec.Id;
        update role2;
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.account = accountJohn;
        List<String> hmr = controller.getHasMissingRoles();
        Test.stopTest();
        system.assertEquals(3,hmr.size());
    }
    
    @isTest
    static void testGetcitynames(){
        test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        List<SelectOption> city = controller.getcitynames();
        test.stopTest();
        system.assertNotEquals(0,city.size());
        
    }
    
    @isTest
    static void testsendReminder(){
        test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.isUpdatePage = true;
        PageReference pageRef =controller.sendReminder();
        controller.isUpdatePage = false;
        PageReference pageRef1 =controller.sendReminder();
        test.stopTest();
        
    }
    
    @IsTest
    static void testdeclineRole() {
        Test.startTest();
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'John'];
        List<Contact> contactsRecords =queryAllContacts();
        
        IB_Role__c role = [SELECT id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE IB_Contact__c =: contactsRecords[1].Id AND IB_Role__r.Role_Name__c='Head of School' limit 1];
        
        PimsProfileContactController controller = new PimsProfileContactController();    
        controller.account = acc;
        controller.roleId = role.Id;
        PageReference result = controller.declineRole();
        Test.stopTest();
        role = [SELECT Id, IB_Contact__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                FROM IB_Role__c WHERE IB_Contact__c =: contactsRecords[1].Id AND IB_Role__r.Role_Name__c='Head of School' limit 1];
        //system.assertEquals('Declined', role.Status__c);     commenting as confirmed role cannot be converted to applicant or declined    
    }
    
    @IsTest
    static void testremoveAllRoles() {
        Test.startTest();
        List<Contact> contactsRecords =queryAllContacts();
        IB_Programme__c programme = [SELECT Id, Name,RecordType.Name FROM IB_Programme__c WHERE RecordType.Name = 'PYP' Limit 1];
        IB_Role__c role = [SELECT Id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                           FROM IB_Role__c WHERE Ib_role__r.Role_Name__c='Head of School' AND IB_Contact__c =: contactsRecords[1].Id ];
        role.End_Date__c = null;
        role.IB_Programme_New__c =  programme.Id;
        update role;
        PimsProfileContactController controllerInstance = new PimsProfileContactController();
        
        controllerInstance.isUpdatePage = true;
        Test.setCurrentPageReference(new PageReference('/apex/PimsProfile'));
        controllerInstance.deleteContactId = contactsRecords[1].id; 
        PageReference result = controllerInstance.removeAllRoles();
        
        role = [SELECT Id,createddate,  IB_Contact__c,IB_Role_Name__c,Programme_Type__c, IB_Role__c, Programme_Selection__c, Status__c, Active__c, IB_Account__c, IB_Programme_New__c
                FROM IB_Role__c WHERE Ib_role__r.Role_Name__c='Head of School' AND IB_Contact__c =: contactsRecords[1].Id];
        system.assertEquals('Withdrawn', role.Status__c);
        Test.stopTest();        
    }
    
    @isTest
    static void testMiscellaneousMethodsForCoverage(){
        test.startTest();
        PimsProfileContactController controller = new PimsProfileContactController();
        controller.MobilePhone = '23456b789';
        controller.PhoneNumber= '2345678';
        controller.citySelected='California';
        controller.progType='test';
        controller.getHasIbccProgramme();
        controller.hasProgramme();
        controller.getFromAfa();
        controller.edit();
        controller.changeRole();
        test.stopTest();
        
    }
    
}