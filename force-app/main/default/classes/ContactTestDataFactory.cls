/**
*  @description -This is used to Test the instance of List of Contacts
* 
* Ticket: US-0002499
*
* @author: Vikash Kumar
* @since 22-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 22-10-2024      Created             US-0002499       Created the class
* 28-03-2025      Modified			  US-0002473       Cacheing Record Type IDs to reduce SOQL calls
*/
@isTest
public without sharing class ContactTestDataFactory {
    
    private final static String HOMEEMAIL = 'testContact@test.com';
    private final static String FIRSTNAME = 'TestFirstName';
    private final static Date BIRTHDATE = Date.today().addDays(-10000);

    // Static cache for Record Type IDs
    private static Map<String, String> recordTypeIdCache = new Map<String, String>();
	
    /**
     * @description -  Creates a list of Contact records        
     * @param recordTypeName - record Type name to be used for record
     * @param tempContact - template Contact record to clone (can be null)   
     * @param nContacts   - number of records to create  
     * @return  `List<Contact>`
     */
    public static List<Contact> createContacts(String recordTypeName, Contact tempContact, Integer nContacts) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < nContacts; i++) {
            Contact con = (tempContact != null) ? tempContact.clone(false) : new Contact();
            con = createContactInstance(con, recordTypeId);
            contacts.add(con);
        }
        return contacts;
    }
	
    /**
    * @description - Creates a single Contact record
    * @param recordTypeName - record Type name to be used for record
    * @param tempContact - template Contact record to clone (can be null)
    * @return Contact record
    */
    public static Contact createContact(String recordTypeName, Contact tempContact) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        Contact con = (tempContact != null) ? tempContact.clone(false) : new Contact();
        con = createContactInstance(con, recordTypeId);
        return con;
    }
	
    /**
    * @description - Retrieves the Record Type Id for a given Record Type Name associated with the Contact object.
    * @param recTypeName - The name of the Record Type to retrieve the Id for.
    * @return String - The Id of the Record Type corresponding to the given name. If the specified Record Type name is not found, the method will return the Id of the first available Record Type.
    */
    public static String getRecordTypeId(String recTypeName) {
        // Check cache first
        if (recordTypeIdCache.containsKey(recTypeName)) {
            return recordTypeIdCache.get(recTypeName);
        }

        String recTypeId = '';
        try {
            recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch (Exception e) {
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' LIMIT 1].Id;
        }
        recordTypeIdCache.put(recTypeName, recTypeId);
        return recTypeId;
    }
	
    /**
    * @description - Populates fields of an Contact instance
    * @param contactRecord - the record to populate fields
    * @param recordTypeId - the recordtype id to assign record type to new record
    * @return Contact with populated fields
    */
    public static Contact createContactInstance(Contact contactRecord, String recordTypeId) {
        Contact contactInstance = contactRecord;
        if (recordTypeId != null) {
            contactInstance.RecordTypeId = recordTypeId;
        }
        contactInstance.FirstName = String.isBlank(contactRecord.FirstName) ? FIRSTNAME : contactRecord.FirstName;
        contactInstance.LastName = String.isBlank(contactRecord.LastName) ? TestDataUtility.generateRandomString(5) : contactRecord.LastName;
        contactInstance.Email = String.isBlank(contactRecord.Email) ? HOMEEMAIL : contactRecord.Email;
        contactInstance.Birthdate = String.isBlank(String.valueOf(contactRecord.Birthdate)) ? BIRTHDATE : contactRecord.Birthdate;
        if (String.isBlank(contactRecord.AccountId)) {
            Account ibAccount = AccountTestDataFactory.createAccount(null, null);
            insert ibAccount;
            contactInstance.AccountId = ibAccount.Id;
        } else {
            contactInstance.AccountId = contactRecord.AccountId;
        }
        return contactInstance;
    }
}