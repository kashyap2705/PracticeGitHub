/*******************************************************************************************
* @Name     IBPortalTriagePageCtrlTest
* @Author       
* @Date         
* @Group        
* @Description  This is test class for IBPortalTriagePageCtrl
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/30/2023         Added assertions in the test method
*******************************************************************************************/
@isTest
private class IBPortalTriagePageCtrlTest {
    static testMethod void Test1() {  
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        PortalUserInfo__c portalUserInfo = new PortalUserInfo__c();
        portalUserInfo.Name = 'IbenPublicPortal';
        portalUserInfo.ProfileId__c = '00e20000001ApEj';
        
        insert portalUserInfo;
        
        List<IB_Country_Segmentation__c> countries = new List<IB_Country_Segmentation__c>();
        IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        countries.add(country);
        country = null;
        country = TestsUtil.createCountryLanguages('testname', 'testnameFR', 'testnameES', acc);
        country.IBEN_Independent_Account__c = acc.Id;
        countries.add(country);
        insert countries;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), countries[0]);
        cont.AccountId = acc.Id;
        cont.Phone = '13861234567';
        //cont.Invitation_ID__c = 'test123';
        //insert cont;
        
        Contact cont2 = TestsUtil.createContact('test_name_002', 'xxx1@xxx.com', 'axxx2@xxx.com', Date.today().addYears(-20), countries[0]);
        cont2.AccountId = acc.Id;
        cont2.Phone = '138612345678';
        //cont.Invitation_ID__c = 'test321';
        //    insert cont2;
        insert new List<contact>{cont,cont2};
            Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
                            EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');
        
        usr.Bypass_Validation_Rules__c = true;
        
        insert usr;
        
        IB_Role_Repository__c tmpRepo = TestsUtil.createRoleRepo();
        tmpRepo.Role_Name__c = 'Programme Coordinator';
        //   insert tmpRepo;
        
        IB_Role_Repository__c tmpRepo2 = TestsUtil.createRoleRepo();
        tmpRepo2.Role_Name__c = 'Billing Contact';
        //  insert tmpRepo2;
        
        insert new List<IB_Role_Repository__c>{tmpRepo,tmpRepo2};
            IB_Address__c tmpAdd = new IB_Address__c(
                Name = 'STRUNK',
                IB_Account__c = acc.Id,
                Address_Line_1__c = 'Test',
                City__c = 'Test city',
                Postal_Code__c = '12345'
            );
        insert tmpAdd;
        
        IB_Programme__c tmpProg = new IB_Programme__c(
            Exam_Session__c = 'STRUNK',
            Primary_Language_of_Instruction__c = 'English',
            Status__c = 'Invited',
            Street_Address__c = tmpAdd.Id,
            IBCC_Implementation_Phase__c = 'Phase 1',
            Account__c = acc.Id
        );
        insert tmpProg;
        
        test.startTest();
        
        List<IB_Role__c> listRoles = new List<IB_Role__c>();
        
        IB_Role__c tmpRole = TestsUtil.createIbRole(tmpRepo.Id, cont.Id);
        tmpRole.IB_Programme_New__c = tmpProg.Id;
        tmpRole.IB_Account__c = acc.Id;
        tmpRole.Status__c = 'Invited';
        listRoles.add(tmpRole);
        
        IB_Role__c tmpRole2 = TestsUtil.createIbRole(tmpRepo2.Id, cont2.Id);
        tmpRole2.IB_Programme_New__c = tmpProg.Id;
        tmpRole2.IB_Account__c = acc.Id;
        tmpRole2.Status__c = 'Invited';
        listRoles.add(tmpRole2);
        
        insert listRoles;
        
        
        List<Contact> listContacts = [select Id,FirstName,LastName,AccountId,Email,Salutation from Contact limit 1];
        Blob targetBlob = Blob.valueOf(listContacts[0].FirstName + listContacts[0].LastName + String.valueOf(DateTime.now()));
        Blob hash = Crypto.generateDigest('SHA256', targetBlob);
        listContacts[0].Invitation_ID__c = EncodingUtil.convertToHex(hash);
        update listContacts;
        
        System.RunAs(usr){  
                          
            PageReference pageRef = Page.IBPortalTriagePage;
            test.setCurrentPageReference(pageRef);
            pageRef.getParameters().put('inviteid',listContacts[0].Invitation_ID__c);            
            IBPortalTriagePageCtrl cs= new IBPortalTriagePageCtrl();
            cs.init(listContacts[0]);
            cs.closeSessions();
            cs.getLocale();
            test.stopTest();  
            
            system.assertEquals(false, cs.withDrawnInviteId);
        }  
    }  
}