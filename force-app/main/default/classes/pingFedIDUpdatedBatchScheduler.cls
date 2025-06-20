/**
* pingFedIDUpdatedBatchScheduler
* This class is created to schedule pingFedIDUpdate batch class to run on everyday
* 
* @author  Arunkumar Kathiravan
* @version 1.0
* @since   2021-08-19 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
global class pingFedIDUpdatedBatchScheduler implements Schedulable{
    global void execute(SchedulableContext sc){
        pingFedIDUpdate tb = new pingFedIDUpdate();
        Id batchId = Database.executeBatch(tb, 20); 
    }
}