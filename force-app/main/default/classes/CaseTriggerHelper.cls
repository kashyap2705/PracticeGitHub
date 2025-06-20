/*******************************************************************************************
* @Name         CaseTriggerHelper 
* @Author       Ranjith Kondabathini
* @Date         26-04-2023
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 
*******************************************************************************************/
public class CaseTriggerHelper {
    
    /*Get GSSS Queue Id*/    
    public static Id gsssQueueId {
        get {
            if (gsssQueueId == null) {
                gsssQueueId = [select Id from Group where Type='Queue' and DeveloperName = :IboUtil.GSSS_QUEUE_NAME]?.Id; 
            }
            return gsssQueueId;
        }
        set;
   }
    //code added by prerna on 20-07-2023 for ECM00489 --START--
    /*Get soCustomerService Queue Id*/    
    public static Id soCustomerServiceQueueId {
        get {
            if (soCustomerServiceQueueId == null) {
                soCustomerServiceQueueId = [select Id from Group where Type='Queue' and DeveloperName = :IboUtil.SO_QUEUE_NAME]?.Id; 
            }
            return soCustomerServiceQueueId;
        }
        set;
   }
   // code added by prerna on 20-07-2023 for ECM00489 --END
}