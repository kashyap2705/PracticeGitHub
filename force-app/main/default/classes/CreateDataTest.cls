@isTest
public class CreateDataTest 
{
    
     public static testMethod user Test1() { 
    Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
         
         //Programme RecordType
    Recordtype progRT = [Select Id, name From Recordtype Where sObjectType = 'Ib_programme__c' and Name = 'CP'];
         
    User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;
         
         System.runAs(usr)
         {
               Account acc=new Account ( 
            Name = 'John',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'John',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA'
        );
             insert acc;
             List<Account>acp=new List<account>();
             List<Account> accUp=[SELECT Name,IBIS_ID__c from Account WHERE Name='John'];
             
             for(Account c:accUp)
             {
                 c.Language_Of_Correspondance__c = 'Spanish';
                 acp.add(c);
             }
             update acp;
             IB_Country_Segmentation__c ibCon=new  IB_Country_Segmentation__c (
                Name = 'Austria', 
                Geographical_Sub_Region_Segmentation__c = 'Europe',
                Regional_Office_Segmentation__c ='IBAEM', 
                IBEN_Segmentation__c = 'IBAEM',
                IBEN_Independent_Account__c = acc.Id
            );
             insert ibCon;
             
             List<IB_Country_Segmentation__c> ibConn=new List<IB_Country_Segmentation__c>();
             List<IB_Country_Segmentation__c> ibUp=[SELECT Name,Geographical_Sub_Region_Segmentation__c from IB_Country_Segmentation__c WHERE Name='Austria'];
             for(IB_Country_Segmentation__c c: ibUp)
             {
                 c.Geographical_Sub_Region_Segmentation__c='Asia';
                 ibConn.add(c);
             }
             update ibConn;
             
             Contact con=new Contact (Salutation = 'Mr.',
            LastName = 'John',
            MobilePhone = '+30992907711',
            HomePhone = '+30992907711',
            Phone = '+30992907711',
            //OtherPhone = '+30992907711',
            Email = 'email@gmail.com',
            Birthdate = Date.today(),
            Country__c = ibCon.id,
            Alternative_Email__c = 'test@gmail.com',
            FirstName = 'FirstName',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
             
             con.AccountId=acc.id;
             
             
           insert con;


            list<Contact> connAd=new List<Contact>();
             List<Contact> conUp=[SELECT MailingCity,MailingStreet FROM Contact WHERE LastName ='John'];
             
             for(Contact co:conUp)
             {
                 co.MailingCity='Chicago';
                 co.MailingStreet='street2';
                 connAd.add(co);
                 
             }
             update connAd;
             
              IB_Address__c tmpAdd = new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = acc.Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        );
        insert tmpAdd;
             
             IB_Role_Repository__c tmpRepo = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c='Programme Field Representative',
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true);
        tmpRepo.Role_Name__c = 'Programme Coordinator';
             
             insert tmpRepo;
             
              IB_Programme__c tmpProg = new IB_Programme__c(
            Exam_Session__c = 'STRUNK',
            Primary_Language_of_Instruction__c = 'English',
            Status__c = 'Invited',
            Street_Address__c = tmpAdd.Id,
                  //Add recordtype
            RecordTypeId = progRT.Id,
            Account__c = acc.Id
        );
        insert tmpProg;
             
             List<IB_Programme__c> ibProg=new List<IB_Programme__c>();
             list<IB_Programme__c> upProg=[SELECT Primary_Language_of_Instruction__c FROM IB_Programme__c WHERE Status__c='Invited'];
             
             for(IB_Programme__c pc:upProg)
             {
                 pc.Primary_Language_of_Instruction__c='Spanish';
                 ibProg.add(pc);
             }
             
             update ibProg;
             
             
            IB_Role__c ibRole=new IB_Role__c(
            IB_Contact__c = con.Id,
            IB_Role__c = tmpRepo.id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified'
        );
           
             insert ibRole; 
             
             List<IB_Role__c> upIb=new List<IB_Role__c>();
             List<IB_Role__c> ibr=[SELECT Status__c FROM IB_Role__c WHERE Role_Level__c = 'Fully Qualified'];
             
             for(IB_Role__c rc:ibr)
             {
                 rc.Status__c='Declined';
                 upIb.add(rc);
                 
             }
             
             update upIb;
             
             
         }
         return usr;
     }

}