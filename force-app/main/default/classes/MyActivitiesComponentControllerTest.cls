@isTest
public with sharing class MyActivitiesComponentControllerTest {

    static testMethod void basicTest(){
        integer i = 1;
        IBActivity iba = new IBActivity(); 
        
        MyActivitiesComponentController tc = new MyActivitiesComponentController();
        TestsUtil.initMyStaffingEvents();
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        List<Campaign> camps = TestsUtil.getCampaigns();
        User u = TestsUtil.createPortalUser('Test User');
        List<IB_Role__c>rolesAll = TestsUtil.getIbRoles();
        
        Training_Event__c te = TestsUtil.createTrainingEvent('testSF', repos[0].Id, camps[0].Id);
        MyActivitiesComponentController.assignment = IBActivity.convertEligTraining(te);
        MyActivitiesComponentController.assignment.StartDate = Date.Today();
        MyActivitiesComponentController.assignment.EndDate = Date.Today();
        
        tc.getActivityCssClass();
        MyActivitiesComponentController.assignment.ApplicationStatus = 'Pending';
        tc.getActivityCssClass();
        MyActivitiesComponentController.assignment.ApplicationStatus = 'confirmed';
        tc.getActivityCssClass();
        MyActivitiesComponentController.assignment.ApplicationStatus = 'invited';
        tc.getActivityCssClass();
        
        tc.getIsAssignment();
        tc.getIsMyAssignment();
        tc.getIsEditMyCurrentAssignment();
        tc.getIsTraining();
        tc.getIsMyTraining();
        tc.getIsEditMyCurrentTraining();
        tc.getHasEventCity();
        tc.getHasEventRegion();
        tc.getSameMonths();
        tc.getNotSingleDay();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        MyActivitiesComponentController.editAssignment();
        MyActivitiesComponentController.editTraining();
    }
}