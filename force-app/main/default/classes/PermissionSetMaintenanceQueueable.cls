public class PermissionSetMaintenanceQueueable implements Queueable{
    
    Set<ID> contactIDs = new Set<ID>();
    public PermissionSetMaintenanceQueueable(Set<ID> conIDs)
    {
        this.contactIDs = conIDs;
    }
    
    public void execute(QueueableContext context)
    {
        PermissionSetMaintenance.updateIBENActiveStatus(contactIds); //only future call
        PermissionSetMaintenance.profileMaintenanceNonFuture(contactIds); 
        System.debug('PermissionSetMaintenanceQueueable###  profileMaintenanceNonFuture executed');
        PermissionSetMaintenance.permissionMaintenanceNonFuture(contactIds);
        System.debug('PermissionSetMaintenanceQueueable###  permissionMaintenanceNonFuture executed');
        
    }
}