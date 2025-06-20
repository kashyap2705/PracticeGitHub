global class PimsBatchReminderInvitedRolesScheduler implements Schedulable {
    
    global void execute (SchedulableContext SC){
        PimsBatchReminderInvitedRoles batchInvitedRoles = new  PimsBatchReminderInvitedRoles();
        database.executeBatch(batchInvitedRoles,10);
        
    }

}