@isTest
public class ValidateIBEventTriggerTest {
        
    static testMethod void testOne(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;      
        setuptestdata(recordTypeId,true);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        cp.Sub_Type__c = 'Request for Candidacy';
        update cp;
        Test.stopTest();
    }
    static testMethod void testTwo(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Learning and Teaching Programme Development', 'Campaign').Id;
        
        setuptestdata(recordTypeId,false);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        update cp;
        Test.stopTest();
    }
    static testMethod void testThree(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;      
        setuptestdata(recordTypeId,true);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        cp.Sub_Type__c = 'BQC Event';
        cp.BQC_Status__c = 'Pending Document Submission';
        update cp;
        Test.stopTest();
    }
    static testMethod void testFour(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;      
        setuptestdata(recordTypeId,true);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        cp.Sub_Type__c = 'BQC Event';
         cp.BQC_Status__c = 'Pending Document Submission';
        update cp;
        Test.stopTest();
    }
    static testMethod void testFive(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;      
        setuptestdata(recordTypeId,true);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        cp.Sub_Type__c = 'BQC Event';
         cp.BQC_Status__c = 'Pending Document Submission';
        update cp;
        Test.stopTest();
    }
    static testMethod void testSix(){
        string recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('IBEN Training', 'Campaign').Id;      
        setuptestdata(recordTypeId,true);
        Test.startTest();
        Campaign cp = [Select id,sub_type__c,status,RecordTypeId from Campaign where status =: 'Pending'];
        cp.status = 'Planned / Ready for Staffing';
        cp.Sub_Type__c = 'BQC Event';
         cp.BQC_Status__c = 'Pending Document Submission';
        update cp;
        Test.stopTest();
    }
    private static void setuptestdata(string recordTypeId,boolean hasSubType) {
        
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
        Campaign camp1;
        if(hasSubType)
        {
                camp1 = TestsUtil.createCampaign('camp 1', acc1.Id, opp1.Id, recordTypeId);
                camp1.Status = 'Pending';
                camp1.Venue_Account__c = acc1.Id;
                insert camp1;
        }
        else
        {
           camp1 = new Campaign  (
                Name = 'Verification visit',
                Event_Organizer_Account__c = acc1.id,
                Related_Programme__c = opp1.id, 
                RecordTypeId = recordTypeId,  
                Type = 'Authorization',
                //    IB_Docs_ID__c = 'Test',
                Status  = 'Pending',
                Staffing_Event_Published__c = false,
                Event_Organizer_Region__c = 'IBAEM',
                Required_Number_of_Educators__c = 3,
                Venue_Account__c = acc1.id,
                Bundle__c = false
        	);
        	insert camp1;
        }
		String srecordTypeId = [select id,name from recordtype where sobjecttype = 'Staffing_Event__c' limit 1].Id;
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = srecordTypeId;
        
        schoolServicesConf.schoolServicesCampList__c = String.valueOf(camp1.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp1.RecordTypeId).substring(0,15);
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = srecordTypeId;
        
        profDevConf.professionalDevelopmentCampList__c = String.valueOf(camp1.RecordTypeId).substring(0,15) + ',' + String.valueOf(camp1.RecordTypeId).substring(0,15);
        insert profDevConf;
    }
}