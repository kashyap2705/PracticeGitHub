public class RecordTypeDAO {

	public static final RecordTypeDAO instance = new RecordTypeDAO();

	public List<RecordType> recordTypes;

	public RecordTypeDAO() {}

	public static RecordTypeDAO getInstance() {
		return instance;
	}

	public List<RecordType> getRecordTypes() {

		recordTypes = [
			SELECT Id, Name, sObjectType, DeveloperName 
			FROM RecordType
		];

		return recordTypes;

	}

// THE FOLLOWING METHODS AND VARS ARE USED EXCLUSIVELY IN IBEN CENTRAL PORTAL
	public RecordType getRecordTypeByNameAndsObjectType (String name, String sObjectType ) {

		if ( String.isBlank(name)) {
			throw new DAOException(' Name can not be null or empty string !!');
		}

		if ( String.isBlank( sObjectType)) {
			throw new DAOException(' sObjectType can not be null or empty string !!');
		}

		List<RecordType> result = [
			SELECT r.SobjectType, r.Name, r.Id 
			FROM RecordType r 
			WHERE r.Name = :name 
			AND SobjectType = :sObjectType
		];

		if (null == result || result.isEmpty()) {
			return null;
		}

		return result.get(0);

	}

}