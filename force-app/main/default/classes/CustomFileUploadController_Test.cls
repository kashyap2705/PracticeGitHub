@isTest(SeeAllData=true)
private class CustomFileUploadController_Test {
    
    @isTest
    private static void testCreate() {
        
        Account objAccount = new Account(Name = 'test record', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', CurrencyIsoCode = 'SGD', 
                                         IBIS_ID__c = '337254',Legal_Status__c = 'Private',Language_Of_Correspondance__c = 'English',Website = 'www.test.com',RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School Account').getRecordTypeId());
        insert objAccount;
        
        User adminuser = [select id from user where Profile.Name =: 'System Administrator' and isactive = true limit 1];
        
        Date dd = Date.newInstance(1999, 12, 9);
        
        Contact ObjContact = new Contact(FirstName = 'testing', LastName = 'Firsttest', AccountId = objAccount.Id, Homephone = '+9212345678', Phone = '+9212345678', Email = 'a@a.com', Contact_Type__c = 'IBEN', RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact;
        PD_Provider_Event__c pdevent = new PD_Provider_Event__c(
            Name = 'Test',
            Status__c = 'Draft',
            Host_School__c = objAccount.Id
        );
        
        insert pdEvent;
        
        PD_Provider_Event__c pdeventRec = [select id from PD_Provider_Event__c limit 1];
        
        User objuser = new User(Alias = 'standt', Email = 'test@gmail.com',
                                EmailEncodingKey = 'UTF-8', LastName = 'test', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = [Select Id from Profile where Name = 'External PD Provider'].id,
                                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test125@ibotestorg.com', ContactId = ObjContact.Id);
        insert objuser;
        
        ContentVersion contentVersion_1 = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content')
        );
        
        insert contentVersion_1;
        
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        System.runAs(adminuser) {
            
            test.startTest();  
            CustomFileUploadController.saveFile(pdeventRec.Id, 'Test', 'base64Data');
            if(pdeventRec != NULL){
                list<contentversion> refiles = CustomFileUploadController.relatedFiles(pdeventRec.Id);
            }
            test.stopTest(); 
        }
    }
}