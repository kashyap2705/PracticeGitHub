//This batch apex is writtened by prerna on 07-03-2025 for ECM00739- PART-1 
global class IBProgrammeBatch implements Database.Batchable<SObject> {
    DateTime currentDate = System.now();
    DateTime yesterdayDate = currentDate.addDays(-1);
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([
            SELECT Id, Status__c, Authorized_Date__c, Account__c, Language_of_Correspondence_Acct__c,Name,Programme_Relationship_Manager_Name__c,Programme_Relationship_Manager_Email__c,RecordTypeId,RecordType.Name
            FROM IB_Programme__c
            WHERE Status__c = 'Authorized' AND Authorized_Date__c != NULL AND Processed_By_Batch__c != True
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<IB_Programme__c> scope) {
        if (scope != null && !scope.isEmpty()) {
            List<IB_Role__c> ibRolesList = new List<IB_Role__c>();
            Set<Id> accountIds = new Set<Id>();
            Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap = new Map<Id, Map<String, IB_Role__c>>();
            
            Map<Id, IB_Programme__c> authorizedProgrammes = new Map<Id, IB_Programme__c>();
            for (IB_Programme__c programme : scope) {
                DateTime authorizedDate = programme.Authorized_Date__c;
                DateTime currentDate = System.now();
                if (authorizedDate != null && currentDate > authorizedDate.addDays(5) && programme.Account__c != null) {
                    accountIds.add(programme.Account__c);
                    authorizedProgrammes.put(programme.Id, programme);
                }  
            }
            List<IB_Programme__c> programmesToUpdate =  new List<IB_Programme__c>();  
            //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --Started--
            List<Attachment> attachmentsToInsert = new List<Attachment>();
            //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --ENDS--
            if (!authorizedProgrammes.isEmpty()) {
                
                Set<String> allowedRoles = new Set<String>{'Head of School', 'Programme Coordinator'  };
                ibRolesList = [SELECT Id, IB_Contact__c, Email__c,IB_Contact__r.Email, IB_Contact__r.Name, IB_Programme_New__c, IB_Role_Name__c, Status__c 
                               FROM IB_Role__c 
                               WHERE IB_Programme_New__c IN :authorizedProgrammes.keySet() 
                               AND Status__c = 'Confirmed' 
                               AND IB_Role_Name__c IN :allowedRoles];
                
                for (IB_Role__c ibRole : ibRolesList) {
                    if (!ibProgrammeVsIBRoleMap.containsKey(ibRole.IB_Programme_New__c)) {
                        ibProgrammeVsIBRoleMap.put(ibRole.IB_Programme_New__c, new Map<String, IB_Role__c>());
                    }
                    ibProgrammeVsIBRoleMap.get(ibRole.IB_Programme_New__c).put(ibRole.IB_Role_Name__c, ibRole);
                }
                
                Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
                
                Set<Id> ownerIds = new Set<Id>();
                for (Account acc : accountMap.values()) {
                    ownerIds.add(acc.OwnerId);
                }
                //Link_to_book_online_meetings__c added by Prerna for ECM00739-Phase 2
                Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name, FirstName, Email, Department, Link_to_book_online_meetings__c FROM User WHERE Id IN :ownerIds AND Department = 'IBWS']);
                
                OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'myschool-noreply@ibo.org'];
                
                Set<String> templateDeveloperNames = new Set<String>{'Auth_IBWS_Handoff_Letter_English','Auth_IBWS_Handoff_Letter_French','Auth_IBWS_Handoff_Letter_Spanish'};
                Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
                for (EmailTemplate empTemp : [SELECT Id, Body, HtmlValue, DeveloperName, Subject
                                              FROM EmailTemplate 
                                              WHERE DeveloperName IN :templateDeveloperNames]) {
                                                  templateMap.put(empTemp.DeveloperName, empTemp);
                                              }
                
                List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
                    if (!userMap.isEmpty()) {
                
                    for (IB_Programme__c programme : authorizedProgrammes.values()) {
                        programme.Processed_By_Batch__c = True;
                        String tmpName = '';
                        String templateBody='';
                        String tmpSubject;
                        String recordTypeName = programme.RecordType.Name;
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
                        //IBWSManagerBookingLink added by Prerna for ECM00739-Phase 2
                        String headOfSchoolName,programmeCoordinatorName,headOfSchoolEmail,programmeCoordinatorEmail,hosOverallName,hosOverallEmail,IBWSManagerName,IBWSManagerFirstName,SchoolName,IBWSManagerEmail,IBWSManagerBookingLink, headOfSchoolOverallEmail,headOfSchoolOverallName,hosContactId;
                        if (ibProgrammeVsIBRoleMap!= null && ibProgrammeVsIBRoleMap.containsKey(programme.id)  ) {
                            Map<String, IB_Role__c> rolesMap = ibProgrammeVsIBRoleMap.get(programme.id);
                            
                            headOfSchoolName = (rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Name != null) ? rolesMap.get('Head of School').IB_Contact__r.Name : null;
                            programmeCoordinatorName = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Name != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Name : null;
                            headOfSchoolEmail = rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Email != null ? rolesMap.get('Head of School').IB_Contact__r.Email : null;
                            programmeCoordinatorEmail = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Email != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Email : null;
                            headOfSchoolOverallEmail = rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Email != null ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Email : null;
                            headOfSchoolOverallName = (rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Name != null) ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Name : null;
                            hosContactId = rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__c != null ? rolesMap.get('Head of School').IB_Contact__c : null;
                        }                        
                        if (programme.Account__c != null && accountMap.containsKey(programme.Account__c)) {
                            Account acc = accountMap.get(programme.Account__c);
                            if (acc.OwnerId != null && userMap.containsKey(acc.OwnerId)) {
                                User accountOwner = userMap.get(acc.OwnerId);
                                if (accountOwner != null && accountOwner.Name != null && accountOwner.Department =='IBWS') {
                                    IBWSManagerName = accountOwner.Name; // username of Account Owner
                                    IBWSManagerFirstName = accountOwner.FirstName;
                                    IBWSManagerEmail = accountOwner.Email;
                                    //IBWSManagerBookingLink added by Prerna for ECM00739-Phase 2
                                    if(accountOwner.Link_to_book_online_meetings__c != null){
                                        IBWSManagerBookingLink = accountOwner.Link_to_book_online_meetings__c;
                                    }
                                }
                            }
                        }
                        
                        if(emailtemp != null &&  emailtemp.HtmlValue != null) {
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
                                if (templateBody.contains('{IBWSManagerEmail}') && IBWSManagerEmail != null) {
                                    templateBody = templateBody.replace('{IBWSManagerEmail}', IBWSManagerEmail);
                                }
                                //below if block added by Prerna for ECM00739-Phase 2
                                if (templateBody.contains('{IBWSManagerBookingLink}') && IBWSManagerBookingLink != null) {
                                    templateBody = templateBody.replace('{IBWSManagerBookingLink}', IBWSManagerBookingLink);
                                }
                            }
                        }
                        
                        if(emailtemp != null){
                            if (headOfSchoolEmail != null && IBWSManagerEmail != null) {
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
                                headOfSchoolEmailMessage.setTargetObjectId(hosContactId);
                                headOfSchoolEmailMessage.setWhatId(programme.Id);   // Associate email with the IB Programme
                                headOfSchoolEmailMessage.setSaveAsActivity(true);   // Log email in Activity History
                              headOfSchoolEmailMessage.setUseSignature(false);//added on 12-06-2025
                                emailsToSend.add(headOfSchoolEmailMessage); 
                                
                                //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --Started--
                                // Generate PDF content
                                Attachment attachment = new Attachment();
                               if(programme.Language_of_Correspondence_Acct__c == 'English'){
                                    attachment.Name = 'IBWS Welcome Letter – First Programme.pdf';
                                    attachment.Description = 'IBWS Welcome Letter';
                                }
                                if(programme.Language_of_Correspondence_Acct__c == 'French'){
                                    attachment.Name = 'Lettre de Bienvenue pour les écoles du monde de l’IB – Premier programme.pdf';
                                    attachment.Description = 'Lettre de Bienvenue pour les écoles du monde de l’IB';
                                }
                                if(programme.Language_of_Correspondence_Acct__c == 'Spanish'){
                                    attachment.Name = 'Carta de bienvenida – Primer programa (Colegios del Mundo del IB).pdf';
                                    attachment.Description = 'Carta de bienvenida – Colegios del Mundo del IB';
                                }
                                attachment.Body = Blob.toPdf(templateBody); 
                                
                                attachment.ContentType = 'application/pdf';  
                                attachment.ParentId = programme.Id;  
                                attachmentsToInsert.add(attachment);
                                //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --ENDS--
                          
                            }
                        }
                        
                        programmesToUpdate.add(programme);
                    }
                }
                if (!emailsToSend.isEmpty() ) {
                    List<Messaging.SendEmailResult> sendResults =  Messaging.sendEmail(emailsToSend);
                    for(Messaging.SendEmailResult result : sendResults) {
                        if (result.isSuccess()) {
                            //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --Started--
                            if(!attachmentsToInsert.isEmpty()){
                              Database.insert(attachmentsToInsert,false);
                            }
                            //code writtened by Prerna on 29-04-2025 for ECM00739: Phase 2 --Started--
                            
                            System.debug('Email sent successfully: ' + result);
                        } else {
                            System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
                        }
                    }
                }
            }
            
            update programmesToUpdate;
        }}
    
    global void finish(Database.BatchableContext BC) {
        
    }
}