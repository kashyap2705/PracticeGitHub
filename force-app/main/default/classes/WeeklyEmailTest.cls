@isTest 
public class WeeklyEmailTest {
    
    @isTest public static void testOne()
    {
        Date birthdate = date.today().addYears(-20);
        account acct = TestsUtil.createAccount('Test Account');
        acct.IBIS_ID__c = '717171';
        acct.Country__c = 'UNITED STATES';
        acct.Sub_region__c = 'NORTHERN AMERICA';
        acct.Region__c = 'IBAEM';
        acct.Language_Of_Correspondance__c = 'English';
        insert acct;
        IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','IBAEM',acct);
        insert country;
        Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com', birthdate, country);
        contactib.User_Language__c = 'English';
        contactib.AccountId = acct.id;
        contactib.Country__c = country.id;
        insert contactib;
        List<IB_Role_Repository__c> repoList = new List<IB_Role_Repository__c>();
        IB_Role_Repository__c role =  TestsUtil.createRoleRepoWithParams('Course Outline Reader', 'Fully Qualified', 'Learning Centre', 'Administratio');
        repoList.add(role);
        IB_Role_Repository__c role1 =  TestsUtil.createRoleRepoWithParams('Reader', 'Fully Qualified', 'Learning Centre', 'Administratio');
        repoList.add(role1);
        insert repoList;
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
        prg.IBCC_Implementation_Phase__c = 'Phase 1';
        insert prg;  
        
        IB_Role__c ibrole = TestsUtil.createIbRole(role.id,contactib.id);
        ibrole.Programme_Selection__c = 'DP';
        insert ibrole;
        
        IB_Role__c ibrole1 = TestsUtil.createIbRole(role1.id,contactib.id);
        ibrole1.Programme_Selection__c= 'DP';
        insert ibrole1;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acct.Id);
        insert opp1;
        IB_Subject__c ibsub = IBSubjectTestDataFactory.createSubject(null);
        insert ibsub;
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        Test.startTest();
        Campaign camp1 = TestsUtil.createCampaign('DP Test', acct.Id, opp1.Id, recordTypeId);
        camp1.Status = 'Planned/Ready for Staffing';
        camp1.Related_IB_Programme__c = prg.id;
        camp1.Type = 'Authorization';
        camp1.Sub_Type__c = 'Course Outline Reading';
        camp1.Venue_Account__c = acct.Id;
        camp1.Event_Organizer_Account__c =acct.id;
        //camp1.IB_subject__c = 'a1d20000002FhED';
        camp1.IB_subject__c = ibsub.Id;
        camp1.StartDate = birthdate;
        camp1.EndDate = Date.today()+7;
        camp1.Required_Number_of_Educators__c = 5;
        //camp1.Staffing_Event_Published__c = true;
        camp1.IB_Role__c = role.id;
        insert camp1;
        
        Staffing_Event__c staffingevent = TestsUtil.createStaffingEvent('Event', camp1.id, acct.id);
        insert staffingevent;
        
        IB_Event_Role__c ibeventrole1 = TestsUtil.createIbEventRole(5, camp1.id);
        ibeventrole1.IB_Programme__c = 'DP';
        ibeventrole1.IB_Role__c = role.id;
        ibeventrole1.Staffing_Event__c = staffingevent.id;
        insert ibeventrole1;
        
        Campaign camp2 = TestsUtil.createCampaign('DP Test', acct.Id, opp1.Id, recordTypeId);
        camp2.Status = 'Planned/Ready for Staffing';
        camp2.Related_IB_Programme__c = prg.id;
        camp2.Type = 'Authorization';
        camp2.Sub_Type__c = 'Candidacy Consultation';
        camp2.Venue_Account__c = acct.Id;
        camp2.StartDate = birthdate;
        camp2.EndDate = Date.today()+7;
        camp2.Event_Organizer_Account__c =acct.id;
        camp2.Required_Number_of_Educators__c = 5;
        //camp2.Staffing_Event_Published__c = true;
        camp2.IB_Role__c = role1.id;
        insert camp2;
        
        Staffing_Event__c staffingevent2 = TestsUtil.createStaffingEvent('Event', camp2.id, acct.id);
        insert staffingevent2;
        
        IB_Event_Role__c ibeventrole2 = TestsUtil.createIbEventRole(5, camp2.id);
        ibeventrole2.IB_Programme__c = 'DP';
        ibeventrole2.IB_Role__c = role1.id;
        ibeventrole2.Staffing_Event__c = staffingevent2.id;
        insert ibeventrole2;
        
     
        
        WeeklyEmailComponentController obj =  new WeeklyEmailComponentController();
        obj.getcont();
        obj.getcor_count_cp();
        obj.getcor_count_dp();
        obj.getcor_count_myp();
        obj.getcor_count_pyp();
        obj.getcount_cp();
        obj.getcount_dp();
        obj.getcount_myp();
        obj.getcount_pyp();
        
        
        
        WeeklyEmail sh1 = new WeeklyEmail();
        String sch = '0 0 22 * * ?'; 
        system.schedule('WeeklyEmail', sch, sh1);  
        
        system.debug('Test Run ');
        Test.stopTest();
        
        
    }

}