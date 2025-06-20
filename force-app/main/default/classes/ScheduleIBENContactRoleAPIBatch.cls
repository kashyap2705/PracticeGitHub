global class ScheduleIBENContactRoleAPIBatch implements Schedulable{
    global void execute(SchedulableContext sc)
    {
        IBENContactRoleCustomObjAPIBatch CustomObjAPIwithdrawBatch = new IBENContactRoleCustomObjAPIBatch();
        Database.executebatch(CustomObjAPIwithdrawBatch,1);
        system.abortJob(sc.getTriggerId());
    }
    
}