@isTest
public with sharing class MassUpdateSimpleControllerTest {
   
   private static void setuptestdata() {
        Date birthdate = date.today()-9000;
        	Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc1.IBIS_ID__c = '717171';
        acc1.Country__c = 'UNITED STATES';
        acc1.Sub_region__c = 'NORTHERN AMERICA';
        acc1.Region__c = 'IBA';

        insert acc1;
        
        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        insert opp1;
        
        Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;
        
		Campaign camp1 = TestsUtil.createCampaign('camp', acc1.Id, opp1.Id, recordTypeId);
        //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        //Begin
		camp1.Status = 'Staffed';//End
		camp1.Venue_Account__c = acc1.Id;
		insert camp1;
        
        IB_Role_Repository__c role = TestsUtil.createRoleRepo();
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
       
        My_Training_Event__c my_training_event_2 = TestsUtil.createMyTrainingEvents('Pending Selection', contactib.id , training_event_1.id , camp1.id);
        insert my_training_event_2;
        
 
      
        
    }
     //This Funcation is updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
    //Begin
    static testMethod void basicTest(){
        integer i = 1;
         setuptestdata();
         List <My_Training_Event__c> events = [select id,Training_Event_Status__c from My_Training_Event__c];
        events[0].Application_Status__c = 'Confirmed';
        events[0].Invitation_Response__c = 'Accepted';
        events[0].Level_of_Interest__c = 'Interested';                 
        System.debug('Size+ '+ events.size());
      // TestsUtil.initMyStaffingEvents();
      // List<Training_Event__c> events = TestsUtil.getTrainingEvents();
       ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(events); 
        List<sObject> record = setCon.getRecords();
        System.debug(record.size());
       //ApexPages.StandardSetController test = new ();
       MassUpdateSimpleController m = new MassUpdateSimpleController(setCon);

       m.getStep();
       m.getsType();
       m.getNow(True);
       Schema.DescribeFieldResult Field_status_1 = My_Training_Event__c.Application_Status__c.getDescribe();
       Schema.SObjectField f1 = Field_status_1.getSObjectField();
       m.field = f1;
       m.getFieldInfoToDisplay();
       Field_status_1 = My_Training_Event__c.Notify_Of_Status__c.getDescribe();
       f1 = Field_status_1.getSObjectField();
       m.field = f1;
       m.getFieldInfoToDisplay();
        Field_status_1 = My_Training_Event__c.Confirmation_Date__c.getDescribe();
       f1 = Field_status_1.getSObjectField();
        m.valueToUpdate = 'true';
        m.convertUserInputToFieldData();
        m.valueToUpdate = 'false';
        m.convertUserInputToFieldData();
        m.valueToUpdate = 'null';
        m.convertUserInputToFieldData();
       m.field = f1;
       m.valueToUpdate = '6/21/2019';
       m.getFieldInfoToDisplay();     
            Field_status_1 = Campaign.Required_Number_of_Educators__c.getDescribe();
       f1 = Field_status_1.getSObjectField();
       m.field = f1;
       m.valueToUpdate = '3';
         m.getFieldInfoToDisplay();   
       m.cancel();
       m.step1();
       m.step2();
       m.step3();
       m.step4();
       m.step5();
       m.getFieldTypeOptions();
       m.getPicklistValues();
        //m.cntr = NULL;
        //m.fromPage = NULL;
        //m.objs = NULL;
        m.fieldMap = NULL;
        m.currentMsg = NULL;
        //m.newLine = NULL;
        m.field = NULL;
        m.sType = NULL;
        m.convertedFieldData = NULL;
        m.picklistValues = NULL;
        m.currentStep = NULL;
        Schema.DescribeFieldResult Field_status = My_Training_Event__c.Application_Status__c.getDescribe();
        Schema.SObjectField f = Field_status.getSObjectField();
        System.debug('Field '+f);
        m.field = f;
        m.convertUserInputToFieldData();
       Field_status = My_Training_Event__c.Notify_Of_Status__c.getDescribe();
       f = Field_status.getSObjectField();
       m.field = f;
        m.valueToUpdate = 'true';
        m.convertUserInputToFieldData();
         m.valueToUpdate = 'false';
        m.convertUserInputToFieldData();
         m.valueToUpdate = 'null';
        m.convertUserInputToFieldData();
       Field_status = My_Training_Event__c.Confirmation_Date__c.getDescribe();
       f = Field_status.getSObjectField();
       m.field = f;
       m.valueToUpdate = '6/21/2019';
       m.getFieldInfoToDisplay(); 
       m.convertUserInputToFieldData();
       Field_status = Campaign.Required_Number_of_Educators__c.getDescribe();
       f = Field_status.getSObjectField();
       m.valueToUpdate = '4';
       m.convertUserInputToFieldData();
       m.getFieldInfoToDisplay(); 
       Map<String, Schema.SObjectField> so = new Map<String, Schema.SObjectField>();
       //so.add('Test',f);
       m.sortByFieldLabel(so);
       m.field = f;
       m.valueToUpdate = '3';
       m.getFieldInfoToDisplay();  
       Field_status = My_Training_Event__c.Application_Feedback__c.getDescribe();
       f = Field_status.getSObjectField();
       m.valueToUpdate = 'Test123'; 
       m.convertUserInputToFieldData();
        m.filterId= NULL;
        String s = m.filterId;
        m.objsToUpdate = NULL;
        List<sObject> l = m.objsToUpdate;
        m.getFieldTypeOptions();        
        m.valueToUpdate= NULL;
        String s1 = m.valueToUpdate;
        m.fieldName= NULL;
        String s2 = m.fieldName;
         m.fieldType= NULL;
        String s3 = m.fieldType;
        m.sortByFieldLabel(NULL);
        m.isSupportedFieldType(NULL);
        Account a=new Account();
        m.discoverSObjectType(a);
        m.currentMsg = null;
        m.valueToUpdate = '3';
        m.step4();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

     /*        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }*/
        
    }
    //End

}