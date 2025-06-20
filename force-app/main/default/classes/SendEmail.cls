/*

Copyright (c) 2012, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
* Neither the name of the salesforce.com, Inc. nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.





* Salesforce version written for: Winter '12 onwards
* This Apex plug-in for Visual Workflow is a wrapper on top of the standard SendEmail API to send emails
* This Apex plug-in also supports the ability to send a PDF attachment.
*
* Inputs:
*  recordID (String)  - Optional
*  emailAddress (String) - Optional
*  subject (String) - Required
*  body (String) - Required
*  textAttachmentName (String) - Required
*  textAttachmentBody (String) - Required
*  pdfAttachmentName (String) - Required
*  pdfAttachmentBody (String) - Required
*
* Outputs:
*  Status (String) - SUCCESS/ERROR
*  ErrorMessage(String) - 'Email sent successfully'
*/


// The Apex Plug-in for a flow must implement the Apex Process.Plugin Interface
global with sharing class SendEmail implements Process.Plugin {

    public String pluginStatus;
    public String pluginErrorMessage;

    public static final String SUCCESS = 'SUCCESS';
    public static final String ERROR = 'ERROR';
    public static final String SUCCESS_MESSAGE = 'Email sent successfully';


    global Process.PluginResult invoke(Process.PluginRequest request) {
        system.debug('#### SendEmail Process plugin invoked');
        // Get all the inputs from the Flow
        String recordID = (String) request.inputParameters.get('recordID');
        String emailAddress = (String) request.inputParameters.get('emailAddress');
        String subject = (String) request.inputParameters.get('subject');
        String attBody = (String) request.inputParameters.get('body');
        String ccEmails = (String) request.inputParameters.get('Emails to CC');
        String displayName = (String) request.inputParameters.get('Display Name');
        String replyTo = (String) request.inputParameters.get('Reply Address');
        
        String lang = (String) request.inputParameters.get('Language');
        
        String emailSubject = '';
        String emailBody = '';
        
        if(lang == 'French'){
            emailSubject = 'Notification concernant votre demande de candidature';
            emailBody = 'Une lettre de notification concernant la demande de candidature de votre établissement vient d’être publiée sur le tableau de bord de Mon établissement.<br/><br/>Veuillez accéder au système pour la consulter.';
        }else if (lang == 'Spanish'){
            emailSubject = 'Novedades sobre la solicitud de categoría de colegio solicitante';
            emailBody = 'Se ha publicado en la página principal de Mi colegio una carta de notificación relativa a la solicitud de categoría de colegio solicitante de su colegio. <br/><br/>Acceda al sistema para revisar este documento.';
        }else{
            emailSubject = 'Update on Application for Candidacy is now available';
            emailBody = 'A notification letter regarding your school’s Application for candidacy has been published on the My School dashboard. <br/><br/>Please access the system to review this document.';
        }
        
        /*
            displayName = String.isBlank(displayName) ? 'International Baccalaureate' : displayName;
            replyTo = String.isBlank(displayName) ? 'Reply Address' : replyTo;
        */
        
        //Get the list of Attachments
        String textAttachmentName = (String) request.inputParameters.get('textAttachmentName');
        String textAttachmentContent = (String) request.inputParameters.get('textAttachmentContent');
        String pdfAttachmentName = (String) request.inputParameters.get('pdfAttachmentName');
        String pdfAttachmentContent = (String) request.inputParameters.get('pdfAttachmentContent');

        Map<String,Object> attachments = new Map<String,Object>();
        if ( (textAttachmentName !=null &&  textAttachmentName.length() > 0) && (textAttachmentContent !=null &&  textAttachmentContent.length() > 0))
            attachments.put(textAttachmentName, textAttachmentContent);

        if ( (pdfAttachmentName !=null &&  pdfAttachmentName.length() > 0) && (pdfAttachmentContent !=null &&  pdfAttachmentContent.length() > 0))
            if(!pdfAttachmentName.contains('.pdf')) pdfAttachmentName = pdfAttachmentName+'.pdf';
        attachments.put(pdfAttachmentName, pdfAttachmentContent);

        Map<String,Object> result = new Map<String,Object>();
        try {
            //Send email
            SendEmail(recordID, emailAddress, emailSubject, attachments,emailBody,ccEmails,displayName, replyto,lang,attBody);
            result.put('Status', pluginStatus);
            result.put('ErrorMessage', pluginErrorMessage);
        }
        catch (Exception anException) {
            system.debug('#### ERROR : '+anException.getMessage());
            result.put('Status',ERROR);
            result.put('ErrorMessage', anException.getMessage());
        }

        return new Process.PluginResult(result);
    }
    
    global void sendEmail(
        String recordId,
        String emailAddress,
        String subject,
        Map<String,Object> attachments,
        String body,
        String cc,
        String disp,
        String reply,
        String language,
        String attBody
    ) {
        system.debug('#### sendEmail method called');
        try{
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            Boolean recordIdIsUser = (recordId != null) && recordId.startsWith('005'); //is the record id referencing a user id?
            Boolean saveAsActivity = !recordIdIsUser;
            if (emailAddress != null && emailAddress.length() > 0) {
                list<string> toEmail = new list<string>();
                message.setToAddresses(new String[] {emailAddress});
            }
            if (recordId != null && recordId.length() > 0 && !recordId.startsWith('a1R')) {
                message.setTargetObjectId(recordId);
            }
            if(!String.isBlank(cc)){
                message.setCcAddresses(cc.split(';'));
            }
            
            boolean useOrgWideEmail = true;
            if(!String.isBlank(disp)){
                useOrgWideEmail = false;
                message.setSenderDisplayName(disp);
            }
            if(!String.isBlank(reply)){
                useOrgWideEmail = false;
                message.setReplyTo(reply);
            }
            
            List<OrgWideEmailAddress> tmpAddress = [select id from orgWideEmailAddress where address='myschool-noreply@ibo.org'];
            if(useOrgWideEmail && !tmpAddress.isEmpty()){
                message.setOrgWideEmailAddressId(tmpAddress[0].id);
            }
            
            message.setSubject(subject);
            message.setHtmlBody(body != null ? body : '');  // If the body is empty, use an empty string
            
            // Don't set the reply to, because it's auto-calculated.
            message.setUseSignature(true);
            message.setSaveAsActivity(saveAsActivity);
    
            // Convert the attachments, creating the objects to add to the list of attachments if set
            List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();
            
            List<Attachment> attachmentList = new List<Attachment>();
            if (attachments != null) {
                for (String attachKey : attachments.keySet()) {
                    String attachValue = (String) attachments.get(attachKey);
                    if (attachValue == null || attachValue.length() == 0) continue;
    
                    Messaging.EmailFileAttachment emailAttach = new Messaging.EmailFileAttachment();
                    emailAttach.setFileName(attachKey);
                    Blob attachment;
                    if (attachKey.endsWith('.pdf')) { // if its a pdf need to convert
                        attachment = Blob.toPdf(attachValue);
                    } else {
                        attachment = Blob.valueOf(attachValue);
                    }
    
                    emailAttach.setBody(attachment);
                    emailAttachments.add(emailAttach);
    
                    if (recordId != null && recordId.length() != 0 && !recordIdIsUser) {
                        Attachment attach = new Attachment();
                        attach.ParentId = recordId;
                        attach.Name = emailAttach.getFileName();
                        attach.Body = emailAttach.getBody();
                        attachmentList.add(attach);
                    }
                }
            }
            message.setFileAttachments(emailAttachments);
    
            Messaging.SendEmailResult result = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message})[0];
            
            system.debug('#### Body : '+body);
            
            // If the record ID is specified, add the email to the parent object as well.
            if (attachmentList.size() > 0) {
                insert attachmentList;
            }
            
            system.debug('##### recordId : '+recordId);
            
            //Creating attachment for IB Programme
            List<Attachment> pdfAttachmentList = new List<Attachment>();
            if (recordId != null && recordId.length() != 0 && !recordIdIsUser) {
                Attachment attach = new Attachment();
                attach.ParentId = recordId;
                if(language == 'French'){
                    attach.Name = 'IB: Demande de lettre de réponse à la candidature.pdf';
                }else if (language == 'Spanish'){
                    attach.Name = 'IB: Solicitud de carta de respuesta a la candidatura.pdf';
                }else{
                    attach.Name = 'IB : Application for candidacy response letter.pdf';
                }
                
                
                //PageReference letterTemplate = Page.IBAppCandidacyRespLetterTemplate;
                //letterTemplate.getParameters().put('programmeId',recordId);

                //PageReference letterTemplateToSend = letterTemplate;

                PageReference letterTemplateToSend = new PageReference('/apex/IBAppCandidacyRespLetterTemplate?programmeId=' + recordId);
                if(!Test.isRunningTest())
                    attach.body = letterTemplateToSend.getContent();
                else
                    attach.body = null;
                //attach.Body = Blob.toPdf(attBody != null ? attBody : '');
                
                pdfAttachmentList.add(attach);
            }
    
            system.debug('#### pdfAttachmentList : '+pdfAttachmentList.size());
    
            //Creating IB application attachment for IB Programme
            if (pdfAttachmentList.size() > 0) {
                insert pdfAttachmentList;
            }
             /*   list<IB_Application_Attachment__c> appAttachmentList = new list<IB_Application_Attachment__c>();
                for(Attachment att : pdfAttachmentList){
                    IB_Application_Attachment__c appAttachment = new IB_Application_Attachment__c();
                    appAttachment.Name = att.Name;
                    appAttachment.IB_Programme__c = att.ParentId;
                    appAttachment.Attachment__c = att.Id;
                    appAttachment.Type__c = 'Consultant Report';
                    appAttachment.Publish_to_Community__c = true;
                    appAttachmentList.add(appAttachment);
                }
                insert appAttachmentList;
                system.debug('#### appAttachmentList : '+appAttachmentList.size());
            }*/
    
            if (result.isSuccess()) {
                pluginStatus =  SUCCESS;
                pluginErrorMessage = SUCCESS_MESSAGE;
                //Update Letter of Candidacy Date on IB Event with today's date when email is sent successfully.
                if(recordId != null && recordId.length() != 0 && !recordIdIsUser){
                    updateVisitAndMonitoring(recordId);
                }
            } else {
                pluginStatus = ERROR;
                pluginErrorMessage = result.getErrors()[0].getMessage();
            }
        }catch(Exception e){
            system.debug('#### ERROR : '+e.getMessage());
            pluginStatus = ERROR;
            pluginErrorMessage = e.getMessage();
        }
    }

    //Method to update Letter of Candidacy Date on IB Event
    global void updateVisitAndMonitoring(string programmeId){
        list<Campaign> visitAndMonitoringList = [select id, AfC_Final_Response_to_School_Date__c from Campaign where Related_IB_Programme__c =: programmeId];
        for(Campaign event : visitAndMonitoringList){
            event.AfC_Final_Response_to_School_Date__c = system.today();
        }
        update visitAndMonitoringList;
    }


    /* This is the method the Cloud Flow Designer calls to show the Apex Plug-ins to the flow author
    * The implemnetation of this method drives how author of the flow interacts in the the Cloud Flow Designer
    */
    global Process.PluginDescribeResult describe() {

        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        //Shows the description visible in the Palette tab of the Cloud Flow Designer.
        result.description = 'The SendEmail Flow Plug-in send an email according to the Messaging.SendSingle Apex API';

        //Setting the 'tag' give the Apex Plug-in as its own section on the Cloud Flow Designer Palette tab.
        // Use this attribute to group related Apex Plug-ins together in the Cloud Flow Designer.
        result.tag = 'Emails';

        //All the Inputs needed, their data type and the requiredness
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter('recordID',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('emailAddress',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('subject',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('body',Process.PluginDescribeResult.ParameterType.STRING, true),
            new Process.PluginDescribeResult.InputParameter('textAttachmentName',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('textAttachmentContent',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('pdfAttachmentName',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('pdfAttachmentContent',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Emails to CC', 'If more than one email address, add a semi-colin between each email address.',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Display Name',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Reply Address',Process.PluginDescribeResult.ParameterType.STRING, false),
            new Process.PluginDescribeResult.InputParameter('Language', 'On supports Spanish, English, French',Process.PluginDescribeResult.ParameterType.STRING, false)
        };

        //All the Outputs and their data type
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            new Process.PluginDescribeResult.OutputParameter('Status',Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('ErrorMessage',Process.PluginDescribeResult.ParameterType.STRING)
        };
        
        return result;
    }
}