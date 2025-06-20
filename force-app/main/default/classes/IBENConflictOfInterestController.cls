public without sharing class IBENConflictOfInterestController {
    // public static User user=[select contact.AccountId,contactid, Name ,Email from user where id=:userInfo.getUserId()];
    public static User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public static Id contactId = user.ContactId;
   
    
    @AuraEnabled (cacheable=true)
    public static String getUserLocale() {
        return UserInfo.getLocale();
    }

   @AuraEnabled(cacheable=true)
    public static List<Conflict_of_Interest__c> getConflictOfInterests() {
        system.debug('In getConflictOfInterests');
        return [SELECT Id, Name,toLabel(Type_of_Conflict__c), Start_Date__c, End_Date__c, IB_Account__c, Description__c, IB_Contact__c,CreatedDate,IB_Account__r.Name
            FROM Conflict_of_Interest__c
            WHERE IB_Contact__c =: contactId 
            ORDER BY End_Date__c DESC];//lastmodifieddate DESC];
    }  

    @AuraEnabled(cacheable=true)
    public static List<Conflict_of_Interest__c> getConnectionConflicts() {
        system.debug('In IBENConflictOfInterestController#: getConnectionConflicts');
        return [SELECT Id, Name,toLabel(Type_of_Conflict__c), Start_Date__c, End_Date__c, IB_Account__c, Description__c, IB_Contact__c,CreatedDate,IB_Account__r.Name
            FROM Conflict_of_Interest__c
            WHERE IB_Contact__c =: contactId AND
            toLabel(Type_of_Conflict__c) = 'Connection to a school' ORDER BY lastmodifieddate DESC];
    }  


    @AuraEnabled(cacheable=true)
    public static List<Conflict_of_Interest__c> getNonConnectionConflicts() {
        system.debug('In IBENConflictOfInterestController#: getNonConnectionConflicts');
        return [SELECT Id, Name,toLabel(Type_of_Conflict__c), Start_Date__c, End_Date__c,
                IB_Account__c, Description__c, IB_Contact__c,CreatedDate,IB_Account__r.Name
            FROM Conflict_of_Interest__c
            WHERE IB_Contact__c =: contactId AND
            toLabel(Type_of_Conflict__c) != 'Connection to a school'
            ORDER BY lastmodifieddate DESC];
    }  

    
    @AuraEnabled
    public static string updateConnectionConflicts(Object data) {
    
    List <Conflict_of_Interest__c> consForUpdate = (List<Conflict_of_Interest__c>) JSON.deserialize(JSON.serialize(data),List <Conflict_of_Interest__c>.class);
    try {
        update consForUpdate;
        return 'Success: Conflict updated successfully';
    }
    catch (Exception e) {
        return 'The following exception has occurred: ' + e.getMessage();
    }

    }   



}