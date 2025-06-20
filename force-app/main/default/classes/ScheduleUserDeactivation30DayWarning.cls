global class ScheduleUserDeactivation30DayWarning implements schedulable {
    
    global void execute(SchedulableContext sc)
    {
        UserDeactivation30DayWarning userDeactivationWarningBatch = new UserDeactivation30DayWarning();
        database.executebatch(userDeactivationWarningBatch);
    }
}