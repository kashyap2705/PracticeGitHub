public class UserTriggerHelper {
    
    @TestVisible private static Id pingPermissionSetId;
    @TestVisible private static Id ccAdvProfileId;
    @TestVisible private static Id scuAdvProfileId;
    
    public static Id getPingPermissionSetId() {
        
        try
        {
            
            if (pingPermissionSetId == null) {
                PermissionSet ps = [
                    SELECT Id 
                    FROM PermissionSet 
                    WHERE Name = 'Ping_Federate_Identity_Provider' 
                    LIMIT 1
                ];
                pingPermissionSetId = ps.Id;
            }
            
            return pingPermissionSetId;       
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public static Id getCcAdvProfileId() {
        
        try
        {
            
            if (ccAdvProfileId == null) {
                Profile pro = [
                    SELECT Id 
                    FROM Profile  
                    WHERE Name = 'Customer Community Advanced' 
                    LIMIT 1
                ];
                ccAdvProfileId = pro.Id;
            }
            
            return ccAdvProfileId;    
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static Id getScuAdvProfileId() {
        
        try
        {
            
            if (scuAdvProfileId == null) {
                Profile pro = [
                    SELECT Id 
                    FROM Profile  
                    WHERE Name = 'SCU + Advanced' 
                    LIMIT 1
                ];
                scuAdvProfileId = pro.Id;
            }
            
            return scuAdvProfileId;   
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
}