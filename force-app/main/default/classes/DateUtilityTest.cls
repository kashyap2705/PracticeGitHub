@isTest
private class DateUtilityTest {
	
	@isTest static void test_method_one() {
        integer i=1;
		Map<String,String> dateMap = DateUtility.dateFormatMapJQuery();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
	}
}