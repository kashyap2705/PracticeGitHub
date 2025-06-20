global class WeeklyEmail implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
      
      WeeklyEmailBatch b = new WeeklyEmailBatch (); //ur batch class
      database.executebatch(b,10);
      
    }
}