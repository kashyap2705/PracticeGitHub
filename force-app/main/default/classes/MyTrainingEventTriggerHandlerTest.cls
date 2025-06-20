@isTest
public class MyTrainingEventTriggerHandlerTest {

    
   /* @isTest
    public static void testInsert(){
        Test.startTest();
        init();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        Contact cont = TestsUtil.getContacts().get(0);

        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        insert myTrainingEvent;
        
        System.assert(trEvent.Id != null, 'Role Must be Inserted');
        Test.stopTest();
    }*/
    
    
    @isTest
    public static void testInsertWithNoRelatedTrainigEvent(){
        Test.startTest();
        init();
        
        Contact cont = TestsUtil.getContacts().get(0);
        
        //no training event specified
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, null);

        try {
            
            insert myTrainingEvent;
            myTrainingEvent.Release_Permission_Requested__c = true;
            update myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    
    
    @isTest
    public static void testUpdateWhenRoleHasStatusDeclined(){
        
        init();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        Contact cont = TestsUtil.getContacts().get(0);
        IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        Test.startTest();
        role.Status__c = 'Declined';
        update role;
        
        try {
            MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
            update myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
            System.assert(e.getMessage().contains( Label.Declined_Role_Application ));
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testMultipleRoles(){
        
        init();

        initMoreRoleRepos();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        Contact cont = TestsUtil.getContacts().get(0);
        IB_Role__c role1 = TestsUtil.getIbRoles().get(0);
        

        Account acc = TestsUtil.createAccount('twretwretr');
        acc.IBIS_ID__c = '202020';
        insert acc;
        IB_Country_Segmentation__c country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        insert country;
    
        
        /*IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Programme Coordinator3','Shadow','School Services','Evaluation & Authorization');
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Programme Coordinator4','Shadow','Assessment','Workshops');
        IB_Role_Repository__c repo3 = TestsUtil.createRoleRepoWithParams('Programme Coordinator5','Shadow','Professional Development','Management');
        insert new List<IB_Role_Repository__c>{repo1,repo2,repo3};*/
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        
        try {
            
        //test.startTest();
        myTrainingEvent.IB_Role__c = repos[0].id;
        myTrainingEvent.IB_Role_2__c = repos[1].id;
        myTrainingEvent.IB_Role_3__c = repos[2].id;
        
        
        myTrainingEvent.Application_Status__c = 'Confirmed';
        myTrainingEvent.Level_of_Interest__c = 'Interested';
        myTrainingEvent.Release_Permission_Required__c = 'No';
        myTrainingEvent.Invitation_Response__c = 'Accepted';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        myTrainingEvent.Application_Status__c = 'Completed';
        myTrainingEvent.Training_Result__c = 'Passed';
        myTrainingEvent.Role_Level__c = 'Fully Qualified';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        //test.stopTest();

        /*role.Status__c = 'Declined';
        update role;*/
        
        
            
            //update myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
            System.assert(e.getMessage().contains( Label.Declined_Role_Application ));
        }
        
    }

    /*@isTest
    public static void testUpdateWhenRoleHasStatusConfirmed(){
        
        init();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        Contact cont = TestsUtil.getContacts().get(0);
        IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        insert myTrainingEvent;
        
        role.Status__c = 'Confirmed';
        role.Role_Level__c = 'Fully Qualified';
        role.Active__c = true;
        update role;
        Test.startTest();
        try {
            
            update myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
            System.assert(e.getMessage().contains( Label.Confirmed_Role_Application ));
        }
        Test.stopTest();
    }*/
    
        
    @isTest
    public static void testUpdateIfIbRoleStatusUnregistered(){
        init();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        Contact cont = TestsUtil.getContacts().get(0);
        IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        
        role.Status__c = 'Unregistered';
        update role;
        
        try {
            MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
            update myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
            System.assert(e.getMessage().contains( Label.Unregistered_Role_Application ));
        }
    }
        
        
    @isTest
    public static void testInsertWithNoContact(){
        init();
        
        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);

        // no contactId specified
        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', null, trEvent.Id);
        
        try {
            
            insert myTrainingEvent;
            
        } catch (Exception e) {
            System.debug('>>>> ' + e.getMessage());
           // System.assert(e.getMessage().contains( Label.No_Role_Application ));
        }       
    }   

        
        
    @isTest
    public static void testUpdateSetTrainingResultToPassed(){

        init();

        initMoreRoleRepos();

        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        Contact cont = TestsUtil.getContacts().get(0);

        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        

        /*IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Programme Coordinator3','Shadow','School Services','Evaluation & Authorization');
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Programme Coordinator4','Shadow','Assessment','Workshops');
        IB_Role_Repository__c repo3 = TestsUtil.createRoleRepoWithParams('Programme Coordinator5','Shadow','Professional Development','Management');
        insert new List<IB_Role_Repository__c>{repo1,repo2,repo3};

        trEvent.IB_Role__c = repo1.id;
        trEvent.IB_Role_2__c = repo2.id;
        trEvent.IB_Role_3__c = repo3.id; 
        update trEvent;*/
        

        myTrainingEvent.Application_Status__c = 'Confirmed';
        myTrainingEvent.Invitation_Response__c = 'Accept';
        myTrainingEvent.Level_of_Interest__c = 'Interested';
        myTrainingEvent.Release_Permission_Required__c = 'No'; 
        
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        myTrainingEvent.IB_Role__c = repos[0].id;
        myTrainingEvent.IB_Role_2__c = repos[1].id;
        myTrainingEvent.IB_Role_3__c = repos[2].id;                 
        myTrainingEvent.Training_Result__c = 'Passed';
        myTrainingEvent.Application_Status__c = 'Completed';
        myTrainingEvent.Role_Level__c = 'Fully Qualified';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        
    }               
        
    @isTest
    public static void testUpdateSetTrainingResultToFailed(){
        
        init();
        initMoreRoleRepos();

        Training_Event__c trEvent = TestsUtil.getTrainingEvents().get(0);
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        Contact cont = TestsUtil.getContacts().get(0);

        My_Training_Event__c myTrainingEvent = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        myTrainingEvent.IB_Event__c = trEvent.IB_Event__c;
        insert myTrainingEvent;
        
        // before set Application_Status__c to 'Completed' it must be set to 'Confirmed'
        myTrainingEvent.Application_Status__c = 'Confirmed';
        myTrainingEvent.Invitation_Response__c = 'Accept';
        myTrainingEvent.Level_of_Interest__c = 'Interested';
        myTrainingEvent.Release_Permission_Required__c = 'No';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
        
        myTrainingEvent.IB_Role__c = repos[0].id;
        myTrainingEvent.IB_Role_2__c = repos[1].id;
        myTrainingEvent.IB_Role_3__c = repos[2].id;                 
        myTrainingEvent.Training_Result__c = 'Failed';
        myTrainingEvent.Application_Status__c = 'Completed';
        myTrainingEvent.Declined_for_Further_Trainings__c = 'Yes';
        MyTrainingEventTriggerHandler.RAN_FLAG = FALSE;
        update myTrainingEvent;
        
    }       
                
        

    
    // helper methods
    public static void initMoreRoleRepos(){
        Test.startTest();
        Contact cont1 = TestsUtil.getcontacts().get(0);
        Campaign camp = TestsUtil.getCampaigns().get(0);
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepoWithParams('Programme Coordinator4','Fully Qualified','Assessment','Workshops');
        IB_Role_Repository__c repo3 = TestsUtil.createRoleRepoWithParams('Programme Coordinator5','Fully Qualified','Professional Development','Management');
        insert new List<IB_Role_Repository__c>{repo2,repo3};
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo2.Id, cont1.Id);
        ibRole2.Programme_Selection__c = camp.IB_Programme__c;
        // if Status is 'Applicant' then User must be NOT Active And Role_Level__c must be null
        ibRole2.Status__c = 'Applicant';
        ibRole2.Active__c = false;
        ibRole2.Role_Level__c = null;
        insert  ibRole2;

        IB_Role__c ibRole3 = TestsUtil.createIbRole(repo3.Id, cont1.Id);
        ibRole3.Programme_Selection__c = camp.IB_Programme__c;
        // if Status is 'Applicant' then User must be NOT Active And Role_Level__c must be null
        ibRole3.Status__c = 'Applicant';
        ibRole3.Active__c = false;
        ibRole3.Role_Level__c = null;
        insert  ibRole3;

        Training_Event__c trEvent1 = TestsUtil.getTrainingEvents().get(0);
        trEvent1.IB_Role_2__c = repo2.Id;
        trEvent1.IB_Role_3__c = repo3.Id;
        update trEvent1;
        Test.stopTest();
    }//end initMoreRoleRepos

    public static void init(){
        
        initCampaigns();
        
        /*IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;*/
        IB_Role_Repository__c repo1 = TestsUtil.createRoleRepoWithParams('Programme Coordinator3','Fully Qualified','School Services','Evaluation & Authorization');
        
        insert repo1;
                    
        Campaign camp = TestsUtil.getCampaigns().get(0);
        camp.IB_Role__c = repo1.Id;
        camp.IB_Programme__c = repo1.Related_Programmes__c;
        //This Part is being updated by Ammara-Plumlogix,as part of US-11586 on 06/11/2020
        //Begin
        camp.Status = 'Staffed';//End
        update camp;
        
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        insert country;
        
        Contact cont1 = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont1.AccountId = acc.Id;
        //insert cont;
        insert cont1;

        /*Contact cont2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx2', 'yyyy@yyy.yyy2', Date.today().addYears(-25), country);
        insert cont2;

        Contact cont3 = TestsUtil.createContact('test_contact_003', 'yyyy@yyyy.xxx3', 'yyyy@yyy.yyy3', Date.today().addYears(-26), country);
        insert cont3;*/

        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo1.Id, cont1.Id);
        
        ibRole1.Programme_Selection__c = camp.IB_Programme__c;
        // if Status is 'Applicant' then User must be NOT Active And Role_Level__c must be null
        ibRole1.Status__c = 'Applicant';
        ibRole1.Active__c = false;
        ibRole1.Role_Level__c = null;
        insert ibRole1;
        

        Training_Event__c trEvent1 = TestsUtil.createTrainingEvent('test_name000', repo1.Id, camp.Id); 
        insert trEvent1;
        
        /*Training_Event__c trEvent2 = TestsUtil.createTrainingEvent('test_name001', repo2.Id, camp.Id); 
        Training_Event__c trEvent3 = TestsUtil.createTrainingEvent('test_name003', repo3.Id, camp.Id); 
        insert new List<Training_Event__c>{trEvent1,trEvent2,trEvent3};*/
        /*trEvent.IB_Role_2__c = repo.Id;
        trEvent.IB_Role_3__c = repo.Id;
        update trEvent;*/
    }
    
    
    
    private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '111111';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '222222';
        Account acc3 = TestsUtil.createAccount('test_acc_name_3');
        acc3.IBIS_ID__c = '333333';
        insert new List<Account> {acc1,acc2,acc3};
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        Opportunity opp3 = TestsUtil.createOpportunity('Test PYP 2', acc3.Id); 
        insert new List<Opportunity> {opp1,opp2,opp3};
        //This Part is being updated by Ammara-Plumlogix,as part of US-11586 on 06/11/2020
        //Begin
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        //End
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        Campaign camp3 = TestsUtil.createCampaign('camp test name 2', acc3.Id, opp3.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2,camp3};
    }   
        
     
}