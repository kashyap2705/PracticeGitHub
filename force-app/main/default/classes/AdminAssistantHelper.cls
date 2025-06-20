public class AdminAssistantHelper {
    
    //This code is added as a part of ADASUS04 of Admin Assistant Project on 11/2/2021 by Umair Mukhtar
    //Start
    public static void sendEmailToADASReminder(String urlAccept, String urlReject, IB_Role__c roleForEmail) {
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        } 
        
        try{
            String toEmail = roleforEmail.IB_Contact__r.Email;
            
            String sub,body,lang;
            Sub=body='';
            //lang=temprol.IB_Contact__r.User_Language__c;
            lang=UserInfo.getLanguage();
            
if(lang=='fr' && roleForEmail.IB_Role_Name__c =='Surveillant principal ou surveillante principale') {
Sub = 'Mon IB – Invitation pour le rôle de' + roleforEmail.IB_Role_Name_fr__c + '– RAPPEL';
body = 'À l’attention de ' + roleForEmail.Contact_name__c+ ',<br></br> <br></br> Madame/Monsieur, <br></br> <br></br> Le coordonnateur ou la coordonnatrice de programme de votre établissement vous a récemment demandé de mettre à jour votre compte pour le rôle de  '+roleforEmail.IB_Role_Name_fr__c+'  au sein de l’établissement '+roleForEmail.Account_Name__c+'.  <br></br><br></br> Veuillez cliquer sur l’un des boutons ci-dessous pour indiquer votre réponse.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACCEPTER</button></a> Si vous cliquez sur Accepter, vous serez dirigé(e) vers la page de connexion et pourrez mettre à jour votre compte.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">REFUSER</button></a> Si hace clic en Rechazar no tendrá que hacer nada más y comunicaremos su decisión a su.  <br></br> <br></br> Si vous avez la moindre question concernant cette invitation, veuillez contacter le coordonnateur ou la coordonnatrice de programme de votre établissement.<br></br> <br></br> Salutations distinguées,<br></br> <br></br> L’administrateur du système Mon IB'; 
} else if (lang=='es' &&  roleForEmail.IB_Role_Name__c =='Supervisor/a jefe') {
Sub = 'RECORDATORIO. Invitación a rol de Mi IB:'+ roleforEmail.IB_Role_Name_es__c;
body = 'Estimado(a)' +roleForEmail.Contact_name__c+',<br></br> <br></br> Hace poco, su coordinador(a) del programa le pidió que completara la configuración de su cuenta correspondiente al rol de '+roleforEmail.IB_Role_Name_es__c+' en  '+roleForEmail.Account_Name__c+'.  <br></br> <br></br> A continuación verá dos botones para indicar si acepta o rechaza el rol.<br></br> <br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACEPTAR</button></a> Si hace clic en Aceptar se le redirigirá a la página de inicio de sesión para que termine de configurar su cuenta.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">RECHAZAR</button></a> Si hace clic en Rechazar no tendrá que hacer nada más y comunicaremos su decisión a su.  <br></br> <br></br> Si tiene alguna pregunta sobre la invitación, no dude en escribir a su coordinador(a).<br></br> <br></br> Atentamente,<br></br> <br></br> El administrador de Mi IBn';   
}
else
{
            sub = 'MyIB - ' +roleForEmail.IB_Role_Name__c+ ' Role Invitation - REMINDER';
            body = 'Dear '+roleForEmail.Contact_name__c+',<br></br> <br></br> Your school Programme Coordinator recently invited you to complete your account setup for the role of '+roleForEmail.IB_Role_Name__c+' at '+roleForEmail.Account_Name__c+'.  <br></br><br></br> Please use one of the buttons below to indicate your response.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACCEPT</button></a> If you select \'Accept\' you will be directed to login and complete your account setup.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">REJECT</button></a> If you select \'Reject\' no further action will be required and the person who sent the invite will be notified of your decision . <br></br> <br></br>If you have any questions regarding your invitation please contact your school Programme Coordinator.<br></br> <br></br> Thank you,<br></br> <br></br> My IB Admin';                    
              }
            
            String[] toAddresses = new String[] {toEmail};
                mail.setToAddresses(toAddresses);
            mail.subject=sub;
            mail.setHtmlBody(body);
            mail.setUseSignature(false);
            messages.add(mail);
            Messaging.sendEmail(messages);
        }
        catch(Exception exp)
        {
            system.debug('Excep'+exp);
        }
    }
    //End
    
    //This code is added as a part of ADASUS01 and ADASUS05 of Admin Assistant Project on 11/2/2021 by Umair Mukhtar
    //Start 
    public static void sendEmailToADASNewInvitee(String urlAccept, String urlReject, Ib_Role__c roleforEmail) {
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        } 
        
        try{
            String toEmail = roleforEmail.IB_Contact__r.Email;
            String sub,body,lang;
            sub=body='';
              lang=UserInfo.getLanguage();

if(lang=='fr' && roleForEmail.IB_Role_Name__c =='Surveillant principal ou surveillante principale') {
Sub = 'Mon IB – Invitation pour le rôle de ' + roleforEmail.IB_Role_Name_fr__c + 'Réponse requise';
body = 'À l’attention de ' + roleForEmail.Contact_name__c+' Madame/Monsieur,<br></br> <br></br>Le coordonnateur ou la coordonnatrice de programme de votre établissement vous a récemment demandé de mettre à jour votre compte pour le rôle de  '+roleforEmail.IB_Role_Name_fr__c+'  au sein de l’établissement '+roleForEmail.Account_Name__c+'.  <br></br><br></br> Veuillez cliquer sur l’un des boutons ci-dessous pour indiquer votre réponse.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACCEPTER</button></a> Si vous cliquez sur \'Accepter\', la page de connexion s’affichera et vous pourrez finaliser la création de votre compte.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">REFUSER</button></a> Si vous cliquez sur \'Refuser\', aucune autre action ne sera requise de votre part. Le coordonnateur ou la coordonnatrice et le ou la chef d’établissement seront informés de votre décision. <br></br <br></br> Si vous avez la moindre question concernant cette invitation, veuillez contacter le coordonnateur ou la coordonnatrice de programme de votre établissement.<br></br>  <br></br> Salutations distinguées,<br></br> <br></br> L’administrateur du système Mon IB'; 
} else if (lang=='es' &&  roleForEmail.IB_Role_Name__c =='Supervisor/a jefe' ) {

Sub = 'Indique su respuesta a la invitación al rol de ' + roleforEmail.IB_Role_Name_es__c + 'en Mi IB';
body = 'Estimado(a) Sr(a) ' + roleForEmail.Contact_name__c+',<br></br> <br></br> Su coordinador(a) del programa le pidió que completara la configuración de su cuenta correspondiente al rol de  '+roleforEmail.IB_Role_Name_es__c+' en el  '+roleForEmail.Account_Name__c+'.  <br></br><br></br> A continuación verá dos botones para indicar si acepta o rechaza el rol.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACEPTAR</button></a> Si hace clic en \'Aceptar\' se le redirigirá a la página de inicio de sesión para que termine de configurar su cuenta.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">RECHAZAR</button></a> Si hace clic en \'Rechazar\' no tendrá que hacer nada más y comunicaremos su decisión a su  <br></br><br></br> Si tiene alguna pregunta sobre la invitación, no dude en escribir a su coordinador(a).<br></br> <br></br>Atentamente,<br></br> <br></br> El administrador de Mi IB';   
}
else
{ 
            Sub = 'MyIB - ' +roleForEmail.IB_Role_Name__c + ' Role Invitation- Please indicate your response';
            body = 'Dear '+roleForEmail.Contact_name__c+',<br></br> <br></br> Your school Programme Coordinator has invited you to complete your account setup for the role of '+roleForEmail.IB_Role_Name__c+' at '+roleForEmail.Account_Name__c+'.  <br></br><br></br> Please use one of the buttons below to indicate your response.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACCEPT</button></a> If you select \'Accept\' you will be directed to login and complete your account setup.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">REJECT</button></a> If you select \'Reject\' no further action will be required and the person who sent the invite will be notified of your decision .  <br></br> <br></br>If you have any questions regarding your invitation please contact your school Programme Coordinator.<br></br> <br></br> Thank you,<br></br> <br></br> My IB Admin';                    
            }
            
            String[] toAddresses = new String[] {toEmail};
                mail.setToAddresses(toAddresses);
            mail.subject=sub;
            mail.setHtmlBody(Body);
            mail.setUseSignature(false);
            messages.add(mail);
            Messaging.sendEmail(messages);
        }
        catch(Exception exp)
        {
            system.debug('Excep'+exp);
        }
    } 
    //End
    
    public  static void SendEmailToPCADASAccept(Ib_Role__c role, Contact invitationContact) {
        User contactOwner = [Select id, FirstName, LastName, Name , Email,LanguageLocaleKey from User where id=: invitationContact.CreatedById Limit 1];
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        } 
        
        try{
            String toEmail = contactOwner.Email;
            String sub,body;
            sub=body='';
            if(contactOwner.LanguageLocaleKey =='fr') {
                Sub = 'Mon IB – Invitation pour le rôle de ' + role.IB_Role_Name_fr__c + '- Acceptée';
                body = 'À l’attention de '+contactOwner.Name+', <br></br><br></br> Madame/Monsieur, <br></br><br></br> Votre invitation pour le rôle de '+role.IB_Role_Name_fr__c+' au sein de l’établissement '+role.Account_Name__c+' a été acceptée par '+invitationContact.Name+'. <br></br>Aucune action supplémentaire de votre part n’est requise. Le rôle sera automatiquement confirmé et l’accès aux applications et aux ressources de l’IB sera également automatiquement accordé.  <br></br><br></br> Salutations distinguées,<br></br> <br></br> L’administrateur du système Mon IB'; 
            }
            else if(contactOwner.LanguageLocaleKey =='es') {
                Sub = 'La invitación al rol de ' + role.IB_Role_Name_es__c + ' en Mi IB fue - Aceptada';
                body = 'Estimado(a) Sr(a).'+contactOwner.Name+',<br></br><br></br>' +invitationContact.Name+'  ha aceptado su invitación al rol de '+role.IB_Role_Name_es__c+' en el  '+role.Account_Name__c+'. Por el momento no es necesario que realice ninguna acción, ya que el rol se confirmará automáticamente y se dará acceso de inmediato a los recursos y aplicaciones del IB.  <br></br><br></br> Atentamente,<br></br> <br></br> El administrador de Mi IB'; 
            }
            else{
                Sub = 'MyIB - ' + role.IB_Role_Name__c +' Role Invitation - Accepted';
                body = 'Dear '+contactOwner.Name+', <br></br> <br></br>Your invite to '+invitationContact.Name+' for the role of '+role.IB_Role_Name__c+' at '+role.Account_Name__c+' has been accepted.  <br></br><br></br>You do not need to take any further action at this time as the role will be automatically confirmed and access to IB applications and resources will be automatically granted.<br></br> <br></br>Thank you,<br></br> <br></br> My IB Admin'; 
            }
            String[] toAddresses = new String[] {toEmail};
            mail.setToAddresses(toAddresses);
            mail.subject=sub;
            mail.setHtmlBody(body);
            mail.setUseSignature(false);
            messages.add(mail);
            Messaging.sendEmail(messages);
        }
        catch(Exception exp)
        {
            system.debug('Excep'+exp);
        }
    }
    
    public static void sendEmailToAdminAssistantforInvitation(List<IB_Role__c> rolesId) {
        
        System.debug('Umair ID '+rolesId);
        User contactOwner = [Select id, FirstName, LastName, Name , Email,LanguageLocaleKey from User where id=: UserInfo.getUserId() Limit 1];
        List<IB_Role__c> rolesList = [Select id,Account_Name__c,Contact_name__c,IB_Contact__r.User_Language__c, Programme_Selection__c,Email__c,IB_Contact__r.Email from IB_Role__c where id IN :rolesId];
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        
        
        try {
            
            for (IB_Role__c role : rolesList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if ( owea.size() > 0 ) {       
                mail.setOrgWideEmailAddressId(owea.get(0).Id); 
              }
                System.debug('Umair role = '+ role.Contact_name__c + '  ====  '+role.IB_Contact__r.Email);
                String toEmail = role.IB_Contact__r.Email;
                String sub,body;
                sub=body='';
                if(role.IB_Contact__r.User_Language__c == 'fr')
                {
                    sub = 'Vous avez été nominé pour le poste Adjoint administratif chez ' + role.Account_Name__c;
          body = 'À l’attention de '+ role.Contact_name__c +', <br></br> <br></br>Vous avez été nommé par ' + contactOwner.Name + ' assumer le rôle Adjoint administratif au sein du '+ role.Programme_Selection__c +' à votre école.<br></br> <br></br>Si vous avez des questions concernant cette notification ou le rôle, veuillez contacter ' +  contactOwner.Name + '.<br><br/>Salutations distinguées,<br></br> <br></br> L’administrateur du système Mon IB';
                }
                else if (role.IB_Contact__r.User_Language__c == 'es')
                {
                    sub = 'Usted ha sido nominado para el puesto de Asistente Administrativo en ' + role.Account_Name__c;
          body = 'Estimado(a) Sr(a). '+ role.Contact_name__c +', <br></br> <br></br>has sido nominado por ' + contactOwner.Name + ' para asumir el papel de Asistente Administrativo dentro de la '+ role.Programme_Selection__c +' en tu escuela.<br></br> <br></br>Si tiene alguna pregunta sobre esta notificación o el rol, comuníquese con ' +  contactOwner.Name + '.<br><br/>Atentamente,<br></br> <br></br> El administrador de Mi IB';
                }
                else
                {
                sub = 'You have been nominated for the role of Admin Assistant at ' + role.Account_Name__c;
                body = 'Dear '+ role.Contact_name__c +', <br></br> <br></br>You have been nominated by ' + contactOwner.Name + ' to undertake the role of Admin Assistant within the '+ role.Programme_Selection__c +' at your school.<br></br> <br></br>If you have any questions relating to this notification or the role, please contact ' +  contactOwner.Name + '.<br><br/>Thank You<br><br/>My IB Admin';
                }
                System.debug('Umair mail 1'+ mail);
                String[] toAddresses = new String[] {toEmail};
                mail.setToAddresses(toAddresses);
                mail.subject=sub;
                mail.setHtmlBody(body);
                mail.setUseSignature(false);
                messages.add(mail);
                System.debug('Umair mail 2'+ mail);
                
            }
            
            if (!Test.isRunningTest()) {
                System.debug('Umair Apple : '+messages);
                Messaging.sendEmail(messages);
                
            }
            
        } catch(Exception exp) {
            
            system.debug('Excep'+exp);
            
        }
        
    }
    
}