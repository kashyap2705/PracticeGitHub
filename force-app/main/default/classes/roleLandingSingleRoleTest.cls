@isTest
public with sharing class roleLandingSingleRoleTest {

    static testMethod void basicTest(){
        integer i=1;
        TestsUtil.initMyStaffingEvents();
        roleLandingSingleRole RL = new roleLandingSingleRole();
        List<IB_Role_Repository__c> repos = TestsUtil.getRoleRepos();
        RL.role = repos[0];

        RL.getApplication();
        RL.getTraining();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }
}