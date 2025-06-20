/**		
	* <h1>TranslationTriggerDispatcher</h1>		
	* This class is responsible managing Trigger Dispatcher functionality on Translation__c object as part of trigger consolidation,US11101.
	* 
	* @author  Dilip Kumar	
	* @version 1.0		
	* @since   08-02-2022
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class TranslationTriggerDispatcher extends TriggerDispatcherBase {

	private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;
	private static Boolean isAfterDeleteProcessing = false;
	private static Boolean isAfterUnDeleteProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
    
    public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new TranslationBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}
		else execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
	}

}