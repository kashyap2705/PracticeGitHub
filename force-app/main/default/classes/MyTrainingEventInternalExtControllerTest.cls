@isTest
private class MyTrainingEventInternalExtControllerTest {
    
    
    @isTest
    private static void testInitialState(){
        init();

        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);
        
        System.assert(instance.Id == controller.mytraningEvent.Id);
    }
    
    
    @isTest
    private static void testInitialStateWithUrlParam(){
        init();

        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        
        String trainingEventId = instance.Training_Event__c;
        
        instance.Training_Event__c = null;
        
        Test.setCurrentPage(Page.myTrainingInternal);
        ApexPages.currentPage().getParameters().put('trainingEventId', trainingEventId);
                
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);
    }
    
    
    @isTest
    private static void testSave(){
        init();
        
        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        system.debug('instance: ' + instance);
        instance.IB_Event__c = [select IB_Event__c from Training_Event__c where Id =: instance.Training_Event__c].IB_Event__c;
        update instance;
        Test.setCurrentPage(Page.myTrainingInternal);
        
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);

        PageReference pr = controller.save();
        System.assert(pr.getUrl() == '/' + instance.Id);
        
        //set retUrl param
        ApexPages.currentPage().getParameters().put('retURL', 'testUrl');
        
        pr = controller.save();
        System.assert(pr.getUrl() == 'testUrl');
    }   
    
    
    @isTest
    private static void testDmlExceptionOnSave(){
        init();
        
        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        instance.Training_Event__c = null;
        
        Test.setCurrentPage(Page.myTrainingInternal);
        
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);
        
        System.assert(null == controller.save());
        
        System.assert(ApexPages.hasMessages());
    }


    @isTest
    private static void testExceptionOnSave(){
        init();
        
        MyTrainingEventsDAO MyTrainingMtd = MyTrainingEventsDAO.getInstance();
        MyTrainingMtd.getCampaignIdFromTrainingId(null);
        
        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        
        Test.setCurrentPage(Page.myTrainingInternal);
        
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);
        
        //simmulate TypeException
        controller.mytraningEvent = null;
        
        System.assert(null == controller.save());
        
        System.assert(ApexPages.hasMessages());
    }
    
    

    @isTest
    private static void testCancel(){
        init();
        
        My_Training_Event__c instance = TestsUtil.getMyTrainingEvents().get(0);
        
        Test.setCurrentPage(Page.myTrainingInternal);
        
        ApexPages.StandardController stContr = new ApexPages.StandardController(instance);
        MyTrainingEventInternalExtController controller = new MyTrainingEventInternalExtController(stContr);
        

        PageReference pr = controller.cancel();
        System.assert(pr.getUrl() == '/a0t/o');
        
        ApexPages.currentPage().getParameters().put('retUrl', 'retUrl');
        
        pr = controller.cancel();
        System.assert(pr.getUrl() == 'retUrl');     
        
        ApexPages.currentPage().getParameters().put('cancelURL', 'testUrl');
        
        pr = controller.cancel();
        System.assert(pr.getUrl() == 'testUrl');
    }
        
        
        
    // helper methods
    
    private static void init(){
        Test.startTest();
        initCampaigns();
        
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;
        
        repo.Training_Model__c = 'Initial Training';
        update repo;
                    
        Campaign camp = TestsUtil.getCampaigns().get(0);
        camp.IB_Role__c = repo.Id;
        camp.IB_Programme__c = repo.Related_Programmes__c;
        camp.Training_Event_Type__c = 'Initial Training';
        //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //Begin
        camp.Status = 'Staffed';//End
        update camp;
        
        Account acc = TestsUtil.createAccount('twretwretr');
        insert acc;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('testname', 'EUROPE', acc);
        insert country;
        
        Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
        cont.AccountId = acc.Id;
        insert cont;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont.Id);
        
        ibRole1.Programme_Selection__c = camp.IB_Programme__c;
        // if Status is 'Applicant' then User must be NOT Active And Role_Level__c must bu null
        ibRole1.Status__c = 'Applicant';
        ibRole1.Active__c = false;
        ibRole1.Role_Level__c = null;
        insert ibRole1;
        
        Training_Event__c trEvent = TestsUtil.createTrainingEvent('test_name000', repo.Id, camp.Id); 
        insert trEvent;
        
        My_Training_Event__c instance = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
        insert instance;
        Test.stopTest();
    }
    
    
    
    private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '161616';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '171717';
        insert new List<Account> {acc1,acc2};
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2};
    }   
        
}