@isTest
public class IBEventPublishedFuture_Test {
    
@isTest static void testPublishIBEvent ()
{
    campaign cmp = new campaign ();
    cmp.name = 'Testing event';
    cmp.Sub_Type__c = 'Request for Candidacy';
    cmp.Status = 'Pending';
    try
     {
    insert cmp;
    cmp.Status = 'Planned / Ready for Staffing';
    update cmp;
    /*Test for Future Method */
         IBEventPublishedFuture.publishIBEvent(new list<id>{cmp.id});
    
    
    }
    catch (exception e)
    {
        system.debug(e.getMessage());
    }
    

    
    
    
    
}
    
@isTest static void test_statusanddate ()
{
    try {
        
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
        /*This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        Begin*/
        account.IBIS_ID__c ='344918';//End
        account.Sub_region__c = 'ASIA';
        account.Region__c = 'IBA';
        account.Country__c = 'Australia';
        account.Language_Of_Correspondance__c = 'English';
        account.Legal_Status__c = 'Private';
        account.State_Abbr__c = 'SA';
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
        prg.Account__c = account.id;
        /*This line is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        Begin*/
        prg.IBCC_Implementation_Phase__c = 'Phase1';//End
        insert prg;  
        
        //Insert IB Event(Campaign) Record
       campaign cmp = new campaign ();
       cmp.name = 'Testing event';
       cmp.Sub_Type__c = 'Candidacy Consultation';
       cmp.Status = 'Staffed-Pending L1';
       cmp.Related_IB_Programme__c = prg.Id;
       insert cmp;
         
        
    //Method Call  
    Test.startTest();
    IBEventPublishedFuture ibevent = new IBEventPublishedFuture();
    ibevent.status_and_date_automation(prg);
    IBEventPublishedFuture.updateCORStatus(null,null);
        Test.stopTest();
        
 
    
    }
    catch (exception e)
    {
        system.debug('Automation Error : '+e.getMessage());
    }
    


    
    
    
    
}


    
}