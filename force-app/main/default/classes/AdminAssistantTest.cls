/**
* @description - This is used to cover AdminAssistantHelper class.
*
* @author: Satyanarayana Gajavalli
* @since 21-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 21-10-2024      Modified            US-0002466       Modified the class
*/
@isTest
public class AdminAssistantTest {
    
    public static String Url = '/ibportal/IBPortalTriagePage?inviteid=';
    public static String Url2 = '/ibportal/roleRejectConfirmADAS?inviteid=';
    
    @testSetup static void setup() {
        
        IB_Role_Repository__c repo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(null);
        insert repo1;
        
        IB_Role_Repository__c roleRepo = new IB_Role_Repository__c();
        roleRepo.Role_Name__c = 'Head of School';
        
        IB_Role_Repository__c repo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepo);
        insert repo2;
        
        
        
       IB_Role_Repository__c roleRepoProgrammeCoordinator = new IB_Role_Repository__c();
        roleRepoProgrammeCoordinator.Role_Name__c = 'Programme Coordinator';
        
        IB_Role_Repository__c repo3 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(roleRepoProgrammeCoordinator);
        insert repo3;
        
        Account accOne = new Account();
        Account acc = AccountTestDataFactory.createAccount('School Account',accOne);
        insert acc;
        
        List<Contact> contactList = new List<Contact>();
        
        Contact conNew = new Contact();
        conNew.AccountId = acc.Id;        
        contactList = ContactTestDataFactory.createContacts(null,conNew,20);
        insert contactList;
        
        IB_Country_Segmentation__c ibConSeg = new IB_Country_Segmentation__c();
        ibConSeg.Name = 'United States';
        ibConSeg.Geographical_Sub_Region_Segmentation__c = 'Americas';
        ibConSeg.IBEN_Independent_Account__c = acc.Id;
        
        IB_Country_Segmentation__c ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibConSeg);
        insert ibCon;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = acc.Id;
        ibAdd.Country__c = ibCon.id;
        
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        IB_Programme__c ibProg = new IB_Programme__c();
        ibProg.Account__c = acc.Id;
        ibProg.Street_Address__c = address.id;
        ibProg.Owner__c = UserInfo.getUserId();
        
        IB_Programme__c programme = IBProgrammeTestDataFactory.createIBProgramme('PYP', ibProg);
        programme = PimsTestUtil.associateAddressWithProgramme(programme, address, 'billing');
        insert programme;
        
        List<IB_Role__c> rolesList = new List<IB_Role__c>();
        
        IB_Role__c ibRole = new IB_Role__c();
        ibRole.Status__c = 'Applicant';
        ibRole.IB_Programme_New__c = programme.Id;
        ibRole.IB_Contact__c = contactList[0].Id;
        ibRole.IB_Role__c = repo1.Id;
        ibRole.IB_Account__c = contactList[0].AccountId;
        ibRole.Programme_Selection__c='PYP';
        IB_Role__c roleApplicant = IBRoleTestDataFactory.createRole(ibRole);
        rolesList.add(roleApplicant);
        
        IB_Role__c ibRole2 = new IB_Role__c();
        ibRole2.Status__c = 'Confirmed';
        ibRole2.IB_Programme_New__c = programme.Id;
        ibRole2.IB_Contact__c = contactList[10].id;
        ibRole2.IB_Role__c = repo2.Id;
        ibRole2.IB_Account__c = contactList[10].AccountId;
        ibRole2.Programme_Selection__c='PYP';
        IB_Role__c roleAdmin = IBRoleTestDataFactory.createRole(ibRole2);
        rolesList.add(roleAdmin);
        
        
        IB_Role__c ibRole3 = new IB_Role__c();
        ibRole3.Status__c = 'Confirmed';
        ibRole3.IB_Programme_New__c = programme.Id;
        ibRole3.IB_Contact__c = contactList[9].id;
        ibRole3.IB_Role__c = repo3.Id;
        ibRole3.IB_Account__c = contactList[10].AccountId;
        ibRole3.Programme_Selection__c='PYP';
        IB_Role__c rolePC = IBRoleTestDataFactory.createRole(ibRole3);
        rolesList.add(rolePC);
        
        insert rolesList;
        
        IB_Subject__c ibsub = IBSubjectTestDataFactory.createSubject(null);
        insert ibsub;
        
        Role_Application_Subject__c roleAndAppSubject = new Role_Application_Subject__c(
            IB_Subject__c = ibsub.Id
        );
        insert roleAndAppSubject;
        
        List<User> usrList = new List<User>();
        
        User sysAdUser = new User();
        sysAdUser.UserName = 'test.sysadmin.123@test.com';
        sysAdUser.email = 'test.sysadmin.123@test.com';
        sysAdUser.IsActive = true;
        User usr = UserTestDataFactory.createUser(null,sysAdUser);
        usrList.add(usr);
        
        User commUser = new User();
        commUser.username = 'test.pims.123@ibo.org';
        commUser.email = 'test.pims.123@ibo.org';
        commUser.contactId = contactList[0].Id;
        commUser.IsActive = true;
        User communityUser = UserTestDataFactory.createUser('SCU + Advanced',commUser);
        usrList.add(communityUser);
        
        insert usrList;
    }
    
    @isTest
    public static void testSendEmailADASNewCont() {
        
        User usr = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'System Administrator') AND isActive = true LIMIT 1];
        System.runAs(usr){
            
            List<Contact> tempcont = [Select id, Email, Invitation_ID__c, CreatedById, OwnerId, Salutation, firstname, lastname, Name, Account.Name from Contact Limit 1];
            List<IB_Role__c> temprol = [Select id, IB_Contact__r.id, IB_Contact__r.Email, IB_Role_Name__c, IB_Role_Name_fr__c, IB_Role_Name_es__c, 
                                        Contact_name__c, Account_Name__c from IB_Role__c limit 2];
            
            Integer initialEmailInvocations = Limits.getEmailInvocations();
            
            for(IB_Role__c ADSrole:temprol){
                AdminAssistantHelper.sendEmailToADASReminder(url,url2,ADSrole);
                AdminAssistantHelper.sendEmailToADASNewInvitee(url,url2,ADSrole);
                AdminAssistantHelper.sendEmailToPCADASAccept(ADSrole,tempcont[0]);
            }
            Test.startTest();
            AdminAssistantHelper.sendEmailToAdminAssistantforInvitation(temprol);
            Test.stopTest();
            
            Integer emailsSent = Limits.getEmailInvocations() - initialEmailInvocations;
            System.assert(emailsSent > 0, 'Expected at least one email to be sent, but none were sent.');
            System.assertEquals(6, emailsSent, 'Expected exactly 6 emails to be sent, but a different number was sent.');
        }
    }
    
    @isTest
    public static void testMyIBRolesController() {
        
        Test.startTest();
        User usr = [Select id, FirstName, LastName,ContactId, Username from User where Username = 'test.pims.123@ibo.org' Limit 1];
        List<IB_Role__c> temprol = [Select id,Status__c, IB_Contact__r.Email,IB_Role__c,IB_Role_Name__c, IB_Role_Name_fr__c, IB_Role_Name_es__c, Contact_name__c, Account_Name__c from IB_Role__c Limit 2];
        MyIBRolesController controller = new MyIBRolesController();
        
        System.runAs(usr){
            MyIBRolesController.adasAcceptDocId = temprol[0].id;
            PageReference resultAccept = controller.adasAcceptRecord();
            
            System.assertNotEquals(null, resultAccept, 'Expected ADASAcceptRecord to return a valid PageReference.');
            IB_Role__c updatedRole = [SELECT Status__c FROM IB_Role__c WHERE Id = :temprol[0].Id];
            System.assertEquals('Confirmed', updatedRole.Status__c, 'Expected the Status__c of the role to be updated to "Confirmed".');
            
            MyIBRolesController.adasRejectDocId = temprol[1].id;
            PageReference resultReject = controller.adasRejectRecord();
            System.assertNotEquals(null, resultReject, 'Expected ADASRejectRecord to return a valid PageReference.');
            System.assertEquals(temprol[1].IB_Contact__c, resultReject.getParameters().get('inviteidIBRole'), 'Expected the inviteidIBRole parameter to match the contact ID of the role.');
            System.assertEquals(temprol[1].Id, resultReject.getParameters().get('inviteidIBRoleID'), 'Expected the inviteidIBRoleID parameter to match the role ID.');
            
            MyIBRolesController.adasAcceptDocId = Null;
            MyIBRolesController.adasRejectDocId = Null;
            
            PageReference nullResultAccept = controller.adasAcceptRecord();
            PageReference nullResultReject = controller.adasRejectRecord();
            
            System.assertEquals(null, nullResultAccept, 'Expected ADASAcceptRecord to return null for a null ID.');
            System.assertEquals(null, nullResultReject, 'Expected ADASRejectRecord to return null for a null ID.');
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testProfileUpdateController() {
        
        User usrAdmin = [SELECT Id, ProfileId FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'System Administrator') AND isActive = true LIMIT 1];
        
        User usr = [Select id, ProfileId, FirstName, LastName, ContactId, Username from User where Username = 'test.sysadmin.123@test.com' Limit 1];
        
        Profile newProfile = [SELECT Id FROM Profile WHERE Name = 'System Admin IBEN' LIMIT 1];
        PageReference MyIBRoles = Page.MyIBRoles;
        Test.setCurrentPage(MyIBRoles);
        MyIBRoles.getParameters().put('userId',usr.Id);
        MyIBRoles.getParameters().put('profileId',newProfile.Id);
        
        ProfileUpdateController controller = new ProfileUpdateController();
        
        System.runAs(usrAdmin){
            Test.startTest();
            controller.doProfileUpdate();   
            Test.stopTest();
        }      
        
        User updatedUser = [SELECT ProfileId FROM User WHERE Id = :usr.Id];
        System.assertEquals(newProfile.Id, updatedUser.ProfileId, 'Profile ID should be updated to the target profile.');
    }
    
    @isTest
    public static void testRoleRejectConfirmADASCtrl() {
          Test.startTest();
        User adminUser = [SELECT Id FROM User WHERE profileId IN (SELECT id FROM Profile WHERE Name = 'System Administrator') AND isActive = true LIMIT 1];
        List<IB_Role__c> temprol = [Select id,Status__c,IB_Contact__r.id,Email__c,Programme_Selection__c,IB_Account__c, IB_Contact__r.Email,IB_Role_Name__c, 
                                    IB_Role_Name_fr__c, IB_Role_Name_es__c, Contact_name__c, Account_Name__c,IB_Account__r.Name,IB_Contact__r.name from IB_Role__c where 
                                    IB_Role_Name__c = 'Head of School' Limit 1];
        temprol[0].Status__c = 'Invited';
        update temprol;
        
        List<Contact> con = [Select id, Email, OwnerId, User_Language__c, Salutation, firstname, lastname, Name, Account.Name from Contact where id =:temprol[0].IB_Contact__r.id Limit 1];  
        Blob targetBlob = Blob.valueOf(con[0].FirstName + con[0].LastName + String.valueOf(DateTime.now()));
        Blob hash = Crypto.generateDigest('SHA256', targetBlob);
        con[0].Invitation_ID__c = EncodingUtil.convertToHex(hash);
        update con;
        
        PageReference roleRejectConfirmADAS = Page.roleRejectConfirmADAS;
        Test.setCurrentPage(roleRejectConfirmADAS);
        roleRejectConfirmADAS.getParameters().put('inviteid',con[0].Invitation_ID__c);
        roleRejectConfirmADAS.getParameters().put('invitationIDIBRoleID',temprol[0].id);
        roleRejectConfirmADASCtrl controller = new roleRejectConfirmADASCtrl();
        
        System.runAs(adminUser){
          
            controller.invitationContact = con[0];
            controller.invitationID = con[0].id;
            controller.invitationIDIBRoleID = temprol[0].id;
            controller.removeRecord();
            controller.getLocale();
            
            controller.sendEmailToProgrameCoordinator(temprol[0],'en_US');
                
            IB_Role__c updatedRole = [SELECT Status__c FROM IB_Role__c WHERE Id = :temprol[0].Id];
            System.assertEquals('Invited', updatedRole.Status__c, 'The status should be updated to the expected value.');
            con[0].User_Language__c = 'fr';
            
            update con[0];Contact updatedContact = [SELECT User_Language__c FROM Contact WHERE Id = :con[0].Id];
            System.assertEquals('fr', updatedContact.User_Language__c, 'The Contact language should be updated to French.');
            
            PageReference roleRejectConfirmADASfr = Page.roleRejectConfirmADAS;
        Test.setCurrentPage(roleRejectConfirmADASfr);
        roleRejectConfirmADASfr.getParameters().put('inviteid',con[0].Invitation_ID__c);
        roleRejectConfirmADASfr.getParameters().put('invitationIDIBRoleID',temprol[0].id);
        roleRejectConfirmADASCtrl controller1 = new roleRejectConfirmADASCtrl();
            
            Test.stopTest();
        }       
    }
}