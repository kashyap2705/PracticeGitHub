@isTest
public class CSM_GetCaseRecordTest {
    @isTest
    static void testGetCase_EditChatterTrue() {
        Case testCase = new Case(Status = 'New');
        insert testCase;      
        Test.startTest();
        Boolean result = CSM_GetCaseRecord.getCase(testCase.Id);
        Test.stopTest();      
        
        System.assertEquals(true, result, 'Expected editChatter to be true');
    }
    
    @isTest
    static void testGetCase_StatusWithdrawn() {
        
        Case testCase = new Case(Status = 'Withdrawn');
        insert testCase;
        
        Test.startTest();
        Boolean result = CSM_GetCaseRecord.getCase(testCase.Id);
        Test.stopTest();
        System.assertEquals(false, result, 'Expected editChatter to be false');
    }
    
    @isTest
    static void testGetCase_StatusClosed() {        
        Case testCase = new Case(Status = 'Closed');
        insert testCase;
        Test.startTest();
        Boolean result = CSM_GetCaseRecord.getCase(testCase.Id);
        Test.stopTest();
        System.assertEquals(false, result, 'Expected editChatter to be false');
    }
    
    @isTest
    static void testGetCase_NullRecordID() {      
        Test.startTest();
        Boolean result = CSM_GetCaseRecord.getCase(null);
        Test.stopTest();  
        System.assertEquals(true, result, 'Expected editChatter to be true for null record ID');
    }
}