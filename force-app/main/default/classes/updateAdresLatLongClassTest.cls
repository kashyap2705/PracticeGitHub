/**
 * <h1>Test Class updateAdresLatLongClass</h1>
 * This Test class is responsible for testing the updateAdresLatLongClass class.
 *
 * @author  Ahmad Shakeel
 * @version 1.0
 * @since   10-10-2019
 */


@isTest
public class updateAdresLatLongClassTest {
    /**
     * This method is used to create ibaddress test date and Test the updateAdresLatLongClass class
     * @param No Parameter.
     * @return Void.
     */
    
    @isTest
    public static void testdoCalloutFromFuture()
    {
        Google_maps__c mapObj=new Google_maps__c(Enable_Geocoding_API_Calls__c=true,Google_Geocoding_API_Key__c='asdkgasjkfgasjdgfdsfa');
        insert mapObj;
        updateAdresLatLongClass onj=new updateAdresLatLongClass();
        Set<id>idsList=new Set<id>();
        Set<id>idsList1=new Set<id>();
        List<Account> acc=new List <Account>();
            Account ac=new Account (
            External_PD_Provider__c = true,
            IBIS_ID__c = '000045',
            State_Abbr__c = 'SA'
                );
            ac = AccountTestDataFactory.createAccount('Online Provider',ac);        
            acc.add(ac);
        insert acc;
        
        IB_Country_Segmentation__c country= new IB_Country_Segmentation__c (
            Name = 'Austria',
        Geographical_Sub_Region_Segmentation__c = 'Europe',
        Regional_Office_Segmentation__c ='IBAEM',
        IBEN_Segmentation__c = 'IBAEM',
        IBEN_Independent_Account__c = acc[0].id);
        country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(country);
        insert country;
            IB_Address__c tmpAdd = new IB_Address__c(
                Name = 'STRUNK',
            IB_Account__c = acc[0].Id,
            Address_Line_1__c = 'Test',
            Address_Line_2__c = 'Test',
            Address_Line_3__c = 'Test',
            Address_Line_4__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345',
            Country__c=country.id
                
            
            );
            
            insert tmpAdd;
            idsList.add(tmpAdd.id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new updateLatLongMockTest());
        
        updateAdresLatLongClass.doCalloutFromFuture(idsList);
        IB_Address__c tmpAdd1 = new IB_Address__c(
                Name = 'STRUNK',
            IB_Account__c = acc[0].Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345',
            Country__c=country.id,
            Province__c='Pubjab'
                
            
            );
            
            insert tmpAdd1;
            tmpAdd1.Province__c='Sindh';
            update tmpAdd1;
            idsList1.add(tmpAdd1.id);
        updateAdresLatLongClass.doCalloutFromFuture(idsList1);
        Test.stopTest();
        
    }
}