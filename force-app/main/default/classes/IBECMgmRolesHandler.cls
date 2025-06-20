/* <h1> IBECMgmRolesHandler </h1>
* This class is created for IBEC Roles 
* This class is part of ECM226
* @version 1.0
* @since   2021-12-26 
*/
public class IBECMgmRolesHandler {
    /**
* This method will send the email to IBEC Admin Users, so that they admin can verify and decline the roles.
* @param List<IB_Role__c>.
* @return N/A.
*/
    
    public void SendEmailtoIBECAdminForApplicant(List<IB_Role__c> roles, list<id> accList)
    {
        
        map<id,IB_Role__c> IBECAdminRoleMap = new map<id,IB_Role__c>();//maps account ids to         
        for(IB_Role__c adminrole : [select Contact_name__c,ContactUserLanguage__c,IB_Contact__r.FirstName,IB_Contact__r.LastName,ContactInfo_Emailvalue__c,Contact_Information_Email__c,IB_Account__c from Ib_role__c where IB_Account__c IN: acclist and IB_Role_Name__c='IBEC University Administrator' and Status__c='Confirmed']){
            IBECAdminRoleMap.put(adminrole.IB_Account__c,adminrole);
        }
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>() ;
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        for(IB_Role__c r:roles)
        {
            List<IB_Role__c> IBECAdminRole = new List<IB_Role__c>();
            if(IBECAdminRoleMap.get(r.IB_Account__c)!=null){
                IBECAdminRole.add(IBECAdminRoleMap.get(r.IB_Account__c));
                system.debug('IBECAdminRole '+IBECAdminRole);
            }
            
            IF( IBECAdminRole.size()>0)
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] { IBECAdminRole[0].ContactInfo_Emailvalue__c };
                    system.debug('Email '+IBECAdminRole[0].ContactInfo_Emailvalue__c);
                
                    if ( owea.size() > 0 )
                {
                    Message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                String Sub,body;
                Sub=body='';
                if(r.ContactUserLanguage__c=='fr')
                {
                    Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c;                    
                    body='À l’attention de '+IBECAdminRole[0].Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’institut, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon institut.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';                    
                }     
                else if(r.ContactUserLanguage__c=='es')
                {
                    Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+' en Mi IB';                    
                    body='Estimado(a) Sr(a). '+IBECAdminRole[0].Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para institución en Mi institución.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB';                    
                }
                else 
                {                    
                    Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                    body='Dear '+IBECAdminRole[0].Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Institute User Roles page in My Institute by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';  
                }
                message.subject = Sub;
                message.setHtmlBody(Body);
                message.setUseSignature(false);
                messages.add(message);   
            }
        }
        
        if(Messages.size()>0 && !Test.isRunningTest())
        {
            system.debug('messages '+messages);
            Messaging.sendEmail(messages);
        }
        
    }
    /**
* This method is responsible to process the Role Applications for IB Institutes
* @param List<IB_Role__c>.
* @return N/A.
*/
    
    public void ProcessIBECRoles(List<IB_Role__c> roles)
    {        
        list<id> AccList=new list<id>();
        boolean hasIBECAdmin=false;
        Set<id>ContactIds=new set<id>();
        for(IB_Role__c rol:roles)
        {
            if(rol.status__c!='Applicant')   
                AccList.add(rol.IB_Account__c);
            ContactIds.add(rol.IB_Contact__c);
        }
        
        list<IB_Role__c> confirmTrans = new list<IB_Role__c>();
        list<IB_Role__c> adRole = new list<IB_Role__c>();
        for(IB_Role__c rol : [select id,status__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,IB_Contact__c,IB_Role_Name__c,Contact_Information_Email__c,Contact_Information_Phone__c from IB_Role__c where
                              IB_Account__c IN:AccList and status__c='Confirmed' and 
                              ((IB_Role_Name__c='IBEC University Administrator' and id not in: roles)) ])
        {
            
            adRole.add(rol);
        }  
        for(IB_Role__c rol:roles)
        {
            if(rol.IB_Role_Name__c=='IBEC University Administrator' && rol.Status__c=='Confirmed')
            {
                hasIBECAdmin=true;
            }
            
        }
        if(adRole.size()>0 && hasIBECAdmin==true)
        {
            
            list<IB_role__c>rolestowithdraw=new list<ib_role__c>();
            for(IB_role__c IBECAdminRolefromList:adRole)
            {
                IBECAdminRolefromList.status__c='Withdrawn';
                ContactIds.add(IBECAdminRolefromList.IB_Contact__c);
                rolestowithdraw.add(IBECAdminRolefromList);
            }
            try{
                update rolestowithdraw;
                if(ContactIds.size()>0)PermissionSetMaintenance.permissionMaintenance(contactIds);
            }
            catch(Exception exp){
                Logger.get().add(exp, LogSeverity.ERROR).publish();
            }
        }
    }
}