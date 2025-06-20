/**
* <h1>Account information for Association users</h1>
* This Class is reponsible for displaying the Account For the Association Users;
* @author  Muhammad Shehryar
* @version 1.0
*/
public without sharing class AccountAssociationcontroller {
    
    public static User user = [SELECT contact.AccountId, contactid, Name, Email FROM user WHERE Id=:userInfo.getUserId()];
    
    @AuraEnabled (cacheable=true)
    public static Account getAccounts() {
        list<Account> ac = [SELECT Id, Name, Phone, IBIS_ID__c, Dial_code2__c, Dial_code__c, IB_Transcript_Method__c, Confirmed_Transcript_Users__c, Maximum_Transcript_Users__c 
                            FROM Account 
                            WHERE Id =: user.contact.AccountId  
                            LIMIT 1];
        if(ac.size()>0){
            return ac[0];
        } 
        else{
            return null;
        }
    }
  
    
    // This method will get all the Account value for the running Association User.
    // @param N/A.
    // @return List of Account.
    
    @AuraEnabled (cacheable=true)
    public static list<Account> getAllAccounts() {
        Set<Id>acList=new set<Id>();
        
        List<Account> accountUserRoles=new list<Account>();
        for(IB_Role__c role:[SELECT IB_Account__c FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='Association Admin' OR IB_Role_Name__c='Association User') and IB_contact__c=:user.contactid]){
            acList.add(role.IB_Account__c);
        }
        //accountUserRoles.add(getAccounts());
        for(Account accQuery:[select Id,Name,Phone from Account where id IN: acList ]){
            accountUserRoles.add(accQuery);
        }
        return accountUserRoles; 
    }
        
    @AuraEnabled (cacheable=true)
    public static boolean isAdmin(String selectedAccountId) {
        list<IB_role__c>psa=new list<IB_role__c>();
        if(AccountAssociationcontroller.getAccounts()!=null)
            psa=   [SELECT ID FROM IB_role__c where IB_Account__c=:selectedAccountId and IB_Role_Name__c='Association Admin' and status__c='Confirmed' and IB_contact__c=:user.contactid];
        if(psa.size()>0){
            return true;
        }        
        return false;
    }
    @AuraEnabled
    public static Boolean addAccountOnContact(String selectedAccountId){
        try {
            String contactId = user.contactid;
            List <AccountContactRelation> accConList = new List <AccountContactRelation>();
            AccountContactRelation accCon = new AccountContactRelation();
            accConList = [Select Accountid from AccountContactRelation where contactId  =: contactId AND Accountid =: selectedAccountId];
            if(accConList.size() >0){
                return true;
            }
            else{
                accCon.Accountid = selectedAccountId;
                accCon.contactId = contactId;
                insert accCOn;
                return true;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
        
    @AuraEnabled (cacheable=true)
    public static Account getSelectedAccountData(String selectedAccountId) {
                             
        if (selectedAccountId != null) {
            //Added License_Agreement__c field by Suraj Parihar as a part of INC0173769        
            return [SELECT Id, Name, Type, Region__c, Sub_region__c, Legal_Name__c, ShippingCity, ShippingCountry, ShippingCountryCode, ShippingPostalCode,
                   ShippingState, ShippingStateCode, ShippingStreet, Phone, Email__c, Language_Of_Correspondance__c, annual_cycle_period_start_month__c,
                   annual_cycle_period_end_month__c, Paid_membership__c, Renewal_in_months__c, Dial_code__c,
                   Non_IB_school_members__c, IBIS_Manager__c, AIBWS_Country_State__c, External_PD_Provider__c, D_R_Manager__c, Signed_Agreement__c, 
                   AIBWS_Acronym__c, Signature_date__c, Expiry_date__c,License_Agreement__c 
                   FROM Account 
                   WHERE Id =: selectedAccountId  
                   LIMIT 1];
                        
        }      
        
        return null;
    }
    
    // This method will get the BaseUrl for the MyIB Community, which helps in navigation for Association Users.
    // @param N/A.
    // @return String.
    
    @AuraEnabled (cacheable=true)
    public static string getBaseUrl() {
        
        Network nw = [SELECT id, name FROM Network WHERE Name = 'ibportal' LIMIT 1];
        String baseUrl = Network.getLoginUrl(nw.id);
        baseUrl = baseUrl.removeEnd('/ibportal/IBPortalLogin');
        baseUrl = baseUrl.replace('https','http');
        system.debug(baseUrl);
        return   baseUrl;
    }
    
    // This method will get the runnig Users Name.
    // @param N/A.
    // @return String.
    
    @AuraEnabled (cacheable=true)
    public static string getUserDetails() {
        return  user.name;
    }   
    
}