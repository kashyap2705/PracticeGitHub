/**
* <h1>Test All User Triggers</h1>
* This Test class is to Test all Triggers that are on User Object,DE6118.
* @author  Ahmad Shakeel.
* @version 1.0
* @since   10-10-2019.

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 

*/
@isTest
public class allUserTriggerTest
{
      /**
   * This Method will insert user to test User Triggers,DE6118.
   * @author: Ahmad Shakeel-Plumlogix 
   * @since 10-10-2019
   * @param No parameter.
   * @return void.
   */
    
    @isTest
    public static void disableTriggerMethod()
    {
        Account acc=new Account ( 
            Name = 'TestNew York',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'pepe',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',
            Phone = '+9212345607865'
        );
        IB_Country_Segmentation__c contrySeg=new IB_Country_Segmentation__c (
                Name = 'Austria', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                IBEN_Independent_Account__c = acc.Id
            );
        
        Contact con=new Contact (
            Salutation = 'Mr.',
            LastName = 'Messi',
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
            Email = 'home@test.com',
            Birthdate = Date.today().addYears(-20),
            Country__c = contrySeg.id,
            Alternative_Email__c = 'email@test.com',
            FirstName = 'FN Messi',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
        
        
        insert con;
        
      IB_Role__c rol= new  IB_Role__c(
            IB_Contact__c = con.id,
            //IB_Role__c = repoId,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified'
        );
        
        
        
       /* Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community Advanced'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com',ContactId=con.Id,UserRole);

        usr.Bypass_Validation_Rules__c = true;
       userDeactiveOrFreezeClass.FreezeTriggerActivator=True;
        UserDeactivateClass.TriggerActivator=true;
        insert usr;*/
         userDeactiveOrFreezeClass.FreezeTriggerActivator=True;
        UserDeactivateClass.TriggerActivator=true;
        User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');
        insert u;
      
    }
   
    
      /**
   * This method will update and insert Users,DE6118.
   * @author: Ahmad Shakeel-Plumlogix 
   * @since 10-10-2019
   * @param No parameter.
   * @return Void.
   */
    @isTest
    public static void callInsertTrigger()
    {
        Account acc=new Account ( 
            Name = 'TestNew York',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'pepe',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',
            Phone = '+9212345607865'
        );
        IB_Country_Segmentation__c contrySeg=new IB_Country_Segmentation__c (
                Name = 'Austria', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                IBEN_Independent_Account__c = acc.Id
            );
        
        Contact con=new Contact (
            Salutation = 'Mr.',
            LastName = 'Messi',
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
            Email = 'home@test.com',
            Birthdate = Date.today().addYears(-20),
            Country__c = contrySeg.id,
            Alternative_Email__c = 'email@test.com',
            FirstName = 'FN Messi',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
        
        
        insert con;
        
      IB_Role__c rol= new  IB_Role__c(
            IB_Contact__c = con.id,
            //IB_Role__c = repoId,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified'
        );
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       userDeactiveOrFreezeClass.FreezeTriggerActivator=True;
        UserDeactivateClass.TriggerActivator=true;
        insert usr;
        usr.firstName='UpdateTrigger';
        update usr;
    }


}