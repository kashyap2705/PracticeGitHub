public with sharing class roleLandingSingleRole {
    public IB_Role_Repository__c role {get; set;}
    public List<Training_Event__c> training;
    public List<IB_Role__c> application;
    public String userRegion {get;set;}
    User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    public List<IB_Role__c> getApplication(){
        return [Select Programme_Selection__c, Id, IB_Role_Name__c, Status__c From IB_Role__c where IB_Contact__c = :user.ContactId AND IB_Role_Name__c = :role.Role_Name__c LIMIT 1];
    }
    
    public List<Training_Event__c> getTraining(){
        return [SELECT id, IB_Event_Name__c, IB_Programme__c, Training_Event_Country__c, Training_Event_Region__c, Start_Date__c, End_Date__c, IB_Role_2__r.id, IB_Role_3__r.id, IB_Role__r.id
                  FROM Training_Event__c
                 WHERE End_Date__c > TODAY
                 AND Application_Deadline__c >= TODAY
                 AND Training_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Completed')
                 AND Training_Event_Region__c = :userRegion];
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
}