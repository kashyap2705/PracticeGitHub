public class ApplicationStaffTableDAO {

	private static final ApplicationStaffTableDAO instance = new ApplicationStaffTableDAO();
     private Application_Staff_Table__c appStaffTable;
	private List<Application_Staff_Table__c> appStaffTableList;

	public static ApplicationStaffTableDAO getInstance() {
          return instance;
     }

     public List<Application_Staff_Table__c> getApplicationLibraryResourcesByApplicationId(Id appId) {

		appStaffTableList = [
			SELECT Id, B2_2_2_Staff_Standards__c, B2_2_3_Full_Time__c, B2_2_4_Part_Time__c
			FROM Application_Staff_Table__c
			WHERE IB_Application_Lookup__c = :appId
		];

		return appStaffTableList;
	}
}