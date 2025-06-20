@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here

    @isTest
    public static void method1()
    {
        Opportunity opp = new Opportunity();
        opp.DeliveryInstallationStatus__c= 'In progress';
        opp.Name= 'LAPTOPS'; 
        opp.StageName='Closed Won'; 
        opp.CloseDate=Date.today();
        insert opp;
        
        Project__c prjt = new Project__c();
         prjt.ProjectRef__c = 'test';
            prjt.Name = 'Test';
            prjt.Opportunity__c = opp.id;
            prjt.Start_Date__c = Date.today();
        	prjt.End_Date__c = (Date.today()).addDays(10);
            prjt.Billable_Amount__c = 500;
            prjt.Status__c = 'Running';
        Insert prjt;
        
        ProjectRESTService.postProjectData('test','Test',String.valueOf(opp.id),Date.today(),Date.today(),500,'Running');
        
    }

}