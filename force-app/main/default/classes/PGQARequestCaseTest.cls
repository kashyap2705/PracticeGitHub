@isTest
public class PGQARequestCaseTest {
public static testMethod void test_Method(){
        //ID Recordtype_id = Schema.SObjectType.Case.getRecordTypeInfosByName().get('PGQA').getRecordTypeId();
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
    acc.Programme_Recognised__c='DP Courses';
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        User testUser = new User(profileId = p.id, username = 'example@gmail.com', email = 'example@gmail.com',
                                 emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                                 languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                                 alias='cspu', lastname='TestIBAP', contactId = con.id);
        insert testUser;
        
        Case case1 = new Case();
        case1.Subject='PGQA – Test';  
        //case1.RecordTypeId = Recordtype_id;
        case1.ContactId = con.id;
        insert case1;
    
    	PGQA_Sample__c sample1 = new PGQA_Sample__c();
    	sample1.PGQA_Name__c='Sample 1';
    	sample1.PGQA_Candidate_Full_Name__c='Ali Khan';
    	sample1.PGQA_Candidate_Session_Number__c='1234';
    	sample1.PGQA_Canidate_Predicted_Grade__c='3';
        sample1.PGQA_Case__c=case1.id;
    	insert sample1;
    
        Subject__c subject = new Subject__c();
        subject.Name = '1';
        subject.English__c = 'PGQA – Test';
        subject.Spanish__c = 'PGQA – Test';
        subject.French__c = 'PGQA – Test';
        subject.Unavailable__c = false;
        insert subject;
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        insert contentVersion_1;
         ContentVersion contentVersion_2 = new ContentVersion(
            Title = 'Peng',
            PathOnClient = 'Peng.jpg',
            VersionData = Blob.valueOf('Test Content 2')
        );
        insert contentVersion_2;
         ContentVersion contentVersion_3 = new ContentVersion(
            Title = 'abc',
            PathOnClient = 'abc.jpg',
            VersionData = Blob.valueOf('Test Content 3')
        );
        insert contentVersion_3;
         ContentDocumentLink cdl = new ContentDocumentLink();
         cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_1.id
        ].ContentDocumentId;
        cdl.LinkedEntityId = sample1.id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
            insert cdl;
         ContentDocumentLink cd2 = new ContentDocumentLink();
         cd2.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_2.id
        ].ContentDocumentId;
        cd2.LinkedEntityId = sample1.id;
        cd2.Visibility = 'AllUsers';
        cd2.ShareType = 'V';
            insert cd2;
         ContentDocumentLink cd3 = new ContentDocumentLink();
         cd3.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_3.id
        ].ContentDocumentId;
        cd3.LinkedEntityId = sample1.id;
        cd3.Visibility = 'AllUsers';
        cd3.ShareType = 'V';
            insert cd3;
        ContentVersion contentVersion_list = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        System.runAs(testUser){
            Test.startTest();
            PGQARequestCase.getCases();
            PGQARequestCase.getconfirmedAccount();
            PGQARequestCase.getcaserecord(case1.id);
            PGQARequestCase.getSiPGESubject('SIPGE – Test');
            //SIPGERequestCase.getcutoffdate();
            PGQARequestCase.updatecaserecord(case1.id,'Submitted');
            //SIPGERequestCase.addcaserecord(acc.id, '123456', 'Test', 'Test', 'Test', 'May 2021', '2', '5', 'Yes', '2', 'Test', 'Test', 'Test', 'true');
            PGQARequestCase.getUserLocale();
            //SIPGERequestCase.update_request_for_cancellation(case1.id, 'Test');
            PGQARequestCase.createContentLink(contentVersion_2.id, case1.id);
           // PGQARequestCase.saveFile(sample1.Id, 'Test','Test 2.pdf', cdl.ContentDocumentId);
           // PGQARequestCase.saveFile(sample1.Id, 'Decalaration','Test 2.pdf', cd2.ContentDocumentId);
            PGQARequestCase.updateFile(sample1.id, contentVersion_2.id, case1.id,'Decalaration','Test 2.pdf', cd3.ContentDocumentId);
            List<ID> case_list = new List<ID>();
            PGQARequestCase.getsamplerecord(sample1.id);
            case_list.add(case1.id);
            if(case1 != NULL){
                PGQARequestCase.getRelatedFilesByRecordId(sample1.Id);
            }
           // SIPGERequestCase.deletecase(case_list);
            Test.stopTest();
        }
        
    }
}