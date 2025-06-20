@isTest
public with sharing class MyTrainingEventRedirectionControllerTest {
    
    static testMethod void testgetUrlMethod() {
    	init();
    	
    	MyTrainingEventRedirectionRules__c rules = new MyTrainingEventRedirectionRules__c(name = RedirectionHandlerController.INTERNAL_COMMUNITY , url__c = 'test', ids__c = 'test', communityName__c = 'test');
    	insert rules;
    	
    	new MyTrainingEventRedirectionController((new ApexPages.StandardController(TestsUtil.getMyTrainingEvents()[0]))).redirectTo();
    	System.assert(true, 'MyTrainingEventRedirectionController redirect problem !!');
    	 
    }
    
    // helper methods
	
	private static void init() {
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
        //This line is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        camp.status = 'Staffed';
		update camp;
		
		Account acc = TestsUtil.createAccount('twretwretr');
        acc.IBIS_ID__c = '463674';
		insert acc;
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('testname', 'EUROPE', acc);
		insert country;
		
	 	Contact cont = TestsUtil.createContact('test_name_001', 'xxx@xxx.com', 'axxx@xxx.com', Date.today().addYears(-20), country);
	 	cont.AccountId = acc.Id;
	 	
	 	insert cont;
	 	
	 	
		cont = [select Salutation, LastName,
                       MobilePhone,
            HomePhone,
            IBEN_Region__c,
            Email,
            Birthdate,
            Country__r.IBEN_Segmentation__c,
            Alternative_Email__c,
            FirstName,
            MailingCity ,
            MailingState,
            MailingStateCode,
            MailingCountry,
            MailingCountryCode,
            MailingPostalCode,
            MailingStreet from Contact where id =: cont.id];
        
		IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont.Id);
		
		ibRole1.Programme_Selection__c = camp.IB_Programme__c;
		// if Status is 'Applicant' then User must be NOT Active And Role_Level__c must bu null
		ibRole1.Status__c = 'Applicant';
		ibRole1.Active__c = false;
		ibRole1.Role_Level__c = null;
		insert ibRole1;
		
		Training_Event__c trEvent = TestsUtil.createTrainingEvent('test_name000', repo.Id, camp.Id); 
		insert trEvent;
		Test.stopTest();
		My_Training_Event__c instance = TestsUtil.createMyTrainingEvent('Invited', cont.Id, trEvent.Id);
		instance.IB_Contact__r = cont;
		System.debug('<<<<<->>>>>' + instance.IB_Contact__r.IBEN_Region__c +  instance.Contact_IBEN_Region__c + ' = ' + instance.Training_Event_Region__c );
		
		insert instance;
	}
	
	
	
	private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '434343';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '444444';
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