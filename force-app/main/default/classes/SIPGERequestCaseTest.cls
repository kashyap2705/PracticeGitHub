@isTest
public class SIPGERequestCaseTest {
    
    public static testMethod void test_Method(){
        ID Recordtype_id = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SIPGE Request').getRecordTypeId();
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
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
        case1.Subject='SIPGE – Test';  
        case1.RecordTypeId = Recordtype_id;
        case1.ContactId = con.id;
        insert case1;
        
        Subject__c subject = new Subject__c();
        subject.Name = '1';
        subject.English__c = 'SIPGE – Test';
        subject.Spanish__c = 'SIPGE – Test';
        subject.French__c = 'SIPGE – Test';
        subject.Unavailable__c = false;
        insert subject;
        
        Cut_Of_Date__c cutOfDate = new Cut_Of_Date__c();
        cutOfDate.Session_Close_Date__c = date.today()+10; //changed by Prerna for ECM00546 on 14/11/2022
        cutOfDate.Session_Open_Date__c = date.today()-10; //added by Prerna for ECM00546 on 14/11/2022
        cutOfDate.Name = 'Cut of date May session';
        cutOfDate.Active__c = true;
        insert cutOfDate;
        
        //Change Added by Prerna for ECM00546 on 17/11/2022 --START--
        Cut_Of_Date__c mayCutOffDate = new Cut_Of_Date__c();
        mayCutOffDate.Session_Close_Date__c = date.today()-10; 
        mayCutOffDate.Session_Open_Date__c = date.today()-30; 
        mayCutOffDate.Name = 'Cut of date May session';
        mayCutOffDate.Type__c = 'sipge';
        insert mayCutOffDate;
        
        Cut_Of_Date__c novCutOffDate = new Cut_Of_Date__c();
        novCutOffDate.Session_Close_Date__c = date.today()-40;
        novCutOffDate.Session_Open_Date__c = date.today()-60;
        novCutOffDate.Name = 'Cut of date Nov session';
        novCutOffDate.Type__c = 'sipge';
        insert novCutOffDate;
        //Change Added by Prerna for ECM00546 on 17/11/2022 --END--
        
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
        cdl.LinkedEntityId = case1.id;
        cdl.Visibility = 'AllUsers';
        cdl.ShareType = 'V';
            insert cdl;
         ContentDocumentLink cd2 = new ContentDocumentLink();
         cd2.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_2.id
        ].ContentDocumentId;
        cd2.LinkedEntityId = case1.id;
        cd2.Visibility = 'AllUsers';
        cd2.ShareType = 'V';
            insert cd2;
         ContentDocumentLink cd3 = new ContentDocumentLink();
         cd3.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersion_3.id
        ].ContentDocumentId;
        cd3.LinkedEntityId = case1.id;
        cd3.Visibility = 'AllUsers';
        cd3.ShareType = 'V';
            insert cd3;
        ContentVersion contentVersion_list = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        System.runAs(testUser){
            Test.startTest();
            SIPGERequestCase.getCases();
            SIPGERequestCase.getconfirmedAccount();
            SIPGERequestCase.getcaserecord(case1.id);
            SIPGERequestCase.getSiPGESubject('SIPGE – Test');
            SIPGERequestCase.getcutoffdate();
            SIPGERequestCase.getsessionname();
            //below 2 statements changed by Prerna since this class was failing due to bad value for restricted picklist field, earlier Value was May 2021, its changed to new value which is May 2024
            SIPGERequestCase.updatecaserecord(case1.id,acc.id, '123456', 'Test', 'Test', 'Test', 'May 2024', '2', '5', 'Yes', '2', 'Test', 'Test', 'Test', 'true');
            SIPGERequestCase.addcaserecord(acc.id, '123456', 'Test', 'Test', 'Test', 'May 2024', '2', '5', 'Yes', '2', 'Test', 'Test', 'Test', 'true');
            SIPGERequestCase.getUserLocale();
            SIPGERequestCase.update_request_for_cancellation(case1.id, 'Test');
            SIPGERequestCase.createContentLink(contentVersion_2.id, case1.id);
            SIPGERequestCase.saveFile(case1.Id, 'Test','Test 2.pdf', cdl.ContentDocumentId);
            SIPGERequestCase.saveFile(case1.Id, 'Decalaration','Test 2.pdf', cd2.ContentDocumentId);
            SIPGERequestCase.updateFile(case1.id, contentVersion_2.id, case1.id,'Decalaration','Test 2.pdf', cd3.ContentDocumentId);
            List<ID> case_list = new List<ID>();
            case_list.add(case1.id);
            if(case1 != NULL){
                SIPGERequestCase.getRelatedFilesByRecordId(case1.Id);
            }
            SIPGERequestCase.deletecase(case_list);
            Test.stopTest();
        }
        
    }
}