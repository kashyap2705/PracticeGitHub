/*** Author : - Kashyap
*  Decsription :- This class is to send reminder mail to contacts whose roles is in invited status even after 15 or 30 or 60 days 
* 
* 
* 
* ***/

global class PimsBatchReminderInvitedRoles implements Database.Batchable<sObject>,Database.Stateful {
    
    public String roleNames= '(\'Admin Assistant\' , \'Billing Contact\' , \'Exam Contact\' , \'Head of School\' , \'Programme Coordinator\' ,\'Chief Invigilator\' )';
    public static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
    public static EmailTemplate template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='PIMS_Send_Email_Reminder_Body'];
    public static List<Messaging.SingleEmailMessage> listEmails = new List<Messaging.SingleEmailMessage>();
    public static String headUrl= Test.isRunningTest() ? 'test.ibo.org' : [SELECT id,DomainType,HttpsOption,Domain FROM domain where HttpsOption =: Label.DomainName limit 1].Domain;
    public static String baseUrl='https://'+headUrl+'/ibportal/IBPortalTriagePage?inviteid='; 
    public static String curUrl = '/ibportal/IBPortalTriagePage?inviteid=';
    public static String curUrl2 = '/ibportal/roleRejectConfirmADAS?inviteid=';
    public List<Id> contactIds= new List<Id>();
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query= 'select id,name,Contact_name__c,Account_Name__c,IB_Role_Name__c,IB_Contact__r.name,IB_Contact__c,IB_Contact__r.Invitation_ID__c,IB_Contact__r.Email,IB_Contact__r.owner.Name,Programme_Type__c,IB_Account__c,IB_Account__r.Name,createddate from IB_Role__c WHERE Status__c = \'Invited\' '+
            ' AND IB_Role_Name__c in'+roleNames+ Label.Date_Query_Condition  + 'ORDER BY CreatedDate DESC' ;
        system.debug('query**'+query);
        return Database.getQueryLocator(query);
    }
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<IB_Role__c> invitedRolesList){
        if(invitedRolesList.size()>0){
            for(IB_Role__c roleObj:invitedRolesList ){
                contactIds.add(roleObj.IB_Contact__c);
                sendEmail(roleObj);
            }
        }
        
        if(!listEmails.isEmpty()){
            Messaging.sendEmail(listEmails); 
        } 
    }
    
    global void finish(Database.BatchableContext BC){
        
        List<Contact> EmailDateTimeUpdateOnContact = [select id,Email_Reminder__c,EmailReminderDateTime__c from contact where id in: contactIds];
        for(Contact c: EmailDateTimeUpdateOnContact)
        {
            c.EmailReminderDateTime__c= Datetime.now();
            c.Email_Reminder__c= Date.today();
         }
        update EmailDateTimeUpdateOnContact;
    }
    
    global static void sendEmail(IB_Role__c roleForEmail)
    {
        String email= roleForEmail.IB_Contact__r.Email;
        String urlAccept ='https://'+headUrl+curUrl+roleForEmail.IB_Contact__r.Invitation_ID__c;
        String urlReject = 'https://'+headUrl+curUrl2+roleForEmail.IB_Contact__r.Invitation_ID__c;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
             mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        if(roleForEmail.IB_Role_Name__c!='Admin Assistant' && roleForEmail.IB_Role_Name__c!='Chief Invigilator'){
            try{
                String[] toAddresses = new String[] {email};
                mail.setToAddresses(toAddresses);
                mail.setUseSignature(false);
                String plainSubject= template.Subject;
                mail.setSubject(plainSubject);
                String plainBody = template.Body;
                 
                if(roleForEmail!= null)
                {
                    plainBody = plainBody.replace('[Date]', (roleForEmail.createddate).date().format());
                    plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
                    plainBody = plainBody.replace('[Last Name]', roleForEmail.IB_Contact__r.name);
                    plainBody = plainBody.replace('[School Name]', roleForEmail.IB_Account__r.Name);
                    plainBody = plainBody.replace('[Programme Name]', roleForEmail.Programme_Type__c);
                    plainBody = plainBody.replace('[Owner Name]', roleForEmail.IB_Contact__r.owner.Name);
                    plainBody = plainBody.replace('[URL]', baseUrl+roleForEmail.IB_Contact__r.Invitation_ID__c);
                }
                mail.setPlainTextBody(plainBody);
            }
            
            catch(exception e)
            {
                system.debug('excep'+e+'lno**'+e.getLineNumber()+'Cause**'+e.getCause());
            }
        }
        if(roleForEmail.IB_Role_Name__c =='Admin Assistant' || roleForEmail.IB_Role_Name__c =='Chief Invigilator')
        {
            try{
                String sub,body,lang;
                Sub=body='';
                sub = 'MyIB - ' +roleForEmail.IB_Role_Name__c+ ' Role Invitation - REMINDER';
                body = 'Dear '+roleForEmail.Contact_name__c+',<br></br> <br></br> Your school Programme Coordinator recently invited you to complete your account setup for the role of '+roleForEmail.IB_Role_Name__c+' at '+roleForEmail.Account_Name__c+'.  <br></br><br></br> Please use one of the buttons below to indicate your response.<br></br><br></br><a href='+urlAccept+'><button style="background:#008CBA;;color:white;padding: 10px 20px">ACCEPT</button></a> If you select \'Accept\' you will be directed to login and complete your account setup.<br></br> <br></br> <a href='+urlReject+'><button style="background:#008CBA;;color:white;padding: 10px 20px">REJECT</button></a> If you select \'Reject\' no further action will be required and the person who sent the invite will be notified of your decision . <br></br> <br></br>If you have any questions regarding your invitation please contact your school Programme Coordinator.<br></br> <br></br> Thank you,<br></br> <br></br> My IB Admin';                    
                String[] toAddresses = new String[] {email};
                mail.setToAddresses(toAddresses);
                mail.subject=sub;
                mail.setHtmlBody(body);
                mail.setUseSignature(false);
                
            }
            catch(Exception exp) {
                system.debug('Excep'+exp);
            }
        }
        
        try{
            listEmails.add(mail);            
        }catch(exception e){
            system.debug('exception at line no**'+e.getLineNumber()+'reason*'+e.getCause()+'In PimsBatchReminderInvitedRoles');
        }
    }
}