@isTest
public class TestOnSubmissionEmailTrigger {
@isTest
    private static void testOne()
    {
        Date birthdate = date.today();

       Account acct = TestsUtil.createAccount('Test Account');
       insert acct;

       IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','XYZ',acct);
       insert country;

       Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com', birthdate, country);
       contactib.Account = acct;
       insert contactib;

       IB_Role_Repository__c role = TestsUtil.createRoleRepo();
       insert role;

        //Insert IB Address Record
       IB_Address__c address = new IB_Address__c();
       address.Name = 'Testing Address';
       address.Status__c = 'Active';
       address.Address_Line_1__c = 'Bahria Town';
       address.City__c = 'Lahore';
       address.Postal_Code__c = '2021';
       address.Country__c = country.Id;
       address.IB_Account__c=acct.id;
       insert address;

        //Insert IB Programme Record
       IB_Programme__c prg = new IB_Programme__c();
       prg.Name = 'Testing Programmme';
       prg.StageName__c = 'Consultation process';
       prg.Status__c = 'Candidate';
       prg.Sub_Stage__c = 'Candidacy Approved';
       prg.Date_Decision_on_Candidacy__c = Date.today();
       prg.Exam_Session__c = 'May';
       prg.Invoice_Date__c = 'Aug 1 2019';
       prg.Primary_Language_of_Instruction__c = 'English';
       prg.Language_of_Correspondence__c = 'English';
       prg.Street_Address__c = address.id;
       
        prg.Account__c = acct.id;
       insert prg;

IB_Application_Attachment__c att = new IB_Application_Attachment__c();
att.IB_Programme__c = prg.id;
insert att;


course_outline_reading__C cor = new course_outline_reading__C();
cor.Application_Attachment__c = att.id;
cor.Programme__c = prg.id;
//        cor.status__c ='Submitted';
insert cor;
       
    }
}