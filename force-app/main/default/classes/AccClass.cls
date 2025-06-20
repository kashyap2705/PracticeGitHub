/**
* <h1>Account information for Instiute users</h1>
* This Class is reponsible for displaying the Account and IB Addresses information for the Institutute Users;
* @author  Mubeen Akbar.
* @version 1.0
* @since   06-09-2020.
*/
public without sharing class AccClass {
    
    public static User user=[select contact.AccountId,contactid, Name ,Email from user where id=:userInfo.getUserId()];
    /**
    * This method will get all the Account value for the running Institute User.
    * @return Account.
    */
    @AuraEnabled (cacheable=true)
    public static Account getAccounts() {
        
        list<Account> ac=[select id,Name,Phone,IBIS_ID__c,Dial_code2__c,Dial_code__c,IB_Transcript_Method__c,
                          Confirmed_Transcript_Users__c,Maximum_Transcript_Users__c from Account where id=:user.contact.AccountId  limit 1];
        if(ac.size()>0) {
            return ac[0];
        } else {
            return null;
        }
    }
    
    /**
    * This method will get all the Account value for the running Institute User.
    * @param String
    */
    @AuraEnabled 
    public static void UpdateAccounts(string AcIBISID) {
        
        Account ac=[select id from Account where name=:AcIBISID  limit 1];
        contact c=new contact(id=user.contactid);
        c.AccountId=ac.id;
        if(!test.isRunningTest())update c;
        
    }
    
    /**
    * This method will get all the Account value for the running Institute User.
    * @return List of Account.
    */ 
    @AuraEnabled (cacheable=true)
    public static list<Account> getAllAccounts() {
        Set<Id>AcList=new set<id>();
        // This code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
        for(IB_Role__c role:[SELECT IB_Account__c FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='IBEC University Administrator' 
                                                                                                   OR IB_Role_Name__c='Institute Administrator' 
                                                                                                   OR IB_Role_Name__c='Institute Transcript User' 
                                                                                                   OR IB_Role_Name__c='Communication User') 
                             AND IB_contact__c=:user.contactid]) {
                                 AcList.add(role.IB_Account__c);
                             }
        List<Account>AccountUserRoles=new list<Account>();
        AccountUserRoles.add(getAccounts());
        for(Account a:[select id,Name,IBIS_ID__c,IB_Transcript_Method__c,Phone,Confirmed_Transcript_Users__c from Account where id IN:AcList and id  !=:getAccounts().id])
        {
            AccountUserRoles.add(a);
            
        }
        return AccountUserRoles; 
    }
    
    /**
    * This method will get all the Account value for the running IBEC Institute User.
    * @return List of Account.
    */ 
    @AuraEnabled (cacheable=true)
    public static list<Account> getAllIBECAccounts() {
        Set<Id>AcList=new set<id>();
        for(IB_Role__c role:[SELECT IB_Account__c FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='IBEC University Administrator' 
                                                                                                   OR IB_Role_Name__c='IBEC Faculty Member' 
                                                                                                   OR IB_Role_Name__c='IBEC Candidate') AND IB_contact__c=:user.contactid])
        {
            AcList.add(role.IB_Account__c);
        }
        List<Account>AccountUserRoles=new list<Account>();
        AccountUserRoles.add(getAccounts());
        for(Account a:[select id,Name,IBIS_ID__c,IB_Transcript_Method__c,Phone,Confirmed_Transcript_Users__c from Account where id IN:AcList and id  !=:getAccounts().id])
        {
            AccountUserRoles.add(a);
            
        }
        return AccountUserRoles; 
    }
    
    /**
    * This method will identify if the running Institute User is an admin or Not.
    * @param N/A.
    * @return Integer.
    */
    @AuraEnabled (cacheable=true)
    public static integer isAdmin() {
        list<IB_role__c>psa=new list<IB_role__c>();
        if(AccClass.getAccounts()!=null) {
            psa=   [SELECT ID FROM IB_role__c where IB_Account__c=:AccClass.getAccounts().id and IB_Role_Name__c='Institute Administrator' and status__c='Confirmed' and IB_contact__c=:user.contactid];
        }
        if(psa.size()>0)
        {
            return 2;
        }        
        return 0;
    }
    
    /**
    * This method will identify if the running IBEC User is an admin or Not.
    * Added as part of ECM226
    * @return Integer.
    */
    @AuraEnabled (cacheable=true)
    public static Integer isIBECAdmin() {
        list<IB_role__c>psa=new list<IB_role__c>();
        if(AccClass.getAccounts()!=null)
            psa=   [SELECT ID FROM IB_role__c where IB_Account__c=:AccClass.getAccounts().id and IB_Role_Name__c='IBEC University Administrator' and status__c='Confirmed' and IB_contact__c=:user.contactid];
        
        if(psa.size()>0)
        {
            return 2;
        }        
        return 0;
    }
    
    /**
    * This method will get all the IB Address value for the running Institute User.
    * @return IB_Address.
    */
    @AuraEnabled (cacheable=true)
    public static IB_Address__c getAccountAddress() {
        list<IB_Address__c> adr=new list<IB_Address__c>();
        if(AccClass.getAccounts()!=null) {
            adr=[select Name,City__c,Province__c,Postal_Code__c,Country__r.Name,Address_Line_1__c,IB_Account__r.Dial_code2__c,IB_Account__r.Dial_code__c,
                 Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,IB_Account__r.id,IB_Account__r.Phone2__c,IB_Account__r.Phone,IB_Account__r.Phone_Number__c,
                 IB_Account__r.IB_Transcript_Method__c,IB_Account__r.Confirmed_Transcript_Users__c from IB_Address__c where IB_Account__c=:AccClass.getAccounts().id  limit 1];
        }
        if(adr.size()>0)
        {
            return adr[0];
        }
        return null;
    }
    
    /**
    * This method will get the BaseUrl for the MyIB Community, which helps in navigation for Institute Users.
    * @return String.
    */
    @AuraEnabled (cacheable=true)
    public static string getBaseUrl() {
        
        Network nw = [SELECT id, name FROM Network WHERE Name = 'ibportal' LIMIT 1];
        String baseUrl = Network.getLoginUrl(nw.id);
        baseUrl = baseUrl.removeEnd('/ibportal/IBPortalLogin');
        baseUrl = baseUrl.replace('https','http');
        system.debug(baseUrl);
        return   baseUrl;
    }
    
    /**
    * This method will get the running User's Name.
    * @return String.
    */
    @AuraEnabled (cacheable=true)
    public static string getUserDetails() {
        return  user.name;
    }
}