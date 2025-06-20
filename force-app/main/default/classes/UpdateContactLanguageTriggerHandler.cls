public class UpdateContactLanguageTriggerHandler {
    @future
    static public void updateContacts(List<ID> userIds){
        List<User> users = [SELECT Id,ContactId,LanguageLocaleKey From User WHERE Id in :userIds];
        Map<ID, String> contactMap = new Map<ID,String>();
        for(User u : users){
            contactMap.put(u.ContactId,u.LanguageLocaleKey);
        }
        
        List<Contact> contacts = new List<Contact>();
        
        for(Id c : contactMap.keySet()){
                Contact contact = new Contact();
                contact.ID = c;
                contact.User_Language__c = contactMap.get(c);
                contact.User_IsActive_Portal__c  = true;
                contacts.add(contact);
        }
            system.debug('Added by uma in updatedtrigger handler');
        update contacts;
        
        
    }
}