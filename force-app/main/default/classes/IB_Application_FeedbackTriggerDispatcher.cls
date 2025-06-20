public class IB_Application_FeedbackTriggerDispatcher extends TriggerDispatcherBase {
	private static Boolean isAfterUpdateProcessing = false; 
	
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new IBApplicationFeedbackAfterUpdateHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}

}