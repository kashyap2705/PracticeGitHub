/**		
* <h1>LeadBeforeUpdateTriggerHandler</h1>		
* This class is responsible managing beforeupdate trigger functionality on lead object as part of trigger consolidation,US11226.
* 
* @author  Abd Ur Rehman		
* @version 1.0		
* @since   28-1-2020

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class LeadBeforeUpdateTriggerHandler  extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp){
        process((Map<Id,Lead>)tp.oldMap, (Map<Id,Lead>)tp.newMap ,(list<Lead>)tp.newList
                ,(list<Lead>)tp.oldList);
    }
    /**		
* This Method is responsible for beforeupdate trigger execution ,US11226.
* @author: Abd Ur Rehman-Plumlogix 
* @since 28-1-2020
* @param map and list of lead.		
* @return void.		
*/
    private static void process (Map<Id,Lead> oldProgramme, Map<Id,Lead> newProgramme 
                                 ,list<Lead> newlist , list<Lead> oldlist) {
                                     LeadTriggerHelper.DupLead(newlist);
                                     // Below Method is added by Suraj As a part of ECM00511                                  
                                     LeadTriggerHelper.updateIberoAmericaLead(oldProgramme, newlist); 
                                     //END
                                     
                                 }
    
}