public class ContactEmailDAO {

	private static final ContactEmailDAO instance = new ContactEmailDAO();
	
    private List<ContactEmail__c> emailRecs;
	private ContactEmail__c emailRec;
	
	private ContactEmailDAO() {}

	public static ContactEmailDAO getInstance() {
		return instance;
	}
    
    public List<ContactEmail__c> getEmailsByAccount(Id accountId) { 

		emailRecs = [
			SELECT Id, Name, Contact__c, Account__c, EmailAddress__c 
			FROM ContactEmail__c 
			WHERE Account__c = :accountId 
		];

		return emailRecs;

	}

	public ContactEmail__c getEmailByAccountAndContact(Id accountId, Id contactId) { 

		List<ContactEmail__c> emailRecs = [
			SELECT Id, Name, Contact__c, Account__c, EmailAddress__c 
			FROM ContactEmail__c 
			WHERE Account__c = :accountId 
			AND Contact__c = :contactId 
			LIMIT 1
		];

		if (emailRecs.isEmpty()) {
			return null;
		}
		else {
			emailRec = emailRecs.get(0);
		}

		return emailRec;

	}
    
    public ContactEmail__c getEmailByContact(List<ContactEmail__c> contactEmails, Id contactId) { 
		
        // wipe out emailRec if it exists
        emailRec = null;
        
        for (ContactEmail__c email : contactEmails) {
            if (email.Contact__c == contactId) {
                emailRec = email;
                break;
            }
        }

		return emailRec;

	}

}