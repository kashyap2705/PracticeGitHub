@isTest
private class AccountTriggerHandlerTest {
    
    @isTest static void addphoneTest() {
        List<Account> accountValue= new List<Account>();
        List<Account> accounts = new List<Account>();
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        RecordType RecType_inst = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'IB_Institute'];
        Account account = new Account();
        account.Name = 'Test Account 4';
        account.RecordTypeId = RecType.id;
        account.Language_Of_Correspondance__c = 'English';
        account.Legal_Status__c = 'State';
        account.IBIS_ID__c = '123456';
        account.Email__c = 'arbaz.s@plumlogix.com';
        account.Dial_code__c = 'Algeria (+213)';
        account.Phone_Number__c = '0987654322';
        account.Website = 'www.google.com';
        accountValue.add(account);
        Account account1 = new Account();
        account1.Name = 'Test Account 3';
        account1.RecordTypeId = RecType_inst.id;
        account1.Language_Of_Correspondance__c = 'English';
        account1.Legal_Status__c = 'State';
        account1.IBIS_ID__c = 'N912455';
        account1.Email__c = 'arbaz.s@plumlogix.com';
        account1.Dial_code__c = 'Algeria (+213)';
        account1.Phone = '0987654323';
        account1.Website = 'www.google.com';
        accountValue.add(account1);
        
        Account account2 = new Account();
        account2.Name = 'Test Account';
        account2.RecordTypeId = RecType.id;
        account2.Language_Of_Correspondance__c = 'English';
        account2.Legal_Status__c = 'State';
        account2.IBIS_ID__c = '';
        account2.Email__c = 'arbaz.s@plumlogix.com';
        account2.Dial_code__c = 'Algeria (+213)';
        account2.Phone_Number__c = '22';
        account2.Website = 'www.google.com';
        accounts.add(account2);
        Account account3 = new Account();
        account3.Name = 'Test Account 2';
        account3.RecordTypeId = RecType_inst.id;
        account3.Language_Of_Correspondance__c = 'English';
        account3.Legal_Status__c = 'State';
        account3.IBIS_ID__c = 'N912455';
        account3.Email__c = 'arbaz.s@plumlogix.com';
        account3.Dial_code__c = '';
        account3.Phone = '0987';
        account3.Website = 'www.google.com';
        accounts.add(account3);
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        System.runAs(u){
            Test.startTest();
            try{
                insert accountValue;
                insert accounts;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            Test.stopTest();
            
        }    
    }
    @isTest static void updatephoneTest() {
        List<Account> accountValue= new List<Account>();
        List<Account> accountValues = new List<Account>();
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        RecordType RecType_inst = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'IB_Institute'];
        //School Account
        Account account = new Account();
        account.Name = 'Test Account';
        account.RecordTypeId = RecType.id;
        account.Language_Of_Correspondance__c = 'English';
        account.Legal_Status__c = 'State';
        account.IBIS_ID__c = '123450';
        account.Email__c = 'arbaz.s@plumlogix.com';
        account.Dial_code__c = 'Algeria (+213)';
        account.Phone_Number__c = '0987654322';
        account.Website = 'www.google.com';
        //Instituite Account
        Account account1 = new Account();
        account1.Name = 'Test Account 2';
        account1.RecordTypeId = RecType_inst.id;
        account1.Language_Of_Correspondance__c = 'English';
        account1.Legal_Status__c = 'State';
        account1.IBIS_ID__c = 'N412377';
        account1.Email__c = 'arbaz.s@plumlogix.com';
        account1.Dial_code__c = 'Algeria (+213)';
        account1.Phone = '0987654322';
        account1.Dial_code2__c = 'Afghanistan (+93)';
        account1.Phone2__c = '3211186192';
        account1.Website = 'www.google.com';
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        System.runAs(u){
            insert account1;
            insert account;
            //School Account Update
            account.Dial_code__c = 'Afghanistan (+93)';
            account.Phone_Number__c = '03211156192';
            //Instituite Account Update
            account1.Dial_code__c = 'Afghanistan (+93)';
            account1.Phone = '03211186192';
            account1.Dial_code2__c = 'Afghanistan (+93)';
            account1.Phone2__c = '3211186192';
            Test.startTest();
            try {
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                update account1;   }
            catch(Exception ex){
                System.debug('Error Acc1: '+ex);
            }         
            try {
                account.Dial_code__c = 'Afghanistan (+93)';
                account.Phone_Number__c = '132';
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account1.Dial_code__c = 'Afghanistan (+93)';
                account1.Phone = '192';
                account1.Dial_code2__c = 'Afghanistan (+93)';
                account1.Phone2__c = '321';
                update account1;   }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account.Dial_code__c = 'Afghanistan (+93)';
                account.Phone_Number__c = '';
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account1.Dial_code__c = 'Afghanistan (+93)';
                account1.Phone = '';
                account1.Dial_code2__c = 'Afghanistan (+93)';
                account1.Phone2__c = '';
                update account1;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account1.Dial_code__c = '';
                account1.Phone = '';
                account1.Dial_code2__c = '';
                account1.Phone2__c = '';
                update account1;
                account.Dial_code__c = '';
                account.Phone_Number__c = '';
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            Test.stopTest();        
        }
    }
    @isTest static void updatephoneTest_Negative() {
        List<Account> accountValue= new List<Account>();
        List<Account> accountValues = new List<Account>();
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        RecordType RecType_inst = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'IB_Institute'];
        //School Account
        Account account = new Account();
        account.Name = 'Test Account';
        account.RecordTypeId = RecType.id;
        account.Language_Of_Correspondance__c = 'English';
        account.Legal_Status__c = 'State';
        account.IBIS_ID__c = '123450';
        account.Email__c = 'arbaz.s@plumlogix.com';
        account.Dial_code__c = 'Algeria (+213)';
        account.Phone_Number__c = '0987654322';
        account.Website = 'www.google.com';
        //Instituite Account
        Account account1 = new Account();
        account1.Name = 'Test Account 2';
        account1.RecordTypeId = RecType_inst.id;
        account1.Language_Of_Correspondance__c = 'English';
        account1.Legal_Status__c = 'State';
        account1.IBIS_ID__c = 'N412377';
        account1.Email__c = 'arbaz.s@plumlogix.com';
        account1.Dial_code__c = 'Algeria (+213)';
        account1.Phone = '0987654322';
        account1.Website = 'www.google.com';
        Profile p = [select Id,name from Profile where name='System Administrator' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles',username='testObama@example.com'
                         );  
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        System.runAs(u){
            insert account;
            insert account1;
            Test.startTest();
            try{
                account.Dial_code__c = 'Afghanistan (+93)';
                account.Phone_Number__c = '132';
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try { 
                account1.Dial_code__c = 'Afghanistan (+93)';
                account1.Phone = '192';
                update account1;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account.Dial_code__c = '';
                account.Phone_Number__c = '';
                update account;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            try {
                account1.Dial_code__c = '';
                account1.Phone = '';
                update account1;
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            Test.stopTest();        
        }
        //system.assertEquals('987654321', acct.Phone);
        //   system.assertEquals('Afghanistan (+93)', acct.Dial_code__c);
        //  system.assertEquals('03211156192', acct.Phone_Number__c);
    }
    @isTest static void TestupdatePossibleDuplicateCheckField()
    {
        
        //cntList will be sent to the updatePossibleDuplicateCheckField method so it can treat it as trigger.new
        list<contact> cntList=new list<contact>();
        DuplicateRule dp=[select id,developerName from duplicaterule where developerName='Contact_Name_and_Email'];
        //created a test duplicate record set based on the existing duplicate rule 
        DuplicateRecordSet dupRS = new DuplicateRecordSet(DuplicateRuleId = dp.id);
        insert dupRS;
        
        //create a contact
        Contact cntct=new contact(firstName='steve',lastName='smith',email='arbaz.s+testcont@plumlogix.com' ,
                                  Possible_Duplicate__c=true ,Duplicate_Record_Set_ID__c=dupRS.id);
        insert cntct;
        cntct.firstName='stevee';
        cntct.Country_of_Birth__c = 'America';
        cntct.Birth_Locale__c = 'America';
        Date ddd = Date.newInstance(1999, 12, 9);
        cntct.Birthdate = ddd;
        cntct.Alternative_Email__c = 'arbaz.s+testcont@plumlogix.com';
        update cntct;
        cntList.add(cntct);
        //create a DuplicateRecordItem to increment the record count 
        DuplicateRecordItem dup = new DuplicateRecordItem(DuplicateRecordSetId = dupRS.id, RecordId=cntct.id);
        insert dup;
        
        
        Test.startTest();
        
        Test.stopTest();
        
    }
}