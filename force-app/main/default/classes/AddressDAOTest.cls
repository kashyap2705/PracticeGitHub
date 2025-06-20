@isTest
private class AddressDAOTest {
	
	@isTest static void test_method_one() {
		AddressDAO addrDAO = AddressDAO.getInstance();

		Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;
        
        IB_Country_Segmentation__c cou = PimsTestUtil.createIBACountrySegmentation('United States','US','US');
        insert cou;
		
		IB_Address__c addr = PimsTestUtil.createAddress('Billing', '1 Test St', 'Palm Coast', '32137', cou.Id, acc);
		insert addr;

		IB_Address__c addrById = addrDAO.getAddressById(addr.Id);
		system.assertEquals(addrById.Name,addr.Name);

		IB_Address__c addrByTypeAndAccount = addrDAO.getAddressByTypeAndAccount('Billing',acc.Id);
		system.assertEquals(addrByTypeAndAccount.Name,'Billing');

		IB_Address__c addrByTypeAndAccount2 = addrDAO.getAddressByTypeAndAccount('Mailing',acc.Id);
		system.assertEquals(addrByTypeAndAccount2.Name,'Mailing');

		List<IB_Address__c> addrByAccount = addrDAO.getAllAddressesByAccount(acc.Id);
	}	
}