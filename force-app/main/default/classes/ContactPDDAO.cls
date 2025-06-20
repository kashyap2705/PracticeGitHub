public class ContactPDDAO {

    private static final ContactPDDAO instance = new ContactPDDAO();

	private List<Contact_Professional_Development__c> proDevBySubject;
     private List<Contact_Professional_Development__c> proDevByRole;
     private List<Contact_Professional_Development__c> proDevByRoleList;

	private ContactPDDAO() {}

	public static ContactPDDAO getInstance() {
		return instance;
	}

    public List<Contact_Professional_Development__c> getProDevBySubjectId(Id subjectId) {

        proDevBySubject = [
            SELECT Id, Name, Year__c, Contact__c, Role__c, Role_Subject__c, Workshop_Category__c, Workshop_Status__c, Workshop_Name__c, Workshop_Sub_Name__c, Region__c, City__c, Workshop_Type__c
            FROM Contact_Professional_Development__c
            WHERE Role_Subject__c = :subjectId
        ];

		return proDevBySubject;

	}

    public List<Contact_Professional_Development__c> getProDevByRoleId(Id roleId) {

        proDevByRole = [
            SELECT Id, Name, Year__c, Contact__c, Role__c, Role_Subject__c, Workshop_Category__c, Workshop_Status__c, Workshop_Name__c, Workshop_Sub_Name__c, Region__c, City__c, Workshop_Type__c
            FROM Contact_Professional_Development__c
            WHERE Role__c = :roleId
        ];

		return proDevByRole;

	}

    public List<Contact_Professional_Development__c> getProDevByRoleList(List<Id> roleList) {

        proDevByRoleList = [
            SELECT Id, Name, Year__c, Contact__c, Role__c, Role_Subject__c, Workshop_Category__c, Workshop_Status__c, Workshop_Name__c, Workshop_Sub_Name__c, Region__c, City__c, Workshop_Type__c
            FROM Contact_Professional_Development__c
            WHERE Role__c IN :roleList
        ];

		return proDevByRoleList;

	}

}