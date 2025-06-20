/**		
	* <h1>IB_ProgrammeTriggerDispatcher</h1>		
	* This class is responsible managing trigger consolidation pattern as part of trigger consolidation,US11226.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public with sharing class IB_ProgrammeTriggerDispatcher extends TriggerDispatcherBase {

	private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;
	private static Boolean isAfterDeleteProcessing = false;
	private static Boolean isAfterUnDeleteProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new IB_ProgrammeAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}
	public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new IB_ProgrammeBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}

	public virtual override void beforeUpdate(TriggerParameters tp) {
		if(!isBeforeUpdateProcessing) {
			isBeforeUpdateProcessing = true;
			execute(new IB_ProgrammeBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
			isBeforeUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}
    
    public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
            
			isAfterInsertProcessing = true;
			execute(new IB_ProgrammeAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

    
}