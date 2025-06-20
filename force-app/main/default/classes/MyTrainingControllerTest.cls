@isTest
public with sharing class MyTrainingControllerTest {
	
	static testMethod void basicTest(){
	    User u = TestsUtil.createPortalUser('test');
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
		//Start
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        insert acc;
        Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        insert con1;

        List<String> abc = new List<String>();
       
        abc.add('School Visit Team Leader');
        abc.add('School Visit Team Member');
        List<IB_Role__c> RolesOfCon = new List<IB_Role__c>();
        RolesOfCon = [Select IB_Role_Name__c, Status__c, Programme_Selection__c from IB_Role__c where IB_Contact__r.id =: con1.id];
        String bb= ''+u.id;
        String cc= ''+con1.id;
        Test.startTest();
		TrainingEventDAO temp = new TrainingEventDAO();
      	//End
        
		MyTrainingController.user = u;
		
		MyTrainingController tc = new MyTrainingController();
		
		/*System.assert(MyTrainingController.myTrainings == null);
		System.assert(MyTrainingController.myEligTrainings == null);
		System.assert(MyTrainingController.myTrainingsHistory == null);*/
      
      	boolean a = tc.getNoTrainings();
      	System.assert(a);
      	
      	boolean b = tc.getNoEligTrainings();
      	System.assert(b);
      	
      	boolean c = tc.getNoTrainingsHistory();
      	System.assert(c);
        
      	List<IBActivity> activities;
        String query;
      	List<IBActivity> myTrainings = MyTrainingController.loadMyTrainings(activities, query, true);
        //Following code is added by Umair-Plumlogix of US11949 of Staff Augmentation Project on 06/18/2020
		//Start
      	temp.getEligibleTrainings(abc, bb, cc);
        temp.getAppliedForTrainings(cc);
        //End
        tc.getStatusPdf();
        tc.getEligibilityPdf();
        tc.getTrainingTypesPdf();
        tc.getUserRegion();
      	
        Test.stopTest();
	} 
}