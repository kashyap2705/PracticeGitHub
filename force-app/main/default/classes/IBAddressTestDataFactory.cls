/**
* @description -This is used to Test the instance of List of IB_Address__c
* 
* Ticket: 
*
* @author: Vikash Kumar
* @since 18-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 18-10-2024      Created            US-0002499       Created the classe
*/
@isTest
public without sharing class IBAddressTestDataFactory { 
    private final static String STATUS = 'Active';
    private final static String ADDRESS_LINE1 = 'Brooklyn';
    private final static String CITY = 'New York';
    private final static String POSTAL_CODE = '10001';
    
    /**
     * @description - Creates a list of IB_Address__c records      
     * @param tempIBAdress - template IB_Address__c record to clone (can be null)
     * @param nAddress - number of records to create    
     * @return   `List<IB_Address__c>`
     */
    public static List<IB_Address__c> createIBAddresses(IB_Address__c tempIBAdress, Integer nAddress){
        List<IB_Address__c> ibAddresses = new List<IB_Address__c>();
        for (Integer i = 0; i < nAddress; i++) {
            IB_Address__c ibAddress;
            if(tempIBAdress != null){
                ibAddress = tempIBAdress.clone(false);
            }else{
                ibAddress = new IB_Address__c();
            }
            
            ibAddress = createIBAddressInstance(ibAddress);
            ibAddresses.add(ibAddress);
        }
        return ibAddresses;
    }
    /**
     * @description - Creates a IB_Address__c record        
     * @param tempIBAdress - template IB_Address__c record to clone (can be null)
     * @return             `IB_Address__c`
     */
    public static IB_Address__c createIBAddress(IB_Address__c tempIBAdress){

        IB_Address__c ibAddress;
        if(tempIBAdress != null){
            ibAddress = tempIBAdress.clone(false);
        }else{
            ibAddress = new IB_Address__c();
        }
        
        ibAddress = createIBAddressInstance(ibAddress);
        return ibAddress;
    }
    
    /**
     * @description - Populates fields of an IB_Address__c instance          
     * @param ibAddressRecord -  the record to populate fields
     * @return  `IB_Address__c`
     */
    public static IB_Address__c createIBAddressInstance(IB_Address__c ibAddressRecord){
        IB_Address__c ibAddressInstance = ibAddressRecord;            
        ibAddressInstance.Name = String.isBlank(ibAddressInstance.Name) ? TestDataUtility.generateRandomString(5) : ibAddressRecord.Name;
        ibAddressInstance.Status__c = String.isBlank(ibAddressRecord.Status__c) ? STATUS : ibAddressRecord.Status__c;
        ibAddressInstance.Address_Line_1__c = String.isBlank(ibAddressRecord.Address_Line_1__c) ? ADDRESS_LINE1 : ibAddressRecord.Address_Line_1__c;
        ibAddressInstance.City__c = String.isBlank(ibAddressRecord.City__c) ? CITY : ibAddressRecord.City__c;
		ibAddressInstance.Postal_Code__c = String.isBlank(ibAddressRecord.Postal_Code__c) ? POSTAL_CODE : ibAddressRecord.Postal_Code__c;
		if(String.isBlank(ibAddressRecord.Country__c)){
			IB_Country_Segmentation__c ibCountrySegmentation = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
			insert ibCountrySegmentation;
			ibAddressInstance.Country__c = ibCountrySegmentation.id;
		}else{
			ibAddressInstance.Country__c = ibAddressRecord.Country__c;
		}
		if(String.isBlank(ibAddressRecord.IB_Account__c)){
			Account ibAccount = AccountTestDataFactory.createAccount(null,null);
			insert ibAccount;
			ibAddressInstance.IB_Account__c = ibAccount.id;
		}else{
			ibAddressInstance.IB_Account__c = ibAddressRecord.IB_Account__c;
		}
		
        return ibAddressInstance;
    }
    
}