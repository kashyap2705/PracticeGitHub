public class CSM_SendEmailNau {
    public class inputVariableFlow {
        @InvocableVariable
        public String FirstName;
        @InvocableVariable
        public String LastName;
        @InvocableVariable
        public String CaseNumber;
        @InvocableVariable
        public String CaseSubject;
        @InvocableVariable
        public String UserEmail;
      }
    
    private static final OrgWideEmailAddress[] owea = [
    SELECT Id
    FROM OrgWideEmailAddress
    WHERE Address = 'ibcommunities.noreply@ibo.org'
    LIMIT 1
  ];
  @InvocableMethod(label='Send Email to NAU' description='Send email notification to NAU when case is created from IB Answers Portal' category='Case')
    public static void sendSingleEmailNau(List<inputVariableFlow> inputVariableFlow){
        try {
            if (inputVariableFlow != null && !inputVariableFlow.isEmpty()) {
                inputVariableFlow caseDetails = inputVariableFlow.get(0);
                String firstName = caseDetails.FirstName;
                String lastName = caseDetails.LastName;
                String caseNumber = caseDetails.CaseNumber;
                String caseSubject = caseDetails.CaseSubject;
                String caseEmail = caseDetails.UserEmail;
                String htmlContent = '<!DOCTYPE html>'
        + '<html lang="en">'
        + '<head>'
        + '<meta charset="UTF-8">'
        + '<meta name="viewport" content="width=device-width, initial-scale=1.0">'
        + '<title>Support Response</title>'
        + '</head>'
        + '<body>'
        + '<div style="background-color:#cccccc; padding:0px 50px">'
        + '<div style="background-color:#ffffff;padding:10px 20px">'
        + '<p>Hello ' + firstName + ' ' + lastName + ',</p>'
        + '<p>Thank you for getting in touch. We have received your support request and you will hear back from us within the next three business days.</p>'
        + '<p>If your query is more urgent or you would like to speak to us in person, please call us directly. You can find our contact numbers <a href="https://www.ibo.org/contact-the-ib/ask-a-question/">here</a>. Our dedicated support team are on hand to assist you 24 hours a day, 5 days a week.</p>'
        + '<p style="background-color:#d9e2f3;"><strong>Below are the details of your enquiry:</strong></p>'
        + '<p>Please keep a note of your case number below, if you call us this will help us locate your query.</p>'
        + '<ul>'
        + '<li>Case number: ' + caseNumber + '</li>'
        + '<li>Your email Subject: ' + caseSubject + '</li>'
        + '</ul>'
        + '<p style="background-color:#d9e2f3;"><strong>Additional information:</strong></p>'
        + '<p>If you work within an IB World School and have a MyIB account, don’t forget that you can <a href=\'https://ibo.my.site.com/ibportal/IBPortalLogin?lang=en_US\'>log in</a> to see our frequently asked questions in addition to other useful information and updates.</p>'
        + '<p>If you are a parent or student we have created a dedicated page on our website with informative and useful content, you can find the page <a href="https://www.ibo.org/">here</a>.</p>'
        + '<p>Thank you,</p>'
        + '<p>The IB Service & Support team</p>'
        + '<a href=\'https://ibo.org/terms-and-conditions/\'>Terms & Conditions</a>'
        + '<span>-</span>'
        + '<a href=\'https://ibo.org/terms-and-conditions/privacy-policy/\'>Privacy Policy</a>'
        + '<hr style="border:8px solid #d9e2f3;">'
        + '<p>Madame/Monsieur ' + firstName + ' ' + lastName + ',</p>'
        + '<p>Merci d’avoir communiqué avec nous. Nous avons bien reçu votre demande d’assistance et nous y répondrons dans les trois prochains jours ouvrables.</p>'
        + '<p>Si votre demande est urgente ou si vous souhaitez vous entretenir directement avec quelqu’un, n’hésitez pas à nous appeler par téléphone. Vous trouverez les numéros pour nous contacter <a href="https://ibo.org/fr/contact-the-ib/ask-a-question/">ici</a>. L’équipe de notre service d’assistance dédié est là pour vous aider 24 heures sur 24, 5 jours par semaine.</p>'
        + '<p style="background-color:#d9e2f3;"><strong>Vous trouverez ci-dessous les informations à propos de votre demande:</strong></p>'
        + '<p>Veuillez prendre note de votre numéro de référence. Il nous aidera à retrouver votre requête si vous nous appelez par téléphone.</p>'
        + '<ul>'
        + '<li>Numéro de référence : ' + caseNumber + '</li>'
        + '<li>Objet de votre courriel : ' + caseSubject + '</li>'
        + '</ul>'
        + '<p style="background-color:#d9e2f3;"><strong>Informations complémentaires:</strong></p>'
        + '<p>Si vous travaillez dans une école du monde de l’IB et possédez un compte sur Mon IB, n’hésitez pas à vous y <a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin?lang=fr">connecter</a> pour consulter notre foire aux questions, ainsi que d’autres informations et mises à jour utiles.</p>'
        + '<p>Si vous êtes un parent ou un élève, cliquez <a href="https://ibo.org/fr/information-for-parents/">ici</a> pour accéder à une page Web créée à votre intention et qui contient du contenu informatif et utile.</p>'
        + '<p>Salutations distinguées,</p>'
        + '<p>L’équipe du service d’assistance de l’IB</p>'
        + '<a href="https://ibo.org/fr/terms-and-conditions/">Conditions d\'utilisation</a>'
        + '<span>-</span>'
        + '<a href="https://ibo.org/fr/terms-and-conditions/privacy-policy/">Politique de protection des données à caractère personnel de l’IB</a>'
        + '<hr style="border:8px solid #d9e2f3;">'
        + '<p>Estimado(a)' + firstName + ' ' + lastName + ',</p>'
        + '<p>Gracias por utilizar nuestro servicio de asistencia. Hemos recibido su mensaje y le responderemos en un plazo de tres días laborables.</p>'
        + '<p>Si se trata de algo urgente o que prefiere discutir personalmente, puede llamarnos por teléfono. Encontrará los números de contacto <a href="https://ibo.org/es/contact-the-ib/ask-a-question/">aquí</a>. Nuestro equipo de asistencia especializado está a su disposición las 24 horas del día, cinco días a la semana.</p>'
        + '<p style="background-color:#d9e2f3;"><strong>Información detallada sobre su consulta:</strong></p>'
        + '<p>Tome nota del número de referencia de su caso, ya que nos permitirá buscar su consulta si nos llama por teléfono.</p>'
        + '<ul>'
        + '<li>Número de referencia del caso: ' + caseNumber + '</li>'
        + '<li>Asunto del mensaje de correo electrónico: ' + caseSubject + '</li>'
        + '</ul>'
        + '<p style="background-color:#d9e2f3;"><strong>Información adicional:</strong></p>'
        + '<p>Si trabaja en un Colegio del Mundo del IB y tiene una cuenta en Mi IB, no olvide que puede <a href="https://ibo.my.site.com/ibportal/IBPortalLogin?lang=es">iniciar sesión</a> para leer las preguntas frecuentes, obtener más información útil y conocer las novedades.</p>'
        + '<p>Si usted es padre, madre o alumno, en nuestro sitio web encontrará una página exclusiva con contenido útil e informativo. Para visitarla,haga clic <a href="https://www.ibo.org/es/">aquí</a>.</p>'
        + '<p>Muchas gracias,</p>'
        + '<p>El equipo de asistencia del IB</p>'
        + '<a href="https://ibo.org/es/terms-and-conditions/">Condiciones de uso</a>'
        + '<span>-</span>'
        + '<a href="https://ibo.org/es/terms-and-conditions/privacy-policy/">Política de privacidad del IB</a>'
        + '</div>'
        + '</div>'
        + '</body>'
        + '</html>';
    
        List<String> userEmails = new List<String>();
        userEmails.add(caseEmail);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(userEmails);
        if ( owea.size() > 0 ) {
        mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        String subjectKey = 'Your Support request has been received';
        mail.setSubject(subjectKey);
        mail.setHTMLBody(htmlContent);
        mail.setSaveAsActivity(false);
        mail.setUseSignature(false);
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
     }
        } catch (Exception e) {
            Logger.get().add(e, LogSeverity.ERROR).publish();
        }
        
    
}
    
}