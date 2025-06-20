public class RoleRepositoryService {
    
	public static IB_Role_Repository__c role = null;
    public static List<IB_Role_Repository__c> roles = null;
    
	public static Boolean isRoleCached = false;
    public static Boolean isRolesCached = false;
    
	public static Id roleId = null;
    
    public static IB_Role_Repository__c getRoleById() {

        try
        {
		if (!isRoleCached) {
            
            if (roleId == null) {
				throw new CustomValidationException('The value for roleId cannot be null.');
			}
            
            RoleRepositoryDAO dao = RoleRepositoryDAO.getInstance();
			role = dao.getRoleById(roleId);
            isRoleCached = true;
            
		}

		return role;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}
    
    public static List<IB_Role_Repository__c> getAllRoles() {
        try
        {

		if (!isRolesCached) {
            
            RoleRepositoryDAO dao = RoleRepositoryDAO.getInstance();
			roles = dao.getAllRoles();
            isRolesCached = true;
            
		}

		return roles;
        }
         Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}

	public static List<IB_Role_Repository__c> getAllMyIBRoles() {
        try
        {

		if (!isRolesCached) {
            
            RoleRepositoryDAO dao = RoleRepositoryDAO.getInstance();
			roles = dao.getAllMyIBRoles();
            isRolesCached = true;
            
		}

		return roles;
        }
         Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }

	}
    
}