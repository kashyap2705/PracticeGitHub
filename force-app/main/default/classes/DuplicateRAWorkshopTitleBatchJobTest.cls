@isTest
public class DuplicateRAWorkshopTitleBatchJobTest {

    @TestSetup
    static Void setupdata(){
          
           Account acc = PimsTestUtil.createAccount('Test Account', '');
           Insert acc;	
           Contact con = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
           Insert con;
           IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
           prog.Status__c = 'Interested';
           Insert prog;
           IB_Role_Repository__c rr = PimsTestUtil.createRoleRepo('Programme Coordinator');
           Insert rr; 
           IB_Role__c rp = PimsTestUtil.createIbRole(rr.Id, con.Id, acc.Id);
           Insert rp;
           IB_Workshop_Titles__c wt = new IB_Workshop_Titles__c();
           Insert wt;
        
        
          List<IB_Role__c> roleAppList = new List<IB_Role__c>();
          roleAppList = [SELECT Id, Name,(SELECT Id,Name, 
                                                 Role_And_Application__c,IB_Workshop_Title__c,
                                                 Duplicate__c 
                                            FROM Role_Application_Workshop_Titles__r) 
                           FROM IB_Role__c];
            
           //-Prepare bulk workshop Titles per Role & Application 
           List<Role_Application_Workshop_Title__c> rpwtList = new List<Role_Application_Workshop_Title__c>();
            for (Integer i=0;i<200;i++) {
           		 Role_Application_Workshop_Title__c rpwt = PimsTestUtil.createRoleApplicationWorkshopTitle(rp.Id,wt.Id);
                 rpwtList.add(rpwt);
            }
            Insert rpwtList;	        
    }
    
    @isTest 
    static void testIdentifyDuplicates(){
        test.startTest();
	      List<Role_Application_Workshop_Title__c> rawtList = new List<Role_Application_Workshop_Title__c>();
          rawtList = [SELECT Id,Name,Role_And_Application__c,
                             IB_Workshop_Title__c,Duplicate__c 
                        FROM Role_Application_Workshop_Title__c];
              IdentifyDuplicateRAWorkshopTitleBatchJob dup = new IdentifyDuplicateRAWorkshopTitleBatchJob();
          Database.executeBatch(dup);
        test.stopTest();
        
    }
    
    @isTest 
    static void testDeleteDuplicates(){
         test.startTest();
	      List<Role_Application_Workshop_Title__c> rawtList = new List<Role_Application_Workshop_Title__c>();
          rawtList = [SELECT Id,Name,Role_And_Application__c,
                             IB_Workshop_Title__c,Duplicate__c 
                        FROM Role_Application_Workshop_Title__c];
            for(Role_Application_Workshop_Title__c rwat: rawtList){
                rwat.duplicate__c = true;
            }
          update rawtList;
          rawtList = [SELECT Id,Name,Role_And_Application__c,
                             IB_Workshop_Title__c,Duplicate__c 
                        FROM Role_Application_Workshop_Title__c];
          DeleteDuplicateRAWorkshopTitleBatchJob dup = new DeleteDuplicateRAWorkshopTitleBatchJob();
          Database.executeBatch(dup);
        test.stopTest(); 
    }    

}