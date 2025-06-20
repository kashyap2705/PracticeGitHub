public class CaseTriggerDispatcher extends TriggerDispatcherBase{
     
    
    private static Boolean isBeforeUpdateProcessing = false;
    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    public virtual override void beforeUpdate(TriggerParameters tp) {
    if(!isBeforeUpdateProcessing) {
      isBeforeUpdateProcessing = true;
      execute(new CaseBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
      isBeforeUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
  }
    public virtual override void beforeInsert(TriggerParameters tp) {
     if(!isBeforeInsertProcessing) {
      isBeforeInsertProcessing = true;
      execute(new CaseBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
      isBeforeInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
  }
     public virtual override void afterInsert(TriggerParameters tp) {
     if(!isAfterInsertProcessing) {
      isAfterInsertProcessing = true;
      execute(new CaseAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
      isAfterInsertProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
  }

    public virtual override void afterUpdate(TriggerParameters tp) {
     if(!isAfterUpdateProcessing) {
      isAfterUpdateProcessing = true;
      execute(new CaseAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterupdate);
      isAfterUpdateProcessing = false;
    }
    else execute(null, tp, TriggerParameters.TriggerEvent.afterupdate);
  }}