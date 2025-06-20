@IsTest
private class UpdateContactIBISIDBatchTest {
    
    @testSetup static void setup() {
        // Create the custom setting with an initial value
        ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Invited Contact').getRecordTypeId();
        
        Account acc = PimsTestUtil.createAccount('IBEN Test', 'School Account');
        insert acc; 
        
        // Insert contacts for the test
        List<Contact> testContactList = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact c = new Contact(
                FirstName = 'TestContact',
                LastName = 'Test' + i,
                Email = 'test' + i + '@home.com',
                RecordTypeId = ContactRecordTypeId,
                AccountId = acc.Id
            );
            testContactList.add(c);
        }
        insert testContactList;
        
        List<IB_Role_Repository__c> roleRepoList = new List<IB_Role_Repository__c>();
        
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        roleRepoList.add(theRoleRepo1);
        
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Teacher');
        theRoleRepo2.Role_Type__c = 'School Role';
        theRoleRepo2.Permission_Set_Name__c = 'Teacher';
        roleRepoList.add(theRoleRepo2);
        
        insert roleRepoList;
        
        // Insert Confirmed Roles for Contacts
        List<IB_Role__c> roleList = new List<IB_Role__c>();
        for (Contact con : testContactList) {
            IB_Role__c role = new IB_Role__c(
                IB_Contact__c = con.Id,
                IB_Account__c = acc.Id,
                Status__c = 'Confirmed'
            );
            roleList.add(role);
        }
        insert roleList;
        
        Profile p = [select Id,name from Profile where name='SCU + Basic' limit 1];

        // Create active users linked to some of the contacts
        List<User> users = new List<User>();
        for (Integer i = 0; i < 5; i++) { // Only linking 5 out of 10 contacts
            User u = new User(
                ProfileId = p.id,
                alias = 'welcome',
                Username = 'user' + i + '@test.com',
                LastName = 'TestUser' + i,
                Email = 'user' + i + '@test.com',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ContactId = testContactList[i].Id,
                IsActive = true
                                 );  
            users.add(u);
        }
        insert users;
    }

    @IsTest
    static void testExecute() {
        
        Test.startTest();
    
        UpdateContactIBISIDBatch batch = new UpdateContactIBISIDBatch();
        Database.executeBatch(batch, 100);
        
        Test.stopTest();
    }
}