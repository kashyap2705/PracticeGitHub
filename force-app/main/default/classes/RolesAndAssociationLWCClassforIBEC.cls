/**
* This Class is reponsible for getting all confirmed and Applicant Role of IBEC Institute Users as well as declined Roles of IBEC Institute Users;
* ECM-00226.
* @author  Arbaz Sharif.
* @version 1.0
* @since   12-21-2021.
*/
public without sharing class  RolesAndAssociationLWCClassforIBEC {
    Private static list<account> account = [select id,name,IBIS_ID__c,IB_Transcript_Method__c from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId  limit 1];


    @AuraEnabled( cacheable = true )
    public static List< Account > fetchAccounts() {
        return [ select id,name,IBIS_ID__c,IB_Transcript_Method__c from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId  limit 1];
    }

    @AuraEnabled
    public static string updateAccounts( Object data ) {
        List < IB_Role__c > accsForUpdate = ( List < IB_Role__c > ) JSON.deserialize(JSON.serialize( data ),List < IB_Role__c >.class);
        try {
            update accsForUpdate;
            return 'Success: End Date updated successfully';
        }
        catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return ('The following exception has occurred: ' + e.getMessage());
        }
    }

    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleList() {
        if(account.size()>0){
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c, Date_Confirmed__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Start_Date__c,End_Date__c,IB_Account__c,status__c FROM IB_Role__c WHERE Status__c='Applicant' AND Email_Confirmed__c=true AND (IB_Role_Name__c='IBEC Candidate' OR IB_Role_Name__c='IBEC Faculty Member') AND IB_Account__c=:account[0].id];
        }
        return null;    
    }

    @AuraEnabled (cacheable=true )
    public static List<IB_Role__c> getRoleListConfirmed() {
        if(account.size()>0) {
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,End_Date__c, IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Status__c FROM IB_Role__c WHERE Status__c='Confirmed' AND (IB_Role_Name__c='IBEC Candidate' OR IB_Role_Name__c='IBEC Faculty Member') and IB_Account__c=:account[0].id];  
        }
        return null;
    }

    @AuraEnabled
    public static void AddSelectedItems(List<IB_Role__c> listRole) {
        try{
            List<IB_Role__c>roles=new List<IB_Role__c>();
            for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c,End_Date__c FROM IB_Role__c WHERE Id IN:listRole])
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
    public static void DeclinedApplicantRoles(List<IB_Role__c> listRole) {
        List<IB_Role__c>roles=new List<IB_Role__c>();
        for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c,End_Date__c FROM IB_Role__c WHERE Id IN:listRole])
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
    

    @AuraEnabled
    public static void DeclinedConfirmRoles(List<IB_Role__c> listRole) {
        try{  
            List<IB_Role__c>roles=new List<IB_Role__c>();
            for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c,End_Date__c FROM IB_Role__c WHERE Id IN:listRole])
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

    @AuraEnabled
    public static Object saveRoles( List<IB_Role__c> rolesList) {
        Map<String, Object> jsonObject = new Map<String, Object>();
        try{
            String errorMessage = null;
            Map<Integer, IB_Role__c> roleIntegerMap = new Map<Integer, IB_Role__c>();
            Map<Id, IB_Role__c> roleMap = new Map<Id, IB_Role__c>();            
            for(Integer idx = 0; idx < rolesList.size(); idx ++ ){
                roleIntegerMap.put(idx, rolesList[idx]);
                roleMap.put(rolesList[idx].Id, rolesList[idx] );
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
}