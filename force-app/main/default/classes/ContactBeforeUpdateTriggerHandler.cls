/*
*** Developer Name - Shahrukh Anwar
*** Developed On - 04/07/2023
*** Developed For - Contact before update logic should be written in this class
*** Initially developed for - ECM00590
*/
public class ContactBeforeUpdateTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp){
		process((List<Contact>)tp.newList);
	}

    private static void process(List<Contact> newList) {
        Map<Id, List<Contact>> contactsByCountryId = new Map<Id, List<Contact>>();

        for(Contact contact : newList) {
            if(contact.OtherStreet != NULL && contact.OtherCity != NULL && contact.OtherPostalCode != NULL) {
                if(contactsByCountryId.containsKey(contact.Country__c)) {
                    contactsByCountryId.get(contact.Country__c).add(contact);
                } else {
                    contactsByCountryId.put(contact.Country__c, new List<Contact>{contact});
                }
            }
        }

        for(IB_Country_Segmentation__c country : [SELECT Id, Name FROM IB_Country_Segmentation__c WHERE Id IN :contactsByCountryId.keyset()]) {
            for(Contact contact : contactsByCountryId.get(country.Id)) {
                contact.OtherCountry = country.Name;
            }
        }
    }
}