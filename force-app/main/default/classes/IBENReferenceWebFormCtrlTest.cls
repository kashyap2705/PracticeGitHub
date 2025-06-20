@isTest
public class IBENReferenceWebFormCtrlTest {
	public static testMethod void testConstructor() {
        Account account = PimsTestUtil.createAccount('IBAEM Inactive Contacts', '');
        insert account;

      	Contact con = PimsTestUtil.createContact('A Contact', 'q@a.com', 'z@a.com', Date.newInstance(1990, 11, 11), account);
      	insert con;
        
        IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
      	repo.Prevent_Duplicates__c = true;
      	insert repo;
        
        IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.Id);
        role.Title__c = 'Mr.';
        role.Referee_1_First_Name__c = 'test';
        role.Referee_1_Last_Name__c = 'ref 1';
        role.Referee_1_Email__c = 'testref1@iben.com';
        role.First_Referee_Professional_Relationship__c = 'test'; 
        role.Referee_2_Title__c = 'Mr.';
        role.Referee_2_First_Name__c = 'test';
        role.Referee_2_Last_Name__c = 'ref 2';
        role.Referee_2_Email__c = 'testref2@iben.com';
        role.Second_Referee_Professional_Relationship__c = 'test';
        insert role;
        
        IB_Referee_Feedback__c feedback = new IB_Referee_Feedback__c();
        feedback.IB_Contact__c = role.IB_Contact__c;
        feedback.My_Role__c = role.Id;
        insert feedback;
        
        test.startTest();
            ApexPages.StandardController std = new ApexPages.StandardController(feedback);
            IBENReferenceWebFormCtrl ctrl = new IBENReferenceWebFormCtrl(std);
        	system.assertEquals(ctrl.feedback.Id,feedback.Id);
        	ctrl.submit();
        	IB_Referee_Feedback__c result = [select Status__c from IB_Referee_Feedback__c where id =: feedback.Id];
        	system.assertEquals(result.Status__c,'Complete');
        test.stopTest();
    }
}