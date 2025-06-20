global class RejectRoleApplicationSchedule implements Schedulable{
 global void execute(SchedulableContext sc) {
        RejectRoleApplicationBatchClass b = new RejectRoleApplicationBatchClass();
        	Database.executeBatch (b);
    }
}