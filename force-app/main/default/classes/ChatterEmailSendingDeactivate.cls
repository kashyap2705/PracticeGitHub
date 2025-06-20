global class ChatterEmailSendingDeactivate implements Database.Batchable<sObject> 
{
    
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        if(Test.isRunningTest())
        {
            
            return Database.getQueryLocator([SELECT ID,UserPreferencesDisableAllFeedsEmail, ContactId, Contact.Firstname FROM User WHERE isActive = true AND ContactId NOT IN(SELECT IB_Contact__c FROM IB_Role__c WHERE status__c='Confirmed')AND IsPortalEnabled=true AND UserPreferencesDisableAllFeedsEmail=false LIMIt 200]);
            
        }
        
        else
        {
            
            
            return Database.getQueryLocator([SELECT ID,UserPreferencesDisableAllFeedsEmail, ContactId, Contact.Firstname FROM User WHERE isActive = true AND ContactId NOT IN(SELECT IB_Contact__c FROM IB_Role__c WHERE status__c='Confirmed')AND IsPortalEnabled=true AND UserPreferencesDisableAllFeedsEmail=false]);
        }
    }
    
    
    
    global void execute(Database.BatchableContext bc, List<User> scope){
        
        LIST<user> confirmendUsers=new List<user>();
		confirmendUsers=[SELECT ID, ContactId,UserPreferencesDisableAllFeedsEmail, Contact.Firstname FROM User WHERE isActive = true AND ContactId IN(SELECT IB_Contact__c FROM IB_Role__c WHERE status__c='Confirmed') AND IsPortalEnabled=true AND UserPreferencesDisableAllFeedsEmail=false AND id IN:scope];        
       
        
        
        
        for(user u:scope)
        {
            if(!confirmendUsers.contains(u) &&  u.UserPreferencesDisableAllFeedsEmail==false)
            {
                u.UserPreferencesDisableAllFeedsEmail=true;
            }
            
            
        }
        if(scope.size()>0)
        Database.update(scope,false);
        
       
    }    
    
    global void finish(Database.BatchableContext bc)
    {
        
        // execute any post-processing operations
    } 
    
    
}