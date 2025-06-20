@isTest
private class SchoolSectionsDAOTest {
	
	@isTest static void test_method_one() {
        integer i=1;
		SchoolSectionsDAO ssDAO = SchoolSectionsDAO.getInstance();

		User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'August', 'May',true);

		insert u;

		Contact c = [SELECT AccountId FROM Contact WHERE ID = :u.ContactId];

		List<SchoolSections__c> schoolSectionsByAccount = ssDAO.getSchoolSectionsByAccountId(c.AccountId);
        SchoolSectionsDAO.sections = null;
		ssDAO.getSchoolSectionsByAccountIdForCurrentYear(c.AccountId);
	}
}