/**
* <h1>Schudule userDeactiveOrFreezeClass</h1>
* This Class is responsible for scheduling userDeactiveOrFreezeClass,DE6118.
* @author  Ahmad Shakeel.
* @version 1.0
* @since   10-10-2019.

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
global class ScheduleUserFreezeAndDeactivate implements Schedulable{
    
    
     /**
   * This method Will call userDeactiveOrFreezeClass.
   * @param SchedulableContext.
   * @return Void.
   */
    global void execute(SchedulableContext sc)
    {
        userDeactiveOrFreezeClass classObjectUserDeactivateFreeze = new userDeactiveOrFreezeClass();
        if(Test.isRunningTest())
        {
            classObjectUserDeactivateFreeze.testingDate=Date.today().addDays(-200);
        }//ur batch class
         if(Test.isRunningTest())
        {
            classObjectUserDeactivateFreeze.testingDate=Date.today().addDays(-100);
        }//ur
        database.executebatch(classObjectUserDeactivateFreeze);
    }

}