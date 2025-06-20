public without sharing class ContactsOfSchool {
    
    @AuraEnabled
    public static Integer getConfirmedOrInvitedRoleCount(Id accountId,String programmeName) {

       

        return [
            SELECT COUNT()
            FROM IB_Role__c
            WHERE IB_Account__c = :accountId
            AND Status__c IN ( 'Invited') //'Confirmed',
            AND IB_Role_Name__c= 'Chief Invigilator' 
            AND Programme_Selection__c =: programmeName
        ];
    }
    
    
    @AuraEnabled
    public static void upsertRolesOfConatct(String programmeName , Id schoolId, List<Id> contactIds,List<Id> withDrawalContactIds){
        system.debug('contactId**'+contactIds);
        system.debug('schoolId**'+schoolId);
        system.debug('withDrawalContactIds**'+withDrawalContactIds);
          system.debug('programmeName**'+programmeName);
        List<IB_Role__c> insertRolesList= new List<IB_Role__c>();
        List<IB_Role__c>  singleContactRoleCI = new List<IB_Role__c>();
        
        if(withDrawalContactIds != null && !withDrawalContactIds.isEmpty()){
                   /** if(programmeName =='DP'){
                programmeName='Diploma Programme';
            }**/
            List<IB_Role__c> rolesTobeWithDrawn=[select id,name,Disable_CI_Role__c,IB_Account__c,Programme_Selection__c,IB_Contact__r.User_Language__c,
                                                 IB_Role_Name__c,Email__c, IB_Account__r.Name,IB_Contact__r.Name from IB_Role__c 
                                                 where 
                                                 IB_Role_Name__c= 'Chief Invigilator'
                                                 and Status__c = 'Confirmed' and IB_Contact__c in: withDrawalContactIds 
                                                 and  Programme_Selection__c = : programmeName];
            if(!rolesTobeWithDrawn.isEmpty()){                                    
            for(IB_Role__c role:rolesTobeWithDrawn ){
                
                role.Status__c='Withdrawn';
                if(role.Disable_CI_Role__c == true)
                {
                   singleContactRoleCI.add(role);
                }
                
            }
            update rolesTobeWithDrawn;
            }
            
            
        }
        
      
        
        
        if(!contactIds.isEmpty() ){
        List<IB_Role_Repository__c> ciRoleRepository = [select id, name,Role_Name__c from 
                                                        IB_Role_Repository__c where Role_Name__c= 'Chief Invigilator' limit 1];
        system.debug('programmeName****'+programmeName);
        system.debug('schoolId****'+schoolId);
        if(programmeName =='DP'){
            programmeName='Diploma Programme';
        }
        List<IB_Programme__c> ibPrograme=[select id, RecordTypeId, Account__c from IB_Programme__c 
                                          where RecordType.Name=: programmeName and Account__c=: schoolId limit 1]; //'CP'
        
        system.debug('ciRoleRepository****'+ciRoleRepository);
        system.debug('ciRoleRepository****'+ciRoleRepository[0].id);
        system.debug('ibPrograme****'+ibPrograme);
        
        
        for(Id conctactId: contactIds){ 
            IB_Role__c role = new IB_Role__c();
            if (!ciRoleRepository.isEmpty()){
                role.IB_Role__c =ciRoleRepository[0].id;
            }
            role.IB_Contact__c= conctactId;
            role.Status__c = 'Confirmed';
            role.IB_Account__c = schoolId;
            if(!ciRoleRepository.isEmpty()){
                role.IB_Programme_New__c =ibPrograme[0].id;
            }
            //srole.Programme_Selection__c= programmeName; //'CP';
            
            
            insertRolesList.add(role);
            
        }
        }
        try{
            system.debug('insertRolesList****'+insertRolesList);
            if(!insertRolesList.isEmpty())
            insert insertRolesList;
            system.debug('after insert insertRolesList****'+insertRolesList);
            
            if(!contactIds.isEmpty() && !insertRolesList.isEmpty()){
                sendEmailToConfirmedContact(contactIds,insertRolesList);
            }
            if(!withDrawalContactIds.isEmpty() && singleContactRoleCI.isEmpty()){
                sendEmailToWithDrawalContact(withDrawalContactIds,schoolId,programmeName);
            }
            if(!singleContactRoleCI.isEmpty()){
                IB_NewCIRoleAdded.withdrawTheUserWhoRequestedCIRole(singleContactRoleCI);
            }
            
            
        }catch(EXception e){
            System.debug('Excpetion occured in class ContactsOfSchool**'+e.getMessage()+e.getLinenUmber());
        }
    }
    
    
    @AuraEnabled
    public static List<IB_Role__c> getAllContactsOfSchool(Id schoolId){
        system.debug('schoolId**'+schoolId);
        
        List<IB_Role__c> ibRoles=[select id,name, IB_Contact__r.Name, Status__c, IB_Role_Name__c ,
                                  Programme_Selection__c, IB_Account__c, IB_Contact__c from IB_Role__c
                                  where IB_Account__c=: schoolId 
                                  and Status__c='Confirmed' 
                                  and IB_Contact__r.RecordTYpe.Name = 'Standard Contact'
                                 ];
        return ibRoles;
    }
    
    @AuraEnabled
    public static void sendEmailToConfirmedContact(List<Id> contactIds, List<IB_Role__c> insertRolesList){
        List<Id> rolesId= new List<Id>();
        for(IB_Role__c role:insertRolesList){
            rolesId.add(role.Id);
}
        
        
        User contactOwner = [Select id, FirstName, LastName, Name , Email,LanguageLocaleKey from User where id=: UserInfo.getUserId() Limit 1];
        List<IB_Role__c> rolesList = [Select id,IB_Contact__r.Name,IB_Role_Name__c,IB_Account__r.Name, Account_Name__c,Contact_name__c,IB_Contact__r.User_Language__c, Programme_Selection__c,
                                      Email__c,IB_Contact__r.Email from IB_Role__c where IB_Role_Name__c ='Chief Invigilator' and IB_Contact__c IN :contactIds and id in: rolesId];
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        String developerName;
        List<String> isDuplicate= new List<String>();
        for (IB_Role__c role : rolesList) {
            
            if(isDuplicate.contains(role.Email__c)){
                continue;
            }
            isDuplicate.add(role.Email__c);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            if(role.IB_Contact__r.User_Language__c=='fr'){
                developerName = 'PIMS_CI_Confirmation_fr';
            }else if(role.IB_Contact__r.User_Language__c=='es'){
                developerName = 'PIMS_CI_Confirmation_es';
            }else{
                developerName = 'PIMS_CI_Confirmation';
            }
            
            EmailTemplate template;  
            try {
                template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
            } catch (Exception e) {
                
            }
            
            if (owea.size()>0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            String plainSubject= template.Subject;
            plainSubject = plainSubject.replace('[roleName]', role.IB_Role_Name__c);
            plainSubject = plainSubject.replace('[schoolName]', role.IB_Account__r.Name);
            String[] toAddresses = new String[] {role.Email__c};
                mail.setToAddresses(toAddresses);
            mail.setSubject(plainSubject);
            String plainBody = template.Body;
            plainBody = plainBody.replace('[CI]', role.IB_Contact__r.Name);
            plainBody = plainBody.replace('[roleName]', role.IB_Role_Name__c);
            plainBody = plainBody.replace('[Programme]', role.Programme_Selection__c);
            plainBody = plainBody.replace('[PC]', contactOwner.Name);
            
            mail.setPlainTextBody(plainBody);
            messages.add(mail);
            
            //Messaging.SendEmailResult[] results = Messaging.sendEmail(
            //  new Messaging.SingleEmailMessage[] { mail });
        }
        Messaging.sendEmail(messages);
        
    }
    
    
    @AuraEnabled
    public static void sendEmailToWithDrawalContact(List<Id> withDrawalContactIds,Id schoolId, String programmeName){
        
        //User contactOwner = [Select id, FirstName, LastName, Name , Email,LanguageLocaleKey from User where id=: UserInfo.getUserId() Limit 1];
        
        if(programmeName == 'Diploma Programme')
        {
            programmeName='DP';
        }
        List<IB_Role__c> rolesList = [Select id,IB_Contact__r.Name,IB_Account__c, IB_Role_Name__c,IB_Account__r.Name, Account_Name__c,Contact_name__c,IB_Contact__r.User_Language__c, Programme_Selection__c,
                                      Email__c,IB_Contact__r.Email from IB_Role__c where IB_Role_Name__c ='Chief Invigilator' and IB_Contact__c IN :withDrawalContactIds
                                     and IB_Account__c =:schoolId and Programme_Selection__c=: programmeName];
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        String developerName;
        List<String> isDuplicate= new List<String>();
        for (IB_Role__c role : rolesList) {
            
            if(isDuplicate.contains(role.Email__c)){
                continue;
            }
            isDuplicate.add(role.Email__c);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            if(role.IB_Contact__r.User_Language__c=='fr'){
                developerName = 'PIMS_CI_withdrawn_fr';
            }else if(role.IB_Contact__r.User_Language__c=='es'){
                developerName = 'PIMS_CI_withdrawn_es';
                
            }else{
                developerName = 'PIMS_CI_withdrawn';
            }
            
            EmailTemplate template;  
            try {
                template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
            } catch (Exception e) {
                
            }
            
            if (owea.size()>0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            // Get the current user's Id
            Id currentUserId = UserInfo.getUserId();
            
            // Query for the email
            User currentUser = [SELECT Email FROM User WHERE Id = :currentUserId LIMIT 1];
            
            String plainSubject= template.Subject;
            plainSubject = plainSubject.replace('[schoolName]', role.IB_Account__r.Name);
            plainSubject = plainSubject.replace('[roleName]', role.IB_Role_Name__c);   
            String[] toAddresses = new String[] {role.Email__c};
                mail.setToAddresses(toAddresses);
            mail.setCCAddresses(new String[]{ currentUser.Email });
            mail.setSubject(plainSubject);
            String plainBody = template.Body;
            plainBody = plainBody.replace('[CI]', role.IB_Contact__r.Name);
            plainBody = plainBody.replace('[roleName]', role.IB_Role_Name__c);
            plainBody = plainBody.replace('[schoolName]', role.IB_Account__r.Name);
            
            mail.setPlainTextBody(plainBody);
            messages.add(mail);
            
            //Messaging.SendEmailResult[] results = Messaging.sendEmail(
            //  new Messaging.SingleEmailMessage[] { mail });
        }
        Messaging.sendEmail(messages);
        
    }
    
    
    /** Added for DAS **/
    
    @AuraEnabled
    public static Map<String, String> getTranslationsMap(String userLanguage) { 
        final List<String> constantList = new List<String>{IboUtil.PIMS_Saving ,IboUtil.PIMS_Update ,IboUtil.PIMS_Selected, IboUtil.PIMS_Selection , IboUtil.PIMS_CHIEF_INVIGILATOR,IboUtil.PIMS_CI_ROLE_LIMIT_ERROR, IboUtil.PIMS_Success };
            
            try {
                system.debug('userLanguage**'+userLanguage);
                if(userLanguage=='fr'){
                    userLanguage='French';
                }
                else if(userLanguage=='es'){
                    userLanguage='Spanish';
                }
                else{
                    userLanguage='American English';
                }
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                     WHERE CustomLabel__r.Label__c =: constantList
                                                     AND Language__c = :userLanguage];
                Map<String, String> translationsMap;
                translationsMap = new Map<String, String>();
                
                for (Translation__c translation : translations) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                } 
                system.debug('translationsMap**'+translationsMap);
                system.debug('translationsMap**'+String.valueOf(translationsMap));
                
                return translationsMap;
            }
        catch (Exception ex) {
            
            Logger.get().add(ex, LogSeverity.ERROR).publish();  
            return null;
        }
        
        
        
    }
    
    /** End of Added for DAS **/
    
    
    
    
    
    
}