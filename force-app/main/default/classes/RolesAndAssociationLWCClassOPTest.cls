/*******************************************************************************************
* @Name         RolesAndAssociationLWCClassOPTest 
* @Author       Ranjith Kondabathini
* @Date         07-08-2023  
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1. 			   Ranjith 		    07-08-2023		<<PRB0041125>> Apex Test Execution Failed (RolesAndAssociationLWCClassOPTest)
* 2.               Satyanarayana	04-24-2025      <<US-0002552>> Refactor the entire test class to include TestDataFactories.
*******************************************************************************************/
@isTest
public class RolesAndAssociationLWCClassOPTest {
    
    @testSetup 
    static void setup() {
	
        List<IB_Role__c> ibRoleList = new List<IB_Role__c>();
        List<IB_Role_Repository__c> roleRepos = new List<IB_Role_Repository__c>();
        
        Account acc = AccountTestDataFactory.createAccount('Online Provider', null);
		acc.Name = 'Test Account';
        insert acc;
        
        Contact con = ContactTestDataFactory.createContact(null, new Contact(AccountId = acc.Id, Email = 'a@a.com'));
        insert con;
        
        User testUser = UserTestDataFactory.createUser('Customer Community Advanced', 
            new User(
                ContactId = con.Id,
                Email = 'test@example.com',
                Username = 'testuser@test.com',
                LastName = 'smith',
                isActive = true
            ));
        insert testUser;
        
        IB_Country_Segmentation__c country = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(null);
        country.Name = 'Test Country';
        country.Regional_Office_Segmentation__c = 'IBA';
        country.IBEN_Segmentation__c = 'IBA';
        insert country;
        
        IB_Address__c ibAdd = new IB_Address__c();
        ibAdd.Name = 'Postal';
        ibAdd.IB_Account__c = acc.Id;
        ibAdd.Country__c = country.id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddressInstance(ibAdd);
        insert address;
        
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme(
            'MYP',
            new IB_Programme__c(
                Account__c = acc.Id,
                Street_Address__c = address.Id
            )
        );
        insert prog;
        
        IB_Role_Repository__c theRoleRepo1 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Online Coordinator',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo1);
        
        IB_Role_Repository__c theRoleRepo2 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Teacher',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo2);

		IB_Role_Repository__c theRoleRepo3 = IBRoleRepositoryTestDataFactory.createIBRoleRepository(
            new IB_Role_Repository__c(
                Role_Name__c = 'Online Admin Assistant',
                Role_Level__c = 'Fully Qualified',
				Role_Type__c = 'School Role'
            ));
        roleRepos.add(theRoleRepo3);
        
        insert roleRepos;
        
        Contact_information__c ci = new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId(),
                                                               name='Ck',email__c='test@abc.com',job__c='Job',roleId__c=String.valueof(theRoleRepo1.id),IB_Contact__c=con.id);
        insert ci;
        
        Contact_information__c ci2 = new Contact_information__c(recordtypeid=Schema.Sobjecttype.Contact_information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId(),
                                                                name='Ck1',phone__c='+981212',job__c='Job',roleId__c=String.valueof(theRoleRepo1.id),IB_Contact__c=con.id);
        insert ci2;

        IB_Role__c onlineCoordinatorRole1 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Applicant', 
                IB_Role__c = theRoleRepo1.Id,
				Contact_Information_Email__c=ci.id,
        		Contact_Information_Phone__c=ci2.id,
                IB_Contact__c = con.Id,
                Job_Title__c = 'BA',
        		Role_Level__c = 'Fully Qualified',
        		Email_Confirmed__c=true
            ));
        ibRoleList.add(onlineCoordinatorRole1);
        
        IB_Role__c onlineCoordinatorRole2 = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Confirmed', 
                IB_Role__c = theRoleRepo1.Id,
				Contact_Information_Email__c=ci.id,
        		Contact_Information_Phone__c=ci2.id,
                IB_Contact__c = con.Id,
                Job_Title__c = 'BA',
        		Role_Level__c = 'Fully Qualified',
        		Email_Confirmed__c=true
            ));
        ibRoleList.add(onlineCoordinatorRole2);
        
        IB_Role__c teacherRole = IBRoleTestDataFactory.createRole(
            new IB_Role__c(
                IB_Account__c = acc.Id,
                IB_Programme_New__c = prog.Id,
                Status__c = 'Confirmed', 
                IB_Role__c = theRoleRepo2.Id,
                IB_Contact__c = con.Id,
        		Role_Level__c = 'Fully Qualified',
        		Email_Confirmed__c=true
            ));
        ibRoleList.add(teacherRole);
        
        insert ibRoleList;
    }    
    
    @isTest
    public static void testIbRoleBeforeInsert() {
        
        IB_Programme__c prog = [Select Id from IB_Programme__c LIMIT 1];        
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser@test.com' LIMIT 1];

        Test.startTest();
        
        prog.Status__c = 'Authorized';
        prog.Date_Decision_on_Authorization__c = System.today();
        prog.Owner__c = UserInfo.getUserId();
        update prog;

        System.runAs(testUser) {
            list<ib_role__c> rolelist = [Select Id from ib_role__c];
            
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClassOP.getRoleList());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClassOP.getRoleListConfirmed());
            system.assertNotEquals(rolelist, RolesAndAssociationLWCClassOP.getRoleListTransConfirmed());
            
            RolesAndAssociationLWCClassOP.AddSelectedItems(rolelist);
            RolesAndAssociationLWCClassOP.DeclinedApplicantRoles(rolelist);
            RolesAndAssociationLWCClassOP.DeclinedConfimRoles(rolelist);  
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testConfirmTeacherUser() {
        
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser@test.com' LIMIT 1];
        Integer initialRoleCount = [SELECT COUNT() FROM IB_Role__c WHERE IB_Contact__c = :con.Id];
  
        Test.startTest();
        System.runAs(testUser) {  
            try {           
                RolesAndAssociationLWCClassOP.ConfirmTeacherUser(); 
                Integer newRoleCount = [SELECT COUNT() FROM IB_Role__c WHERE IB_Contact__c = :con.Id];
            	System.assertEquals(initialRoleCount + 1, newRoleCount, 'A new Teacher role should have been created');
            } catch(exception e) {
                System.assert(false, 'ConfirmTeacherUser should not throw exception: ' + e.getMessage());
            }
        }
        Test.stopTest();
    } 
}