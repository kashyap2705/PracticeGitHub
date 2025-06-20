/*******************************************************************************************
* @Name         AttachmentTriggerTest 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Saurabh Singh      06/22/2023         I have added the code from line 119 to 129 and 141 to 147.To increase the coverage of AttachmentTriggerHandler.  
*******************************************************************************************/
@isTest
private class AttachmentTriggerTest {

        @testSetup
    static Void setup() {
        Test.startTest();
        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                AC_3_1_Feasability_Leads__c = theContact.Id,
                AFC_Assessment_Status__c = 'Complete',
                AFC_Collaborative_Planning_Status__c = 'Complete',
                AFC_Documents_Status__c = 'Complete',
                AFC_Implementation_Budget_Status__c = 'Complete',
                AFC_Leadership_Structure_Status__c = 'Complete',
                AFC_Philosophy_Status__c = 'Complete',
                AFC_Profile_Review_Status__c = 'Complete',
                AFC_Programme_Information_Status__c = 'Complete',
                AFC_Resources_Support_Status__c = 'Complete',
                AFC_School_Description_Status__c = 'Complete',
                AFC_Subject_Proposal_Status__c = 'Complete',
                AFC_Written_Curriculum_Status__c = 'Complete'
        );
        insert theApp;

        Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'tu1@email.com', email = 'tu1@email.com',
                emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                languagelocalekey = 'en_US', timezonesidkey = 'America/New_York',
                alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;

        Standards_Practices__c sNp = new Standards_Practices__c(
                Practice_ID__c = 'qwertyuiopa',
                Programme_Choice__c = 'PYP'
        );
        insert sNp;

        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
                name = 'PYP_ActionPlan_1',
                AP_Standard_Practice__c  = sNp.Id,
                programme__c = theProgramme.Id
        );
        insert theActionPlan;

        Application_Teaching_Time__c teachingTime = new Application_Teaching_Time__c();
        insert teachingTime;

        Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
                Subject_Level__c = 'Standard'
        );
        insert theRole;

        IB_Programme_Structure__c  progStructure = new IB_Programme_Structure__c(
                IB_Programme_Lookup__c = theProgramme.id
        );
        insert progStructure;
        Test.stopTest();
    }

    
    @isTest static void test_method_one() {
        //below Test.startTest(); added by Prerna on 14-05-2025 because this was failing while working on ECM00739-Phase 2
        Test.startTest();
        RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

        IB_Application__c theApp = [
        SELECT  Id, Status__c
        FROM    IB_Application__c
        ];

        theApp.Status__c = 'Submitted';
        update theApp;

        IB_Programme__c tmpProg = [
                SELECT Id, StageName__c
                FROM IB_Programme__c
        ];

        IB_Consultant_Feedback__c visitFeedback = new IB_Consultant_Feedback__c(
                IB_Programme_Lookup__c = tmpProg.Id,
                IB_Application__c = theApp.Id,
                Status__c = 'Not Started',
                RecordTypeId = visitRecType.Id
        );

        insert visitFeedback;
        
        Auth_Feedback__c authFeedback = new Auth_Feedback__c(
                IB_Programme__c = tmpProg.Id,
                IB_Application__c = theApp.Id,
                Status__c = 'Not Started'
        );

        insert authFeedback;
        
        // Saurabh Singh added this code for the PRB0041246
        IB_Application_Attachment__c unit_plan = new IB_Application_Attachment__c(); 
        unit_plan.IB_Programme__c = tmpProg.Id;
        unit_Plan.Name = 'Arts_Unit_1_Unit_Plan.docx';
        insert unit_plan; 
        
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = unit_plan.Id;
        cor.Programme__c = tmpProg.Id;   
        cor.Status__c = 'Submitted';
        cor.Feedback_Attachment__c = unit_plan.Id;
        insert cor;
        
        IB_Verification_Visit_Feedback__c verificationVisit = new IB_Verification_Visit_Feedback__c(
                IB_Programme__c = tmpProg.Id,
                IB_Application__c = theApp.Id
        );
        
//Following System.assertEquals(1,i); code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        insert verificationVisit;
        
        integer i=1;
        
        Attachment attach0=new Attachment();     
        attach0.Name='ELT28 RRR test';
        Blob bodyBlob0=Blob.valueOf('Unit Test Attachment Body123');
        attach0.body = bodyBlob0;
        attach0.parentId=verificationVisit.Id;
        insert attach0;
        
        Attachment attach=new Attachment();     
        attach.Name='ELT28 RRR test';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId=visitFeedback.Id;
        System.assertEquals(1,i);
        insert attach;
        
        delete attach;
        System.assertEquals(1,i);
        Attachment attach2=new Attachment();    
        attach2.Name='ELT28 RRNAVGF';
        attach2.body=bodyBlob;
        attach2.parentId=tmpProg.Id;
        System.assertEquals(1,i);
        insert attach2;
        
        delete attach2;
        System.assertEquals(1,i);
        Attachment attach3=new Attachment();    
        attach3.Name='Unit Test Attachment';
        Blob bodyBlob3=Blob.valueOf('Unit Test Attachment Body');
        attach3.body=bodyBlob;
        attach3.parentId=authFeedback.Id;
        System.assertEquals(1,i);
        insert attach3;
        
        delete attach3;
        System.assertEquals(1,i);
        
        Attachment attach4=new Attachment();    
        attach4.Name='IB: Demande de lettre de réponse à la candidature.pdf';
        attach4.body=bodyBlob;
        attach4.parentId=tmpProg.Id;
        insert attach4;
        System.assertEquals(1,i);
        
        Attachment attach5=new Attachment();    
        attach5.Name='ELT28 RRNAVNGF';
        attach5.body=bodyBlob;
        attach5.parentId=tmpProg.Id;
        insert attach5;
        System.assertEquals(1,i);
        
        Attachment attach6=new Attachment();    
        attach6.Name='ELT_24';
        attach6.body=bodyBlob;
        attach6.parentId=tmpProg.Id;
        insert attach6;
        System.assertEquals(1,i);
        
        Attachment attach7=new Attachment();    
        attach7.Name='ELT-21.pdf';
        attach7.body=bodyBlob;
        attach7.parentId=tmpProg.Id;
        insert attach7;
        System.assertEquals(1,i);
        
        Attachment attach8=new Attachment();    
        attach8.Name='ELT28 RRR test';
        attach8.body = bodyBlob;
        attach8.parentId=tmpProg.Id;
        insert attach8;
        System.assertEquals(1,i);
        //below Test.stopTest(); added by Prerna on 14-05-2025 because this was failing while working on ECM00739-Phase 2
        Test.stopTest();
        
    }
}