public class PageLockService {
	
	public static Boolean isCached = false;
	public static List<PageLock__c> locksByProgramme;
	public static Id programmeId = null;

	public static void queryProgrammePageLocks() {

		PageLockDAO dao = PageLockDAO.getInstance();
		locksByProgramme = dao.getPageLocksByProgrammeId(programmeId);
		isCached = true;

	}

	public static PageLock__c getPageLock(String pageName, String pageSection) {

		PageLock__c pageLock = null;

		if (!isCached) {
			queryProgrammePageLocks();
		}

		for (PageLock__c pl : locksByProgramme) {
			if (pl.Page_Name__c == pageName && pl.Page_Section__c == pageSection) {
				pageLock = pl;
				break;
			}
		}

		return pageLock;

	}

	public static void setProgrammeId(Id progId) {
		programmeId = progId;
	}

}