/*
 * @description - This is the test class for updateAdressLatLongBatch class
 * @author  *
 * @version *
 * @since   *
 * Modification Log -
 *--------------------------------------------------------------------------------------------------                    
 * Developer                   Date                   Description          Version
   Gautam Manchanda            2024/12/05             US-0002697
 * -------------------------------------------------------------------------------------------------                   
*/
@isTest
public class updateAdressLatLongBatchTest {
    /*
    @description : testSetup method to setup test data for this test class
    */
    @testSetup
    public static void testSetup()
    {
        User u = new User (id=UserInfo.getUserId());
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Online_Coordinator_Role'];
        PermissionSet ps1 = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        List<PermissionSetAssignment> list_psa = new List<PermissionSetAssignment>();
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        list_psa.add(psa);
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = u.id;
        psa1.PermissionSetId = ps1.Id;
        list_psa.add(psa1);
        insert list_psa;
        
        System.runAs(u){
            Account ibInstituteAccount = AccountTestDataFactory.createAccount('IB Institute', null);
            insert ibInstituteAccount;
            
            Account onlineProviderAccount = AccountTestDataFactory.createAccount('Online Provider', null);
            insert onlineProviderAccount;
            
            IB_Country_Segmentation__c country= new IB_Country_Segmentation__c (
                Name = 'Austria', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                IBEN_Independent_Account__c = ibInstituteAccount.id);
            insert country;
            
            /*IB_Address__c tmpAdd = new IB_Address__c(
                Name = 'Institute address',
                IB_Account__c = ibInstituteAccount.Id,
                Address_Line_1__c = 'Test',
                City__c = 'Test city',
                Postal_Code__c = '12345',
                Country__c=country.id
                
            );
            insert tmpAdd;
            */
            IB_Address__c tmpAdd1 = new IB_Address__c(
                Name = 'ONLINE PROVIDER',
                IB_Account__c = onlineProviderAccount.Id,
                Address_Line_1__c = 'Test',
                Address_Line_2__c = 'Test',
                Address_Line_3__c = 'Test',
                Address_Line_4__c = 'Test',
                City__c = 'Test city',
                Postal_Code__c = '12345',
                Country__c=country.id
                
            );
            insert tmpAdd1;
            
            Google_maps__c mapObj=new Google_maps__c(Enable_Geocoding_API_Calls__c=true,Google_Geocoding_API_Key__c='asdkgasjkfgasjdgfdsfa');
            insert mapObj;
        }
    }
    
    @isTest
    public static void testBatch(){
        IB_Address__c addressRecord = [SELECT id, MALatitude__c FROM IB_Address__c LIMIT 1];
        System.assert(addressRecord.MALatitude__c == null);
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new updateLatLongMockTest());
        	Id batchId = Database.executeBatch(new updateAdressLatLongBatch(), 40);
        Test.stopTest();
        addressRecord = [SELECT id, MALatitude__c FROM IB_Address__c LIMIT 1];
        System.assert(addressRecord.MALatitude__c != null);
    }
    
}