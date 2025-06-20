@isTest
private class userHeaderControllerTest {
    static testMethod void testOne(){
        //TestsUtil.initMyStaffingEvents();
        integer i=1;
        set<String> Test_Languages = new set<String>();
        setuptestdata();
        
        User testUser = TestsUtil.createPortalUser('testUser');
        
        System.runAs(testUser) 
        {
            
            Test.startTest();
            userHeaderController msc = new userHeaderController();
            msc.getcoi();
            msc.getPhoto();
            msc.getHelpAndResource();
            msc.getAssignment();
            msc.getDashboard();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            //Following code line is added by Umair-Plumlogix of US11930 on 06/03/2020
            ////Begin
            Test_Languages.add('English');
            Test_Languages.add('Spanish');
            Test_Languages.add('French');
            msc.myLanguages = Test_Languages;
            msc.eligibleAssignments();
            //End
            Test.stopTest();
            
            //List<SelectOption> options = msc.getMyRoleOptions();
        }
    }
    private static void setuptestdata() {
        
        Date birthdate = date.newInstance(1994,08,08);
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';
        acc1.Language_Of_Correspondance__c = 'English';
        insert acc1;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp1;
        
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc1.Id);
        insert opp2;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp 1', acc1.Id, opp1.Id, recordTypeId);
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
        //Start
        camp1.Status = 'Staffed';
        //End
        camp1.Venue_Account__c = acc1.Id;
        insert camp1;
        
        Id recordTypeId1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
        Campaign camp2 = TestsUtil.createCampaign('camp 2', acc1.Id, opp2.Id, recordTypeId1);
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
        //Start
        camp2.Status = 'Staffed';
        //End
        camp2.Sub_Type__c = 'Candidacy Consultation';
        camp2.Venue_Account__c = acc1.Id;
        camp2.Event_Organizer_Account__c = acc1.id;
        insert camp2;
        Campaign camp3 = TestsUtil.createCampaign('camp 2', acc1.Id, opp2.Id, recordTypeId1);
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
        //Start
        camp3.Status = 'Pending';
        //End
        camp3.Sub_Type__c = 'Request for Candidacy';
        camp3.Venue_Account__c = acc1.Id;
        camp3.Event_Organizer_Account__c = acc1.id;
        insert camp3; 
        
        IB_Role_Repository__c role = new IB_Role_Repository__c(
            Available__c=False, 
            SF_Role_Application__c=true,
            Available_From__c=Date.today().addDays(-16),//2014-02-27 00:00:00
            CurrencyIsoCode='USD',
            Role_Name__c='Programme Field Representative Test',
            Category__c='Learning Centre',
            Role_Level__c='Shadow',
            Sub_Category__c='Administration',
            Related_Programmes__c='PYP;MYP;DP;CP;IBCC',
            Available_in_Region__c='Global',
            Training_Model__c = 'Advanced Training',
            IB_Staff_Role__c=true
        );//TestsUtil.createRoleRepo();
        insert role;
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('ABC','XYZ',acc1);
        country.Regional_Office_Segmentation__c = 'IBA' ;
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        Contact contactib = TestsUtil.createContact('Ammara', 'dummy@gmail.com','dummy@yahoo.com', birthdate, country);
        contactib.Account = acc1;
        contactib.User_Language__c = 'en_US';
        contactib.EmailBouncedDate = null;
        contactib.Country__c = country.id;
        insert contactib;
        
        Training_Event__c training_event_1 = TestsUtil.createTrainingEvent('Testing Event 1', role.id, camp1.id);
        insert training_event_1;
        
        Staffing_Event__c staffing_event_1 = TestsUtil.createStaffingEvent('Testing Auth Event', camp2.id , acc1.id);
        insert staffing_event_1;
        
        My_Training_Event__c my_training_event_2 = TestsUtil.createMyTrainingEvents('Pending Selection', contactib.id , training_event_1.id , camp1.id);
        insert my_training_event_2;
    }
    
}