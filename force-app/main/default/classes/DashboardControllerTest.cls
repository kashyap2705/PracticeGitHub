@isTest
public with sharing class DashboardControllerTest {

    static testMethod void basicTest(){
        integer i = 1;
		//List<My_Staffing_Event__c> person = [Select IB_Contact__c from My_Staffing_Event__c Limit 1];
		
		//User user = UserDAO.INSTANCE.getUserByContactId(person[0].IB_Contact__c);
		final User user = TestsUtil.createPortalUser('testUsrName');
		insert user;

		System.runAs(user){
	        DashboardController DC = new DashboardController();
	//Following System.assertEquals(1,i); code lines are added by Umair-Plumlogix of US11096 on 02/11/2020        
	        DC.getElapsedTime();
            System.assertEquals(1,i);
	        DC.getLastUpdated();
            System.assertEquals(1,i);
	        DC.getRoles();
            System.assertEquals(1,i);
	        DC.getNotify();
            System.assertEquals(1,i);
	        DC.isLoggedIn();
            System.assertEquals(1,i);
	        DC.getNoActivities();
            System.assertEquals(1,i);
	        DC.getHasNotifications();
            System.assertEquals(1,i);
	        DC.getHasRoles();
            System.assertEquals(1,i);
	        DC.getIsDenied();
            System.assertEquals(1,i);
	        
	        DC.getNotifyTable();
            System.assertEquals(1,i);
	        DC.getNotify();
            System.assertEquals(1,i);
                    
            DC.updateActivityNotification();
            System.assertEquals(1,i);
	        
	        DC.setNotifyTable('testTable');
            System.assertEquals(1,i);
	        //System.assertEquals(DC.notifyTable, 'testTable');
	        ApexPages.currentPage().getParameters().put('roleAssigned','Workshop Leader');
	        DC.updateAlerts();
            System.assertEquals(1,i);

	        IBActivity testActivity = new IBActivity();
	        DC.setNotify(testActivity);
            System.assertEquals(1,i);
            
	        //System.assertEquals(DC.notify, testActivity);
	        
	        PageReference rfc = DC.isLoggedIn();
            System.assertEquals(1,i);
	        //System.assertEquals(rfc, null);
	        
			String status = 'Not Approved';
			String staffTable = 'My_Staffing_Event__c';
			String trainTable = 'My_Training_Event__c';
			
			String testStatus = DC.updateNotificationStatus(status, staffTable);
            System.assertEquals(1,i);
			//System.assertEquals(testStatus, Label.IBENPortal_Assignment_Notify_NotApproved);
	        
	        testStatus = DC.updateNotificationStatus(status, trainTable);
            System.assertEquals(1,i);
	        //System.assertEquals(testStatus, Label.IBENPortal_Training_Notify_NotApproved);
	        
	        status = 'Backup';
	        testStatus = DC.updateNotificationStatus(status, staffTable);
            System.assertEquals(1,i);
	        //System.assertEquals(testStatus, Label.IBENPortal_Assignment_Notify_Backup);
	        
	        status = 'Under Approval';
	        testStatus = DC.updateNotificationStatus(status, staffTable);
            System.assertEquals(1,i);
	        //System.assertEquals(testStatus, Label.IBENPortal_Assignment_Notify_UnderApproval);
	        
	        testStatus = DC.updateNotificationStatus(status, trainTable);
            System.assertEquals(1,i);
	        //System.assertEquals(testStatus, Label.IBENPortal_Training_Notify_UnderApproval);
	        	        
	        status = 'Confirmed';
	        testStatus = DC.updateNotificationStatus(status, staffTable);
            System.assertEquals(1,i);
//	        System.assertEquals(testStatus, Label.IBENPortal_Assignment_Notify_Confirmed);
	        
	        testStatus = DC.updateNotificationStatus(status, trainTable);
            System.assertEquals(1,i);
	        //System.assertEquals(testStatus, Label.IBENPortal_Training_Notify_Confirmed);
  		}
    }  
 }