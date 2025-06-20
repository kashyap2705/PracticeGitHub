global class SchduleChatterEmailSendingDeactivate  implements schedulable
{
     global void execute(SchedulableContext sc)
    {
    ChatterEmailSendingDeactivate classObjectEmailDeactivate = new ChatterEmailSendingDeactivate(); //ur batch class
      database.executebatch(classObjectEmailDeactivate);
    }

}