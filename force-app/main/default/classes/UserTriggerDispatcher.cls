public class UserTriggerDispatcher extends TriggerDispatcherBase {

	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;

	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new UserAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}

	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new UserAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

}