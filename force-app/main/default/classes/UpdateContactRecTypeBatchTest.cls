@IsTest
public class UpdateContactRecTypeBatchTest {
	@IsTest
	static void testBatchMethod(){
        
        RecordType standardRecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Standard_Contact'];
		RecordType invitedRecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Invited_Contact'];
        
         ContactMaxIBCode__c setting = new ContactMaxIBCode__c();
        setting.MaxIBCode__c = 100000;
        setting.Name = 'MaxContactIBCode';
        insert setting;
        
        Account acc = PimsTestUtil.createAccount('Test Account 1', '');
        insert acc; 
        
        //Insert contacts
        Contact con1 = PimsTestUtil.createContact('Jones', 'testemail121@yopmail.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        con1.Legal_first_name__c ='Jones';
        con1.Legal_Last_name__c = 'Doe';
        con1.User_Language__c = 'en_US';
        con1.IBEN_Active__c=true;
        
        insert new List<contact>{con1};
            
        //Insert Role Repository
        IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Examiner');
        theRoleRepo1.Role_Type__c = 'IBEN Role';
        theRoleRepo1.Permission_Set_Name__c = 'Examiner';
        
        IB_Role_Repository__c theRoleRepo2 = PimsTestUtil.createRoleRepo('Programme Coordinator');
        theRoleRepo2.Role_Type__c = 'IBEN Role';
        theRoleRepo2.Permission_Set_Name__c = 'Programme Coordinator';
        
        IB_Role_Repository__c theRoleRepo3 = PimsTestUtil.createRoleRepo('Head of School');
        theRoleRepo3.Role_Type__c = 'IBEN Role';
        theRoleRepo3.Permission_Set_Name__c = 'Head of School';
        
        IB_Role_Repository__c theRoleRepo4 = PimsTestUtil.createRoleRepo('Billing Contact');
        theRoleRepo4.Role_Type__c = 'IBEN Role';
        theRoleRepo4.Permission_Set_Name__c = 'Billing Contact';
        
        IB_Role_Repository__c theRoleRepo5 = PimsTestUtil.createRoleRepo('Exam Contact');
        theRoleRepo5.Role_Type__c = 'IBEN Role';
        theRoleRepo5.Permission_Set_Name__c = 'Exam Contact';
        insert new List<IB_Role_Repository__c>{theRoleRepo1,theRoleRepo2,theRoleRepo3,theRoleRepo4,theRoleRepo5};
        
        
            
        //insert programme
        IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
        prog.Status__c = 'Interested';
        insert prog;

		Contact_Information__c ci = new Contact_Information__c(IB_Contact__c = con1.id, Email__c = 'test@test.com');
        insert ci;
        
        IB_Role__c examiner1 = PimsTestUtil.createIbRole(theRoleRepo1.Id, con1.Id, acc.Id);  
        examiner1.IB_Programme_New__c = prog.Id;
        examiner1.Start_Date__c = Date.today();
        examiner1.IB_Account__c = acc.Id;
        examiner1.Status__c = 'Confirmed';
        examiner1.Reason_For_Status__c = 'Confirmed';
        examiner1.Contact_Information_Email__c = ci.id;
        examiner1.Programme_Selection__c = 'DP';
        insert examiner1;

		con1.RecordTypeId = invitedRecType.id;
        update con1;
        
        Database.executeBatch(new UpdateContactRecTypeBatch(), 200);
    }
}