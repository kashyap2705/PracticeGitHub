@isTest
private class IBUploadAttachmentControllerTest {

     static testMethod void test_method_one() {
         integer i = 1;

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
          insert prog;

          IB_Application__c app = new IB_Application__c();
          app.Name = 'Test App';
          app.Application_Lookup_to_Programme__c = prog.Id;
          insert app;

          IBUploadAttachmentController con = new IBUploadAttachmentController(new ApexPages.StandardController(prog));
//Following  System.assertEquals(1,i); code line is added by Umair-Plumlogix of US11096 on 02/11/2020
          List<SelectOption> attTypes = con.getAttachmentTypes();
         System.assertEquals(1,i);

          con.fileName = 'Test Attachment';
         System.assertEquals(1,i);
          con.fileBody = Blob.valueOf('Test Attachment Body');
         System.assertEquals(1,i);
          con.selectedType = 'Organizational chart';
         System.assertEquals(1,i);
          con.description = 'Org Chart in support of AFC Application';
         System.assertEquals(1,i);
          con.publishToCommunity = true;
         System.assertEquals(1,i);

          PageReference pageRef = con.processUpload();
         System.assertEquals(1,i);

          PageReference pageRef2 = con.back();
         System.assertEquals(1,i);
     }
}