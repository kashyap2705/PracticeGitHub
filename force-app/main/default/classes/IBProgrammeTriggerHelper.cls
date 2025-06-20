public class IBProgrammeTriggerHelper {

    //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --Started--
    Public static List<Attachment> attachmentsToInsert = new List<Attachment>();
    //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --ENDS--  
     
    // added by kashyap for part 3 
    public static void getAuthorizedProgramme( Set<Id> accountIds, List<IB_programme__c> newList, Map<Id, Account> accountMap, 
                                              Map<Id, User> userMap ) {
                                                  List<Messaging.SingleEmailMessage> emailsToSend1 = new List<Messaging.SingleEmailMessage>();
                                                  List<IB_Programme__c> authorizedProgrammes = [SELECT Id, recordtype.name,Language_of_Correspondence_Acct__c,Status__c
                                                                                                FROM IB_Programme__c 
                                                                                                WHERE Account__c IN :accountIds 
                                                                                                AND Status__c = 'Authorized' 
                                                                                                
                                                                                               ];
                                                  
                                                  system.debug('authorizedProgrammes**'+authorizedProgrammes);
                                                  Map<String,List<String>> authorizedProgrammesMap = new  Map<String,List<String>>();
                                                  Map<Id,IB_Programme__c> programmeMap= new Map<Id,IB_Programme__c>();
                                                  
                                                  for(IB_Programme__c ibProgramme: authorizedProgrammes){
                                                      programmeMap.put(ibProgramme.id,ibProgramme);
                                                      if(!authorizedProgrammesMap.containsKey((ibProgramme.Status__c))){
                                                          authorizedProgrammesMap.put(ibProgramme.Status__c,new List<String>{ibProgramme.recordtype.name} );
                                                      }else{
                                                          authorizedProgrammesMap.get(ibProgramme.Status__c).add(ibProgramme.recordtype.name);
                                                      }
                                                  }
                                                  // Check if the required record types exist
                                                  system.debug('authorizedProgrammesMap**'+authorizedProgrammesMap);
                                                  
                                                  if (authorizedProgrammesMap.containsKey('Authorized')) {
                                                      List<String> authorizedRecordTypes = authorizedProgrammesMap.get('Authorized');
                                                      if (authorizedRecordTypes.contains('PYP') && authorizedRecordTypes.contains('MYP') 
                                                          && (authorizedRecordTypes.contains('CP') || authorizedRecordTypes.contains('Diploma Programme'))
                                                         ) {
                                                             Set<String> templateDeveloperNames = new Set<String>{
                                                                 'Becoming_a_new_IB_Continuum_school_English','Becoming_a_new_IB_Continuum_school_Spanish','Becoming_a_new_IB_Continuum_school_French'};
                                                                     Map<String, EmailTemplate> templateMap = IBProgrammeTriggerHelper.createEmailTemplateMap(templateDeveloperNames);
                                                            List<String> toaddress= new List<String>();
                                                             Map<String,List<String>> nameEmailMap = new  Map<String,List<String>>();
                                                             
                                                             
                                                             
                                                             List<IB_Role__c> roleListForAccount= [SELECT Id, IB_Account__c,IB_Contact__c, Email__c,IB_Contact__r.Email, IB_Contact__r.Name, IB_Programme_New__c, IB_Role_Name__c, Status__c 
                                                                                                   FROM IB_Role__c 
                                                                                                   WHERE IB_Account__c IN :accountIds
                                                                                                   AND Status__c = 'Confirmed' 
                                                                                                   AND IB_Role_Name__c = 'Head of School (Overall)' 
                                                                                                      
                                                                                                   ];
                                                             
                                                            
                                                             Set<Id> hosOverallAccounts= new Set<Id>();
                                                             if(!roleListForAccount.isEmpty()){
                                                                 for(IB_Role__c r : roleListForAccount)
                                                                 {
                                                                     hosOverallAccounts.add(r.IB_Account__c);
                                                                    
                                                                 }
                                                             }
                                                             // Derive accountIds WITHOUT Head of School role
                                                             Set<Id> accountIdsWithouthosOverallAccounts= new Set<Id>();
                                                             
                                                                             for (Id checkId: accountIds) {
                                                                                 
                                                                                    if (!hosOverallAccounts.contains(checkId)) {
                                                                                        accountIdsWithouthosOverallAccounts.add(checkId); // only in A, not in B
                                                                                    }
                                                                                    }

                                                             
                                                            List<IB_Role__c >  roleListForhosAccount = new List<IB_Role__c >();
                                                             if(accountIdsWithouthosOverallAccounts.size()> 0){
                                                               roleListForhosAccount  = [SELECT Id, IB_Account__c,IB_Contact__c, Email__c,IB_Contact__r.Email, IB_Contact__r.Name, IB_Programme_New__c, IB_Role_Name__c, Status__c 
                                                                                      FROM IB_Role__c 
                                                                                      WHERE IB_Account__c IN :accountIdsWithouthosOverallAccounts
                                                                                      AND Status__c = 'Confirmed' 
                                                                                      AND IB_Role_Name__c = 'Head of School' 
                                                                                      AND IB_Programme_New__r.Status__c ='Authorized'
                                                                                      AND IB_Programme_New__r.Recordtype.Name in  ('PYP', 'CP', 'MYP', 'Diploma Programme')];
                                                             }
                                                             
                                                             List<IB_Role__c> finalroleList= new List<IB_Role__c>();
                                                             if(!roleListForAccount.isEmpty())
                                                             finalroleList.addAll(roleListForAccount);
                                                              if(!roleListForhosAccount.isEmpty())
                                                             finalroleList.addAll(roleListForhosAccount);
                                                             
                                                             
                                                             if(finalroleList.size() >0)
                                                             {
                                                                 
                                                                 for(IB_Role__c role:finalroleList ) {
                                                                     
                                                                    
                                                                     
                                                                     if(!nameEmailMap.containsKey(role.IB_Account__c)){
                                                                         nameEmailMap.put(role.IB_Account__c,new List<String>{role.IB_Contact__r.Email+ '-'+role.IB_Contact__r.Name+':'+role.IB_Contact__c});
                                                                     }else
                                                                     {
                                                                         nameEmailMap.get(role.IB_Account__c).add(role.IB_Contact__r.Email+ '-'+role.IB_Contact__r.Name+':'+role.IB_Contact__c);
                                                                     }
                                                                 }
                                                                 system.debug('finalroleList**'+finalroleList.size());
                                                                 
                                                                 
                                                                 
                                                                 OrgWideEmailAddress[] owea = IBProgrammeTriggerHelper.getOrgWideEmailAddress(System.Label.Director_of_IB_world_Schools);
                                                                 
                                                                 for (IB_Programme__c programme :newList ) { 
                                                                     List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
                                                                     system.debug('programme**'+programme);
                                                                     Map<String,String> finalnameEmailMap= new Map<String,String>();
                                                                     
                                                                     if(nameEmailMap!=null && nameEmailMap.get(programme.Account__c) != null){
                                                                         List<String> nameEmailString= nameEmailMap.get(programme.Account__c);
                                                                         for(String s: nameEmailString){
                                                                             finalnameEmailMap.put(s.substringBefore('-'),s.substringAfter('-')  );
                                                                         }
                                                                     }
                                                                     system.debug('finalnameEmailMap**'+finalnameEmailMap);
                                                                     
                                                                     if(userMap != null && !userMap.isEmpty() && accountMap!=null && !accountMap.isEmpty() &&
                                                                        accountMap.containsKey(programme.Account__c) && 
                                                                        userMap.containsKey(accountMap.get(programme.Account__c).OwnerId)){
                                                                            emailsToSend1=  IBProgrammeTriggerHelper.substituteEmailTemplates(programme, templateMap, null, accountMap, userMap,owea, emailsToSend,finalnameEmailMap);
                                                                    } // Atticus Null check ECM00739
                                                                 }
                                                                 
                                                             }
                                                             
                                                             
                                                             
                                                         }
                                                  }
                                                  
                                                  //return emailsToSend1;
                                                  if(!emailsToSend1.isEmpty()){
                                                      sendEmail(emailsToSend1);
                                                  }
                                              }
    
    public static Map<Id, Integer> getAuthorizedProgrammeCount(Set<Id> accountIds) {
        Map<Id, Integer> authorizedCounts = new Map<Id, Integer>();
        for (AggregateResult res : [
            SELECT Account__c, COUNT(Id) cnt
            FROM IB_Programme__c
            WHERE Account__c IN :accountIds AND Status__c = 'Authorized'
            GROUP BY Account__c
        ]) {
            authorizedCounts.put((Id) res.get('Account__c'), (Integer) res.get('cnt'));
        }
        return authorizedCounts;
    }
    
    public static List<IB_Role__c> getIbRolesByProgrammes(Map<Id, IB_Programme__c> programmesById, Set<String> allowedRoles ) {
        
        return [SELECT Id, IB_Contact__c, Email__c,IB_Contact__r.Email, IB_Contact__r.Name, IB_Programme_New__c, IB_Role_Name__c, Status__c 
                FROM IB_Role__c 
                WHERE IB_Programme_New__c IN :programmesById.keySet() 
                AND Status__c = 'Confirmed' 
                AND IB_Role_Name__c IN :allowedRoles];
    }
    
    
    
    public static Map<Id, Map<String, IB_Role__c>> createIbRoleMapByIbProgramme(List<IB_Role__c> ibRolesList) {
        Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap = new Map<Id, Map<String, IB_Role__c>>();
        for (IB_Role__c ibRole : ibRolesList) {
            if (!ibProgrammeVsIBRoleMap.containsKey(ibRole.IB_Programme_New__c)) {
                ibProgrammeVsIBRoleMap.put(ibRole.IB_Programme_New__c, new Map<String, IB_Role__c>());
            }
            ibProgrammeVsIBRoleMap.get(ibRole.IB_Programme_New__c).put(ibRole.IB_Role_Name__c, ibRole);
        }
        return ibProgrammeVsIBRoleMap;
    }
    
    public static Map<String, EmailTemplate> createEmailTemplateMap(Set<String> templateDeveloperNames) {
        Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
        for (EmailTemplate empTemp : [SELECT Id, Body, HtmlValue, DeveloperName, Subject
                                      FROM EmailTemplate 
                                      WHERE DeveloperName IN :templateDeveloperNames]) {
                                          templateMap.put(empTemp.DeveloperName, empTemp);
                                      }
        
        return templateMap;
    }
    
    public static List<OrgWideEmailAddress> getOrgWideEmailAddress(String emailaddress) {
        return [SELECT Id FROM OrgWideEmailAddress WHERE Address =: emailaddress];
    }
    
    public static Map<Id, Account> getAccountMap(Set<Id> accountIds) {
        return new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
    }
    
    public static Set<Id> getAccountOwnerIds(Map<Id, Account> accountMap) {
        Set<Id> ownerIds = new Set<Id>();
        for (Account acc : accountMap.values()) {
            ownerIds.add(acc.OwnerId);
        }
        return ownerIds;
    }
    
    public static Map<Id, User> getUserMap(Set<Id> ownerIds) {
        //Link_to_book_online_meetings__c field added by Prerna on 29-04-2025 for 739-Phase 2
        return new Map<Id, User>([SELECT Id, Name, FirstName, Department,Email, Link_to_book_online_meetings__c FROM User WHERE Id IN :ownerIds AND Department = 'IBWS']);
    }
    
    //***BEWARE*** This method is getting called from within a for loop  ibProgrammeVsIBRoleMap, accountMap,userMap,emailsToSend  //List<Messaging.SingleEmailMessage>
    public static List<Messaging.SingleEmailMessage> substituteEmailTemplates(IB_Programme__c programme, Map<String, EmailTemplate> templateMap, 
                                                                              Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap, Map<Id, Account> accountMap, 
                                                                              Map<Id, User> userMap, List<OrgWideEmailAddress> owea, List<Messaging.SingleEmailMessage> emailsToSend,
                                                                              Map<String,String> nameEmailMap) 
    {
        Set<String> toaddress;
        system.debug('templateMap insdiee***'+templateMap);
        String tmpName = '';
        String templateBody='';
        String tmpSubject;
        String recordTypeName = Schema.getGlobalDescribe().get('IB_Programme__c').getDescribe().getRecordTypeInfosById().get(programme.RecordTypeId).getName();
        String lang = programme.Language_of_Correspondence_Acct__c;
        Set<String> supportedLanguages = new Set<String>{'Spanish', 'French', 'English'};
            
            String keyword = supportedLanguages.contains(lang) ? lang : 'English';
        
        for (String emailTemp : templateMap.keySet()) {
            if (emailTemp.contains(keyword)) {
                tmpName = templateMap.get(emailTemp).DeveloperName;
                tmpSubject = templateMap.get(emailTemp).Subject;
                break;
            }
        }
        
        EmailTemplate emailtemp = templateMap.get(tmpName);
        system.debug('c'+emailtemp);
        
        //IBWSManagerBookingLink added below by Prerna on on 29-04-2025 as part of 739-phase 2
        String hosContactId,headOfSchoolName,programmeCoordinatorName,headOfSchoolEmail,programmeCoordinatorEmail,hosOverallName,hosOverallEmail,IBWSManagerName,IBWSManagerFirstName,SchoolName,IBWSManagerEmail,headOfSchoolOverallEmail,headOfSchoolOverallName, IBWSManagerBookingLink;
        if (ibProgrammeVsIBRoleMap!= null && ibProgrammeVsIBRoleMap.containsKey(programme.id)  ) {
            Map<String, IB_Role__c> rolesMap = ibProgrammeVsIBRoleMap.get(programme.id);
            system.debug('rolesMap***'+rolesMap);
            
            headOfSchoolName = (rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Name != null) ? rolesMap.get('Head of School').IB_Contact__r.Name : null;
            programmeCoordinatorName = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Name != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Name : null;
            headOfSchoolEmail = rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Email != null ? rolesMap.get('Head of School').IB_Contact__r.Email : null;
            programmeCoordinatorEmail = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Email != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Email : null;
            headOfSchoolOverallEmail = rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Email != null ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Email : null;
            headOfSchoolOverallName = (rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Name != null) ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Name : null;
            hosContactId = rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__c != null ? rolesMap.get('Head of School').IB_Contact__c : null;
                      
        }
        
        system.debug('headOfSchoolEmail**'+headOfSchoolEmail);
        system.debug('programmeCoordinatorEmail**'+programmeCoordinatorEmail);
        system.debug('headOfSchoolOverallEmail**'+headOfSchoolOverallEmail);
        
        if (programme.Account__c != null && accountMap.containsKey(programme.Account__c)) {
            Account acc = accountMap.get(programme.Account__c);
            if (acc.OwnerId != null && userMap.containsKey(acc.OwnerId)) {
                User accountOwner = userMap.get(acc.OwnerId);
                if (accountOwner != null && accountOwner.Name != null && accountOwner.Department =='IBWS') {//
                    IBWSManagerName = accountOwner.Name; // username of Account Owner
                    IBWSManagerFirstName = accountOwner.FirstName;
                    IBWSManagerEmail = accountOwner.Email;
                    //code added by Prerna on 29-04-2025 for 739-Phase2 --STARTS--
                    if(accountOwner.Link_to_book_online_meetings__c != null){
                        IBWSManagerBookingLink = accountOwner.Link_to_book_online_meetings__c;
                    }
                    //code added by Prerna on 29-04-2025 for 739-Phase2 --ENDS--
                }
            }
        }
        
        system.debug('IBWSManagerEmail**'+IBWSManagerEmail);
        system.debug('emailtemp**'+emailtemp);
        system.debug('emailtemp HtmlValue 194**'+emailtemp.HtmlValue);
        
        if( tmpName == 'Becoming_a_new_IB_Continuum_school_English'||  tmpName == 'Becoming_a_new_IB_Continuum_school_Spanish'  || 
           tmpName =='Becoming_a_new_IB_Continuum_school_French') {
               
               if(nameEmailMap!= null){ 
                   toaddress= nameEmailMap.keySet();   
               }
               for(String s:toaddress ){  
                   
                   if(emailtemp != null &&  emailtemp.HtmlValue != null) {
                       if ( toaddress!= null) {
                           templateBody = emailtemp.HtmlValue;
                           
                           if (templateBody.contains('{IBWSManagerName}') && IBWSManagerName != null) {
                               templateBody = templateBody.replace('{IBWSManagerName}', IBWSManagerName);
                           }
                       }
                   }
                   
                   
                   
                   
                   String hosName= nameEmailMap.get(s).split(':')[0];//enhanced newly
                   String hosContactIdForTemplate= nameEmailMap.get(s).split(':')[1];//enhanced newly
                   String hosemail= s;
                   if (templateBody.contains('{Name}') ) {
                       templateBody = templateBody.replace('{Name}', hosName );
                   }
                   
                   Messaging.SingleEmailMessage headOfSchoolEmailMessage = new Messaging.SingleEmailMessage();
                   headOfSchoolEmailMessage.setHtmlBody(templateBody);
                   headOfSchoolEmailMessage.setSubject(tmpSubject);
                   headOfSchoolEmailMessage.setToAddresses(new List<String> { s  });
                   headOfSchoolEmailMessage.setCcAddresses(new List<String>{ IBWSManagerEmail }); // Add CC recipients
                   headOfSchoolEmailMessage.setWhatId(programme.Id);    // Associate email with the IB Programme
                   headOfSchoolEmailMessage.setSaveAsActivity(true);    // Log email in Activity History
                   headOfSchoolEmailMessage.setTargetObjectId(hosContactIdForTemplate);//added newly on 5-5-25
                   headOfSchoolEmailMessage.setUseSignature(false);//added on 12-06-2025
                   if (owea.size() > 0) {
                       headOfSchoolEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                   }
                   
                   system.debug('headOfSchoolEmailMessage***'+headOfSchoolEmailMessage);
                   emailsToSend.add(headOfSchoolEmailMessage);
                   // Generate PDF content
                   //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --Started--
                   Attachment attachment = new Attachment();
                   if(programme.Language_of_Correspondence_Acct__c == 'English'){
                       attachment.Name = 'Becoming an IB Continuum School – Welcome Letter.pdf';
                       attachment.Description = 'IBWS Welcome Letter';
                   }
                   if(programme.Language_of_Correspondence_Acct__c == 'French'){
                       attachment.Name = 'Devenir un établissement continuum de l’IB - Lettre de bienvenue.pdf';
                       attachment.Description = 'Lettre de Bienvenue pour les écoles du monde de l’IB';
                   }
                   if(programme.Language_of_Correspondence_Acct__c == 'Spanish'){
                       attachment.Name = 'Carta de bienvenida – Colegio del continuo de programas del IB.pdf';
                       attachment.Description = 'Carta de bienvenida – Colegios del Mundo del IB';
                   }
                   attachment.Body = Blob.toPdf(templateBody);
                   attachment.ContentType = 'application/pdf';  
                   attachment.ParentId = programme.Id;  
                   attachmentsToInsert.add(attachment);
                   //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --ENDS--
               }
           }
        
        if(emailtemp != null &&  emailtemp.HtmlValue != null && (tmpName == 'Auth_IBWS_Adding_a_Programme_English'  || 
                                                                 tmpName == 'Auth_IBWS_Adding_a_Programme_French'  || 
                                                                 tmpName =='Auth_IBWS_Adding_a_Programme_Spanish' )) 
        {
            if (headOfSchoolEmail != null && headOfSchoolName!= null) {
                templateBody = emailtemp.HtmlValue;
                templateBody = templateBody.replace('{Head_of_School_Name}', headOfSchoolName);
                if (templateBody.contains('{IBProgrammeName}') && recordTypeName != null) {
                    templateBody = templateBody.replace('{IBProgrammeName}', recordTypeName);
                }
                if (templateBody.contains('{PrmName}') && programme.Programme_Relationship_Manager_Name__c != null) {
                    templateBody = templateBody.replace('{PrmName}', programme.Programme_Relationship_Manager_Name__c);
                }
                if (templateBody.contains('{AuthorizationPRM}') && programme.Programme_Relationship_Manager_Name__c != null) {
                    templateBody = templateBody.replace('{AuthorizationPRM}', programme.Programme_Relationship_Manager_Name__c);
                }
                if (templateBody.contains('{IBWSManagerName}') && IBWSManagerName != null) {
                    templateBody = templateBody.replace('{IBWSManagerName}', IBWSManagerName);
                }
                if (templateBody.contains('{IBWSFirstName}') && IBWSManagerFirstName != null) {
                    templateBody = templateBody.replace('{IBWSFirstName}', IBWSManagerFirstName);
                }
                if (templateBody.contains('{SchoolName}')) {
                    templateBody = templateBody.replace('{SchoolName}', programme.Account_Name_Text__c);
                }
                if (templateBody.contains('{IBWSManagerEmail}') && IBWSManagerEmail != null) {
                    templateBody = templateBody.replace('{IBWSManagerEmail}', IBWSManagerEmail);
                }
                //Below If block added by Prerna on 29-04-2025 for 739-Phase 2
                if (templateBody.contains('{IBWSManagerBookingLink}') && IBWSManagerBookingLink != null) {
                    templateBody = templateBody.replace('{IBWSManagerBookingLink}', IBWSManagerBookingLink);
                }
            }
        }
        
        if(emailtemp != null && (tmpName == 'Auth_IBWS_Adding_a_Programme_English'  || 
                                 tmpName == 'Auth_IBWS_Adding_a_Programme_French'  || 
                                 tmpName =='Auth_IBWS_Adding_a_Programme_Spanish'))
        {
            if (headOfSchoolEmail != null ) {
                Messaging.SingleEmailMessage headOfSchoolEmailMessage = new Messaging.SingleEmailMessage();
                if (owea.size() > 0) {
                    headOfSchoolEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                }
                headOfSchoolEmailMessage.setHtmlBody(templateBody);
                headOfSchoolEmailMessage.setSubject(tmpSubject);
                headOfSchoolEmailMessage.setToAddresses(new List<String> { headOfSchoolEmail });
                headOfSchoolEmailMessage.setCcAddresses(new List<String>{ IBWSManagerEmail, programmeCoordinatorEmail }); // Add CC recipients
                headOfSchoolEmailMessage.setReplyTo(programme.Programme_Relationship_Manager_Email__c);
                //headOfSchoolEmailMessage.setSenderDisplayName(programme.Programme_Relationship_Manager_Name__c);
                headOfSchoolEmailMessage.setWhatId(programme.Id);   // Associate email with the IB Programme
                headOfSchoolEmailMessage.setSaveAsActivity(true);   // Log email in Activity History
                headOfSchoolEmailMessage.setUseSignature(false);//added on 12-06-2025
                headOfSchoolEmailMessage.setTargetObjectId(hosContactId);//added newly on 5-5-25
                emailsToSend.add(headOfSchoolEmailMessage);      
                // Generate PDF content
                //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --Started--
                Attachment attachment = new Attachment();
                if(programme.Language_of_Correspondence_Acct__c == 'English'){
                    attachment.Name = 'IBWS Welcome Letter – Adding a Programme.pdf'; // File name on Salesforce
                    attachment.Description = 'IBWS Welcome Letter';
                }
                if(programme.Language_of_Correspondence_Acct__c == 'French'){
                    attachment.Name = 'Lettre de Bienvenue pour les écoles du monde de l’IB – Ajouter un programme.pdf'; // File name on Salesforce
                    attachment.Description = 'Lettre de Bienvenue pour les écoles du monde de l’IB';
                }
                if(programme.Language_of_Correspondence_Acct__c == 'Spanish'){
                    attachment.Name = 'Carta de bienvenida – Programa Adicional (Colegios del Mundo del IB).pdf'; // File name on Salesforce
                    attachment.Description = 'Carta de bienvenida – Colegios del Mundo del IB';
                }
                attachment.Body = Blob.toPdf(templateBody); 
                attachment.ContentType = 'application/pdf';  
                attachment.ParentId = programme.Id;  
                attachmentsToInsert.add(attachment);
                //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --ENDS--
               
            }
        }
        
        return emailsToSend;
    }
    
    public static void sendEmail(List<Messaging.SingleEmailMessage> emailsToSend) {
        List<Messaging.SendEmailResult> sendResults =  Messaging.sendEmail(emailsToSend);
        for(Messaging.SendEmailResult result : sendResults) {
            if (result.isSuccess()) {
                //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --Starts--
                if(!attachmentsToInsert.isEmpty()){
                    System.debug('attachmentsToInsert is present===>' +attachmentsToInsert);
                    Database.insert(attachmentsToInsert,false);
                }
                //code writtened by Prerna on 29-024-2025 for ECM00739: Phase 2 --ENDS--
                System.debug('Email sent successfully: ' + result);
            } else {
                System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
            }
        }
    }
}