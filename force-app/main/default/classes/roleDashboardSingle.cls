public with sharing class roleDashboardSingle {
    public IB_Role_Repository__c role {get; set;}
    User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public List<IB_Role__c> application = new List<IB_Role__c>();
    public boolean isAdvanced;
    
    public boolean getIsAdvanced(){
        if(role.Training_Model__c == 'Advanced Training'){
            integer count = 0;
            List<IB_Role_Repository__c> rolesMaster = IBRoleRepositoryDAO.INSTANCE.getAvailableRoles();
            List<IB_Role__c> applications = [Select id From IB_Role__c 
                                                       WHERE IB_Contact__c = :user.ContactId 
                                                       AND IB_Role_Category__c = :role.Category__c
                                                       AND Status__c = 'Confirmed'
                                                       AND IB_Role__r.Display_In_PIMS_Community__c = false];
            
            
             if(applications.size() > 0){
              return true;
             } else {
              return false;
             }                               

            /*for(IB_Role_Repository__c r: rolesMaster){
              if(r.Category__c == role.Category__c && r.Training_Model__c != 'Advanced Training'){
                  count += 1;
              }
            }
            
           System.debug('**** number of initial roles: ' + count);
           System.debug('**** number of applications: ' + applications.size());


            if(count <= applications.size()){
                return true;
            }
            else{
                return false;
            }*/
                                                              
        }
        else{
            return true;
        } 
    }
    
    public List<IB_Role__c> getApplication(){
        return [Select Status__c, IB_Role_Category__c,IB_Role_Level__c From IB_Role__c where IB_Contact__c = :user.ContactId AND IB_Role_Name__c = :role.Role_Name__c LIMIT 1];
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
}