public class RoleApplicationSubjectService {
    
    public static Role_Application_Subject__c subject = null;
    public static List<Role_Application_Subject__c> subjects = null;
    public static List<Role_Application_Subject__c> subjectsByRoleList = null;
    
    public static Boolean isSubjectCached = false;    
    public static Boolean isSubjectsCached = false;
    public static Boolean isSubjectsByRoleListCaches = false;
    
    public static Id subjectId = null;
    public static Id roleId = null;
    public static List<Id> roleList = null;
    
    public static Role_Application_Subject__c getSubjectById() {
        try
        {
            
            if (!isSubjectCached) {
                
                if (subjectId == null) {
                    throw new CustomValidationException('The value for subjectId cannot be null.');
                }
                
                RoleApplicationSubjectDAO dao = RoleApplicationSubjectDAO.getInstance();
                subject = dao.getSubjectById(subjectId);
                isSubjectCached = true;
                
            }
            
            return subject;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static List<Role_Application_Subject__c> getSubjectsByRoleId() {
        try
        {
            if (!isSubjectsCached) {
                
                if (roleId == null) {
                    throw new CustomValidationException('The value for roleId cannot be null.');
                }
                
                RoleApplicationSubjectDAO dao = RoleApplicationSubjectDAO.getInstance();
                subjects = dao.getSubjectsByRoleId(roleId);
                isSubjectsCached = true;
                
            }
            
            return subjects;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public static List<Role_Application_Subject__c> getSubjectsByRoleList() {
        
        System.debug('Limits.getCpuTime() :'+Limits.getCpuTime());
        System.debug('Limits.getHeapSize() :'+Limits.getHeapSize());
        try{
            
            
            if (!isSubjectsByRoleListCaches) {
                
                if (roleList == null) {
                    throw new CustomValidationException('The value for roleList cannot be null.');
                }
                
                RoleApplicationSubjectDAO dao = RoleApplicationSubjectDAO.getInstance();
                subjectsByRoleList = dao.getSubjectsByRoleList(roleList);
                isSubjectsByRoleListCaches = true;
                
            }
            
            
            System.debug('Limits.getCpuTime() :'+Limits.getCpuTime());
            System.debug('Limits.getHeapSize() :'+Limits.getHeapSize());
            return subjectsByRoleList;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            
            System.debug('Limits.getCpuTime() :'+Limits.getCpuTime());
            System.debug('Limits.getHeapSize() :'+Limits.getHeapSize() );
            return NULL;
        }
        
    }
    
    public static void setSubjectId(Id subId) {
        
        subjectId = subId;
        
    }
    
    public static void setRoleId(Id rolId) {
        
        roleId = rolId;
        
        
    }
    
    public static void setRoleList(List<Id> rolList) {
        
        roleList = rolList;
        
    }
    
}