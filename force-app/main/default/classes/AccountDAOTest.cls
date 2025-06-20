@isTest
private class AccountDAOTest {
	
	@isTest static void test_method_one() {
		AccountDAO accDAO = AccountDAO.getInstance();

		Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
		insert acc;

		Account searchAccById = accDAO.getAccountById(acc.id);

		system.assertEquals(searchAccById.Name, acc.Name);

		List<Account> searchAccByName = accDAO.searchAccountsByName('Test Account');

		system.assertEquals(searchAccByName.size(), 1);

		List<Account> searchAccByNameAndRecordType = accDAO.searchAccountsByNameAndType('Test Account','Association Account');

		system.assertEquals(searchAccByNameAndRecordType.size(), 1);

	}

}