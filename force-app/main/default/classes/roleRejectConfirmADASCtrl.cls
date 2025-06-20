public class roleRejectConfirmADASCtrl {
    public String invitationID {get;set;}
    public String invitationIDIBRole {get;set;}
    public String invitationIDIBRoleID {get;set;}
    public String body {get;set;}
    public Contact invitationContact {get; set;}
    public IB_Role__c roleRejected; // added newly for DAS
    public IB_Role__c docToRemove {get;set;} // added newly for DAS
    public String userLanguage; // added newly for DAS 
    
    //This code is added as a part of ADASUS05 of Admin Assistant Project on 11/2/2021
    //Start 
    
    public roleRejectConfirmADASCtrl(){
        
        invitationID = apexpages.currentpage().getparameters().get('inviteid');
        invitationIDIBRole = apexpages.currentpage().getparameters().get('inviteidIBRole');
        invitationIDIBRoleID = apexpages.currentpage().getparameters().get('inviteidIBRoleID');
        
        if((invitationID != null && invitationID != '') || (invitationIDIBRole != null && invitationIDIBRole != '')){
            if(invitationID != null)
                invitationContact = [Select id, Salutation, Name, Account__c, User_Language__c from Contact where Invitation_ID__c =:invitationID];
            else
                invitationContact = [Select id, Salutation, Name, Account__c, User_Language__c from Contact where id =:invitationIDIBRole ];        
        }
        
        userLanguage= invitationContact.User_Language__c ;
       
        if(invitationIDIBRoleID == null || invitationIDIBRoleID == '')
        {
            if(invitationID != null){
            //added and Status__c ='Invited' in below soql for DAS
            system.debug('invitationID***'+invitationID);
            IB_Role__c roleForId = [Select id,IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c,Status__c from IB_Role__c where IB_Contact__r.Invitation_ID__c =: invitationID];
            invitationIDIBRoleID = roleForId.id;
            roleRejected= roleForId;// added newly for DAS
            }
        }
         if(invitationIDIBRoleID != null )
        {
            IB_Role__c roleForId = [Select id,IB_Role_Name__c,IB_Role_Name_es__c,IB_Role_Name_fr__c,Status__c from IB_Role__c where id =: invitationIDIBRoleID];
            invitationIDIBRoleID = roleForId.id;
            roleRejected= roleForId;// added newly for DAS
            
        }
        
             
        if(invitationContact.User_Language__c == null || invitationContact.User_Language__c == 'en_US')
            body = 'Dear '+invitationContact.Name+' you have chosen to reject the role invitation for the role of '+roleRejected.IB_Role_Name__c+' at '+ invitationContact.Account__c +'. If you selected this option accidentally, please reach out to your Programme Coordinator who will be able to issue you with a new invite.';
        else if (invitationContact.User_Language__c == 'fr')
            body = 'À l’attention de '+invitationContact.Name+' Vous avez refusé l’invitation pour le rôle de '+roleRejected.IB_Role_Name_fr__c+ 'dans l’établissement '+invitationContact.Account__c +'. Si vous avez sélectionné cette option par erreur, veuillez contacter votre coordonnateur ou coordonnatrice de programme qui pourra vous envoyer une nouvelle invitation.';
        else if (invitationContact.User_Language__c == 'es')
            body = 'Estimado(a) Sr(a). '+invitationContact.Name+' Ha decidido rechazar la invitación al rol de '+roleRejected.IB_Role_Name_es__c+ 'en el '+invitationContact.Account__c +'. Si seleccionó esta opción por error, comuníquese con su coordinador(a) del programa, quien podrá enviarle una nueva invitación.';
        
        
        
        
    }
    //End
    
    //This code is added as a part of ADASUS05 of Admin Assistant Project on 11/2/2021
    //Start 
    public void removeRecord() 
    {
        system.debug('removeRecord*****');
        try{
            docToRemove = [SELECT Id,Account_Id_Formula__c,IB_Role_Name__c,IB_Account__r.Name,IB_Contact__r.name, Programme_Selection__c,Email__c,IB_Contact__c,Programme_Coordinator_First_Name__c,IB_Account__c, IB_Contact__r.User_Language__c, IB_Contact__r.Email, Name, Status__c, IB_Programme_New__c, Programme_Coordinator_Email__c
                           FROM IB_Role__c
                           WHERE Id =: invitationIDIBRoleID];
            if(docToRemove != null)
            {
                if(docToRemove.Status__c == 'Invited')
                {
                    docToRemove.Status__c = 'Declined';
                    If(!Test.isRunningTest())
                        update docToRemove;   
                    
                    system.debug('docToRemove***'+docToRemove);
                    system.debug('userLanguage***'+userLanguage);
                    if(docToRemove.IB_Role_Name__c == 'Chief Invigilator'){
                        sendEmailToProgrameCoordinator(docToRemove, userLanguage); 
                    }
                }
            } 
            
            
        }
        catch(exception exp){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.IBENPortal_shared_Error));    
        }
    }
    //End
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
    
    public void sendEmailToProgrameCoordinator(IB_Role__c roleRejected, String userLanguage){
        
       
        STring roleName= roleRejected.IB_Role_Name__c;
        String invitedContactEmail = roleRejected.Email__c;
        String programmeName= roleRejected.Programme_Selection__c;
        String schoolId= roleRejected.IB_Account__c;
        String confirmedPC='Programme Coordinator';
        String developerName;
        String programmeCoordinatorEmail;
        
        List<IB_Role__c> programmeCoordinatorForRole=[select id,Email__c ,IB_Contact__r.name from IB_Role__c where IB_Account__c=:schoolId and 
                                                      Programme_Selection__c=:programmeName and IB_Role_Name__c=: confirmedPC   ];
        if(programmeCoordinatorForRole!= null)
         programmeCoordinatorEmail= programmeCoordinatorForRole[0].Email__c;
        
        // Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ib.salesforceno-reply@ibo.org'];	//myschool-noreply@ibo.org
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        if(userLanguage=='fr'){
            developerName = 'PIMS_InvitedRoleRejectedForCI_Body_fr';
        }else if(userLanguage=='es'){
            developerName = 'PIMS_InvitedRoleRejectedForCI_Body_es';
        }else{
            developerName = 'PIMS_InvitedRoleRejectedForCI_Body';
        }
        
        EmailTemplate template;  
        try {
            template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
        } catch (Exception e) {
            
        }
        
        
        String plainSubject= template.Subject;
         plainSubject = plainSubject.replace('[role Name]', roleName);
        String[] toAddresses = new String[] { programmeCoordinatorEmail};//invitedContactEmail
        mail.setToAddresses(toAddresses);
        mail.setSubject(plainSubject);
        String plainBody = template.Body;
        plainBody = plainBody.replace('[school Name]', roleRejected.IB_Account__r.Name);
        plainBody = plainBody.replace('[Chief Invigilator Name]', roleRejected.IB_Contact__r.name);
        plainBody= plainBody.replace('[Programme Coordinator]', programmeCoordinatorForRole[0].IB_Contact__r.name);
       
        if(roleName != null){
            plainBody = plainBody.replace('[role Name]', roleName);
        } 
        mail.setPlainTextBody(plainBody);
        
        system.debug('mail***'+mail);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail });
        
        
    }
    
}