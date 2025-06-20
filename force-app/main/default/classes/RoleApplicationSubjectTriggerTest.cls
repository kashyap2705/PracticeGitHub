@isTest
private class RoleApplicationSubjectTriggerTest {

	private static testMethod void testInsert() {
	    
	    TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
		insert country;
		
		Contact cont = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
		insert cont;
		
		IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
		repo.Role_Level__c = 'Fully Qualified';
		insert repo;

        IB_Subject__c subject = createIbSubject();
        insert subject;
        
        IB_Subject__c subject1 = createIbSubject();
        insert subject1;
        
		IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, cont.Id);		
		role1.Restricted_Subjects__c = subject1.Id+','+subject.Id;
		insert role1;
		
		Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.Role_And_Application__c = role1.Id;
        ras.IB_Subject__c = subject.Id;
        test.startTest();
        insert ras;
        test.stopTest();
	}
	
	private static testMethod void testDelete1() {
	    
	    TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
		insert country;
		
		Contact cont = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
		insert cont;
		
		IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
		repo.Role_Level__c = 'Fully Qualified';
		insert repo;

        IB_Subject__c subject = createIbSubject();
        insert subject;
        
        IB_Subject__c subject1 = createIbSubject();
        insert subject1;
        
		IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, cont.Id);		
		role1.Restricted_Subjects__c = subject1.Id+','+subject.Id;
		insert role1;
		
		Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.Role_And_Application__c = role1.Id;
        ras.IB_Subject__c = subject.Id;
        insert ras;
        test.startTest();
        delete ras;
        test.stopTest();
	}
	
	private static testMethod void testDelete2() {
	    
	    TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
		insert country;
		
		Contact cont = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
		insert cont;
		
		IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
		repo.Role_Level__c = 'Fully Qualified';
		insert repo;

        IB_Subject__c subject = createIbSubject();
        insert subject;
        
        IB_Subject__c subject1 = createIbSubject();
        insert subject1;
        
		IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, cont.Id);		
		insert role1;
		
		Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.Role_And_Application__c = role1.Id;
        ras.IB_Subject__c = subject.Id;
        insert ras;
        test.startTest();
        delete ras;
        test.stopTest();
	}
	
	public static IB_Subject__c createIbSubject(){
        return new IB_Subject__c(
            IB_Programme__c = 'DP',
            IB_Programme_Long__c = 'Diploma',
            Subject_Code__c = 'eeyyy',
            Subject_Group__c = 'Diploma Programme Core',
            Subject_Group_Identifier__c = 'gen0d',
            Subject_Name__c = 'Extended essay',
            Available_in_IBEN__c = true,
            Available_in_MySchool__c = true
        );
    }
}