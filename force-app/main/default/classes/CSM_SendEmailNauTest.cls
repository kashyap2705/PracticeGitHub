@isTest
public class CSM_SendEmailNauTest {
     @testSetup
    static void makeData(){
     String accountName = 'test account name';
    String contactName = 'test contact name';
    String testemail = 'testyb123@test.com';
        
       Account testAccount = new Account(
      Name = accountName,
      Language_Of_Correspondance__c = 'English',
      Legal_Status__c = 'Private',
      Lead_Account__c = true,
       Website = 'http://example.com'
    );
    insert testAccount;

    Contact testContact = new Contact(
      Salutation = 'Mr.',
      LastName = contactName,
      FirstName = contactName,
      Email = testemail,
      AccountId = testAccount.Id
    );
    insert testContact;
        
  
    Profile ccAdvancedProfileId = [
      SELECT Id, Name
      FROM profile
      WHERE name = 'Customer Community Advanced'
      LIMIT 1
    ];
        User portalUser = new User(
      profileId = ccAdvancedProfileId.id,
      username = testemail,
      email = testemail,
      emailencodingkey = 'UTF-8',
      languagelocalekey = 'en_US',
      localesidkey = 'en_US',
      timezonesidkey = 'America/Los_Angeles',
      alias = 'cspu',
      lastname = 'lastname',
      contactId = testContact.id
    );
    insert portalUser;
    }

  @isTest
  static void testSendSingleEmailNau() {
       User u = [select id from User where email = 'testyb123@test.com'];
      System.RunAs(u){
    List<CSM_SendEmailNau.inputVariableFlow> inputList = new List<CSM_SendEmailNau.inputVariableFlow>();
    CSM_SendEmailNau.inputVariableFlow flowVar = new CSM_SendEmailNau.inputVariableFlow();
    flowVar.FirstName = 'John';
    flowVar.LastName = 'Doe';
    flowVar.CaseNumber = '12345';
    flowVar.CaseSubject = 'Sample Case';
    flowVar.UserEmail = 'johndoe@example.com';
    inputList.add(flowVar);
	Test.StartTest();
    CSM_SendEmailNau.sendSingleEmailNau(inputList);
	Test.StopTest();
      }
  }
}