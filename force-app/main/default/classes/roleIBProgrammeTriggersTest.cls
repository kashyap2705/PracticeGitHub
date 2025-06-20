@isTest
public class roleIBProgrammeTriggersTest {
static testMethod void roleIBProgrammeTriggersTest() {
//Created record from scratch
    // Create a test account
    Account testAcct = new Account(
            Name = 'Account Name',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'Short Name',
            Lead_Account__c=true
    
    );
    insert testAcct;
    
    IB_Address__c tmpAdd = new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = testAcct.Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        );
    insert tmpAdd;
        
    IB_Programme__c testIBProgramme = new IB_Programme__c(
            Name = 'PYP Test',
            StageName__c = 'Evaluation', 
            Account__c = testAcct.Id, 
            Close_Date__c = Date.today(), 
            CurrencyIsoCode= 'EUR',
            Primary_Language_Of_Instruction__c = 'English',
            Status__c = 'Interested',
            Programme_Legal_Name__c =  'Test',
            Exam_Session__c = 'May',
            Street_Address__c = tmpAdd.Id,
            Owner__c = '00520000002xbuj'
        );
    insert testIBProgramme;
    
    IB_Country_Segmentation__c testCountry = new IB_Country_Segmentation__c(
            name = 'Austria', 
            Geographical_Sub_Region_Segmentation__c = 'Europe',
            Regional_Office_Segmentation__c ='IBAEM', 
            IBEN_Segmentation__c = 'IBAEM',
            IBEN_Independent_Account__c = testAcct.Id
        );
    insert testCountry;
    
    Contact testContact = new Contact(
            Salutation = 'Mr.',
            LastName = 'Last Name',
            MobilePhone = '+30992907711',
            HomePhone = '+30992907711',
            Phone = '+30992907711',
            Email = 'test123@test.com',
            Birthdate =  Date.today().addYears(-25),
            Country__c = testCountry.id,
            Alternative_Email__c = 'profEmail@test123.com',
            FirstName = 'FN',
            MailingCity = 'Lviv city',
            MailingStateCode = 'USCA',
            MailingCountryCode = 'US',
            MailingPostalCode = '33016',
            MailingStreet = 'street'
        );
    insert testContact;
    
    IB_Role_Repository__c testRoleRepo = new IB_Role_Repository__c(
            Available__c=true, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
            CurrencyIsoCode='EUR',
            Role_Name__c='Programme Coordinator',
            Category__c='Learning Centre',
            Role_Level__c='Fully Qualified;',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );
    insert testRoleRepo;
    
    
    testRoleRepo.Prevent_Duplicates__c = true;
    testRoleRepo.DOB_Mandatory__c = true;
    update testRoleRepo;
    
    IB_Role__c testRoleAndApp = new IB_Role__c(
            IB_Contact__c = testContact.Id,
            IB_Account__c = testAcct.Id,
            IB_Programme_New__c = testIBProgramme.Id,
            IB_Role__c = testRoleRepo.Id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Applicant',
            Active__c = true,
            Role_Level__c = 'Fully Qualified'
        );
    //insert testRoleAndApp;
    
    try {
        IB_Role__c testRoleAndApp2 = new IB_Role__c(
                IB_Contact__c = testContact.Id,
                IB_Account__c = testAcct.Id,
                IB_Programme_New__c = testIBProgramme.Id,
                IB_Role__c = testRoleRepo.Id,
                Programme_Selection__c='PYP;MYP;DP;IBCC',
                Status__c='Applicant',
                Active__c = true,
                Role_Level__c = 'Fully Qualified'
            );
         insert new List<IB_Role__c>{testRoleAndApp,testRoleAndApp2};
        //insert testRoleAndApp2;
        throw new TriggerException('An exception should have been thrown by the trigger but was not');
    }
    catch(Exception e) {
        Boolean expectedExceptionThrown = e.getMessage().contains('There already exists a Role and Application with the same Role and End Date associated with this Programme.');
        //System.AssertEquals(expectedExceptionThrown, true);
    }
     Date dd = Date.newInstance(1997, 12, 9);
    testContact.Birthdate = dd;
  //  update testContact;
    
    //try {
        testRoleAndApp.Programme_Selection__c ='PYP;MYP;DP';
        //update testRoleAndApp;
    //    throw new TriggerException('An exception should have been thrown by the trigger but was not');
    //}
    //catch(Exception e) {
    //    Boolean expectedExceptionThrown = e.getMessage().contains('Please select a Contact with a Birthdate populated or update the Birthdate on the Contact selected');
    //    System.AssertEquals(expectedExceptionThrown, true);
    //}
    
    try {
        testIBProgramme.Status__c = 'Candidate';
        update testIBProgramme;
        throw new TriggerException('An exception should have been thrown by the trigger but was not');
    }
    catch(Exception e) {
        Boolean expectedExceptionThrown = e.getMessage().contains('Please make sure the Programme has a Head of School and Programme Coordinator before updating from Interested to Candidate');
        //System.AssertEquals(expectedExceptionThrown, true);    
    }
    
    //delete testRoleAndApp;
     
     
    }
}