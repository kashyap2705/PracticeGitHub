@isTest
private class StaffingEventTriggerHandlerTest {

    @isTest
    private static void testBeforeTriggers(){

        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';
        insert acc1;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp1;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        camp1.Status = 'Pending';
        camp1.Venue_Account__c = acc1.Id;
        insert camp1;
    }
    
    //Added by Shahrukh on 20/07/2023 for ECM00637 -- START --
    @isTest
    private static void testEventCancelled() {
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';
        insert acc1;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        Contact con1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        con1.OtherStreet = 'other_street';
        con1.OtherCity = 'other_city';
        con1.OtherStateCode = 'USCA';
        con1.OtherPostalCode = 'postal';
        con1.OtherCountryCode = 'US';
        con1.Country__c = country.id;
        insert con1;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp1;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        //below line modified by Prerna
        IB_Role_Repository__c repo = TestsUtil.createRoleRepoForTeamLeader();
        insert repo;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, con1.Id);
        insert ibRole1;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        insert camp1;
        
        My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', acc1.Id, 
                                                                                 camp1.Id, null, ibRole1.Id);
        insert myStaffEvent1;
        
        Test.startTest();
            camp1.Status = 'Cancelled';
            update camp1;
        Test.stopTest();
        
        My_Staffing_Event__c staffingEvent = [SELECT Id, WithdrawalReason__c FROM My_Staffing_Event__c WHERE Id = :myStaffEvent1.Id];
        //System.assertEquals('Event cancelled', staffingEvent.WithdrawalReason__c);
    }
    //Added by Shahrukh on 20/07/2023 for ECM00637 -- END --

    @isTest
    //method changed from private to public by Prerna on 23-05-2023
    public static void testUpdate() {
        
        Date birthdate = date.today().addYears(-30);        //modified by Shahrukh on 20/07/2023 for ECM00637 -- error resolution --
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        initCustomSettings (campaigns.get(0), true);
        
        IB_Role_Repository__c role = TestsUtil.createRoleRepoForTeamLeader();
        insert role;
        
        /*Account acct = TestsUtil.createAccount('Test Account');
        acct.Language_Of_Correspondance__c = 'English';
        acct.Region__c = 'IBA';
        insert acct;*/
        Account acct = new Account();
        acct.Name = 'Test School';
        acct.Sub_region__c = 'ASIA';
        acct.Region__c = 'IBA';
        acct.Country__c = 'Australia';
        acct.Language_Of_Correspondance__c = 'English';
        acct.Legal_Status__c = 'Private';
        acct.State_Abbr__c = 'SA';
        acct.Lead_Account__c = true;
        insert acct;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','XYZ',acct);
        country.Regional_Office_Segmentation__c = 'IBA' ;
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        /*Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com', birthdate, country);
        contactib.Account = acct;
        contactib.User_Language__c = 'en_US';
        contactib.EmailBouncedDate = null;
        contactib.Country__c = country.id;
        //below email added by Prerna
        contactib.Email = 'test@test.com';
        insert contactib;*/
        //Insert IB Account Record
        
        Contact contactib = PimsTestUtil.createContact('Test Contact','test@gmail.com', 'test@gmail.com', Date.today(), acct);
        contactib.User_Language__c = 'en_US';
        contactib.EmailBouncedDate = null;
        contactib.Country__c = country.id;
        insert contactib;
        System.debug('contactib');
        
        //code added by Prerna on 15-03-2024 --Starts--
        IB_Programme__c prog = IbProgramFactoryTest.createProgrammeForAccount(acct,'PYP');
        prog.StageName__c = 'Verification visit';
        prog.Sub_Stage__c = 'Allocate visit team';
        prog.Contact_Programme_Coordinator__c = contactib.id;
        prog.Contact_Head_of_School__c = contactib.id;
        insert prog;
        //code added by Prerna on 15-03-2024 --ends--
        
        //code added by Prerna on 22-08-2024 --STARTS--
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        //code added by Prerna on 22-08-2024 --ENDS--
        
        Campaign camp1 = campaigns.get(0);
        //camp1.Staffing_Event_Published__c = true;
         //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //Begin
        camp1.Status = 'Staffed';//End
        camp1.Required_Number_of_Educators__c = 2;
        camp1.Training_Language__c = 'English';
        camp1.Traing_Event_Published__c = true;  
        
        //code added by Prerna on 15-03-2024 --Starts--
        camp1.EndDate = System.Today()+10;  
        camp1.StartDate = System.Today()-10;  
        camp1.Delivery_Mode__c = 'Remote';
        camp1.Related_IB_Programme__c = prog.id;
        //below line added by Prerna on 22-08-2024
        camp1.RecordTypeId = recordTypeId;
        //code added by Prerna on 15-03-2024 --Ends--
        
        Campaign camp2 = campaigns.get(1);
        //camp2.Staffing_Event_Published__c = true;
        camp2.Required_Number_of_Educators__c = 2;
        camp2.Venue_Account__c = acct.id;
        camp2.Event_Organizer_Account__c = acct.id;
        camp2.Training_Language__c = 'Spanish';
        //code added by Prerna on 21-03-2024 --Starts--
        camp2.EndDate = System.Today()+10;  
        camp2.StartDate = System.Today()-10;  
        camp2.Delivery_Mode__c = 'Hybrid';
        camp2.Related_IB_Programme__c = prog.id;
        //below line added by Prerna on 22-08-2024
        camp1.RecordTypeId = recordTypeId;
        //code added by Prerna on 21-03-2024 --Ends--
         //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //Begin
        camp2.Status = 'Staffed';//End
        camp2.Traing_Event_Published__c = true;  
        
        //code started by Prerna
        
        IB_Role_Repository__c teamMemberRole = TestsUtil.createRoleRepoForTeamLeader();
        teamMemberRole.Role_Name__c='School Visit Team Member';
        insert teamMemberRole;
        List<My_Staffing_Event__c> myAssignment = new List<My_Staffing_Event__c>();
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_001', acct.Id, camp1.Id, null, role.Id, contactib.id));
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_002', acct.Id, camp1.Id, null, teamMemberRole.Id, contactib.id));
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_001', acct.Id, camp2.Id, null, role.Id, contactib.id));
        myAssignment.add(TestsUtil.createMyStaffingEventForTeamLeader('test_staf_name_002', acct.Id, camp2.Id, null, teamMemberRole.Id, contactib.id));
        insert myAssignment;
        //code by prerna ends
        
        //code added by Prerna on 23-05-2024 -- STARTS--
        Test.startTest();
        IB_Role_Repository__c pcRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert pcRepo;
        IB_Role__c pcRole = PimsTestUtil.createIbRole(pcRepo.Id, contactib.Id, acct.Id);
        pcRole.IB_Programme_New__c = prog.Id;
        pcRole.Start_Date__c = Date.today();
        insert pcRole;
        //code added by Prerna on 23-05-2024 -- ends--
        
        update campaigns;
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        Map<Id, Campaign> camps = new Map<Id, Campaign> (TestsUtil.getCampaigns());
        
        Training_Event__c training_event_1 = TestsUtil.createTrainingEvent('Testing Event 1', role.id, camp1.id);
        insert training_event_1;
        
        My_Training_Event__c my_training_event_1 = TestsUtil.createMyTrainingEvents('Pending Selection', contactib.id , training_event_1.id , camp1.id);
        insert my_training_event_1;
        
        Training_Event__c training_event_2 = TestsUtil.createTrainingEvent('Testing Event 2', role.id, camp2.id);
        insert training_event_2;
            
         My_Training_Event__c my_training_event_2 = TestsUtil.createMyTrainingEvents('Pending Selection', contactib.id , training_event_2.id , camp2.id);
        insert my_training_event_2;
        
         my_training_event_2.Application_Status__c = 'Confirmed';
        my_training_event_2.Invitation_Response__c = 'Accepted';
        my_training_event_2.Level_of_Interest__c = 'Interested';
        update my_training_event_2;
        
        //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //Begin
        camp2.status = 'Participants Confirmed';
        camp1.status = 'Participants Confirmed';
        update campaigns;//End
        
        camp2.Status = 'Complete';
        camp1.Status = 'Cancelled';
        update campaigns;
        Test.stopTest();
    
    }
   
    @isTest
    private static void testDeleteWithStaffingEvent() {
        init();
        
        List<Campaign> camps = TestsUtil.getCampaigns();
        System.assertEquals(2, camps.size());
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        
        try {
            delete staffEvents;
        } catch (Exception e){
            System.debug('>>>>>>>>>>>>>>' + e.getMessage());
        }
    }
    
        
    @isTest
    private static void testDeleteStartDateError() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        campaigns.get(0).StartDate = Date.today().addDays(-20);
        campaigns.get(1).StartDate = Date.today().addDays(-20);
        update campaigns;
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        
        try {
            delete staffEvents;
        } catch (Exception e){
            System.debug('>>>>>> error >>>>>>>>' + e.getMessage());
        }
    }
    
        
    @isTest
    private static void testDeleteWithoutStaffingEvents() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());

        delete campaigns;
    }
            

    
    @isTest
    private static void testNoProfessionalDevelopmentTriggerProp() {
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
        
        Campaign camp1 = campaigns.get(0);
        camp1.Staffing_Event_Published__c = true;
        camp1.Required_Number_of_Educators__c = 2;
        //This Part is being commented by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //camp1.Traing_Event_Published__c = true;
        
        try {
        
            update campaigns;
        
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
            System.assert(e.getMessage().contains('ProfessionalDevelopment was not found'));
        }
    }
    
    
    @isTest
    private static void testNoTriggerProps() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
         
        Campaign camp1 = campaigns.get(0);
        //This line is being commented by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //camp1.Staffing_Event_Published__c = true;
        camp1.Required_Number_of_Educators__c = 2;
        camp1.Status = 'Staffed';
        camp1.Traing_Event_Published__c = true;  
        
        try {
        
            update campaigns;
        
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
            //System.assert(e.getMessage().contains('SchoolServices was not found'));
        }
    }
    
    
    
    @isTest
    private static void testUpdateProffessionalDevelopmentTriggerProps() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        
        initCustomSettings (campaigns.get(0), true);
         
        Campaign camp1 = campaigns.get(0);
        camp1.Staffing_Event_Published__c = true;
        camp1.Required_Number_of_Educators__c = 2;
        //This line is being commented by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //camp1.Traing_Event_Published__c = true;  
        
        try {
        
            update campaigns;
        
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
            System.assert(e.getMessage().contains('SchoolServices was not found'));
        }
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        
        System.debug('camp1 >>> RT' + camp1.RecordTypeId);
        //System.debug('RT >>>>' + staffEvents.get(0).RecordTypeId);
    }   

   @isTest
    private static void testRemoveAccestoAccount() {
    
        initCampaigns();
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
     
        StaffingEventTriggerHandler.RemoveAccountAccess(campaigns);
    }
    @isTest
    private static void testUpdateSchoolServicesTriggerProps() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        
        initCustomSettings (campaigns.get(0), false);
         
        Campaign camp1 = campaigns.get(0);
         //camp1.Staffing_Event_Published__c = true;
        camp1.Status = 'Staffed';
        camp1.Required_Number_of_Educators__c = 2;
        camp1.Traing_Event_Published__c = true;  
        
        try {
        
            update campaigns;
        
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
        }
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        System.assert(staffEvents.size() == 0);
    }   
    
    
    
    @isTest
    private static void testWithIbEventRoles() {
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
         Campaign camp1 = campaigns.get(0);
        
        initCustomSettings (camp1, true);

        IB_Event_Role__c eventRole = TestsUtil.createIbEventRole(23, camp1.Id);
        eventRole.Staffing_Event__c = null;
        insert eventRole;
       
        camp1.Staffing_Event_Published__c = true;
        camp1.Required_Number_of_Educators__c = 2;
        //This line is being commented by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //camp1.Traing_Event_Published__c = true;  
        update camp1;
        
        List<Staffing_Event__c> staffEvents = TestsUtil.getStaffingEvents();
        Map<Id, Campaign> camps = new Map<Id, Campaign> (TestsUtil.getCampaigns());
        
        System.assertEquals(1, staffEvents.size());
        
        System.assert( camps.containsKey( staffEvents.get(0).IB_Event__c ));
    }
    
    //Modified by Shahrukh on 25/07/2023 to resolve issue -- START --
    @isTest
    private static void send_email() {
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        
        initCustomSettings (campaigns.get(0), false);
        
        //This Part of Code is being updated by Ammara-Plumlogix,as Part od CR-685 on 3/25/2020
        //Begin
        User u = PimsTestUtil.createPortalUserPYP('dummy123+test.prod@gmail.com');
        insert u;
        Set<String> user_set = new Set<String>();
        user_set.add(u.Email);
        //End
       
        try
        {
            //This Part of Code is being updated by Ammara-Plumlogix,as Part od CR-685 on 3/25/2020
            //Begin
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'English');
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'Spanish');
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'French');
            //End
        }
        catch(Exception ex) {
            system.debug('Exception '+ex);
        }

    }
    //Modified by Shahrukh on 25/07/2023 to resolve issue -- END --
    
    /*@isTest
    private static void send_email() {
        Date birthdate = date.today().addYears(-30);        //modified by Shahrukh on 20/07/2023 for ECM00637 -- error resolution --
        
        Account acct = TestsUtil.createAccount('Test Account');
        acct.Language_Of_Correspondance__c = 'English';
        acct.Region__c = 'IBA';
        insert acct;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','XYZ',acct);
        country.Regional_Office_Segmentation__c = 'IBA' ;
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com', birthdate, country);
        contactib.Account = acct;
        contactib.User_Language__c = 'en_US';
        contactib.EmailBouncedDate = null;
        contactib.Country__c = country.id;
        insert contactib;
        //This Part of Code is being updated by Ammara-Plumlogix,as Part od CR-685 on 3/25/2020
        //Begin
        User u = PimsTestUtil.createPortalUserPYP('dummy123+test.prod@gmail.com');
        insert u;
        Set<String> user_set = new Set<String>();
        user_set.add(u.Email);
        //End
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
        prg.IBCC_Implementation_Phase__c = 'Phase 1';
        insert prg;  
        
        IB_Role__c ibrole = TestsUtil.createIbRole(role.id,contactib.id);
        ibrole.Status__c = 'Applicant';
        ibrole.Programme_Selection__c = 'PYP';
        insert ibrole;
        
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getCampaigns();
        
        initCustomSettings (campaigns.get(0), false);
         
        Campaign camp1 = campaigns.get(0);
        
        List<IB_Role__c> list_ibrole = new List<IB_Role__c>();
        list_ibrole.add(ibrole);
        
        camp1.Required_Number_of_Educators__c = 2;
        camp1.Traing_Event_Published__c = true;  
        //This line is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        camp1.Status = 'Staffed';//End
        camp1.IB_Role__c = role.id;
        camp1.Training_Event_Type__c = 'Advanced Training';
        camp1.Related_IB_Programme__c = prg.Id;
        camp1.Traing_Event_Published__c = true;
        camp1.Event_Organizer_Account__c = acct.id;
        camp1.Venue_Account__c = acct.id;
        camp1.Training_Language__c ='English';
        //update camp1;
        
        
        Training_Event__c training_event = TestsUtil.createTrainingEvent('Testing Event', role.id, camp1.id);
       
        try
        {
             insert training_event;
             //This Part of Code is being updated by Ammara-Plumlogix,as Part od CR-685 on 3/25/2020
             //Begin
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'English');
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'Spanish');
            StaffingEventTriggerHandler.Send_Email(user_set, '22/01/2020' , 'French');
            //End
        }
        catch(Exception ex) {
            system.debug('Exception '+ex);
        }

    }*/

    @isTest
    private static void testPreventCloseEvent() {
        init();

        List<Campaign> campaigns = TestsUtil.getCampaigns();
        Campaign camp1 = campaigns.get(0);
        Test.startTest();
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c staff1 = myStaffingEvents.get(0);

        staff1.IB_Event__c = camp1.Id;
        staff1.Application_Status__c = 'Pending Selection';

        update staff1;

        camp1.Status = 'Confirmed';
        try{
            update camp1;
        } catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('You can not close an event with pending educators.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
        Test.stopTest();
    }
    
    private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc2.IBIS_ID__c = '727272';
        insert new List<Account> {acc1,acc2};
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2};
    }   


        
    
    private static void initStaffingEvents(List<Campaign> campaigns, List<Account> accounts){
        
        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', campaigns.get(0).Id, accounts.get(0).Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', campaigns.get(1).Id, accounts.get(0).Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        insert new List<Staffing_Event__c>{staffEvent1, staffEvent2};
    }
    
    
    
    private static void initCustomSettings (Campaign camp, Boolean isProffesionalDevelopment) {
        
        String recordTypeId = [select id,name from recordtype where sobjecttype = 'Staffing_Event__c' limit 1].Id;
        
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        if (! isProffesionalDevelopment ) {
            schoolServicesConf.schoolServiceForStuffEvent__c = recordTypeId;
        }
        schoolServicesConf.schoolServicesCampList__c = String.valueOf(camp.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp.RecordTypeId).substring(0,15);
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        if (isProffesionalDevelopment ) {
            profDevConf.profDevForStuffEvent__c = recordTypeId;
        }
        
        profDevConf.professionalDevelopmentCampList__c = String.valueOf(camp.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp.RecordTypeId).substring(0,15);
        insert profDevConf;
    }
    

    private static void init(){
        initCampaigns();
        
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType()); 
        List<Account> accounts = TestsUtil.getSObjectsByType(Account.getSobjectType());
        
        initStaffingEvents(campaigns, accounts);
        
        List<Staffing_Event__c> staffingEvents = TestsUtil.getStaffingEvents();
        
        initIbEventRoles(staffingEvents);
        
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        
        TestsUtil.initMyStaffingEvents(ibEventRoles, staffingEvents, accounts);
    }
    
    private static void initIbEventRoles(List<Staffing_Event__c> staffingEvents){
        //
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, staffingEvents.get(0).IB_Event__c);
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, staffingEvents.get(1).IB_Event__c);
        
        ibEventRole1.Staffing_Event__c = staffingEvents.get(0).Id;
        ibEventRole2.Staffing_Event__c = staffingEvents.get(1).Id;
        
        insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2};
    }

}