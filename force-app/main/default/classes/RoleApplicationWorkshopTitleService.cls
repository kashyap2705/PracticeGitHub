public class RoleApplicationWorkshopTitleService {
    
    
	public static List<Role_Application_Workshop_Title__c> workshopTitles = null;
    
	public static Boolean isWorkshopTitlesCached = false;    
	
    public static Id roleId = null;
    
    public static List<Role_Application_Workshop_Title__c> getWorkshopTitlesByRoleId() {
        try
        {
        
        if (!isWorkshopTitlesCached) {

			if (roleId == null) {
				throw new CustomValidationException('The value for roleId cannot be null.');
			}
            
            RoleApplicationWorkshopTitleDAO dao = RoleApplicationWorkshopTitleDAO.getInstance();
            workshopTitles = dao.getWorkshopTitlesByRoleId(roleId);
            isWorkshopTitlesCached = true;

		}

		return workshopTitles;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
         
    }
}