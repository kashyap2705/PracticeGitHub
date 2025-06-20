/**		
	* <h1>IB_E_BackgroundAftrUpdtTriggerHandler</h1>		
	* This class is responsible managing after upadte trigger functionality on IB_E_Background__c object as part of trigger consolidation,US11101.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
public class IB_E_BackgroundAftrUpdtTriggerHandler extends TriggerHandlerBase{
public override void mainEntry(TriggerParameters tp){
     //if(TriggerContextUtility.isFirstRun()){
        // TriggerContextUtility.setFirstRunFalse();
          populateLanguage((list<IB_E_Background__c>)tp.newList); 
      //  }
        
     }
     /*This method is developed by Abd-Ur-Rehman-Plumlogix to populate language of educators on ib contact 2020-02-12 
   As part of cr-691 */
    //begin 
    @testvisible
    private static void populateLanguage (list<IB_E_Background__c> backGrounds)
    {
        system.debug('populate language');
        set<Id> contactIds = new set<Id>();
    List<ID> ib_backgrounds_ids = new List<ID>();
    list<Contact> contactlist = new list<Contact>();
    for(IB_E_Background__c iben : backGrounds){
        contactids.add(iben.IB_Contact__c);
        ib_backgrounds_ids.add(iben.id);
        System.debug('LOD: '+iben.Language_Delivery__c);
    }
    
    integer i;
    
   
    List<Contact> contact =[select id,Name,Language_1__c,Language_2__c,Language_3__c,Language_4__c,
                            (SELECT Id,Language__c ,Language_Delivery__c From IB_E_Experiences__r where RecordType.Name = 'Language Experience' order by Language_Delivery__c   ) 
                            from contact where id IN:contactids]; 
    
    for(Contact contact_to_update :contact){
        i=1;
        for(IB_E_Background__c ib_background_record: contact_to_update.IB_E_Experiences__r ){
            if(i==1 )
            {
                
                contact_to_update.Language_1__c = ib_background_record.Language__c;
                contact_to_update.Language_Delivery_1__c = ib_background_record.Language_Delivery__c;
            }
            
            else if( i==2)
            {
                
                contact_to_update.Language_2__c = ib_background_record.Language__c;
                contact_to_update.Language_Delivery_2__c = ib_background_record.Language_Delivery__c;
                
            }
            else if( i==3)
            {
                
                contact_to_update.Language_3__c = ib_background_record.Language__c;
                contact_to_update.Language_Delivery_3__c = ib_background_record.Language_Delivery__c;
            }
            else if( i==4){
                
                contact_to_update.Language_4__c = ib_background_record.Language__c;
                contact_to_update.Language_Delivery_4__c = ib_background_record.Language_Delivery__c;
                
            }
            System.debug('Contact Name: '+contact_to_update.Name+' Value of i'+i);
            i++;
        }
        
        contactlist.add(contact_to_update);
    }
    
    try{
        if(contactlist.size()>0)
            update contactlist;
    }
    catch(Exception ex){
        System.debug('Exception: '+ex);
    }
    
    }
    //end
}