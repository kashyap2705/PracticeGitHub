global class SharingContactBatchSch implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
      
      SharingContactBatch b = new SharingContactBatch(); 
      database.executebatch(b,100);
      
    }
}