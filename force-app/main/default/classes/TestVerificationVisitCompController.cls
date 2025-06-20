@isTest
public class TestVerificationVisitCompController {

    @isTest static void TestOne()
    {
              //Insert IB Country Segmentation Record
         IB_Country_Segmentation__c country = new IB_Country_Segmentation__c();
        country.Country_es__c = 'Australia';
        country.Geographical_Sub_Region_Segmentation__c = 'Asia';
        country.IBEN_Segmentation__c = 'IBA';
        country.Regional_Office_Segmentation__c = 'IBA';   
         insert country;
        
         //Insert IB Account Record
        Account account = new Account();
        account.Name = 'Test School';
        account.Sub_region__c = 'ASIA';
        account.Region__c = 'IBA';
        account.Country__c = 'Australia';
        account.Language_Of_Correspondance__c = 'English';
        account.Legal_Status__c = 'Private';
        account.State_Abbr__c = 'SA';
        account.Lead_Account__c = true;
        insert account;
        
        //Insert IB Address Record
        IB_Address__c address = new IB_Address__c();
        address.Name = 'Testing Address';
        address.Status__c = 'Active';
        address.Address_Line_1__c = 'Bahria Town';
        address.City__c = 'Lahore';
        address.Postal_Code__c = '2021';
        address.Country__c = country.Id;
        address.IB_Account__c=account.id;
        insert address;
        
        
        Contact contact = PimsTestUtil.createContact('Test Contact','test@gmail.com', 'test@gmail.com', Date.today(), account);
        insert contact;
        System.debug('Contact');
        
        //Insert IB Programme Record
        IB_Programme__c prg = new IB_Programme__c();
        prg.Name = 'Testing Programmme';
        prg.StageName__c = 'Consultation';
        prg.Status__c = 'Candidate';
        prg.Sub_Stage__c = 'Candidacy Approved';
        prg.Date_Decision_on_Candidacy__c = Date.today();
        prg.Exam_Session__c = 'May';
        prg.Invoice_Date__c = 'Aug 1 2019';
        prg.Primary_Language_of_Instruction__c = 'English';
        prg.Language_of_Correspondence__c = 'English';
        prg.Street_Address__c = address.id;
        prg.Account__c = account.id;
        prg.Contact_Programme_Coordinator__c = contact.id;
        prg.Contact_Head_of_School__c= contact.id;
        insert prg;  
        
        //Insert IB Event(Campaign) Record
       campaign cmp = new campaign ();
       cmp.name = 'Testing event';
       cmp.Sub_Type__c = 'Candidacy Consultation';
       cmp.Status = 'Staffed';
       cmp.Related_IB_Programme__c = prg.Id;
       insert cmp;
        Test.startTest();
        VerificationVisitCompController obj = new VerificationVisitCompController();
		obj.Camp = cmp.id;
obj.TL=null;
obj.TM1=null;
obj.TM2 = null;
obj.TMA = 0;        
    	obj.getCamp();
        obj.setCamp(cmp.Id);
        
    }
}