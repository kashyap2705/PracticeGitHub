@isTest
public class WithdrawRolesBatchTest {
    public static String CRON_EXP = '0 0 0 14 8 ? 2040';
    @isTest
    static Void testScenarios(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Insert acc;  
        
        Contact con = PimsTestUtil.createContact('Jones', 'jone@home.com', 'jone@prof.com', Date.newInstance(1984, 09, 14), acc);
        Insert con;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Terminated';
        Insert prog;
        
        IB_Role_Repository__c rr = PimsTestUtil.createRoleRepo('Programme Coordinator');
        Insert rr; 
        List<IB_Role__c> rolesList = new List<IB_Role__c>();
        
        
        IB_Role__c rl =  new IB_Role__c(
            IB_Contact__c = con.Id,
            IB_Role__c = rr.id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            IB_Programme_New__c =prog.Id,
            Status__c='Confirmed',
            Active__c = true,
            Start_Date__c = Date.today(),
            IB_Account__c = acc.Id
        ); 
        
        rolesList.add(rl);
        
        
        Insert rolesList;
        
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',CRON_EXP, new ScheduleWithdrawRolesBatch());    
        Test.stopTest();  
        
    }
    //ECM00774 start
    @isTest
    static Void testScenariosTerminateProg(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Insert acc;  
        
        Contact con = PimsTestUtil.createContact('Jones', 'jone@home.com', 'jone@prof.com', Date.newInstance(1984, 09, 14), acc);
        Insert con;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Terminated';
        Insert prog;
        
        IB_Role_Repository__c rr = PimsTestUtil.createRoleRepo('Programme Coordinator');
        Insert rr; 
        List<IB_Role__c> rolesList = new List<IB_Role__c>();
        
        
        IB_Role__c rl =  new IB_Role__c(
            IB_Contact__c = con.Id,
            IB_Role__c = rr.id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            IB_Programme_New__c =prog.Id,
            Status__c='Confirmed',
            Active__c = true,
            Start_Date__c = Date.today(),
            IB_Account__c = acc.Id
        ); 
        
        rolesList.add(rl);
        
        
        Insert rolesList;
        
        Test.startTest();
        Database.executeBatch(new WithdrawRolesBatch(new Set<Id>{prog.Id}), 5);
        Test.stopTest();  
        
    }
    @isTest
    static Void testScenariosTerminateProgWithAccount(){
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        Insert acc;  
        
        Contact con = PimsTestUtil.createContact('Jones', 'jone@home.com', 'jone@prof.com', Date.newInstance(1984, 09, 14), acc);
        Insert con;
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Terminated';
        Insert prog;
        
        IB_Role_Repository__c rr = PimsTestUtil.createRoleRepo('Programme Coordinator');
        Insert rr; 
        List<IB_Role__c> rolesList = new List<IB_Role__c>();
        
        
        IB_Role__c rl =  new IB_Role__c(
            IB_Contact__c = con.Id,
            IB_Role__c = rr.id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            IB_Programme_New__c =prog.Id,
            Status__c='Confirmed',
            Active__c = true,
            Start_Date__c = Date.today(),
            IB_Account__c = acc.Id
        ); 
        
        rolesList.add(rl);
        
        
        Insert rolesList;
        
        Test.startTest();
        Map<Id,Boolean> mapAccBool = new Map<Id,Boolean>{ acc.Id => true };
        Database.executeBatch(new WithdrawRolesBatch(new Set<Id>{prog.Id},mapAccBool), 5);
        Test.stopTest();  
        
    }
    //ECM00774 end
}