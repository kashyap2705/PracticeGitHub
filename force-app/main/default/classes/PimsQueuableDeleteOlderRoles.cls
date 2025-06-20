/*** Author : - Kashyap
*  Decsription :- This class is to delete invited roles which are older than 90 days in invited status and 
*   				trigger email to invitee contact and programm coordinator of that role saying contact/role is deleted
* 
* 
* 
* 
* ***/

public class PimsQueuableDeleteOlderRoles implements Queueable {
    public set<Id> roleIds= new Set<Id>();
    public set<Id> roleAccountIds= new Set<Id>();
    public List<IB_Role__c> invitedRolesList = new List<IB_Role__c>();
    public set<Id> contactIds= new Set<Id>();
    public String roleNames= '(\'Admin Assistant\' , \'Billing Contact\' , \'Exam Contact\' , \'Head of School\' , \'Programme Coordinator\' , \'Chief Invigilator\' )';
    public String acceptedStatus = '(\'Invited\' , \'Declined\')';
    public static List<Messaging.SingleEmailMessage> listEmails = new List<Messaging.SingleEmailMessage>();
    public static Map<Id,List<IB_Role__c>> confirmedProgrameCoorddinatorMap = new Map<Id,List<IB_Role__c>>();
    public static Map<String,IB_Role__c> confirmedProgrameCoorddinatorMap1 = new Map<String,IB_Role__c>();
    public static OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
    public static EmailTemplate template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='PIMS_Batch_WithDrawalEmail_Body'];
     
    public void execute(QueueableContext context) {
        
       String query= 'select id,IB_Contact__r.AccountId,IB_Contact__r.name,name,IB_Role_Name__c,IB_Contact__c,IB_Contact__r.Email,Programme_Type__c,IB_Account__c,IB_Account__r.Name,IB_Programme_New__c from IB_Role__c WHERE Status__c in '+ acceptedStatus +
         ' AND IB_Role_Name__c in '+roleNames+' AND createddate < N_DAYS_AGO :'+ Label.Role_withdrawn_days +' ORDER BY CreatedDate DESC limit 500' ;   
          
        //String query= 'select id,IB_Contact__r.AccountId,IB_Contact__r.name,name,IB_Role_Name__c,IB_Contact__c,IB_Contact__r.Email,Programme_Type__c,IB_Account__c,IB_Account__r.Name,IB_Programme_New__c from IB_Role__c WHERE Status__c in '+ acceptedStatus +
        //      ' AND IB_Role_Name__c in '+roleNames+' AND createddate ='+ 'today' +' ORDER BY CreatedDate DESC limit 500' ;   
        
        List<IB_Role__c> ibRolesList= Database.Query(query);
        
        system.debug('ibRolesList**'+ibRolesList);
        
       for( IB_Role__c role:ibRolesList ){
            roleAccountIds.add(role.IB_Contact__r.AccountId);
        }
        
        List<IB_Role__c> confirmedProgrammCoordinator=[select id,IB_Contact__r.AccountId,IB_Contact__c,IB_Programme_New__c,IB_Contact__r.Name,IB_Role_Name__c ,IB_Account__c,Email__c from IB_Role__c 
                                                     where 
                                                     IB_Account__c in : roleAccountIds
                                                     and 
                                                     (IB_Role_Name__c ='Programme Coordinator') and Status__c= 'Confirmed' 
                                                    ];
        system.debug('confirmedProgrammCoordinator**'+confirmedProgrammCoordinator);
         system.debug('roleAccountIds**'+roleAccountIds);
        
        
        for(IB_Role__c role: confirmedProgrammCoordinator)
        {
           confirmedProgrameCoorddinatorMap1.put(role.IB_Account__c+''+role.IB_Programme_New__c, role);
        }
        system.debug('confirmedProgrameCoorddinatorMap1**'+confirmedProgrameCoorddinatorMap1);
        for( IB_Role__c role:ibRolesList ){
            roleIds.add(role.Id);
            invitedRolesList.add(role);
            contactIds.add(role.IB_Contact__c);
           
        }
        
        List<IB_Referee_Feedback__c> ibRefereeFeedbackList= [select id,name, My_Role__c from IB_Referee_Feedback__c where My_Role__c in: roleIds];
        Map<id,User> userContactMap= new Map<id,User>();
        List<Id> deleteContactIds = new List<Id>();
       
        for(User contactUser:[select id,contactId from User where contactId!='' and contactId IN:contactIds ] ){
            userContactMap.put(contactUser.contactId,contactUser);
        }
        
        for(Id contactId : contactIds) {
            if(!userContactMap.containsKey(contactId)){
                deleteContactIds.add(contactId);
            }
        }
        if(!ibRefereeFeedbackList.isEmpty())
        {
            Database.delete(ibRefereeFeedbackList, false);
        }
        if(!invitedRolesList.isEmpty())
        {
            Database.delete(invitedRolesList, false); 
        }
        if(!deleteContactIds.isEmpty()){
            Database.delete(deleteContactIds, false);
        }
        
        List<IB_Role__c> nonDeletedIBRoles=[select id from IB_Role__c where IB_Role__c in: roleIds ];
        if(nonDeletedIBRoles.size() > 0)
        {
            
            for(IB_Role__c role: nonDeletedIBRoles)
            {
               ibRolesList.remove(ibRolesList.indexOf(role));
            }
            
        }
        
         system.debug('ibRolesList before sending email**'+ibRolesList);
        if(!ibRolesList.isEmpty()){
            for(IB_Role__c role: ibRolesList )
            {
                if(role.IB_Contact__r.Email!='' )
                {
                    sendBatchWithDrawalEmail(role);
                }
            } 
        }
        
       
        if(!listEmails.isEmpty()){
            Messaging.sendEmail(listEmails); 
        }
    }
    
    @testvisible 
    public static void sendBatchWithDrawalEmail(IB_Role__c roleForEmail) {
         system.debug('sendBatchWithDrawalEmail**'+roleForEmail);
         String contactForEmail = roleForEmail.IB_Contact__r.Email;
        String contactForName = roleForEmail.IB_Contact__r.Name;
        List<IB_Role__c> confirmedCoordinators;
        IB_Role__c autoWithDrawalContact;
        
        if(confirmedProgrameCoorddinatorMap1.containsKey(roleForEmail.IB_Account__c+''+roleForEmail.IB_Programme_New__c))   
        {
            autoWithDrawalContact = confirmedProgrameCoorddinatorMap1.get(roleForEmail.IB_Account__c+''+roleForEmail.IB_Programme_New__c);
        }
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String developerName;
        string rolename;
        string programme;
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        if(roleForEmail != null){
            rolename = roleForEmail.IB_Role_Name__c;
            programme = roleForEmail.Programme_Type__c;
        }
        try{
            String[] toAddresses;
            String[] ccAddresses;
            if(contactForEmail != null)
            {
                toAddresses = new String[] {contactForEmail };
                    mail.setToAddresses(toAddresses);
            }
            if(autoWithDrawalContact!= null && autoWithDrawalContact.Email__c != null){
                ccAddresses = new String[] {autoWithDrawalContact.Email__c};          
                    mail.setCcAddresses(ccAddresses);
            }
            String plainSubject= template.Subject;
            plainSubject= plainSubject.replace('[Role Name] ',roleForEmail.IB_Role_Name__c );
            plainSubject= plainSubject.replace('[Name of School] ',roleForEmail.IB_Account__r.Name);
            mail.setSubject(plainSubject);
            String plainBody = template.Body;
            plainBody = plainBody.replace('[Last Name]', contactForName);
            if(autoWithDrawalContact!= null && autoWithDrawalContact.IB_Contact__r.Name != null){
                plainBody= plainBody.replace('[Programme Coordinator]', autoWithDrawalContact.IB_Contact__r.Name);
            }
            if(roleForEmail != null){
                plainBody = plainBody.replace('[Role Name]', roleForEmail.IB_Role_Name__c);
            } 
            mail.setPlainTextBody(plainBody);
        }
        catch(exception e)
        {
            system.debug('excep'+e+'Lno**'+e.getLineNumber()+'** Casue**'+e.getCause()+'*** message**'+e.getMessage());
        }
        
        try{
            listEmails.add(mail);
        }catch(exception e){
             system.debug('excep'+e+'Lno**'+e.getLineNumber()+'** Casue**'+e.getCause()+'*** message**'+e.getMessage());
        }
    }
}