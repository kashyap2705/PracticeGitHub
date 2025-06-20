public with sharing class IB_ProgrammeAfterUpdateTriggerHandler extends TriggerHandlerBase {
    private static Boolean isSendEmailCalled = false;
    private static Boolean isSendEmailCalledForAddingProgramme = false;//Added by Shahrukh for ECM00739 Part-2
    public static List<IB_Application_Attachment__c> WelcomeLetterList;//INC0209938 Ben mcgarvey, had to make some static variable to reduce soql queries
    public static IB_Role_Repository__c[] schoolRoles;
    
    public override void mainEntry(TriggerParameters tp){
        if(test.isRunningTest())
        {
            TriggerContextUtility.firstRun = true;
        }
        
        //if(TriggerContextUtility.isFirstRun()){
        //TriggerContextUtility.setFirstRunFalse();
        process((Map<Id,IB_Programme__c>)tp.oldMap, (Map<Id,IB_Programme__c>)tp.newMap ,(list<IB_Programme__c>)tp.newList
                ,(list<IB_Programme__c>)tp.oldList);
        //}
    }
    
    private static void process (Map<Id,IB_Programme__c> oldProgramme, Map<Id,IB_Programme__c> newProgramme, 
                                 list<IB_Programme__c> newlist , list<IB_Programme__c> oldlist) {
                                     //below if condition added by prerna to stop executing the trigger logic from IBProgrammeBatch batch apex
                                     //whenever an update is happening from batch on 07-03-2025 for ECM00739- PART-1
                                     if (!System.isBatch()) {
                                         //Added by Shahrukh for ECM00739 Part-2 --START--
                                         if (!isSendEmailCalledForAddingProgramme) {
                                             isSendEmailCalledForAddingProgramme = true;
                                             sendEmailUponSecondProgramAuthorization(newlist,oldProgramme);
                                         } 
                                         //Added by Shahrukh for ECM00739 Part-2 --END--
                                         createApplicationForAuthorization(oldProgramme,newProgramme);
                                         createAuthorizationFeedback(oldProgramme,newProgramme);
                                         createCourseOutlineForAuthorization(oldProgramme,newProgramme);
                                         createVerificationVisitFeedback(oldProgramme,newProgramme);
                                         createMtbaAction(oldProgramme,newProgramme);
                                         IB_programmetriggerlogic1(oldProgramme ,newlist); 
                                         IB_programtriggerlogic3(newlist,oldProgramme);
                                         OnTermWith_UpdateRolesEndDate(oldProgramme ,newlist); 
                                         // AutomaticRoleWithdrawl(newlist , oldProgramme );
                                         IB_programWithIB_Event_legal(oldlist,newlist) ;
                                         //Code added by Prerna on 28-05-2024 for ECM00501 --STARTS--
                                         if (!isSendEmailCalled) {
                                             isSendEmailCalled = true;
                                             sendEmailBasedOnProgrammeStatus(oldProgramme, newProgramme);
                                             System.debug('Inside the process');
                                         } else {
                                             System.debug('sendEmailBasedOnProgrammeStatus already called');
                                         }
                                         //Code added by Prerna on 28-05-2024 for ECM00501 --ENDS--
                                     }
                                 }
    
    //below method writtened by Prerna on 28-05-2024  for ECM00501
    public static void sendEmailBasedOnProgrammeStatus(Map<Id,IB_programme__c> oldMap,Map<Id,IB_programme__c> newMap){
        List<Id> filteredProgrammes = new List<Id> ();
        System.debug('Inside the method==>');
        for (String idValue : newMap.keySet()) {
            final IB_programme__c oldVal = oldMap.get(idValue);
            final IB_programme__c newVal = newMap.get(idValue);
            System.debug('OLD===>'+oldVal.Status__c);
            System.debug('NEW===>'+newVal.Status__c);
            if(oldVal.Status__c != newVal.Status__c && newVal.Status__c == 'Candidate' && !oldVal.Status__c.equals(newVal.Status__c))
            {
                System.debug('True====>');
                filteredProgrammes.add(idValue);
                System.debug('filteredProgrammes==>'+filteredProgrammes);
            }
        }
        if(filteredProgrammes != null && filteredProgrammes.size()>0){
            System.debug('filteredProgrammes inside if===>'+filteredProgrammes);
            String oldMapJson = JSON.serialize(oldMap);
            String newMapJson = JSON.serialize(newMap);
            processProgrammesAsync(filteredProgrammes, oldMapJson, newMapJson);
        }
    }
    //below method writtened by Prerna on 28-05-2024  for ECM00501
    @future
    public static void processProgrammesAsync(List<Id> filteredProgrammes, String oldMapJson, String newMapJson) {
        // Deserialize old and new maps
        Map<Id, IB_programme__c> oldMap = (Map<Id, IB_programme__c>) JSON.deserialize(oldMapJson, Map<Id, IB_programme__c>.class);
        Map<Id, IB_programme__c> newMap = (Map<Id, IB_programme__c>) JSON.deserialize(newMapJson, Map<Id, IB_programme__c>.class);
        
        if(filteredProgrammes != null){
            List<IB_Role__c> ibRolesList = new List<IB_Role__c>();
            Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap = new Map<Id, Map<String, IB_Role__c>>();
            System.debug('filteredProgrammes===****>'+filteredProgrammes);
            if (!filteredProgrammes.isEmpty()) {
                ibRolesList = [SELECT id, IB_Contact__c,IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,IB_Role_Name__c,Status__c 
                               FROM IB_Role__c 
                               WHERE IB_Programme_New__c IN :filteredProgrammes 
                               AND Status__c = 'Confirmed' 
                               AND (IB_Role_Name__c = 'Head of School' Or IB_Role_Name__c = 'Programme Coordinator' Or IB_Role_Name__c = 'Head of School (Overall)')];
            }
            System.debug('ibRolesList===****>'+ibRolesList);
            if(!ibRolesList.isEmpty()){
                for(IB_Role__c ibRole : ibRolesList){
                    if(!ibProgrammeVsIBRoleMap.containsKey(ibRole.IB_Programme_New__c)){
                        ibProgrammeVsIBRoleMap.put(ibRole.IB_Programme_New__c,new Map<String, IB_Role__c>());
                    }
                    ibProgrammeVsIBRoleMap.get(ibRole.IB_Programme_New__c).put(ibRole.IB_Role_Name__c,ibRole);
                }
            }
            System.debug('ibProgrammeVsIBRoleMap======>'+ibProgrammeVsIBRoleMap);
            Set<String> templateDeveloperNames =new Set<String> { 
                'New_Notification_to_New_Head_of_School_and_Coordinators',
                'New_Notification_to_New_Head_of_School_and_Coordinators_French',
                'New_Notification_to_New_Head_of_School_and_Coordinators_Spanish'
                    };
            Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
            List<EmailTemplate> emailTemplatesList = new List<EmailTemplate>();
            if (!templateDeveloperNames.isEmpty()) {
                emailTemplatesList = [SELECT Id, Body, HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName IN :templateDeveloperNames];
            }
            System.debug('emailTemplatesList======>'+emailTemplatesList);
            for(EmailTemplate empTemp : emailTemplatesList){
                templateMap.put(empTemp.DeveloperName,empTemp);
            }
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'schooldelivery@ibo.org'];
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
            List<Task> tasksToCreate = new List<Task>(); 
            System.debug('filteredProgrammes======>'+filteredProgrammes);
            for (String programmeId : filteredProgrammes)
            {
                final IB_programme__c oldVal = oldMap.get(programmeId);
                final IB_programme__c newVal = newMap.get(programmeId);
                String tmpName = '';
                String tmpSubject;
                if (newVal.Language_of_Correspondence_Acct__c == 'English') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators';
                    tmpSubject = 'IB Candidate Welcome pack for new coordinators and heads of school';
                }
                if (newVal.Language_of_Correspondence_Acct__c == 'Spanish') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators_Spanish';
                    tmpSubject = 'Paquete de bienvenida para nuevo personal de coordinación y dirección de colegios solicitantes';
                }
                if (newVal.Language_of_Correspondence_Acct__c == 'French') {
                    tmpName = 'New_Notification_to_New_Head_of_School_and_Coordinators_French';
                    tmpSubject = 'Dossier de bienvenue pour les responsables de la coordination et la direction des nouveaux établissements candidats';
                }
                EmailTemplate emailtemp = templateMap.get(tmpName);
                String headOfSchoolName,programmeCoordinatorName,headOfSchoolEmail,programmeCoordinatorEmail,hosOverallName,hosOverallEmail;
                if (ibProgrammeVsIBRoleMap.containsKey(programmeId)) {
                    Map<String, IB_Role__c> rolesMap = ibProgrammeVsIBRoleMap.get(programmeId);
                    headOfSchoolName = (rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Name != null) ? rolesMap.get('Head of School').IB_Contact__r.Name : null;
                    programmeCoordinatorName = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Name != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Name : null;
                    headOfSchoolEmail = rolesMap.containsKey('Head of School') && rolesMap.get('Head of School').IB_Contact__r.Email != null ? rolesMap.get('Head of School').IB_Contact__r.Email : null;
                    programmeCoordinatorEmail = rolesMap.containsKey('Programme Coordinator') && rolesMap.get('Programme Coordinator').IB_Contact__r.Email != null ? rolesMap.get('Programme Coordinator').IB_Contact__r.Email : null;
                    hosOverallName = rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Name != null ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Name : null;
                    hosOverallEmail = rolesMap.containsKey('Head of School (Overall)') && rolesMap.get('Head of School (Overall)').IB_Contact__r.Email != null ? rolesMap.get('Head of School (Overall)').IB_Contact__r.Email : null;
                    
                }
                System.debug('emailtemp====>'+emailtemp);
                System.debug('headOfSchoolEmail====>'+headOfSchoolEmail);
                if(emailtemp != null){
                    if (headOfSchoolEmail != null) {
                        String headOfSchoolTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, headOfSchoolName, null, null, newVal);
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
                            WhatId = programmeId,
                            Status = 'Completed',
                            Priority = 'Normal',
                            ActivityDate = Date.today(),
                            Type = 'Email'
                        );
                        tasksToCreate.add(headOfSchoolTask);
                    }
                    if (programmeCoordinatorEmail != null) {
                        String programmeCoordinatorTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, null, programmeCoordinatorName, null, newVal);
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
                            WhatId = programmeId,
                            Status = 'Completed',
                            Priority = 'Normal',
                            ActivityDate = Date.today(),
                            Type = 'Email'
                        );
                        tasksToCreate.add(programmeCoordinatorTask);
                    }
                    if (hosOverallEmail != null) {
                        String hosOverallTemplateBody = customizeTemplateBody(emailtemp.HtmlValue, null, null, hosOverallName, newVal);
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
                            WhatId = programmeId,
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
                List<Messaging.SendEmailResult> sendResults =  Messaging.sendEmail(emailsToSend);
                for(Messaging.SendEmailResult result : sendResults) {
                if (result.isSuccess()) {
                    System.debug('Email sent successfully: ' + result);
                } else {
                    System.debug('Failed to send email: ' + result.getErrors()[0].getMessage());
                }
            }

                insert tasksToCreate; 
            }
            
        }
    }
    private static String customizeTemplateBody(String templateBody, String headOfSchoolName, String programmeCoordinatorName, String hosOverallName, IB_programme__c newVal) 
    {
        if (templateBody != null) {
            if (headOfSchoolName != null) {
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
    //Code added by Prerna on 28-05-2024 --ENDS--
    @Testvisible private static IB_Application__c removeFields(IB_Application__c app){
        
        // Form Validation Fields
        app.AFC_Profile_Review_Status__c = null;
        app.AFC_School_Description_Status__c = null;
        app.AFC_Programme_Information_Status__c = null;
        app.AFC_Subject_Proposal_Status__c = null;
        app.AFC_Philosophy_Status__c = null;
        app.AFC_Leadership_Structure_Status__c = null;
        app.AFC_Resources_Support_Status__c = null;
        app.AFC_Collaborative_Planning_Status__c = null;
        app.AFC_Written_Curriculum_Status__c = null;
        app.AFC_Teaching_Learning_Status__c = null;
        app.AFC_Assessment_Status__c = null;
        app.AFC_Implementation_Budget_Status__c = null;
        app.AFC_Documents_Status__c = null;
        app.AFC_Agreement_Status__c = null;
        
        // Agreement Fields
        app.SP_School_Superintendent__c = null;
        app.SP_SS_Signature__c = false;
        app.SP_School_Superintendent_Sign_Date__c = null;
        app.SP_Executive_Head__c = null;
        app.SP_EH_Signature__c = false;
        app.SP_Executive_Head_Sign_Date__c = null;
        app.SP_Governing_Body__c = null;
        app.SP_Governing_Body_Sign_Date__c = null;
        
        // Other Fields
        app.A3_4_1_Governing_Actions__c = null;
        app.A3_4_2_Governing_Outcomes__c = null;
        app.A3_4_3_Local_Actions__c = null;
        app.A3_4_4_Local_Outcomes__c = null;
        app.A3_4_7_Parents_Actions__c = null;
        app.A3_4_8_Parents_Outcomes__c = null;
        app.A3_4_9_Pedagogical_Actions__c = null;
        app.A3_4_10_Pedagogical_Outcomes__c = null;
        app.A3_4_11_Teacher_Actions__c = null;
        app.A3_4_12_Teacher_Outcomes__c = null;
        app.A3_4_5_Other_Actions__c = null;
        app.A3_4_6_Other_Outcomes__c = null;
        return app;
        
    }
    
    @Testvisible private static void createAuthorizationFeedback(Map<Id,IB_Programme__c> oldMap, Map<Id,IB_Programme__c> newMap) {
        System.debug('Test '+oldMap.size());
        List<IB_Programme__c> pList = new List<IB_Programme__c>();
        string LanguageOfCorrespondence;
        Set<Id> pIdSet = new Set<Id>();
        //This part is updated by Developer Abd-Ur-Rehman-Plumlogix on 12-10-2019,AFA Reader Feedback Report Fix
        //Begin
        for(IB_Programme__c p : newMap.values())
        {
            IB_programme__c old_programme = oldMap.get(p.id);
            if(old_programme.Sub_Stage__c != 'Allocate reader (App for Auth)' && p.Sub_Stage__c=='Allocate reader (App for Auth)')
            { 
                pIdSet.add(p.Id);
                //Getting programme LanguageOfCorrespondence
                LanguageOfCorrespondence = p.Language_of_Correspondence_Acct__c;
                System.debug('Test 1 '+p.Language_of_Correspondence_Acct__c);
            }
        }
        System.debug('Test '+pIdSet.size());
        if(!pIdSet.isEmpty())
        {
            Map<Id,Auth_Feedback__c> authMap = new Map<Id,Auth_Feedback__c>();            
            
            Set<Id> appIdSet = new Set<Id>();
            for(IB_Application__c app : [SELECT Id,Application_Lookup_to_Programme__c,Application_Lookup_to_Programme__r.Account__c FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Authorization' AND Application_Lookup_to_Programme__c IN :pIdSet])
            {
                appIdSet.add(app.Id);
                authMap.put(app.Id,new Auth_Feedback__c(Name='Application Feedback',IB_Application__c=app.Id,IB_Programme__c=app.Application_Lookup_to_Programme__c,Account__c=app.Application_Lookup_to_Programme__r.Account__c));                
            }
            
            //check for duplicates before creating
            for(Auth_Feedback__c af : [SELECT Id,IB_Application__c FROM Auth_Feedback__c WHERE IB_Application__c IN :appIdSet])
            {
                if(authMap.containsKey(af.IB_Application__c))
                    authMap.remove(af.IB_Application__c);
            }
            if(!authMap.isEmpty())
            {
                insert authMap.values();
                
                List<Auth_Feedback_Section_A__c> aList = new List<Auth_Feedback_Section_A__c>();
                List<Auth_Feedback_Section_B__c> bList = new List<Auth_Feedback_Section_B__c>();
                List<Auth_Feedback_Section_C__c> cList = new List<Auth_Feedback_Section_C__c>();
                for(Auth_Feedback__c af : authMap.values())
                {
                    aList.add(new Auth_Feedback_Section_A__c(Name='TestA',Authorization_Feedback__c=af.Id));
                    bList.add(new Auth_Feedback_Section_B__c(Name='TestB',Authorization_Feedback__c=af.Id));
                    cList.add(new Auth_Feedback_Section_C__c(Name='TestC',Authorization_Feedback__c=af.Id));
                }
                /*insert aList;
insert bList;
insert cList;*/
                //Conga A Part
                if(!aList.isEmpty())
                {
                    insert aList;
                    if(LanguageOfCorrespondence == 'English'){
                        List<IB_Authorization_Feedback_Conga_A__c> aCongaList = new List<IB_Authorization_Feedback_Conga_A__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_A__c sectionA : aList)
                            {
                                System.debug('Creating Conga section A');
                                aCongaList.add(new IB_Authorization_Feedback_Conga_A__c(IB_Authorization_Feedback__c =af.Id,Section_A__c =sectionA.Id));
                            }                        
                        }
                        
                        insert aCongaList;
                    }
                    //French condition
                    if(LanguageOfCorrespondence == 'French')
                    {
                        List<IB_Authorization_Feedback_Conga_A_FR__c> aCongaList_FR = new List<IB_Authorization_Feedback_Conga_A_FR__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_A__c sectionA : aList)
                            {
                                System.debug('Creating Conga section A');
                                aCongaList_FR.add(new IB_Authorization_Feedback_Conga_A_FR__c(IB_Authorization_Feedback__c =af.Id,Section_A_FR__c = sectionA.Id));
                            }                        
                        }
                        
                        insert aCongaList_FR;
                    }
                    
                    //Spanish condition
                    if(LanguageOfCorrespondence == 'Spanish')
                    {
                        List<IB_Authorization_Feedback_Conga_A_SP__c> aCongaList_SP = new List<IB_Authorization_Feedback_Conga_A_SP__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_A__c sectionA : aList)
                            {
                                System.debug('Creating Conga section A');
                                aCongaList_SP.add(new IB_Authorization_Feedback_Conga_A_SP__c(IB_Authorization_Feedback__c =af.Id,Section_A_SP__c =sectionA.Id));
                            }                        
                        }
                        
                        insert aCongaList_SP;
                    }
                }
                //Conga B Part
                if(!bList.isEmpty())
                {
                    insert bList;
                    if(LanguageOfCorrespondence == 'English'){
                        List<IB_Authorization_Feedback_Conga_B__c> bCongaList = new List<IB_Authorization_Feedback_Conga_B__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_B__c sectionB : bList)
                            {
                                System.debug('Creating Conga section B');
                                bCongaList.add(new IB_Authorization_Feedback_Conga_B__c(IB_Authorization_Feedback__c =af.Id,Section_B__c =sectionB.Id));
                            }                        
                        }
                        
                        insert bCongaList;
                    }
                    //French
                    if(LanguageOfCorrespondence == 'French')
                    {
                        List<IB_Authorization_Feedback_Conga_B_FR__c> bCongaList_FR = new List<IB_Authorization_Feedback_Conga_B_FR__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_B__c sectionB : bList)
                            {
                                System.debug('Creating Conga section B');
                                bCongaList_FR.add(new IB_Authorization_Feedback_Conga_B_FR__c(IB_Authorization_Feedback__c =af.Id,Section_B_FR__c =sectionB.Id));
                            }                        
                        }
                        
                        insert bCongaList_FR;
                    }
                    //Spanish 
                    if(LanguageOfCorrespondence == 'Spanish')
                    {
                        List<IB_Authorization_Feedback_Conga_B_SP__c> bCongaList_SP = new List<IB_Authorization_Feedback_Conga_B_SP__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_B__c sectionB : bList)
                            {
                                System.debug('Creating Conga section B');
                                bCongaList_SP.add(new IB_Authorization_Feedback_Conga_B_SP__c(IB_Authorization_Feedback_SP__c =af.Id,Section_B_SP__c =sectionB.Id));
                            }                        
                        }
                        insert bCongaList_SP;
                    }
                }
                //Conga C Part
                if(!cList.isEmpty())
                {
                    insert cList;
                    if(LanguageOfCorrespondence == 'English')
                    {
                        List<IB_Authorization_Feedback_Conga_C__c> cCongaList = new List<IB_Authorization_Feedback_Conga_C__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_C__c sectionC : cList)
                            {
                                System.debug('Creating Conga section C');
                                cCongaList.add(new IB_Authorization_Feedback_Conga_C__c(IB_Authorization_Feedback__c =af.Id,Section_C__c =sectionC.Id));
                            }                        
                        }
                        
                        insert cCongaList;
                    }
                    //French
                    if(LanguageOfCorrespondence == 'French')
                    {
                        List<IB_Authorization_Feedback_Conga_C_FR__c> cCongaList_FR = new List<IB_Authorization_Feedback_Conga_C_FR__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_C__c sectionC : cList)
                            {
                                System.debug('Creating Conga section C');
                                cCongaList_FR.add(new IB_Authorization_Feedback_Conga_C_FR__c(IB_Authorization_Feedback__c =af.Id,Section_C_FR__c =sectionC.Id));
                            }                        
                        }
                        
                        insert cCongaList_FR;
                        
                    }
                    
                    //Spanish
                    if(LanguageOfCorrespondence == 'Spanish')
                    {
                        List<IB_Authorization_Feedback_Conga_C_SP__c> cCongaList_SP = new List<IB_Authorization_Feedback_Conga_C_SP__c>();
                        
                        for(Auth_Feedback__c af : authMap.values())
                        {
                            for(Auth_Feedback_Section_C__c sectionC : cList)
                            {
                                System.debug('Creating Conga section C');
                                cCongaList_SP.add(new IB_Authorization_Feedback_Conga_C_SP__c(IB_Authorization_Feedback__c =af.Id,Section_C_SP__c =sectionC.Id));
                            }                        
                        }
                        
                        insert cCongaList_SP;
                    }
                }
                
                
            }            
        }
    }
    
    @Testvisible private static Id getOwnerId(IB_Application__c afc) {
        AFA_Settings__c AfaSettings = AFA_Settings__c.getInstance('AdminId');        
        Id OwnerId;
        if(afc == null)
            OwnerId = Id.valueOf(AfaSettings.AFA_Owner_Id__c);
        else{
            if(afc.Owner.isActive == true)
                OwnerId = afc.OwnerId;
            else
                OwnerId = Id.valueOf(AfaSettings.AFA_Owner_Id__c);
        }
        return OwnerId;
    }
    
    private static void createCourseOutlineForAuthorization(Map<Id,IB_Programme__c> oldMap, Map<Id,IB_Programme__c> newMap) {
        
        List<IB_Programme__c> programmes = new List<IB_Programme__c>();
        
        RecordType dpRecordType = RecordTypeService.getRecordTypeByTypeAndName('IB_Programme__c', 'Diploma_Programme');
        RecordType cpRecordType = RecordTypeService.getRecordTypeByTypeAndName('IB_Programme__c', 'IBCC');
        
        Set<Id> progIdSet = new Set<Id>();
        
        for (IB_Programme__c prog : newMap.values()) {
            if ((prog.RecordTypeId == dpRecordType.Id || prog.RecordTypeId == cpRecordType.Id) && (prog.Sub_Stage__c == 'Receive Application for Authorization' && oldMap.get(prog.Id).Sub_Stage__c == 'Plan Authorization')) {
                programmes.add(prog);
                progIdSet.add(prog.Id);
            }
        }   
        
        System.debug('Updating Programme'+progIdSet);
        
        if(progIdSet.size() > 0)
            CourseOutlineReadingService.createCourseOutlineReadings(progIdSet);
        
    }
    
    @Testvisible private static void createApplicationForAuthorization(Map<Id,IB_Programme__c> oldMap, Map<Id,IB_Programme__c> newMap) {
        
        List<IB_Programme__c> programmes = new List<IB_Programme__c>();
        List<IB_Application__c> applications = new List<IB_Application__c>();
        
        for (IB_Programme__c prog : newMap.values()) {
            if (prog.StageName__c == 'Request for Authorization' && oldMap.get(prog.Id).StageName__c == 'Consultation process') {
                programmes.add(prog);
                /*for (IB_Programme__c old : oldProgrammes) {
if (old.Id == prog.Id && old.StageName__c == 'Consultation process') {
programmes.add(prog);
}
}*/
            }
        }
        
        if (!programmes.isEmpty()) {
            
            RecordType afcRecordType = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Candidacy');
            RecordType afaRecordType = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Authorization');
            
            for (IB_Programme__c programme : programmes) {
                
                ApplicationService.isApplicationsCached = false;
                ApplicationService.setProgrammeId(programme.Id);
                List<IB_Application__c> apps = ApplicationService.getAllFieldsApplications();
                
                IB_Application__c afc = null;
                IB_Application__c afa = null;
                
                for (IB_Application__c app : apps) {
                    if (app.RecordTypeId == afcRecordType.Id) {
                        afc = app;
                    }
                    if (app.RecordTypeId == afaRecordType.Id) {
                        afa = app;
                    }
                }
                
                if (afc != null && afa == null) {
                    afa = afc.clone(false, true, false, false);
                    afa = removeFields(afa);
                    afa.Status__c = 'Draft';
                    afa.Name = String.valueOf(afa.Name).replace('Candidacy', 'Authorization'); 
                    afa.AFA_Available_to_School__c = true;
                    afa.RecordTypeId = afaRecordType.Id;
                    afa.ClonedFromAFC__c = afc.Id;
                    afa.OwnerId = getOwnerId(afc); //marty added
                    applications.add(afa);
                }
                
            }
            
            
            
        }
        
        if (!applications.isEmpty()) {
            insert applications;
            Set<Id> apps = new Set<Id>();
            for(IB_Application__c a:applications){
                apps.add(a.Id);
            }
            PimsApplicationCloneChildren.execute(apps);
            
        }        
        
    }
    
    private static void createVerificationVisitFeedback(Map<Id, IB_Programme__c> oldMap, Map<Id, IB_Programme__c> newMap) {
        
        List<IB_Programme__c> progList = new List<IB_Programme__c>();
        Set<Id> progIdSet = new Set<Id>();
        
        for (IB_Programme__c prog : newMap.values()) {
            if (prog.StageName__c == 'Verification visit' && prog.Sub_Stage__c == 'Allocate visit team')
                progIdSet.add(prog.Id);
        }
        
        if (!progIdSet.isEmpty()) {
            
            Map<Id, IB_Verification_Visit_Feedback__c> vvMap = new Map<Id, IB_Verification_Visit_Feedback__c>();            
            
            Set<Id> appIdSet = new Set<Id>();
            for (IB_Application__c app : [SELECT Id, Application_Lookup_to_Programme__c, Application_Lookup_to_Programme__r.Account__c FROM IB_Application__c WHERE RecordType.DeveloperName = 'Application_for_Authorization' AND Application_Lookup_to_Programme__c IN :progIdSet]) {
                appIdSet.add(app.Id);
                vvMap.put(app.Id, new IB_Verification_Visit_Feedback__c(Name = 'Verification Visit Feedback', IB_Application__c = app.Id, IB_Programme__c = app.Application_Lookup_to_Programme__c, Account__c = app.Application_Lookup_to_Programme__r.Account__c));                
            }
            
            //check for duplicates before creating
            for (IB_Verification_Visit_Feedback__c vvf : [SELECT Id, IB_Application__c FROM IB_Verification_Visit_Feedback__c WHERE IB_Application__c IN :appIdSet]) {
                if (vvMap.containsKey(vvf.IB_Application__c))
                    vvMap.remove(vvf.IB_Application__c);
            }
            
            if (!vvMap.isEmpty()) {
                
                insert vvMap.values();
                
                List<IB_Verification_Visit_Feedback_A__c> vva = new List<IB_Verification_Visit_Feedback_A__c>();
                List<IB_Verification_Visit_Feedback_B1__c> vvb1 = new List<IB_Verification_Visit_Feedback_B1__c>();
                List<IB_Verification_Visit_Feedback_B2__c> vvb2 = new List<IB_Verification_Visit_Feedback_B2__c>();
                List<IB_Verification_Visit_Feedback_C1__c> vvc1 = new List<IB_Verification_Visit_Feedback_C1__c>();
                List<IB_Verification_Visit_Feedback_C2__c> vvc2 = new List<IB_Verification_Visit_Feedback_C2__c>();
                List<IB_Verification_Visit_Feedback_C3__c> vvc3 = new List<IB_Verification_Visit_Feedback_C3__c>();
                List<IB_Verification_Visit_Feedback_C4__c> vvc4 = new List<IB_Verification_Visit_Feedback_C4__c>();
                
                for (IB_Verification_Visit_Feedback__c vvf : vvMap.values()) {
                    vva.add(new IB_Verification_Visit_Feedback_A__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvb1.add(new IB_Verification_Visit_Feedback_B1__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvb2.add(new IB_Verification_Visit_Feedback_B2__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvc1.add(new IB_Verification_Visit_Feedback_C1__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvc2.add(new IB_Verification_Visit_Feedback_C2__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvc3.add(new IB_Verification_Visit_Feedback_C3__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                    vvc4.add(new IB_Verification_Visit_Feedback_C4__c(IB_Verification_Visit_Feedback__c = vvf.Id));
                }
                List<sObject> objects = new List<sObject>();
                objects.addAll((List<sObject>)(vva));
                objects.addAll((List<sObject>)(vvb1));
                objects.addAll((List<sObject>)(vvb2));
                objects.addAll((List<sObject>)(vvc1));
                objects.addAll((List<sObject>)(vvc2));
                objects.addAll((List<sObject>)(vvc3));
                objects.addAll((List<sObject>)(vvc4));
                insert objects;
                //insert vva;
                //insert vvb1;
                //insert vvb2;
                //insert vvc1;
                //insert vvc2;
                //insert vvc3;
                //insert vvc4;
                
            }
            
        }
        
    }
    @Testvisible private static void createMtbaAction(Map<Id, IB_Programme__c> oldMap, Map<Id, IB_Programme__c> newMap) {
        String EnglishDesc = 'Statement of acceptance read and signed by the head of school, the superintendent of school (if applicable/necessary) and an authorized representative of the governing body/controlling entity (if applicable/necessary), scanned, and returned to the IB via your My School Action Plan.';
        String SpanishDesc = 'El director del colegio, el superintendente (si corresponde o se requiere) y un representante autorizado del órgano de gobierno o entidad controladora (si corresponde o se requiere) deben leer y firmar la declaración de aceptación, que deberá escanearse y enviarse al IB a través del plan de acción en Mi colegio.';
        String FrenchDesc  = 'Le chef d’établissement, l’administrateur en chef de l’établissement (le cas échéant/si nécessaire) et un représentant autorisé des instances décisionnelles ou de l’entité exerçant le contrôle (le cas échéant/si nécessaire) doivent lire et signer la déclaration d’acceptation puis la numériser et la renvoyer à l’IB par l’intermédiaire du plan d’action sur Mon établissement.';
        
        
        List<IB_Programme__c> programmes = new List<IB_Programme__c>();
        List<IB_Action_Plan__c> ap = new List<IB_Action_Plan__c>();
        List<Standards_Practices__c> practice = [SELECT Id, Practice__c FROM Standards_Practices__c];
        String practiceId;
        Date today = System.today();
        for(Standards_Practices__c pr : practice){
            if(pr.Practice__c == 'Support from authorities')
                practiceId = pr.Id;
            
        }
        
        for (IB_Programme__c prog : newMap.values()) {
            if (prog.StageName__c == 'Decision on Authorization' && prog.Sub_Stage__c == 'Update Decision' && oldMap.get(prog.Id).StageName__c != 'Decision on Authorization') {
                programmes.add(prog);
            } 
        }
        if (!programmes.isEmpty()) {
            
            for (IB_Programme__c programme : programmes) {
                
                IB_Action_Plan__c actionPlan = new IB_Action_Plan__c();
                actionPlan.AP_Standard_Practice__c = practiceId;
                actionPlan.AP_Due_Date__c = today+14;
                actionPlan.AP_Status__c = 'New';
                actionPlan.programme__c = programme.id;
                
                if(programme.Language_of_Correspondence_Acct__c == 'English'){
                    actionPlan.AP_Action_Type__c = 'School Action';
                    actionPlan.AP_Action_Description__c = 'Authorization Action - Upload signed documents';
                    actionPlan.AP_Achievement_Evidence__c = EnglishDesc;
                }else if(programme.Language_of_Correspondence_Acct__c == 'Spanish'){
                    actionPlan.AP_Action_Type__c = 'Acción de la escuela';
                    actionPlan.AP_Action_Description__c = 'Acción de Autorización -  Cargar documentos firmados';
                    actionPlan.AP_Achievement_Evidence__c = SpanishDesc;
                }else if(programme.Language_of_Correspondence_Acct__c == 'French'){
                    actionPlan.AP_Action_Type__c = 'Action de l école';
                    actionPlan.AP_Action_Description__c = 'Action d autorisation - Télécharger des documents signés';
                    actionPlan.AP_Achievement_Evidence__c = FrenchDesc;
                }
                
                actionPlan.Name = 'Authorization Action';
                actionPlan.Authorization_Action__c = true;
                actionPlan.Head_of_School_Email__c = programme.Head_of_School_Email__c;
                actionPlan.Program_Coordinator_Email__c = programme.Programme_Coordinator_Email__c;
                ap.add(actionPlan);
            }
            insert ap;
            
        }
    }
    private static  void IB_programmetriggerlogic1(Map<Id,IB_programme__c> oldMap ,list<IB_programme__c> newlist)
    {
        
        for( IB_Programme__c prog: newlist)
        {
            if (prog.status__c!= oldMap.get(prog.Id).status__c ||
                prog.StageName__c!= oldMap.get(prog.Id).StageName__c)
            {
                system.debug('stage name = ' + prog.StageName__c );
                system.debug('status name = ' + prog.status__c );
                
                //Case A- if Both Status and Stage is Changed
                if (prog.status__c!= oldMap.get(prog.Id).status__c &&
                    prog.StageName__c!= oldMap.get(prog.Id).StageName__c)
                {
                    system.debug('both are changed');
                    
                    IB_Programme_Report__c rep=new IB_Programme_Report__c();
                    rep.name=prog.name;
                    rep.Account_Name_Account_IBIS_code_Program__c=prog.Account_IBIS_Code__c;
                    rep.Account_Name__c=prog.Account_Name_Text__c ;
                    rep.Previous_Stage__c=oldMap.get(prog.Id).StageName__c;
                    rep.Previous_Status__c=oldMap.get(prog.Id).status__c;
                    rep.Programme_Legal_Name__c=prog.Programme_Legal_Name__c;
                    rep.Stage__c=prog.StageName__c;
                    rep.Stage_change_date__c=Date.today();
                    rep.Status__c=prog.Status__c;
                    rep.Status_Change_date__c=Date.today();
                    if(CustomReportData.IsExec)
                    {
                        CustomReportData.SaveReport(rep);
                    }
                    
                }
                
                //Case B- if only Status is Changed
                else if (prog.status__c!= oldMap.get(prog.Id).status__c &&
                         prog.StageName__c== oldMap.get(prog.Id).StageName__c)
                {
                    
                    IB_Programme_Report__c rep=new IB_Programme_Report__c();
                    rep.name=prog.name;
                    rep.Account_Name_Account_IBIS_code_Program__c=prog.Account_IBIS_Code__c;
                    rep.Account_Name__c=prog.Account_Name_Text__c ;
                    // rep.Previous_Stage__c=trigger.oldMap.get(prog.Id).StageName__c;
                    rep.Previous_Status__c=oldMap.get(prog.Id).status__c;
                    rep.Programme_Legal_Name__c=prog.Programme_Legal_Name__c;
                    // rep.Stage__c=prog.StageName__c;
                    // rep.Stage_change_date__c=Date.today();
                    rep.Status__c=prog.Status__c;
                    rep.Status_Change_date__c=Date.today();
                    if(CustomReportData.IsExec)
                    {
                        CustomReportData.SaveReport(rep);
                    }
                }
                //Case C- if only Stage is Changed
                else if (prog.status__c== oldMap.get(prog.Id).status__c &&
                         prog.StageName__c!= oldMap.get(prog.Id).StageName__c)
                {
                    
                    IB_Programme_Report__c rep=new IB_Programme_Report__c();
                    rep.name=prog.name;
                    rep.Account_Name_Account_IBIS_code_Program__c=prog.Account_IBIS_Code__c;
                    rep.Account_Name__c=prog.Account_Name_Text__c ;
                    rep.Previous_Stage__c=oldMap.get(prog.Id).StageName__c;
                    //rep.Previous_Status__c=oldMap.get(prog.Id).status__c;
                    rep.Programme_Legal_Name__c=prog.Programme_Legal_Name__c;
                    rep.Stage__c=prog.StageName__c;
                    rep.Stage_change_date__c=Date.today();
                    // rep.Status__c=prog.Status__c;
                    // rep.Status_Change_date__c=Date.today();
                    if(CustomReportData.IsExec)
                    {
                        CustomReportData.SaveReport(rep);
                    }
                }
                
                
            }
        }
    }
    private static void IB_programtriggerlogic3(list<IB_programme__c> newlist, Map<Id,IB_Programme__c> oldmap)
    {
        //This part is updated by Developer Ammara-Plumlogix on 21/02/2020,Code Merge with Prod
        //Begin
        /*Calling Future Method to send Email */
        List<IB_Programme__c> theProgrammeList = new List<IB_Programme__c>();
        /*Calling Future Method to send Email */
        for(IB_Programme__c theProgramme :newlist )
        { 
            // @description to stop sending emails for terminited Schools.
            // @this change is the part of US(PRB0041317).
            if (checkingStagesforSendingEmail(theProgramme, oldMap)) {
                theProgrammeList.add(theProgramme);
            }
            
        }
        if(theProgrammeList.size()>0){
            system.debug('Jarvis Log: Programme List Size : ' +theProgrammeList.size());
            EmailSending.ibprogramme_email_automation(theProgrammeList);
        }        
        //update invoice date
        /*Welcome Letter Creation on IB Progammer */
        //customCreateAndAttachPDF cPDF = new customCreateAndAttachPDF();
        if(!customCreateAndAttachPDF.ibProgramWLPDFExecuted && (newlist[0].Programme_in_candidacy__c == false ||(newlist[0].Programme_in_candidacy__c == true && newlist[0].Welcome_Letter_Sended__c == false))) {
            customCreateAndAttachPDF.ibProgramWLPDFExecuted = true;
            //if(WelcomeLetterList!=null){
            //  WelcomeLetterList = [Select name from IB_Application_Attachment__c where Name ='Welcome Letter.pdf' AND IB_Programme__r.id=:newlist[0].id];   
            //}
            //if(WelcomeLetterList?.Size()==0){
                customCreateAndAttachPDF.ibProgramWLPDF(newlist[0].id); 
            //}
        }
        system.debug('Jarvis Log: Programme ID : ' + newlist[0].id);
        IBEventPublishedFuture obj= new IBEventPublishedFuture();  
        obj.status_and_date_automation(newlist[0]); //End
        
    }
    private static void OnTermWith_UpdateRolesEndDate(Map<Id,IB_programme__c> oldMap ,list<IB_programme__c> newlist)
    {
        IboUtil.showLimits('IB_ProgrammeAfterUpdateTriggerHandler.OnTermWith_UpdateRolesEndDate');    
        List<IB_Role__c> rolesToUpdate = new List<IB_Role__c>();
        if(schoolRoles==null){//INC0208998 ben mcgarvey, had to reduce soql queries used
            schoolRoles = [SELECT Id FROM IB_Role_Repository__c];
        }
        Set<ID> IBProgNewID = new Set<ID>();
        Set<Id> ibAccountIds = new Set<Id>(); //Added for ECM00774
        Boolean check = false;
        for(IB_Programme__c iBProgramme : newlist) {
            
            //Check if Status changed, changed to previously Interested or Terminated or Withdrawn, and was previously neither of those statuses.
            if (iBProgramme.Status__c != oldMap.get(iBProgramme.Id).Status__c && ( iBProgramme.Status__c.contains('Terminated') || iBProgramme.Status__c.contains('Withdrawn') || iBProgramme.Status__c.contains('Previously Interested') ) && !oldMap.get(iBProgramme.Id).Status__c.contains('Previously Interested') && !oldMap.get(iBProgramme.Id).Status__c.contains('Terminated') && !oldMap.get(iBProgramme.Id).Status__c.contains('Withdrawn') ) { 
                
                System.debug('Programme changed from not Term/With/previously Interested to Term/Withdrawn/previously Interested');
                
                IBProgNewID.add(iBProgramme.Id);
                check =true;
                
                ibAccountIds.add(iBProgramme.Account__c); //Added for ECM00774
            }
            
        }//End for loop 1
        //===================
        //Added for ECM00774 - [start]
        System.debug('## ibAccountIds '+ibAccountIds);
        Set<Id> setSchoolHasOneActiveProg = new Set<Id>();
        Map<Id,Boolean> mapSchoolHasOneActiveProg = new Map<Id,Boolean>();
        if(!ibAccountIds.isEmpty()){
            Set<String> excludedStage = new Set<String>{'Withdrawal','Termination'}; 
            Set<String> excludedStatus = new Set<String>{'Terminated by School','Terminated by IB','Terminated',
                                                        'Withdrawn by IB','Withdrawn'}; 
            
            List<IB_Programme__c> lstProgSchAccs = [SELECT Id,Account__c,Account__r.RecordType.Name,StageName__c 
                                                    FROM IB_Programme__c
                                                    WHERE Account__c IN:ibAccountIds AND 
                                                    StageName__c  NOT IN:excludedStage AND Status__c NOT IN:excludedStatus
                                                    AND Sub_Stage__c != 'Complete'];
            if(!lstProgSchAccs.isEmpty()){
                for(IB_Programme__c prog : lstProgSchAccs){
                    if(prog.Account__r.RecordType.Name == 'School Account' ){
                        setSchoolHasOneActiveProg.add(prog.Account__c);
                    }
                }
                for(Id accId : ibAccountIds){
                    if(setSchoolHasOneActiveProg.contains(accId)){
                        mapSchoolHasOneActiveProg.put(accId,true);
                    }else{
                        mapSchoolHasOneActiveProg.put(accId,false);
                    }
                }
            }else{
                for(Id accId : ibAccountIds){
                    mapSchoolHasOneActiveProg.put(accId,false);
                }
            }
            System.debug('## mapSchoolHasOneActiveProg '+mapSchoolHasOneActiveProg);        
        }
        //ECM00774 - [end]
        
        List<IB_Role__c> roles = [SELECT Id, End_Date__c,IB_Programme_New__c,IB_Account__c,Status__c FROM IB_Role__c WHERE End_Date__c = null AND IB_Role__c IN :schoolRoles AND (IB_Programme_New__c IN :IBProgNewID OR IB_Account__c IN: ibAccountIds) AND (Start_Date__c <= TODAY OR Start_Date__c = null) ];
        // Added IB_Account__c condition  and few fields for ECM00774
        // Status__c field added by Prerna for bug related to ECM00774 on 28-01-2025
        System.debug('## roles '+roles);        
        
        if(!roles.isEmpty()) {            
            if (roles.size() <= 20 || system.isBatch() || system.isfuture()) {
                for(IB_Role__c roleToUpdate: roles ) {
                    System.debug('Updating Role: ' + roleToUpdate);
                    
                    if((roleToUpdate.IB_Programme_New__c != null && IBProgNewID.contains(roleToUpdate.IB_Programme_New__c)) || 
                        (mapSchoolHasOneActiveProg.containsKey(roleToUpdate.IB_Account__c) && !mapSchoolHasOneActiveProg.get(roleToUpdate.IB_Account__c))){ 
                        //Below if else is part of the existing logic
                        if(roleToUpdate.Status__c != IboUtil.ROLE_APPLICANT_STATUS && 
                                roleToUpdate.Status__c !=IboUtil.ROLE_INVITED_STATUS){
                            roleToUpdate.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                        }else{
                            roleToUpdate.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                        }
                        // Added if condition for ECM00774  
                        rolesToUpdate.add(new IB_Role__c(Id = roleToUpdate.Id, End_Date__c = System.today(), Status__c=IboUtil.ROLE_WITHDRAWN_STATUS, Active__c=false));
                    } 
                    System.debug('## rolesToUpdate '+rolesToUpdate);    
                }
                //===================
                
                if(rolesToUpdate.size() > 0 && check){
                    update rolesToUpdate; 
                }       
            } else {
                Database.executeBatch(new WithdrawRolesBatch(IBProgNewID), 20);
            }
        }
        
        IboUtil.showLimits('IB_ProgrammeAfterUpdateTriggerHandler.OnTermWith_UpdateRolesEndDate'); 
    }
    /** 
* @author Saurabh(Epam)
* @date 11/08/2023
* @description to stop sending emails for terminited Schools.
* @this change is the part of US(PRB0041317).
* @filter logic updated as part of INC0194417 1/25/2024 Kevin Fugate
*/  
    public static Boolean checkingStagesforSendingEmail(IB_Programme__c theProgramme, Map<Id, IB_Programme__c> oldMap) {
        return !theProgramme.Introduction_Letter_Sent__c
            && theProgramme.StageName__c != 'Withdrawal'
            && theProgramme.StageName__c != 'Termination'
            && theProgramme.StageName__c != 'Suspension';
    }
    
    /* For Withdrawl for Associated Roles and Apps on School Withdrawl
US11296
Plumlogix - RF Project
Begin*/
    
    /*   This functionalty is moved to batch class now.
* 
*   Public static void AutomaticRoleWithdrawl( list<IB_Programme__c> Programme , Map<Id,IB_Programme__c> oldmap)   {
system.debug('in function');  
Set<ID> prog_ids = new Set<ID>(); 
for( IB_Programme__c prog: Programme){
if (prog.status__c!= oldmap.get(prog.Id).status__c 
&& (prog.status__c=='Withdrawn'||
prog.status__c=='Terminated'||prog.status__c=='Terminated by School'
||prog.status__c=='Terminated by IB'||prog.status__c=='Withdrawn by School'
||prog.status__c=='Withdrawn by IB') && prog.Old_Withdrawn_Status_Date__c !=null){
prog_ids.add(prog.id);


} //End
}

list <IB_Role__c>    roles = [select name,IB_Role__c.IB_Programme_New__r.Old_Withdrawn_Status_Date__c,IB_Role__c.IB_Programme_New__c,End_Date__c,status__c from IB_Role__c where IB_Role__c.IB_Programme_New__c IN:prog_ids];
Map<id,IB_Role__c> map_roles = new Map<id,IB_Role__c>();

for(IB_role__c r:roles)
{   
r.status__c='Withdrawn';
r.End_Date__c= r.IB_Programme_New__r.Old_Withdrawn_Status_Date__c;  
map_roles.put(r.id,r);   

}   

if(map_roles.size()>0){
update map_roles.values();
}


}*/
    /** 
* @author Muhammad Shehryar
* @date 03/24/2021
* @description update Legal_Guarantee_Document__c field of IB event when Legal_Guarantee_Document__c field of IB Programme updated.
* @returntype Void
* @param List<IB_Programme__c> oldList,List<IB_Programme__c> newList
*/       
    
    public static void IB_programWithIB_Event_legal(list<IB_programme__c> oldList, List<IB_programme__c> newList)
    {
        system.debug('legal_func');
        boolean Ib_Programme_new_legal;
        boolean Ib_Programme_old_legal;
        String ib_programme_id;
        
        for(IB_Programme__c old : oldList){
            Ib_Programme_old_legal = old.Legal_Guarantee_Document__c;
        }
        
        Set<ID> prog_ids = new Set<ID>();
        for(IB_Programme__c prog : newList){
            ib_programme_id = prog.Id;
            Ib_Programme_new_legal = prog.Legal_Guarantee_Document__c;
            prog_ids.add(prog.id);
        }
        
        
        
        if(Ib_Programme_new_legal!=Ib_Programme_old_legal)
        {
            system.debug('legal_func1');
            
            List<Campaign> event= [Select id,name from Campaign where Related_IB_Programme__c =:ib_programme_id
                                   And Type = 'Authorization'
                                   And Sub_Type__c = 'Request for Candidacy'
                                   And Status != 'Cancel' 
                                   And Status != 'Postponed'   ];
            
            Map<id,Campaign> map_roles = new Map<id,Campaign>();
            
            for(Campaign r:event)
            {   
                {
                    system.debug('legal_func2');
                    r.Legal_Guarantee_Document__c=Ib_Programme_new_legal;  
                    map_roles.put(r.id,r);   
                }
            }   
            
            if(map_roles.size()>0){
                update map_roles.values();
            }
        }
    }
    
    //End
    
    //Method created by Shahrukh for ECM00739 Part-2 on 12-03-25
    public static void sendEmailUponSecondProgramAuthorization(List<IB_programme__c> newList, Map<Id,IB_programme__c> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id, IB_Programme__c> authorizedProgrammes = new Map<Id, IB_Programme__c>();
        List<IB_Role__c> ibRolesList = new List<IB_Role__c>();
        Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap = new Map<Id, Map<String, IB_Role__c>>();
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for(IB_programme__c prog : newList) {
            if(oldMap.get(prog.Id).Status__c != 'Authorized' && prog.Status__c == 'Authorized' && prog.Account__c != null) {
                accountIds.add(prog.Account__c);
                authorizedProgrammes.put(prog.Id, prog);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }
        
        //IBProgrammeTriggerHelper.getAuthorizedProgramme(accountIds, newList);// added by kashyap
        Map<Id, Integer> authorizedCounts = IBProgrammeTriggerHelper.getAuthorizedProgrammeCount(accountIds);
        
        Set<String> allowedRoles = new Set<String>{'Head of School', 'Programme Coordinator'  };
        ibRolesList = IBProgrammeTriggerHelper.getIbRolesByProgrammes(authorizedProgrammes, allowedRoles);
        
        ibProgrammeVsIBRoleMap = IBProgrammeTriggerHelper.createIbRoleMapByIbProgramme(ibRolesList);
        
        Map<Id, Account> accountMap = IBProgrammeTriggerHelper.getAccountMap(accountIds);
        
        Set<Id> ownerIds = IBProgrammeTriggerHelper.getAccountOwnerIds(accountMap);
        
        Map<Id, User> userMap = IBProgrammeTriggerHelper.getUserMap(ownerIds);
        
        OrgWideEmailAddress[] owea = IBProgrammeTriggerHelper.getOrgWideEmailAddress('myschool-noreply@ibo.org');
        
        Set<String> templateDeveloperNames = new Set<String>{
            'Auth_IBWS_Adding_a_Programme_English',
            'Auth_IBWS_Adding_a_Programme_French',
            'Auth_IBWS_Adding_a_Programme_Spanish'
         };
                    
        Map<String, EmailTemplate> templateMap = IBProgrammeTriggerHelper.createEmailTemplateMap(templateDeveloperNames);
        
        for (IB_Programme__c programme : authorizedProgrammes.values()) {
            if (authorizedCounts.get(programme.Account__c) > 1) {
                // Atticus null Check ECM00739
                if(userMap != null && !userMap.isEmpty() && accountMap!=null && !accountMap.isEmpty() &&
                    accountMap.containsKey(programme.Account__c) && 
                    userMap.containsKey(accountMap.get(programme.Account__c).OwnerId)){
                         emailsToSend = IBProgrammeTriggerHelper.substituteEmailTemplates(programme, templateMap, ibProgrammeVsIBRoleMap, accountMap, userMap, owea, emailsToSend, null);
                }
            }
        }
        
        if (!emailsToSend.isEmpty() ) {
            IBProgrammeTriggerHelper.sendEmail(emailsToSend);
        }
        
        IBProgrammeTriggerHelper.getAuthorizedProgramme( accountIds, newList, accountMap,userMap );// added by kashyap part3
       
    }
}