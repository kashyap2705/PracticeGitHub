@isTest
private class PimsBatchReminderRolesTest {
    
    @testSetup
    static void setup() {
        
        Account acc = AccountTestDataFactory.createAccount(null, null);
		acc.Name = 'Test Account';
        insert acc;
        
        Contact con = ContactTestDataFactory.createContact(null, new Contact(AccountId = acc.Id, Email = 'abcd@prt.com'));
        insert con;

		Contact con2 = ContactTestDataFactory.createContact(null, new Contact(AccountId = acc.Id, Email = 'abc1d@prt.com'));
        insert con2;
         
        ContactMaxIBCode__c cmax= new ContactMaxIBCode__c();
        cmax.Name='MaxContactIBCode';
        cmax.MaxIBCode__c=100000;
        insert cmax;
        
        List<IB_Role_Repository__c> roleRepos = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c theRoleRepo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Head of School',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo1);
        
        IB_Role_Repository__c theRoleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Programme Coordinator',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo2);

		IB_Role_Repository__c theRoleRepo3 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Admin Assistant',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo3);
        
        insert roleRepos;
        
		IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = acc.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme(
            'MYP',
            new IB_Programme__c(
                Account__c = acc.Id,
                Contact_Head_of_School__c = con2.Id,
                Street_Address__c = address.Id
            )
        );
        insert prog;

        List<IB_Role__c> ibRoleList = new List<IB_Role__c>();
        
        IB_Role__c headOfSchoolRole1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Invited', 
                IB_Role__c = theRoleRepo1.Id,
                IB_Contact__c = con.Id,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today()
            ));
        ibRoleList.add(headOfSchoolRole1);
        
        IB_Role__c headOfSchoolRole2 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Confirmed',
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = con2.Id,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today()
            ));
        ibRoleList.add(headOfSchoolRole2);
        
        IB_Role__c headOfSchoolRole3 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Confirmed', 
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = con2.Id,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today()
            ));
        ibRoleList.add(headOfSchoolRole3);
        
        IB_Role__c headOfSchoolRole4 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Invited', 
                IB_Role__c = theRoleRepo3.Id,
                IB_Contact__c = con2.Id,
                Start_Date__c = Date.today(),
                End_Date__c = Date.today()
            ));
        ibRoleList.add(headOfSchoolRole4);
        
        insert ibRoleList;
        
        Test.setCreatedDate(headOfSchoolRole1.Id, System.now().addDays(-15));
        Test.setCreatedDate(headOfSchoolRole4.Id, System.now().addDays(-15));
    }
    
    @isTest
    static void testBatch() {
   
        List<IB_Role__c> roles = [select id, name ,IB_Contact__c, IB_Account__r.Name, IB_Contact__r.name, Programme_Type__c, Contact_name__c, Account_Name__c,
                                  IB_Contact__r.owner.Name, createddate ,status__c,IB_Role_Name__c,IB_Contact__r.Email, IB_Contact__r.Invitation_ID__c from IB_Role__c];
        
        Test.startTest();  
        PimsBatchReminderInvitedRoles reminderInvitedRoles = new PimsBatchReminderInvitedRoles();
        Id jobid= Database.executeBatch(reminderInvitedRoles,5);
        reminderInvitedRoles.execute(null, roles);
        Test.stopTest();    
        System.assertEquals(4, PimsBatchReminderInvitedRoles.listEmails.size(), 'Should have sent 4 emails');
    }
    
    @isTest
    public static void  testschedule() {
        
        Test.StartTest();
        PimsBatchReminderInvitedRolesScheduler sh1 = new PimsBatchReminderInvitedRolesScheduler();      
        String sch = '0 0 23 * * ?';
        String jobId = system.schedule('Test check', sch, sh1);
        Test.stopTest();
        List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(1, cronTriggers.size(), 'Should have one scheduled job');
    }
}