public class ContactTriggerDispatcher extends TriggerDispatcherBase {
	private static Boolean isAfterUpdateProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;			//Added by Shahrukh for ECM590
	
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new ContactAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}

	//Added by Shahrukh for ECM590 -- START --
	public virtual override void beforeUpdate(TriggerParameters tp) {
		if(!isBeforeUpdateProcessing) {
			isBeforeUpdateProcessing = true;
			execute(new ContactBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
			isBeforeUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}
	//Added by Shahrukh for ECM590 -- END --
}