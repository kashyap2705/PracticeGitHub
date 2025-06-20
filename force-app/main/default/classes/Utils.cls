public class Utils {
    
    @future 
    public static void updateContacts(List<Id> newContactIds) {
        
        List<contact> records = new List<Contact>();
           
        List<User> userRecords = [ SELECT ID, ContactID FROM User WHERE ContactID IN :newContactIds ];
        
        for (User uss: userRecords) {
            Contact con = new Contact(id = uss.ContactID, User__c = uss.ID);
            records.add(con);
        }
        
        if (!records.isEmpty()) {
            update records;
        }
        
    }
    
    @future 
    public static void DisableUsers(Id userIdsss) { }
    
    @future 
    public static void updateUserProfile(Set<Id> newUserIds, Set<Id> cons) {  
        
        List<ID> newContactIds = new List<ID>();        
        
        try {
            
            List<User> userRecords = new List<User>();
            profile p = [SELECT ID FROM profile WHERE name = 'SCU + Advanced'];    
            
            for (Id userId : newUserIds) {
                User usr = new User(Id = userId, ProfileID = p.ID);
                userRecords.add(usr);
            }
            
            if (!userRecords.isEmpty()) {
                update userRecords;
            }
            
            if (cons.size() > 0) {
                PermissionSetMaintenance.deleteAllPSA(cons);
                PermissionSetMaintenance.permissionMaintenanceNonFuture(cons);
            }
            
        } catch(Exception e) {
            
            system.debug('An exception Occured : '+ e.getMessage());
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> strListEmail = System.Label.ibPortal_Exception_Emails_Recipients.split(',');
            
            mail.setToAddresses(strListEmail);
            mail.setSubject('Exception Notification');
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('There is an exception that occurred. Following are details: \nClass = Utils, \nMethod = updateUserProfile, \nInput User Ids = ' + newUserIds + ', \nInput Contact Ids = ' + cons + ', \nError Message = ' + e.getMessage() + '');
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });            
            
        }
        
    }
    
    @future 
    public static void updateUserProfileThroughContact(List<Id> contIds) {    
        
        List<ID> newContactIds = new List<ID>();
        
        try {

            List<User> userRecords = [ SELECT ID, ProfileID, Name, ContactID FROM User WHERE ContactID IN :contIds];
        
            if ( !UserRecords.isEmpty() ) {
                profile p1 = [SELECT ID FROM profile WHERE name = 'SCU + Advanced'];
            }
        
            if (! UserRecords.isEmpty() ) {
                update UserRecords;
            }

        } catch(Exception ee) {

			system.debug('An exception Occured : '+ ee.getMessage());

		}
        
    }
    
    @future 
    public static void updateRoles( List<ID> contIds, List<String> strProgrammeSelection, List<String> roleName) {
        
        List<IB_Role__c> Roles = [SELECT ID,IB_Contact__c,IB_Role_Name__c FROM IB_Role__c WHERE IB_Contact__c= :contIds AND Status__c = 'Confirmed' AND IB_Role_Name__c= :roleName AND Programme_Selection__c = :strProgrammeSelection ];
                
        for(IB_Role__c a: Roles ) {
            
            a.status__c = 'Withdrawn';
            a.Active__c = FALSE;
            a.End_Date__c = system.today();
            
        }
        
        if ( ! Roles.isEmpty() ) { 

            try {

				update Roles;

			} catch( exception ee) {

				system.debug('An exception Occured : '+ ee.getMessage());
                
			}            
        }
        
    }
    
    @future 
    public static void updateContactCreatedFromLead( List<ID> ContactIds) {
        
        List<contact> records = new List<Contact>();
        records =[ SELECT ID, Lead_type__c FROM Contact WHERE ID = :ContactIds ] ;
        
        List<contact> updateContacts = new List<contact>();
        
        for (Contact con: records) {   
            
            if (con.Lead_type__c != null) {
                con.Lead_type__c = null;
                updateContacts.add(con);
            }
            
        }
        
        if (! updateContacts.IsEmpty() ) {
            update updateContacts;
        }
        
    }    
    
    @future 
    public static void updateContactsTriggerUser(List<Id> newUserIds, List<ID> OldContactIds) {
        
        List<contact> records = new List<Contact>();
        List<ID> newContactIds = new List<ID>();
        List<Contact> contactRecords = [ SELECT ID, User__C FROM Contact WHERE ID IN :OldContactIds ] ;
        List<User> userRecords = [ SELECT ID, Name, ContactID FROM User WHERE ID IN :newUserIds  ];
        
        for (Contact con: contactRecords) { 
            
            for (User uss: userRecords) {
                
                if (  uss.ContactID == NULL && uss.ID == con.User__C  ) {
                    con.User__c = NULL; 
                }  
                
            }
            
            records.add(con); 
            
        }
                
        update records;
        
    }
    
    public class IBPortalValidationUtilPossibleAccountException extends Exception {}
    public class IBPortalValidationUtilDuplicateSchoolEmailException extends Exception {}
    
    @future 
    public static void updateContact_User(Set<Id> cnt_ids) {
        
        if (cnt_ids!=null) {
            
            Map<Id, Contact> mapCnt = new Map<Id, Contact>([SELECT Id, user__c FROM Contact WHERE Id IN :cnt_ids ]);
            List<Contact> listCnt  = new List<Contact>([SELECT Id, user__c FROM Contact WHERE Id IN :cnt_ids ]);
            
            for (Id i_d: cnt_ids) {
                
                for (Contact cnt :listCnt) {
                    
                    if (i_d != null && mapCnt.containsKey(i_d) && i_d==cnt.id) {
                        
                        cnt.user__c=null;
                        mapCnt.put(cnt.Id,cnt);
                        
                    }
                    
                }
                
            }
            
            update mapCnt.values(); 
            
        }
        
    }
    
    // @author: Arunkumar Kathiravan 
    // @since 30-4-2021
    // @description Update User__c field on Contact when contacts merge.
    // @param a map of user ids to contact ids
    // @return void.		
    
    @future 
    public static void updateCont_User(map<id, id> mapUserIdsToContIds) {
        
        list<Contact> contToUpd = new list<Contact>();
        
        if (mapUserIdsToContIds != null) {
            
            for (Id usrId : mapUserIdsToContIds.keySet()) {
                
                if (usrId != null && mapUserIdsToContIds.get(usrId) != null) {
                    Contact con = new Contact(Id = mapUserIdsToContIds.get(usrId), User__c = usrId);
                    contToUpd.add(con);
                }
                
            }
            
            if (!contToUpd.isEmpty()) {
                update contToUpd; 
            }
            
        }
        
    }
    
    @future public static void updateUserProfile(Set<Id> newUserIds) {    
        List<ID> newContactIds = new List<ID>();
        
        
        try{
            
            
            List<User> userRecords = [ SELECT ID,ProfileID, Name, ContactID from User where ID IN :newUserIds  ];
            profile p = [SELECT ID FROM profile WHERE name='SCU + Advanced'];    
            system.debug('These are the user records : ' + userRecords);
            
            for(User uss: userRecords)
            {
                
                uss.ProfileID = p.ID;
                
                
            }   
            update UserRecords;
            
        }catch(Exception ee)
        {
            system.debug('An exception Occured : '+ ee.getMessage());
        }  
    }
    
}