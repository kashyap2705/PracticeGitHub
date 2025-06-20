public with sharing class PreventChatterUploadDataForProfile {
    
    private final NotAllowedChatterProfiles__c nameOfNotAllowedProfileProp;
    
    public PreventChatterUploadDataForProfile () {
        try
        {
            
            nameOfNotAllowedProfileProp = NotAllowedChatterProfiles__c.getInstance('NotAllowedChatterProfiles'); 
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
    
    public boolean isAllowedUserProfile() {
        try
        {
            System.debug('nameOfNotAllowedProfileProp==='+nameOfNotAllowedProfileProp);
            if (null == nameOfNotAllowedProfileProp) {
                throw new ControllerException(Label.IBENPortal_Error_NoCustomSettingChatterPrevention + 'NotAllowedChatterProfiles.');            
            }
            
            final Set<String> notAllowedProfileIds = new Set <String>();
            
            for (String id : nameOfNotAllowedProfileProp.ids__c.split(',', -2) ) {
                notAllowedProfileIds.add(id);
            }
            if (notAllowedProfileIds.contains(((String)userinfo.getProfileId()).substring(0,15))) {
                return false;
            }
            
            return true;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return false;
        }
    }
    
}