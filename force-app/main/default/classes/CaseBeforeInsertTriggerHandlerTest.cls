/*******************************************************************************************
* @Name         Main class:CaseBeforeInsertTriggerHandler , Test class : CaseBeforeInsertTriggerHandlerTest
* @Author       Ranjith Kondabathini
* @Date         26-04-2023
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 
*******************************************************************************************/
@isTest(seeAllData=false)
public class CaseBeforeInsertTriggerHandlerTest {
    
    public static testMethod void testGSSSCases() {
        Test.startTest();
        
        List<Case> cases = TestDataFactory.createCase(1,IboUtil.SUPPORT_CASE_RT_ID, false);
        if(!cases.isEmpty()){
            cases[0].Origin = IboUtil.ORIGIN_EMAIL;
            cases[0].SuppliedEmail = 'testing@nobody.com';
            insert cases;
        }
      
        Test.stopTest();
        
        List<Case> listCases = [select Id,OwnerId from Case];
        //Assert.areEqual(CaseTriggerHelper.gsssQueueId, listCases[0].OwnerId);
    }
    //Below method added by Prerna on 25-07-2023 for ECM00489
    public static testMethod void testSOCustomerServiceCases() {
        Test.startTest();
        
        List<Case> queueCases = TestDataFactory.createCase(1,IboUtil.SUPPORT_CASE_RT_ID, false);
        if(!queueCases.isEmpty()){
            queueCases[0].Origin = 'Web';
            insert queueCases;
        }
      
        Test.stopTest();
        
        List<Case> listCases = [select Id,OwnerId from Case];
        Assert.areEqual(CaseTriggerHelper.soCustomerServiceQueueId, listCases[0].OwnerId);
    }
}