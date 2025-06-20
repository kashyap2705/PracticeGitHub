public class RoleApplicationSubjectDAO {
    
    private static final RoleApplicationSubjectDAO instance = new RoleApplicationSubjectDAO();
	
    private Role_Application_Subject__c subject;
	private List<Role_Application_Subject__c> subjects;

	private RoleApplicationSubjectDAO() {}

	public static RoleApplicationSubjectDAO getInstance() {
		return instance;
	}
    
    public Role_Application_Subject__c getSubjectById(Id subjectId) {
        try
        {
        
        subject = [
            SELECT Id, Name, IB_Subject__c, Role_And_Application__c, IB_Programme__c, Subject_Group__c, Subject_Name__c, toLabel(IB_Subject__r.Subject_Group__c), IB_Subject__r.Subject_Name_FR__c, IB_Subject__r.Subject_Name_SP__c 
            FROM Role_Application_Subject__c 
            WHERE Id = :subjectId
        ];

		return subject;
        }
        catch(exception x)
        {
            System.debug('excp'+x);
            return NULL;
            
        }
        

	}
    
    public List<Role_Application_Subject__c> getSubjectsByRoleId(Id roleId) {
        
        subjects = [
            SELECT Id, Name, IB_Subject__c, Subject_Name_FR__c, Subject_Name_ES__c, Role_And_Application__c, IB_Programme__c, Subject_Group__c, Subject_Name__c, toLabel(IB_Subject__r.Subject_Group__c), IB_Subject__r.Subject_Name_FR__c, IB_Subject__r.Subject_Name_SP__c 
            FROM Role_Application_Subject__c 
            WHERE Role_And_Application__c = :roleId
        ];

		return subjects;

	}
    
    public List<Role_Application_Subject__c> getSubjectsByRoleList(List<Id> roleList) {
        
        subjects = [
            SELECT Id, Name, IB_Subject__c, Role_And_Application__c, IB_Programme__c, Subject_Group__c, Subject_Name__c, toLabel(IB_Subject__r.Subject_Group__c), IB_Subject__r.Subject_Name_FR__c, IB_Subject__r.Subject_Name_SP__c 
            FROM Role_Application_Subject__c 
            WHERE Role_And_Application__c IN :roleList 
            ORDER BY IB_Subject__c
        ];

		return subjects;

	}

}