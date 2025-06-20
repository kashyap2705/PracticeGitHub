@isTest
public class UserPAsswordResetTest {
    @isTest
    public static void testReset(){

        User testUser = createPortalUser('testUser');
        insert testUser;
        List<User> userList = new List<User>();
        userList.add(testUser);
        UserPasswordReset.ResetRequest rr = new UserPasswordReset.ResetRequest();
		rr.users = userList;
        
        Test.startTest();
        UserPasswordReset.resetPassword(new List<UserPasswordReset.ResetRequest>{rr});
        Test.stopTest();
    }
    
    public static User createPortalUser(String name){
        Profile p =  [select Id from profile where Name ='Customer Community Advanced' limit 1];
        
        return createPortalUser('any_possible_name', p.Id);
    }
    
    public static User createPortalUser(String name, Id profileId){
        //Account acc = new Account (Name = 'acc_test_' + name);
        Account acc = createAccount('acc_test_' + name);
        acc.IBIS_ID__c = '000002';
        acc.Region__c='IBA';
        acc.Billing_Currency__c='USD';
        acc.Website = 'www.testwebsite.com';
        insert acc;
        
        IB_Country_Segmentation__c country = createCountry('Test_Country', 'Europe', acc);
        insert country;
        
        String testemail = name+'xxx@testtest.com';
        
        Contact c = createContact(name, testemail, testemail, Date.today().addYears(-22), country);
        fillContactWithNokData(c);
        fillContactWithPassportDetails(c);
        //c.Independent_Educator__c = 'Yes';
        //c.OtherStreet = 'other street';
        c.AccountId = acc.Id;
        insert c;
        
        User pu = new User(profileId = profileId, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname=name, contactId = c.id);
        return pu;
    } 
    
    public static Account createAccount(String name){
        return new Account ( 
            Name = name,
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = name,
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',
            Phone = '+9212345607865'
            
        );
        //,
        //IBIS_ID__c = '000001'
    }
 
    public static IB_Country_Segmentation__c createCountry(String name, String region, Account acc){
        return new IB_Country_Segmentation__c (
            Name = 'Austria', 
            Geographical_Sub_Region_Segmentation__c = 'Europe',
            Regional_Office_Segmentation__c ='IBAEM', 
            IBEN_Segmentation__c = 'IBAEM',
            IBEN_Independent_Account__c = acc.Id
        );
    }
    
    public static Contact createContact(String name, String homeEmail, String profEmail, Date birthdate, IB_Country_Segmentation__c country){
        return new Contact (
            Salutation = 'Mr.',
            LastName = name,
            MobilePhone = '+9212345607865',
            HomePhone = '+9212345607865',
            AssistantPhone = '+9212345607865',
            OtherPhone = '+9212345607865',
            NoK_Mobile__c = '+9212345607865',
            NoK_Phone__c = '+9212345607865',
            Permission_Mobile__c = '+9212345607865',
            Permission_Phone__c = '+9212345607865',
            Work_Phone_Extension__c = '+9212345607865',
            Phone = '+9212345607865',
            //OtherPhone = '+30992907711',
            Email = homeEmail,
            Birthdate = birthdate,
            Country__c = (country == null ? null : country.id),
            Alternative_Email__c = profEmail,
            FirstName = 'FN'+name,
            MailingCity = 'Lviv city',
          //  MailingState = 'state UA',
            MailingCountry = 'Ukraine',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
    }
    public static void fillContactWithNokData(Contact cont){
        cont.NoK_First_Name__c = 'FNoK' + cont.FirstName;
        cont.NoK_Last_Name__c = 'LNoK' + cont.LastName;
        //cont.NoK_Phone__c = '+301020304';
        cont.NoK_Mobile__c = '+301020304';
        cont.NoK_Title__c = 'Next of Kin';
        cont.NoK_Email__c = 'atest@test.com';
        //cont.Bank_Name__c = 'testuserBankname';
        cont.Independent_Educator__c = 'Yes';
    }
    public static void fillContactWithPassportDetails(Contact cont){
        cont.Full_Name__c = cont.FirstName + cont.LastName;
        cont.Legal_first_name__c = 'FirstName';  
        cont.Legal_Last_name__c = 'LastName';
        cont.Passport_Number__c = '010203';
        cont.Birth_Locale__c = 'Somewhere';
        cont.Country_of_Birth__c = 'Ukraine';
        cont.Place_of_Issue__c = 'Ukraine';
        cont.Expiry_Date__c = Date.today().addDays(20);
        cont.Nationality__c = 'Ukraine';
        //cont.OtherStreet = 'other_street';
    }   
    
}