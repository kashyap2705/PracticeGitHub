@isTest
public class BqcMypMySchoolControllerTest {
@isTest
    public static void Custom_Attachment()
    {
       initCustomSettings();
        initCampaigns();
        
        List<Campaign> bqc_PARENTcamp_list = [Select id,BQC_Status__c,Venue_Account__r.id,Related_IB_Programme__r.id From Campaign where parentid=null and sub_Type__c='BQC Event'];
        Campaign camp_record= bqc_PARENTcamp_list[0];
        List<Campaign> bqc_camp_list = [Select id,BQC_Status__c,ParentId,Staffing_Event_Published__c,Status From Campaign where parentid=:camp_record.id and sub_Type__c='BQC Event'];
        Campaign camp_record1= bqc_camp_list[0];
        Campaign camp_record2= bqc_camp_list[1];
        
         Date dd = Date.newInstance(1999, 12, 9);
        
        Contact theContact = new Contact(FirstName='testing', LastName='Firsttest', AccountId=camp_record.Venue_Account__r.Id,Homephone='+92131112356',Phone='+92131112356',Email='a@a.com',Contact_Type__c= 'IBEN',RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId(), birthdate = dd);
        theContact.Global_IBEN_Number__c = 1234;
        theContact.OtherStreet = 'Test';
        theContact.OtherCity = 'Test';
        theContact.OtherPostalCode = 'Test2';
        theContact.OtherCountryCode = 'PK';
        insert theContact;
        
        User user = new User(Alias = 'sspp', Email='testutils@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='testUu', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = [Select Id from  Profile where Name = 'SCU + Advanced'].id,
        TimeZoneSidKey='America/Los_Angeles', UserName='testUtils@ibotestorg.com',ContactId=theContact.Id);
        insert user;
            
        System.RunAs(user){  
        
        Test.startTest();
               
 
        PageReference pageRef = Page.IBPortalTriagePage;
            BqcMypMySchoolController controller = new BqcMypMySchoolController();
            controller.mypEvent = camp_record;
            controller.mypchildeventslist = bqc_camp_list;
            controller.fileBody = Blob.valueof('StringToBlobTest');
            controller.fileName = 'fileName.doc';
            controller.Subject_Name='Arts';
            controller.description='Test';
            controller.UnitPlan='Unit 1';
            controller.docType ='Test';
            controller.upload();
            controller.fileBody = Blob.valueof('StringToBlobTest');
            controller.fileName = 'fileName.doc';
            controller.Subject_Name='Arts';
            controller.description='Test';
            controller.UnitPlan='Test';
            controller.docType ='Test';
            controller.upload();
            controller.fileBody = Blob.valueof('StringToBlobTest');
            controller.fileName = 'fileName';
            controller.upload();         
            controller.fileBody = Blob.valueof('StringToBlobTest');
            controller.upload();
            controller.removeAppDocument();
            controller.getcheckStatus();
            controller.submit();
        Test.stopTest();
        }
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
    
    private static void initCampaigns() {
        
        Account acc1 = TestsUtil.createAccount('test_acc_name_1');
        Account acc2 = TestsUtil.createAccount('test_acc_name_2');
        acc1.Region__c = 'IBAEM';
        acc1.External_PD_Provider__c = true;
        acc2.Region__c = 'IBAEM';
        acc2.External_PD_Provider__c = true;
        acc2.IBIS_ID__c = '682382';
        insert new List<Account> {acc1,acc2};
        
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc1, 'MYP');
		insert prog;

        Opportunity opp1 = TestsUtil.createOpportunity('Test PYP 1', acc1.Id);
        Opportunity opp2 = TestsUtil.createOpportunity('Test PYP 2', acc2.Id); 
        insert new List<Opportunity> {opp1,opp2};
            
         Id recordTypeId2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Authorization', 'Campaign').Id;
        
        Campaign camp3 = TestsUtil.createCampaign('camp test name 3', acc1.Id, opp1.Id, recordTypeId2);
        camp3.Name = 'BQC test_acc_name_1';
        camp3.Sub_Type__c = 'BQC Event';
        camp3.Related_IB_Programme__c = prog.id;
        camp3.Venue_Account__c = acc1.id ;
        insert new List<Campaign>{camp3};
        
    }

}