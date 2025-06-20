public class IB_NewCIRoleAdded {
    public static List<IB_Role__c> programmeCoordinatorUser;
    public static Boolean roleDeleted= false;
    public static void withdrawTheUserWhoRequestedCIRole( List<IB_Role__c> ibRolesList)
    {
        Set<Id> schoolIds= new Set<Id>();
        for(IB_Role__c ibRole: ibRolesList){
            schoolIds.add(ibRole.IB_Account__c);
        }
        
     /**   List<IB_Role__c> ciRolesListConfirmed=[Select id,name,Programme_Selection__c, IB_Account__c, Status__c ,IB_Role_Name__c from 
                                               IB_Role__c where IB_Role_Name__c='Chief Invigilator' and 
                                               Status__c ='Confirmed' and Disable_CI_Role__c != true and IB_Account__c in: schoolIds] ;**/
        
        
       
        
        system.debug('schoolIds**'+schoolIds);
        /**List<IB_Role__c> oldCIRolesConfirmed=[Select id ,name,Programme_Selection__c,IB_Contact__r.User_Language__c, IB_Role_Name__c,Email__c, IB_Account__r.Name,IB_Contact__r.Name from 
                                              IB_Role__c where IB_Role_Name__c='Chief Invigilator' and 
                                              Status__c ='Withdrawn' and Disable_CI_Role__c = true and 
                                              IB_Account__c in:schoolIds limit 1];**/
        
        if(!ibRolesList.isEmpty()){
          programmeCoordinatorUser =[Select id ,name,Programme_Selection__c,IB_Contact__r.User_Language__c, IB_Role_Name__c,Email__c, IB_Account__r.Name,IB_Contact__r.Name from 
                                                   IB_Role__c where IB_Role_Name__c='Programme Coordinator' and 
                                                   Status__c ='Confirmed'and Programme_Selection__c =: ibRolesList[0].Programme_Selection__c and 
                                                   IB_Account__c in:schoolIds limit 1];
            
            
             roleDeleted= true;
           
            
           
        }
        
        
        
        if(roleDeleted == true){
            system.debug('programmeCoordinatorUser.isEmpty()**'+!programmeCoordinatorUser.isEmpty());

            if(!programmeCoordinatorUser.isEmpty() ){
            sendEmailToPO(programmeCoordinatorUser[0], ibRolesList[0]);
            }
            if(!ibRolesList.isEmpty() ){
            sendEmailToCIUserWhoWantsWithdrawal(ibRolesList[0]);
            }
            
        }
        
        
    }
    
    public static void sendEmailToPO(IB_Role__c programmeCoordinatorUser, IB_Role__c oldCIRolesConfirmed){ //PIMS_CIWithdrawalBy_PO
       
         // Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        String userLanguage;
        String developerName;
        if( programmeCoordinatorUser.IB_Contact__r.User_Language__c =='fr'){
            developerName = 'PIMS_CIWithdrawalBy_PO_fr';
            
        }else if(programmeCoordinatorUser.IB_Contact__r.User_Language__c == 'es'){
            developerName = 'PIMS_CIWithdrawalBy_PO_es';
            
        }else{
            developerName = 'PIMS_CIWithdrawalBy_PO';
        }
        
        EmailTemplate template;  
        try {
            template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
        } catch (Exception e) {
            
        }
        
        
        String plainSubject= template.Subject;
        plainSubject= plainSubject.replace('[PC]',programmeCoordinatorUser.IB_Contact__r.Name );
        plainSubject= plainSubject.replace('[roleName]',oldCIRolesConfirmed.IB_Role_Name__c );
        
        String[] toAddresses = new String[] {programmeCoordinatorUser.Email__c};
        mail.setToAddresses(toAddresses);
        mail.setSubject(plainSubject);
        String plainBody = template.Body;
        plainBody = plainBody.replace('[school Name]', programmeCoordinatorUser.IB_Account__r.Name);
        plainBody = plainBody.replace('[PC]', programmeCoordinatorUser.IB_Contact__r.Name);
        plainBody= plainBody.replace('[roleName]',oldCIRolesConfirmed.IB_Role_Name__c );
        mail.setPlainTextBody(plainBody);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    public static void  sendEmailToCIUserWhoWantsWithdrawal(IB_Role__c withdrawalCIRole){
        
        // Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
        if (owea.size()>0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        String userLanguage;
        String developerName;
        if( withdrawalCIRole.IB_Contact__r.User_Language__c =='fr'){
            developerName = 'PIMS_CIWithdrawal_Accepted_fr';

            
        }else if(withdrawalCIRole.IB_Contact__r.User_Language__c == 'es'){
            developerName = 'PIMS_CIWithdrawal_Accepted_es';

            
        }else{
            developerName = 'PIMS_CIWithdrawal_Accepted';
        }
        
        EmailTemplate template;  
        try {
            template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
        } catch (Exception e) {
            
        }
        
        
        String plainSubject= template.Subject;
        plainSubject= plainSubject.replace('[role Name]',withdrawalCIRole.IB_Role_Name__c );
        String[] toAddresses = new String[] {withdrawalCIRole.Email__c};
        mail.setToAddresses(toAddresses);
        mail.setSubject(plainSubject);
        String plainBody = template.Body;
        plainBody = plainBody.replace('[School Name]', withdrawalCIRole.IB_Account__r.Name);
        plainBody= plainBody.replace('[role Name]',withdrawalCIRole.IB_Role_Name__c );
        plainBody = plainBody.replace('[CI Name]', withdrawalCIRole.IB_Contact__r.Name);
        
        mail.setPlainTextBody(plainBody);
        
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail });
        
    }
}