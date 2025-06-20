public class IBConciergeStagingTriggerDispatcher extends TriggerDispatcherBase{
     
  
    private static Boolean isAfterInsertProcessing = false;
   
     public virtual override void afterInsert(TriggerParameters tp) { 
     if(!isAfterInsertProcessing) {
      isAfterInsertProcessing = true;
      execute(new ConciergeStagingAfterInsertTriggerHandle(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isAfterInsertProcessing = false;
    } 
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }
    
    

   }