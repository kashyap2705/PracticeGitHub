public class PGQA_SampleTriggerDispatcher extends TriggerDispatcherBase{
 private static Boolean isBeforeInsertProcessing = false;
 
    public virtual override void beforeInsert(TriggerParameters tp) {
     if(!isBeforeInsertProcessing) {
      isBeforeInsertProcessing = true;
      execute(new PGQA_SampleBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
      isBeforeInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
  }
}