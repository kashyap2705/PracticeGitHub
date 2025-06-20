/**		
	* <h1>UserTriggerHandler</h1>		
	* This class is responsible for calling the functionality of diffrenet triggers  on user object ,US11103.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class UserTriggerHandler {
    
    /**		
	   * This Method is responsible for UpdateContactLanguage functionality,US11103.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param list of user.		
	   * @return void.		
	  */
    public static void UpdateContactLanguage(list<user> Usr )
    {

        List<Id> userIds = new List<Id>();
            for(User u : Usr){
                if(u.ContactId != null){
                    userIds.add(u.Id);
                }
            }

            UpdateContactLanguageTriggerHandler.updateContacts(userIds);
    
}
    /**		
	   * This Method is responsible for UpdateContactLanguage functionality,US11103.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param list of user and a map of user.		
	   * @return void.		
	  */
    public static void UpdateContactLanguage1(list<user> Usr , Map<Id , User> OldMap)
    {
        
            Map<ID, String> contactMap = new Map<ID,String>();
            for(User u : Usr) {
                if(u.ContactId != null){
                    User oldUser = oldMap.get(u.Id);

                    if (oldUser.LanguageLocaleKey != u.LanguageLocaleKey){
                        contactMap.put(u.ContactId,u.LanguageLocaleKey);
                    }
                }
            }

            List<Contact> contacts = new List<Contact>();

            for(Id c : contactMap.keySet()){
                Contact contact = new Contact();
                contact.ID = c;
                contact.User_Language__c = contactMap.get(c);
                contacts.add(contact);
            }
            update contacts;

    }
    /**		
	   * This Method is responsible for Disable_Id functionality,US11103.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param list of user.		
	   * @return void.		
	  */
     public static void Disable_Id(list<user> Usr)
    {
        Set<id> cntct_ids = new Set<id>();
        Map<id,User> map_var= new Map<id,User>();
        for(User us_er: Usr)
      {
       if(!us_er.isPortalEnabled)
        {
          
           for(User user : Usr)
           {
            map_var.put(user.contactId,user);
            }           
         }
       }
        if(!System.IsBatch() && !system.isFuture() && !Test.isRunningTest())
        Utils.updateContact_User(map_var.keyset());       
     
   }     


}