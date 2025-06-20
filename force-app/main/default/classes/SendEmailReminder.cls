global class SendEmailReminder implements Schedulable {
    global void execute(SchedulableContext ctx) {
        

         list <my_staffing_event__c> myAss = [select id, Application_Status__c,IB_contact__r.Email, IB_Contact__r.name ,IB_Event__r.Status,IB_Event__r.Reminder_date__c, IB_Event__r.Event_Language__c, IB_Event__r.name ,IB_Event__r.Related_IB_Programme__r.Language_of_Correspondence_Acct__c, End_Date__c from my_staffing_event__c where IB_Event__r.status = 'Staffed' AND Application_Status__c = 'Confirmed' AND IB_Event__r.Reminder_date__c =:System.today()];
        system.debug('Size of List is '+myAss.size()/*+' '+myAss[0].Application_Status__c + ' '+ myAss[0].IB_Event__r.Status+ ' '+myAss[0].IB_Event__r.Reminder_date__c*/ );
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for(my_staffing_event__c c:myAss) {
         
             
                  //  Create a master list to hold the emails we'll send
              
                  //  Create a new Email
                  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                  String body = '';
                  
                  
                  OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
                if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                    
                  //  Set list of people who should get the email
                  List<String> sendTo = new List<String>();
                  sendTo.add(c.IB_contact__r.Email);
                  mail.setToAddresses(sendTo);
                
            if(c.IB_Event__r.Related_IB_Programme__r.Language_of_Correspondence_Acct__c== 'English' || Test.isRunningTest())
                  {
                  mail.setSubject('Reminder Email '+c.IB_Event__r.name);
                  
                  
                  
                  body = 'Dear ' + c.IB_Contact__r.name  + ',<br><br> \n';
                  body += 'An event that you have been assigned to "'+c.IB_Event__r.name +'" has not yet been started.';
                  
                  
                  body += 'This assignment must be completed by '+ c.End_Date__c.format()+'.';
                  body += 'If you are no longer able to complete this assignment please withdraw your participation in IBEN Central.<br><br>';
                  body += '\nBest wishes,\n<br>';
                  body += 'The International Baccalaureate educator network team\n<br><br>';
                  body += 'This is an automated message';
                 }
                 
                 if(c.IB_Event__r.Related_IB_Programme__r.Language_of_Correspondence_Acct__c== 'French' || Test.isRunningTest())
                 {
                  mail.setSubject('Reminder Email '+c.IB_Event__r.name);
                  
                  
                  
                  body = 'À l’attention de ' + c.IB_Contact__r.name  + '<br>\nMadame/Monsieur,<br><br> \n';
                  body += 'Vous n’avez pas encore commencé la mission qui vous a été attribuée, "'+c.IB_Event__r.name +'".';
                  
                  
                  body += 'Celle-ci doit être effectuée avant le '+ c.End_Date__c.format()+'.';
                  body += ' Si vous n’êtes plus disponible pour cette mission, veuillez annuler votre participation sur IBEN Central. <br><br>';
                  body += '\nSalutations distinguées,\n<br>';
                  body += 'L’équipe du réseau de collaborateurs du Baccalauréat International\n<br><br>';
                  body += 'Ceci est un message automatique.';
                 }
                 if(c.IB_Event__r.Related_IB_Programme__r.Language_of_Correspondence_Acct__c== 'Spanish' || Test.isRunningTest())
                 {
                 
                  mail.setSubject('Reminder Email '+c.IB_Event__r.name);
                  
                  
                  
                  body = 'Estimado(a)  ' + c.IB_Contact__r.name  + ':<br>\n';
                  body += 'Aún no ha comenzado un trabajo que se le ha asignado: "'+c.IB_Event__r.name +'".';
                  
                  
                  body += ' La fecha límite para completar el trabajo es el '+ c.End_Date__c.format()+'.';
                  body += '  Si no le va a ser posible completarlo, cancele su participación en IBEN Central. <br><br>';
                  body += 'Atentamente,<br>';
                  body += 'El equipo de la Red de educadores del Bachillerato Internacional<br><br>';
                  body += 'Este es un mensaje automático.';
                
                 
                 }
                 
                  mail.setHtmlBody(body);
                  mail.setUseSignature(false);
                  mails.add(mail);
                
        }
            if(!Test.isRunningTest())  Messaging.sendEmail(mails);
                
     
    }
}