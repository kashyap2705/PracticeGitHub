public class CountrySegmentationDAO {

	private static final CountrySegmentationDAO instance = new CountrySegmentationDAO();

	private CountrySegmentationDAO() {}

	public static CountrySegmentationDAO getInstance() {
		return instance;
	}

	public List<IB_Country_Segmentation__c> getAllCountries() {

		List<IB_Country_Segmentation__c> countries = [
			SELECT Id, Name, Country_fr__c, Country_es__c
			FROM IB_Country_Segmentation__c 
			ORDER BY Name ASC
		];

		return countries;

	}

}