public class ContactEmailService {

	public static ContactEmail__c emailRec = null;
    public static List<ContactEmail__c> emailRecs = null;

	public static Boolean isEmailRecCached = false;
    public static Boolean isEmailsByAccountCached = false;

    public static Id contactId = null;
	public static Id accountId = null;
    
    public static List<ContactEmail__c> getEmailsByAccount() {
        
        if (!isEmailsByAccountCached) {
            
            if (accountId == null) {
				throw new CustomValidationException('The value for accountId cannot be null.');
			}
            
            ContactEmailDAO dao = ContactEmailDAO.getInstance();
            emailRecs = dao.getEmailsByAccount(accountId);
            isEmailsByAccountCached = true;
            
        }
        
        return emailRecs;
        
    }
    
    public static ContactEmail__c getEmailRec() {
        
        if (!isEmailRecCached) {
            
            getEmailsByAccount();

			if (contactId == null) {
				throw new CustomValidationException('The value for contactId cannot be null.');
			}

			ContactEmailDAO dao = ContactEmailDAO.getInstance();
            if (!emailRecs.isEmpty()) {
                emailRec = dao.getEmailByContact(emailRecs, contactId);
            }
			//emailRec = dao.getEmailByAccountAndContact(accountId, contactId);
			isEmailRecCached = true;

		}

		return emailRec;
        
    }

	public static void setContactId(Id conId) {
		contactId = conId;
	}

	public static void setAccountId(Id accId) {
		accountId = accId; 
	}

}