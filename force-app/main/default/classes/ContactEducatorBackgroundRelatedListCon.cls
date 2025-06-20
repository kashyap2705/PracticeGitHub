public class ContactEducatorBackgroundRelatedListCon{
    
    public List<IB_E_Background__c> backgroundList {get; private set;}
    public String contactId{get;set;}
    
    public ContactEducatorBackgroundRelatedListCon(ApexPages.StandardController stdc){
    	this.contactId = stdc.getRecord().Id;// ApexPages.currentPage().getParameters().get('id');
    	backgroundList = new List<IB_E_Background__c>(); 
        loadEducatorBackground();
    }
    
    private void loadEducatorBackground(){
        // Query for the contact's background records
        /*
            ID,Record Type,Language,Language Delivery,Educational Degree,
			Field of Study,School University,Country,IB Workshop Title,IB Role
		*/
        
        backgroundList = [SELECT Name, RecordType.Name,Language__c,Language_Delivery__c,
                          Educational_Degree__c, Field_of_Study__c, School__c, Country__c,
                          IB_Workshop_Title__c, Role__c 
                          FROM IB_E_Background__c WHERE IB_Contact__c = :contactId];
    }
    
}