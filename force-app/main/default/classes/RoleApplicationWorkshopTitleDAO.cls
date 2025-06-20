public class RoleApplicationWorkshopTitleDAO {
    
    @TestVisible private static final RoleApplicationWorkshopTitleDAO instance = new RoleApplicationWorkshopTitleDAO();
	
    @TestVisible private List<Role_Application_Workshop_Title__c> workshopTitles;

	@TestVisible private RoleApplicationWorkshopTitleDAO() {}

	public static RoleApplicationWorkshopTitleDAO getInstance() {
		return instance;
	}
    
    public List<Role_Application_Workshop_Title__c> getWorkshopTitlesByRoleId(Id roleId) {
        try
        {
        
        workshopTitles = [
            SELECT ID, IB_Workshop_Title__c, IB_Workshop_Title__r.Workshop_Title_FR__c, 
            IB_Workshop_Title__r.Workshop_Title_SP__c, IB_Workshop_Title__r.Workshop_Title_ENG__c
            FROM Role_Application_Workshop_Title__c 
            WHERE Role_And_Application__c =: roleId
        ];

		return workshopTitles;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
	}
}