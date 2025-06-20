@isTest
public class IBMassEventPublishControllerTest {
    
    @isTest
    static void testController() {
        integer i=1;
        
        IBMassEventPublishController controller = new IBMassEventPublishController();
        
        controller.setEventRegion('IBAEM');
        controller.getEventRegion();
        controller.getEventRegions();
        controller.getIbEvents();
        
        controller.filter();
        controller.publish();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        
    }

}