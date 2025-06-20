/**		
	* <h1>LeadAfterInsertTriggerHandler</h1>		
	* This class is responsible managing afterinsert trigger functionality on ib_progleadramme object as part of trigger consolidation,US11226.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class LeadAfterInsertTriggerHandler extends  TriggerHandlerBase {
    
     /**		
	   * This Method is responsible for afterinsert trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param triggerparameter.		
	   * @return void.		
	  */
    public override void mainEntry(TriggerParameters tp){
		process((Map<Id,Lead>)tp.oldMap, (Map<Id,Lead>)tp.newMap ,(list<Lead>)tp.newList
                ,(list<Lead>)tp.oldList);
	}
	/**		
	   * This Method is responsible for afterinsert trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param map and list of lead.		
	   * @return void.		
	  */
    private static void process (Map<Id,Lead> oldProgramme, Map<Id,Lead> newProgramme 
                                 ,list<Lead> newlist , list<Lead> oldlist) {
   LeadTrigger(oldProgramme ,newProgramme , newlist);
   
     }
     /**		
	   * This Method is responsible for LeadTrigger trigger functionality ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param map and list of lead.		
	   * @return void.		
	  */
 private static void LeadTrigger (Map<Id,Lead> oldMap ,Map<Id,Lead> newMap ,list<Lead> newlist )
    {
        //Invoke Bitly Service to shorten Web-address
    set<Id> leadIds = new set<Id>();
    List<Lead> list_lead = new List<Lead>();
    for(Lead l : newlist){
       if( l.Website != null && l.Website.length() > 100){
            leadIds.add(l.Id);
        }
    }
    system.debug('#### Leads to shorten web address : '+leadIds);
    if(leadIds.size() > 0){
        InvokeBitlyService.shortenAsync(newMap.keyset(),'Lead');
     }
    }
}