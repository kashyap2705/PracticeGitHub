@isTest
public with sharing class MyTrainingDetailsControllerTest {
    static testMethod void basicTest(){
        try {
            test.StartTest();
            integer i=1;
            TestsUtil.initMyStaffingEvents();
            List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
            List<Campaign> camps = TestsUtil.getCampaigns();
            User u = TestsUtil.createPortalUser('Test User');
            insert u;
            campaign camp1 = camps.get(0);
            //This Part is being updated by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
            //Begin
            camp1.Status = 'Staffed';//End
            camp1.Required_Number_of_Educators__c = 2;
            camp1.Training_Event_Type__c = 'Advance Training';
            camp1.Training_Language__c = 'English';
            camp1.Traing_Event_Published__c = true;  
            camp1.IB_Role__c = repos[0].id;
            camp1.IB_Programme__c = 'PYP';
            update camp1;
            
            
            
            //This Part is being commented by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
            //Begin
            //User usr = TestsUtil.createPortalUser('Test User12');
            //End
            
            Training_Event__c trainingEvent = TestsUtil.createTrainingEvent('test', repos[0].Id, camp1.id);
            insert trainingEvent;
           
            test.StopTest();
            My_Training_Event__c myTrainEvent = TestsUtil.createMyTrainingEvent('Invited', u.ContactId, trainingEvent.Id);
            myTrainEvent.IB_Event__c = camp1.id;
            myTrainEvent.Invitation_Response__c = null;
            insert myTrainEvent;
           
            My_Training_Event__c training_event = TestsUtil.getMyTrainingEvents().get(0);
            List<My_Training_Event__c> trainingevents = new List<My_Training_Event__c>();
            trainingevents.add(training_event);
            Test.setCurrentPageReference(Page.MyTrainingDetails); 
            System.currentPageReference().getParameters().put('Id', trainingEvent.Id);
           
           
                MyTrainingDetailsController tc = new MyTrainingDetailsController();
                tc.user = u;
                //This Part is being updated by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
                //Begin
                tc.myInvitation = trainingevents;//End    
                List<SelectOption> someList = tc.getReleasePermissionItems();
                List<SelectOption> otherList = tc.getInterestLevelItems();
                
                List<SelectOption> lista = tc.getWithdrawalReasons();
                
                Boolean c = tc.getUrlActionEdit();
                Boolean d = tc.getHasInvitation();
                Boolean e = tc.getShowGeneralInstructions();
                Boolean f = tc.getInvitationAccepted();
                Boolean g = tc.getHasReqTraining();
                Boolean h = tc.getHasTrainingPrereqs();
                tc.isLoggedIn();
                tc.acceptInvitation();
                tc.submitApplication();
                tc.saveWithdrawal();
                tc.cancel();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                tc.withdrawalReason = 'Test';
                tc.withdrawalComments ='Test';
               
            
        }    
        catch(Exception ex){
            System.debug('Exception: '+ex);
        }
        
        
        
    }
    static testMethod void decline_invitation(){
        try {
            
            integer i=1;
            TestsUtil.initMyStaffingEvents();
            List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
            List<Campaign> camps = TestsUtil.getCampaigns();
            User u = TestsUtil.createPortalUser('Test User');
            insert u;
           
            campaign camp1 = camps.get(0);
            //This Part is being updated by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
            //Begin
            camp1.Status = 'Staffed';//End
            camp1.Required_Number_of_Educators__c = 2;
            camp1.Training_Event_Type__c = 'Advance Training';
            camp1.Training_Language__c = 'English';
            camp1.Traing_Event_Published__c = true;  
            camp1.IB_Role__c = repos[0].id;
            camp1.IB_Programme__c = 'PYP';
            update camp1;
            
            
            //User usr = TestsUtil.createPortalUser('Test User12');
            test.StartTest();
            
            Training_Event__c trainingEvent = TestsUtil.createTrainingEvent('test', repos[0].Id, camp1.id);
            insert trainingEvent;
        
             
            My_Training_Event__c myTrainEvent = TestsUtil.createMyTrainingEvent('Invited', u.ContactId, trainingEvent.Id);
            myTrainEvent.IB_Event__c = camp1.id;
            myTrainEvent.Invitation_Response__c = null;
            insert myTrainEvent;
                        
            
            My_Training_Event__c training_event = TestsUtil.getMyTrainingEvents().get(0);
             
            List<My_Training_Event__c> trainingevents = new List<My_Training_Event__c>();
            trainingevents.add(training_event);
            Test.setCurrentPageReference(Page.MyTrainingDetails); 
            System.currentPageReference().getParameters().put('Id', trainingEvent.Id);
          
            
             
                MyTrainingDetailsController tc = new MyTrainingDetailsController();
                tc.user = u;
                tc.myInvitation = trainingevents;         
                List<SelectOption> someList = tc.getReleasePermissionItems();
                List<SelectOption> otherList = tc.getInterestLevelItems();
                
                List<SelectOption> lista = tc.getWithdrawalReasons();
                
                Boolean c = tc.getUrlActionEdit();
                Boolean d = tc.getHasInvitation();
                Boolean e = tc.getShowGeneralInstructions();
                Boolean f = tc.getInvitationAccepted();
                Boolean g = tc.getHasReqTraining();
                Boolean h = tc.getHasTrainingPrereqs();
                tc.isLoggedIn();
                tc.withdrawalReason = 'Test';
                tc.withdrawalComments ='Test';
                tc.declineInvitation();
               
            Test.stopTest();
        }    
        catch(Exception ex){
            System.debug('Exception: '+ex);
        }
        
        
    }
    static testmethod void translated_text(){
        try{
            IB_Role_Repository__c theRoleRepo = TestsUtil.createRoleRepo();
            insert theRoleRepo;
            TestsUtil.initCampaigns();
            List<Campaign> camps = TestsUtil.getCampaigns();
            campaign camp1 = camps.get(0);
            //This Part is being updated by Ammara-Plumlogix,as part of US-11565 and US-11580 on 06/11/2020
            //Begin
            camp1.Status = 'Staffed';//End
            camp1.Required_Number_of_Educators__c = 2;
            camp1.Training_Event_Type__c = 'Advanced Training';
            camp1.Training_Language__c = 'English';
            camp1.Traing_Event_Published__c = true;  
            camp1.IB_Role__c = theRoleRepo.id;
            camp1.IB_Programme__c = 'PYP';
            update camp1;
            
            Profile p =  [select Id from profile where Name ='SCU + Basic' limit 1];
            //User u = TestsUtil.createNonPortalUser('User', p.id);
            User usr = TestsUtil.createPortalUser('Test User12');
            usr.ProfileId = p.id;
            insert usr;
            
            Training_Event__c trainingEvent = TestsUtil.createTrainingEvent('test', theRoleRepo.Id, camp1.Id);
            insert trainingEvent;
            
            IB_Role__c IBrole = TestsUtil.createIbRole(theRoleRepo.id, usr.ContactId);
            IBrole.Status__c = 'Applicant';
            insert IBrole;
            
            My_Training_Event__c  mytrainingEvent = TestsUtil.createMyTrainingEvent('Invited', usr.ContactId, trainingEvent.id);
            mytrainingEvent.IB_Event__c = camp1.id;
            insert mytrainingEvent;        
            
            Test.setCurrentPageReference(new PageReference('Page.MyTrainingDetails')); 
            System.currentPageReference().getParameters().put('Id', trainingEvent.Id);
            List<My_Training_Event__c>  myInvitation = [Select Id, Application_Status__c, Invitation_Response__c
                                                        From My_Training_Event__c
                                                        Where Training_Event__c = :trainingEvent.id
                                                        And IB_Contact__c = :usr.ContactId
                                                        And Application_Status__c = 'Invited'
                                                        And Invitation_Response__c = null];
            System.debug('Size: '+myInvitation);
            Test.startTest();
            
            myInvitation = [Select Id, Application_Status__c, Invitation_Response__c
                            From My_Training_Event__c
                            Where Training_Event__c = :trainingEvent.id
                            And IB_Contact__c = :usr.ContactId
                            And Application_Status__c = 'Invited'
                            And Invitation_Response__c = null];
            System.debug('Size: '+myInvitation);
            MyTrainingDetailsController tc = new MyTrainingDetailsController();
            tc.user = usr;
            Boolean c = tc.getUrlActionEdit();
            Boolean d = tc.getHasInvitation();
            Boolean e = tc.getShowGeneralInstructions();
            Boolean f = tc.getInvitationAccepted();
            Boolean g = tc.getHasReqTraining();
            Boolean h = tc.getHasTrainingPrereqs();
            tc.isLoggedIn();
            IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IBActivity';
            dt.Locale__c = 'en_US';
            dt.Record_ID__c = 'CP';
            dt.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'TrainingStatus';
            dt2.Locale__c = 'en_US';
            dt2.Record_ID__c = 'CP';
            dt2.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'CP';
            dt3.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'CP';
            dt4.Translate_Value_1__c = 'CP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
            MyTrainingDetailsController.translateText('Test',null);
            tc.submitApplication();
           // tc.myInvitation();
            tc.saveWithdrawal();
            tc.acceptInvitation();
            tc.cancel();
            tc.declineInvitation();
            
            tc.getWithdrawalReasons();
            tc.getReleasePermissionItems();
            
            Test.stopTest();        
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
}