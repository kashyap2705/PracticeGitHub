@isTest
private class PhoneValidationTest {
@isTest static void Test_Method() {
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        Account account = new Account();
        account = AccountTestDataFactory.createAccount('School Account', null);
        account.IBIS_ID__c = '123456';
        account.Dial_code__c = 'Algeria (+213)';
        account.Phone_Number__c = '0987654322';
        insert account;
        Contact Contact4 = ContactTestDataFactory.createContact('', null);//PimsTestUtil.createContact('Test Contact 4', 'testContact4@test.com', 'testContact4@test.com', Date.newInstance(1980, 1, 1), account);
        Contact4.FirstName = 'Test ';
        Contact4.LastName = 'Contact 4';
        Contact4.Email = 'testContact4@test.com';
        Contact4.AccountId = account.id;
        Contact4.Country_code__c = 'Algeria (+213)';
        Contact4.Phone_Number__c = '0987654322';
        insert Contact4;
        IB_Role_Repository__c repo = new IB_Role_Repository__c();
        repo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(repo);
        repo.Role_Name__c = 'Institute Administrator';
        insert repo;
        
        IB_Role_Repository__c repo2 = new IB_Role_Repository__c();
        repo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(repo2);
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
        Contact_information__c contact_info=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),name='Ck',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c=Contact4.id);
        contact_info.Country_Code__c = 'Algeria (+213)';
        contact_info.Phone_Number__c = '123456789';
        contact_info.IB_Contact__c = Contact4.id;
        contact_info.Name = '+213';
        insert contact_info;
        Contact_information__c    ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo.id),IB_Contact__c= Contact4.id);
        insert ci;
        IB_Role__c ibRole1 = new IB_Role__c();
        ibRole1.Status__c = 'Confirmed';
        ibRole1.IB_Role__c = repo.Id;
        ibRole1.IB_Contact__c = Contact4.Id;
        ibRole1.Contact_Information_Phone__c = contact_info.id;
        ibRole1 = IBRoleTestDataFactory.createRole(ibRole1);
            Test.startTest();
            try{
                PhoneValidation ph = new PhoneValidation();
                ph.edit_phone_account(account);
                ph.edit_phone(Contact4);
                ph.edit_phone_contact_Info('Algeria (+213)', '123456789', '213123456789');
                ph.edit_phone_contact_Info(contact_info, 'Algeria (+213)', '123456789', ibRole1);
            }
            catch(Exception ex){
                System.debug('Error: '+ex);
            }
            Test.stopTest();
    }
}