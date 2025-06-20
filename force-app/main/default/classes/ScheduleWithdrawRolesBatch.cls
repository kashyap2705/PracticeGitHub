global class ScheduleWithdrawRolesBatch implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        WithdrawRolesBatch withdrawBatch = new WithdrawRolesBatch();
        Database.executebatch(withdrawBatch, 20);
    }
    
}