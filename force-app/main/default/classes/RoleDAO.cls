public class RoleDAO {

    private static final RoleDAO instance = new RoleDAO();
    
    private IB_Role__c role;
    private List<IB_Role__c> rolesByAccount;
    private List<IB_Role__c> rolesByContact;
    private List<IB_Role__c> rolesByContactList;
    private List<IB_Role__c> headOfSchoolList;

    private RoleDAO() {}

    public static RoleDAO getInstance() {
        return instance;
    }
    
    public IB_Role__c getRoleById(Id roleId) { 

        role = [
            SELECT Id, Name, Role_Has_Subjects__c, IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
                IB_Role__c, Restricted_Subjects__c,Age_Groups__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, Programme_Selection__c, Programme_Selection_FR__c, Programme_Selection_Es__c
            FROM IB_Role__c 
            WHERE Id = :roleId
        ];
        //Added Age_Groups__c field which was removed as part of US000037
        //Added by Atticus F. on 23-11-2022 -- Bug 184794/184795 Fix
        return role;

    }

    public List<IB_Role__c> getRolesByAccountId(Id accountId) {
// IB_Programme_New__r.Agreement_Type__c Added by kashyap ECM00635
        rolesByAccount = [
            SELECT Id, Name,Email__c,ContactUserLanguage__c,Contact_name__c,RecordType.Name,RecordTypeId, Status__c, IB_Contact__c, IB_Contact__r.RecordTypeId, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
                IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name,IB_Contact__r.Email, 
                IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
                IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c, IB_Contact__r.Invitation_ID__c,createddate, IB_Programme_New__r.Agreement_Type__c, IB_Programme_New__r.RecordType.DeveloperName  // added createdate bby kashyap
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId
            AND (End_Date__c = null OR End_Date__c > TODAY)
            ORDER BY IB_Contact__c
        ];

        return rolesByAccount;

    }

    public List<IB_Role__c> getApplicantRolesForApprovalByAccountId(Id accountId) {
//IB_Programme_New__r.Agreement_Type__c added by kashyap for ECM00635
        rolesByAccount = [
            SELECT Id, Name, Status__c, IB_Contact__c, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
                IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, 
                IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
                IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title,IB_Programme_New__r.Agreement_Type__c, (SELECT Subject_Name__c, Subject_Name_FR__c, Subject_Name_ES__c FROM Role_Application_Subjects__r)
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId
            AND (End_Date__c = null OR End_Date__c > TODAY)
            AND Status__c = 'Applicant'
            AND IB_Role__r.MyIB_Require_My_School_Approval__c = true
            ORDER BY IB_Contact__c
        ];

        return rolesByAccount;

    }

    public List<IB_Role__c> getRolesByContacts(List<Id> contactIds) {

        rolesByContactList = [
            SELECT Id, Name, status__c,Role_Has_Subjects__c, IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
            FROM IB_Role__c 
            WHERE IB_Contact__c IN :contactIds
            AND (End_Date__c = null OR End_Date__c > TODAY)
            ORDER BY IB_Role_Name__c
        ];

        return rolesByContactList;

    }
    
    public List<IB_Role__c> getRolesByContactId(Id contactId) {

        rolesByContact = [
            SELECT Id, Name, Role_Has_Subjects__c, Status__c, Programme_Selection__c, IB_Contact__c, Status_Value__c, IB_Account__c, IB_Account__r.Name, IB_Account__r.IBIS_ID__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
            FROM IB_Role__c
            WHERE IB_Contact__c = :contactId
            AND (End_Date__c = null OR End_Date__c > TODAY)
            ORDER BY IB_Role_Name__c
        ];

        return rolesByContact;

    }

    public List<IB_Role__c> getMyIBRolesByContactId(Id contactId) {

        rolesByContact = [
            SELECT Id, Name, Role_Has_Subjects__c, End_Date__c, Programme_Selection_Es__c,Programme_Selection_FR__c, toLabel(Status__c), Programme_Selection__c, IB_Contact__c, Status_Value__c, IB_Account__c, IB_Account__r.Name, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, IB_Role_Programme_Combo__c
            FROM IB_Role__c
            WHERE IB_Contact__c = :contactId
            AND (End_Date__c = null OR End_Date__c > TODAY)
            AND (IB_Role__r.Display_in_MyIB__c = true OR IB_Role__r.Display_Confirmed_in_MyIB__c = true)
            ORDER BY IB_Role_Name__c
        ];

        return rolesByContact;

    }

    public List<IB_Role__c> getRolesByContactAndAccount(List<Id> contactIds, Id acctId){
        
        List<IB_Role__c> rolesForContact = [
            SELECT Id, Name, Role_Has_Subjects__c, IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
            FROM IB_Role__c 
            WHERE IB_Contact__c in :contactIds
            AND (End_Date__c = null OR End_Date__c > TODAY)
            ORDER BY IB_Role_Name__c
        ];

        List<IB_Role__c> rolesByContactList = new List<IB_Role__c>();
        for(IB_Role__c r : rolesForContact){
            if(acctId == r.IB_Account__c){
                IB_Role__c role = new IB_Role__c();
                role = r;
                rolesByContactList.add(role);
            } else {
                system.debug(loggingLevel.ERROR,acctId + ':' + r.IB_Account__c);
            }
        }

        return rolesByContactList;
        
    }   

    public List<IB_Role__c> getHeadOfSchool(Id accountId) {

        try {
            headOfSchoolList = [
                SELECT Id, Name, Role_Has_Subjects__c,IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
                FROM IB_Role__c
                WHERE IB_Account__c = :accountId 
                AND IB_Role__c = :getRoleByName('Head of School (Overall)')
                AND (End_Date__c = null OR End_Date__c > TODAY)
                ORDER BY IB_Role_Name__c
            ];
        } catch (Exception e){
            headOfSchoolList = new List<IB_Role__c>();
        }

        return headOfSchoolList;

    }

    public Id getRoleByName(String roleName){
        
        IB_Role_Repository__c repo = [
            SELECT Id
            FROM IB_Role_Repository__c
            WHERE Role_Name__c = :roleName
            LIMIT 1
        ];

        return repo.Id;

    }

}