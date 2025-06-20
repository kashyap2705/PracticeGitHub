@isTest
public class SiteValidationHelperTest {
    
    @isTest
    static void testValidationHelper() {
        
        
        TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
        insert country;
        
        Contact cont =new Contact (
            Salutation = 'Mr.',
            LastName = 'TestContact',
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
            Email = 'example@exam.com',
            Birthdate = Date.today().addDays(-100),
            Country__c = (country == null ? null : country.id),
            Alternative_Email__c = 'AlterEmail@example.com',
            FirstName = 'FNTestContact',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
        insert cont;
        List<Contact> conList=new List<Contact>();
        conList.add(cont);
        SiteValidationHelper.findMatches(conList);
       
    
    }

}