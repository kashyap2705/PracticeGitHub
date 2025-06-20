@IsTest
public class TestMyStaffingEventTriggerHandler {
    @testSetup 
    static void setup()
    {
        Id  RecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('External PD Provider Account').getRecordTypeId();  
        Account acc = AccountFactoryTest.createAccountRecord(false);
        acc.RecordTypeId=RecType;
        acc.IBIS_ID__c = 'N123456';
        insert acc;
        
        Process_Automation_Settings__c pasRecord = new Process_Automation_Settings__c();
        pasRecord.Bypass_All_Triggers__c = true;
        pasRecord.SetupOwnerId = UserInfo.getUserId();
        insert pasRecord;
        
        List<Contact> conRecords = ContactFactoryTest.createContacts(1,false,acc);   
        conRecords[0].LastName = 'konpondyCheery';
        conRecords[0].Email = 'konpondycherry@gmail.com';
        conRecords[0].Contact_Type__c = 'PD Provider';
        conRecords[0].MailingState = 'Florida'; // ECM00694
        conRecords[0].MailingCountry = 'United States';
        //conRecords[0].MailingStateCode = 'USFL';
        //conRecords[0].MailingCountryCode = 'US';
        if(!conRecords.isEmpty()){
            insert conRecords;
        }
        User pu = AccountFactoryTest.createCommunityUser('konpondycherry@gmail.com',conRecords[0]);
        insert pu;
        BulkDataFactoryTest.loadRoleRepoData();
        
        IB_Role_Repository__c repoPD = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                        FROM IB_Role_Repository__c WHERE Role_Name__c='PD Provider' Limit 1];
        
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoPD.Id, conRecords[0].id, conRecords[0].AccountId); 
        insert role;
        
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'PYP');
        insert progRec;
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Approval Process', 'Campaign').Id;
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc.Id);
        insert opp1;
        campaign cm = TestsUtil.createCampaign('sample',acc.id,opp1.id,recordTypeId);
        insert cm;
        IB_Event_Role__c myEventRole = TestsUtil.createIbEventRole(5, cm.Id);
        Staffing_Event__c staffEvent1 = TestsUtil.createStaffingEvent('test_name_st_event_001', cm.Id, acc.Id);
        
        Date dd = Date.newInstance(1999, 12, 9);
        Contact ObjContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=acc.Id,Homephone='+9212345678',Phone='+9212345678',Email='abc@gmail.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        insert ObjContact; 
        
        List<My_Staffing_Event__c> myStaffingEvents = TestsUtil.getMyStaffingEvents();
        My_Staffing_Event__c mse = TestsUtil.createMyStaffingEvent('dataTest',acc.Id,cm.Id,myEventRole.Id,role.Id);
        mse.IB_Contact__c = ObjContact.Id;
        mse.Event_Organizer_Account__c =acc.Id;
        mse.Application_Status__c='Pending Selection';
        myStaffingEvents.add(mse);
        insert myStaffingEvents;
    }
    @isTest  
    private static void testUpdate1(){
        
        User pdProvider = [SELECT Id FROM User where username = 'konpondycherry@gmail.com' limit 1];
        
        system.runas(pdProvider){
            Account acc = [select Id, External_PD_Provider__c from Account WHERE IBIS_ID__c = 'N123456' limit 1 ];
            
            system.assertEquals(true, acc.External_PD_Provider__c);
            
            List<My_Staffing_Event__c> myStaffingEvent = [select id, Event_Organizer_Account__r.RecordType.Name,Event_Organizer_Account__r.External_PD_Provider__c, Application_Status__c,Staffing_Event_Type__c,Staffing_Event__c,IB_Contact__c,Event_Organizer_Account__c,Staffing_Event_Venue__c from My_Staffing_Event__c WHERE LastModifiedDate >= YESTERDAY                                                      
                                                         ];
            Test.startTest();
            new MyStaffingEventTriggerHandler().GrantAccessToAccountContacts(myStaffingEvent);
            List<Contact> contacts = [SELECT Id, Name, FirstName FROM Contact WHERE FirstName = 'testing'];
            System.assertEquals(1, contacts.size(), 'Expected one contact with FirstName = "testing"');
            Test.stopTest();
            
        }
        
    }
    
}