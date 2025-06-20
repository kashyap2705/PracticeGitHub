public without sharing class ConsultantFeedbackDAO {

	public static final ConsultantFeedbackDAO instance = new ConsultantFeedbackDAO();

	private ConsultantFeedbackDAO(){}

	//holds parent fields that are left out of the select all
	public static List<String> parentFields = new List<String>{
		',IB_Application__r.A1_5_Other__c',
		'IB_Application__r.A1_5_com_fac__c',
		'IB_Programme_Lookup__r.Account__r.Website',
		'IB_Programme_Lookup__r.Name',
		'IB_Programme_Lookup__r.Account__r.Name'
	};

	//Build select all query string
	public String buildQueryString(){

		DescribeSObjectResult describeResult = IB_Consultant_Feedback__c.getSObjectType().getDescribe();
		List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

		return 'SELECT ' + String.join(fieldNames, ',') + String.join(parentFields, ',') + ' FROM ' + describeResult.getName();
	}

	public IB_Consultant_Feedback__c getRecordById(String i){

		if(String.isEmpty(i)){
			return null;
		}

		String str = buildQueryString();
		str += ' WHERE Id = \'' + i + '\'';

		return Database.query(str);
	}

	public List<IB_Consultant_Feedback__c> getRecordsByAppId(String appId){

		if(String.isEmpty(appId)){
			return null;
		}

		String str = buildQueryString();
		str += (' WHERE IB_Application__c = \'' + appId + '\'');

		return Database.query(str);
	}

	public static ConsultantFeedbackDAO getInstance(){
		return instance;
	}
}