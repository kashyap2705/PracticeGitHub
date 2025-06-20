/**
* <h1>Contact Deletion</h1>
* This class is responsible for Deleting the Invited Contact,US-10851
* 
* @author  Abd ur Rehman
* @version 1.0
* @since   07-22-2019 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

  
*/
public class DeleteNewContactMadeforRole {
    /**
   * This method is used to delete the invited contact.
   * If the related invited role is merge with an existing contact
   * @param  contactid This is the first parameter of DeleteContact
   * @return null This method returns the null.
   */
     @future public static void DeleteContact(id contactid)  
     {
     try {
         //Query the Contact Data
         if(contactid != null){
         contact theContactRecord = new contact();
         theContactRecord = [select id from contact where id=:contactid Limit 1];
         //Delete Contact
         if(theContactRecord != null)
         delete theContactRecord;
         }
         }
         catch(Exception ex) {
         System.debug('Error in deletion of contact: '+ex);
     }
}
}