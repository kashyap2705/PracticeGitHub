public class DeleteOlderInvitedRolesSchedule implements Schedulable{
    
    public void execute(SchedulableContext sc)
        {
            PimsQueuableDeleteOlderRoles deleteOlderInvitedRoles = new PimsQueuableDeleteOlderRoles();
            System.enqueueJob(deleteOlderInvitedRoles);
        }

}