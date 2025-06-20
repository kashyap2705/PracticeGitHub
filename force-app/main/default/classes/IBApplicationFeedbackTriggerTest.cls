@isTest
public class IBApplicationFeedbackTriggerTest {
    
    @testSetup 
    static void setupData(){
        integer i=1;
        
        Account theAccount = PimsTestUtil.createAccount('Test School Account', 'School Account');
        insert theAccount;
        
        Contact theContact = PimsTestUtil.createContact('John Doe', 'JD@jd.com', 'jd@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        //    insert theContact;
        
        Contact theContact2 = PimsTestUtil.createContact('Jane Doe', 'JD2@jd.com', 'jd2@profEmail.com', Date.newInstance(1985, 10, 14), theAccount);
        //  insert theContact2;
        insert new List<contact>{theContact,theContact2};
            
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
        insert theProgramme;
       
        IB_Role_Repository__c roleRepo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert roleRepo;
        
        IB_Role_Repository__c roleRepo2 = PimsTestUtil.createRoleRepo('Teacher');
        insert roleRepo2;

        IB_Role_Repository__c roleRepo3 = PimsTestUtil.createRoleRepo('Reader');
        insert roleRepo3;
        
        IB_Role__c theRole = PimsTestUtil.createIbRole(roleRepo.Id, theContact.Id, theAccount.Id);
        theRole.IB_Programme_New__c = theProgramme.Id;
        //insert theRole;
        
        IB_Role__c theRole2 = PimsTestUtil.createIbRole(roleRepo2.Id, theContact.Id, theAccount.Id);
        theRole2.IB_Programme_New__c = theProgramme.Id;
        //insert theRole2;
        
        IB_Role__c theRole3 = PimsTestUtil.createIbRole(roleRepo3.Id, theContact.Id, theAccount.Id);
        theRole3.IB_Programme_New__c = theProgramme.Id;
        //insert theRole3;
        
        IB_Application__c theApp = new IB_Application__c(
            AC_3_1_Feasability_Lead__c = theContact.Id,
            Application_Lookup_to_Programme__c = theProgramme.Id,
            AFC_Assessment_Status__c = 'Complete',
            AFC_Collaborative_Planning_Status__c = 'Complete' ,
            AFC_Documents_Status__c = 'Complete' ,
            AFC_Implementation_Budget_Status__c = 'Complete' ,
            AFC_Leadership_Structure_Status__c = 'Complete' ,
            AFC_Philosophy_Status__c = 'Complete' ,
            AFC_Profile_Review_Status__c = 'Complete' ,
            AFC_Programme_Information_Status__c = 'Complete' ,
            AFC_Resources_Support_Status__c = 'Complete' ,
            AFC_School_Description_Status__c = 'Complete' ,
            AFC_Subject_Proposal_Status__c = 'Complete' ,
            AFC_Written_Curriculum_Status__c = 'Complete',
            Status__c = 'Submitted'
        );
        insert theApp;
        
        Id campaignRecordTypeId = Schema.getGlobalDescribe().get('Campaign').getDescribe().getRecordTypeInfosByName().get('Authorization').getRecordTypeId();      
        Campaign rfcEvent = TestsUtil.createRFCCampaign('RFC Event',theAccount.Id,theProgramme.Id,campaignRecordTypeId, 'Staffed');
        insert rfcEvent;
        
        IB_Application_Feedback__c appFeedback = new IB_Application_Feedback__c();
        appFeedback.IB_Programme_Lookup__c = theProgramme.Id;
        appFeedback.FB_Lookup_IB_Application__c = theApp.Id;
        appFeedback.name = theProgramme.Name + ' Candidacy Feedback';
        appFeedback.Status__c = 'Not Started';
        insert appFeedback;
    }
    
    @isTest
    static void test_feedbackSubmitted() {
        
        IB_Programme__c theProgramme = [Select Id from IB_Programme__c where Account__r.Name='Test School Account'];
        IB_Application__c theApp = [Select Id from IB_Application__c where Application_Lookup_to_Programme__c = :theProgramme.Id and Status__c='Submitted'];
        IB_Application_Feedback__c appFeedbackRecord = [Select Id from IB_Application_Feedback__c where FB_Lookup_IB_Application__c = :theApp.Id];
        appFeedbackRecord.Status__c = 'Submitted';
        List<Campaign> rfcEvents = new List<Campaign>();		
        List<Campaign> updateRFCEvents = new List<Campaign>();
        rfcEvents = [Select Id, Status, Sub_Type__c, Related_IB_Programme__r.Owner__c from Campaign where Related_IB_Programme__c =:theProgramme.Id
                      AND Status = 'Staffed' AND Sub_Type__c = 'Request for Candidacy'];

        try{
            update appFeedbackRecord;
            System.debug('rfcEvents.size():' +rfcEvents.size());
        }catch(Exception e)
        {
            System.debug(e);
        }
        
    }
    
}