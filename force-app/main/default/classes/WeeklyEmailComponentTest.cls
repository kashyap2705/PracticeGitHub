@isTest
public class WeeklyEmailComponentTest {
@isTest
public static void test_component() {
        
        Test.startTest(); 
        WeeklyEmailComponentController obj =  new WeeklyEmailComponentController();
        obj.getcont();
        obj.getcor_count_cp();
        obj.getcor_count_dp();
        obj.getcor_count_myp();
        obj.getcor_count_pyp();
        obj.getcount_cp();
        obj.getcount_dp();
        obj.getcount_myp();
        obj.getcount_pyp();
    
        Test.stopTest();
    }
}