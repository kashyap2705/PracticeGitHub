/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Michael  Khan     08/08/2023         PRB0041127: Apex Test Execution Failed (ScheduledIbenEndDateRolesTest)
*******************************************************************************************/

@isTest
private class ScheduledIbenEndDateRolesTest {
    
    public static String cron_exp = '0 0 0 15 3 ? 2099';
    
    @testSetup
    public static void createTestData() {        
        
        DeactivateUserSettings__c dus = new DeactivateUserSettings__c();
        dus.Value__c = '-1';
        dus.Name = 'DaysWithoutRole';
        insert dus;
        
        Account acc = AccountFactoryTest.createAccountRecord(false);
        insert acc;
        List<Contact> conRecords = ContactFactoryTest.createContacts(3,false,acc);   
        if(!conRecords.isEmpty()){
            insert conRecords;
        }
        
        IB_Country_Segmentation__c country2= RoleRepoFactoryTest.createCountry(false, acc);
        insert country2;
        List<IB_Address__c> addresRec = RoleRepoFactoryTest.createAddress(3,country2.id,acc,false); 
        if(!addresRec.isEmpty()){
            insert addresRec;
        }
                
        IB_Role_Repository__c repoHOSOverall = PimsTestUtil.createRoleRepo('New Test Role');
        repoHOSOverall.Display_In_PIMS_Community__c = false;
        repoHOSOverall.SF_Role_Application__c = true;
        insert repoHOSOverall;      
                
        
    }
    
	
	@isTest(SeeAllData=false)
    static void testEndDate() {
        
        List<Contact> conRecords = [select Id,AccountId from Contact];
        IB_Role_Repository__c repoHOSOverall = [select Id from IB_Role_Repository__c limit 1];
        Process_Automation_Settings__c pas = new Process_Automation_Settings__c();
        pas.Bypass_All_Triggers__c = true;
        pas.SetupOwnerId = UserInfo.getUserId();
        insert pas;
        system.runAs(new User(Id=UserInfo.getUserId())) {            
            List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
            IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoHOSOverall.Id, conRecords[0].id, conRecords[0].AccountId); 
            role.Status__c = 'Applicant';   
            role.Active__c = false;
            role.End_Date__c = Date.today().addDays(-2);
            testRoles.add(role);            
            insert testRoles;   
        }
		
		Test.startTest();               

		//schedule the job
		String jobId = System.schedule('IbenEndDateRolesTest', cron_exp, new ScheduledIbenEndDateRoles());

		// get the information from the CronTrigger API object
		CronTrigger ct = [
			SELECT Id, CronExpression, TimesTriggered, NextFireTime 
			FROM CronTrigger 
			WHERE id = :jobId
		];

		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		System.assertEquals('2099-03-15 00:00:00', String.valueOf(ct.NextFireTime));

		// test should run after stopTest()
		Test.stopTest();

	}

}