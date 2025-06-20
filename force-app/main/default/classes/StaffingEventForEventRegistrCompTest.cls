@isTest
private class StaffingEventForEventRegistrCompTest {

    @isTest
    static void testInitialState(){
        
        StaffingEventForEventRegistrationComp comp = new StaffingEventForEventRegistrationComp();
        
        RegisterForEventsController parentController = new RegisterForEventsController();
        comp.setParentController(parentController);
        comp.getParentController();
     //   System.assert(comp.getParentController() == parentController);
    }
}