public class RoleService {
    
    public static IB_Role__c role = null;
    public static List<IB_Role__c> roles = null;
    public static List<IB_Role__c> rolesByContact = null;
    public static List<IB_Role__c> applicantRoles = null;
    
    public static Boolean isRoleCached = false;
    public static Boolean isRolesCached = false;
    public static Boolean isRolesByContactCached = false;
    public static Boolean isMyIBRolesByContactCached = false;
    public static Boolean isApplicantRolesCached = false;
    
    public static Id roleId = null;
    public static Id contactId = null;
    public static Id accountId = null;
    public static Id programmeId = null;
    
    public static IB_Role__c getRole() {
        
        if (!isRoleCached) {
            
            if (roleId == null) {
                throw new CustomValidationException('The value for roleId cannot be null.');
            }
            
            RoleDAO dao = RoleDAO.getInstance();
            role = dao.getRoleById(roleId);
            isRoleCached = true;
            
        }
        
        return role;
        
    }
    
    public static List<IB_Role__c> getRolesByContactId() {
        
        if (!isRolesByContactCached) {
            
            if (contactId == null) {
                throw new CustomValidationException('The value for contactId cannot be null.');
            }
            
            RoleDAO dao = RoleDAO.getInstance();
            rolesByContact = dao.getRolesByContactId(contactId);
            isRolesByContactCached = true;
            
        }
        
        return rolesByContact;
        
    }
    
    public static List<IB_Role__c> getMyIBRolesByContactId() {
        
        if (!isRolesByContactCached) {
            
            if (contactId == null) {
                throw new CustomValidationException('The value for contactId cannot be null.');
            }
            
            RoleDAO dao = RoleDAO.getInstance();
            rolesByContact = dao.getMyIBRolesByContactId(contactId);
            isMyIBRolesByContactCached = true;
            
        }
        
        return rolesByContact;
        
    }
    
    public static List<IB_Role__c> getRolesByAccountId() {
        
        if (!isRolesCached) {
            
            if (accountId == null) {
                throw new CustomValidationException('The value for accountId cannot be null.');
            }
            
            RoleDAO dao = RoleDAO.getInstance();
            roles = dao.getRolesByAccountId(accountId);
            isRolesCached = true;
            
        }
        
        return roles;
        
    }
    
    public static List<IB_Role__c> getApplicantRolesForApprovalByAccountId() {
        
        if (!isApplicantRolesCached) {
            
            if (accountId == null) {
                throw new CustomValidationException('The value for accountId cannot be null.');
            }
            
            RoleDAO dao = RoleDAO.getInstance();
            applicantRoles = dao.getApplicantRolesForApprovalByAccountId(accountId);
            isApplicantRolesCached = true;
            
        }
        
        return applicantRoles;
        
    }
    
    public static List<IB_Role__c> getRolesByProgrammeId() {
        
        if (programmeId == null) {
            throw new CustomValidationException('The value for programmeId cannot be null.');
        }
        
        getRolesByAccountId();
        
        List<IB_Role__c> rolesByProgramme = new List<IB_Role__c>();
        for (IB_Role__c r : roles) {
            if (r.IB_Programme_New__c == programmeId) {
                rolesByProgramme.add(r);
            }
        }
        
        return rolesByProgramme;
        
    }
    
    public static List<IB_Role__c> getRolesByProgrammeId_B(Id accountId, Id programmeId) {
        List<IB_Role__c> rolesByProgramme = new List<IB_Role__c>();
        rolesByProgramme = [
            SELECT Id, Name,Email__c,RecordType.Name,RecordTypeId, Status__c, IB_Contact__c, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
            IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, 
            IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
            IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId
            AND IB_Programme_New__c = :programmeId
            AND Status__c = 'Confirmed'
            AND Active__c = true
            AND (End_Date__c = null OR End_Date__c > TODAY)
            AND IB_Role_Name__c != 'Teacher'
            ORDER BY IB_Contact__c
        ];
        
        return rolesByProgramme;
        
    }
    
    public static List<IB_Role__c> getRolesByProgrammeId_T(Id accountId, Id programmeId) {
        List<IB_Role__c> rolesByProgramme_T = new List<IB_Role__c>();
        rolesByProgramme_T = [
            SELECT Id, Name,Email__c,RecordType.Name,RecordTypeId, Status__c, IB_Contact__c, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
            IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, 
            IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
            IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId
            AND IB_Programme_New__c = :programmeId
            AND Status__c = 'Confirmed'
            AND Active__c = true
            AND (End_Date__c = null OR End_Date__c > TODAY)
            AND IB_Role_Name__c = 'Teacher'
            ORDER BY IB_Contact__c
        ];
        
        return rolesByProgramme_T;
        
    }
    
    
    public static void setRoleId(Id rolId) {
        roleId = rolId;
    }
    
    public static void setContactId(Id conId) {
        contactId = conId;
    }
    
    public static void setAccountId(Id accId) {
        accountId = accId;
    }
    
    public static void setProgrammeId(Id progId) {
        programmeId = progId;
    }
    
}