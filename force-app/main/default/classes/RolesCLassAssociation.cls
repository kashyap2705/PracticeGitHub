/**
* <h1>Account information for Association users</h1>
* This Class is reponsible for getting all confirmed and Applicant Roles of Association Users as well as declined Roles of Association Users;
* @author  Muhammad Shehryar
* @version 1.0
*/
public without sharing class RolesCLassAssociation {
    Private static  list<account>account=[select id,name,IBIS_ID__c,IB_Transcript_Method__c from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId  limit 1];
    
    
    /**
* This method will get all the Applicant Roles of the Association User.
* @param N/A.
* @return List of IB_Role__c.
*/
    
    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleList(String selectedAccountId) {
        
        if(selectedAccountId!=null){
        return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c, Date_Confirmed__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Applicant' AND Email_Confirmed__c=true AND (IB_Role_Name__c!='Association Admin') and IB_Account__c=:selectedAccountId];
        }
		return null;    
    }
    
    
    /**
* This method will get all the Confirmed Roles of the Association User.
* @param N/A.
* @return List of IB_Role__c.
*/
    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleListConfirmed(String selectedAccountId) {
        if(selectedAccountId!=null){
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Confirmed' AND  IB_Role_Name__c='Association User'  And IB_Account__c=:selectedAccountId];
        }
        return null;
    }
    
    /**
* This method will get all the Confirmed Association User Roles
* @param N/A.
* @return List of IB_Role__c.
*/
    
    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleListTransConfirmed() {
        if(account.size()>0)return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Account__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Status__c='Confirmed' AND IB_Role_Name__c='Association User' and IB_Account__c=:account[0].id];
        return null;
    }
    
    /**
* This method will Confirmed , Applicant Roles of the Association User.
* @param List of IB_Role__c.
* @return void.
*/
    
    @AuraEnabled
    public static void addSelectedItems(List<IB_Role__c> listRole) 
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
    
    @AuraEnabled
    public static Object confirmSelectedItems(List<IB_Role__c> rolesList) {
        Map<String, Object> jsonObject = new Map<String, Object>();
        try{
            String errorMessage = null;
            Map<Integer, IB_Role__c> roleIntegerMap = new Map<Integer, IB_Role__c>();
            Map<Id, IB_Role__c> roleMap = new Map<Id, IB_Role__c>();            
            for(Integer idx = 0; idx < rolesList.size(); idx ++ ){
                roleIntegerMap.put(idx,  rolesList[idx]);
                roleMap.put(rolesList[idx].Id, rolesList[idx] );
            }
            for(IB_Role__c roleIns : roleMap.values()){
                roleIns.Status__c='Confirmed';
            }
            if(roleMap.values().size() > 0){
                Database.SaveResult[] srList = Database.update(roleMap.values(), true);
                for(Integer idx = 0; idx < srList.size(); idx ++ ){
                    String msgStr = null;
                    Database.SaveResult sr = srList[idx];
                    if (sr.isSuccess()) {
                        System.debug('Successfully updated role' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');   
                            if(roleIntegerMap.containsKey(idx)){
                                IB_Role__c roleRec = roleIntegerMap.get(idx);
                                msgStr = 'Role with' + roleRec.Email__c + 'is not updated successfully for this reason' + err.getMessage() + '\n';
                            }          
                        }
                    }
                    if(String.isNotBlank(msgStr)){
                        errorMessage += msgStr;
                    }
                }
               
            }
            if(String.isNotBlank(errorMessage)){
                jsonObject.put('success', false);
                jsonObject.put('error', errorMessage);
            }
            else{
                jsonObject.put('success', true);
                jsonObject.put('error', null);
            }
            return jsonObject;
        }
        catch(Exception exp){
            System.debug(Logginglevel.ERROR, exp.getMessage());
            jsonObject.put('success', false);
            jsonObject.put('error', exp.getMessage());
            return jsonObject;    
        } 
    }
    
    
    /**
* This method will Dclined , Applicant Roles of the Association User.
* @param List of IB_Role__c.
* @return void.
*/

@AuraEnabled
    public static Object declineApplicantRoles(List<IB_Role__c> rolesList) {
        Map<String, Object> jsonObject = new Map<String, Object>();
        try{
            String errorMessage = null;
            Map<Integer, IB_Role__c> roleIntegerMap = new Map<Integer, IB_Role__c>();
            Map<Id, IB_Role__c> roleMap = new Map<Id, IB_Role__c>();            
            for(Integer idx = 0; idx < rolesList.size(); idx ++ ){
                roleIntegerMap.put(idx,  rolesList[idx]);
                roleMap.put(rolesList[idx].Id, rolesList[idx] );
            }
            for(IB_Role__c roleIns : roleMap.values()){
                roleIns.Status__c='Declined';
            }
            if(roleMap.values().size() > 0){
                Database.SaveResult[] srList = Database.update(roleMap.values(), true);
                for(Integer idx = 0; idx < srList.size(); idx ++ ){
                    String msgStr = null;
                    Database.SaveResult sr = srList[idx];
                    if (sr.isSuccess()) {
                        System.debug('Successfully updated role' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');   
                            if(roleIntegerMap.containsKey(idx)){
                                IB_Role__c roleRec = roleIntegerMap.get(idx);
                                msgStr = 'Role with' + roleRec.Email__c + 'is not updated successfully for this reason' + err.getMessage() + '\n';
                            }
                                       
                        }
                    }
                    if(String.isNotBlank(msgStr)){
                        errorMessage += msgStr;
                    }
                }
            }
            if(String.isNotBlank(errorMessage)){
                jsonObject.put('success', false);
                jsonObject.put('error', errorMessage);
            }
            else{
                jsonObject.put('success', true);
                jsonObject.put('error', null);
            }
            return jsonObject;
        }
        catch(Exception exp){
            System.debug(Logginglevel.ERROR, exp.getMessage());
            jsonObject.put('success', false);
            jsonObject.put('error', exp.getMessage());
            return jsonObject;    
        } 
    }
    
    @AuraEnabled
    public static void declinedApplicantRoles(List<IB_Role__c> listRole) 
    {
        List<IB_Role__c>roles=new List<IB_Role__c>();
        for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
        {
            rol.Status__c='Declined';
            roles.add(rol);
        }
        try{
            if(roles.size()>0){
                Update roles; 
            } 
        }
        catch(Exception e){  
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }     
    }
    
    /**
* This method will Withdrawn , Confirmed Roles of the Association User.
* @param List of IB_Role__c.
* @return void.
*/

@AuraEnabled
public static Object declineConfimedRoles(List<IB_Role__c> rolesList) {
    Map<String, Object> jsonObject = new Map<String, Object>();
    try{
        String errorMessage = null;
        Map<Integer, IB_Role__c> roleIntegerMap = new Map<Integer, IB_Role__c>();
        Map<Id, IB_Role__c> roleMap = new Map<Id, IB_Role__c>();            
        for(Integer idx = 0; idx < rolesList.size(); idx ++ ){
            roleIntegerMap.put(idx,  rolesList[idx]);
            roleMap.put(rolesList[idx].Id, rolesList[idx] );
        }
        for(IB_Role__c roleIns : roleMap.values()){
            roleIns.Status__c='Withdrawn';
        }
        if(roleMap.values().size() > 0){
            Database.SaveResult[] srList = Database.update(roleMap.values(), true);
            for(Integer idx = 0; idx < srList.size(); idx ++ ){
                String msgStr = null;
                Database.SaveResult sr = srList[idx];
                if (sr.isSuccess()) {
                    System.debug('Successfully updated role' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');   
                        if(roleIntegerMap.containsKey(idx)){
                            IB_Role__c roleRec = roleIntegerMap.get(idx);
                            msgStr = 'Role with' + roleRec.Email__c + 'is not updated successfully for this reason' + err.getMessage() + '\n';
                        }        
                    }
                }
                if(String.isNotBlank(msgStr)){
                    errorMessage += msgStr;
                }   
            }
        }
        if(String.isNotBlank(errorMessage)){
            jsonObject.put('success', false);
            jsonObject.put('error', errorMessage);
        }
        else{
            jsonObject.put('success', true);
            jsonObject.put('error', null);
        }
        return jsonObject;
    }
    catch(Exception exp){
        System.debug(Logginglevel.ERROR, exp.getMessage());
        jsonObject.put('success', false);
        jsonObject.put('error', exp.getMessage());
        return jsonObject;    
    } 
}

    
    @AuraEnabled
    public static void declinedConfimRoles(List<IB_Role__c> listRole) 
    {
        try{  
            List<IB_Role__c>roles=new List<IB_Role__c>();
            for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
            {
                rol.Status__c='Withdrawn';
                roles.add(rol);
            }
            
            if(roles.size()>0){
                Update roles;
            }
        }
        catch(Exception e){
            System.debug(Logginglevel.ERROR, e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}