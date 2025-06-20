/**
* <h1>Lead Conversion</h1>
* This class is responsible for converting lead to existing contact,US-11329
* 
* @author  Ammara
* @version 1.0
* @since   09-22-2019 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

  
*/
global  class LeadConversion {
    /**
   * This method is a Remote Action that called on a Button Click to convert lead to a existing Contact.
   * @param leadid This is the first paramter to LeadConversiontoExistingContact
   * @return void This function returns null.
   */
    @RemoteAction
     Webservice Static void LeadConversiontoExistingContact(id leadid){
         Lead lead_record = new Lead();
         Contact theContact = new Contact();
         //Query the Lead Record
             lead_record = [select id,Existing_Account_Related__c,isConverted,Existing_Contact_Related__c,FirstName,Title,
                             Phone,Description,Skype_Account_Name__c,LastName,Lead_Type__c,Fax,Email,Street from Lead
                             where id =: leadid 
                             AND IsConverted = false 
                             AND Existing_Contact_Related__c != null Limit 1];
            
         if(lead_record != null) {
             try{
                 //Query Existing Contact data
                 theContact = [Select id,AccountId from Contact where id =: lead_record.Existing_Contact_Related__c Limit 1];
                 //Calling Function to Convert Lead
            ConvertLead(Lead_record,theContact);
             }
             catch(Exception ex){
                 System.debug('Exception: '+ex);
             }
         }
         
     }
    /**
   * Convert Lead to Existing Contact using LeadConvert Class.
   * @param Lead_record This is the first paramter to ConvertLead
   * @param theContact  This is the second parameter to ConvertLead
   * @return void This function returns null.
   */
    public static void ConvertLead(Lead Lead_record,Contact theContact) {
    //Creating Record
    Database.LeadConvert lc = new Database.LeadConvert();
    lc.setLeadId(Lead_record.id);
    lc.setConvertedStatus('Qualified');
    lc.setContactId(Lead_record.Existing_Contact_Related__c);
    lc.setDoNotCreateOpportunity(true);
    // if lead Contain Existing Account else take contact account
    if(Lead_record.Existing_Account_Related__c != Null)
    lc.setAccountId(Lead_record.Existing_Account_Related__c);
    else
    lc.setAccountId(theContact.AccountId);
    //Calling convert Lead Function to Convert Lead
    Database.LeadConvertResult lcr = Database.convertLead(lc);
    System.assert(lcr.isSuccess());
    }
}