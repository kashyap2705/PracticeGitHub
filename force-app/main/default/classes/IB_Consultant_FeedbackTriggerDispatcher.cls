public class IB_Consultant_FeedbackTriggerDispatcher extends TriggerDispatcherBase {

  private static Boolean isAfterUpdateProcessing = false;
  private static Boolean isBeforeUpdateProcessing = false;

   public virtual override void afterUpdate(TriggerParameters tp) {
    if(!isAfterUpdateProcessing) {
      isAfterUpdateProcessing = true;
      execute(new IB_ConsultantFeedbackAfterUpdateTrigger(), tp, TriggerParameters.TriggerEvent.afterUpdate);
      isAfterUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
  }
    
  public virtual override void beforeUpdate(TriggerParameters tp) {
    if(!isBeforeUpdateProcessing) {
      isBeforeUpdateProcessing = true;
      execute(new IB_ConsultantFeedbackBeforeUpdateHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
      isBeforeUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
  } 
    

}