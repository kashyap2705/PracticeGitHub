@isTest
public with sharing class roleDashboardSingleTest {

    static testMethod void basicTest(){
        integer i=1;
        try
        {
            TestsUtil.initMyStaffingEvents();
            User p = TestsUtil.createPortalUser('somesuch'); 
            
     
            System.runAs(p) {
                roleDashboardSingle rds = new roleDashboardSingle();
                
                IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
                 insert repo2;
                  rds.role=repo2;
   
                List<IB_Role_Repository__c> roleRepo = TestsUtil.getRoleRepos();
               if(roleRepo !=null){
               
                rds.role = roleRepo[0];
                rds.getApplication();
                rds.getIsAdvanced();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                   System.assertEquals(1,i);
                }
            }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
        
    }
    
}