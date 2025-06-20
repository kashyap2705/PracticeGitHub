/*******************************************************************************************
* @Name     EmailSending 
* @Author   Ammara Alvi    
* @Date     12/27/2018    
* @Group        
* @Description  This Class is ues to send emil to HOS, Programme coordinator and Consultant 
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         Added logger framework to publish error messages
*******************************************************************************************/
public class EmailSending {
    
    public static boolean iBProgEANotExecuted = true;
    
    //Future Apex automation on IB Programme to send email
    //@Future(callout=true)
    public static void ibprogramme_email_automation(List<IB_Programme__c> theProgrammeList) {
        try {
            Map<ID,IB_programme__c> theProgramme= new Map<ID,IB_programme__c>();
            List<IB_programme__c> theProgrammetoUpdate = new List<IB_programme__c>();
            IB_Programme__c theProgrammerecord = new IB_Programme__c();
            
            //Retive related ib-programme and Campaign data
            List<IB_Programme__c> prog = new List<IB_Programme__c>();
            prog = [select Id,StageName__c,Status__c,Sub_Stage__c,Programme_in_candidacy__c,Introduction_Letter_Sent__c,
                    Contact_Head_of_School__c,Contact_Programme_Coordinator__c
                    from IB_Programme__c where Id IN :theProgrammeList AND
                    StageName__c = 'Consultation process' AND
                    Status__c = 'Candidate' AND
                    Introduction_Letter_Sent__c = false]; 
            System.debug('List of Prog: '+prog.size());
            if(prog.size() > 0){
                for(IB_Programme__c theProg:prog){
                    theProgramme.put(theProg.id,theProg);
                    System.debug('ID: '+theProg.id);
                }
                
                List <My_Staffing_Event__c> staffing_event = new List<My_Staffing_Event__c>();
                staffing_event = [select id,Staffing_Event_Status__c,Application_Status__c,IB_Event__c,
                                  IB_Event__r.Sub_Type__c,IB_Event__r.Related_IB_Programme__c,
                                  IB_Contact__c  from My_Staffing_Event__c where 
                                  IB_Event__r.Related_IB_Programme__c IN :prog AND
                                  IB_Event__r.Sub_Type__c = 'Candidacy Consultation'
                                  AND Application_Status__c = 'Confirmed'
                                 ];
                
                if(staffing_event.size()>0){
                    for(My_Staffing_Event__c list_staffing_event: staffing_event) {
                        
                        
                        //Conditions to send Email
                        if (list_staffing_event.Application_Status__c == 'Confirmed' && 
                            (list_staffing_event.Staffing_Event_Status__c == 'Staffed' || list_staffing_event.Staffing_Event_Status__c == 'Staffed-Pending L1')) {
                                
                                system.debug('Entering into Send email notification from IB Programme');  
                                system.debug('list_staffing_event : ' +list_staffing_event);  
                                system.debug('theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c) : ' + theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c));  
                                send_email_notification(theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c),list_staffing_event);
                                system.debug('Entering into Attach intro letter from IB Programme');
                                attachmentLetter(theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c).id,list_staffing_event.id);
                                
                                
                                theProgrammerecord = theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c);
                                theProgrammerecord.Introduction_Letter_Sent__c = true;
                                System.debug('theProgrammerecord.Introduction_Letter_Sent__c: '+theProgrammerecord.Introduction_Letter_Sent__c);
                                theProgrammetoUpdate.add(theProgrammerecord);
                                System.debug('Jarvis Log: If-IB Programme Record: '+theProgrammerecord);
                                
                            } 
                        else if(list_staffing_event.Staffing_Event_Status__c != 'Staffed'||list_staffing_event.Staffing_Event_Status__c != 'Staffed-Pending L1') {
                            
                            
                            theProgrammerecord = theProgramme.get(list_staffing_event.IB_Event__r.Related_IB_Programme__c);
                            theProgrammerecord.Programme_in_candidacy__c = true;
                            theProgrammetoUpdate.add(theProgrammerecord);
                            System.debug('Jarvis Log: Else-IB Programme Record : '+theProgrammerecord);
                        }
                        System.debug('theProgrammetoUpdate.Id: '+theProgrammetoUpdate[0].Id);
                        System.debug('theProgrammetoUpdate.Introduction_Letter_Sent__c: '+theProgrammetoUpdate[0].Introduction_Letter_Sent__c);
                       
                    }
                     if(theProgrammetoUpdate.size() > 0){
                        iBProgEANotExecuted = false;
                        update theProgrammetoUpdate;
                    }
                }
            }
        }            
        catch (Exception ex) {
            Logger.get().add(ex, LogSeverity.ERROR).publish();             
        }
    } 
    
    public static Boolean isIBevent_email_automationNotExecuted = True;
    
    //Future Apex automation on IB Event to send email
    public static void ibevent_email_automation(Id eventid) {     
        try {
            
            List<campaign> camp = [select  Id,status,Sub_Type__c,Related_IB_Programme__c from campaign where Id=: eventid Limit 1];
            List<IB_Programme__c> prog = [select Id,Introduction_Letter_Sent__c,Programme_Relationship_Manager_Name__c,Programme_Relationship_Manager_Email__c,StageName__c,Programme_Coordinator_Name__c,Contact_Head_of_School__c,Contact_Programme_Coordinator__c,Status__c,Sub_Stage__c,Date_Decision_on_Candidacy__c,Programme_in_candidacy__c,Account__c from IB_Programme__c where Id=: camp[0].Related_IB_Programme__c Limit 1 ];
            List <My_Staffing_Event__c> staffing_event = [select id,Application_Status__c,IB_Contact__c  from My_Staffing_Event__c where IB_Event__c =: camp[0].id AND Application_Status__c = 'Confirmed'];
            
            
            for(My_Staffing_Event__c list_staffing_event: staffing_event) {
                System.debug('Jarvid Log : IB Event');
                //Condition to satisfy for email sending
                if(camp[0].status == 'Staffed'  && camp[0].Sub_Type__c == 'Candidacy Consultation' 
                   && list_staffing_event.Application_Status__c == 'Confirmed' && prog[0].Programme_in_candidacy__c == true
                   && prog[0].Introduction_Letter_Sent__c == false) {
                       
                       isIBevent_email_automationNotExecuted = false;
                       system.debug('Today prog[0] : ' +prog[0]); 
                       system.debug('Today staffing_event[0]: ' +staffing_event[0]); 
                       send_email_notification(prog[0], staffing_event[0]);
                       attachmentLetter(prog[0].id, staffing_event[0].id);
                       
                       prog[0].Introduction_Letter_Sent__c = true;
                       System.debug('prog[0].Introduction_Letter_Sent__c : '+ prog[0].Introduction_Letter_Sent__c);
                       update prog[0];
                       
                   }
            }
        } catch (Exception ex) {            
            Logger.get().add(ex, LogSeverity.ERROR).publish(); 
        }
    }
    
    //create attachement Introduction Letter and Introduction Letter to Consultant
    @Future(callout=true)
    @TestVisible private static void attachmentLetter(ID programID, ID  staffing_eventID) {
        try
        {
            
            //Introduction Letter to Consultant PDF atachment generation
            PageReference pdfPage2 = Page.Introduction_Letter;
            
            //prep attachment   
            pdfPage2.getParameters().put('myStaffingEventID', staffing_eventID);
            //pdf.setRedirect(true); //does not seem to be required
            
            Attachment attachILC = new Attachment();
            
            if (Test.IsRunningTest())
            {
                attachILC.Body=Blob.valueOf('UNIT.TEST');
            }
            else
            {  
                
                attachILC.Body = pdfPage2.getContentAsPDF();//email.gethtmlBody(); //Blob.valueOf(encodedContentsString);
            }
            
            //attachILC.Body = pdfPage2.getContentAsPDF();//email.gethtmlBody(); //Blob.valueOf(encodedContentsString);
            attachILC.Name = String.valueOf('Introduction Letter.pdf');
            attachILC.ParentId = programID;
            insert attachILC;
            System.debug('Introduction letter inserted');
            
            List<IB_Application_Attachment__c> ibAppAttachments = [Select name from IB_Application_Attachment__c where Attachment__c =: attachILC.id];
            IB_Application_Attachment__c ibAppAttach = ibAppAttachments[0];
            ibAppAttach.Description__c = 'Letter';
            ibAppAttach.Category__c = 'Letter';
            ibAppAttach.Publish_to_Community__c = True;
            update ibAppAttach;   
            Logger.get().add('Introduction letter generated', LogSeverity.INFO).publish();
            System.debug('Introduction letter updated');
            
            system.debug('Jarvis Log===========================================Attachment ID'+attachILC.Id);
        }Catch(Exception x)
        {
            Logger.get().add(x, LogSeverity.ERROR).publish(); 
        }
        
    }
    
    //function to check email
    public static void send_email_notification(IB_Programme__c prog,My_Staffing_Event__c staffing_event) {
        try
        {
            //Reterive Related Contact record to send Email
            List <Contact> contact_consultant = [select id,Name,Email from Contact where id=:staffing_event.IB_Contact__c];  
            List<Contact> contact_hos = [select Name,Job_Title__c,Email from contact where id=:prog.Contact_Head_of_School__c];
            List<Contact> contact_coordinator = [select Name,Job_Title__c,Email from contact where id=:prog.Contact_Programme_Coordinator__c];
            
            //Setting strings value 
            string[] hosMail=new string[]{contact_hos[0].Email};
                string[] p_c_Mail=new string[]{contact_coordinator[0].Email};
                    string[] consultant_Mail=new string[]{contact_consultant[0].Email};   
                        
                        
                        //Email Template for sending email to Consultant
                        EmailTemplate templateId = [Select id from EmailTemplate where developerName = 'Introduction_Letter_to_Consultant'];
            
            //list to add all the mails
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
            
            //Setting email for consultant
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('IBEN Central');  
            mail.setTargetObjectId(contact_consultant[0].id);
            mail.setWhatId(staffing_event.id);
            mail.setTemplateId(templateId.id);
            mail.setToAddresses(consultant_Mail);
            
            
            //mail.setOrgWideEmailAddressId(owea.get(0).Id);
            //
            //Setting email for Head of School
            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
            mail1.setToAddresses(hosMail);
            mail1.setHtmlBody('A notification letter regarding your school’s Application for candidacy has been published on the My School dashboard.<br>Please access the system to review this document.');
            mail1.setSenderDisplayName('IBEN Central');  
            mail1.setSubject('Introduction Letter');
            
            
            //Setting email for Programme Coordinator
            Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
            mail2.setHtmlBody('A notification letter regarding your school’s Application for candidacy has been published on the My School dashboard.<br>Please access the system to review this document.');
            mail2.setSenderDisplayName('IBEN Central');  
            mail2.setSubject('Introduction Letter');
            mail2.setToAddresses(p_c_Mail);
            
            //add all email objects in list          
            allmsg.add(mail);
            allmsg.add(mail1);
            allmsg.add(mail2);
            
            //sending emails
            Messaging.sendEmail(allmsg);
        }
        Catch(Exception x)
        {
            Logger.get().add(x, LogSeverity.ERROR).publish(); 
        }
        
    }
    
}