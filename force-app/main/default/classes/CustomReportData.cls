Public class CustomReportData
{

    public static boolean IsExec = true;
     
    public static void SaveReport(IB_Programme_Report__c rep)
    {
    
    
        insert rep;
        IsExec = false;
    }



}