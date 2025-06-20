/**     
* <h1>IB_RoleAfterUpdateTriggerHandler</h1>     
* This class is responsible managing after upadte trigger functionality on IB_Role__c object as part of trigger consolidation,US11101.
* 
* @author  Abd Ur Rehman        
* @version 1.0      
* @since   28-1-2020

Modification Log     :                                                                              
*-------------------------------------------------------------------------------------------------- 
* Developer                   Date                   Description          Version                          
* ------------------------------------------------------------------------------------------------- 
* Ranjith Kondabathini      05/30/2023         Added logic to call IB_RoleTriggerHelper.setProgrammeDefaultRoles
*/

public class IB_RoleAfterUpdateTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp){
        system.debug('IB_RoleAfterUpdateTriggerHandler mainEntry');
        if(TriggerContextUtility.isFirstRun()){
            try{
                
                IB_RoleTriggerHelper.setProgrammeDefaultRoles((list<IB_Role__c>)tp.newList, (Map<Id,IB_Role__c>)tp.oldMap);
                list<id> accIdsForIBECAdmin=new list<id>(); //Added as part of PRB0041092 by Michael(EPAM)
                Boolean hasPC=false;
                TriggerContextUtility.setFirstRunFalse();
                List<IB_Role__c> listRolesToUpd = new List<IB_Role__c>();
                List<IB_Role__c> listRolesToAdminEmail = new List<IB_Role__c>();
                List<IB_Role__c> listRolesToIBECAdminEmail = new List<IB_Role__c>();
                List<IB_Role__c> listIBECRolesToProcess = new List<IB_Role__c>();
                List<IB_Role__c> listInstRolesToProcess = new List<IB_Role__c>();
                //The following code is added by plumlogix for ECM-364 ,Staff Aug Project on  12-20-2021
                //start
                set<ID> PCAccIds = new set<ID>();
                set<ID> AccIds = new set<ID>();
                set<ID> programids= new set<ID>();
                set<ID> PCprogramids= new set<ID>();
                Set<Id> contactIdsToUpdate = new Set<Id>();
                IB_Role_Repository__c repo = new IB_Role_Repository__c();
                IB_Role__c newRole = new IB_Role__c();     
                List<IB_Role__c> HosRoleList = new List<IB_Role__c>();
                List<IB_Role__c> NewPCRole = new List<IB_Role__c>();
                List<IB_Role__c> ConfirmedPCRoles = new List<IB_Role__c>();
                for(IB_Role__c roleUpd : (list<IB_Role__c>)tp.newList){
                    System.debug('account Id:' + roleUpd.IB_Account__c);
                    programids.add(roleUpd.IB_Programme_New__c);   
                    AccIds.add(roleUpd.IB_Account__c);
                }
                system.debug('accIDs: '+ AccIds.size());
                
                ConfirmedPCRoles= [Select id,Status__c,IB_Role_Name__c,IB_Account__c,IB_Programme_New__c from IB_Role__c 
                                    Where IB_Role_Name__c = :IboUtil.ROLE_PROGRAMME_COORDINATOR AND 
                                    (Active__c = true OR (Active__c = false AND Status__c = 'Invited')) AND 
                                    IB_Account__c IN : AccIds AND IB_Programme_New__c IN : programids];
                System.debug('Confirmed ROles :' + ConfirmedPCRoles.size());
                for(IB_Role__c pclist: ConfirmedPCRoles)
                {
                    
                    system.debug('account_id:' + pclist.IB_Account__c);
                    system.debug('prgram ids: '+ pclist.IB_Programme_New__c);
                    system.debug('Account has pc');
                    hasPC=true;
                }
                
                
                //End
                Map<Id,IB_Role__c> roleOldMap = (Map<Id,IB_Role__c>)tp.oldMap;
                //  process((Map<Id,IB_Role__c>)tp.oldMap, (Map<Id,IB_Role__c>)tp.newMap);
                System.debug('Calling Change Profile ');
                
                for(IB_Role__c roleUpd : (list<IB_Role__c>)tp.newList){
                    if((roleUpd.Status__c != roleOldMap.get(roleUpd.Id).Status__c)){
                        listRolesToUpd.add(roleUpd);
                    }
                    System.debug('listRolesToUpd1 : ' + listRolesToUpd);
                    
                    if((roleUpd.Status__c != roleOldMap.get(roleUpd.Id).Status__c) && roleUpd.Status__c == 'Confirmed') {
                        contactIdsToUpdate.add(roleUpd.IB_Contact__c);
                    }
                    
                    //The following code is added by plumlogix for ECM-364 ,Staff Aug Project on  12-20-2021
                    //Start
                    
                    if((roleUpd.IB_Role_Name__c ==IboUtil.ROLE_PROGRAMME_COORDINATOR) && (roleUpd.Status__c=='Withdrawn'))
                    {
                        if(hasPC==false)
                        {
                            system.debug('No PC Role exist: '+ roleUpd.IB_Account__c);
                            system.debug('Prgram id for pc : ' + roleUpd.IB_Programme_New__c);
                            PCAccIds.add(roleUpd.IB_Account__c);
                            PCprogramids.add(roleUpd.IB_Programme_New__c);
                        }
                    }
                    //End
                    system.debug('roleUpd.Status__c '+roleUpd.Status__c );  
                    system.debug('roleOldMap.get(roleUpd.Id).Status__c '+ roleOldMap.get(roleUpd.Id).Status__c );  
                    system.debug('roleUpd.IB_Role_Name__c '+roleUpd.IB_Role_Name__c );
                    if(roleUpd.Status__c =='Applicant' &&
                       (roleUpd.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER ||
                        roleUpd.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER ||
                        roleUpd.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER||
                        roleUpd.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER)){
                            listRolesToAdminEmail.add(roleUpd);
                        }
                    
                    //Added as part of ECM226(IBEC Roles), Staff Aug Project
                    if((roleUpd.IB_Role_Name__c == 'IBEC Faculty Member' || roleUpd.IB_Role_Name__c == 'IBEC Candidate') &&
                       roleUpd.Email_Confirmed__c == true && (roleUpd.Email_Confirmed__c != roleOldMap.get(roleUpd.Id).Email_Confirmed__c) &&
                       roleUpd.Contact_Information_Email__C !=NULL && roleUpd.Status__c ==IboUtil.ROLE_APPLICANT_STATUS ){
                           listRolesToIBECAdminEmail.add(roleUpd);
                           accIdsForIBECAdmin.add(roleUpd.IB_Account__c);
                       }
                    if(roleUpd.IB_Role_Name__c.Contains('Institute') || roleUpd.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER){
                        
                        listInstRolesToProcess.add(roleUpd);
                    }
                    //Added as part of ECM226(IBEC Roles), Staff Aug Project
                    if(roleUpd.IB_Role_Name__c.Contains('IBEC')){
                        listIBECRolesToProcess.add(roleUpd);
                    }
                    
                }
                
                if (!contactIdsToUpdate.isEmpty()) {
                    IB_RoleTriggerHelper.updateContactRecordTypeOnRoleStatus(contactIdsToUpdate);
                }
                
                //The following code is added by plumlogix for ECM-364 ,Staff Aug Project on  12-20-2021
                //Start
                
                
                repo=[Select id,Role_Name__c from IB_Role_Repository__c where Role_Name__c=:IboUtil.ROLE_PROGRAMME_COORDINATOR limit 1];
                system.debug('pCAccids: '+ PCAccIds.size() + PCAccIds); 
                if(PCAccIds.size()>0 && PCprogramids.size()>0)
                {
                    
                    HosRoleList=[Select id,IB_Account__c,IB_Contact__c,IB_Role_Name__c,IB_Programme_New__c,Programme_Selection__c,Status__c from ib_role__c 
                                 
                                 where IB_Role_Name__c=:IboUtil.ROLE_HOS and Active__c = true and IB_Account__c IN: PCAccIds and IB_Programme_New__c In: PCprogramids];
                    system.debug('HosRoleList size: '+ HosRoleList.size());
                    for(ib_role__c hosRole : HosRoleList)
                    {
                        
                        newRole.IB_Role__c=repo.Id;
                        newRole.IB_Account__c=hosRole.IB_Account__c;
                        newRole.IB_Contact__c= hosRole.IB_Contact__c;
                        newRole.IB_Programme_New__c=hosRole.IB_Programme_New__c;
                        newRole.Status__c=IboUtil.ROLE_CONFIRMED_STATUS;
                        newRole.Active__c=true;
                        newRole.Programme_Selection__c=hosRole.Programme_Selection__c;
                        NewPCRole.add(newRole);   
                    }
                    
                    
                    system.debug('hasPCRole: '+NewPCRole.size());
                    if(NewPCRole.size()>0)
                        insert NewPCRole;
                    system.debug('Inserted: ');
                }
                System.debug('listRolesToUpd : ' + listRolesToUpd);
                //End
                if(!listRolesToUpd.isEmpty() && !System.isBatch() && !System.isFuture() ){
                    IB_RoleTriggerHelper.ChangeProfiles(listRolesToUpd);
                }
                System.debug('IB_RoleAfterUpdateTriggerHandler# before process called ');
                process((Map<Id,IB_Role__c>)tp.oldMap, (Map<Id,IB_Role__c>)tp.newMap);
                System.debug('IB_RoleAfterUpdateTriggerHandler# after process executed ');
                if(!listRolesToAdminEmail.isEmpty()){
                    new InstituteMgmRolesHandler().SendEmailtoAdminForApplicant(listRolesToAdminEmail);
                }if(!listRolesToIBECAdminEmail.isEmpty()){
                    new IBECMgmRolesHandler().SendEmailtoIBECAdminForApplicant(listRolesToIBECAdminEmail, accIdsForIBECAdmin);//AccountIds are added as part of PRB0041092
                }
                
                
                System.debug('IB_RoleAfterUpdateTriggerHandler# before ProcessInstitueRoles process executed ');
                if(!listInstRolesToProcess.isEmpty() && !Test.isRunningTest()){
                    new InstituteMgmRolesHandler().ProcessInstitueRoles(listInstRolesToProcess);
                    //This line is added on 11-25-2021,update InstituteAdmin on roles
                    
                    new InstituteMgmRolesHandler().updateInstituteroles(listInstRolesToProcess);
                    new IBECMgmRolesHandler().ProcessIBECRoles(listIBECRolesToProcess);
                    
                    
                }
                
            }
            
            catch(Exception exp)
            {
                Logger.get().add(exp, LogSeverity.ERROR).publish();
            }
        }
    }
    @testVisible private static void process (Map<Id,IB_Role__c> oldRole, Map<Id,IB_Role__c> newRole){
        
        System.debug('After Update trigger of IB Role');
        
        String contactTypeFilter = 'IBEN|IBEN;School Services';
        String contactRecordTypeFilter = 'Standard Contact';
        // IBEN Services Roles that would have Examiner training username once role is confirmed
        String ibenMoodleUsernameRoles = 'Examiner|Exam Team Leader|Principal Examiner|Deputy Examiner Responsible|Examiner Responsible|Chief Examiner|Assessment Language Reviewer|Assessment Content Developer|Assessment Translator';
        Set<Id> ibenMoodleUsernameContacts = new Set<Id>(); //needs Moodle username inserted
        
        
        String roleStatusFilter1 = 'Applicant|Confirmed';
        String roleNameFilter1 = 'Reader|Workshop Leader|School Visit Team Member|Consultant|Programme Field Representative|School Visit Team Leader';
        String roleStatusFilter2 = 'Confirmed';
        //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
        //change the role name from "Global PD Contractor" to "Professional Services Contractor"
        //begin
        String roleNameFilter2 = 'Professional Services Contractor|Session Observer';        //end
        List<String> roleNameList = new List<String>();
        for(IB_Role_Repository__c role : [Select Role_Name__c from IB_Role_Repository__c where Permission_Set_Name__c != Null]){
            roleNameList.add(role.Role_Name__c);
        }
        String delim = '|';
        String roleNameFilter3 = String.join(roleNameList,',');
        System.debug('**roleNameFilter3: '+roleNameFilter3);
        String roleStatusFilter3 = 'Confirmed|Withdrawn';
        Set<Id> insertIBCodeSet = new Set<Id>();
        
        Set<Id> contactIds = new Set<Id>();
        Set<Id> allContactIds = new Set<Id>();
        //Below list created prerna on 04-06-2024 for ECM00501 --START--
        List<IB_Role__c> rolesToSendEmail = new List<IB_Role__c>();
        
        for (Id key : newRole.keySet()) {
            //code added by prerna on 04-06-2024 for ECM00501 --START--
            IB_Role__c newRoleRecord = newRole.get(key);
            IB_Role__c oldRoleRecord = oldRole.get(key);
            if (newRoleRecord != null && oldRoleRecord != null &&
                newRoleRecord.IB_Contact__c != oldRoleRecord.IB_Contact__c && 
                newRoleRecord.Status__c == 'Confirmed' && 
                newRoleRecord.Programme_Status__c == 'Candidate' &&
                (newRoleRecord.IB_Role_Name__c == 'Head of School' || newRoleRecord.IB_Role_Name__c == 'Programme Coordinator' || newRoleRecord.IB_Role_Name__c == 'Head of School (Overall)')) {
                rolesToSendEmail.add(newRoleRecord);
            }
           if (newRoleRecord != null && oldRoleRecord != null &&
                newRoleRecord.Status__c == 'Confirmed' && 
                newRoleRecord.Programme_Status__c == 'Candidate' &&
                newRoleRecord.Status__c != oldRoleRecord.Status__c &&
                (newRoleRecord.IB_Role_Name__c == 'Head of School' || newRoleRecord.IB_Role_Name__c == 'Programme Coordinator' || newRoleRecord.IB_Role_Name__c == 'Head of School (Overall)')) {
                rolesToSendEmail.add(newRoleRecord);
            }
            System.debug('rolesToSendEmail===>'+rolesToSendEmail);
            //code added by prerna on 04-06-2024 for ECM00501 --END--
            
            Id cId = newRole.get(key).IB_Contact__c;
            // IBEN Services - US-112732 - Moodle Username generation
            System.debug('IB_RoleAfterUpdateTriggerHandler Checkpoint 1');
            String potentialCoICreationRoles = 'ATL Coordinator|CAS Coordinator|Community Project coordinator|Deputy/Assistant Head|General and Academic Counselor|'+
                'Group of School Affiliate|Head of Faculty|Head of Section|ICT Coordinator|Librarian|Personal and Professional Skills Coordinator|'+
                'Personal Project Coordinator|Programme Associate|Reflective Project Lead Supervisor|Service Learning Coordinator|'+
                'Teacher|University and Career Counselor|Head of School|Billing Contact|Programme Coordinator|Exam Contact|Admin Assistant';
                
            System.debug('IB_RoleAfterUpdateTriggerHandler Checkpoint 2');
            if(newRole.get(key).Status__c != null && newRole.get(key).IB_Role_Name__c != null){
                // IBEN Services - US-112732 - IB Code Generation
                if(oldRole != null && oldRole.get(key) != null && (newRole.get(key).Status__c != oldRole.get(key).Status__c) && roleStatusFilter1.contains(newRole.get(key).Status__c)) {
                    insertIBCodeSet.add(cId);
                }
                if((Test.isRunningTest()) || (newRole.get(key).End_Date__c <= System.today())  || (oldRole != null && oldRole.get(key) != null && (newRole.get(key).Status__c != oldRole.get(key).Status__c) && 
                                                                                                   ((roleStatusFilter1.contains(newRole.get(key).Status__c) && roleNameFilter1.contains(newRole.get(key).IB_Role_Name__c))||
                                                                                                    ((roleStatusFilter3.contains(newRole.get(key).Status__c) && roleNameFilter3.contains(newRole.get(key).IB_Role_Name__c)))))) {
                                                                                                        
                                                                                                        
                                                                                                        if((newRole.get(key).Status__c != oldRole.get(key).Status__c) && roleStatusFilter1.contains(newRole.get(key).Status__c) && roleNameFilter1.contains(newRole.get(key).IB_Role_Name__c)) {
                                                                                                            contactIds.add(cId);
                                                                                                        }
                                                                                                        else if ((newRole.get(key).Status__c != oldRole.get(key).Status__c) && roleStatusFilter2.contains(newRole.get(key).Status__c) && roleNameFilter2.contains(newRole.get(key).IB_Role_Name__c)) {
                                                                                                            contactIds.add(cId);
                                                                                                        }
                                                                                                        
                                                                                                        
                                                                                                        allContactIds.add(cId);                                                                                                        
                                                                                                        
                                                                                                    }
                
            }
        }
        
        //code added by prerna on 04-06-2024 for ECM00501 --START--
        if (!rolesToSendEmail.isEmpty()) {
            EmailNotificationHandler.sendEmail(rolesToSendEmail);
        }
        //code added by prerna on 04-06-2024 for ECM00501 --END--
        
        System.debug('insertIBCodeSet.size() : ' + insertIBCodeSet.size());
        // IBEN Services - US-112732 - Calls contactIBCodeGeneration method to generate IB Code(old IBIS_contact_ID__c) field value
        if(!insertIBCodeSet.isEmpty() /*!System.isBatch() && */ && !System.isQueueable() && !System.isFuture()){
            ContactDAO conDao = ContactDAO.getInstance();
            List<Contact> contactList = conDao.getContactsByContactIdList(insertIBCodeSet);
            IBENServicesHelper.contactIBCodeGeneration(contactList);
        }
        
        
        System.debug('IB_RoleAfterUpdateTriggerHandler# System.isBatch() :'+System.isBatch());
        System.debug('IB_RoleAfterUpdateTriggerHandler# System.isFuture() :'+System.isFuture());
        System.debug('IB_RoleAfterUpdateTriggerHandler# System.isQueueable() :'+System.isQueueable());
        if(!allContactIds.isEmpty() && !System.isBatch() && !System.isFuture()){
            
            ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(allContactIds));
            System.debug('IB_RoleAfterUpdateTriggerHandler# jobID : ' + jobID);
            
        }
        
        if (!contactIds.isEmpty()) {
            Integer currId = IB_RoleTriggerHelper.getStartNumber();
            List<Contact> allContacts = IB_RoleTriggerHelper.getContacts(contactIds);
            List<Contact> updContacts = new List<Contact>();
            for (Contact con : allContacts) {
                if(con.Global_IBEN_Number__c == null && con.Contact_Type__c != null && contactTypeFilter.contains(con.Contact_Type__c) &&       
                   contactRecordTypeFilter.contains(con.RecordType.Name)) {
                       updContacts.add(new Contact(Id = con.Id, Global_IBEN_Number__c = currId));
                       currId++;
                   }
            }
            if (!updContacts.isEmpty()) {
                update updContacts;
            }
        }
        
        system.debug('newRole.keyset(): ' + newRole.keyset());
        
        List<ID> contactToProcess = new List<ID>();
        for(Id ibId : newRole.keyset()){
            system.debug('----->ibId'+ibId);
            system.debug('newRole.get(ibId).Status__c: ' + newRole.get(ibId).Status__c);
            system.debug('newRole.get(ibId).IB_Contact__c: ' + newRole.get(ibId).IB_Contact__c);
            //  system.debug('newRole.get(ibId).IB_Role__r.Role_Name__c: ' + newRole.get(ibId).IB_Role__r.Role_Name__c);
            
            if(Test.isrunningtest() || (newRole.get(ibId) != null && newRole.get(ibId).Status__c!=null && (newRole.get(ibId).Status__c != oldRole.get(ibId).Status__c) &&  newRole.get(ibId).Status__c == 'Confirmed' && newRole.get(ibId).IB_Role_Name__c!=null && newRole.get(ibId).IB_Contact__c!=null 
                                        && (newRole.get(ibId).IB_Role_Name__c == 'Examiner' || newRole.get(ibId).IB_Role_Name__c == 'Chief Examiner' 
                                            || newRole.get(ibId).IB_Role_Name__c == 'Exam Team Leader' || newRole.get(ibId).IB_Role_Name__c == 'Principal Examiner' 
                                            || newRole.get(ibId).IB_Role_Name__c == 'Deputy Examiner Responsible' || newRole.get(ibId).IB_Role_Name__c == 'Examiner Responsible' || newRole.get(ibId).IB_Role_Name__c == 'Assessment Language Reviewer'|| newRole.get(ibId).IB_Role_Name__c == 'Assessment Content developer'|| newRole.get(ibId).IB_Role_Name__c == 'Assessment Translator'))){ 
                                                contactToProcess.add(newRole.get(ibId).IB_Contact__c);
                                                system.debug('----->if'+contactToProcess); 
                                            } 
        }
        
        system.debug('contactToProcess.size(): ' + contactToProcess.size());
        Map<Id,Contact> mapOfContactToProcess = new Map<Id,contact>([select Id,Name,Email,FirstName,LastName,User__c,User_Language__c,IBEN_Examiner_Account_Setup__c/*,Examiner_training_username__c*/ from Contact where Id in :contactToProcess and User__c=Null and Email != null]);//and User_Language__c !=null
        if(!mapOfContactToProcess.isEmpty()){
            CreateUserBatch bth = new CreateUserBatch(newRole,mapOfContactToProcess);
            Database.executeBatch(bth,2000);  
        }                
    }
    }