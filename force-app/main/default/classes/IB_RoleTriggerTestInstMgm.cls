@isTest
public class IB_RoleTriggerTestInstMgm {
    public static User u;
     public static  Contact_information__c ci {get; set;}
    public static  Contact_information__c ci2 {get; set;}
    @isTest public static void testOne()
    {
        //User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');
        
        
         u = new User(Id = UserInfo.getUserId());
      
        
         PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Institute_Management_User'];
       
        // Assign the above inserted user for the above Permission Set.
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        Database.insert(psa,false);
        test.startTest();
        System.runAs(u)
        {
        
        Account acc = PimsTestUtil.createAccount('Test Account', 'IB Institute' );
       // acc.IB_Transcript_Method__c='Electronic';
        acc.IB_Transcript_Method__c='Paper';
        //user u=[select id,name from user userInfo.getUserId()].contact.AccountId];
        insert acc;
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        u.ContactId=con.id;
        system.debug('con_id12' + u.ContactId);
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Name__c = 'Institute Transcript User';
        insert repo2;
            
            
        ci=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId() ,name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(repo2.id),IB_Contact__c= con.id);
        insert ci;
        ci2=new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId() ,name='Ck1',phone__c='+923070989740',job__c='Job',roleId__c=String.valueof(repo2.id),IB_Contact__c=con.id);
        insert ci2; 
        
     
            
            
           IB_Role__c ibRole1 = TestsUtil.createIbRole(repo2.Id, con.id);
         ibRole1.Status__c = 'Applicant';
         ibRole1.IB_Account__c = acc.id;
         ibRole1.Role_Level__c = 'Fully Qualified';
         ibRole1.Contact_Information_Phone__c=ci2.id;
        ibRole1.Contact_Information_Email__c=ci.id;
        ibRole1.Job_Title__c=ci2.job__c; 
         insert ibRole1;
         
         
        }        
    }
}