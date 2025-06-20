global class ScheduleUserDeactivation5DayWarning implements schedulable {
    
    global void execute(SchedulableContext sc)
    {
        UserDeactivation5DayWarning userDeactivationWarningBatch = new UserDeactivation5DayWarning();
        database.executebatch(userDeactivationWarningBatch);
    }
}