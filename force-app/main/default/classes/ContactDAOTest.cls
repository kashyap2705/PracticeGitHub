@isTest
private class ContactDAOTest {
    
    @isTest static void test_method_one() {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        ContactDAO conDAO = ContactDAO.getInstance();
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        insert acc;
        
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        insert con;
        
        Contact con2 = PimsTestUtil.createContact('Contact Test', 'b@b.com', 'b@b.com', Date.newInstance(1980, 5, 30), acc);
        insert con2;
        
        Contact conByUserId = conDAO.getContactByUserId(con.Id);
        
        List<Contact> conByAccountId = conDAO.getContactsByAccountId(acc.Id);
        //INC0214000 Benjamin McGarvey, needed a way to get related contacts due to HOS/PC role that arent directly linked
        List<Contact> conByAccountId2 = conDAO.GetContactsByAccountHOSPCNoDirectRelation(acc.id);
        system.debug(loggingLevel.ERROR,conByAccountId.size());
        
        system.assertEquals(conByAccountId.size(), 2);
        
        
        Set<ID> contactSet = new Set<ID>();
        contactSet.add(con.Id);
        contactSet.add(con2.Id);
        
        List<Contact> conByContactIdList = conDAO.getContactsByContactIdList(contactSet);
        List<Contact> conByNameAndAccount = conDAO.searchContactsByNameAndAccount('Contact',acc.Id);
        List<Contact> conByContactIdListAndAccount = conDAO.getContactsByContactIdList(contactSet, acc.Id);
        
        
        system.assertEquals(conByContactIdList.size(), 2);
        system.assertEquals(conByNameAndAccount.size(), 2);
        
        
    }
    
    @isTest static void test_method_two() {
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        ContactDAO conDAO = ContactDAO.getInstance();
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        insert acc;
        
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        insert con;
        
        Contact con2 = PimsTestUtil.createContact('Contact Test', 'b@b.com', 'b@b.com', Date.newInstance(1980, 5, 30), acc);
        insert con2;
        
        Set<ID> contactSet = new Set<ID>();
        id failID = acc.id;
		Contact conByContactId = conDAO.getContactByUserId(failID);        
    }
}