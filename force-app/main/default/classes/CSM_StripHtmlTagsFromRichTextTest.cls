@isTest
public class CSM_StripHtmlTagsFromRichTextTest {
    
    @testSetup
    static void makeData(){
        
        String contactName = 'test contact name';
        String testemail = 'testyb123@test.com';
        
        Account accOne = new Account();
        Account testAccount = AccountTestDataFactory.createAccount('School Account',accOne);
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.AccountId = testAccount.Id;
        testContact.FirstName = contactName;
        testContact.LastName = contactName;
        testContact = ContactTestDataFactory.createContact(null,testContact);
        insert testContact;
        
        User commUser = new User();
        commUser.LastName = 'lastname';
        commUser.username = testemail;
        commUser.email = testemail;
        commUser.contactId = testContact.Id;
        commUser.IsActive = true;
        User communityUser = UserTestDataFactory.createUser('Customer Community Advanced',commUser);
        
        insert communityUser;
    }
    
    @isTest
    static void testStripHtmlTagsFromPost() {
        
        User u = [select id from User where email = 'testyb123@test.com'];
        
        System.RunAs(u){
            
            List<CSM_StripHtmlTagsFromRichText.inputVarFromFlow> inputList = new List<CSM_StripHtmlTagsFromRichText.inputVarFromFlow>();
            CSM_StripHtmlTagsFromRichText.inputVarFromFlow input = new CSM_StripHtmlTagsFromRichText.inputVarFromFlow();
            input.richText = '<p>This is a <b>test</b> message</p>';
            inputList.add(input);
            
            List<CSM_StripHtmlTagsFromRichText.returnVarToFlow> outputList = CSM_StripHtmlTagsFromRichText.stripHtmlTagsFromPost(inputList);
            
            System.assertEquals(1, outputList.size());
            CSM_StripHtmlTagsFromRichText.returnVarToFlow output = outputList[0];
            System.assertEquals('This is a test message', output.plainText);
        }
    }
}