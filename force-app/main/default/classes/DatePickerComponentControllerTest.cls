@isTest
public class DatePickerComponentControllerTest {

    @isTest 
	static void testDatePickerComponentControllerTest() {
    
        DatePickerComponentController controller = new DatePickerComponentController();
        System.assertEquals(Date.Today().format(), controller.currentDate);
        
    }
    
}