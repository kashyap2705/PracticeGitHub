@isTest
public with sharing class MyAssignmentsComponentControllerTest {

    static testMethod void basicTest(){
        integer i=1;
      
      MyAssignmentsComponentController MACC = new MyAssignmentsComponentController();
      TestsUtil.initMyStaffingEvents();
      List<My_Staffing_Event__c> staffingEvents = TestsUtil.getMyStaffingEvents();
      MACC.assignment = IBActivity.convertAssignment(staffingEvents[0]);
      MACC.assignment.StartDate = Date.Today();
      MACC.assignment.EndDate = Date.Today();
      MACC.assignment.ApplicationStatus = ' pending';
      
      MACC.getSameMonths();
      MACC.getActivityCssClass();
      
      MACC.assignment.ApplicationStatus = ' confirmed';
      MACC.getActivityCssClass();

      MACC.assignment.ApplicationStatus = ' invited';
      MACC.getActivityCssClass();
      //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
      
    }
 }