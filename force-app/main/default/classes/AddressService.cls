public class AddressService { 

	public static IB_Address__c address = null;
	public static List<IB_Address__c> addresses = null;

	public static Boolean isAddressCached = false;
	public static Boolean isAddressesCached = false;

	public static Id accountId = null;
	public static Id addressId = null;

	public static IB_Address__c getAddress() {

		if (!isAddressCached) {

			if (addressId == null) {
				throw new CustomValidationException('The value for addressId cannot be null.');
			}
			
			AddressDAO dao = AddressDAO.getInstance();
			address = dao.getAddressById(addressId);
			isAddressCached = true;

		}

		return address;

	}

	public static List<IB_Address__c> getAddressesByAccount() {
		
		if (!isAddressesCached) {

			if (accountId == null) {
				throw new CustomValidationException('The value for accountId cannot be null.');
			}
			
			AddressDAO dao = AddressDAO.getInstance();
			addresses = dao.getAllAddressesByAccount(accountId);
			isAddressesCached = true;

		}

		return addresses;

	}
    
    public static List<SelectOption> getAddressOptions() {

		List<SelectOption> options = new List<SelectOption>();
		addresses = getAddressesByAccount();

		for (Ib_Address__c addr : addresses){
     
            String addressOption = addr.Name + ' - ' + addr.Address_Line_1__c;

            if(addr.City__c != null){
            	addressOption = addressOption + ' / ' + addr.City__c;
            }

            if(addr.Province__c != null){
            	addressOption = addressOption + ' / ' + addr.Province__c;
            }

            if(addr.Postal_Code__c != null){
            	addressOption = addressOption + ' / ' + addr.Postal_Code__c;
            }
         
            options.add(new SelectOption(addr.Id, addressOption)); 
            
        }

		return options;

	}

	public static void setAddressId(Id addrId) {
		addressId = addrId;
	}

	public static void setAccountId(Id accId) {
		accountId = accId;
	}

}