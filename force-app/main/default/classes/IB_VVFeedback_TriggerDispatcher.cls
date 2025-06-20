/**     
    * <h1>IB_VVFeedbackTriggerDispatcher</h1>       
    * This class is responsible managing Trigger Dispatcher functionality on IB_Verification_Visit_Feedback__c object.
    * 
    * @author Ammara Alvi       
    * @version 1.0      
    * @since   6-19-2020
    
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class IB_VVFeedback_TriggerDispatcher extends TriggerDispatcherBase {

    private static Boolean isBeforeInsertProcessing = false;
    private static Boolean isAfterInsertProcessing = false;
    private static Boolean isAfterUpdateProcessing = false;
    private static Boolean isAfterDeleteProcessing = false;
    private static Boolean isAfterUnDeleteProcessing = false;
    private static Boolean isBeforeUpdateProcessing = false;
    
    public virtual override void afterUpdate(TriggerParameters tp) {
        if(!isAfterUpdateProcessing) {
            isAfterUpdateProcessing = true;
            execute(new IB_VVFAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
            isAfterUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }

}