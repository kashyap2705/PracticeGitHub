public class PageLockDAO {

	private static final PageLockDAO instance = new PageLockDAO();
	private List<PageLock__c> locksByProgramme;

	public static PageLockDAO getInstance() {
		return instance;
	}

	public List<PageLock__c> getPageLocksByProgrammeId(Id programmeId) {

		locksByProgramme = [
			SELECT Id, Name, Community__c, Page_Name__c, Page_Section__c, Locked_By__c, Locked_By__r.Name, Programme__c 
			FROM PageLock__c 
			WHERE Programme__c = :programmeId
		];

		return locksByProgramme;

	}

}