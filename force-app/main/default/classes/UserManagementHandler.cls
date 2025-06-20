public with sharing class UserManagementHandler {
    
    @InvocableMethod(label='Unfreeze User and Reset Password' description='Unfreezes a user if they are frozen and resets their password')
    public static void unfreezeAndResetPassword(List<Input> inputRecords) {
        
        List<Id> userIds = new List<Id>();
        
        for(Input temp : inputRecords)
        {
            if (temp.userId == null) {
                System.debug('No user IDs provided.');
                return;
            }
            
            userIds.add(temp.userId);
        }
        
        activateUsers(userIds);
        
        unfreezeUsers(userIds);
        
        if(inputRecords.size() > 0)
        {
            String recordData = convertListToJSON(inputRecords);
            
            // Send password reset asynchronously to avoid mixed DML issues
            resetUserPasswordsAsync(recordData);
        }
    }
    
    @future
    private static void resetUserPasswordsAsync(String recordData) {
        
        List<Input> records = convertJSONToList(recordData);
        
        for (Input temp : records) {
            try {
                System.resetPassword(temp.userId, true); // False means no email sent
                Logger.get().add('UserManagementHandler: Password reset initiated for User: ' + temp.userId, LogSeverity.DEBUG).publish();
            } catch (Exception e) {
                Logger.get().add('UserManagementHandler: Error resetting password for User: ' + temp.userId + ' - ' + e.getMessage(), LogSeverity.ERROR).publish();
                break;
            }
            
            Case tempCase = new Case(Id=temp.caseId);
            
            try{
                tempCase.Disposition__c = temp.disposition;
                tempCase.Password_Reset_Date__c = temp.passwordResetDate;
                tempCase.Status = temp.caseClosureStatus;
                update tempCase;
                Logger.get().add('UserManagementHandler: Case successfully closed ' + tempCase.Id +'', LogSeverity.DEBUG).publish();
            } catch (Exception e) {
                // to do - add some error handling alert or field for reporting or logging tool
                Logger.get().add('UserManagementHandler: Error updating case: ' + tempCase.Id + ' - ' + e.getMessage(), LogSeverity.ERROR).publish();
                break;
            }
        }
    }
    
    public static String convertListToJSON(List<Input> inputList) {
        return JSON.serialize(inputList);
    }
    
    public static List<Input> convertJSONToList(String jsonString) {
        return (List<Input>) JSON.deserialize(jsonString, List<Input>.class);
    }
    
    public static void activateUsers(List<Id> inputList)
    {
        List<User> users = ([SELECT Id, IsActive FROM User WHERE Id IN :inputList]);
        
        List<User> usersToUpdate = new List<User>();
        
        for(User tempUser : users)
        {
            if(tempUser.IsActive == false)
            {
                tempUser.IsActive = true;
                
                usersToUpdate.add(tempUser);
            }
        }
        
        update usersToUpdate;
    }
    
    public static void unfreezeUsers(List<Id> inputList)
    {
        List<UserLogin> userLoginsToUpdate = new List<UserLogin>();
        
        List<UserLogin> userLogins = [SELECT Id, UserId, IsFrozen 
                                          FROM UserLogin 
                                          WHERE UserId IN :inputList];
        
        for (UserLogin ul : userLogins) {
            if (ul.IsFrozen) {
                ul.IsFrozen = false;
                userLoginsToUpdate.add(ul);
            }
        }
        
        // Unfreeze users
        if (!userLoginsToUpdate.isEmpty()) {
            update userLoginsToUpdate;
        }
    }
    
    public class Input {
        
        @InvocableVariable(required=true)
        public Id caseId;
        
        @InvocableVariable(required=true)
        public Id userId;
        
        @InvocableVariable(required=true)
        public String disposition;
        
        @InvocableVariable(required=true)
        public Date passwordResetDate;
        
        @InvocableVariable(required=true)
        public String caseClosureStatus;
    }
}