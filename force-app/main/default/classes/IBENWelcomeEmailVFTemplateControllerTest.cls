@isTest
public class IBENWelcomeEmailVFTemplateControllerTest {
    @isTest static void testMethod1() 
    {
        try
        {
            
            Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
            insert theAccount;
            
            Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            insert theContact;
            
            List<Contact> currContacts = new List<Contact>();
            currContacts.add(theContact);
            
            IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
            insert theProgramme;
            
           
            
            IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
            insert theRoleRepo;
            
            IB_Role__c theRole = new IB_Role__c(
                IB_Role__c = theRoleRepo.Id,
                IB_Programme_New__c = theProgramme.Id,
                IB_Account__c = theAccount.Id,
                IB_Contact__c = theContact.Id
            );
            insert theRole;
            
            List<IB_Role__c> currRoles = new List<IB_Role__c>();
            currRoles.add(theRole);
            
            Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
            User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias = 'cspu', lastname = 'lastname');
            insert pu;
            
            Test.startTest();
            
            System.runAs(pu) {
                IBENWelcomeEmailVFTemplateController inst = new IBENWelcomeEmailVFTemplateController();
				inst.getUserId();
                inst.setUserId(pu.Id);
                
                
            }
            Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
        
    }
    
    @isTest static void testMethod2() 
    {
        try
        {
            
            Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
            insert theAccount;
            
            Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            insert theContact;
            
            List<Contact> currContacts = new List<Contact>();
            currContacts.add(theContact);
            
            IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
            insert theProgramme;
            
            IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
            insert theRoleRepo;
            
            IB_Role__c theRole = new IB_Role__c(
                IB_Role__c = theRoleRepo.Id,
                IB_Programme_New__c = theProgramme.Id,
                IB_Account__c = theAccount.Id,
                IB_Contact__c = theContact.Id
            );
            insert theRole;
            
            List<IB_Role__c> currRoles = new List<IB_Role__c>();
            currRoles.add(theRole);
            
            Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
            User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias = 'cspu', lastname = 'lastname');
            insert pu;
            
            Test.startTest();
            
            System.runAs(pu) {
                IBENWelcomeEmailVFTemplateController inst = new IBENWelcomeEmailVFTemplateController();
                inst.setuserLanguage('English');
                inst.getuserLanguage();
                inst.findIBCode();
                
                
            }
            Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
        
    }

	@isTest static void testMethod3() 
    {
        try
        {
            
            Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
            insert theAccount;
            
            Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            insert theContact;
            
            List<Contact> currContacts = new List<Contact>();
            currContacts.add(theContact);
            
            IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
            insert theProgramme;
            
            
            IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
            insert theRoleRepo;
            
            IB_Role__c theRole = new IB_Role__c(
                IB_Role__c = theRoleRepo.Id,
                IB_Programme_New__c = theProgramme.Id,
                IB_Account__c = theAccount.Id,
                IB_Contact__c = theContact.Id
            );
            insert theRole;
            
            List<IB_Role__c> currRoles = new List<IB_Role__c>();
            currRoles.add(theRole);
            
            Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
            User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias = 'cspu', lastname = 'lastname');
            insert pu;
            
            Test.startTest();
            
            System.runAs(pu) {
                IBENWelcomeEmailVFTemplateController inst = new IBENWelcomeEmailVFTemplateController();
                inst.setisUserSetup(true);
                inst.getisUserSetup();
                
                
            }
            Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
        
    }

	
	@isTest static void testMethod4() 
    {
        try
        {
            
            Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
            insert theAccount;
            
            Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            insert theContact;
            
            List<Contact> currContacts = new List<Contact>();
            currContacts.add(theContact);
            
            IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
            insert theProgramme;
            
            IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
            insert theRoleRepo;
            
            IB_Role__c theRole = new IB_Role__c(
                IB_Role__c = theRoleRepo.Id,
                IB_Programme_New__c = theProgramme.Id,
                IB_Account__c = theAccount.Id,
                IB_Contact__c = theContact.Id
            );
            insert theRole;
            
            List<IB_Role__c> currRoles = new List<IB_Role__c>();
            currRoles.add(theRole);
            
            Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
            User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               alias = 'cspu', lastname = 'lastname');
            insert pu;
            
            Test.startTest();
            
            System.runAs(pu) {
                IBENWelcomeEmailVFTemplateController inst = new IBENWelcomeEmailVFTemplateController();
                inst.firstName = 'testfirstname';
				inst.lastName = 'testlastname';
				inst.roleName = 'testrolename';
                
            }
            Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
        
    }
    
}