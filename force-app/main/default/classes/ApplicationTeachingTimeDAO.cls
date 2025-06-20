public class ApplicationTeachingTimeDAO {

	private static final ApplicationTeachingTimeDAO instance = new ApplicationTeachingTimeDAO();
     private Application_Teaching_Time__c att;

	public static ApplicationTeachingTimeDAO getInstance() {
          return instance;
     }

     public Application_Teaching_Time__c getApplicationTeachingTimeById(Id attId) {

          att = [
			SELECT Id, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Other_Activities__c, B2_10a_1_Single_Subject__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Year_Grade__c, B2_10c_1_Number_Weeks__c,
				B2_10c_1_Subject_Group__c, B2_10c_1_Teaching_Time__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c
			FROM Application_Teaching_Time__c
			WHERE Id = :attId
		];

		return att;
	}
}