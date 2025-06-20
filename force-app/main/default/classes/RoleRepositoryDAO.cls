public class RoleRepositoryDAO {
    
    private static final RoleRepositoryDAO instance = new RoleRepositoryDAO();
    
    private List<IB_Role_Repository__c> roles;
    private IB_Role_Repository__c role;
    
    public RoleRepositoryDAO() {}
    
    public static RoleRepositoryDAO getInstance() {
        return instance;
    }
    
    public IB_Role_Repository__c getRoleById(Id roleId) {
        try
        {
            
            role = [
                SELECT Id, Name, Role_Name__c,Role_Type__c, Custom_Application__c, MyIB_Use_My_School_Subjects__c, Related_Programmes__c,Category__c, Category_es__c, Category_fr__c, Role_Name_es__c, Role_Name_fr__c, Display_In_PIMS_Community__c, MyIB_Has_Subjects__c, MyIB_Has_Workshop_Titles__c, Require_Educational_Degree__c, Require_Language_Experience__c 
                FROM IB_Role_Repository__c 
                WHERE Id = :roleId 
                ORDER BY Role_Name__c 
            ];
            
            return role;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
        
    } 
    
    public List<IB_Role_Repository__c> getAllRoles() {
        try
        {
            
            roles = [
                SELECT Id, Name, Role_Name__c, Role_Name_es__c, Role_Name_fr__c, Display_In_PIMS_Community__c, Application_Available_in_MyIB__c
                FROM IB_Role_Repository__c 
                ORDER BY Role_Name__c 
            ];
            
            return roles;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    } 
    
    public List<IB_Role_Repository__c> getAllMyIBRoles() {
        try
        {
            roles = [
                SELECT Id, MyIB_Use_My_School_Subjects__c, Category__c, Category_es__c, Category_fr__c, Role_Name__c, Role_Name_es__c, Role_Name_fr__c, Role_Description__c, Role_Description_fr__c, 
                Role_Description_es__c, Role_Type__c, MyIB_Max_Number_of_this_Role__c,MyIB_Require_My_School_Approval__c, Application_Available_in_MyIB__c, Custom_Application__c, Training_Model__c
                FROM IB_Role_Repository__c 
                WHERE Display_in_MyIB__c = true
                AND (Available_From__c <= TODAY OR Available_From__c = NULL) 
                AND (Available_To__c >= TODAY OR Available_To__c = NULL)
                ORDER BY Role_Name__c 
            ];
            
            return roles;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    } 
    
}