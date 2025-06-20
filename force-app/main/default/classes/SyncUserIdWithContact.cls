public class SyncUserIdWithContact {
	@future
	public static void SyncUserIdWithContact (Set<Id> contactIds) {
		system.debug('contactIds: ' + contactIds);
		List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId in :contactIds];
		List<Contact> contacts = new List<Contact>();
		system.debug('users: ' + users);
		for(User u:users){
			contacts.add(new Contact(Id = u.ContactId, User__c = u.Id));
		}
		system.debug('contacts: ' + contacts);
        try{
		update contacts;
        }
        catch(Exception e){
            String error = e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
        }
	}
    	public static void SyncUserIdWithContactnonfuture (Set<Id> contactIds) {
		system.debug('contactIds: ' + contactIds);
		List<User> users = [SELECT Id, ContactId FROM User WHERE ContactId in :contactIds];
		List<Contact> contacts = new List<Contact>();
		system.debug('users: ' + users);
		for(User u:users){
			contacts.add(new Contact(Id = u.ContactId, User__c = u.Id));
		}
		system.debug('contacts: ' + contacts);

		update contacts;
	}    
}