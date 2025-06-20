/*******************************************************************************************
* @Name     IB_RoleTriggerHelper 
* @Author       
* @Date         
* @Group        
* @Description  This is trigger helper class for IB_Role__c object
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/30/2023         Added method setProgrammeDefaultRoles from IB_RoleAfterInsertTriggerHandler
*******************************************************************************************/
// This Helper Class is being updated by Developer Abd Ur Rehman -PlumLogix on 28/1/2020 as part of trigger consolidation, US-11101
//begin
public class IB_RoleTriggerHelper {
    
    private static Integer startNumber; 
    private static List<Contact> contacts;        
    
    public static Integer getStartNumber() {    
            if (startNumber == null) {
                
                try {
                    AggregateResult[] groupedResults = [
                        SELECT MAX(Global_IBEN_Number__c) start
                        FROM Contact 
                        WHERE Global_IBEN_Number__c != null
                    ];
                    
                    Integer currNumber = Integer.valueOf(groupedResults[0].get('start'));
                    startNumber = currNumber + 1;
                    
                } catch (Exception ex) {
                    
                    startNumber = 1;
                    
                }
                
            }
            
            return startNumber;
            
        }
    
    public static List<Contact> getContacts(Set<Id> idSet) {
        
        if (contacts == null) {
            
            contacts = [
                SELECT Id, Name, Contact_Type__c, RecordType.Name, Global_IBEN_Number__c 
                FROM Contact 
                WHERE Id IN :idSet
            ];
            
        }
        
        return contacts;
        
    }
    
    // This Method is responsible for validating CAS roles.
    // @author: Arbaz-Plumlogix 
    // @since 09-10-2021
    // @param list of ib_roles.     
    // @return void.        
    
    public static void IBRole_CAS_confirmed_Validation(List<IB_Role__c> RoleList){
        
        Set<Id> Ids = new Set<Id>();
        
        for (IB_Role__c role : RoleList) {
            
            Ids.add(role.IB_Programme_New__c);
            
        }
        List<IB_Role__c> Existing_CAS_Role = new List<IB_Role__c>();
        Existing_CAS_Role =  [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,
                              Active__c, IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c,
                              Programme_Selection__c, School_Name__c FROM IB_Role__c Where IB_Programme_New__c != NULL and IB_Programme_New__c IN :Ids and
                              Status__c = :IboUtil.ROLE_CONFIRMED_STATUS and IB_Role_Name__c = :IboUtil.ROLE_CAS_Coordinator Limit 1]; 
        System.debug('### Existing_Role_Size ' + Existing_CAS_Role.size());
        if( Existing_CAS_Role.size() > 0)
        {    
            
            
            
            
            for(IB_Role__c role : Existing_CAS_Role)
            {
                for(IB_Role__c newRole : RoleList)
                {
                    if(role.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator && role.IB_Programme_New__c == newRole.IB_Programme_New__c )
                    {
                        
                        system.debug('JavaLog CAS_IB_Programme_New__c ' + role.IB_Programme_New__c );
                        system.debug('JavaLog CAS_IB_Programme_New__c_NewRole ' + newRole.IB_Programme_New__c );
                        Try{
                            system.debug('role status' + role.Status__c);
                            system.debug('newRole status' + newRole.Status__c);
                            /*ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, system.label.Confirmed_CAS_Coordinator_already_Exist);
ApexPages.addMessage(msg);*/
                            newRole.addError(system.label.Confirmed_CAS_Coordinator_already_Exist_for_School);
                        }
                        catch (Exception exp){                                                        
                            Logger.get().add(exp, LogSeverity.ERROR).publish();
                        }
                    }
                }
            }
        }
    }
    
    
    /**    
* This Method is responsible for changeprofile trigger functiionality,US11101.
* @author: Abd Ur Rehman-Plumlogix 
* @since 29-1-2020
* @param list of ib_roles.    
* @return void.    
*/ 
    public static void ChangeProfiles(list<IB_Role__c> new_roles) {
        
        if (system.isFuture()) {
            return;
        }
        Map<id,id> contactUpdate=new Map<id,id>();
        Set<ID> account_id=new Set<ID>();
        Set<ID> role_id=new Set<ID>();
        List<String> strProgrammeSelection = new List<String>();
        
        List<String> roleName = new List<String>();    
        Set<ID> cons = new Set<ID>();
        List <contact> cont = new List<Contact>();
        // Condtions updated for ECM226 as part of Staff-Aug Project
        set<string> mapRoleNames = new set<string>{IboUtil.ROLE_HOS, IboUtil.ROLE_ONLINE_COORDINATOR, IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT ,IboUtil.ROLE_PROGRAMME_COORDINATOR, IboUtil.ROLE_HOS_OVERALL , IboUtil.ROLE_INSTITUTE_ADMINISTRATOR,
            IboUtil.ROLE_INSTITUTE_CURRICULUM_USER, IboUtil.ROLE_INSTITUTE_POLICY_USER, IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER, IboUtil.ROLE_BILLING_CONTACT, IboUtil.ROLE_COMMUNICATION_USER,
            'Deputy/Assistant Head', 'Group of Schools Affiliate', IboUtil.ROLE_CAS_Coordinator, 'General and Academic Counselor',
            'Librarian', 'Reflective Project Lead Supervisor', IboUtil.ROLE_TEACHER, 'Personal Project Coordinator'};
                
                system.debug('Starting..........Size of Trigger'+new_roles.Size());
        
        Set<ID> ContactIDs = new Set<ID>();
        Set<ID> AccountIDs = new Set<ID>();    
        
        Set<Id>idofCon=new Set<Id>();//contact ids for all the role
        for(IB_Role__c c: new_roles)
        {
            idofCon.add(c.IB_Contact__c);
        }
        
        List<IB_Role__c> roleListCon = new List<IB_Role__c>(); //all confirmed role match mapRoleNames 
        Map<id,String> mapRoleIdToConRecordType = new Map<id,String>(); //roleid,Contact record Type
        
        for (IB_Role__c roleAll : [SELECT Id, IB_Contact__c, IB_Contact__r.RecordType.Name, IB_Role_Name__c, IB_Account__r.Name, IB_Account__r.Id 
                                   FROM IB_Role__c 
                                   WHERE Status__c = :IboUtil.ROLE_CONFIRMED_STATUS 
                                   AND IB_Contact__c IN: idofCon 
                                   AND IB_Role_Name__c IN: mapRoleNames ] ) {
                                       roleListCon.add(roleAll);
                                       mapRoleIdToConRecordType.put(roleAll.Id, roleAll.IB_Contact__r.RecordType.Name);
                                   }      
        System.debug('Map_Role: ' + roleListCon.size());
        // System.debug('Name_Role: ' + roleListCon[0].IB_Role_name__c);
        
        Map<Id,Contact>ConRecordType = new Map<Id,Contact>([SELECT recordType.Name 
                                                            FROM Contact 
                                                            WHERE Id IN: idofCon]);
        
        Map<Id,Id> ContactLastId = New Map<Id,Id>();
        Set<Id> lastContactIdSav = new Set<Id>();
        
        for (IB_Role__c c: new_roles) {
            System.debug('Inside_loop');   
            string contactRecordType = mapRoleIdToConRecordType.get(c.Id);
            
            system.debug('Contact_Record_Type: ' + contactRecordType);
            
            if(
                ( c.IB_Role_Name__c == IboUtil.ROLE_HOS || c.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR || c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_ADMINISTRATOR || c.IB_Role_Name__c == 'IBEC University Administrator' /* || c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER|| c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER|| c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER */  ) && c.Status__c == IboUtil.ROLE_CONFIRMED_STATUS )
                
            {
                System.debug('Inside_loop_1');
                roleName.add(c.IB_Role_Name__c);
                cons.add(c.IB_Contact__c);        
                account_id.add(c.IB_Account__c); 
                role_id.add(c.IB_Role_ID__c);
                strProgrammeSelection.add(c.Programme_Selection__c);
                
            }            
            
            if (
                (contactRecordType == 'Standard Contact') && 
                ( 
                    c.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR || 
                    c.IB_Role_Name__c == IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT || 
                    c.IB_Role_Name__c == IboUtil.ROLE_HOS || 
                    c.IB_Role_Name__c == IboUtil.ROLE_HOS_OVERALL || 
                    c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_ADMINISTRATOR || 
                    c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER || 
                    c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER|| 
                    c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER || 
                    c.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER || 
                    c.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR || 
                    c.IB_Role_Name__c == IboUtil.ROLE_BILLING_CONTACT || 
                    c.IB_Role_Name__c == 'Deputy/Assistant Head' || 
                    c.IB_Role_Name__c == 'PGroup of Schools Affiliate' || 
                    c.IB_Role_Name__c == IboUtil.ROLE_CAS_Coordinator || 
                    c.IB_Role_Name__c == 'General and Academic Counselor' || 
                    c.IB_Role_Name__c == 'Librarian' || 
                    c.IB_Role_Name__c == 'Reflective Project Lead Supervisor' || 
                    c.IB_Role_Name__c == IboUtil.ROLE_TEACHER  || 
                    c.IB_Role_Name__c == 'IBEC University Administrator' || 
                    c.IB_Role_Name__c == 'IBEC Faculty Member' || 
                    c.IB_Role_Name__c == 'IBEC Candidate'  ||
                    c.IB_Role_Name__c =='Personal Project Coordinator' 
                )
            ) {
                
                if( c.IB_Account__c != NULL || c.IB_Account__c != '')
                {
                    
                    ContactIDs.add(c.IB_Contact__c);
                    AccountIDs.add(c.IB_Account__c);
                    
                }
                
                
            }
            
            if((c.IB_Role_Name__c == IboUtil.ROLE_ONLINE_COORDINATOR || c.IB_Role_Name__c == IboUtil.ROLE_ONLINE_ADMIN_ASSISTANT || c.IB_Role_Name__c == IboUtil.ROLE_HOS || c.IB_Role_Name__c == IboUtil.ROLE_HOS_OVERALL || c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_ADMINISTRATOR  || c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_CURRICULUM_USER|| c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_POLICY_USER|| c.IB_Role_Name__c == IboUtil.ROLE_INSTITUTE_TRANSCRIPT_USER || c.IB_Role_Name__c == IboUtil.ROLE_COMMUNICATION_USER || c.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR || c.IB_Role_Name__c==IboUtil.ROLE_BILLING_CONTACT || c.IB_Role_Name__c == 'Deputy/Assistant Head' || c.IB_Role_Name__c == 'PGroup of Schools Affiliate' || c.IB_Role_Name__c ==IboUtil.ROLE_CAS_Coordinator  || c.IB_Role_Name__c=='General and Academic Counselor' || c.IB_Role_Name__c == 'Librarian' || c.IB_Role_Name__c == 'Reflective Project Lead Supervisor' || c.IB_Role_Name__c == IboUtil.ROLE_TEACHER || c.IB_Role_Name__c == 'IBEC University Administrator' || c.IB_Role_Name__c == 'IBEC Faculty Member' || c.IB_Role_Name__c == 'IBEC Candidate'  || c.IB_Role_Name__c=='Personal Project Coordinator') && contactRecordType=='Standard Contact' ){
                
                
                System.debug('Inside_loop_2');
                ID contactId = c.IB_Contact__c;
                ID accountId;
                List<IB_Role__c> roles=new List<IB_Role__c>();
                for(Integer u=0;u<roleListCon.size();u++)
                {
                    if(roleListCon[u].IB_Contact__c==c.IB_Contact__c)
                    {                                   
                        roles.add(roleListCon[u]);
                    }
                }
                
                List<String> accountNames = new List<String>();
                List<String> distinctAccounts = new List<String>();
                List<Integer> distinctAccountsCount = new List<Integer>();
                for(IB_Role__c role: roles)
                {
                    
                    accountNames.add(role.IB_Account__r.Name);
                }
                
                for(String accountName : accountNames)
                {
                    Integer j=0;
                    for( String distinctAccountName: distinctAccounts)
                    {
                        if(accountName==distinctAccountName)
                        {
                            distinctAccountsCount[j]++;
                            Break;                           
                        }
                        j++;
                    }//end of inner loop
                    if(j==distinctAccounts.size())
                    {                     
                        distinctAccounts.add(accountName);
                        distinctAccountsCount.add(1);
                    }
                }//end of outer loop
                
                Integer max = 0;
                Integer index = -1;
                Integer i = 0;
                
                for ( Integer distinctAccountCount: distinctAccountsCount) {
                    
                    if (distinctAccountCount>max) {                        
                        max = distinctAccountCount;
                        index = i;                        
                    }
                    i++;
                }//end of for                
                
                for (IB_Role__c role: roles) {
                    
                    if (role.IB_Account__r.Name == distinctAccounts[index]) {
                        accountId = role.IB_Account__r.Id;                        
                        
                        contactUpdate.put(contactId,accountId);
                        Break;
                    }           
                }
                lastContactIdSav.add(contactId);
                
                
                
            }//end of If
            //End
            
            
        } 
        //end of loop
        
        List<Contact>contactRecord = new List<Contact>();
        contactRecord = [SELECT Id, AccountId 
                         FROM Contact 
                         WHERE Id IN:lastContactIdSav];
        
        List<Contact> FinalContactUpdate = new List<Contact>();
        
        for (Integer e = 0; e < contactRecord.size(); e++) {
            
            ID accountIdOfCon = contactUpdate.get(contactRecord[e].id);
            
            if (accountIdOfCon != Null && contactRecord[e].AccountId <> accountIdOfCon) {   
                
                contactRecord[e].AccountId = accountIdOfCon;          
                
                FinalContactUpdate.add(contactRecord[e]);
            }
        }       
        if ( !FinalContactUpdate.isEmpty() ) {
             System.debug('FinalContactUpdate : ' + FinalContactUpdate);
            update FinalContactUpdate;
        }
        System.debug('Cons : ' + Cons.size());
        
        Set<ID> userIds = new Set<ID>();        
        
        if ( accountIds.size() > 0 && contactIds.size() > 0 ) {
            
            for (User u : [SELECT ID, Name 
                           FROM user 
                           WHERE contactID = :contactIds] ) {
                               
                               userIds.add(u.ID);    
                               
                           }
            
            List<ID> contIds = new List<ID>();
            
            if(cont.size()>0){
                for(Contact a: cont )
                {
                    
                    contIds.add(a.ID);         
                }
                List <User> userUpdate = new List<User>();        
                if ( ! userIds.isEmpty() ) {
                    Utils.updateUserProfile(userIds,contactIds);
                }
                
                
                for(User u : userUpdate )
                {
                    userIds.add(u.ID);
                }
                if( ! userIds.isEmpty() )
                    Utils.updateUserProfile(userIds);  
                system.debug('This is the user with updated Profile' + userUpdate);
                Set<id> tempSet = new Set<id>();
                tempSet.addAll(contIds);
                if(!System.isBatch()){
                    PermissionSetMaintenance.permissionMaintenance(tempSet);
                }
                if(System.isBatch()){
                    PermissionSetMaintenance.profileMaintenanceNonFuture(tempSet);
                    PermissionSetMaintenance.permissionMaintenanceNonFuture(tempSet); 
                    PermissionSetMaintenance.updateIBENActiveStatusNonFuture(tempSet);
                }
            }
            
            
            
        }
        
    }
    
    /*  Author : Ranjith Kondabathini
Date   : 05/30/2023
Description : Method used to populate default contact roles information on Programmes
*/
    public static void setProgrammeDefaultRoles(List<IB_Role__c> newRoles, Map<Id,IB_Role__c> oldRoles) {
        try{
            Map<Id,IB_Programme__c> progToUpdateMap = new Map<Id,IB_Programme__c>();
            Map<Id,IB_Programme__c> allProgMap = new Map<Id,IB_Programme__c>();
            List<IB_Role__c> rolesToEndDate = new List<IB_Role__c>();
            final Set<Id> setAccountIds = new Set<Id>();
            final Set<Id> setContactIds = new Set<Id>();
            final Set<Id> setProgrammeIds = new Set<Id>();
            final Set<Id> roleIds = new Set<Id>();
            
            for (IB_Role__c role : newRoles) {
                if((IboUtil.DEFAULT_PROGRAMME_ROLES.contains(role.IB_Role_Name__c) || (role.IB_Role_Name__c == IboUtil.ROLE_HOS_OVERALL)) && 
                   (Trigger.isInsert || Trigger.isUpdate && (role.Active__c <> oldRoles.get(role.Id).Active__c || role.Status__c <> oldRoles.get(role.Id).Status__c))) {

                       if (role.IB_Programme_New__c <> null) {
                           setProgrammeIds.add(role.IB_Programme_New__c);
                       }
                       if (role.IB_Account__c <> null) {
                           setAccountIds.add(role.IB_Account__c);
                       }
                       if (role.IB_Contact__c <> null) {
                           setContactIds.add(role.IB_Contact__c);
                       }
                       roleIds.add(role.Id);
                }
            }
            final Map<String,List<IB_Role__c>> allRoles = getRolesByAccountAndProgramme(setAccountIds, setProgrammeIds);     
            final Map<String,Id> mapAccountProgrammeIds = new Map<String,Id>();
            
            if(!roleIds.isEmpty() && setAccountIds.isEmpty()) {
                for(IB_Programme__c prog : [select Id,Account__c,RecordType.Name from IB_Programme__c where Account__c IN : setAccountIds]) {
                    if(prog.Status__c<>null && (prog.Status__c.contains('Terminated') || prog.Status__c.contains('Withdrawn') || prog.Status__c.contains('Previously Interested'))) {
                        continue;
                    }
                    if(prog.RecordType.Name == 'Diploma Programme') {
                        mapAccountProgrammeIds.put(prog.Account__c + '-DP', prog.Id);
                    } else {
                        mapAccountProgrammeIds.put(prog.Account__c + '-' + prog.RecordType.Name, prog.Id);    
                    }  
                    allProgMap.put(prog.Id, prog);
                }
            }
            
            final Set<String> setProgRoleToRemove = new Set<String>();
            
            for (IB_Role__c role : newRoles) {
                if(roleIds.contains(role.Id) && checkIfConfirmedDefaultRole(role, oldRoles)) { 
                    if(role.IB_Programme_New__c <> null) {
                        final IB_Programme__c prog = allProgMap.containsKey(role.IB_Programme_New__c) ? allProgMap.get(role.IB_Programme_New__c) : new IB_Programme__c(Id = role.IB_Programme_New__c);
                        progToUpdateMap = processProgrammeInfo(prog, role, progToUpdateMap);    
                    }                    
                    rolesToEndDate = processDefaultRolesInfo(role, allRoles, rolesToEndDate);
                } else if(roleIds.contains(role.Id) && checkIfInvitedDefaultRole(role, oldRoles)){
                    rolesToEndDate = processDefaultRolesInfo(role, allRoles, rolesToEndDate);
                }else if(roleIds.contains(role.Id) && checkIfInactiveDefaultRole(role, oldRoles)) {  
                    if(!hasActiveRole(allRoles, role) && !setProgRoleToRemove.contains(role.IB_Programme_New__c+role.IB_Role_Name__c)) {
                        setProgRoleToRemove.add(role.IB_Programme_New__c+role.IB_Role_Name__c);
                        final IB_Programme__c prog = allProgMap.containsKey(role.IB_Programme_New__c) ? allProgMap.get(role.IB_Programme_New__c) : new IB_Programme__c(Id = role.IB_Programme_New__c);
                        progToUpdateMap = removeRoleInfoOnProgramme (prog, role.IB_Role_Name__c, progToUpdateMap);
                    }
                }
            }
            
            updateRoles(rolesToEndDate);
            updateProgrammes(progToUpdateMap);    
        } catch(Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish();
        }        
    }
    
    private static boolean checkIfConfirmedDefaultRole(IB_Role__c role, Map<Id,IB_Role__c> oldRoles) {
        return role.IB_Account__c<>null && role.IB_Contact__c<>null && role.Active__c && role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS;
    }
    
    private static boolean checkIfInvitedDefaultRole(IB_Role__c role, Map<Id,IB_Role__c> oldRoles) {
        return role.IB_Account__c<>null && role.IB_Contact__c<>null && role.Status__c == IboUtil.ROLE_INVITED_STATUS;
    }
    
    private static boolean checkIfInactiveDefaultRole(IB_Role__c role, Map<Id,IB_Role__c> oldRoles) {
        return role.IB_Account__c<>null && role.IB_Contact__c<>null && role.IB_Programme_New__c<>null && role.Status__c == IboUtil.ROLE_WITHDRAWN_STATUS;
    }
    
    private static void updateProgrammes (Map<Id,IB_Programme__c> progMap) {
        if(!progMap.isEmpty()) {            
            update progMap.values();
        }                
    }
    
    private static void updateRoles (List<IB_Role__c> rolesToEndDate) {
        final Set<Id> contactIds = new Set<Id>();
        final List<Id> roleIds = new List<Id>();
        
        if (!rolesToEndDate.isEmpty()) {
            for(IB_Role__c rID : rolesToEndDate) {
                contactIds.add(rID.IB_Contact__c);
                roleIds.add(rID.Id);
            }            
            if(roleIds.size() > 20) {
                WithdrawRolesBatch wrb = new WithdrawRolesBatch(roleIds);
                final ID jobID = Database.executeBatch(wrb, 20);     
            } else {
            update rolesToEndDate;                        
            final ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(contactIds));                               
        }
    }
    }
    
    private static List<IB_Role__c> processDefaultRolesInfo(IB_Role__c role, Map<String,List<IB_Role__c>> allRoles, List<IB_Role__c> rolesToEndDate) {               
        rolesToEndDate = deactivateExistingRoles(allRoles, role.IB_Role_Name__c, role, rolesToEndDate);                                    
        return rolesToEndDate;
    }
    
    private static Map<Id,IB_Programme__c> processProgrammeInfo (IB_Programme__c prog, IB_Role__c role, Map<Id,IB_Programme__c> progToUpdateMap) {
        IB_Programme__c progToUpdate = progToUpdateMap.containsKey(prog.Id) ? progToUpdateMap.get(prog.Id) : prog;
        progToUpdate.Programme_Contacts_Last_Modified__c = Date.today();
        if (role.IB_Role_Name__c == IboUtil.ROLE_HOS) {
            progToUpdate.Contact_Head_of_School__c = role.IB_Contact__c;
            progToUpdate.Head_of_School_Email__c = role.Email__c;                    
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        } else if (role.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_COORDINATOR) {
            progToUpdate.Contact_Programme_Coordinator__c = role.IB_Contact__c;
            progToUpdate.Programme_Coordinator_Email__c = role.Email__c;                    
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        } else if (role.IB_Role_Name__c == IboUtil.ROLE_BILLING_CONTACT) {                    
            progToUpdate.Contact_Billing_Contact__c = role.IB_Contact__c;
            progToUpdate.Billing_Contact_Email__c = role.Email__c;
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        }       
        return progToUpdateMap;
    }
    
    /**
     * Author : Satyanarayana Gajavalli
     * Date Added : 07-10-2024
     * Description: Updates the record type of Contacts to "Standard Contact" if any associated role status is "Confirmed".
    **/
    public static void updateContactRecordTypeOnRoleStatus (Set<Id> contactIdsToUpdate) {

        try {
            List<Contact> contactsToUpdate = [SELECT Id, RecordTypeId FROM Contact WHERE Id IN :contactIdsToUpdate];
            Id standardRecordType = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();

            for (Contact contact : contactsToUpdate) {
                if (contact.RecordTypeId != standardRecordType) {
                    contact.RecordTypeId = standardRecordType;
                }
            }

            if (contactsToUpdate.size()>0) {
                update contactsToUpdate;
            }
        } catch(Exception exp) {              
            Logger.get().add(exp, LogSeverity.ERROR).publish();            
        }
    }
    
    private static Map<Id,IB_Programme__c> removeRoleInfoOnProgramme (IB_Programme__c prog, String roleName, Map<Id,IB_Programme__c> progToUpdateMap) {
        IB_Programme__c progToUpdate = progToUpdateMap.containsKey(prog.Id) ? progToUpdateMap.get(prog.Id) : prog;
        progToUpdate.Programme_Contacts_Last_Modified__c = Date.today();
        if (roleName == IboUtil.ROLE_HOS) {
            progToUpdate.Contact_Head_of_School__c = null;
            progToUpdate.Head_of_School_Email__c = null;                    
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        } else if (roleName == IboUtil.ROLE_PROGRAMME_COORDINATOR) {
            progToUpdate.Contact_Programme_Coordinator__c = null;
            progToUpdate.Programme_Coordinator_Email__c = null;                    
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        } else if (roleName == IboUtil.ROLE_BILLING_CONTACT) {                    
            progToUpdate.Contact_Billing_Contact__c = null;
            progToUpdate.Billing_Contact_Email__c = null;
            progToUpdateMap.put(progToUpdate.Id,progToUpdate);
        }       
        return progToUpdateMap;
    }
    
    private static List<IB_Role__c> deactivateExistingRoles(Map<String,List<IB_Role__c>> allRoles, String roleName, IB_Role__c role, List<IB_Role__c> rolesToEndDate) {
        final List<IB_Role__c> listRolesToWithdraw = new List<IB_Role__c>();
        if(role.IB_Programme_New__c<>null && allRoles.containsKey(role.IB_Programme_New__c + '_' + roleName)) {
            listRolesToWithdraw.addAll(allRoles.get(role.IB_Programme_New__c + '_' + roleName));
        }
        
        if(allRoles.containsKey(role.IB_Account__c+role.Programme_Selection__c + '_' + roleName)) {
            listRolesToWithdraw.addAll(allRoles.get(role.IB_Account__c+role.Programme_Selection__c + '_' + roleName));
        }
        if(roleName == IboUtil.ROLE_HOS_OVERALL && allRoles.containsKey(role.IB_Account__c + '_' + roleName)) {
            listRolesToWithdraw.addAll(allRoles.get(role.IB_Account__c + '_' + roleName));
        }

        for (IB_Role__c r : listRolesToWithdraw) {
            if (r.IB_Role_Name__c == roleName && r.id != role.Id) {
                r.End_Date__c = Date.today();
                r.Active__c = false;   
                
                    //role.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                    if(r.Status__c!= IboUtil.ROLE_APPLICANT_STATUS && r.Status__c!=IboUtil.ROLE_INVITED_STATUS){
                r.Status__c = IboUtil.ROLE_WITHDRAWN_STATUS;
                        }
                        else{
                            r.Status__c = IboUtil.ROLE_DECLINED_STATUS;  
                        }
                        
                   if(r.Reason_For_Status__c == 'Confirmed'){
                    r.Reason_For_Status__c= '';
                   }  
                 
                rolesToEndDate.add(r);
            }
        }    
            
        return rolesToEndDate;
    }
    
    private static boolean hasActiveRole(Map<String,List<IB_Role__c>> allRoles, IB_Role__c role) {
        final List<IB_Role__c> existingRoles = new List<IB_Role__c>();
        if(role.IB_Programme_New__c<>null && allRoles.containsKey(role.IB_Programme_New__c + '_' + role.IB_Role_Name__c)) {
            existingRoles.addAll(allRoles.get(role.IB_Programme_New__c + '_' + role.IB_Role_Name__c));
        }
        
        if(allRoles.containsKey(role.IB_Account__c+role.Programme_Selection__c + '_' + role.IB_Role_Name__c)) {
            existingRoles.addAll(allRoles.get(role.IB_Account__c+role.Programme_Selection__c + '_' + role.IB_Role_Name__c));
        }
        for (IB_Role__c r : existingRoles) {
            if (r.IB_Role_Name__c == role.IB_Role_Name__c && (r.Active__c==true || r.Status__c == IboUtil.ROLE_CONFIRMED_STATUS)) {
                return true;
            }
        } 
        return false;
    }
    
    private static Map<String,List<IB_Role__c>> getRolesByAccountAndProgramme(Set<Id> setAccountIds, Set<Id> setProgrammeIds) {
        final Map<String,List<IB_Role__c>> mapProgrammeRoles = new Map<String,List<IB_Role__c>>();
        if(!setAccountIds.isEmpty()) {            
            for(IB_Role__c role : [
                SELECT Id, Name, Email__c, Status__c, IB_Contact__c, IB_Contact__r.RecordTypeId, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Selection__c,
                IB_Role__c, IB_Role_Name__c, IB_Programme_New__r.RecordType.Name,IB_Contact__r.Email, Active__c,                
                IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title, Account_Name__c, createddate,Reason_For_Status__c// added createdate bby kashyap
                FROM IB_Role__c
                WHERE IB_Account__c IN :setAccountIds and (IB_Programme_New__c IN :setProgrammeIds OR IB_Programme_New__c=NULL OR IB_Role_Name__c = 'Head of School (Overall)')
                AND (End_Date__c = null OR End_Date__c > TODAY OR Active__c=true)
                AND (IB_Role_Name__c IN : IboUtil.DEFAULT_PROGRAMME_ROLES OR IB_Role_Name__c = 'Head of School (Overall)')
                ORDER BY IB_Contact__c
            ]) {
                List<IB_Role__c> roles = new List<IB_Role__c>();
                if(role.IB_Role_Name__c == IboUtil.ROLE_HOS_OVERALL) {
                    if(mapProgrammeRoles.containsKey(role.IB_Account__c + '_' + role.IB_Role_Name__c)) {
                        roles = mapProgrammeRoles.get(role.IB_Account__c + '_' + role.IB_Role_Name__c);
                    }
                    roles.add(role);    
                    mapProgrammeRoles.put(role.IB_Account__c + '_' + role.IB_Role_Name__c, roles);  
                } else if(role.IB_Programme_New__c == null) {
                    if(mapProgrammeRoles.containsKey(role.IB_Account__c+role.Programme_Selection__c + '_' + role.IB_Role_Name__c)) {
                        roles = mapProgrammeRoles.get(role.IB_Account__c+role.Programme_Selection__c + '_' + role.IB_Role_Name__c);
                    }
                    roles.add(role);    
                    mapProgrammeRoles.put(role.IB_Account__c+role.Programme_Selection__c + '_' + role.IB_Role_Name__c, roles);  
                }else {
                    if(mapProgrammeRoles.containsKey(role.IB_Programme_New__c + '_' + role.IB_Role_Name__c)) {
                        roles = mapProgrammeRoles.get(role.IB_Programme_New__c + '_' + role.IB_Role_Name__c);
                    }
                    roles.add(role);    
                    mapProgrammeRoles.put(role.IB_Programme_New__c + '_' + role.IB_Role_Name__c, roles);    
                }                
            }
        }
        return mapProgrammeRoles;
    }        
    
    public static void populateProgrammeOnOnboardingRoles(List<IB_Role__c> newRoles, Map<Id,IB_Role__c> oldRolesMap) {
        try{        
            final Set<Id> accIds = new Set<Id>();
            for(IB_Role__c role : newRoles) {
                if(role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && (Trigger.isInsert || (Trigger.isUpdate && oldRolesMap.get(role.Id).Status__c <> role.Status__c)) 
                   && role.IB_Programme_New__c == null && IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION.contains(role.IB_Role_Name__c) && role.Programme_Selection__c<>null) {                
                       accIds.add(role.IB_Account__c);
                   }
            }
            final Map<String,Id> mapAccountProgrammeIds = new Map<String,Id>();
            if(!accIds.isEmpty()) {
                for(IB_Programme__c prog : [select Id,RecordType.Name,Status__c,Account__c from IB_Programme__c where Account__c IN : accIds]) {
                    if(prog.Status__c<>null && (prog.Status__c.contains('Terminated') || prog.Status__c.contains('Withdrawn') || prog.Status__c.contains('Previously Interested'))) {
                        continue;
                    }
                    if(prog.RecordType.Name == 'Diploma Programme') {
                        mapAccountProgrammeIds.put(prog.Account__c + '-DP', prog.Id);
                    } else {
                        mapAccountProgrammeIds.put(prog.Account__c + '-' + prog.RecordType.Name, prog.Id);    
                    }
                }
            }
            if(!mapAccountProgrammeIds.isEmpty()) {
                for(IB_Role__c role : newRoles) {
                    if(role.Status__c == IboUtil.ROLE_CONFIRMED_STATUS && (Trigger.isInsert || (Trigger.isUpdate && oldRolesMap.get(role.Id).Status__c <> role.Status__c)) 
                       && role.IB_Programme_New__c == null && IboUtil.DEFAULT_PROGRAMME_ROLES_ADDITION.contains(role.IB_Role_Name__c) && role.Programme_Selection__c<>null) {                
                           if(mapAccountProgrammeIds.containsKey(role.IB_Account__c + '-' + role.Programme_Selection__c)) {
                               role.IB_Programme_New__c = mapAccountProgrammeIds.get(role.IB_Account__c + '-' + role.Programme_Selection__c);
                               role.Expiry_Date__c = null;
                           }
                       }
                }
            }
        }  catch(Exception exp) {              
            Logger.get().add(exp, LogSeverity.ERROR).publish();            
        }
    }
}