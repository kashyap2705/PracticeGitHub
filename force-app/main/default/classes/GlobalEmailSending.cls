global class GlobalEmailSending {
    
    @RemoteAction
    Webservice Static String VerificationVisitEmail(id campid)
    {
        
        Try {
            //below query modified by Prerna on 6th Feb 2024 for ECM00508 (added Delivery_Mode__c field)
            List<Campaign> camp = [select id,Related_IB_Programme__c,Delivery_Mode__c, Owner.Name from Campaign where id=:campid];
            System.debug('Ib Event owner name is ===>'+camp[0].Owner.Name);
            
            //below line modified by prerna on 18-06-2024 and added Delivery mode condition
            //because we have to send the email only for 1 delivery mode
            if(camp[0].Related_IB_Programme__c != null && camp[0].Delivery_Mode__c == 'Remote'){
                //below query modified by Prerna on 5th Feb 2024 for ECM00508 (added Owner__c, HOSName__c fields)
                //below query modified by Prerna on 08-04-2024 for ECM00508 (ADDED PcName__c field)
                List<IB_Programme__c> programme = [select id,Account__r.Name, Contact_Programme_Coordinator__c,Contact_Head_of_School__c,Language_of_Correspondence_Acct__c,Owner__c, Account_Region__c, Account_IBIS_Code__c, Head_of_School_Name__c, HOSName__c, PcName__c, Programme_Coordinator_Name__c from IB_Programme__c where id=:camp[0].Related_IB_Programme__c];
                List<IB_Role__c> ibRolesList = [SELECT id, IB_Contact__c,IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,IB_Role_Name__c,Status__c 
                                               FROM IB_Role__c 
                                               WHERE IB_Programme_New__c =: camp[0].Related_IB_Programme__c 
                                               AND Status__c = 'Confirmed' 
                                               AND (IB_Role_Name__c = 'Head of School' Or IB_Role_Name__c = 'Programme Coordinator')];
                System.debug('ibRolesList===>'+ibRolesList);
                
                String programmeCoordinatorEmail,programmeCoordinatorName,headOfSchoolEmail,headOfSchoolName;
                ID pcContactID;
                for(IB_Role__c ibRole : ibRolesList) {
                    if(ibRole.IB_Role_Name__c == 'Programme Coordinator') {
                        programmeCoordinatorEmail = ibRole.IB_Contact__r.Email;
                        programmeCoordinatorName = ibRole.IB_Contact__r.Name;
                        pcContactID = ibRole.IB_Contact__c;
                    }
                    if(ibRole.IB_Role_Name__c == 'Head of School') {
                        headOfSchoolEmail = ibRole.IB_Contact__r.Email;
                        headOfSchoolName = ibRole.IB_Contact__r.Name;
                    }
                }
                System.debug('programmeCoordinatorEmail===>'+programmeCoordinatorEmail+ 'programmeCoordinatorName===>'+programmeCoordinatorName);
                System.debug('headOfSchoolEmail===>'+headOfSchoolEmail+ 'headOfSchoolName===>'+headOfSchoolName);

                String emailSubject;
                String tmpName='';                   
                
                if(programme[0].Language_of_Correspondence_Acct__c=='English'){
                    //tempName modified by Prerna on 8th Aug 2024
                    tmpName = 'Custom_vv_first_notification_to_school_eng';
                    emailSubject = programme[0].Account_Region__c + ': ' + camp[0].Delivery_Mode__c+ ' Verification visit notification' + ' – ' + programme[0].Account__r.Name+ ' ' + programme[0].Account_IBIS_Code__c + '\n'; 
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='Spanish'){
                    //tempName modified by Prerna on 8th Aug 2024
                    tmpName = 'Custom_vv_first_notification_to_school_spanish';
                    emailSubject = programme[0].Account_Region__c + ': ' + camp[0].Delivery_Mode__c+ ' Notificación de visita de verificación' + ' – ' + programme[0].Account__r.Name+ ' ' + programme[0].Account_IBIS_Code__c + '\n';  
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='French'){
                    //tempName modified by Prerna on 8th Aug 2024
                    tmpName = 'Custom_vv_first_notification_to_school_french';
                    emailSubject = programme[0].Account_Region__c + ': ' + camp[0].Delivery_Mode__c+ ' Notification de visite de vérification' + ' – ' + programme[0].Account__r.Name+ ' ' + programme[0].Account_IBIS_Code__c + '\n'; 
                }                            
                //below line commented by Prerna on 5th feb 2024 for ECM00508
                //string[] p_c_Mail=new string[]{contact_coordinator[0].Email};
                
                //code added by Prerna on 16 may 2024 for ECM00508 --STARTS--
                List<String> sendEmailList = new List<String> ();
                if (!String.isBlank(headOfSchoolEmail) || !String.isBlank(programmeCoordinatorEmail)) {
                    if (!String.isBlank(headOfSchoolEmail) && headOfSchoolEmail.contains('@')) {
                        sendEmailList.add(headOfSchoolEmail);
                    }
                    if (!String.isBlank(programmeCoordinatorEmail) && programmeCoordinatorEmail.contains('@')) {
                        sendEmailList.add(programmeCoordinatorEmail);
                    }
                }
                System.debug('test===>'+sendEmailList);
                //sendEmailList.add(contact_coordinator[0].Email);
                //code added by Prerna on 16 may 2024 for ECM00508 --ENDS--
                
                EmailTemplate templateId1 = [Select id,Body,HtmlValue from EmailTemplate where developerName =: tmpName ];
                //below line commented by Prerna on 5th feb 2024 for ECM00508
                //string[] Hos_Mail=new string[]{HOS.Email};
                //code added by Prerna on 5th feb 2024 for ECM00508 --STARTS--                
                User programmeRelationShipManager = [select id,Name, Email from User where id=:programme[0].Owner__c limit 1];
                string[] relationManagerEmail =new string[]{programmeRelationShipManager.Email};
                
                String templateBody;
                
                if (templateId1 != null && !sendEmailList.isEmpty()) {
                    templateBody = templateId1.HtmlValue;
                    //below line modified on 08-04-2024
                    templateBody = templateBody.replace('School Delivery Associate',camp[0].Owner.Name)
                                               .replace(']]>','');
                    if(templateBody.contains('{Head_of_School_Name}') && headOfSchoolName != null){
                        templateBody = templateBody.replace('{Head_of_School_Name}', headOfSchoolName);
                    }
                    System.debug('language====>'+programme[0].Language_of_Correspondence_Acct__c);
                    if(templateBody.contains('{Head_of_School_Name}') && headOfSchoolName == null){
                        System.debug('if enter===>');
                        if(programme[0].Language_of_Correspondence_Acct__c=='English'){
                            templateBody = templateBody.replace('{Head_of_School_Name} and', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c=='French'){
                            System.debug('french replacement===>');
                            templateBody = templateBody.replace('{Head_of_School_Name} et', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c=='Spanish'){
                            templateBody = templateBody.replace('{Head_of_School_Name} y', '');
                        }
                    }
                    
                    if(templateBody.contains('{Programme_Coordinator_Name}') && programmeCoordinatorName != null){
                        templateBody = templateBody.replace('{Programme_Coordinator_Name}', programmeCoordinatorName);
                    }
                    
                    if(templateBody.contains('{Programme_Coordinator_Name}') && programmeCoordinatorName == null){
                        if(programme[0].Language_of_Correspondence_Acct__c=='English'){
                            templateBody = templateBody.replace('and {Programme_Coordinator_Name}', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c=='French'){
                            templateBody = templateBody.replace('et {Programme_Coordinator_Name}', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c=='Spanish'){
                            templateBody = templateBody.replace('y {Programme_Coordinator_Name}', '');
                        }
                    }
                    if(templateBody.contains('{PrmName}') && programmeRelationShipManager.Name != null){
                        templateBody = templateBody.replace('{PrmName}', programmeRelationShipManager.Name);
                    }
                    if(templateBody.contains('{PrmEmail}') && programmeRelationShipManager.Email != null){
                        templateBody = templateBody.replace('{PrmEmail}', programmeRelationShipManager.Email);
                    }
                    //below code commented by Prerna on 18-06-2024 because we do not have this index anymore, since template is changed                 
                    /*if(programme[0].Language_of_Correspondence_Acct__c=='English')
                    {
                        //below line modified by Prerna on 12-04-2024 for date formatting
                        templateBody = templateBody.replace('{OneWeekLater}', formatDate(System.Today().addDays(7)));
                    }
                
                   if(programme[0].Language_of_Correspondence_Acct__c=='Spanish' || programme[0].Language_of_Correspondence_Acct__c=='French')
                   {                            
                       //below line modified by Prerna on 12-04-2024 for date formatting
                       templateBody = templateBody.replace('{OneWeekLater}', formatDate(System.Today().addDays(3)));
                   }*/
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 //below line modified by Prerna on 5th feb 2024 for ECM00508 
                //changed Address in where clause from noreply.iben@ibo.org to schooldelivery@ibo.org 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'schooldelivery@ibo.org'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                //Below code added by Prerna on 6th feb 2024 for ECM00508 --Starts--
                mail.setSubject(emailSubject);
                mail.setHtmlBody(templateBody);
                //code added by prerna --ENDS--
                
                mail.setTargetObjectId(pcContactID);
                mail.setTemplateId(templateId1.id);
                mail.setWhatId(programme[0].id);
                
                //mail.setSenderDisplayName('System Admin');
                
                //below 2 lines commented by Prerna on 5th feb 2024 for ECM00508
                /*mail.setToAddresses(p_c_Mail);
                mail.setCcAddresses(Hos_Mail);*/
                
                //below 2 lines added by Prerna on 5th feb 2024 for ECM00508
                mail.setToAddresses(sendEmailList);
                mail.setCcAddresses(relationManagerEmail);
                
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
                //code added by Prerna on 15-04-2024 for ECM00508 --STARTS--
                Task task = new Task();
                task.Subject = emailSubject;
                // Remove HTML tags from the templateBody
                String sanitizedDescription = templateBody.replaceAll('<[^>]*>', '')
                                                          .replaceAll('&nbsp;', ' ')
                                                          .trim();
                task.Description = sanitizedDescription;
                task.WhatId = campid; 
                task.Priority = 'Normal';
                task.Status = 'Completed';
                task.ActivityDate = Date.today();
                task.Type = 'Email';
                Database.insert(task);
                return 'Email sent successfully.';
                //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
                } else {
                    return 'Failed to send email';
                }
            } else {
                return 'Conditions not met for sending email.';
            }
        } catch (Exception e) {
            System.debug(e);
            return 'Error: ' + e.getMessage();
        }
    }
    //This code has been added by Saurabh Singh(Epam) as the part of the US (207345).
    //We are calling VerificationConfirmedVisitEmail method from this method.
    //beacuse we are not able to call the VerificationConfirmedVisitEmail method directly from the Flow.
    @InvocableMethod(label='Send Email Methods Calling')
    public static void sendEmail(List<eventIdAndEmailType> param) {
            switch on param[0].emailMethodName {
                when 'VerificationConfirmedVisitEmail' {
                    VerificationConfirmedVisitEmail(param[0].eventIds);
                }
                when 'VerificationVisitEmail' {
                    VerificationVisitEmail(param[0].eventIds);
                }
                when 'IBENVerificationVisitEmail' {
                    IBENVerificationVisitEmail(param[0].eventIds);
                }
                when 'VVTentativeDatesEmail' {
                    VVTentativeDatesEmail(param[0].eventIds);
                }
                // Add more cases for other email types if needed
                when else{
                     // Handle default case or leave empty if not needed
                }
                
            }
    }

    public class eventIdAndEmailType {
        @InvocableVariable(required=true)
        public Id eventIds;

        @InvocableVariable(required=true)
        public String emailMethodName;
    }
    @RemoteAction
    Webservice Static void VerificationConfirmedVisitEmail(id campid)
    {
        Try {          
            List<Campaign> camp = [select id,Related_IB_Programme__c from Campaign where id=:campid];
            list <My_staffing_event__c> TLs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Leader' AND Application_Status__c ='Confirmed' Limit 1];
            list <My_staffing_event__c> TMs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Member' AND Application_Status__c ='Confirmed' Limit 2];
            
            
            if(camp[0].Related_IB_Programme__c != null&&(TLs.size()>0 && TMs.size()>0  )){
                
                List<IB_Programme__c> programme = [select id,Language_of_Correspondence_Acct__c,Contact_Head_of_School__c,Contact_Programme_Coordinator__c from IB_Programme__c where id=:camp[0].Related_IB_Programme__c];
                String tmpName='';                   
                
                if(programme[0].Language_of_Correspondence_Acct__c=='English')
                {
                    tmpName = 'Verification visit confirmed';   
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='Spanish')
                {
                    tmpName = 'S-Verification visit confirmed';   
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='French')
                {
                    tmpName = 'F-Verification visit confirmed';   
                }
                
                EmailTemplate templateId1 = [Select id from EmailTemplate where Name =:tmpName];
                Contact contact_coordinator = [select id,Email from contact where id=:programme[0].Contact_Programme_Coordinator__c limit 1];
                
                Contact HOS = [select id,Email from contact where id=:programme[0].Contact_Head_of_School__c limit 1];
                
                
                if(HOS!=null && contact_coordinator!=null ){
                    string[] p_c_Mail=new string[]{contact_coordinator.Email};
                        string[] Hos_Mail=new string[]{HOS.Email};
                            
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }    
                    mail.setTargetObjectId(contact_coordinator.id);
                    mail.setTemplateId(templateId1.id);
                    mail.setWhatId(campid);
                    // mail.setSenderDisplayName('System Admin');
                    mail.setToAddresses(p_c_Mail);
                    mail.setCcAddresses(Hos_Mail);
                    mail.setUseSignature(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                
            }
        }
        catch(Exception e) 
        {              
            Logger.get().add(e, LogSeverity.ERROR).publish();            
        }
    }
    @RemoteAction
    Webservice Static void IBENVerificationVisitEmail(id campid)
    {
        
        Try {
            List<Campaign> camp = [select id,Related_IB_Programme__c from Campaign where id=:campid];
            list <My_staffing_event__c> TLs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Leader' AND Application_Status__c ='Confirmed' Limit 1];
            list <My_staffing_event__c> TMs = [select id,name,IB_Contact__r.name ,IB_Contact__r.Email from My_staffing_event__c where IB_Event__c=:Camp And IB_Role_Name__c='School Visit Team Member' AND Application_Status__c ='Confirmed' Limit 2];
            
            
            if(camp[0].Related_IB_Programme__c != null&&(TLs.size()>0 && TMs.size()>0  )){
                List<IB_Programme__c> programme = [select id,Language_of_Correspondence_Acct__c,Contact_Programme_Coordinator__c from IB_Programme__c where id=:camp[0].Related_IB_Programme__c];
                String tmpName='';                   
                if(programme[0].Language_of_Correspondence_Acct__c=='English')
                {
                    tmpName = 'IBEN Verification visit confirmed';   
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='Spanish')
                {
                    tmpName = 'IBEN-S Verification visit confirmed';   
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='French')
                {
                    tmpName = 'IBEN-F Verification visit confirmed';   
                }
                
                EmailTemplate templateId1 = [Select id from EmailTemplate where Name =:tmpName];
                
                List<Staffing_Event__c> IbenAss = [select id from Staffing_Event__c where IB_Event__c=:campid limit 1];
                List<my_Staffing_Event__c> Assignment = [select id,IB_Contact__c,Application_Status__c  from my_Staffing_Event__c where Staffing_Event__c=:IbenAss[0].id ];
                
                for(integer i=0;i<Assignment.size();i++) 
                    if(camp[0].Related_IB_Programme__c != null && Assignment[i].Application_Status__c =='Confirmed' )
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    
                    
                    List<Contact> contact_rel = [select id,Email from contact where id=:Assignment[i].IB_Contact__c ];
                    string[] p_c_Mail=new string[]{contact_rel [0].Email};
                        
                        mail.setTargetObjectId(contact_rel [0].id);
                    mail.setTemplateId(templateId1.id);
                    mail.setWhatId(campid);
                    // mail.setSenderDisplayName('System Admin');
                    mail.setToAddresses(p_c_Mail);
                    mail.setUseSignature(false);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            else
            {
                //throw ;
                system.debug('Email Shouldnt be sent');
            }
        }
        catch(Exception e) 
        {              
            Logger.get().add(e, LogSeverity.ERROR).publish();            
        }
        
    }
    //below method writtened by Prerna on 13-02-2024 for ECM00508
    @RemoteAction
    Webservice Static String VVTentativeDatesEmail(id campid)
    {
        Try {
            List<Campaign> camp = [select id,Related_IB_Programme__c,Delivery_Mode__c, Owner.Name, StartDate, EndDate, Status from Campaign where id=:campid];
            if(camp[0].Related_IB_Programme__c != null && camp[0].StartDate != null && camp[0].EndDate != null && camp[0].EndDate >= System.Today() && camp[0].Status == 'Planned / Ready for Staffing')
            {
                List<IB_Programme__c> programme = [select id,Account__r.Name, Contact_Programme_Coordinator__c,Contact_Head_of_School__c,Language_of_Correspondence_Acct__c,Owner__c, Account_Region__c, Account_IBIS_Code__c, Head_of_School_Name__c,HOSName__c, PcName__c, Programme_Coordinator_Name__c from IB_Programme__c where id=:camp[0].Related_IB_Programme__c];
                List<IB_Role__c> ibRolesList = [SELECT id, IB_Contact__c,IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,IB_Role_Name__c,Status__c 
                                               FROM IB_Role__c 
                                               WHERE IB_Programme_New__c =: camp[0].Related_IB_Programme__c 
                                               AND Status__c = 'Confirmed' 
                                               AND (IB_Role_Name__c = 'Head of School' Or IB_Role_Name__c = 'Programme Coordinator')];
                System.debug('ibRolesList===>'+ibRolesList);
                String programmeCoordinatorEmail,programmeCoordinatorName,headOfSchoolEmail,headOfSchoolName;
                ID pcContactID;
                for(IB_Role__c ibRole : ibRolesList) {
                    if(ibRole.IB_Role_Name__c == 'Programme Coordinator') {
                        programmeCoordinatorEmail = ibRole.IB_Contact__r.Email;
                        programmeCoordinatorName = ibRole.IB_Contact__r.Name;
                        pcContactID = ibRole.IB_Contact__c;
                    }
                    if(ibRole.IB_Role_Name__c == 'Head of School') {
                        headOfSchoolEmail = ibRole.IB_Contact__r.Email;
                        headOfSchoolName = ibRole.IB_Contact__r.Name;
                    }
                }
                String emailSubject;
                String tmpName='';
                Map<String, String> emailSubjectAndTemplate = new Map<String, String>(); 
                // Assigning email subject and email template  
                System.debug('lang===>'+programme[0].Language_of_Correspondence_Acct__c);      
                if(programme[0].Language_of_Correspondence_Acct__c=='English'){
                    emailSubjectAndTemplate = getEmailSubjectAndTemplate(programme[0], camp[0], 'Eng');
                    System.debug('emailSubjectAndTemplate===>'+emailSubjectAndTemplate);
                }
                
                if(programme[0].Language_of_Correspondence_Acct__c=='French'){
                    emailSubjectAndTemplate = getEmailSubjectAndTemplate(programme[0], camp[0], 'French');
                }
                if(programme[0].Language_of_Correspondence_Acct__c=='Spanish'){
                    emailSubjectAndTemplate = getEmailSubjectAndTemplate(programme[0], camp[0], 'Spanish');
                }
                if(emailSubjectAndTemplate.size() > 0){
                    emailSubject = emailSubjectAndTemplate.get('emailSubject');
                    tmpName = emailSubjectAndTemplate.get('tmpName');
                }
                List<String> sendEmailList = new List<String> ();
                if (!String.isBlank(headOfSchoolEmail) || !String.isBlank(programmeCoordinatorEmail)) {
                    if (!String.isBlank(headOfSchoolEmail) && headOfSchoolEmail.contains('@')) {
                        sendEmailList.add(headOfSchoolEmail);
                    }
                    if (!String.isBlank(programmeCoordinatorEmail) && programmeCoordinatorEmail.contains('@')) {
                        sendEmailList.add(programmeCoordinatorEmail);
                    }
                }
                System.debug('test===>'+sendEmailList);
                EmailTemplate templateId1 = [Select id,Body,HtmlValue from EmailTemplate where developerName =: tmpName ];
                
                User programmeRelationShipManager = [select id,Name, Email from User where id=:programme[0].Owner__c limit 1];
                string[] relationManagerEmail =new string[]{programmeRelationShipManager.Email};
                String templateBody;
                if (templateId1 != null && !sendEmailList.isEmpty()) {
                    System.debug('ENTERED IN CONDITION===>');
                    templateBody = templateId1.HtmlValue;
                    //below line modified by Prerna on 12-04-2024 for date formatting of StartDate and EndDate
                    templateBody = templateBody.replace('{IB Event Owner}',camp[0].Owner.Name)
                                               .replace('{start date}', formatDate(camp[0].StartDate))
                                               .replace('{end date}',formatDate(camp[0].EndDate))
                                               .replace(']]>','');
                    if(templateBody.contains('{Head_of_School_Name}') && headOfSchoolName != null){
                        templateBody = templateBody.replace('{Head_of_School_Name}', headOfSchoolName);
                    }
                    if(templateBody.contains('{Head_of_School_Name}') && headOfSchoolName == null){
                        if(programme[0].Language_of_Correspondence_Acct__c == 'English'){
                            templateBody = templateBody.replace('{Head_of_School_Name} and', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c == 'French'){
                            templateBody = templateBody.replace('{Head_of_School_Name} et', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c=='Spanish'){
                            templateBody = templateBody.replace('{Head_of_School_Name} y', '');
                        }
                    }
                   
                    if(templateBody.contains('{Programme_Coordinator_Name}') && programmeCoordinatorName != null){
                        templateBody = templateBody.replace('{Programme_Coordinator_Name}', programmeCoordinatorName);
                    }
                    if(templateBody.contains('{Programme_Coordinator_Name}') && programmeCoordinatorName == null){
                        if(programme[0].Language_of_Correspondence_Acct__c == 'English'){
                            templateBody = templateBody.replace('and {Programme_Coordinator_Name}', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c == 'French'){
                            templateBody = templateBody.replace('et {Programme_Coordinator_Name}', '');
                        }
                        if(programme[0].Language_of_Correspondence_Acct__c == 'Spanish'){
                            templateBody = templateBody.replace('y {Programme_Coordinator_Name}', '');
                        }
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'schooldelivery@ibo.org'];
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setSubject(emailSubject);
                mail.setHtmlBody(templateBody);
                    mail.setTargetObjectId(pcContactID);
                mail.setTemplateId(templateId1.id);
                mail.setWhatId(programme[0].id);
                mail.setToAddresses(sendEmailList);
                mail.setCcAddresses(relationManagerEmail);
                mail.setUseSignature(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    Task task = new Task();
                    task.Subject = emailSubject;
                String sanitizedDescription = templateBody.replaceAll('<[^>]*>', '')
                                                .replaceAll('&nbsp;', ' ')
                                                .trim();
                task.Description = sanitizedDescription;
                task.WhatId = campid; 
                task.Priority = 'Normal';
                task.Status = 'Completed';
                task.ActivityDate = Date.today();
                task.Type = 'Email';
                insert task;
                    return 'Email sent successfully.';
                    //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
                } else {
                    return 'Failed to send email';
                }
            } else {
                return 'Conditions not met for sending email.';
            }
        } catch (Exception e) {
            System.debug(e);
            return 'Error: ' + e.getMessage();
        }
    }
    //below method writtened by Prerna on 14-03-2024 for ECM00508
    public static Map<String, String> getEmailSubjectAndTemplate(IB_Programme__c programme, Campaign camp, String language ){
        
        Map<String, String> emailSubjectAndTemplate = new Map<String, String>();
        //below lines modified by Prerna on 12-04-2024 to maintain the consistency of Delivery Mode infront
        Switch on language{
            when 'Eng'{
                emailSubjectAndTemplate.put('emailSubject', programme.Account_Region__c + ': ' + camp.Delivery_Mode__c+ ' Verification visit Tentative dates agreement' + ' – ' + programme.Account__r.Name+ ' ' + programme.Account_IBIS_Code__c + '\n' );
            }
            when 'French'{
                emailSubjectAndTemplate.put('emailSubject', programme.Account_Region__c + ': ' + camp.Delivery_Mode__c+ ' Accord sur les propositions de dates pour visite de vérification' + ' – ' + programme.Account__r.Name+ ' ' + programme.Account_IBIS_Code__c + '\n');
            }
            when 'Spanish'{
                emailSubjectAndTemplate.put('emailSubject',programme.Account_Region__c + ': ' +camp.Delivery_Mode__c+ ' Acuerdo sobre fechas provisionales de visita de verificación' + ' – ' + programme.Account__r.Name+ ' ' + programme.Account_IBIS_Code__c + '\n');
            }
        }
        
        if(camp.Delivery_Mode__c == 'Remote')
        {
            //tempName modified by Prerna on 9th Aug 2024
            emailSubjectAndTemplate.put('tmpName','Custom_VV_Tentative_Dates_Agreement_Remote_' + language);
        }
        if(camp.Delivery_Mode__c == 'Hybrid')
        {
            //tempName modified by Prerna on 9th Aug 2024
            emailSubjectAndTemplate.put('tmpName', 'Custom_VV_Tentative_Dates_Agreement_Hybrid_' + language);
        } 
        if(camp.Delivery_Mode__c == 'On-site')
        {    
            //tempName modified by Prerna on 9th Aug 2024
            emailSubjectAndTemplate.put('tmpName', 'Custom_VV_Tentative_Dates_Agreement_On_site_' + language);
        }
        return emailSubjectAndTemplate;
    }
    // below method writtened by Prerna for Date Formatting on 12-04-2024 for ECM00508
    public static String formatDate(Date dateValue) {
        String formattedDate = String.valueOf(dateValue.month()) + '/' + String.valueOf(dateValue.day()) + '/' + String.valueOf(dateValue.year());
        formattedDate = formattedDate.replaceAll('(^|/)0', '$1');
        return formattedDate;
    }
}