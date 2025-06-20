/**		
	* <h1>IB_ProgrammeAfterInsertTriggerHandler</h1>		
	* This class is responsible managing afterupdate trigger functionality on ib_programme object as part of trigger consolidation,US11226.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
public class IB_ProgrammeAfterInsertTriggerHandler  extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp){
         //if(TriggerContextUtility.isFirstRun()){
         //TriggerContextUtility.setFirstRunFalse();
		process((Map<Id,IB_Programme__c>)tp.oldMap, (Map<Id,IB_Programme__c>)tp.newMap ,(list<IB_Programme__c>)tp.newList
                ,(list<IB_Programme__c>)tp.oldList);
         //}
	}

	private static void process (Map<Id,IB_Programme__c> oldProgramme, Map<Id,IB_Programme__c> newProgramme, 
                                 list<IB_Programme__c> newlist , list<IB_Programme__c> oldlist) {
                                     if(!system.isFuture() && !system.isBatch()) {
                                         WithdrawOnboardingRolesQueueable worq = new WithdrawOnboardingRolesQueueable(newProgramme.keyset());    
                                         Database.executeBatch(worq, 20);
                                     }
                                     
		
	}
    

}