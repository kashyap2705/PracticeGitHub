@isTest
Public class CustomIBProgReportDataTest
{

   @isTest  
    public static void TestOne()
    {
    
    IB_Programme_Report__c rep=new IB_Programme_Report__c();
   // rep.name='test';
    test.startTest();
    CustomReportData.SaveReport(rep);
    test.stopTest();    
    }



}