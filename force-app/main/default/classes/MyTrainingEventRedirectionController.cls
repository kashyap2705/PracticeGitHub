public with sharing class MyTrainingEventRedirectionController extends RedirectionHandlerController  {
	
	private final Map <String, MyTrainingEventRedirectionRules__c> rules = MyTrainingEventRedirectionRules__c.getAll();
  
    public MyTrainingEventRedirectionController (ApexPages.StandardController stdController) {
       
    }
    
    protected override String getUrl() {

        String defaultUrl = '';
        
    	final String communityName = String.isEmpty(System.Site.getName())? INTERNAL_COMMUNITY : System.Site.getName() ;
    	
    	final Set <String> profiles = new Set <String> ();
    	                     
        final MyTrainingEventRedirectionRules__c rule = rules.get(communityName); 
                                                                               
        for (String id : rule.ids__c.split(',', -2) ) {
            profiles.add(id);
            
        }

        if (profiles.contains((Userinfo.getProfileId()).substring(0,15) ) ) {
    	     defaultUrl = rule.url__c; 
    	}
    	
    	return defaultUrl;
    	
    } 
    
}