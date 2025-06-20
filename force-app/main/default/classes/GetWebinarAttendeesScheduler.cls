/*
* @description - This is used to schedule GetWebinarAttendeesBatch class.
*
* @author: Vikash Kumar
* @since 11-03-2025
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 11-03-2025     Created             US-0003047       Created the class
*/
global class GetWebinarAttendeesScheduler implements Schedulable {
   global void execute(SchedulableContext sc) {
      GetWebinarAttendeesBatch batchObj = new GetWebinarAttendeesBatch(); 
      Database.executeBatch(batchObj,1);
   }
}