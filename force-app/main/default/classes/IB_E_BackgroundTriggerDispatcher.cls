/**		
	* <h1>IB_E_BackgroundTriggerDispatcher</h1>		
	* This class is responsible Trigger Dispatcher functionality on IB_E_Background__c object as part of trigger consolidation,US11101.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class IB_E_BackgroundTriggerDispatcher extends TriggerDispatcherBase {
 

	private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;
	private static Boolean isAfterDeleteProcessing = false;
	private static Boolean isAfterUnDeleteProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
    
     public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new IB_E_BackgroundBfrInsrtTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}

	public virtual override void beforeUpdate(TriggerParameters tp) {
		if(!isBeforeUpdateProcessing) {
			isBeforeUpdateProcessing = true;
			execute(new IB_E_BackgroundBfrUpdtTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
			isBeforeUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
	}
    
    public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new IB_E_BackgroundAftrInsrtTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
	}

	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new IB_E_BackgroundAftrUpdtTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
	}

public virtual override void afterDelete(TriggerParameters tp) {
		if(!isAfterDeleteProcessing) {
			isAfterDeleteProcessing = true;
			execute(new IB_E_BackgroundAftrDletTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterDelete);
			isAfterDeleteProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterDelete);
	}

	public virtual override void afterUnDelete(TriggerParameters tp) {
		if(!isAfterUnDeleteProcessing) {
			isAfterUnDeleteProcessing = true;
			execute(new IB_E_BackgroundAfterUnDletTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUnDelete);
			isAfterUnDeleteProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.afterUnDelete);
	}

    
   

 }