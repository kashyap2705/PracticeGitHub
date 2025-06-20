/**
* <h1>Validate other Users</h1>
* This Class is reponsible for getting all conformed and Applicant Role of Online Provider Users as well as declined Roles of Online Provider Users;
* INST0054.
* @author  Umair Mukhtar.
* @version 1.0
* @since   05-07-2021.
*/
public Without Sharing class RolesAndAssociationLWCClassOP {
   Private static  list<account>account=[select id,name from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId  limit 1];
    
    
    /**
* This method will get all the Applicant Roles of the Online Provider User.
* @param N/A.
* @return List of IB_Role__c.
*/
    
    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleList() {
        if(account.size()>0)return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c, Date_Confirmed__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Applicant' AND Email_Confirmed__c=true AND IB_Role_Name__c='Teacher' and IB_Account__c=:account[0].id];
return null;    
    }
    
    
    /**
* This method will get all the Confirmed Roles of the Online Provider User.
* @param N/A.
* @return List of IB_Role__c.
*/

    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleListConfirmed() {
        if(account.size()>0)return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Confirmed' AND  IB_Role_Name__c='Teacher' and IB_Account__c=:account[0].id AND IB_Programme_New__c != null];
        return null;
    }

    /**
* This method will get all the Confirmed Teacher Roles of the Online Provider User.
* @param N/A.
* @return List of IB_Role__c.
*/
    
    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleListTransConfirmed() {
        if(account.size()>0)return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Account__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Confirmed' AND IB_Role_Name__c='Teacher' and IB_Account__c=:account[0].id AND IB_Programme_New__c != null];
        return null;
    }
    
    
    
    /**
* This method will Confirmed , Applicant Roles of the Online Provider User.
* @param List of IB_Role__c.
* @return void.
*/
    
    @AuraEnabled
    public static void AddSelectedItems(List<IB_Role__c> listRole) 
    {
        
        try{
            List<IB_Role__c>roles=new List<IB_Role__c>();
            for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
            {
                rol.Status__c='Confirmed';
                roles.add(rol);
            }
            if(roles.size()>0)
            {
                Update roles;
            }
        }
        catch(Exception e){
            
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        } 
    }
    
    
    /**
* This method will Dclined , Applicant Roles of the Online Provider User.
* @param List of IB_Role__c.
* @return void.
*/
    
    @AuraEnabled
    public static void DeclinedApplicantRoles(List<IB_Role__c> listRole) 
    {
        
        List<IB_Role__c>roles=new List<IB_Role__c>();
        for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
        {
            rol.Status__c='Declined';
            roles.add(rol);
        }
        try{
            if(roles.size()>0)
            {
                Update roles; 
            } 
        }
        catch(Exception e){
            
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        } 
        
    }
    
    
    
    
    
    /**
* This method will Withdrawn , Confirmed Roles of the Online Provider User.
* @param List of IB_Role__c.
* @return void.
*/
    
    @AuraEnabled
    public static void DeclinedConfimRoles(List<IB_Role__c> listRole) 
    {
        try{  
            List<IB_Role__c>roles=new List<IB_Role__c>();
            for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
            {
                rol.Status__c='Withdrawn';
                roles.add(rol);
            }
            
            if(roles.size()>0)
            {
                Update roles;
            }
        }
        catch(Exception e){
            
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
   * This method will confirmed Teacher Role adn update it
   * @param none
   * @return void.
   * @author Ammara Alvi
   */
    
    @AuraEnabled
     public static void ConfirmTeacherUser() 
    {
        try{  
          User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
          List<IB_Role__c> institute_admin = [Select id,Job_Title__c,Contact_Information_Email__c,Contact_Information_Phone__c,IB_Account__c,IB_Role_Name__c,IB_Role__c from IB_Role__c where IB_Contact__c = :userTemp.ContactId AND Status__c = 'Confirmed' AND IB_Account__c = :account[0].id AND IB_Role_Name__c = 'Online Coordinator' Limit 1];
          IB_Role_Repository__c role_repo = [Select id from IB_Role_Repository__c  where Role_Name__c = 'Teacher' Limit 1];
            
          IB_Role__c transcritp_users = new IB_Role__c();
          transcritp_users.Status__c = 'Confirmed';
          transcritp_users.IB_Contact__c = userTemp.ContactId;
          transcritp_users.IB_Role__c = role_repo.id;
          transcritp_users.IB_Account__c = account[0].id;
          transcritp_users.Contact_Information_Email__c = institute_admin[0].Contact_Information_Email__c;
          transcritp_users.Contact_Information_Phone__c = institute_admin[0].Contact_Information_Phone__c;
          transcritp_users.Job_Title__c = institute_admin[0].Job_Title__c;
          transcritp_users.Email_Confirmed__c=true;
          transcritp_users.Role_Level__c = 'Fully Qualified';
          insert transcritp_users;
          update account;
        }
        catch(Exception e){
            
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}