/**
 * @description       : Test class for CSM_IboUtil
 * @author            : Charan Kumar
 * @modified by       : Charan Kumar | 03-22-2024
 * @modified by       : Charan Kumar | 04-25-2024
**/
@isTest
public class CSM_IboUtilTest {
    @isTest
    static void testLogger() {
        String QUERY = 'global';
        String errorMessage = 'Test Error';
        CustomMetadataHandlerTest.setMetadata(
            QUERY,
            (list<LoggerSetting__mdt>) JSON.deserialize(
                '[{"Enable_Log_Events_from_Level__c":"Error","Enable_Log_Save_from_Level__c":"Error"} ]',
                List<LoggerSetting__mdt>.class
            )
        );

        Test.startTest();
        CSM_IboUtil.logError(errorMessage);
	  	Test.getEventBus().deliver();
        Test.stopTest();

        Log__c log = [SELECT Id, Message__c FROM Log__c LIMIT 1];
        System.assertEquals(errorMessage, log.Message__c, 'Error message not logged correctly');
    }
    
    @isTest
    static void testCommunityBasePath() {
        String basePathName = 'IB_Community_Path';
        Test.startTest();
        String result = CSM_IboUtil.communityBasePath();
        Test.stopTest();
        System.assertNotEquals(basePathName, result, 'IB_Community_Path');
    }
    
    @isTest
    static void testGetNetworkDetails() {
        String networkName = 'ibportal';
        Test.startTest();
        Network result = CSM_IboUtil.getNetworkDetails(networkName);
        Test.stopTest();
        System.assertEquals(networkName, result.Name, 'Network name should be same');
    }
}