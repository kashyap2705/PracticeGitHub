@isTest
private class AccountTest {

    //PimsTestUtil
    @isTest
    static void testAccountService() {

          Account acc = PimsTestUtil.createAccount('Test Class Account', '');
          insert acc;

          AccountService.setAccountId(acc.Id);
		Account testGetAccount = AccountService.getAccount();

		System.assert(testGetAccount != null);

    }

    @isTest
    static void testAccountDAONotCoveredByService() {

          AccountDAO accDAO = AccountDAO.getInstance();

		Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
		insert acc;

		List<Account> searchAccByName = accDAO.searchAccountsByName('Test Account');
		system.assertEquals(searchAccByName.size(), 1);

		List<Account> searchAccByNameAndRecordType = accDAO.searchAccountsByNameAndType('Test Account','Association Account');
		system.assertEquals(searchAccByNameAndRecordType.size(), 1);


    }

}