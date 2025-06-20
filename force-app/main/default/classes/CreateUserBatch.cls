global class CreateUserBatch implements Database.Batchable<sObject>,Database.Stateful{
    global static boolean userTriggerExecution = True;
    global static String Query;
    global Set<contact> contactlisttoUpdate = new Set<contact> () ;
    global List<IB_Role__c> IBRolesToUpdate;
    global map<Id,Id> contactIDVsUserId = new map<Id,Id>();
    global Set<Id> ContactIds = new Set<Id>();
    global Map<Id,IB_Role__c> newRole;
    global Map<Id,Contact> mapOfContactToProcesses;
    global list<id> idRoles;
    global CreateUserBatch(Map<Id,IB_Role__c> newRoles,Map<Id,Contact> mapOfContactToProcess ){
        system.debug('newRoles '+newRoles);
        system.debug('mapOfContactToProcess '+mapOfContactToProcess);
        IBRolesToUpdate = new List<IB_Role__c>();
        contactlisttoUpdate = new Set<contact>();
        newRole = new Map<Id,IB_Role__c>();
        newRole.putAll(newRoles);
        mapOfContactToProcesses = new Map<Id,Contact>();
        mapOfContactToProcesses.putAll(mapOfContactToProcess);
        system.debug('newRole '+newRole);
        system.debug('mapOfContactToProcesses '+mapOfContactToProcesses);
        this.idRoles = new list<id>();
        this.idRoles.addAll(newRole.Keyset());
        system.debug('IDs'+this.idRoles);
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('IDS:'+ idRoles);
        query = 'Select id,Name from IB_Role__c where id in: idRoles';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<User> userlisttoInsert = new List<User>();
       // UserRole roleToPopulateonUser= [SELECT Id FROM UserRole where DeveloperName = 'IBENGlobalPartnerUser'];
        Id profileId = [select Name,Id from Profile where Name = 'SCU + Basic'].Id;
        for(Id conId : mapOfContactToProcesses.keyset()){
            User user = new User(); 
            user.FirstName = mapOfContactToProcesses.get(conId).FirstName;
            user.LastName = mapOfContactToProcesses.get(conId).LastName;
            //user.UserRoleId = roleToPopulateonUser.ID;
            user.Alias =  'IBEN'; 
            user.ContactId = conId;
            user.LanguageLocaleKey = 'en_US';
            user.ProfileId = profileId;
            user.IsActive = True;
            user.isExaminingUser__c = true;
            //user.Username = mapOfContactToProcesses.get(conId).Email+mapOfContactToProcesses.get(conId).LastName+ 'IB';
            user.Username = mapOfContactToProcesses.get(conId).Email;
            user.Email = mapOfContactToProcesses.get(conId).Email; 
            user.LocaleSidKey = 'en_US';
            user.TimeZoneSidKey  = 'GMT';
            user.EmailEncodingKey = 'UTF-8';
            userlisttoInsert.add(user);
        }
        
        
        if (!userlisttoInsert.isEmpty()) {
            Set<Id> contactSetIds = new Set<Id>();
            if(!Test.isRunningTest()){
                CreateUserBatch.userTriggerExecution = false;
                system.debug('--->'+userlisttoInsert);
                try{
                    Insert userlisttoInsert;
                }catch(Exception e)
                {
                    system.debug('e --->'+e);
                }
                CreateUserBatch.userTriggerExecution = True;
                for(user u : userlisttoInsert){
                    contactIDVsUserId.put(u.ContactId,u.id);
                    ContactIds.add(u.ContactId);
                }
            }
            //Check Permissions
            ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(ContactIds));
            SyncUserIdWithContact.SyncUserIdWithContactnonfuture(ContactIds);
            
            for(contact con : mapOfContactToProcesses.values()){
                con.User__c = !Test.isRunningTest() ? contactIDVsUserId.get(con.id) : UserInfo.getUserId();  
                if(!con.IBEN_Examiner_Account_Setup__c)
                    con.IBEN_Examiner_Account_Setup__c = true;
                contactlisttoUpdate.add(con);
                system.debug('CreateUserBatch');
            }
            system.debug('CreateUserBatch::'+contactlisttoUpdate);
            for(IB_Role__c obj : newRole.values()){
                IBRolesToUpdate.add(obj);
            }
        } 
    }
    
    
    global void finish(Database.BatchableContext BC){
       system.debug('contactlisttoUpdate'+contactlisttoUpdate);
       /* 
        if(!contactlisttoUpdate.isEmpty()){
            update contactlisttoUpdate;
        }*/
         system.debug('IBRolesToUpdate'+ IBRolesToUpdate);
        if(!IBRolesToUpdate.isEmpty()){
          //  ID jobID = System.enqueueJob(new ContactQueuebleJob(contactlisttoUpdate));
            //SendEmail();
             /* for(contact con : contactlisttoUpdate){
                if(!con.IBEN_Examiner_Account_Setup__c)
                    con.IBEN_Examiner_Account_Setup__c = true;
            }
            if(!contactlisttoUpdate.isEmpty()){
                update contactlisttoUpdate;
            }*/
            system.debug('contactlisttoUpdate'+ contactlisttoUpdate);
        }
        system.debug('finish called.');
    }
    
   /* global void SendEmail(){
        String templateName = 'EN_New_IBE_user_account_access'; //default
        Set<String> IBroleName = new Set<String>{'Examiner','Exam Team Leader','Principal Examiner','Deputy Examiner Responsible','Examiner Responsible','Chief Examiner'};
            system.debug('in send'+ IBRolesToUpdate);
        List<Messaging.SingleEmailMessage> emaillist = new List<Messaging.SingleEmailMessage>();
        for(IB_Role__c role : IBRolesToUpdate){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(role.IB_Contact__c); 
            if(role.IB_Role_Name__c != null && IBroleName.contains(role.IB_Role_Name__c) && role.ContactUserLanguage__c == 'en_US' && mapOfContactToProcesses.containskey(role.IB_Contact__c) &&
               mapOfContactToProcesses.get(role.IB_Contact__c).IBEN_Examiner_Account_Setup__c == false &&
               mapOfContactToProcesses.get(role.IB_Contact__c).Examiner_training_username__c !=null){
                   templateName='EN_New_IBE_user_account_access';
               }else if(role.IB_Role_Name__c != null && IBroleName.contains(role.IB_Role_Name__c) && role.ContactUserLanguage__c == 'es' && mapOfContactToProcesses.containskey(role.IB_Contact__c) &&
                        mapOfContactToProcesses.get(role.IB_Contact__c).IBEN_Examiner_Account_Setup__c == false &&
                        mapOfContactToProcesses.get(role.IB_Contact__c).Examiner_training_username__c !=null){
                            templateName='SP_New_IBE_user_account_access';
                        }else if(role.IB_Role_Name__c != null && IBroleName.contains(role.IB_Role_Name__c) && role.ContactUserLanguage__c == 'fr' && mapOfContactToProcesses.containskey(role.IB_Contact__c) &&
                                 mapOfContactToProcesses.get(role.IB_Contact__c).IBEN_Examiner_Account_Setup__c == false &&
                                 mapOfContactToProcesses.get(role.IB_Contact__c).Examiner_training_username__c !=null){
                                     templateName='FR_New_IBE_user_account_access';
                                 }/*else if(role.IB_Role_Name__c != null && IBroleName.contains(role.IB_Role_Name__c) && role.ContactUserLanguage__c == 'ja' && mapOfContactToProcesses.containskey(role.IB_Contact__c) &&
                                          mapOfContactToProcesses.get(role.IB_Contact__c).IBEN_Examiner_Account_Setup__c == false &&
                                          mapOfContactToProcesses.get(role.IB_Contact__c).Examiner_training_username__c !=null){
                                              templateName='JA_New_IBE_user_account_access';
                                          }else if(role.IB_Role_Name__c != null && IBroleName.contains(role.IB_Role_Name__c) && role.ContactUserLanguage__c == 'ko' && mapOfContactToProcesses.containskey(role.IB_Contact__c) &&
                                                   mapOfContactToProcesses.get(role.IB_Contact__c).IBEN_Examiner_Account_Setup__c == false &&
                                                   mapOfContactToProcesses.get(role.IB_Contact__c).Examiner_training_username__c !=null){
                                                       templateName='KO_New_IBE_user_account_access';
                                                   }
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where Developername = :templateName];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(role.Id); 
            message.toAddresses = new String[] { role.Email__c  };
                emaillist.add(message);
        }
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emaillist);
        
    } */
}