/**    
* <h1>EmailNotificationHandler</h1>    
* This class is responsible for sending emails to contacts on IB_Role__c object as part of trigger consolidation, for ECM00501.
* 
* @author  Prerna Sobti   
* @version 1.0   
* @since   05-06-2024*/

public class EmailNotificationHandler {
public static void sendEmail(List<IB_Role__c> roles) {
        List<Id> contactIds = new List<Id>();
        Map<Id, Id> roleToProgrammeMap = new Map<Id, Id>();
        for (IB_Role__c role : roles) {
            contactIds.add(role.IB_Contact__c);
            roleToProgrammeMap.put(role.Id, role.IB_Programme_New__c);
        }

        if (!contactIds.isEmpty()) {
            List<Contact> contacts = [SELECT Id, Email FROM Contact WHERE Id IN :contactIds];

            Map<Id, String> contactEmailMap = new Map<Id, String>();
            for (Contact contact : contacts) {
                if (contact.Email != null) {
                    contactEmailMap.put(contact.Id, contact.Email);
                }
            }
            Map<Id, IB_programme__c> programmeMap = new Map<Id, IB_programme__c>([SELECT Id, Name,Language_of_Correspondence_Acct__c, Programme_Relationship_Manager_Name__c, Programme_Relationship_Manager_Email__c FROM IB_programme__c WHERE Id IN :roleToProgrammeMap.values()]);
            Set<String> templateDeveloperNames = new Set<String> {
                'New_Notification_to_New_Head_of_School_and_Coordinators',
                'New_Notification_to_New_Head_of_School_and_Coordinators_French',
                'New_Notification_to_New_Head_of_School_and_Coordinators_Spanish'
            }; 
            Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
            if (!templateDeveloperNames.isEmpty()) {
                for (EmailTemplate empTemp : [
                    SELECT Id, Body, HtmlValue, DeveloperName 
                    FROM EmailTemplate 
                    WHERE DeveloperName IN :templateDeveloperNames]){
                        templateMap.put(empTemp.DeveloperName, empTemp);
                    }
            }
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'schooldelivery@ibo.org'];
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
            List<Task> tasksToCreate = new List<Task>();            
            for (IB_Role__c role : roles) {
                IB_programme__c programme = programmeMap.get(role.IB_Programme_New__c);
                String tmpName = '';
                String tmpSubject;
                  
                if (programme.Language_of_Correspondence_Acct__c == 'English') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators';
                    tmpSubject = 'IB Candidate Welcome pack for new coordinators and heads of school';
                }
                if (programme.Language_of_Correspondence_Acct__c == 'Spanish') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators_Spanish';
                    tmpSubject = 'Paquete de bienvenida para nuevo personal de coordinación y dirección de colegios solicitantes';
                }
                if (programme.Language_of_Correspondence_Acct__c == 'French') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators_French';
                    tmpSubject = 'Dossier de bienvenue pour les responsables de la coordination et la direction des nouveaux établissements candidats';
                }
                EmailTemplate emailtemp = templateMap.get(tmpName);
                System.debug('role.IB_Contact__r.Name====>'+role.IB_Contact__r.Name);
                String headOfSchoolName,programmeCoordinatorName,headOfSchoolEmail,programmeCoordinatorEmail,hosOverallName,hosOverallEmail;
                if(role.IB_Role_Name__c == 'Head of School'){
                    headOfSchoolName = role.Contact_name__c;
                    headOfSchoolEmail = role.Email__c;
                }
                if(role.IB_Role_Name__c == 'Programme Coordinator'){
                    programmeCoordinatorName = role.Contact_name__c;
                    programmeCoordinatorEmail = role.Email__c;
                }
                if(role.IB_Role_Name__c == 'Head of School (Overall)'){
                    hosOverallName = role.Contact_name__c;
                    hosOverallEmail = role.Email__c;
                }
                System.debug('headOfSchoolName===>'+headOfSchoolName);
                System.debug('headOfSchoolEmail===>'+headOfSchoolEmail);
                
                if(emailtemp != null){
                    if (headOfSchoolEmail != null) {
                        String headOfSchoolTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, headOfSchoolName, null, null, programme);
                        Messaging.SingleEmailMessage headOfSchoolEmailMessage = new Messaging.SingleEmailMessage();
                        if (owea.size() > 0) {
                            headOfSchoolEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        headOfSchoolEmailMessage.setHtmlBody(headOfSchoolTemplateBody);
                        headOfSchoolEmailMessage.setSubject(tmpSubject);
                        headOfSchoolEmailMessage.setToAddresses(new List<String> { headOfSchoolEmail });
                        emailsToSend.add(headOfSchoolEmailMessage);
                        
                        String sanitizedDescription = headOfSchoolTemplateBody.replaceAll('<[^>]*>', '')
                                                                      .replaceAll('&nbsp;', ' ')
                                                                      .trim();
                        Task headOfSchoolTask = new Task(
                            Subject = 'Email Sent: ' + tmpSubject,
                            Description = sanitizedDescription,
                            WhatId = programme.Id,
                            Status = 'Completed',
                            Priority = 'Normal',
                            ActivityDate = Date.today(),
                            Type = 'Email'
                        );
                        tasksToCreate.add(headOfSchoolTask);
                    }
                    if (programmeCoordinatorEmail != null) {
                        String programmeCoordinatorTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, null, programmeCoordinatorName, null, programme);
                        Messaging.SingleEmailMessage programmeCoordinatorEmailMessage = new Messaging.SingleEmailMessage();
                        if (owea.size() > 0) {
                            programmeCoordinatorEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        programmeCoordinatorEmailMessage.setHtmlBody(programmeCoordinatorTemplateBody);
                        programmeCoordinatorEmailMessage.setSubject(tmpSubject);
                        programmeCoordinatorEmailMessage.setToAddresses(new List<String> { programmeCoordinatorEmail });
                        emailsToSend.add(programmeCoordinatorEmailMessage);
                        String sanitizedDescription = programmeCoordinatorTemplateBody.replaceAll('<[^>]*>', '')
                                                                      .replaceAll('&nbsp;', ' ')
                                                                      .trim();
                        Task programmeCoordinatorTask = new Task(
                            Subject = 'Email Sent: ' + tmpSubject,
                            Description = sanitizedDescription,
                            WhatId = programme.Id,
                            Status = 'Completed',
                            Priority = 'Normal',
                            ActivityDate = Date.today(),
                            Type = 'Email'
                        );
                        tasksToCreate.add(programmeCoordinatorTask);
                    }
                    if (hosOverallEmail != null) {
                        String hosOverallTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, null, null, hosOverallName, programme);
                        Messaging.SingleEmailMessage hosOverallEmailMessage = new Messaging.SingleEmailMessage();
                        if (owea.size() > 0) {
                            hosOverallEmailMessage.setOrgWideEmailAddressId(owea[0].Id);
                        }
                        hosOverallEmailMessage.setHtmlBody(hosOverallTemplateBody);
                        hosOverallEmailMessage.setSubject(tmpSubject);
                        hosOverallEmailMessage.setToAddresses(new List<String> { hosOverallEmail });
                        emailsToSend.add(hosOverallEmailMessage);
                        String sanitizedDescription = hosOverallTemplateBody.replaceAll('<[^>]*>', '')
                                                                      .replaceAll('&nbsp;', ' ')
                                                                      .trim();
                        Task hosOverallTask = new Task(
                            Subject = 'Email Sent: ' + tmpSubject,
                            Description = sanitizedDescription,
                            WhatId = programme.Id,
                            Status = 'Completed',
                            Priority = 'Normal',
                            ActivityDate = Date.today(),
                            Type = 'Email'
                        );
                        tasksToCreate.add(hosOverallTask);
                    }
                }
            }
            System.debug('size===>'+emailsToSend.size());
            if (!emailsToSend.isEmpty()) {
                Messaging.sendEmail(emailsToSend);
                insert tasksToCreate;
            }
        } else {
            System.debug('No contacts found to send emails to.');
        }
    }
    public static String customizeTemplateBody(String templateBody, String headOfSchoolName, String programmeCoordinatorName, String hosOverallName, IB_programme__c newVal) 
    {
        if (templateBody != null) {
            if (headOfSchoolName != null) {
                System.debug('Head is present==>');
                templateBody = templateBody.replace('{Programme_Coordinator_Name} and {Head_of_School_Name} and {Hos_Overall_Name}', headOfSchoolName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} y Sr/a. {Head_of_School_Name} y Sr/a. {Hos_Overall_Name}', headOfSchoolName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} et {Head_of_School_Name} et {Hos_Overall_Name}', headOfSchoolName);
            }
            if (programmeCoordinatorName != null) {
                templateBody = templateBody.replace('{Programme_Coordinator_Name} and {Head_of_School_Name} and {Hos_Overall_Name}', programmeCoordinatorName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} y Sr/a. {Head_of_School_Name} y Sr/a. {Hos_Overall_Name}', programmeCoordinatorName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} et {Head_of_School_Name} et {Hos_Overall_Name}', programmeCoordinatorName);
            }
            if (hosOverallName != null) {
                templateBody = templateBody.replace('{Programme_Coordinator_Name} and {Head_of_School_Name} and {Hos_Overall_Name}', hosOverallName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} y Sr/a. {Head_of_School_Name} y Sr/a. {Hos_Overall_Name}', hosOverallName);
                templateBody = templateBody.replace('{Programme_Coordinator_Name} et {Head_of_School_Name} et {Hos_Overall_Name}', hosOverallName);
            }
            if (templateBody.contains('{IB_Programme_Name}') && newVal.Name != null) {
                templateBody = templateBody.replace('{IB_Programme_Name}', newVal.Name);
            }
            if (templateBody.contains('{PrmName}') && newVal.Programme_Relationship_Manager_Name__c != null) {
                templateBody = templateBody.replace('{PrmName}', newVal.Programme_Relationship_Manager_Name__c);
            }
            if (templateBody.contains('{PrmEmail}') && newVal.Programme_Relationship_Manager_Email__c != null) {
                templateBody = templateBody.replace('{PrmEmail}', newVal.Programme_Relationship_Manager_Email__c);
            }
            templateBody = templateBody.replace(']]>', '');
        }
        return templateBody;
    }
}