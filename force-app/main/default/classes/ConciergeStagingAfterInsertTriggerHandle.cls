public class ConciergeStagingAfterInsertTriggerHandle extends TriggerHandlerBase{

     public override void mainEntry(TriggerParameters tp){
         system.debug('insdie of ConciergeStagingAfterInsertTriggerHandle***');
        process( (List<IBConciergeStaging__c>)tp.newList); 
        
    }
    
    @testVisible  private static void process(List<IBConciergeStaging__c> ibConciergeStagingList){
        
        system.debug('ibConciergeStagingList***'+ibConciergeStagingList);
        
        List<Campaign> events= new List<Campaign>();
        
       System.enqueueJob(new QueueableConcierge(ibConciergeStagingList)); 
     
    }
}