@isTest
public class Programme_Status_Test {
@isTest
static void testBatchJob()
{
    try {
            Account acct = TestsUtil.createAccount('Test Account');
            insert acct;
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','XYZ',acct);
            insert country;
            
             Google_maps__c mapObj=new Google_maps__c(Enable_Geocoding_API_Calls__c=true,Google_Geocoding_API_Key__c='asdkgasjkfgasjdgfdsfa');
             insert mapObj;
            
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
    
        Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
        Id communityprofileId = [select Id from Profile where name='system administrator' and UserLicenseId=:userLicenseId].id;
    
            User usr = new User(Alias = 'ibport', Email='ibportaluser1@testorg.com',
        EmailEncodingKey='UTF-8',FirstName='TriagePageTest1', LastName='Testing1', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = communityprofileId,
        TimeZoneSidKey='America/Los_Angeles', UserName='ibportaltestuser1@testorg.com');

        usr.Bypass_Validation_Rules__c = true;
       
        insert usr;

            
            //Insert IB Programme Record
            IB_Programme__c prg = new IB_Programme__c();
            prg.Name = 'Testing Programmme';
            prg.StageName__c = 'Evaluation';
            prg.Status__c = 'Authorized';
            prg.Date_Decision_on_Candidacy__c = Date.today();
            prg.Old_Withdrawn_Status_Date__c = Date.today();
            prg.Exam_Session__c = 'May';
            prg.Invoice_Date__c = 'Aug 1 2019';
            prg.Primary_Language_of_Instruction__c = 'English';
            prg.Language_of_Correspondence__c = 'English';
            prg.Street_Address__c = address.id;
            prg.Account__c = acct.id;
            prg.Date_Decision_on_Authorization__c = Date.today();
            prg.Owner__c = usr.id;
            insert prg;  
       
     
    
    
      test.starttest();
    
    Programme_Status ps1 = new Programme_Status();

    String sch = '0 0 23 * * ?'; 
    
    system.schedule('Test Programme Status', sch, ps1);  

    test.stoptest();
    }
               catch (Exception ex) {
               System.debug('Exception '+ex);
           }
  
} 
 
}