@isTest
private class IbenCourseOutlineFeedbackControllerTest {

    @isTest 
    static void testIbenCourseOutlineFeedbackController() {
        
       // User usr = CreateDataTest.Test1();
        Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
        Id communityprofileId = [select Id from Profile where name='system administrator' and UserLicenseId=:userLicenseId].id;
       
    User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = communityprofileId,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;
        
        
        System.RunAs(usr){  
            Account acc = PimsTestUtil.createAccount('Test Account','');
        insert acc;
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
              
        IB_Programme__c prog = new IB_Programme__c();
        prog.Account__c = acc.Id;
        prog.Exam_Session__c = 'May';
        prog.Status__c = 'Test';
        prog.IBCC_Implementation_Phase__c = 'Phase 1';
        prog.Primary_Language_of_Instruction__c = 'English';
        prog.Street_Address__c =add.id;
        prog.owner__c = '0050O0000076lXX';
        insert prog;
        
        IB_Programme__c prmemail = [Select Programme_Relationship_Manager_Email__c from IB_Programme__c where id = :prog.id ];
        
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        insert aa; 
         
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;   
        
        insert cor;
        
         List<string> toadd1 =new List<string>();
        toadd1.add(userInfo.getUserEmail());
        
        Staffing_Event__c se = new Staffing_Event__c();
        insert se;
        
               test.startTest();  
            
                PageReference pageRef = Page.IBPortalTriagePage;
                test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('id',se.Id);
                IbenCourseOutlineFeedbackController controller = new IbenCourseOutlineFeedbackController();
                controller.reading = cor;
                controller.fileBody = Blob.valueof('StringToBlobTest');
                controller.fileName = 'fileName';

                controller.init();
               // controller.save();
                controller.upload();
                controller.saveCustomAttachment();

               test.stopTest();  
           
        }
    }
    
    static testmethod void testDMLError(){
          Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
        Id communityprofileId = [select Id from Profile where name='system administrator' and UserLicenseId=:userLicenseId].id;
       
    User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = communityprofileId,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;
        
      

       
        
        System.RunAs(usr){  
             IB_Programme__c prog = PimsTestUtil.createProgramme();
        insert prog; 
        
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        insert aa; 
         
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;   
        insert cor;
        
        Staffing_Event__c se = new Staffing_Event__c();
        insert se;
               test.startTest();  
                PageReference pageRef = Page.IBPortalTriagePage;
                test.setCurrentPageReference(pageRef);
                pageRef.getParameters().put('id',se.Id);
                IbenCourseOutlineFeedbackController controller = new IbenCourseOutlineFeedbackController();
                Course_Outline_Reading__c cor2 = new Course_Outline_Reading__c();
                cor2.Application_Attachment__c = aa.Id;
                cor2.Programme__c = prog.Id;   
                controller.reading = cor2;
                controller.fileBody = Blob.valueof('StringToBlobTest');
                controller.fileName = 'fileName';

            controller.save();
            controller.getUserLanguageKey();
                controller.upload();
               test.stopTest();  
           
        }
    }

}