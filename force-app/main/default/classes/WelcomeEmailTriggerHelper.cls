public with sharing class WelcomeEmailTriggerHelper {
	@TestVisible private static EmailTemplate et; 
	@TestVisible private static Map<Id,User> oldUserMap;
	@TestVisible private static Map<String,OrgWideEmailAddress> owea;

	public static EmailTemplate getEt(){
        try
        {
		if(et == null){
			et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Community_Welcome_Email'];
		}

		return et;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return null;
        }
	} 

	public static void resetUserMap(){
		oldUserMap = null;
	}

	public static Map<Id,User> getoldUserMap(List<Id> users){
        try
        {
        
		if(oldUserMap == null){
			oldUserMap = new Map<Id,User>([SELECT Id,Profile.Name,isActive,LastLoginDate From User WHERE Id in :users]);
		}

            return oldUserMap;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return null;
        }
	} 

	public static Map<String,OrgWideEmailAddress> getOrgWideEmails(){
        try
        {
		if(owea == null){
			owea = new Map<String,OrgWideEmailAddress>();
			List<OrgWideEmailAddress> emailAddresses = [SELECT Id,Address,DisplayName FROM OrgWideEmailAddress WHERE Address in ('ibcommunities.noreply@ibo.org')];

			for(OrgWideEmailAddress o : emailAddresses){
				owea.put(o.Address, o);
			}
		}

		return owea;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return null;
        }

	}

}