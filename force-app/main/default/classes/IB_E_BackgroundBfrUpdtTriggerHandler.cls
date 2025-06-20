/**		
	* <h1>IB_E_BackgroundBfrUpdtTriggerHandler</h1>		
	* This class is responsible managing before update trigger functionality on IB_E_Background__c object as part of trigger consolidation,US11101.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
public class IB_E_BackgroundBfrUpdtTriggerHandler  extends TriggerHandlerBase{
     public override void mainEntry(TriggerParameters tp){
        if(TriggerContextUtility.isFirstRun()){
         TriggerContextUtility.setFirstRunFalse();
        }
     }  

}