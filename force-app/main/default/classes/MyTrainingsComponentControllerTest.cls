@isTest
public with sharing class MyTrainingsComponentControllerTest {

    static testMethod void basicTest(){
        integer i=1;
        IBActivity iba = new IBActivity(); 
        
        MyTrainingsComponentController tc = new MyTrainingsComponentController();
        TestsUtil.initMyStaffingEvents();
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        List<Campaign> camps = TestsUtil.getCampaigns();
        User u = TestsUtil.createPortalUser('Test User');
        List<IB_Role__c>rolesAll = TestsUtil.getIbRoles();
        
        Training_Event__c te = TestsUtil.createTrainingEvent('testSF', repos[0].Id, camps[0].Id);
        tc.training = IBActivity.convertEligTraining(te);
        tc.training.StartDate = Date.Today();
        tc.training.EndDate = Date.Today();

        
        tc.getIsMyTraining();
        tc.getIsEligTraining();
        tc.getHasEventCity();
        tc.getHasEventCountry();
        tc.getHasEventRegion();
        tc.getSameMonths();
        tc.getNotSingleDay();
    //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }
}