public class IBENWelcomeEmailVFTemplateController {
    public String firstName {get;set;}
    public String lastName {get;set;}
    
    public String roleName {get;set;}
    public String ibCode {get;set;}
    
    public Id userId;
    public Id getUserId() {
        return userId;
    }
    public void setUserId(Id u) {
        userId = u;
        findRoleName();
        findIBCode();
    }
    
    public Boolean isUserSetup;
    public Boolean getisUserSetup() {
        return isUserSetup;
    }
    public void setisUserSetup(Boolean b) {
        isUserSetup = b;
    }
    
    
    public String userLanguage;
    public String getuserLanguage() {
        return userLanguage;
    }
    public void setuserLanguage(String s) {
        userLanguage = s;
    }
    
    
    public void findRoleName(){ 
        User u = [Select ContactId from User where Id = :userId LIMIT 1];
        Set<String> validRoles = new Set<String>{'Examiner','Chief Examiner','Examiner Responsible', 'Deputy Examiner Responsible', 'Principal Examiner', 'Exam Team Leader'};
            IB_Role__c examRole = [Select Id, IB_Role_Name__c from IB_Role__c where IB_Contact__c = :u.ContactId 
                                   AND Status__c='Confirmed' AND Active__c=true AND IB_Role_Name__c in :validRoles ORDER BY CreatedDate DESC LIMIT 1];
        roleName = examRole.IB_Role_Name__c; 
        System.debug('roleName:' + roleName);
    }
    
    public void findIBCode(){ 
        User u = [Select ContactId from User where Id = :userId LIMIT 1];
        Contact con = [Select Id, IBIS_contact_ID__c, FirstName, LastName from Contact where Id = :u.ContactId LIMIT 1];
        ibCode = con.IBIS_contact_ID__c; 
        firstName = con.FirstName;
        lastName = con.LastName;
        System.debug('firstName:' + firstName);
        System.debug('lastName:' + lastName);
        System.debug('ibCode:' + ibCode);
    }
    
    public IBENWelcomeEmailVFTemplateController()
    {
        System.debug('IBENWelcomeEmailVFTemplateController userSFId:'+ userId);
        System.debug('IBENWelcomeEmailVFTemplateController ibCode:'+ ibCode);
    }
}