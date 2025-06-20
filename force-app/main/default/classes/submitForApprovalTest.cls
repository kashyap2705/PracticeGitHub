@isTest
public class submitForApprovalTest {
    
    public static final String SUCCESS_CODE = 'SUCCESS';
    public static final String ERROR_CODE = 'ERROR';
    public static final String BAD_ID = 'INVALIDID';
    
    @isTest
    static void basicTest() {
        
        Lead testLead = LeadTestDataFactory.createLead(new Lead(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@example.com',
            Professional_Email__c = 'john.doe.prof@example.com',
            Company = 'Test Company',
            IsConverted = false,
            CP_Interest__c = true
        ));
        insert testLead;
        
        ProcessInstance[] anApprovalList;
        
        submitForApproval anApprovalPlugin = new submitForApproval();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('recordID',testLead.ID);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = anApprovalPlugin.invoke(request);     
        anApprovalList = [select id, status from processInstance where targetObjectID = :testLead.Id];   
        if (anApprovalList.size() > 0) {
            System.AssertEquals(result.OutputParameters.get('Status'), SUCCESS_CODE);
        } else {
            System.AssertEquals(result.OutputParameters.get('Status'), ERROR_CODE);
        }
    }
    
    @isTest
    static void negativeTest() {
        
        submitForApproval anApprovalPlugin = new submitForApproval();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('recordID',BAD_ID);
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = anApprovalPlugin.invoke(request);
        System.AssertEquals(result.OutputParameters.get('Status'), ERROR_CODE);
    }        
    
    @isTest
    static void describeTest() {
        
        submitForApproval anApprovalPlugin = new submitForApproval();
        Process.PluginDescribeResult result = anApprovalPlugin.describe();
        
        System.assertEquals(1, result.inputParameters.size(), 'Input parameters count should be 1');
        System.assertEquals(2, result.OutputParameters.size(), 'Output parameters count should be 2');
    }
}