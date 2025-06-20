@isTest
public class changeProfileFutureMethodClassTest {
    
    @isTest static void changeProfileTest(){
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact contactObject = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert contactObject;
        Id proId= [Select Id from Profile where name ='Customer Community Basic' Limit 1].Id;
        User u = new User();
        u.Username = contactObject.Email;
        u.Email = contactObject.Email;
        u.FirstName = contactObject.FirstName;
        u.LastName = contactObject.LastName;
        u.LanguageLocaleKey = 'en_US'; 
        u.ProfileId = proId;
        u.ContactId = contactObject.Id;
        u.alias = contactObject.FirstName.substring(1,1) + contactObject.LastName.abbreviate(6);
        u.timezonesidkey = 'America/Los_Angeles';
        u.emailencodingkey = 'UTF-8';
        u.localesidkey = 'en_US';
        insert u;
        changeProfileFutureMethodClass.changeProfileMethod(u.Username);
        changeProfileFutureMethodClass.changeProfileMethodADAS(u.Username);
    }
}