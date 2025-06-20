@isTest
public class IBConstantsTest {
    
    static testMethod void searchRecords() {
        
        Test.startTest();
        Set<Id> setEMSRecordTypeIds = IBConstants.fetchCampaignEMSRecordTypeIds(); 
        system.assert(setEMSRecordTypeIds.size() > 1,'Sucessfull fetched EMS Recordtypes');
        Test.stopTest();
        
    }
    
}