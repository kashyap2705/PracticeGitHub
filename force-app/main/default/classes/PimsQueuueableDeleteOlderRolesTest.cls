@isTest
private class PimsQueuueableDeleteOlderRolesTest {
   @testSetup
     static void test_method_one() {
         integer i =1;

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
          con.Email = 'abcd@prt.com';
          insert con;
         
          Contact con2 = PimsTestUtil.createContact('John Doe', 'b@b.com', 'b@b.com', Date.newInstance(1985, 6, 6), acc);
          con2.Email = 'abc1d@prt.com';
          insert con2;

          Set<Id> contactIds = new Set<Id>();
          contactIds.add(con.Id);
          contactIds.add(con2.Id);
         
         ContactMaxIBCode__c  cmax= new ContactMaxIBCode__c();
         cmax.Name='MaxContactIBCode';
         cmax.MaxIBCode__c=100000;
         insert cmax;
    
         
          //Insert Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Head of School');
        theRoleRepo1.Role_Type__c = 'School Role';
        theRoleRepo1.Permission_Set_Name__c = 'Head_of_School';
        insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        theRoleRepo2.Role_Type__c = 'School Role';
        theRoleRepo2.Permission_Set_Name__c = 'Programme_Coordinator';
        insert new List<IB_Role_Repository__c>{theRoleRepo2};
            
            
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Contact_Head_of_School__c=con2.id;
        prog.Status__c = 'Interested';
        insert new List<IB_Programme__c>{prog}; 
            
                     
            IB_Role__c headOfSchoolRole = PimsTestUtil.createIbRole(theRoleRepo1.Id, con.Id, acc.Id);
            headOfSchoolRole.Start_Date__c = Date.today();
            headOfSchoolRole.IB_Programme_New__c=prog.Id;
            headOfSchoolRole.End_Date__c = Date.today();
            headOfSchoolRole.Status__c='Declined'; 
         
         
         	IB_Role__c headOfSchoolRole1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con2.Id, acc.Id);
            headOfSchoolRole1.Start_Date__c = Date.today();
            headOfSchoolRole1.IB_Programme_New__c=prog.Id;
            headOfSchoolRole1.End_Date__c = Date.today();
            headOfSchoolRole1.Status__c='Declined'; 
         
           IB_Role__c headOfSchoolRole3 = PimsTestUtil.createIbRole(theRoleRepo2.Id, con2.Id, acc.Id);
            headOfSchoolRole3.Start_Date__c = Date.today();
            headOfSchoolRole3.IB_Programme_New__c=prog.Id;
            headOfSchoolRole3.End_Date__c = Date.today();
            headOfSchoolRole3.Status__c='Declined'; 
         	
            insert new List<IB_Role__c>{headOfSchoolRole,headOfSchoolRole1,headOfSchoolRole3};
            system.debug('headOfSchoolRole1***'+headOfSchoolRole1);
         	system.debug('headOfSchoolRole1***'+headOfSchoolRole3);
            system.debug('headOfSchoolRole***'+headOfSchoolRole);
            Test.setCreatedDate(headOfSchoolRole.Id, System.now().addDays(-100));
         
      }
    
    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        List<IB_Role__c> roles = [select id, name ,IB_Contact__c, createddate ,status__c,IB_Role_Name__c,IB_Contact__r.Email from IB_Role__c ];
        system.debug('roles in test Queuablle****'+roles);
        // Create our Queueable instance
        PimsQueuableDeleteOlderRoles accQObj = new PimsQueuableDeleteOlderRoles();
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(accQObj);
        Test.stopTest();        
        
    }
    
   
	@isTest
    public static void  testschedule() {
        Test.StartTest();
        DeleteOlderInvitedRolesSchedule sh1 = new DeleteOlderInvitedRolesSchedule();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();
    }



}