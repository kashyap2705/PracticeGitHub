@isTest
public class testSendEmailFlowPluginTest {
    
    public static final String SUBJECT = 'Subject of Test Email';
    public static final String SUBJECT1 = 'Subject of Test Email with Only Email Address';
    public static final String BODY = 'BODY of Test Email';
    public static final String EMAIL_ADDRESS = 'blah@blah.org';
    public static final String EMAIL_TO_CC = 'blah1@blah1.org;blah2@blah2.org';
    public static final String TEXT_ATTACHMENT_NAME = 'My Text Attachment';
    public static final String TEXT_ATTACHMENT_BODY = 'My Text Attachment BODY';
    public static final String PDF_ATTACHMENT_NAME = 'My PDF Attachment.pdf';
    public static final String PDF_ATTACHMENT_BODY = 'My PDF Attachment BODY';
    public static final String INVALIDID = '000000000000000';
    
    static testMethod void basicTestEnglish() {
        String LANGUAGE = 'English';

        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;

		IB_Application__c app = new IB_Application__c();
		app.Name = 'Test App';
		app.Application_Lookup_to_Programme__c = prog.Id;
		insert app;
    
        // Test Sending Email against a record
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('recordID',prog.ID);
        inputParams.put('subject',SUBJECT);
        inputParams.put('body',BODY);
        inputParams.put('emailAddress',EMAIL_ADDRESS);
        inputParams.put('Emails to CC',EMAIL_TO_CC);
        inputParams.put('Language',Language);
        
        inputParams.put('textAttachmentName',TEXT_ATTACHMENT_NAME);
        inputParams.put('textAttachmentContent',TEXT_ATTACHMENT_BODY);
        inputParams.put('pdfAttachmentName',PDF_ATTACHMENT_NAME);
        inputParams.put('pdfAttachmentContent',PDF_ATTACHMENT_BODY);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aSendEmailPlugin.invoke(request);
        
        //System.assertEquals(result.outputparameters.get('Status'),'SUCCESS');
    }
    
    static testMethod void basicTestSpanish() {
        String LANGUAGE = 'Spanish';

        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;

		IB_Application__c app = new IB_Application__c();
		app.Name = 'Test App';
		app.Application_Lookup_to_Programme__c = prog.Id;
		insert app;
    
        // Test Sending Email against a record
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('recordID',prog.ID);
        inputParams.put('subject',SUBJECT);
        inputParams.put('body',BODY);
        inputParams.put('emailAddress',EMAIL_ADDRESS);
        inputParams.put('Language',Language);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aSendEmailPlugin.invoke(request);
        
        //System.assertEquals(result.outputparameters.get('Status'),'SUCCESS');
    }
    
    static testMethod void basicTestFrench() {
        String LANGUAGE = 'French';

        Account acc = PimsTestUtil.createAccount('Test Account', '');
		insert acc;

		IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
		insert prog;

		IB_Application__c app = new IB_Application__c();
		app.Name = 'Test App';
		app.Application_Lookup_to_Programme__c = prog.Id;
		insert app;
    
        // Test Sending Email against a record
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('recordID',prog.ID);
        inputParams.put('subject',SUBJECT);
        inputParams.put('body',BODY);
        inputParams.put('emailAddress',EMAIL_ADDRESS);
        inputParams.put('Language',Language);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aSendEmailPlugin.invoke(request);
        
        //System.assertEquals(result.outputparameters.get('Status'),'SUCCESS');
    }

    /*
    * -ve Test
    */  
    static testMethod void negativeTest() {

        // Test Sending Email against a record
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();

        inputParams.put('recordID',INVALIDID);
        inputParams.put('subject',SUBJECT);
        inputParams.put('body',BODY);

        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = aSendEmailPlugin.invoke(request);
        
        System.assertEquals(result.outputparameters.get('Status'),'ERROR');
    }
    
    /*
    * This test is to test the describe() method
    */ 
    static testMethod void describeTest() {
        SendEmail aSendEmailPlugin = new SendEmail();
        Process.PluginDescribeResult result = aSendEmailPlugin.describe();
                
        //System.AssertEquals(result.inputParameters.size(), 8);
        //System.AssertEquals(result.OutputParameters.size(), 2);
        
    }

}