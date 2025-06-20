/*******************************************************************************************
* @Name     LoggerTest
* @Author   Ranjith Kondabathini    
* @Date     05/16/2023    
* @Group        
* @Description  unit test of Log, LogTrigger, LogSeverity LogTrigger
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      05/16/2023         unit test of Log, LogTrigger, LogSeverity LogTrigger
*******************************************************************************************/
@isTest
public class LoggerTest {
    /**
     * @description used as data for unit test
     */ 
    final static string TESTDEBUG = 'Testing DEBUG';
     /**
     * @description used as data for unit test
     */
    final static string TESTINFO = 'Testing INFO';
     /**
     * @description used as data for unit test
     */
    final static string TESTWARN = 'Testing WARN';
     /**
     * @description used as data for unit test
     */
    final static string TESTERROR = 'Testing ERROR';
    /**
     * @description used as data for unit test
     */
    final static string QUERY = 'global';
    
    @isTest
    static void testLogEventLevelDebug() {
       CustomMetadataHandlerTest.setMetadata(QUERY,(list<LoggerSetting__mdt>) JSON.deserialize('[{"Enable_Log_Events_from_Level__c":"Debug","Enable_Log_Save_from_Level__c":"Debug"} ]', List<LoggerSetting__mdt>.class));
        Test.startTest();
        logger.get().add(testDebug, LogSeverity.DEBUG);
		logger.get().add(testInfo, LogSeverity.INFO);
		logger.get().add(testWarn, LogSeverity.WARN);
		logger.get().add(testError, LogSeverity.ERROR);
        logger.get().add(new DMLException('Exception DEBUG'), LogSeverity.DEBUG);
		logger.get().publish();
        Test.stopTest();
        Test.getEventBus().deliver();
       final String currentRequestId = Request.getCurrent().getRequestId();
       final Quiddity currentQuiddity = Request.getCurrent().getQuiddity();
       final List<Log__c> events = [
            SELECT Id, RequestId__c, Context__c, Message__c, Level__c
            FROM Log__c
            ORDER BY Level__c LIMIT 10
        ];
        /*System.assertEquals(
            5,
            events.size(),
            'expected to find only a single event'
        );

        for (Log__c logEvt : events) {
            System.assertEquals(
                currentRequestId,
                logEvt.RequestId__c,
                'Expected the reuqest id to have been logged'
            );
            System.assertEquals(
                currentQuiddity.name(),
                logEvt.Context__c,
                'Expected quiddity on log message to match apex test context'
            );
            System.assert(
                new Set<String>{
                        Quiddity.RUNTEST_ASYNC.name(),
                        Quiddity.RUNTEST_DEPLOY.name(),
                        Quiddity.RUNTEST_SYNC.name()
                    }
                    .contains(logEvt.Context__c),
                'Expected quiddity to be one of the apex test types, found: ' +
                logEvt.Context__c
            );
        }*/
        
    }
     @isTest
    static void testLogEventLevelInfo() {
     CustomMetadataHandlerTest.setMetadata(QUERY,(list<LoggerSetting__mdt>) JSON.deserialize('[{"Enable_Log_Events_from_Level__c":"Info","Enable_Log_Save_from_Level__c":"Info"} ]', List<LoggerSetting__mdt>.class));
   	 Test.startTest();
        logger.get().add(testDebug, LogSeverity.DEBUG);
		logger.get().add(testInfo, LogSeverity.INFO);
		logger.get().add(testWarn, LogSeverity.WARN);
		logger.get().add(testError, LogSeverity.ERROR);
		logger.get().publish();
        logger.get().publish('publish message test');
        Test.stopTest();
        Test.getEventBus().deliver();
       final List<Log__c> events = [
            SELECT Id, RequestId__c, Context__c, Message__c, Level__c
            FROM Log__c
            ORDER BY Level__c LIMIT 10
        ];
        /*System.assertEquals(
            4,
            events.size(),
            'expected to find Multiple event'
        );*/
        
    }
    @isTest
    static void testLogEventLevelWarn() {
        CustomMetadataHandlerTest.setMetadata(QUERY,(list<LoggerSetting__mdt>) JSON.deserialize('[{"Enable_Log_Events_from_Level__c":"Warn","Enable_Log_Save_from_Level__c":"Warn"} ]', List<LoggerSetting__mdt>.class));
      	Test.startTest();
        logger.get().add(testDebug , LogSeverity.DEBUG);
		logger.get().add(testInfo , LogSeverity.INFO);
		logger.get().add(testWarn, LogSeverity.WARN);
		logger.get().add(testError, LogSeverity.ERROR);
        logger.get().add(new DMLException('Exception WARN'),LogSeverity.WARN);
		logger.get().publish();
        Test.stopTest();
        Test.getEventBus().deliver();
       final List<Log__c> events = [
            SELECT Id, RequestId__c, Context__c, Message__c, Level__c
            FROM Log__c
            ORDER BY Level__c LIMIT 10
        ];
        /*System.assertEquals(
            3,
            events.size(),
            'expected to find only a single event'
        );*/
        
    }
    @isTest
    static void testLogEventLevelError() {
        CustomMetadataHandlerTest.setMetadata(QUERY,(list<LoggerSetting__mdt>) JSON.deserialize('[{"Enable_Log_Events_from_Level__c":"Error","Enable_Log_Save_from_Level__c":"Error"} ]', List<LoggerSetting__mdt>.class));
        Test.startTest();
        logger.get().add(testDebug, LogSeverity.DEBUG);
		logger.get().add(testInfo, LogSeverity.INFO);
		logger.get().add(testWarn, LogSeverity.WARN);
		logger.get().add('testing add string method');
        logger.get().add(new DMLException('hi from exception land'));
        logger.get().add(new DMLException('Exception ERROR'), LogSeverity.ERROR);
		logger.get().publish();
        logger.get().publish(new DMLException('publish exception'));
        Test.stopTest();
        Test.getEventBus().deliver();
        final List<Log__c> events = [
            SELECT Id, RequestId__c, Context__c, Message__c, Level__c
            FROM Log__c
            ORDER BY Level__c LIMIT 10
        ];
        /*System.assertEquals(
            3,
            events.size(),
            'expected to find multiple event'
        );*/
        
    }
    }