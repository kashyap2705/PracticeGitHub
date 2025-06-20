public class ContactEmailTriggerDispatcher extends TriggerDispatcherBase {

	private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;

	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new ContactEmailAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}
    
    public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new ContactEmailAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
    
    public virtual override void afterDelete(TriggerParameters tp) {
		if(!isAfterDeleteProcessing) {
			isAfterDeleteProcessing = true;
			execute(new ContactEmailAfterDeleteTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
			isAfterDeleteProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
	}

}