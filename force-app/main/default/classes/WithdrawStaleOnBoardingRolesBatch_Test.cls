@isTest(seeAllData=false)
public class WithdrawStaleOnBoardingRolesBatch_Test {
    
    @testSetup
    public static void createTestData() {
        Id userLicenseId = [ SELECT Id FROM UserLicense WHERE name = 'Salesforce'].id;
        Id userroleId = [ SELECT Id FROM UserRole WHERE name = 'System Administrator'].id;
        Id communityprofileId = [SELECT Id FROM Profile WHERE name='system administrator' and UserLicenseId=:userLicenseId].id;
        List<User> usr = AccountFactoryTest.createUserTestData(1,communityprofileId,false,'ibportaltestuser@testorg.com');
        usr[0].Bypass_Validation_Rules__c = true;
        usr[0].UserRoleId = userroleId;
        insert usr;
        User pu;
        System.runAs(usr[0]){
            Account acc = AccountFactoryTest.createAccountRecord(false);
            insert acc;
            List<Contact> conRecords = ContactFactoryTest.createContacts(3,false,acc);   
            if(!conRecords.isEmpty()){
                insert conRecords;
            }
            
            IB_View_State_Contacts__c ib_View=new IB_View_State_Contacts__c(Contact_ID__c=conRecords[0].Id,Account_ID__c=acc.id,Active__c=true);                
            insert ib_View;
            IB_Country_Segmentation__c country2= RoleRepoFactoryTest.createCountry(false, acc);
            insert country2;
            List<IB_Address__c> addresRec = RoleRepoFactoryTest.createAddress(3,country2.id,acc,false); 
            if(!addresRec.isEmpty()){
                insert addresRec;
            }
            
            BulkDataFactoryTest.loadRoleRepoData();
            IB_Role_Repository__c repoHOSOverall = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                           FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School (Overall)' Limit 1];
            IB_Role_Repository__c repoBC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                          FROM IB_Role_Repository__c WHERE Role_Name__c='Billing Contact' Limit 1];
            IB_Role_Repository__c repoPC = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                           FROM IB_Role_Repository__c WHERE Role_Name__c='Programme Coordinator' Limit 1];
            IB_Role_Repository__c repoHOS = [SELECT Id,Role_Name__c,Available__c,SF_Role_Application__c,Available_From__c,Role_Level__c,Sub_Category__c,Training_Model__c,IB_Staff_Role__c,Available_in_Region__c,Related_Programmes__c
                                           FROM IB_Role_Repository__c WHERE Role_Name__c='Head of School' Limit 1];
            
            List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
            IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoHOS.Id, conRecords[0].id, conRecords[0].AccountId); 
            role.Programme_Selection__c = 'PYP';
            role.Expiry_Date__c = Date.today();
            testRoles.add(role);
            
            insert testRoles;
        }
    }
    
    @isTest
    static Void testBatchJob() {
        Test.startTest();
        String CRON_EXP = '0 0 0 14 8 ? 2040';
        WithdrawStaleOnBoardingRolesBatch wsbrb = new WithdrawStaleOnBoardingRolesBatch();   
        String jobId =  System.schedule('Withdraw stale onboarding roles', CRON_EXP, wsbrb);
        Database.executeBatch(wsbrb, 20);
        Test.stopTest();
        
        final List<IB_Role__c> listRoles = [select Id,Status__c from IB_Role__c where Status__c='Withdrawn'];
        system.assertEquals(1, listRoles.size());
    }
}