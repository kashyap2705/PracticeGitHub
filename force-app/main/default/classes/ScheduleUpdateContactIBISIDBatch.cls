global class ScheduleUpdateContactIBISIDBatch implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        UpdateContactIBISIDBatch batch = new UpdateContactIBISIDBatch();
        Database.executeBatch(batch, 1);
    }
    
}