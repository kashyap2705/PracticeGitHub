public class ContactDAO {

	private static final ContactDAO instance = new ContactDAO();
	private Contact contact;
	private List<Contact> contacts;

	private ContactDAO() {}

	public static ContactDAO getInstance() {
		return instance;
	}
	// Following code is added by Umair-Plumlogix of SA Project of US12186 on 3/22/2021
	// Start
	public Contact getContactByUserId(Id contactId) {
        system.debug('ContactDAO.getContactByUserId - contactId: ' + contactId);
        try{

		contact = [
			SELECT Id, Country_Code__c, Phone_Number__c, OwnerId, Name, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
				Phone, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, Account.recordtypeid, AccountId, Account.Name, Qualifications__c, Email_Reminder__c,
				Country__c, Country_of_Birth__c, Birth_Locale__c, Alternative_Email__c, HomePhone, Account.IBIS_ID__c, Invitation_ID__c, IBIS_contact_ID__c 
			FROM Contact
			WHERE Id = :contactId
		];
	
//End
		return contact;
        }
        catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }

	}

	public List<Contact> getContactsByAccountId(Id accountId) {

        try
        {
		contacts = [
			SELECT Id, OwnerId, Name,  Country_Code__c, Phone_Number__c, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
				Phone, Invitation_ID__c, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c,RecordTypeId
			FROM Contact
			WHERE AccountId = :accountId
			ORDER BY LastName ASC
		];

		return contacts;
        }
        catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }

	}

	public List<Contact> getContactsByContactIdList(Set<Id> contactSet) {

        
        try
        {
		contacts = [
			SELECT Id, OwnerId, Name, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,IBIS_contact_ID__c,RecordTypeId, Country_Code__c, Phone_Number__c, Phone, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c, Invitation_ID__c,
				(SELECT IB_Programme_New__r.RecordType.Name,Programme_Type_FR__c,Programme_Type_ES__c, Programme_Type__c,Status__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,IB_Role_Name__c FROM IBEN_Roles1__r ORDER BY Programme_Type__c,IB_Role_Name__c)
			FROM Contact
			WHERE Id IN :contactSet
			ORDER BY LastName ASC
		];

		return contacts;
        }
        catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }

	}

	public List<Contact> getContactsByContactIdList (Set<Id> contactSet, Id accountId) {

		system.debug('Contactset: ' + contactSet);
		system.debug('accountId: ' + accountId);

        try
        {
		contacts = [
			SELECT Id, OwnerId, Name, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
				Phone, Country_Code__c, Phone_Number__c, RecordTypeId, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c,
				(SELECT IB_Programme_New__r.RecordType.Name,Programme_Type_FR__c,Programme_Type_ES__c, Programme_Type__c,Status__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,IB_Role_Name__c FROM IBEN_Roles1__r WHERE IB_Account__c = :accountId AND (End_Date__c > TODAY OR End_Date__c = NULL) And Status__c = 'Confirmed' ORDER BY Programme_Type__c,IB_Role_Name__c)
			FROM Contact
			WHERE Id IN :contactSet
			ORDER BY LastName ASC
		];

		system.debug('Contacts: ' + contacts);

		return contacts;
        }
        catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }
 
	}

     public List<Contact> searchContactsByNameAndAccount(String searchTerm, ID AccountId) {

         try{
          List<Contact> contacts = Database.query('SELECT Id, Name FROM Contact WHERE Contact.AccountId = :AccountId AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
          return contacts;
         }
         catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }

     }
    
    //INC0214000 Benjamin McGarvey, needed a way to get related contacts due to HOS/PC role that arent directly linked
    Public List<Contact> GetContactsByAccountHOSPCNoDirectRelation(Id accountId) {

        try
        {
			List<IB_Role__c> ibRoles = [select id, IB_Contact__c,IB_Contact__r.id from IB_Role__c where (IB_Role_Name__c='Programme Coordinator' OR IB_Role_Name__c='Head of School' OR IB_Role_Name__c='Head of School (Overall)') AND  IB_Account__r.id=:accountId AND active__c=true ];		
			List<Id> conIds=new List<Id>();
            for(IB_Role__c ibRole:ibRoles){
                conIds.add(ibRole.IB_Contact__r.id);
            }
			
        	List<Contact> contacts2 = [
                SELECT Id, OwnerId, Name,  Country_Code__c, Phone_Number__c, Salutation, FirstName, LastName, Title, Job_Title__c, Professional_Email__c, Email, Birthdate,
                    Phone, Invitation_ID__c, MobilePhone, Number_of_years_at_school__c, Full_time_Part_time__c, AccountId, Account.Name, Account.IBIS_ID__c, Qualifications__c, Email_Reminder__c,RecordTypeId
                FROM Contact
                WHERE AccountId != :accountId
                AND id IN:conIds
                ORDER BY LastName ASC
            ];

		return contacts2;
        }
        catch(exception c)
        {
            System.debug('excep'+c);
            return Null;
        }

	}

}