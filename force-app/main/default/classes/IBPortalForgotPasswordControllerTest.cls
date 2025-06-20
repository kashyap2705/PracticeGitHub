@isTest
private class IBPortalForgotPasswordControllerTest {
	
   @testsetup
    public static void testdata(){
         account acct = TestsUtil.createAccount('Test Account');
        acct.IBIS_ID__c = '717171';
        acct.Country__c = 'UNITED STATES';
        acct.Sub_region__c = 'NORTHERN AMERICA';
        acct.Region__c = 'IBAEM';
        acct.Language_Of_Correspondance__c = 'English';
        insert acct;
 IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','IBAEM',acct);
        insert country;     
        Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com',Date.today().addYears(-22), country);
        contactib.User_Language__c = 'English';
        contactib.AccountId = acct.id;
        contactib.Country__c = country.id;
        insert contactib;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,IsActive=false,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser@testorg.com');
        
        User usres = new User(Alias = 'ibport', Email='ibportaluseres@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='es',
                            LocaleSidKey='en_US', ProfileId = p.Id,IsActive=false,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuseres@testorg.com');
        
        User usrfr = new User(Alias = 'ibport', Email='ibportaluserfr@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr',
                            LocaleSidKey='en_US', ProfileId = p.Id,IsActive=false,
                            TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuserfr@testorg.com');
        
        insert new List<User>{usr,usres,usrfr};
        system.debug('user hello sh'+usr);
    }
	@IsTest
	public static void testIBPortalForgotPasswordController() {
        IBPortalForgotPasswordController obj=new IBPortalForgotPasswordController();
		PageReference pageRef = Page.IBPortalForgotPassword;
        Test.setCurrentPage(pageRef);
    	IBPortalForgotPasswordController controller = new IBPortalForgotPasswordController();
        Integer errorCount = controller.errorCount;
        string error = 'this is error msg';
        controller.errorMessages.add(error); 
    	controller.username = 'ibportaltestuser@testorg.com';
        controller.errorCount=1;
    	controller.forgotPassword();     
    
     	String currLocale = controller.getLocale();

    }

    
}