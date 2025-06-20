public without sharing class MyContactDAO {

   public static final MyContactDAO INSTANCE = new MyContactDAO();

   private MyContactDAO () {

    }
    
    /** Added by Kashyap as a part of ECM 00503 **/
    public List<IB_Role__c> getRolebyContactId (String id) {

      List<IB_Role__c> roleList=  [SELECT Id,IB_Contact__c, Status__c
                                    FROM IB_Role__c
                                    WHERE IB_Contact__c =: id limit 1];
        return roleList;
    }
        /** End ofaddition by Kashyap as a part of ECM 00503 **/

    public Contact getContactbyId (String id) {

        if ( String.isBlank(id)) {
            throw new DAOException('The ID cannot be zero or an empty string.');

        }

        final List<Contact> result = getContactbyIds (new List<String> { id });

        if (null == result || result.isEmpty()) {
            return null;
        }

        return result.get(0);
    }


    public List<Contact> getContactbyIds (final List<String> ids) {

        if (null == ids || ids.isEmpty()) {
            throw new DAOException( ' List of ids: parameter can not be null or empty !!');

        }
        // This Part is being updated by Ammara-Plumlogix on 9-22-2019,US-11329
       //begin
        return [SELECT Name, Country__c, Do_NOT_contact_about_other_roles__c,Country__r.Name,/* Examiner_training_username__c,*/Full_time_Part_time__c,IBEN_Active__c, Country__r.Country_es__c, Country__r.Country_fr__c, Middle_Name__c, Salutation, Id, School_IBIS_Code__c, School_Name__c, Independent_Educator__c, LastName, FirstName, Email, Job_Title__c, Fax, HasOptedOutOfEmail,
                                       Phone, HomePhone,/*PYP_Interest_Areas__c,MYP_Interest_Areas__c,*/ MobilePhone, Phone_Number__c, Country_Code__c, Alternative_Email__c, Preferred_Phone__c, Birthdate,
                                       Contact.AccountId, OtherPhone, Preferred_Communication_Method__c,Title,Number_of_years_at_school__c,
                                       Preferred_Address_of_Correspondence__c, MailingStreet, OtherStreet, MailingCity, OtherCity, MailingState, MailingStateCode, OtherState, OtherStateCode, MailingPostalCode, OtherPostalCode,Global_IBEN_ID__c,
                                       MailingCountry, MailingCountryCode, OtherCountry, OtherCountryCode, Legal_first_name__c,Legal_Last_name__c,Passport_Number__c, Nationality__c, Nationality_2__c, Third_Nationality__c, Fourth_Nationality__c, Country_of_Birth__c, Place_of_Issue__c, Expiry_Date__c,
                                       NoK_Title__c, NoK_Email__c, NoK_First_Name__c, NoK_Phone__c, NoK_Last_Name__c, NoK_Mobile__c,
                                       Permission_Mobile__c, Permission_Title__c, Permission_First_Name__c, Permission_Last_Name__c, Permission_Email__c, Permission_Phone__c,
                                       Retired__c, School_Type__c, Birth_Locale__c, Qualifications__c, Contract_Signed_New__c, Contact_Type__c,IBIS_contact_ID__c,Residential_Province__c,Mailing_Province__c 
                                       FROM Contact WHERE id IN :ids ];
       //End

    }


    public List<Contact> getContactbyWere (String whereString  ) {

        if ( String.isBlank(whereString)) {
            throw new DAOException(' ContactDAO :  whereString parameter can not be null or empty string !!');

        }

        String query = 'SELECT Id, Country__c, HomePhone, LastName, FirstName, MobilePhone, Birthdate, Email, Account.Id, Account.Name, Phone, Alternative_Email__c, OtherPhone FROM Contact WHERE ' + whereString;

        List<Contact> result = new List<Contact>();

        system.debug( 'Query ' + query );

        try {


             system.debug('----- Query for selecting  ----- '+  query);

             result = (List<Contact>)Database.query(query);

             system.debug('----- Query Result Size ----- ' + result.size());

        } catch(Exception ex) {
                throw new DAOException(' ContactDAO : query ' + query +' Error ' + ex.getMessage());

        }

        return result;
    }

    public Contact getContactbyInvitationID (String id) {
    List<Contact> invitedContactList = new List<Contact>();// added by Kashyap 

        if ( String.isBlank(id)) {
            throw new DAOException('The ID cannot be zero or an empty string.');

        }

        // removed direct return of list 
        invitedContactList =  [SELECT Name, OwnerId, Number_of_years_at_school__c ,Full_time_Part_time__c, Country__c, Country__r.Name, Country__r.Country_es__c, Country__r.Country_fr__c, Middle_Name__c, Salutation, Id, School_IBIS_Code__c, School_Name__c, Independent_Educator__c, LastName, FirstName, Email, Job_Title__c, Fax, HasOptedOutOfEmail,
                                       Phone, HomePhone, MobilePhone, Alternative_Email__c, Preferred_Phone__c, Birthdate,
                                       Contact.AccountId, OtherPhone, Preferred_Communication_Method__c,Title,
                                       Preferred_Address_of_Correspondence__c, MailingStreet, OtherStreet, MailingCity, OtherCity, MailingState, MailingStateCode, OtherState, OtherStateCode, MailingPostalCode, OtherPostalCode,Global_IBEN_ID__c,
                                       MailingCountry, MailingCountryCode, OtherCountry, OtherCountryCode, Legal_first_name__c,Legal_Last_name__c, Passport_Number__c, Nationality__c, Nationality_2__c, Third_Nationality__c, Fourth_Nationality__c, Country_of_Birth__c, Place_of_Issue__c, Expiry_Date__c,
                                       NoK_Title__c, NoK_Email__c, NoK_First_Name__c, NoK_Phone__c, NoK_Last_Name__c, NoK_Mobile__c,
                                       Permission_Mobile__c, Permission_Title__c, Permission_First_Name__c, Permission_Last_Name__c, Permission_Email__c, Permission_Phone__c,
                                       Retired__c, School_Type__c, Birth_Locale__c, Qualifications__c, Contract_Signed_New__c, Contact_Type__c,RecordType.Name,IBIS_contact_ID__c,Invitation_ID__c// added Invitation_ID__c by kashyap
                                       FROM Contact WHERE Invitation_ID__c =: id LIMIT 1];
        
        /**added by Kashyap **/
        if(invitedContactList.size() >0)
        {
            return invitedContactList[0];
        }else
        {
            return null;
        }
        /**added by Kashyap **/    
    }

    public Contact getContactbyEmail (String contactEmail) {

        if ( String.isBlank(contactEmail)) {
            throw new DAOException('The ID cannot be zero or an empty string.');

        }

        return [SELECT Name, OwnerId, Number_of_years_at_school__c, Full_time_Part_time__c, Country__c, Country__r.Name, Country__r.Country_es__c, Country__r.Country_fr__c, Middle_Name__c, Salutation, Id, School_IBIS_Code__c, School_Name__c, Independent_Educator__c, LastName, FirstName, Email, Job_Title__c, Fax, HasOptedOutOfEmail,
                                       Phone, HomePhone, MobilePhone, Alternative_Email__c, Preferred_Phone__c, Birthdate,
                                       Contact.AccountId, OtherPhone, Preferred_Communication_Method__c,Title,
                                       Preferred_Address_of_Correspondence__c, MailingStreet, OtherStreet, MailingCity, OtherCity, MailingState, MailingStateCode, OtherState, OtherStateCode, MailingPostalCode, OtherPostalCode,Global_IBEN_ID__c,
                                       MailingCountry, MailingCountryCode, OtherCountry, OtherCountryCode, Legal_first_name__c,Legal_Last_name__c,Passport_Number__c, Nationality__c, Nationality_2__c, Third_Nationality__c, Fourth_Nationality__c, Country_of_Birth__c, Place_of_Issue__c, Expiry_Date__c,
                                       NoK_Title__c, NoK_Email__c, NoK_First_Name__c, NoK_Phone__c, NoK_Last_Name__c, NoK_Mobile__c,
                                       Permission_Mobile__c, Permission_Title__c, Permission_First_Name__c, Permission_Last_Name__c, Permission_Email__c, Permission_Phone__c,
                                       Retired__c, School_Type__c, Birth_Locale__c, Qualifications__c, Contract_Signed_New__c, Contact_Type__c
                                       FROM Contact WHERE User_Username__c =: contactEmail LIMIT 1];
        
        
    }

}