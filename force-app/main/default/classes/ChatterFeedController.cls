public class ChatterFeedController {
    
    public string AssID{get;set;}
    public ChatterFeedController()
    {
        try
        {
            
            Campaign camp = [select Staffing_Event_Notice_Board__c from campaign where id=:ApexPages.currentPage().getParameters().get('pid') limit 1];
            AssID = string.valueOf(camp.Staffing_Event_Notice_Board__c);    
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
    
    
}