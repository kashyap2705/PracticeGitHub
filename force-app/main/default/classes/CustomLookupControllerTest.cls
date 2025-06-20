/*******************************************************************************************
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Ranjith Kondabathini      08/01/2023         <<PRB0041112>> Apex Test Execution Failed (CustomLookupControllerTest)
*******************************************************************************************/
@isTest
private class CustomLookupControllerTest {
    
    @isTest
    static void searchRecords() {
        
        Id schoolRTId = Schema.Sobjecttype.account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
        Id officeAccountSchoolRTId = Schema.Sobjecttype.account.getRecordTypeInfosByDeveloperName().get('IB_Office_Account').getRecordTypeId();
        Profile profRec = [Select Id from Profile where Name = 'External PD Provider'];
       
        Account schAccount = new Account(Name = 'SchoolAccount', Language_Of_Correspondance__c = 'English', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', 
                                         Website = 'www.test.com',Legal_Status__c = 'State', CurrencyIsoCode = 'SGD', IBIS_ID__c = '321131', RecordTypeId = schoolRTId);
        insert schAccount;
        
        Account providerAccount = new Account(Name = 'IBAP as Provider', Region__c = 'IBAP', Sub_region__c = 'SOUTH ASIA', CurrencyIsoCode = 'SGD', IBIS_ID__c = '321132',
                                              Website = 'www.test.com',RecordTypeId = officeAccountSchoolRTId);
        insert providerAccount;
        
        String objectName = 'account';
        String fieldAPINames = 'Name,Industry';
        String filterFieldAPIName;
        String strInput = '*';
        String titleField ='Name';
        String subTitleFields = 'Industry';
        String conditionExpression = '';
        Date dd = Date.newInstance(1999, 12, 9);
        
        Contact ObjContact = new Contact(FirstName = 'testing', LastName = 'Firsttest', AccountId = schAccount.Id, Homephone = '+9212345678', Phone = '+9212345678', 
                                         Email = 'a@a.com', Contact_Type__c = 'IBEN', RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), 
                                         birthdate = dd);
        
        insert ObjContact;
        
        User objuser = new User(Alias = 'standt', Email = 'test@gmail.com', 
                                EmailEncodingKey = 'UTF-8', LastName = 'test', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = profRec.id,
                                TimeZoneSidKey = 'America/Los_Angeles', UserName = 'test125@ibotestorg.com', ContactId = ObjContact.Id);
        insert objuser;
        
        System.runAs(objuser) {
            
            test.startTest();  
            list<CustomLookupController.SObjectQueryResult> accrecords = new list<CustomLookupController.SObjectQueryResult>();
            accrecords = CustomLookupController.retrieveRecords(objectName,fieldAPINames,filterFieldAPIName,strInput,titleField,subTitleFields,conditionExpression);
            test.stopTest();
        }
    }
}