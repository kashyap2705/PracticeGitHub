public class ContactService {

     public static Contact contact = null;
     public static List<Contact> contacts = null;
     public static List<Contact> contactsByAccount = null;
     public static List<Contact> contactsByIdSet = null;
     public static List<Contact> contactsByIdAndAccountSet = null;

     public static Boolean isContactCached = false;
     public static Boolean isContactsCached = false;
     public static Boolean isContactsByAccountCached = false;
     public static Boolean isContactsByIdSetCached = false;
     public static Boolean isContactsByIdAndAccountSetCached = false;
     public static Boolean isContactsForAccountCached = false;

     public static Id contactId = null;
     public static Id accountId = null;
     public static Set<Id> idSet = null;

     public static void queryContactById() {

        ContactDAO dao = ContactDAO.getInstance();
        contact = dao.getContactByUserId(contactId);
         system.debug('added by uma inline 24 contact'+contact);
        isContactCached = true;

    }

    public static Contact getContact() {

        if (!isContactCached) {
               queryContactById();
               isContactCached = true;
            system.debug('added by uma inline 34 isContactCached'+isContactCached);
        }

        return contact;
    }

     public static List<Contact> getContacts() {

          if (!isContactsCached) {

               queryContactsByAccount();

               RoleService.setAccountId(accountId);
               List<IB_Role__c> roles = RoleService.getRolesByAccountId();

               List<Contact> allContacts = new List<Contact>();
               idSet = new Set<Id>();

               for (Contact con : contactsByAccount) {
                    idSet.add(con.Id);
               }

               for (IB_Role__c role : roles) {
                    idSet.add(role.IB_Contact__c);
               }

               queryContactsByIdSet();
               contacts = contactsByIdSet;
               isContactsCached = true;
          }

          return contacts;
     }

     public static List<Contact> getContactsForAccount() {

          if (!isContactsForAccountCached) {

               queryContactsByAccount();

               RoleService.setAccountId(accountId);
               List<IB_Role__c> roles = RoleService.getRolesByAccountId();

               List<Contact> allContacts = new List<Contact>();
               idSet = new Set<Id>();

               for (Contact con : contactsByAccount) {
                    idSet.add(con.Id);
               }

               for (IB_Role__c role : roles) {
                    idSet.add(role.IB_Contact__c);
               }

               system.debug('idSet: ' + idSet);

               queryContactsByIdSetAndAccount();
               contacts = contactsByIdAndAccountSet;
               isContactsForAccountCached = true;
          }

          system.debug('contacts from getcontactsforaccount: ' + contacts);

          return contacts;
     }
    
     /** Added getInvitedContactsForAccount by Kashyap to display only Invited contacts ***/
    //  IB_Programme_New__r.Agreement_Type__c, IB_Programme_New__r.RecordType.DeveloperName added by Kashyap for ECM00635
    public static List<Contact> getInvitedContactsForAccount() {
        
        system.debug('insdie of getInvitedContactsForAccount: ' );
        
        List<IB_Role__c> roles = [
            SELECT Id, Name,Email__c,ContactUserLanguage__c,Contact_name__c,RecordType.Name,RecordTypeId, Status__c, IB_Contact__c, IB_Contact__r.RecordTypeId, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
            IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name,IB_Contact__r.Email, 
            IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
            IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c, IB_Contact__r.Invitation_ID__c, IB_Programme_New__r.Agreement_Type__c, IB_Programme_New__r.RecordType.DeveloperName
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId AND Status__c = 'Invited'
            AND (End_Date__c = null OR End_Date__c > TODAY)
            ORDER BY IB_Contact__c
        ];
        system.debug('roles in getInvitedContactsForAccount' + roles);
        List<Contact> allContacts = new List<Contact>();
        idSet = new Set<Id>();
        
        
        for (IB_Role__c role : roles) {
            idSet.add(role.IB_Contact__c);
        }
        
        system.debug('idSet check in getInvitedContactsForAccount: ' + idSet);
        
        try
        {
            //IB_Programme_New__r.Agreement_Type__c, IB_Programme_New__r.RecordType.DeveloperName added new field by Kashyap ECM00635
            contacts = [
                SELECT Id, OwnerId, Name, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
                Phone, Country_Code__c, Phone_Number__c, RecordTypeId, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c, createddate,EmailReminderDateTime__c, //Added CreatedDate,EmailReminderDateTimeCustom__c by Kashyap as a part of ECM003-Miscellaneous functionalities on Invited Contact 
                (SELECT IB_Programme_New__r.RecordType.Name,Programme_Type_FR__c,Programme_Type_ES__c, Programme_Type__c,Status__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,IB_Role_Name__c ,IB_Programme_New__r.Agreement_Type__c,IB_Programme_New__r.RecordType.DeveloperName FROM IBEN_Roles1__r WHERE IB_Account__c = :accountId AND (End_Date__c > TODAY OR End_Date__c = NULL) And Status__c = 'Confirmed' ORDER BY Programme_Type__c,IB_Role_Name__c)
                FROM Contact
                WHERE Id IN :idSet
                ORDER BY LastName ASC
            ];
            
            system.debug('Contacts: ' + contacts);
            
            return contacts;
        }catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }
        
        
        
        //system.debug('contacts from getcontactsforaccount: ' + contacts);
        
       // return contacts;
    }
    /** End of  getInvitedContactsForAccount by Kashyap to display only Invited contacts ***/
    
    /** Added getConfimedContactsForAccount by Kashyap to display only confirmed contacts ***/
    public static List<Contact> getConfirmedContactsForAccount() {

        List<IB_Role__c> roles = [
            SELECT Id, Name,Email__c,ContactUserLanguage__c,Contact_name__c,RecordType.Name,RecordTypeId, Status__c, IB_Contact__c, IB_Contact__r.RecordTypeId, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
            IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name,IB_Contact__r.Email, 
            IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
            IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c, IB_Contact__r.Invitation_ID__c
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId AND Status__c = 'Confirmed'
            ORDER BY IB_Contact__c
        ];
        system.debug('roles in getConfirmedContactsForAccount' + roles);
        List<Contact> allContacts = new List<Contact>();
        idSet = new Set<Id>();
        
        
        for (IB_Role__c role : roles) {
            idSet.add(role.IB_Contact__c);
        }
        
        system.debug('idSet check in getConfirmedContactsForAccount: ' + idSet);
        
        try
        {
            //Added by Kashyap for ECM00635 IB_Programme_New__r.Agreement_Type__c 
            contacts = [
                SELECT Id, OwnerId, Name, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
                Phone, Country_Code__c, Phone_Number__c, RecordTypeId, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c,
                (SELECT IB_Programme_New__r.RecordType.Name,Programme_Type_FR__c,Programme_Type_ES__c, Programme_Type__c,Status__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,IB_Role_Name__c ,IB_Programme_New__r.Agreement_Type__c FROM IBEN_Roles1__r WHERE IB_Account__c = :accountId AND (End_Date__c > TODAY OR End_Date__c = NULL) And Status__c = 'Confirmed' ORDER BY Programme_Type__c,IB_Role_Name__c)
                FROM Contact
                WHERE Id IN :idSet
                ORDER BY LastName ASC
            ];
            
            system.debug('Contacts: ' + contacts);
            
            return contacts;
        }catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }
        
        
    }
    /** End of  getConfirmedContactsForAccount by Kashyap to display only Confirmed contacts ***/
    

     public static void queryContactsByAccount() {

          if (!isContactsByAccountCached) {

               if (accountId == null) {
                    throw new CustomValidationException('The value for accountId cannot be null.');
               }

               ContactDAO dao = ContactDAO.getInstance();
               contactsByAccount = dao.getContactsByAccountId(accountId);
               isContactsByAccountCached = true;
          }
     }

     public static void queryContactsByIdSet() {

          if (!isContactsByIdSetCached) {

               if (idSet == null) {
                    throw new CustomValidationException('The value for idSet cannot be null.');
               }

               ContactDAO dao = ContactDAO.getInstance();
               contactsByIdSet = dao.getContactsByContactIdList(idSet);
               isContactsByIdSetCached = true;
          }
     }

     public static void queryContactsByIdSetAndAccount() {

          if (!isContactsByIdAndAccountSetCached) {

               if (idSet == null) {
                    throw new CustomValidationException('The value for idSet cannot be null.');
               }

               ContactDAO dao = ContactDAO.getInstance();
               contactsByIdAndAccountSet = dao.getContactsByContactIdList(idSet, accountId);
               isContactsByIdAndAccountSetCached = true;
          }
     }

     public static void setIdSet(Set<Id> contactsIdSet) {
          idSet = contactsIdSet;
     }

     public static void setAccountId(Id accId) {
          accountId = accId;
     }

     public static void setContactId(Id conId) {
          contactId = conId;
     }
}