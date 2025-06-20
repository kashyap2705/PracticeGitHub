global class ScheduledDeactivateUsers implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        // gets the number of days without a role to check the users
        DeactivateUserSettings__c dus = DeactivateUserSettings__c.getValues('DaysWithoutRole');
        Integer daysWithoutRole = Integer.valueOf(dus.Value__c);
        
        Date d = System.today() - daysWithoutRole;
        
		// limit the users being selected by profile and date created       
        List<User> usersToDeactivate = [
            SELECT Id, Name, IsActive, ContactId, CreatedDate, ProfileId, Profile.Name
            FROM User 
            WHERE IsActive = true
            AND Profile.Name = 'Customer Community Basic' 
            AND CreatedDate < :d 
            LIMIT 10
        ];
        
        if (usersToDeactivate.size() == 0) {
            return;
        }
        
        List<Id> allContactsList = new List<Id>();
        for (User usr : usersToDeactivate) {
            allContactsList.add(usr.ContactId);
        }
        
        List<IB_Role__c> roles = [
        	SELECT Id, Name, IB_Contact__c 
            FROM IB_Role__c 
            WHERE IB_Contact__c IN :allContactsList
        ];
        
        Set<Id> roleContactSet = new Set<Id>();
        for (IB_Role__c role : roles) {
        	roleContactSet.add(role.IB_Contact__c);	   
        }
        
        Integer i = 0;
        while (i < usersToDeactivate.size()) {
            if (roleContactSet.contains(usersToDeactivate.get(i).ContactId)) {
                usersToDeactivate.remove(i);
            }
            else {
                usersToDeactivate.get(i).IsActive = false;
                i++;
            }
        }
        
        if (usersToDeactivate.size() == 0) {
            return;
        }
        
        update usersToDeactivate;
        
    }

}