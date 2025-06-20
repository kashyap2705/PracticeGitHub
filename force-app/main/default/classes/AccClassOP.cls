/**
* <h1>Account information for Online Provider</h1>
* This Class is reponsible for displaying the Account and IB Addresses information for the Online Provider Users;
* @author  Umair Mukhtar.
* @version 1.0
* @since   01-07-2021.
*/
public without sharing class AccClassOP {
    
    public static User user=[select contact.AccountId,contactid, Name ,Email from user where id=:userInfo.getUserId()];
    /**
* This method will get all the Account value for the running Online Provider User.
* @param N/A.
* @return Account.
*/
    
    @AuraEnabled (cacheable=true)
    public static Account getAccounts() {
        //UpdateContactAccount();
        Contact accCon=[select id, AccountId from Contact where id=:user.contactid Limit 1]; 
        System.debug('Apple= '+accCon);
        list<Account> ac=[select id,Name,Recordtype.Name from Account where id=:user.contact.AccountId AND RecordType.Name = 'Online Provider' limit 1]; 
        if(ac.size()>0)
        {
            return ac[0];
        }
        else{
            List<IB_Role__c> role = [SELECT IB_Account__r.id FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='Online Coordinator' OR IB_Role_Name__c='Online Admin Assistant')  and IB_contact__c=:user.contactid Limit 1];
            if(role.size() > 0){
                ac = [Select id,Name,Recordtype.Name from Account where id=:role[0].IB_Account__r.id];
                System.debug('role : '+role.size());
                System.debug('Ac : '+ac.size());
                if(ac.size()>0)
                {
                    return ac[0];
                }
                
            }
            return null;
        }
        
        
    }
    
    
    
    /**
* This method will get all the Account value for the running Online Provider User.
* @param String .
* @return N/A.
*/
    @AuraEnabled   
    public static void UpdateContactAccount() {
        Contact accCon=[select id, AccountId from Contact where id=:user.contactid Limit 1]; 
        System.debug('Orange1 '+accCon.AccountId);
        Boolean accOP = false;
        
        List<IB_Role__c> role = [SELECT IB_Account__r.id FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='Online Coordinator' OR IB_Role_Name__c='Online Admin Assistant')  and IB_contact__c=:user.contactid and IB_Account__r.Recordtype.Name = 'Online Provider'];
        System.debug('Orange2 '+role);
        if(role.size() > 0){
            for(IB_Role__c rol : role)
            {
                System.debug('OrangeRole '+rol.IB_Account__r.id);
                if(accCon.AccountId == rol.IB_Account__r.id)
                    accOP = true;
            }
        }
        if(accOP == false)
        {
            System.debug('Orange Con update');
            contact c=new contact(id=user.contactid);
            c.AccountId=role[0].IB_Account__r.id;
            if(!test.isRunningTest())update c;
        }
        
    }
    
    
    
    @AuraEnabled 
    public static void UpdateAccounts(string AcIBISID) {
        
        Account ac=[select id from Account where name=:AcIBISID  limit 1];
        contact c=new contact(id=user.contactid);
        c.AccountId=ac.id;
        if(!test.isRunningTest())update c;
        
    }
    /**
* This method will get all the Account value for the running Online Provider User.
* @param N/A.
* @return List of Account.
*/ 
    @AuraEnabled (cacheable=true)
    public static list<Account> getAllAccounts() {
        Contact accCon=[select id, AccountId from Contact where id=:user.contactid Limit 1]; 
        System.debug('Apple2= '+accCon);
        Set<Id>AcList=new set<id>();  
        for(IB_Role__c role:[SELECT IB_Account__c FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='Online Coordinator' OR IB_Role_Name__c='Online Admin Assistant')  and IB_contact__c=:user.contactid])
        {
            AcList.add(role.IB_Account__c);
        }
        List<Account>AccountUserRoles=new list<Account>();
        Account acc = new Account();
        acc = getAccounts();
        if(acc != null){
            AccountUserRoles.add(getAccounts());
            for(Account a:[select id,Name,RecordType.Name from Account where id IN:AcList and id != :acc.id])
            {
                AccountUserRoles.add(a);
                
            }
            // UpdateAccounts(AccountUserRoles[0].Name);
        }else{
            for(Account a:[select id,Name,RecordType.Name from Account where id IN:AcList])
            {
                AccountUserRoles.add(a);
                
            }
        }
        Boolean present = false;
        for(Account accTemp : AccountUserRoles)
        {
            if(accCon.AccountId == accTemp.Id)
                present = true;
        }
        /* if(present == false)
{

contact c=new contact(id=user.contactid);
c.AccountId=AccountUserRoles[0].id;
if(!test.isRunningTest())update c;
} */
        
        return AccountUserRoles; 
    }
    
    /**
* This method will identify if the running Online Provider User is an admin or Not.
* @param N/A.
* @return Integer.
*/
    @AuraEnabled (cacheable=true)
    public static integer isAdmin() {
        list<IB_role__c>psa=new list<IB_role__c>();
        if(AccClass.getAccounts()!=null)
            psa=   [SELECT ID,IB_contact__r.Name FROM IB_role__c where IB_Account__c=:AccClassOP.getAccounts().id and IB_Role_Name__c='Online Coordinator' and status__c='Confirmed' and IB_contact__c=:user.contactid];
        
        if(psa.size()>0)
        {
            return 2;
        }        
        return 0;
        
    }
    @AuraEnabled(cacheable=true)
    public static IB_Role__c confirm_OC(){
        List<IB_Role__c> Online_Coordinator = new List<IB_Role__c>();
        Online_Coordinator =   [SELECT ID,IB_contact__r.Name FROM IB_role__c where IB_Account__c=:AccClassOP.getAccounts().id and IB_Role_Name__c='Online Coordinator' and status__c='Confirmed'];
        if(Online_Coordinator.size()>0)
            return Online_Coordinator[0];
        else
            return null;
        
    }
    /**
* This method will get all the IB Address value for the running Online Provider User.
* @param N/A.
* @return IB_Address.
*/
    @AuraEnabled (cacheable=true)
    public static IB_Address__c getAccountAddress() {
        list<IB_Address__c> adr=new list<IB_Address__c>();
        if(AccClass.getAccounts()!=null)
            adr=[select Country_pList__c,Country__c,Name,City__c,Province__c,Postal_Code__c,Country__r.Name,IB_Account__r.Phone,IB_Account__r.Phone2__c,IB_Account__r.Dial_code__c,IB_Account__r.Dial_code2__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,IB_Account__r.id from IB_Address__c where IB_Account__c=:AccClassOP.getAccounts().id  and Status__c = 'Active' limit 1];
        
        if(adr.size()>0)
        {
            return adr[0];
        }
        
        return null;
        
    }
    
    /**
* This method will get the BaseUrl for the MyIB Community, which helps in navigation for Online Provider Users.
* @param N/A.
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
* This method will get the runnig Users Name.
* @param N/A.
* @return String.
*/
    @AuraEnabled (cacheable=true)
    public static string getUserDetails() {
        return  user.name;
    }
    
    /**
* This method will get Total Allowed teachers per School from Custom Settings.
* Added as a fix by Bharat for INC0155008
*/  
    
    @AuraEnabled (cacheable=true)
    public static String getMaxTeacherRoles(){
        MaxRoles__c maxTeacherRole = [ SELECT Id, Name, Max_Allowed_Roles__c FROM MaxRoles__c where Name = 'Max Allowed Teachers' LIMIT 1]; 
        System.debug('Max teachers allowed:' + maxTeacherRole.Max_Allowed_Roles__c);
        return maxTeacherRole.Max_Allowed_Roles__c;
    }  
}