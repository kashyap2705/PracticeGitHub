public class SchoolSectionsService { 

	public static List<SchoolSections__c> sections = null;
	public static Boolean isSectionsCached = false;

	public static Id accountId = null;

	public static List<SchoolSections__c> getSectionsByAccount() {

		if (!isSectionsCached) {

			if (accountId == null) {
				throw new CustomValidationException('The value for accountId cannot be null.');
			}

			SchoolSectionsDAO dao = SchoolSectionsDAO.getInstance();
			sections = dao.getSchoolSectionsByAccountId(accountId);
			isSectionsCached = true;

		}

		return sections;

	}

	public static void setAccountId(Id accId) {
		accountId = accId;
	}

}