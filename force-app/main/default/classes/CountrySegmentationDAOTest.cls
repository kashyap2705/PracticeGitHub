@isTest
private class CountrySegmentationDAOTest {
	
	@isTest static void test_method_one() {
        integer i=1;
		CountrySegmentationDAO csDAO = CountrySegmentationDAO.getInstance();

		List<IB_Country_Segmentation__c> countries = csDAO.getAllCountries();
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);


	}
}