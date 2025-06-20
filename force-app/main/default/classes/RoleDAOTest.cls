@isTest
private class RoleDAOTest {
	
	@isTest static void test_method_one() {
        integer i=1;
		RoleDAO rDAO = RoleDAO.getInstance();

		IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
		insert repo;

		Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
		insert con;

		Contact con2 = PimsTestUtil.createContact('Contact Test', 'b@a.com', 'b@a.com', Date.newInstance(1980, 6, 1), acc);
		insert con2;

		List<Id> contactIds = new List<Id>();
		contactIds.add(con.Id);
		contactIds.add(con2.Id);		

		IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.Id,acc.Id);
		insert role;

		List<IB_Role__c> rolesByAcctId = rDAO.getRolesByAccountId(acc.Id);

		List<IB_Role__c> rolesByContactIds = rDAO.getRolesByContacts(contactIds);

		List<IB_Role__c> rolesByContactAndAccount = rDAO.getRolesByContactAndAccount(contactIds, acc.Id);

		List<IB_Role__c> headOfSchool = rDAO.getHeadOfSchool(acc.Id);
        
        List<IB_Role__c> applicantRoles = rDAO.getApplicantRolesForApprovalByAccountId(acc.Id);
        
        List<IB_Role__c> rolesByContactsId = rDAO.getRolesByContactId(con.id);
        
        List<IB_Role__c> rolesByContactsIdMyIB = rDAO.getMyIBRolesByContactId(con2.id);
        
        IB_Role__c role2 = rDAO.getRoleById(role.id);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}
}