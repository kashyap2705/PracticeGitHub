global class ScheduleUserDeactivate  implements schedulable {
    
    
     global void execute(SchedulableContext sc)
    {
    UserDeactivateClass classObjectUserDeactivate = new UserDeactivateClass(); //ur batch class
      database.executebatch(classObjectUserDeactivate);
    }

}