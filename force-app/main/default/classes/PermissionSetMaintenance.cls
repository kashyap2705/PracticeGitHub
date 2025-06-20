public without sharing class PermissionSetMaintenance {
    private static String IB_ANSWERS_PERMISSION_SET = 'IB_Answers_External_User_Access';
    @future 
    public static void updateIBENActiveStatus (Set<Id> contactIds){
        updateIBENActiveStatusNonFuture (contactIds);  
    }
    
    public static void updateIBENActiveStatusNonFuture (Set<Id> contactIds){
        
        List<IB_Role_Repository__c> ibenRoles = [SELECT Id, Role_Name__c FROM IB_Role_Repository__c WHERE Role_Type__c = 'IBEN Role'];
        set<String> ibrolename = new Set<String>();
        for(IB_Role_Repository__c r:ibenRoles){  
            ibrolename.add(r.Role_Name__c);
        }
        
        List<Contact> contactObjList = [SELECT id, Name,IBEN_Active__c,(SELECT ID,Name,IB_Contact__c,IB_Role_Name__c, Active__c FROM IBEN_Roles1__r)
                                        FROM Contact
                                        WHERE ID IN :contactIds];
        
        for (Contact con : contactObjList){
            Boolean setToactive = false;
            for(IB_Role__c  Ibrole : con.IBEN_Roles1__r) {
                
                if(Ibrole.Active__c == true) {
                    system.debug('Ibrole.IB_Role_Name__c==' +Ibrole.IB_Role_Name__c);
                    if(ibrolename.Contains(Ibrole.IB_Role_Name__c))
                    { 
                        setToactive = true;
                        break;
                    }
                }
            } 
            
            if(setToactive) {
                con.IBEN_Active__c = true;
            } else {
                con.IBEN_Active__c = false;
            }
            
        }
        
        
        update contactObjList;            
        
    }
    
    @future
    public static void profileMaintenance (Set<Id> contactIds) {
        FutureHelper.stopFuture();
        profileMaintenanceNonFuture(contactIds);
    }
    
    public static void profileMaintenanceNonFuture (Set<Id> contactIds) {
        
        Map<Id,User> contactToUser = new Map<Id,User>();
        
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Profile.Name in ('Customer Community Basic','Customer Community Advanced','SCU + Basic','SCU + Advanced')];
        Map<String,Id> profileMap = new Map<String,Id>();
        for(Profile p:profileList){
            profileMap.put(p.Name,p.Id);
        }
        
        List<User> users = [SELECT Id, ContactId, Profile.Name FROM User WHERE ContactId in :contactIds];
        
        Set<Id> userIds = new Set<Id>();
        
        for(User u:users){
            contactToUser.put(u.ContactId,u);
            userIds.add(u.Id);
        }
        
        AggregateResult[] groupedHSResult = [Select IB_Contact__c,count(Name)
                                             FROM IB_Role__c
                                             WHERE Status__c = 'Confirmed'
                                             AND (End_Date__c = null OR End_Date__c >= TODAY)
                                             AND IB_Contact__c in :contactIds
                                             AND (IB_Role_Name__c = 'Programme Coordinator' OR IB_Role_Name__c = 'Head of School'OR IB_Role_Name__c = 'Head of School (Overall)' OR IB_Role_Name__c = 'Association Admin')
                                             GROUP BY IB_Contact__c];
        
        AggregateResult[] groupedResult = [Select IB_Contact__c,count(Id)
                                           FROM IB_Role__c
                                           WHERE Status__c = 'Confirmed'
                                           AND (End_Date__c = null OR End_Date__c >= TODAY)
                                           AND IB_Contact__c in :contactIds
                                           AND (IB_Role_Name__c != 'Programme Coordinator' OR IB_Role_Name__c != 'Head of School'OR IB_Role_Name__c != 'Head of School (Overall)' OR IB_Role_Name__c != 'Association Admin')
                                           GROUP BY IB_Contact__c];
        
        Map<Id,Integer> contactRoleCount = new Map<Id,Integer>();
        Map<Id,Integer> contactHSRoleCount = new Map<Id,Integer>();
        
        for(AggregateResult ar:groupedResult){
            contactRoleCount.put(Id.valueOf(String.valueOf(ar.get('IB_Contact__c'))), Integer.valueOf(ar.get('expr0')));
        }
        
        for(AggregateResult ar:groupedHSResult){
            contactHSRoleCount.put(Id.valueOf(String.valueOf(ar.get('IB_Contact__c'))), Integer.valueOf(ar.get('expr0')));
        }
        
        System.debug('contactRoleCount=>'+contactRoleCount);
        List<User> usersToUpdateProfile = new List<User>();
        
        for(Id c:contactIds){
            Integer confirmedRoleCount = contactRoleCount.get(c);
            Integer confirmedHSRoleCount = contactHSRoleCount.get(c);
            User u = contactToUser.get(c);
            if(u != null){
                if (confirmedHSRoleCount != null && confirmedHSRoleCount > 0){
                    if(contactToUser.get(c).Profile.Name != 'SCU + Advanced'){
                        u.ProfileId = profileMap.get('SCU + Advanced');
                        usersToUpdateProfile.add(u);
                    }
                } else if((confirmedRoleCount == null || confirmedRoleCount == 0) && (confirmedHSRoleCount == null || confirmedHSRoleCount == 0) ){
                    if(contactToUser.get(c).Profile.Name == 'Customer Community Advanced'){
                        u.ProfileId = profileMap.get('Customer Community Basic');
                        usersToUpdateProfile.add(u);
                    } else if (contactToUser.get(c).Profile.Name == 'SCU + Advanced'){
                        u.ProfileId = profileMap.get('SCU + Basic');
                        usersToUpdateProfile.add(u);
                    }
                } else if((confirmedRoleCount != null && confirmedRoleCount > 0) && (confirmedHSRoleCount == null || confirmedHSRoleCount == 0)){
                    if(contactToUser.get(c).Profile.Name == 'Customer Community Basic'){
                        u.ProfileId = profileMap.get('Customer Community Advanced');
                        usersToUpdateProfile.add(u);
                    } else if (contactToUser.get(c).Profile.Name == 'SCU + Basic'){
                        u.ProfileId = profileMap.get('SCU + Advanced');
                        usersToUpdateProfile.add(u);
                    }
                }
            }
        }
        
        system.debug('LIMITS: ' + Limits.getDMLStatements());
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.OptAllOrNone = false;
        system.debug('usersToUpdateProfile2: ' + usersToUpdateProfile);
        
        //if(u.Id == UserInfo.getUserId())
        Database.SaveResult [] updateResult = Database.update (usersToUpdateProfile, dmo);
        
        for(Database.SaveResult r : updateResult)    
        {
            if (!r.isSuccess())     
            {
                for (Database.Error e : r.getErrors())    
                { 
                    system.debug('GOT error: ' + e.getMessage());
                }    
            }   
        }
    }
    
    public static void deleteAllPSA(Set<Id> contactIds) {
        system.debug('PermissionSetMaintenance deleteAllPSA');
        List<User> users = [SELECT Id, ContactId, Profile.Name FROM User WHERE ContactId in :contactIds];
        List<PermissionSetAssignment> psasToDelete = new List<PermissionSetAssignment>();
        psasToDelete = [Select Id, AssigneeId from PermissionSetAssignment where AssigneeId in :users];
        Database.delete(psasToDelete,false);
        system.debug('PermissionSetMaintenance deleteAllPSA executed');
    }
    
    @future
    public static void permissionMaintenance(Set<Id> contactIds) {
        permissionMaintenanceNonFuture(contactIds);
    }
    
    public static void permissionMaintenanceNonFuture(Set<Id> contactIds) {
        //query all roles & applications for the set of contact ids grouped by contact id
        
        system.debug('contactIds: ' + contactIds);
        List<User> users = [SELECT Id, ContactId, Profile.Name FROM User WHERE ContactId in :contactIds];
        
        List<User> usersNeedPing = [SELECT Id FROM User 
                                    WHERE ContactId in :contactIds 
                                    AND ContactId in (SELECT IB_Contact__c FROM IB_Role__c WHERE Status__c = 'Confirmed' AND (End_Date__c = null OR End_Date__c > TODAY))
                                    AND Id not in (Select AssigneeId FROM PermissionSetAssignment WHERE PermissionSet.Name = 'Ping_Federate_Identity_Provider')];
        
        Map<Id,Id> contactToUser = new Map<Id,Id>();
        Set<Id> userIds = new Set<Id>();
        for(User u:users){
            contactToUser.put(u.ContactId,u.Id);
            userIds.add(u.Id);
        }
        
        //we only want to return contacts that have a user account
        //List<Contact> contacts = [SELECT Id FROM Contact WHERE ID in :contactToUser.keySet()];
        
        //Added Programme_Selection__c as a part of CSM and DAS 
        List<IB_Role__c> rolesAndApplications = [SELECT IB_Contact__c,Programme_Selection__c, Id, isDeleted, IB_Role_Name__c, Permission_Set_Name__c, Status__c, End_Date__c FROM IB_Role__c WHERE IB_Contact__c in :contactIds all rows  ];
        
        Map<Id,Map<String,Boolean>> permissionSets = new Map<Id,Map<String,Boolean>>();
        Set<String> permissionSetNames = new Set<String>();
        Map<String,Id> permissionMap = new Map<String,Id>();
        Map<String,Boolean> permission;
        Id userId;
        Map<String, boolean> finalPermissions = new Map<String,boolean>(); // added by kashyap
        
        
        Map<Id,List<IB_Role__c>> contacts = new Map<Id,List<IB_Role__c>>();
        
        for(IB_Role__c r:rolesAndApplications){
            List<IB_Role__c> appsForContact = contacts.get(r.IB_Contact__c);
            if(appsForContact == null){
                appsForContact = new List<IB_Role__c>();
                appsForContact.add(r);
            } else {
                appsForContact.add(r);
            }
            contacts.put(r.IB_Contact__c,appsForContact);
        }
        
        system.debug('Contacts: ' + contacts);
        
        for(Id c:contacts.keySet()){
            userId = contactToUser.get(c);
            system.debug('userid: ' + userid);
            system.debug('contacttouser: ' + contacttouser);
            permission = permissionSets.get(userId);
            // assignIbAnswersPermission added as part of CSM module 
            Boolean assignIbAnswersPermission = false;
            for(IB_Role__c r:contacts.get(c)){
                system.debug('role: ' + r);
                system.debug('Permission: ' + permission);
                if(r.Status__c == 'Confirmed' && assignIbAnswersPermission == false){
                    assignIbAnswersPermission = true;
                }
                if(r.Permission_Set_Name__c != null && r.Permission_Set_Name__c != ''){
                    permissionSetNames.add(r.Permission_Set_Name__c);
                    if(permission == null){
                        permission = new Map<String,Boolean>();
                        if(r.isDeleted == false){
                            if(r.Status__c == 'Confirmed' && (r.End_Date__c == null || r.End_Date__c > Date.Today())){
                                permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,true);
                            } else if(r.Status__c != 'Confirmed'){
                                 permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c ,false);
                            } else if(r.End_Date__c != null && r.End_Date__c <= Date.Today()){
                                permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c ,false);
                            }
                        } else {
                            permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c ,false);
                        }
                    } else {
                        Boolean hasAccess = permission.get(r.Permission_Set_Name__c+':'+r.Programme_Selection__c);
                        system.debug('hasAccess: ' + hasAccess);
                        if(hasAccess == null){
                            if(r.isDeleted == false){
                                if(r.Status__c == 'Confirmed' && (r.End_Date__c == null || r.End_Date__c > Date.Today())){
                                    permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,true);
                                    
                                } else if(r.Status__c != 'Confirmed'){
                                    permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,false);
                                    
                                } else if(r.End_Date__c != null && r.End_Date__c <= Date.Today()){
                                    permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,false);
                                    
                                }
                            } else {
                                permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,false);
                                
                            }
                        } else {
                            if(r.Status__c == 'Confirmed' && (r.End_Date__c == null || r.End_Date__c > Date.Today()) && r.isDeleted == false){
                                permission.put(r.Permission_Set_Name__c+':'+r.Programme_Selection__c,true);
                            }
                        }
                    }
                    
                }
                
            }
            
            if(permission == null){
                permission = new Map<String,Boolean>();
            }
            if(assignIbAnswersPermission == false){
                permission.put(IB_ANSWERS_PERMISSION_SET,false);
            }else{
                permission.put(IB_ANSWERS_PERMISSION_SET,true);
            }
            permissionSets.put(userId,permission);      
        }
        
           if(permission!= null && !permission.isEmpty()){
            system.debug('permission: ' + permission);
            for(String key:permission.keySet()){
                system.debug('key**'+key);
                
                if(key =='Programme_Coordinator:CP' || key =='Programme_Coordinator:DP' )
                {
                    if(permission.get(key) == true){
                        finalPermissions.put('PGQA_SIPGE_Forms_Visibility', true);
                        permissionSetNames.add('PGQA_SIPGE_Forms_Visibility');
                        finalPermissions.put('Chief_Invigilator', true);//Added for DAS 
                        permissionSetNames.add('Chief_Invigilator');//Added for DAS
                     }else
                    {
                        if(finalPermissions.get('PGQA_SIPGE_Forms_Visibility')!= true ){
                            finalPermissions.put('PGQA_SIPGE_Forms_Visibility', false);
                            permissionSetNames.add('PGQA_SIPGE_Forms_Visibility');
                            permissionSetNames.add('Chief_Invigilator');//Added for DAS
                            finalPermissions.put('Chief_Invigilator', false);//Added for DAS
                       }
                    }
                }
                if(key =='Head_of_School:CP' || key =='Head_of_School:DP' )
                {
                    if(permission.get(key) == true){
                        finalPermissions.put('PGQA_SIPGE_Forms_Visibility', true);
                        permissionSetNames.add('PGQA_SIPGE_Forms_Visibility');
                    }
                    else
                    {
                        if(finalPermissions.get('PGQA_SIPGE_Forms_Visibility')!= true ){
                            finalPermissions.put('PGQA_SIPGE_Forms_Visibility', false);
                            permissionSetNames.add('PGQA_SIPGE_Forms_Visibility');
                        }
                    }
                }
            }
            
            system.debug('finalPermissions**'+finalPermissions);
            
            for(String key:permission.keySet()){
                if(key.contains(':')){
                    String permissionSetName = key.substringBefore(':');
                    if(!finalPermissions.containsKey(permissionSetName)){
                        if(permission.get(key)== true){
                            finalPermissions.put(permissionSetName,true);
                        }else
                        {
                            finalPermissions.put(permissionSetName,false);
                        }
                    }else
                    {
                        if(finalPermissions.get(permissionSetName) == false){
                            if(permission.get(key)== true){
                                finalPermissions.remove(permissionSetName);
                                finalPermissions.put(permissionSetName,true);
                            }
                       }
                        
                    }
                }
            }
            
        }
            permissionSets.put(userId,finalPermissions);
            system.debug('permissionSets**'+permissionSets);
            system.debug('permissionSetNames**'+permissionSetNames);
            
        //create map of all permission sets that are included
        List<PermissionSet> psets = [SELECT Id, Name 
                                     FROM PermissionSet 
                                     WHERE Name in :permissionSetNames
                                     OR Name = 'Ping_Federate_Identity_Provider' OR Name =: IB_ANSWERS_PERMISSION_SET];
        
        for(PermissionSet ps:psets){
            permissionMap.put(ps.Name,ps.Id);
        }
        
        List<PermissionSetAssignment> psasToInsert = new List<PermissionSetAssignment>();
        List<PermissionSetAssignment> psasToRemove = new List<PermissionSetAssignment>();
        Map<Id,Set<Id>> psaToRemoveMap = new Map<Id,Set<Id>>();
        
        //loop over all users who need Ping
        for(User u:usersNeedPing){
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.PermissionSetId = permissionMap.get('Ping_Federate_Identity_Provider');
            psa.AssigneeId = u.Id;
            psasToInsert.add(psa);
        }
        
        //loop over all users included:
        for(ID u:userIds){
            permission = permissionSets.get(u);
            if(permission != null){
                for(String s:permission.keySet()){
                    PermissionSetAssignment psa = new PermissionSetAssignment();
                    psa.PermissionSetId = permissionMap.get(s);
                    psa.AssigneeId = u;
                    if(permission.get(s) == true){
                        psasToInsert.add(psa);
                    } else {
                        //psasToRemove.add(psa);
                        Set<Id> curAssignment = psaToRemoveMap.get(u);
                        if(curAssignment==null){
                            curAssignment = new Set<Id>();
                            curAssignment.add(psa.PermissionSetId);
                        } else {
                            curAssignment.add(psa.PermissionSetId);
                        }
                        psaToRemoveMap.put(u,curAssignment);
                    } 
                }
            }
        }
        
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.OptAllOrNone = false;
        Database.insert (psasToInsert, dmo);
        
        //query back all permissionsetassignments for users that may have permissionsets to delete:
        
        List<PermissionSetAssignment> psaForUsers = [SELECT ID,PermissionSetId,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId in :psaToRemoveMap.keySet()];
        
        for(PermissionSetAssignment p:psaForUsers){
            Set<Id> curAssignment = psaToRemoveMap.get(p.AssigneeId);
            if(curAssignment != null){
                if(curAssignment.contains(p.PermissionSetId)){
                    psasToRemove.add(new PermissionSetAssignment(Id = p.Id));
                }
            }
        }
        
        Database.delete (psasToRemove,false);
    }
    
    @future
    public static void contactTypeMaintenance (Set<Id> contactIds){
        
        AggregateResult[] groupedResult = [SELECT IB_Contact__c,IB_Role__r.Role_Type__c, count(id)
                                           FROM IB_Role__c
                                           WHERE Status__c NOT IN ('Withdrawn','Declined')
                                           AND (End_Date__c = NULL OR End_Date__c > TODAY)
                                           AND IB_Contact__c in :contactIds
                                           GROUP BY IB_Contact__c,IB_Role__r.Role_Type__c];
        
        List<Contact> contactRoleTypesQuery = [SELECT Contact_Type__c,Id
                                               FROM Contact
                                               WHERE Id in :contactIds];
        
        Map<String,Set<String>> contactRoleTypeOld = new Map<String,Set<String>>();
        
        for (Contact c:contactRoleTypesQuery) {
            
            Set<String> roleTypeSet = new Set<String>();
            
            if (c.Contact_Type__c != null && c.Contact_Type__c.contains(':')) {
                
                roleTypeSet.addAll(c.Contact_Type__c.split(';'));
                
            } else if (c.Contact_Type__c != null) {
                
                roleTypeSet.add(c.Contact_Type__c);
                
            }
            
            contactRoleTypeOld.put(c.Id,roleTypeSet);
            
        }
        
        //contact role type
        Map<String, Set<String>> contactRoleTypeNew = new Map<String, Set<String>>();
        Set<String> roleTypesForContact = new Set<String>();
        
        for (AggregateResult ar:groupedResult) {
            
            String contactId = String.valueOf(ar.get('IB_Contact__c'));
            String roleType = String.valueOf(ar.get('Role_Type__c'));
            
            roleTypesForContact = contactRoleTypeNew.get(contactId);
            
            if (roleTypesForContact == null) {
                
                roleTypesForContact = new Set<String>();
                
            }
            
            if (roleType == 'IBEN Role') {
                
                roleTypesForContact.add('IBEN');
                
            } else if(roleType == 'School Role') {
                
                roleTypesForContact.add('School Services');
                
            }
            
            contactRoleTypeNew.put(contactId,roleTypesForContact);
        }                       
        
        
        system.debug('1: ' + contactRoleTypeOld);
        system.debug('2: ' + contactRoleTypeNew);
        
        List<Contact> updateContacts = new List<Contact>();
        
        for (Id i:contactIds) {
            
            Set<String> oldContactType = contactRoleTypeOld.get(i);
            Set<String> newContactType = contactRoleTypeNew.get(i);
            
            String contactType = '';
            Boolean isChanged = false;
            
            system.debug('newcontacttype:' + newContactType);
            system.debug('oldcontacttype:' + oldContactType);
            
            if (newContactType != null) {
                
                if (oldContactType != null) {
                    
                    for (String s:newContactType) {
                        
                        if (!oldContactType.contains(s)) {
                            
                            isChanged = true;
                            oldContactType.add(s);
                            
                            if(oldContactType.contains('New Registrant')) {
                                oldContactType.remove('New Registrant');
                            }
                            
                        }
                    }
                    
                } else {
                    
                    oldContactType = new Set<String>();
                    
                    for (String s:newContactType) {
                        
                        if (!oldContactType.contains(s)) {
                            isChanged = true;
                            oldContactType.add(s);
                        }
                        
                    }
                    
                }
                
            }
            
            if (isChanged) {
                
                for (String s:oldContactType) {
                    contactType += (contactType==''?'':';')+s;
                }
                
                updateContacts.add(new Contact(id = i, Contact_Type__c = contactType));
                
            } 
            
        }
        
        system.debug('updateContacts: ' + updateContacts);
        
        if (updateContacts.size() > 0) {
            
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.OptAllOrNone = false;
            Database.update (updateContacts, dmo);
            
        }
        
    }
    
}