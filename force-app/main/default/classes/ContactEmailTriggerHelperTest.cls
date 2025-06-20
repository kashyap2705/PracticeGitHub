@isTest
private class ContactEmailTriggerHelperTest {
    @isTest
     static void testContactEmailTriggerHelperMethod1() {
        
        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        ContactEmail__c mail1 = new ContactEmail__c(
            Contact__c = theContact.Id,
            Account__c = theAccount.Id,
            EmailAddress__c = 'email@email.com'
        );
        
        List<ContactEmail__c> mailList = new List<ContactEmail__c>{mail1};
        insert mailList;
         
        IB_Role_Repository__c repo1 = PimsTestUtil.createRoleRepo('Head of School');
        insert repo1;
         
        IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(theAccount, 'PYP');
        insert programme; 
        
        IB_Role__c role1 = PimsTestUtil.createIbRole(repo1.Id, theContact.id, theAccount.id);
        role1.IB_Programme_New__c = programme.Id;
        insert role1;
         
        ContactEmailTriggerHelper.setProgrammeDefaultRoleEmails(mailList);
        ContactEmailTriggerHelper.deleteProgrammeDefaultRoleEmails(mailList);
        
    }
    @isTest
     static void testContactEmailTriggerHelperMethod2() {
        
        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        ContactEmail__c mail1 = new ContactEmail__c(
            Contact__c = theContact.Id,
            Account__c = theAccount.Id,
            EmailAddress__c = 'email@email.com'
        );
        
        List<ContactEmail__c> mailList = new List<ContactEmail__c>{mail1};
        insert mailList;
         
        IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert repo2;
         
        IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(theAccount, 'PYP');
        insert programme; 
        
        IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, theContact.id, theAccount.id);
        role2.IB_Programme_New__c = programme.Id;

        insert role2; 
         
        ContactEmailTriggerHelper.setProgrammeDefaultRoleEmails(mailList);
        ContactEmailTriggerHelper.deleteProgrammeDefaultRoleEmails(mailList);
        
    }
    
        @isTest
     static void testContactEmailTriggerHelperMethod3() {
        
        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        ContactEmail__c mail1 = new ContactEmail__c(
            Contact__c = theContact.Id,
            Account__c = theAccount.Id,
            EmailAddress__c = 'email@email.com'
        );
        
        List<ContactEmail__c> mailList = new List<ContactEmail__c>{mail1};
        insert mailList;
         
        IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Contact');
        insert repo3;
         
        IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(theAccount, 'PYP');
        insert programme; 
        
        IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, theContact.id, theAccount.id);
        role3.IB_Programme_New__c = programme.Id;

        insert role3; 
         
        ContactEmailTriggerHelper.setProgrammeDefaultRoleEmails(mailList);
        ContactEmailTriggerHelper.deleteProgrammeDefaultRoleEmails(mailList);
        
    }
}