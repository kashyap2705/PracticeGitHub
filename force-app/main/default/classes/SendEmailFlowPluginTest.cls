@isTest
public with sharing class SendEmailFlowPluginTest {
    
    public static final String SUBJECT = 'Subject of Test Email';
    public static final String SUBJECT1 = 'Subject of Test Email with Only Email Address';
    public static final String BODY = 'BODY of Test Email';
    public static final String EMAIL_ADDRESS = 'blah@blah.org';
    public static final String TEXT_ATTACHMENT_NAME = 'My Text Attachment';
    public static final String TEXT_ATTACHMENT_BODY = 'My Text Attachment BODY';
    public static final String PDF_ATTACHMENT_NAME = 'My PDF Attachment.pdf';
    public static final String PDF_ATTACHMENT_BODY = 'My PDF Attachment BODY';
    public static final String INVALIDID = 'INVALID_ID'; // Changed from hardcoded ID
    
    @testSetup 
    static void setup() {
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
    }
    
    private static Lead getTestLead() {
        return [SELECT Id FROM Lead LIMIT 1];
    }
    
    @isTest
    static void basicTest() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        inputParams.put('Language', 'French');
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        Lead updatedLead = [SELECT (SELECT Subject FROM ActivityHistories) FROM Lead WHERE Id = :testLead.Id];
        System.assert(!updatedLead.ActivityHistories.isEmpty(), 'Activity history should be created');
    }
    
    @isTest
    static void testWithTextAttachment() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        inputParams.put('textAttachmentName', TEXT_ATTACHMENT_NAME);
        inputParams.put('textAttachmentContent', TEXT_ATTACHMENT_BODY);
        inputParams.put('Language', 'Spanish');
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        Lead updatedLead = [SELECT (SELECT Name FROM Attachments) FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(1, updatedLead.Attachments.size(), 'Should have 1 attachment');
    }
    
    @isTest
    static void testWithPDFAttachment() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        inputParams.put('pdfAttachmentName', PDF_ATTACHMENT_NAME);
        inputParams.put('pdfAttachmentContent', PDF_ATTACHMENT_BODY);
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
       
        Lead updatedLead = [SELECT (SELECT Name FROM Attachments) FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(1, updatedLead.Attachments.size(), 'Should have 1 PDF attachment');
    }
    
    @isTest
    static void testWithCCEmail() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        inputParams.put('emailAddress', EMAIL_ADDRESS);
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        Lead updatedLead = [SELECT (SELECT Subject, Description FROM ActivityHistories ORDER BY CreatedDate DESC LIMIT 1) 
                          FROM Lead WHERE Id = :testLead.Id];
        
        System.assert(!updatedLead.ActivityHistories.isEmpty(), 'Activity history should be created for email with CC');
        System.assert(updatedLead.ActivityHistories[0].Description.contains(EMAIL_ADDRESS), 
                     'Activity description should contain CC email address');
    }
    
    @isTest
    static void testWithTextAttachmentandCCEmail() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        inputParams.put('emailAddress', EMAIL_ADDRESS);
        inputParams.put('textAttachmentName', TEXT_ATTACHMENT_NAME);
        inputParams.put('textAttachmentContent', TEXT_ATTACHMENT_BODY);
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        Lead updatedLead = [SELECT (SELECT Name FROM Attachments) FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(1, updatedLead.Attachments.size(), 'Should have 1 attachment');
    }
    
    @isTest
    static void attachmentTest() {
        Lead testLead = getTestLead();
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', testLead.Id);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', 'testing body');
        inputParams.put('textAttachmentName', 'textattach');
        inputParams.put('textAttachmentContent', 'testing text content');
        inputParams.put('pdfAttachmentName', 'pdfattach');
        inputParams.put('pdfAttachmentContent', 'testing pdf content');
        
        Test.startTest();
        aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        Lead updatedLead = [SELECT (SELECT Name FROM Attachments) FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(2, updatedLead.Attachments.size(), 'Should have both text and PDF attachments');
    }
    
    @isTest
    static void negativeTest() {
        SendEmail aSendEmailPlugin = new SendEmail();
        Map<String,Object> inputParams = new Map<String,Object>();
        
        inputParams.put('recordID', INVALIDID);
        inputParams.put('subject', SUBJECT);
        inputParams.put('body', BODY);
        
        Test.startTest();
        Process.PluginResult result = aSendEmailPlugin.invoke(new Process.PluginRequest(inputParams));
        Test.stopTest();
        
        System.assertEquals('ERROR', result.outputParameters.get('Status'), 'Expected error status for invalid record ID');
        System.assertNotEquals('Email sent successfully', result.outputParameters.get('ErrorMessage'), 'Expected error message for invalid record ID');
    }
    
    @isTest
    static void describeTest() {
        Test.startTest();
        Process.PluginDescribeResult result = new SendEmail().describe();
        Test.stopTest();
        
        System.assertEquals('The SendEmail Flow Plug-in send an email according to the Messaging.SendSingle Apex API', 
                           result.description, 'Description should match');
        System.assertEquals('Emails', result.tag, 'Tag should be "Emails"');
        System.assert(result.inputParameters.size() > 0, 'Should have input parameters defined');
        System.assert(result.outputParameters.size() > 0, 'Should have output parameters defined');
    }
}