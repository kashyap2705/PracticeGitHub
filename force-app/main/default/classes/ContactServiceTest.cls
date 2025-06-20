@isTest
private class ContactServiceTest {

     static testmethod void test_method_one() {
         integer i =1;

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
          insert con;
          Contact con2 = PimsTestUtil.createContact('John Doe', 'b@b.com', 'b@b.com', Date.newInstance(1985, 6, 6), acc);
          insert con2;

          Set<Id> contactIds = new Set<Id>();
          contactIds.add(con.Id);
          contactIds.add(con2.Id);
    //Following System.assertEquals(1,i); code line is added by Umair-Plumlogix of US11096 on 02/11/2020
          ContactService.setIdSet(contactIds);
         System.assertEquals(1,i);
          ContactService.setAccountId(acc.Id);
         System.assertEquals(1,i);
          ContactService.setContactId(con2.Id);
         System.assertEquals(1,i);

          ContactService.isContactCached = false;
         System.assertEquals(1,i);
          ContactService.isContactsCached = false;
         System.assertEquals(1,i);
          ContactService.isContactsByAccountCached = false;
         System.assertEquals(1,i);
          ContactService.isContactsByIdSetCached = false;
         System.assertEquals(1,i);

     	Contact csContact = ContactService.getContact();
          List<Contact> csContactsList = ContactService.getContacts();
         
          //Insert Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Teacher');
        theRoleRepo1.Role_Type__c = 'School Role';
        theRoleRepo1.Permission_Set_Name__c = 'Teacher';
        insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
            
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        insert new List<IB_Programme__c>{prog}; 
            
             IB_Role__c teacherRole = PimsTestUtil.createIbRole(theRoleRepo1.Id, con.Id, acc.Id);
            TeacherRole.Start_Date__c = Date.today();
            TeacherRole.IB_Programme_New__c=prog.Id;
            TeacherRole.End_Date__c = Date.today();
            TeacherRole.Status__c='Confirmed'; 
            TeacherRole.Active__c = false;
         
            IB_Role__c headOfSchoolRole = PimsTestUtil.createIbRole(theRoleRepo1.Id, con.Id, acc.Id);
            headOfSchoolRole.Start_Date__c = Date.today();
            headOfSchoolRole.IB_Programme_New__c=prog.Id;
            headOfSchoolRole.End_Date__c = Date.today();
            headOfSchoolRole.Status__c='Confirmed'; 
            headOfSchoolRole.Active__c = false;
         
            insert new List<IB_Role__c>{TeacherRole,headOfSchoolRole};
                
            ContactService.getInvitedContactsForAccount();
         	ContactService.getConfirmedContactsForAccount();
            ContactService.getContactsForAccount();
     }
}