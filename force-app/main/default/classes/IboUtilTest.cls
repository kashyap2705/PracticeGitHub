/*******************************************************************************************
* @Name     IboUtilTest 
* @Author     Michael Khan(EPAM)  
* @Date         
* @Group        
* @Description  This is test class for IboUtil class
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 
*******************************************************************************************/
@isTest(SeeAllData=false)
private class  IboUtilTest {
    
    @testSetup
    public static void createTestData() {
        
        Account acc=new Account ( 
                Name = 'John',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE', 
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Short_Name__c = 'John',
                IBIS_ID__c = '000001',
                State_Abbr__c = 'SA',
                Website = 'www.test.com'
            );
            insert acc;
        
        Contact con = new Contact (
                Salutation = 'Mr.',
                LastName = 'Messi',
                MobilePhone = '30992907711',
                HomePhone = '30992907711',
                //OtherPhone = '+30992907711',
                Email = 'Homeemail@example.com',
                Birthdate = Date.today().addYears(-20),
                Alternative_Email__c  = 'noname@example.commm',
                FirstName = 'noname',
                MailingCity = 'Palm Coast',
                MailingState = 'Florida',		//added by Shahrukh on 25/09/24 due to test class failure
                MailingCountry = 'United States',
                MailingPostalCode = '32137',
                MailingStreet = 'street',
                AccountId = acc.Id,
                Full_time_Part_time__c = 'Full Time',
                Number_of_years_at_school__c = '4',
                Phone = '13861234567',
                Qualifications__c = 'BS',
                Job_Title__c = 'Blah',
                Birth_Locale__c   = 'sea',
                Country_of_Birth__c = 'Armenia'
            );
        insert con;
        
        IB_View_State_Contacts__c ib_View=new IB_View_State_Contacts__c(Contact_ID__c=con.Id,Account_ID__c=acc.id,Active__c=true);                
        insert ib_View;
    }
    
    @isTest
    static void test_Util() {
        IboUtil sampleObject = new IboUtil();
        system.debug(IboUtil.GSSS_QUEUE_NAME);
        system.debug(IboUtil.ORIGIN_EMAIL);
        
        system.debug(IboUtil.Ib_language_policy);
        system.debug(IboUtil.Ib_terms_and_Conditions);
        system.debug(IboUtil.IB_privacy_policy);
        system.debug(IboUtil.Copyright);
        
        system.debug(IboUtil.SUPPORT_CASE_RT_ID);
        system.debug(IboUtil.ROLE_INVITED_RT_ID);
        system.debug(IboUtil.getContactIdForSystemAdmin());
        
        system.debug(IboUtil.PIMS_PROGRAMME_STATUS);
        system.debug(IboUtil.PIMS_IB_PROGRAMME);
        system.debug(IboUtil.PIMS_IB_STAFF_CONTACT_INFORMATION);
        
        IboUtil.showLimits('Test Method');
    }
}