//This Schedulable apex is writtened by prerna on 07-03-2025 for ECM00739- PART-1 
//It is designed to call IBProgrammeBatch batch apex
global class IBProgrammeBatchScheduler implements Schedulable {

    global void execute(SchedulableContext ctx){
    	IBProgrammeBatch ibProgrammeBatch = new IBProgrammeBatch();
      	Database.executebatch(ibProgrammeBatch, 200);
    }
}