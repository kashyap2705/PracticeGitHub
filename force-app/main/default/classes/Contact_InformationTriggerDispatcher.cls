/**     
    * <h1>Contact_Information_TriggerDispatcher</h1>       

    * This class is responsible managing Trigger Dispatcher functionality on Contact_Information_c object.

    * 
    * @author Ammara Alvi       
    * @version 1.0      
    * @since  05-20-2021
    
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class Contact_InformationTriggerDispatcher extends TriggerDispatcherBase{



    public static Boolean isBeforeInsertProcessing = false;
    public static Boolean isBeforeUpdateProcessing = false;
    

    public virtual override void beforeUpdate(TriggerParameters tp) {
        if(!isBeforeUpdateProcessing) {
            isBeforeUpdateProcessing = true;
            execute(new ContactInfo_BeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
            isBeforeUpdateProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
    }



     public virtual override void beforeInsert(TriggerParameters tp) {
        if(!isBeforeInsertProcessing) {
            isBeforeInsertProcessing = true;
            execute(new ContactInfo_AfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
            isBeforeInsertProcessing = false;
        }
        else execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);


    }
}