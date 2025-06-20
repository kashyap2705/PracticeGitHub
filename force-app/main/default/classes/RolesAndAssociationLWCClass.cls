/**
* <h1>Validate other Users</h1>
* This Class is reponsible for getting all conformed and Applicant Role of Institute Users as well as declined Roles of Institutute Users;
* INST0054.
* @author  Ahmad Shakeel.
* @version 1.0
* @since   06-09-2020.
*/
public Without Sharing class RolesAndAssociationLWCClass {
    Private static  list<account>account=[select id,name,IBIS_ID__c,IB_Transcript_Method__c from Account where id=:[select contact.AccountId from user where id=:userInfo.getUserId()].contact.AccountId  limit 1];
    
    @AuraEnabled (cacheable=true )/** For ECM00565 Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
    public static List<IB_Role__c> getRoleList() {
        
        if(account.size()>0){
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c, Date_Confirmed__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Status__c
                    FROM IB_Role__c 
                    WHERE Status__c='Applicant' AND Email_Confirmed__c=true AND 
                    (IB_Role_Name__c!='Institute Administrator') AND 
                    (IB_Role_Name__c='Institute Transcript User' or IB_Role_Name__c='Communication User' or IB_Role_Name__c='Institute Policy User' ) 
                    AND IB_Account__c=:account[0].id]; 
        }
        return null;    
    }
    
    //--Following code is updated by Shehryar-Plumlogix of SA in US12210 on 4/7/2021-->
    //-- Updated to get both transcript & admininistrator user roles
    //--Start-->  
    @AuraEnabled (cacheable=true )/** For ECM00565  Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
    public static List<IB_Role__c> getRoleListConfirmed() {
        // this code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
        // start
        if(account.size()>0){
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,Status__c
                    FROM IB_Role__c 
                    WHERE Status__c='Confirmed' AND 
                    (IB_Role_Name__c='Institute Administrator' or IB_Role_Name__c='Institute Transcript User' or 
                     IB_Role_Name__c='Communication User' or IB_Role_Name__c='Institute Policy User') and IB_Account__c=:account[0].id];
            
        }
        return null;
        //end
    }
    
    @AuraEnabled (cacheable=true )/** For ECM00565  Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
    public static List<IB_Role__c> getRoleListTransConfirmed() {
        if(account.size()>0){
            return [SELECT Id, Contact_name__c, Email__c,ContactInfo_Emailvalue__c,IB_Account__c,IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c 
                    FROM IB_Role__c 
                    WHERE Status__c='Confirmed' AND 
                    (IB_Role_Name__c='Institute Transcript User' or IB_Role_Name__c='Institute Policy User' or IB_Role_Name__c='Institute Administrator') and IB_Account__c=:account[0].id];
        }
        return null;
    }
    
    @AuraEnabled (cacheable=true)/** For ECM00565  Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
    public static Boolean isInstituteRole() {
        List<User> userList = [SELECT contact.AccountId,contactid, Name ,Email FROM User WHERE Id=: userInfo.getUserId() LIMIT 1];
        if(userList.size() > 0){
            User userIns = userList[0];
            List<IB_role__c> roleist = new List<IB_role__c>();
            if(AccClass.getAccounts()!=null){
                roleist = [SELECT ID 
                           FROM IB_role__c 
                           WHERE IB_Account__c=:userIns.contact.AccountId  AND IB_contact__c=:userIns.contactid
                           AND status__c='Confirmed' AND 
                           (IB_Role_Name__c='Institute Administrator' OR IB_Role_Name__c='Institute Transcript User' 
                            OR IB_Role_Name__c='Communication User' OR IB_Role_Name__c='Institute Policy User' )];
            }
            if(roleist.size() > 0){
                return true;
            }else{
                return false;
            }
        }
        return null;
        
    }
    
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
    
    @AuraEnabled
    public static void DeclinedApplicantRoles(List<IB_Role__c> listRole) 
    {
        List<IB_Role__c>roles=new List<IB_Role__c>();
        for(IB_Role__c rol:[SELECT Id, Name,Status__c,IB_Account__c,IB_Contact__c, Email__c, Date_Confirmed__c,IB_Role_Name_es__c FROM IB_Role__c WHERE Id IN:listRole])
        {
            if (rol == null) {
                throw new AuraHandledException('No records found for the provided IDs');
            }
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
    
    @AuraEnabled
    public static void ConfirmTranscriptUser() 
    {
        try{  
            User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
            List<IB_Role__c> institute_admin = [Select id,Job_Title__c,Contact_Information_Email__c,Contact_Information_Phone__c,IB_Account__c,IB_Role_Name__c,IB_Role__c from IB_Role__c where IB_Contact__c = :userTemp.ContactId AND Status__c = 'Confirmed' AND IB_Account__c = :account[0].id AND IB_Role_Name__c = 'Institute Administrator' Limit 1];
            //this code is edited by developer Ali Haider bajwa-plumlogix for ECM324 of staff aug project
            //start
            IB_Role_Repository__c role_repo = [Select id,Role_Level__c from IB_Role_Repository__c  where Role_Name__c = 'Institute Transcript User' or Role_Name__c = 'Communication User' Limit 1];
            //end
            IB_Role__c transcritp_users = new IB_Role__c();
            transcritp_users.Status__c = 'Confirmed';
            transcritp_users.IB_Contact__c = userTemp.ContactId;
            transcritp_users.IB_Role__c = role_repo.id;
            transcritp_users.IB_Account__c = account[0].id;
            transcritp_users.Contact_Information_Email__c = institute_admin[0].Contact_Information_Email__c;
            transcritp_users.Contact_Information_Phone__c = institute_admin[0].Contact_Information_Phone__c;
            transcritp_users.Job_Title__c = institute_admin[0].Job_Title__c;
            transcritp_users.Email_Confirmed__c=true;
            transcritp_users.Role_Level__c = role_repo.Role_Level__c;
            insert transcritp_users;
            account[0].IB_Transcript_Method__c = 'Electronic';
            update account;
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