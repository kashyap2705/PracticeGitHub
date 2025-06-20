//Class created by Shahrukh Anwar and Prerna Sobti for ECM00498 on 12/15/2022 -----
//This class is responsible to shift the control to the right control on basis of Trigger event
public with sharing class Non_IB_CodeTriggerDispatcher extends TriggerDispatcherBase {
    
    private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isAfterUnDeleteProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
    
    public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new Non_IB_CodeBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}

    public virtual override void beforeUpdate(TriggerParameters tp) {
		if(!isBeforeUpdateProcessing) {
			isBeforeUpdateProcessing = true;
			execute(new Non_IB_CodeBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
			isBeforeUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}
}