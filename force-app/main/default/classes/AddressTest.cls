@isTest
private class AddressTest {

    @isTest 
    static void testAddressService() {
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;
        
        IB_Country_Segmentation__c cou = PimsTestUtil.createIBACountrySegmentation('United States','US','US');
        insert cou;
		
		IB_Address__c addr = PimsTestUtil.createAddress('Billing', '1 Test St', 'Palm Coast', '32137', cou.Id, acc);
		insert addr;
        
        try { 
            AddressService.getAddress();
        } catch (Exception ex) { }
        try { 
            AddressService.getAddressesByAccount();
        } catch (Exception ex) { }
        
        AddressService.setAccountId(acc.Id);
        AddressService.setAddressId(addr.Id);
        
        AddressService.getAddress();
        AddressService.getAddressesByAccount();
        AddressService.getAddressOptions();
        
    }
        
}