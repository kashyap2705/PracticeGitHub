public class RecordTypeService {

	public static Boolean isCached = false;
	public static List<RecordType> recordTypes = null;

	public static void queryRecordTypes() {

		RecordTypeDAO dao = RecordTypeDAO.getInstance();
		recordTypes = dao.getRecordTypes();
		isCached = true;

	}

	public static RecordType getRecordTypeByTypeAndName(String objectType, String devName) {

		string logTag = '[getRecordTypeByTypeAndName]';

		if (!isCached) {
			queryRecordTypes();
		}

		//6/14/2017 - michael.demeglio: added this because CP is not a valid Recordtype's DeveloperName (CP is the label and "IBCC" is the recordtype's developerName)
		if(devName.equalsIgnoreCase('CP')){ 
			System.debug(logTag + 'Converting CP to IBSS for recordtype query.. (temporary hack)');
			devName = 'IBCC';
		}

		System.debug(logTag + 'recordTypes: ' + recordTypes);

		for (RecordType recordType : recordTypes) {
			
			if (recordType.SobjectType == objectType && recordType.DeveloperName == devName) {
				System.debug(logTag + 'Match - found recordType [' + recordType + ']');
				return recordType;
			} /*else {
				System.debug(logTag + 'No Match for recordType: ' + recordType);
			}*/
		}

		return null;

	}

}