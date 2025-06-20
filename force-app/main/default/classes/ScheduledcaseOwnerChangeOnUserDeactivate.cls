global class ScheduledcaseOwnerChangeOnUserDeactivate implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        caseOwnerChangeOnUserDeactivate executeBatchClass = new caseOwnerChangeOnUserDeactivate();
        database.executeBatch(executeBatchClass);
    }   
}