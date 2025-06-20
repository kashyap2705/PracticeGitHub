/*******************************************************************************************
* @Name         InstituteMgmRolesHandler 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Michael Khan      06/12/2023         Count of Transcript user was showing wrong value hence we have updated ProcessInstitueRoles method.
*******************************************************************************************/
public class InstituteMgmRolesHandler {
    /**
* <h1>Manage IBRoles for Instiute users</h1>
* This Class is reponsible for processing the Institutute Users, Institute roles will be handled in this class;
* @author  Mubeen Akbar.
* @version 1.0
* @since   06-09-2020.
*/
    public static boolean isFirstRun=true;
    /**
* This method will send the email to Institute Admin Users, so that they admin can verify and decline the roles.
* @param List<IB_Role__c>.
* @return N/A.
*/
    
    public void SendEmailtoAdminForApplicant(List<IB_Role__c> roles)
    {
        list<id> AccList=new list<id>();
        map<id,IB_Role__c> IBECAdminRoleMap = new map<id,IB_Role__c>();//maps account ids to 
        for(IB_Role__c rol:roles)
        {
            AccList.add(rol.IB_Account__c);
        }
        //list<ib_role__c> InstAdminRole=[select Contact_name__c,ContactUserLanguage__c,IB_Contact__r.FirstName,IB_Contact__r.LastName,ContactInfo_Emailvalue__c,Contact_Information_Email__c from Ib_role__c where IB_Account__c IN:Acclist and IB_Role_Name__c='Institute Administrator' and Status__c='Confirmed' limit 1];
        for(IB_Role__c adminrole : [select Contact_name__c,ContactUserLanguage__c,IB_Contact__r.FirstName,IB_Contact__r.LastName,ContactInfo_Emailvalue__c,Contact_Information_Email__c,IB_Account__c from Ib_role__c where IB_Account__c IN:Acclist and IB_Role_Name__c='Institute Administrator' and Status__c='Confirmed']){
            IBECAdminRoleMap.put(adminrole.IB_Account__c,adminrole);
        }
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>() ;
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        for(IB_Role__c r:roles)
        {
            List<IB_Role__c> InstAdminRole = new List<IB_Role__c>();
            if(IBECAdminRoleMap.get(r.IB_Account__c)!=null){
                InstAdminRole.add(IBECAdminRoleMap.get(r.IB_Account__c));
            }
            IF(r.Contact_Information_Email__C !=NULL 
               && r.Email_Confirmed__c==True &&
               r.Status__c=='Applicant' && InstAdminRole.size()>0 &&
               (r.IB_Role_Name__c=='Institute Curriculum User' ||
                r.IB_Role_Name__c=='Institute Policy User' ||
                r.IB_Role_Name__c == 'Communication User' ||
                r.IB_Role_Name__c=='Institute Transcript User'||isFirstRun==false))
            {
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                message.toAddresses = new String[] {InstAdminRole[0].ContactInfo_Emailvalue__c};
                    if ( owea.size() > 0 )
                {
                    Message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                String Sub,body;
                Sub=body='';
                if(r.ContactUserLanguage__c=='en_US')
                {
                    Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                    body='Dear '+InstAdminRole[0].Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Institute User Roles page in My Institute by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';
                    
                }
                else if(r.ContactUserLanguage__c=='es')
                {
                    Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+' en Mi IB';
                    
                    body='Estimado(a) Sr(a). '+InstAdminRole[0].Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para institución en Mi institución.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB';
                    
                }
                else
                {
                    Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c;
                    
                    body='À l’attention de '+InstAdminRole[0].Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’institut, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon institut.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';
                    
                    
                    
                }                
                
                message.subject = Sub;
                message.setHtmlBody(Body);
                message.setUseSignature(false);
                messages.add(message);   
            }
        }
        
        if(Messages.size()>0 && !Test.isRunningTest())
        {
            Messaging.sendEmail(messages);
        }
        
    }
    public void SendEmailtoAIBWSAdminForApplicant(List<IB_Role__c> roles)
    {
        list<id> AccList=new list<id>();
        map<id,IB_Role__c> AIBWSAdminRoleMap = new map<id,IB_Role__c>(); 
        for(IB_Role__c rol:roles)
        {
            AccList.add(rol.IB_Account__c);
        }
        for(IB_Role__c adminrole : [select Contact_name__c,ContactUserLanguage__c,IB_Contact__r.FirstName,IB_Contact__r.LastName,ContactInfo_Emailvalue__c,Contact_Information_Email__c,IB_Account__c from Ib_role__c where IB_Account__c IN:Acclist and IB_Role_Name__c='Association Admin' and Status__c='Confirmed']){
            AIBWSAdminRoleMap.put(adminrole.IB_Account__c,adminrole);
        }
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>() ;
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        for(IB_Role__c r:roles)
        {
            List<IB_Role__c> AIBWSAdminRole = new List<IB_Role__c>();
            if(AIBWSAdminRoleMap.get(r.IB_Account__c)!=null){
                AIBWSAdminRole.add(AIBWSAdminRoleMap.get(r.IB_Account__c));
            }
            IF(r.Contact_Information_Email__C !=NULL 
               && r.Email_Confirmed__c==True &&
               r.Status__c=='Applicant' && AIBWSAdminRole.size()>0 &&
               (r.IB_Role_Name__c=='Association User' || isFirstRun==false))
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                message.toAddresses = new String[] {AIBWSAdminRole[0].ContactInfo_Emailvalue__c};
                    if ( owea.size() > 0 )
                {
                    Message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                String Sub,body;
                Sub=body='';
                if(AIBWSAdminRole[0].ContactUserLanguage__c=='fr')
                {
                    Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’associatio '+r.Account_Name__c;
                    body='À l’attention de '+AIBWSAdminRole[0].Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’association '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’association, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon AIBWS.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';
                    
                }
                else if(AIBWSAdminRole[0].ContactUserLanguage__c=='es')
                {
                    Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la Asociación '+r.Account_Name__c+' en Mi IB';
                    body='Estimado(a) Sr(a). '+AIBWSAdminRole[0].Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la Asociación '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para Asociación en Mi AIBWS.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB'; 
                }
                else
                {
                    Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                    body='Dear '+AIBWSAdminRole[0].Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Association User Roles page in My AIBWS by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';
                    
                }                
                
                message.subject = Sub;
                message.setHtmlBody(Body);
                message.setUseSignature(false);
                messages.add(message);   
            }
        }
        
        if(Messages.size()>0 && !Test.isRunningTest())
        {
            Messaging.sendEmail(messages);
        }
        
    }
    
    //Following method is added by Plumlogix-ECM00440 on 1/July/2022
    //Start
    public void sendEmailtoAdminsForApplicantEmailConfirmedMatched(List<IB_Role__c> roles)
    {
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>() ;
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        list<id> accList=new list<id>();
        for(IB_Role__c rol:roles)
        {
            accList.add(rol.IB_Account__c);
        }
        
        Map<id,Map<String,IB_Role__c>> accountWithRoleMap= new Map<id,Map<String,IB_Role__c>>();
        Map<String,IB_Role__c> adminRoleWithRecord = new Map<String,IB_Role__c>();
        
        list<ib_role__c> adminRoleList=[select IB_Account__c, Contact_name__c,ContactUserLanguage__c,IB_Contact__r.FirstName,IB_Role_Name__c,
                                        IB_Contact__r.LastName,ContactInfo_Emailvalue__c,Contact_Information_Email__c 
                                        from Ib_role__c where IB_Account__c IN:acclist and 
                                        (IB_Role_Name__c='Institute Administrator' OR IB_Role_Name__c='IBEC University Administrator' OR IB_Role_Name__c='Association Admin') AND
                                        Status__c='Confirmed'];
        
        List<Ib_Role__c> tempRoles = [Select Status__c,IB_Account__c,Contact_Information_Email__C,Email_Confirmed__c,Contact_Information_Email__r.email__c,IB_Contact__r.User__r.Email,
                                      ContactInfo_Emailvalue__c, ContactUserLanguage__c, Contact_name__c, IB_Role_Name__c, Account_Name__c,
                                      IB_Role_Name_es__c, IB_Role_Name_fr__c from IB_Role__c where id IN: roles];
        
        for(IB_Role__c role : adminRoleList){
            adminRoleWithRecord.put(role.IB_Role_Name__c,role);
            if (accountWithRoleMap.containsKey(role.IB_Account__c)){
                accountWithRoleMap.get(role.IB_Account__c). putAll(adminRoleWithRecord);
            }
            else{
                accountWithRoleMap.put(role.IB_Account__c, adminRoleWithRecord);
            }
        }
        IB_Role__c adminRole;
        Map<String,IB_Role__c> AdminRolesList = new Map<String,IB_Role__c>();
        
        for(IB_Role__c r:tempRoles)
        {
            if((r.Contact_Information_Email__C !=NULL && r.Contact_Information_Email__r.email__c == r.IB_Contact__r.User__r.Email 
                && r.Contact_Information_Email__C !=NULL &&
                r.Status__c=='Applicant' &&
                ((r.IB_Role_Name__c=='Institute Curriculum User' ||
                  r.IB_Role_Name__c=='Institute Policy User' ||
                  r.IB_Role_Name__c == 'Communication User' ||
                  r.IB_Role_Name__c == 'Association User' ||
                  r.IB_Role_Name__c=='Institute Transcript User' ) ||
                 (r.IB_Role_Name__c == 'IBEC Faculty Member' || 
                  r.IB_Role_Name__c == 'IBEC Candidate'))) 
               || Test.isRunningTest())
            {
                AdminRolesList = accountWithRoleMap.get(r.IB_Account__c);
                
                if(r.IB_Role_Name__c.Contains('IBEC'))
                {
                    adminRole = AdminRolesList.get('IBEC University Administrator');
                }
                else if (r.IB_Role_Name__c.Contains('Institute') || r.IB_Role_Name__c.Contains('Communication'))
                {
                    adminRole = AdminRolesList.get('Institute Administrator');
                }
                else if (r.IB_Role_Name__c.Contains('Association'))
                {
                    adminRole = AdminRolesList.get('Association Admin');
                }
                IF(adminRole != null )
                { 
                    String Sub,body;
                    Sub=body='';  
                    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                    message.toAddresses = new String[] {adminRole.ContactInfo_Emailvalue__c};
                        if ( owea.size() > 0 ){
                            message.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                    
                    if(r.IB_Role_Name__c.Contains('IBEC') && adminRole.ContactUserLanguage__c=='fr')
                    {
                        Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c; 
                        body='À l’attention de '+adminRole.Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’institut, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon institut.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';
                    }
                    else if (r.IB_Role_Name__c.Contains('IBEC') && adminRole.ContactUserLanguage__c=='es')
                    {
                        Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+' en Mi IB';
                        body='Estimado(a) Sr(a). '+adminRole.Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para institución en Mi institución.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB';     
                    }
                    else if (r.IB_Role_Name__c.Contains('IBEC') && adminRole.ContactUserLanguage__c=='en_US')
                    {
                        Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                        body='Dear '+adminRole.Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Institute User Roles page in My Institute by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';
                    }
                    else if ((r.IB_Role_Name__c.Contains('Institute') || r.IB_Role_Name__c.Contains('Communication')) && adminRole.ContactUserLanguage__c=='en_US')
                    {
                        Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                        body='Dear '+adminRole.Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Institute User Roles page in My Institute by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';
                    }
                    else if ((r.IB_Role_Name__c.Contains('Institute') || r.IB_Role_Name__c.Contains('Communication')) && adminRole.ContactUserLanguage__c=='fr')
                    {
                        Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c;
                        body='À l’attention de '+adminRole.Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’institut '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’institut, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon institut.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';
                    }
                    else if ((r.IB_Role_Name__c.Contains('Institute') || r.IB_Role_Name__c.Contains('Communication')) && adminRole.ContactUserLanguage__c=='es')
                    {
                        Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+' en Mi IB';
                        body='Estimado(a) Sr(a). '+adminRole.Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la institución '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para institución en Mi institución.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB';        
                    }
                    else if(r.IB_Role_Name__c.Contains('Association') && adminRole.ContactUserLanguage__c=='fr')
                    {
                        Sub='Mon IB – Examen de la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’associatio '+r.Account_Name__c; 
                        body='À l’attention de '+adminRole.Contact_name__c+', <br></br><br></br>Madame/Monsieur,<br></br><br></br> Veuillez examiner la candidature de '+r.Contact_name__c+' pour le rôle d’ '+r.IB_Role_Name_fr__c+' au sein de l’associatio '+r.Account_Name__c+'. <br></br>Avant d’approuver ou de refuser ce rôle à un utilisateur, veuillez vous assurer que tous les renseignements le concernant sont corrects.Pour examiner cette demande, veuillez consulter la page consacrée aux rôles des utilisateurs de l’association, vous connectant à <a href="https://internationalbaccalaureate.force.com/ibportal"> Mon IB</a> > Mon institut.<br></br><br></br>Salutations distinguées,<br></br><br></br>L’administrateur du système Mon IB';
                    }
                    else if (r.IB_Role_Name__c.Contains('Association') && adminRole.ContactUserLanguage__c=='es')
                    {
                        Sub='Revisión de la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la Asociación '+r.Account_Name__c+' en Mi IB';
                        body='Estimado(a) Sr(a). '+adminRole.Contact_name__c+', <br></br><br></br>Sírvase revisar la información de '+r.Contact_name__c+' para el rol de '+r.IB_Role_Name_es__c+' de la Asociación '+r.Account_Name__c+'. Antes de aprobar o rechazar este rol, asegúrese de que toda la información sea correcta.Para revisar esta solicitud, inicie sesión en <a href="https://internationalbaccalaureate.force.com/ibportal">Mi IB</a> y visite la página de Roles de usuarios para Asociación en Mi AIBWS.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br> El administrador de Mi IB';     
                    }
                    else if (r.IB_Role_Name__c.Contains('Association') && adminRole.ContactUserLanguage__c=='en_US')
                    {
                        Sub = 'My IB: Review '+r.Contact_name__c+' for '+r.IB_Role_Name__c+' at '+r.Account_Name__c;
                        body='Dear '+adminRole.Contact_name__c+',<br><br> Please review '+r.Contact_name__c+' for the '+r.IB_Role_Name__c+' role at '+r.Account_Name__c+'. Before you approve or decline this role, please ensure all user details are correct. To review this request, please visit the Association User Roles page in My AIBWS by logging into <a href="https://internationalbaccalaureate.force.com/ibportal">My IB</a>.<br><br>Thank you,<br> <br>My IB Admin';
                    }
                    message.subject = Sub;
                    message.setHtmlBody(Body);
                    message.setUseSignature(false);
                    messages.add(message); 
                }
            }
        }
        if(Messages.size()>0 && !Test.isRunningTest())
        {
            Messaging.sendEmail(messages);
        } 
        
    }
    
    //End
    
    /**
* This method will update the Institute related fields on Role(s)&Application(s) for Institute roles when applied
* @param List<IB_Role__c>.
* @return N/A.
*/
    public void updateInstituteAdmin(List<IB_Role__c> roles)
    {
        Map<ID,IB_Role__c> Institute_roles = new Map<ID,IB_Role__c>();
        for(IB_Role__c role_record:roles){
            if(role_record.IB_Role_Name__c == 'Institute Curriculum User' ||
               role_record.IB_Role_Name__c == 'Institute Policy User' || 
               
               role_record.IB_Role_Name__c == 'Communication User'||
               
               role_record.IB_Role_Name__c == 'Institute Transcript User')
                Institute_roles.put(role_record.IB_Account__c,role_record);
        }
        
        if(Institute_roles.size()>0){
            List<IB_Role__c> List_Institute_admins = new  List<IB_Role__c>([Select IB_Account__c,Contact_Information_Email_Text__c,IB_Contact__c,Email__c,Contact_name__c,Name from IB_Role__c where IB_Account__c IN:Institute_roles.keySet() AND IB_Role_Name__c = 'Institute Administrator' And Status__c = 'Confirmed' ]);
            Map<id,IB_Role__c> Institute_admins = new Map<Id,IB_Role__c>();
            for(IB_Role__c role_record:List_Institute_admins){
                Institute_admins.put(role_record.IB_Account__c,role_record);
            }
            for(IB_Role__c role_record:Institute_roles.values()){
                System.debug('role_record.IB_Account__c: '+role_record.IB_Account__c);
                IB_Role__c inst_admin = Institute_admins.get(role_record.IB_Account__c);
                System.debug('inst_admin: '+inst_admin);
                
                if(inst_admin != null && ((role_record.Institute_Administrator__c != inst_admin.IB_Contact__c) || (role_record.Institute_Administrator_Email__c != inst_admin.Contact_Information_Email_Text__c))){
                    role_record.Institute_Administrator__c = inst_admin.IB_Contact__c;
                    role_record.Institute_Administrator_Email__c = inst_admin.Contact_Information_Email_Text__c;
                    role_record.Institute_Administrator_Name__c =  inst_admin.Contact_name__c;
                }
                
            }
        }
        
    }
    /**
* This method will update the Institute related fields on Role(s)&Application(s) for all Institute roles when new Admin approved
* @param List<IB_Role__c>.
* @return N/A.
*/
    public void updateInstituteroles(List<IB_Role__c> roles)
    {
        Map<ID,IB_Role__c> Institute_roles = new Map<ID,IB_Role__c>();
        Set<ID> accountids = new Set<ID>();
        List<IB_Role__c> newroles = new List<IB_Role__c>();
        for(IB_Role__c role_record:roles){
            if(role_Record.IB_Role_Name__c == 'Institute Administrator' && role_Record.Status__c == 'Confirmed')
                newroles.add(role_record);
            
        }
        List<IB_Role__c> Institute_roles_to_update = new List<IB_Role__c>();
        for(IB_Role__c role_record:newroles){
            Institute_roles.put(role_record.IB_Account__c,role_record);
            
        }
        try{
            List<IB_Role__c> List_Institute_roles = new  List<IB_Role__c>([Select Institute_Administrator__c,Institute_Administrator_Email__c,Institute_Administrator_Name__c,IB_Account__c,IB_Contact__c,Email__c,Contact_name__c,Name from IB_Role__c where IB_Account__c IN:Institute_roles.keyset() AND (Status__c != 'Withdrawn' OR Status__c != 'Declined') AND IB_Role_Name__c IN('Institute Curriculum User','Institute Policy User','Institute Transcript User','Communication User') ]);
            
            if(List_Institute_roles.size()>0){
                for(IB_Role__c role_record:List_Institute_roles){
                    System.debug('role_record.IB_Account__c: '+role_record.IB_Account__c);
                    IB_Role__c inst_admin = Institute_roles.get(role_record.IB_Account__c);
                    System.debug('inst_admin: '+inst_admin);
                    if(inst_admin != null && ((role_record.Institute_Administrator__c != inst_admin.IB_Contact__c)||(role_record.Institute_Administrator_Email__c != inst_admin.Contact_Information_Email_Text__c))){
                        role_record.Institute_Administrator__c = inst_admin.IB_Contact__c;
                        role_record.Institute_Administrator_Email__c = inst_admin.Contact_Information_Email_Text__c;
                        role_record.Institute_Administrator_Name__c =  inst_admin.Contact_name__c;
                        Institute_roles_to_update.add(role_record);
                    }
                }
            }
            if(Institute_roles_to_update.size()>0)
                update Institute_roles_to_update;
            
        }
        catch(Exception ex){
            System.debug('Javalog -- InstituteMgmRolesHandler -- Exception '+ex);
        }
        
    }
    /**
* This method will send the email to Applicant-Institute Users, so that they admin can verify their email.
* @param List<IB_Role__c>.
* @return N/A.
*/
    
    public  void SendEmailConfirmationToRoleApplicant(List<IB_Role__c> roles) {
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage>();
        OrgWideEmailAddress[] owea = [select Id,Address from OrgWideEmailAddress where DisplayName='IB Communities' limit 1];
        List<Ib_Role__c> tempRoles = new List<Ib_Role__c>();
        tempRoles = [Select Contact_Information_Email__C,Email_Confirmed__c,Contact_Information_Email__r.email__c,IB_Contact__r.User__r.Email,
                     ContactInfo_Emailvalue__c, ContactUserLanguage__c, Contact_name__c, IB_Role_Name__c, Account_Name__c,
                     IB_Role_Name_es__c, IB_Role_Name_fr__c from IB_Role__c where id IN: roles];
        for(IB_Role__c r:tempRoles)
        {
            IF(r.Contact_Information_Email__C !=NULL && r.Email_Confirmed__c==false && r.Contact_Information_Email__r.email__c != r.IB_Contact__r.User__r.Email)
            { 
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {r.ContactInfo_Emailvalue__c};
                    if ( owea.size() > 0 )
                {
                    Message.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                String Sub,body;
                Sub=body='';
                if(r.ContactUserLanguage__c=='en_US')
                {
                    
                    Sub = 'My IB: Verify your email address';
                    body = 'Dear '+r.Contact_name__c+',<br></br> <br></br>Your application for the '+ r.IB_Role_Name__c+ ' role at '+r.Account_Name__c+' has been received. Before your role can be approved, you need to verify your email address.<br></br><br></br><a href='+AccClass.getBaseUrl()+'/ibportal/RoleEmailConfirmation?roleID='+r.id+'><button style="background:#008CBA;;color:white;padding: 10px 20px">VERIFY EMAIL</button></a><br></br> <br></br> Once your email address is verified, and your role is approved, you will receive a confirmation email.<br></br> <br></br>Thank you,<br></br> <br></br>My IB Admin';
                    
                }
                else if(r.ContactUserLanguage__c=='es')
                {
                    Sub='Verifique su dirección de correo electrónico en Mi IB';
                    body='Estimado(a) Sr(a). '+r.Contact_name__c+',<br></br> <br></br>Hemos recibido su solicitud para el rol de '+r.IB_Role_Name_es__c+' en la institución '+r.Account_Name__c+ '. Antes de aprobar su solicitud, necesitamos que verifique su dirección de correo electrónico.<br></br> <br></br><a href='+AccClass.getBaseUrl()+'/ibportal/RoleEmailConfirmation?roleID='+r.id+'><button style="background:#008CBA;;color:white;padding: 10px 20px">VERIFICAR LA DIRECCIÓN DE CORREO ELECTRÓNICO</button></a>  <br></br> <br></br>Le enviaremos un mensaje a su dirección de correo electrónico una vez la hayamos confirmado y se haya aprobado su rol.<br></br> <br></br>Gracias por su colaboración,<br></br> <br></br>El administrador de Mi IB';
                    
                }
                else
                {
                    Sub='Mon IB: Vérifiez votre adresse électronique';
                    body='À l’attention de '+r.Contact_name__c+',<br></br> <br></br>Madame/Monsieur,<br></br> <br></br>   Nous avons bien reçu votre candidature au rôle d’ '+r.IB_Role_Name_fr__c+', au sein de l’institut '+r.Account_Name__c+'. Avant que votre rôle ne soit approuvé, vous devez confirmer votre adresse électronique.<br></br><br></br> <a href='+AccClass.getBaseUrl()+'/ibportal/RoleEmailConfirmation?roleID='+r.id+'><button style="background:#008CBA;;color:white;padding: 10px 20px">CONFIRMATION DE L’ADRESSE ÉLECTRONIQUE</button></a> <br></br> <br></br> Une fois votre adresse électronique confirmée et votre rôle approuvé, vous recevrez un courriel de confirmation.<br></br> <br></br>Salutations distinguées,<br></br> <br></br>L’administrateur du système Mon IB';
                    
                }
                if( 
                    (r.IB_Role_Name__c != 'Examiner' && r.IB_Role_Name__c != 'Exam Team Leader' && r.IB_Role_Name__c != 'Principal Examiner' &&
                     r.IB_Role_Name__c != 'Deputy Examiner Responsible' && r.IB_Role_Name__c != 'Examiner Responsible' && r.IB_Role_Name__c != 'Chief Examiner' && r.IB_Role_Name__c != 'Assessment Content Developer' && r.IB_Role_Name__c != 'Assessment Language Reviewer' && r.IB_Role_Name__c != 'Assessment Translator'))
                {
                    
                    message.subject=sub;
                    message.setHtmlBody(Body);
                    message.setUseSignature(false);
                    messages.add(message);
                }
                
            }
        }
        if(messages.size()>0 && !Test.isRunningTest())
        {
            Messaging.sendEmail(messages);
            
        }
    }
    
    /**
* This method is responsible to process the Role Applications for IB Institutes
* @param List<IB_Role__c>.
* @return N/A.
*/
    
    public void ProcessInstitueRoles(List<IB_Role__c> roles)
    {
        System.debug('Inside_ProcessRoles');
        list<id> AccList=new list<id>();
        boolean hasAdmin=false;
        Set<id>ContactIds=new set<id>();
        for(IB_Role__c rol:roles)
        {
            if(rol.status__c!='Applicant')   
                AccList.add(rol.IB_Account__c);
            
            ContactIds.add(rol.IB_Contact__c);
        }
        system.debug('#ProcessInstitueRoles - Role: ' + roles);
        list<IB_Role__c> confirmTrans = new list<IB_Role__c>();
        list<IB_Role__c> adRole = new list<IB_Role__c>();
        Map<Id,Integer> accConfirmedTransUsersCount = new Map<Id,Integer>();
        
        for(IB_Role__c rol : [select id,status__c,ContactUserLanguage__c,ContactInfo_Emailvalue__c,IB_Account__c, IB_Account__r.Confirmed_Transcript_Users__c, IB_Contact__c,IB_Role_Name__c,Contact_Information_Email__c,Contact_Information_Phone__c from IB_Role__c where
                              IB_Account__c IN:AccList and status__c='Confirmed' and 
                              ((IB_Role_Name__c='Institute Administrator' and id not in: roles) OR
                               IB_Role_Name__c='Institute Transcript User')])
            
        {
            system.debug('inst_admin' + rol.IB_Role_Name__c);
            if(rol.IB_Role_Name__c=='Institute Transcript User' || rol.IB_Role_Name__c=='Institute Policy User'){// Added Institute Policy User as part of ECM00562 by Kashyap
                confirmTrans.add(rol);
                if(accConfirmedTransUsersCount.containsKey(rol.IB_Account__c)){
                    accConfirmedTransUsersCount.put(rol.IB_Account__c, accConfirmedTransUsersCount.get(rol.IB_Account__c)+1);
                }
                else{
                    accConfirmedTransUsersCount.put(rol.IB_Account__c,1);
                }
            }
            else if(rol.IB_Role_Name__c=='Institute Administrator'){
                adRole.add(rol);
                System.debug('else_if');
            }
        }
        List<IB_Role__c> RoleToInsert = new list<ib_role__c>();     
        Boolean roleAdded=false;
        for(IB_Role__c rol:roles)
        {
            
            if((rol.IB_Role_Name__c=='Institute Transcript User' && rol.Institute_Active_Status__c=='Active' && ( rol.Status__c=='Withdrawn' || rol.Status__c=='Declined' ) && rol.Institute_Transcript_Method__c=='Electronic')||isFirstRun==false)
            {
                if(confirmTrans.size()==0 && roleAdded==false ){
                    system.debug('Role Withdraw Inside');
                    IB_Role__c rol1=new Ib_role__c();
                    
                    
                    
                    if(adRole.size()>0)
                    {
                        rol1.IB_Contact__c=adRole[0].IB_Contact__c;
                        rol1.Contact_Information_Email__c=adRole[0].Contact_Information_Email__c;
                        rol1.Contact_Information_Phone__c=adRole[0].Contact_Information_Phone__c;
                    }
                    rol1.Job_Title__c=rol.Job_Title__c;    
                    rol1.Status__c='Confirmed';
                    rol1.IB_Account__c=rol.IB_Account__c;    
                    rol1.IB_Role__c=rol.IB_Role__c;
                    rol1.Email_Confirmed__c=true;  
                    rol1.Active__c=true; 
                    RoleToInsert.add(rol1);
                    roleAdded=true;
                    
                }                               
                
            }
            
            else if(rol.IB_Role_Name__c=='Institute Administrator'&& rol.Status__c=='Confirmed')
            {
                hasAdmin=true;
                System.debug('has_admin');
            }
            
            
        }
        if(RoleToInsert.size()>0 && !test.isRunningTest()) { insert RoleToInsert; }
        if(adRole.size()>0 && hasAdmin==true)
        {
            System.debug('Withdraw_role');
            
            list<IB_role__c>rolestowithdraw=new list<ib_role__c>();
            for(IB_role__c AdminRolefromList:adRole)
            {
                AdminRolefromList.status__c='Withdrawn';
                ContactIds.add(AdminRolefromList.IB_Contact__c);
                
                rolestowithdraw.add(AdminRolefromList);
            }
            update rolestowithdraw;
            if(ContactIds.size()>0)PermissionSetMaintenance.permissionMaintenance(contactIds);
            
        }
        list<Account>accounts=new list<Account>();
        for(Account a:[select id,Confirmed_Transcript_Users__c from account where id IN:AccList and RecordType.DeveloperName = 'IB_Institute'])
        {
            a.Confirmed_Transcript_Users__c = accConfirmedTransUsersCount.get(a.Id);
            accounts.add(a);
        }
        try{
            if(accounts.size()>0 && roleAdded==false ){
                update accounts;
            }
        }
        catch(Exception e){
            system.debug('Error Message: ' + e.getMessage());
        }
    }  
}