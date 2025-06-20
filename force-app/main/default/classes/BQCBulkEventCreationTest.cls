@isTest
public class BQCBulkEventCreationTest {
    private static Account acc2;
    private static IB_Role_Repository__c repo;
    @isTest
    public static void BQC_Event_publish(){
        
        List<Campaign> bqc_PARENTcamp_list = [Select id From Campaign where parentid=null and sub_Type__c='BQC Event'];
        List<Campaign> bqc_camp_list = [Select id,BQC_Status__c,ParentId,Staffing_Event_Published__c,Status From Campaign where parentid!=null and sub_Type__c='BQC Event'];
        Campaign camp_record= bqc_PARENTcamp_list[0];
        Test.startTest();
        
        BQCBulkEventCreation.BQC_child_publish(new list<id>{camp_record.id});
        System.debug('Test+++++++++++++++++  '+camp_record);
        Test.stopTest();
        
    }
    @isTest
    public static void BQC_Event_status_change_1(){
        
        List<Campaign> bqc_parent_camp_list = [Select id,BQC_Status__c From Campaign where parentid=null and sub_Type__c='BQC Event'];
        List<Campaign> bqc_camp_list = [Select id,BQC_Status__c,ParentId,Staffing_Event_Published__c,Status From Campaign where parentid!=null and sub_Type__c='BQC Event'];
        Campaign camp_record= bqc_parent_camp_list[0];
        Test.startTest();
        List<ID> Event_set = new List<ID>();
        camp_record.BQC_Status__c = 'Report Published to My School';
        update camp_record;
        Event_set.add(camp_record.id);
        camp_record.BQC_Status__c = 'Cancelled';
        update camp_record;
        Event_set.add(camp_record.id);
        BQCBulkEventCreation.BQC_Parent_Event_Status_Changed(Event_set);
        System.debug('Test+++++++++++++++++  '+camp_record);
        Test.stopTest();
        
    }
    @isTest
    public static void BQC_Event_status_change_2(){
        
        List<Campaign> bqc_parent_camp_list = [Select id,Related_IB_Programme__c,BQC_Status__c From Campaign where parentid=null and sub_Type__c='BQC Event'];
        List<Campaign> bqc_camp_list = [Select id,BQC_Status__c,ParentId,Staffing_Event_Published__c,Status From Campaign where parentid!=null and sub_Type__c='BQC Event'];
        Campaign camp_record= bqc_parent_camp_list[0];
        
        IB_Application_Attachment__c unit_plan = new IB_Application_Attachment__c(); 
        unit_plan.IB_Programme__c = camp_record.Related_IB_Programme__c;
        unit_plan.Type__c = 'Unit Plan';
        unit_Plan.Name = 'Arts_Unit_1_Unit_Plan.docx';
        insert unit_plan; 
        Test.startTest();
        List<ID> Event_set = new List<ID>();
        camp_record.Status = 'Staffed';
        camp_record.BQC_Status__c = 'Pending Feedback from School Reviewer';
        update camp_record;
        Event_set.add(camp_record.id);
        BQCBulkEventCreation.BQC_Parent_Event_Status_Changed(Event_set);
        //camp_record.BQC_Status__c = 'Event Complete';
        //update camp_record;
        Event_set.add(camp_record.id);
        BQCBulkEventCreation.BQC_Parent_Event_Status_Changed(Event_set);
        BQCBulkEventCreation.BQC_Event_Status_Change(Event_set);
        camp_record.Status = 'Cancelled';
        //update camp_record;
        Event_set = new List<ID>();
        Event_set.add(camp_record.id);
        BQCBulkEventCreation.BQC_Event_Status_Change(Event_set);
        System.debug('Test+++++++++++++++++  '+camp_record);
        Test.stopTest();
        
    }
    private static void initCustomSettings () {
        
        SchoolServicesTriggerProp__c schoolServicesConf = new SchoolServicesTriggerProp__c(name= 'SchoolServices');
        schoolServicesConf.schoolServiceForStuffEvent__c = '1';
        schoolServicesConf.schoolServicesCampList__c = '1,2,3';
        insert schoolServicesConf;
        
        ProfessionalDevelopmentTriggerProp__c profDevConf = new ProfessionalDevelopmentTriggerProp__c (name= 'ProfessionalDevelopment');
        profDevConf.profDevForStuffEvent__c = '1';
        profDevConf.professionalDevelopmentCampList__c = '1,2,3';
        insert profDevConf;
    }
    @testSetup static void initCampaigns() {
        initCustomSettings();
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        acc2 = TestsUtil.createAccount('test_acc_name_2');
        Account acc3 = TestsUtil.createAccount('test_acc_name_3');
        acc1.Region__c = 'IBAEM';
        acc1.External_PD_Provider__c = true;
        acc2.Region__c = 'IBAEM';
        acc2.External_PD_Provider__c = true;
        acc2.IBIS_ID__c = '682382';
        insert new List<Account> {acc1,acc2};
            //update new List<Account> {acc1,acc2};
            
            Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
            
            Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc2, 'MYP');
        insert prog;
        Campaign camp3 = TestsUtil.createCampaign('camp test name 3', acc1.Id, opp1.Id, recordTypeId2);
        camp3.Sub_Type__c = 'BQC Event';
        camp3.StartDate = date.Today();
        camp3.Status = 'Planned / Ready for Staffing';
        camp3.BQC_Status__c='Pending Document Submission';
        camp3.Related_IB_Programme__c = prog.id;
        insert new List<Campaign>{camp3};
        Campaign camp4 = TestsUtil.createCampaign('camp test name 4', acc1.Id, opp2.Id, recordTypeId2);
        camp4.Sub_Type__c = 'BQC Event';
        camp4.StartDate = date.Today();
        camp4.Status = 'Pending';
        camp4.BQC_Status__c='Pending Document Submission';
        camp4.Related_IB_Programme__c = prog.id;
        camp4.ParentId = camp3.id;
        insert new List<Campaign>{camp4};
            }
    
}