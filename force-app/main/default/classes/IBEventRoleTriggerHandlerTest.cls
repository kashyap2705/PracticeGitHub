@isTest
public class IBEventRoleTriggerHandlerTest {
    @testSetup
    static void testdata(){
        Test.startTest();
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = '1';
        profDevConf.professionalDevelopmentCampList__c = '1,2,3';
        insert profDevConf;

        Account acc1 = new Account();
        Account acc2 = new Account();
        acc1.External_PD_Provider__c = true;
        acc1 = AccountTestDataFactory.createAccount(null, acc1);
        acc2.External_PD_Provider__c = true;
        acc2.IBIS_ID__c = '682382';
        acc2 = AccountTestDataFactory.createAccount(null, acc2);
        insert new List<Account> {acc1,acc2};
        
        //update new List<Account> {acc1,acc2};

        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        
        Campaign camp1 = TestsUtil.createCampaign('camp test name 1', acc1.Id, opp1.Id, recordTypeId);
        Campaign camp2 = TestsUtil.createCampaign('camp test name 2', acc2.Id, opp2.Id, recordTypeId);
        insert new List<Campaign>{camp1,camp2};
        IB_Event_Role__c ibEventRole1 = TestsUtil.createIbEventRole(20, camp1.Id);
        IB_Event_Role__c ibEventRole2 = TestsUtil.createIbEventRole(20, camp2.Id);
        insert new List<IB_Event_Role__c>{ibEventRole1,ibEventRole2};

        Id staffEventRecTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Professional Development', 'Staffing_Event__c').Id;      
        
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', camp1.Id, acc1.Id);
        Staffing_Event__c staffEvent2 = TestsUtil.createStaffingEvent('test_name_st_event_002', camp2.Id, acc1.Id);
        staffEvent1.RecordTypeId = staffEventRecTypeId;
        staffEvent2.RecordTypeId = staffEventRecTypeId;
        insert new List<Staffing_Event__c>{staffEvent1, staffEvent2};
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', acc1);
        insert country;
        
        System.debug('country==='+country.IBEN_Segmentation__c);

        Contact cont1 = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
        //TestsUtil.fillUpContactDetailsInfo(cont1,country.Id);

        cont1.OtherStreet = 'other_street';
        cont1.OtherCity = 'other_city';
        cont1.OtherStateCode = 'USCA';
        cont1.OtherPostalCode = 'other';
        cont1.OtherCountryCode = 'US';
        cont1.Country__c = country.id;

        Contact cont2 = TestsUtil.createContact('test_contact_002', 'yyyy@yyyy.xxx', 'yyyy@yyy.yyy', Date.today().addYears(-24), country);
        //TestsUtil.fillUpContactDetailsInfo(cont2,country.Id);

        cont2.OtherStreet = 'other_street2';
        cont2.OtherCity = 'other_city2';
        cont2.OtherStateCode = 'USCA';
        cont2.OtherPostalCode = 'other2';
        cont2.OtherCountryCode = 'US';
        cont2.Country__c = country.id;

        insert new List<Contact>{cont1, cont2};
        
        

        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        insert repo;
        
        IB_Role__c ibRole1 = TestsUtil.createIbRole(repo.Id, cont1.Id);
        IB_Role__c ibRole2 = TestsUtil.createIbRole(repo.Id, cont2.Id);
        insert new List<IB_Role__c> {ibRole1, ibRole2};
        
        Account acc = acc1;
        acc.Region__c = 'IBAEM';
        acc.External_PD_Provider__c = true;
        update acc;
        List<Campaign> camps = TestsUtil.getSObjectsByType(Campaign.getSobjectType()); 
        for(Campaign c: camps){
            c.Event_Organizer_Account__c = acc.id;
            c.Staffing_Event_Published__c = true;
        }
        update camps;
        My_Staffing_Event__c myStaffEvent1 = TestsUtil.createMyStaffingEvent('test_staf_name_001', acc.Id, 
            camps.get(0).Id, ibEventRole1.Id, ibRole1.Id);
        //staffEvent1.IB_Contact__c = cont1.id;     
        My_Staffing_Event__c myStaffEvent2 = TestsUtil.createMyStaffingEvent('test_staf_name_002', acc.Id, 
            camps.get(1).Id, ibEventRole1.Id, ibRole2.Id);
        //myStaffEvent2.IB_Contact__c = cont2.id;
        System.debug('staffEvent1==='+myStaffEvent1);
        System.debug('staffingEvents==='+myStaffEvent2);
        System.debug('staffEvent2==='+myStaffEvent2);
        System.debug('ibEvents camps==='+camps);
        System.debug('acc==='+acc);
        
        myStaffEvent1.Staffing_Event__c = staffEvent1.Id;
        myStaffEvent2.Staffing_Event__c = staffEvent2.Id;
        
        myStaffEvent1.IB_Contact__c = cont1.Id;
        myStaffEvent2.IB_Contact__c = cont2.Id;
        
        myStaffEvent1.IB_Role__c = repo.Id;
        myStaffEvent2.IB_Role__c = repo.Id;
        
        myStaffEvent1.IB_Programme__c = repo.Related_Programmes__c;
        myStaffEvent2.IB_Programme__c = repo.Related_Programmes__c;

        
        insert new List<My_Staffing_Event__c>{myStaffEvent1, myStaffEvent2};
        Test.stopTest();
    }
    
     @isTest
    public static void testRoleInsertWithCampaign() {
        Test.startTest();
        List<Campaign> camp = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
        IB_Event_Role__c role1 = TestsUtil.getIbEventRoles().get(0);
        System.assert(role1.Id != null, 'Error. IB_Event_Role__c object was not inserted');
        Test.stopTest();
    }
    
    
    
    @isTest
    public static void testRoleInsertWithoutCampaign() {
        Test.startTest();
        IB_Event_Role__c role1 = TestsUtil.createIbEventRole(20, null);
        insert role1;
        
        System.assert(role1.Id != null, 'Error. IB_Event_Role__c object was not inserted');
        Test.stopTest();
    }

    @isTest
    public static void testSetRoleOnEventRoleWithStaffingEventsInitiated() {
        Test.startTest();
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
        List<Account> accs = TestsUtil.getSObjectsByType(Account.getSobjectType());
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        List<IB_Role_Repository__c> repos = TestsUtil.getSObjectsByType(IB_Role_Repository__c.getSobjectType());
        ibEventRoles.get(0).IB_Role__c = repos.get(0).Id;
        ibEventRoles.get(1).IB_Role__c = repos.get(0).Id;
        try {
            update ibEventRoles;
            
        } catch (Exception e) {
            System.assert(e.getMessage().contains(Label.Staffing_Applications), 'MUST Contain error message');
            System.debug('*************' + e.getMessage().contains(Label.Staffing_Applications));
        }
        Test.stopTest();
    }
    
    
    @isTest// test IB_Role__c field set (change) on IB_Event_Role__c object with NO related Staffing Events
    public static void testSetRoleOnEventRoleWithoutStaffingEvents() {
        Test.startTest();
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        
        Id camp1Id = ibEventRoles.get(0).IB_Event__c;
        Id camp2Id = ibEventRoles.get(1).IB_Event__c;
        
        System.assert(camp1Id != null && camp2Id != null, 'Campaign Ids Must be set');
        
        //switch Ids
        ibEventRoles.get(0).IB_Event__c = camp2Id;
        ibEventRoles.get(1).IB_Event__c = camp1Id;
        
        ibEventRoles.get(0).Number_of_Required_Educators__c = 22;
        
        update ibEventRoles;
        
        Map<Id, IB_Event_Role__c> ibEventRolesMap = new Map<Id, IB_Event_Role__c>(TestsUtil.getIbEventRoles());
        
        ibEventRoles.set(0, ibEventRolesMap.get(ibEventRoles.get(0).Id));
        ibEventRoles.set(1, ibEventRolesMap.get(ibEventRoles.get(1).Id));
        
        //assert successfuly updated
        System.assert(ibEventRoles.get(0).Number_of_Required_Educators__c == 22);
        System.assert(ibEventRoles.get(0).IB_Event__c == camp2Id);
        System.assert(ibEventRoles.get(1).IB_Event__c == camp1Id);
        Test.stopTest();
    }   
        
        
   @isTest
    public static void deleteRoleWithStaffingEvent() {
        Test.startTest();
        List<Campaign> campaigns = TestsUtil.getSObjectsByType(Campaign.getSobjectType());
        List<Account> accs = TestsUtil.getSObjectsByType(Account.getSobjectType());
        List<IB_Event_Role__c> ibEventRoles = TestsUtil.getIbEventRoles();
        try{
             delete ibEventRoles;
            } catch (Exception e) {

            System.debug('ERROR **** >>>' + e.getMessage().contains(Label.Staffing_Applications));
                
            System.assert(e.getMessage().contains(Label.Staffing_Applications),
                'Must Forbid deleting if Event Role has Staffing Event');
        } 
        Test.stopTest();
    }   
   }