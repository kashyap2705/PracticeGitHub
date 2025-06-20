public without sharing class MyStaffingEventRedirectionController extends RedirectionHandlerController  {
	
	private final Map <String, MyStaffingEventRedirectionRules__c> rules = MyStaffingEventRedirectionRules__c.getAll();
  
    public MyStaffingEventRedirectionController (ApexPages.StandardController stdController) {
       
    }
    
    @TestVisible
    protected override String getUrl() {

        String defaultUrl = '';
        
    	final String communityName = String.isEmpty(System.Site.getName())? INTERNAL_COMMUNITY : System.Site.getName() ;
    	
    	final Set <String> profiles = new Set <String> ();
    	                     
        final MyStaffingEventRedirectionRules__c rule = rules.get(communityName); 
                                                                               
        for (String id : rule.ids__c.split(',', -2) ) {
            profiles.add(id);
            
        }

        if (profiles.contains((Userinfo.getProfileId()).substring(0,15) ) ) {
    	     defaultUrl = rule.url__c; 
    	}
    	
    	return defaultUrl;
    	
    } 
    
}