public class AddressDAO {

	private static final AddressDAO instance = new AddressDAO();
     public List<IB_Data_Translate__c> translations { get; set; }

	private AddressDAO() {}

	public static AddressDAO getInstance() {
		return instance;
	}

	public IB_Address__c getAddressById(Id addressId) {

		List<IB_Address__c> address = [
			SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, Country__c, Country__r.Name, Country__r.Country_es__c, Country__r.Country_fr__c,
				Deliverability__c, IB_Account__c, Postal_Code__c, Province__c, Status__c
			FROM IB_Address__c
			WHERE Id = :addressId
			LIMIT 1
		];

		return address[0];

	}

	public IB_Address__c getAddressByTypeAndAccount(String type, Id accountId) {

		List<IB_Address__c> address = [
			SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, Country__c, Country__r.Name, Country__r.Country_es__c, Country__r.Country_fr__c,
				Deliverability__c, IB_Account__c, Postal_Code__c, Province__c, Status__c
			FROM IB_Address__c
			WHERE Name = :type
			AND IB_Account__c = :accountId
			AND Status__c = 'Active'
			LIMIT 1
		];

		if (address.isEmpty()) {
			return new IB_Address__c(Name = type, IB_Account__c = accountId);
		}
		else {
			return address[0];
		}

	}

	public List<IB_Address__c> getAllAddressesByAccount(Id accountId) {

		List<IB_Address__c> addresses = [
			SELECT Id, Name, Address_Line_1__c, Address_Line_2__c, Address_Line_3__c, Address_Line_4__c, City__c, Country__c, Country__r.Name,  Country__r.Country_es__c, Country__r.Country_fr__c,
				Deliverability__c, IB_Account__c, Postal_Code__c, Province__c, Status__c, Gmaps_URL__c 
			FROM IB_Address__c
			WHERE IB_Account__c = :accountId
			AND Status__c = 'Active'
		];

        translations = [
            SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c
			FROM IB_Data_Translate__c
            WHERE Object_Name__c = 'IB_Address__c'
            AND Locale__c = :UserInfo.getLanguage()
        ];

        for (IB_Address__c a : addresses) {
            for (IB_Data_Translate__c t : translations) {
                if (a.Name == t.Record_ID__c) {
                    a.Name = t.Translate_Value_1__c;
                }
            }
        }

		return addresses;

	}

}