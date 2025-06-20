@isTest(seeAllData=false)
public class WithdrawOnboardingRolesQueueable_Test {

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
            testRoles.add(role);
            
            IB_Role__c role2 = RoleRepoFactoryTest.createIbRole(repoPC.Id, conRecords[1].id, conRecords[0].AccountId); 
            role2.Programme_Selection__c = 'PYP';
            testRoles.add(role2);
            
            IB_Role__c role3 = RoleRepoFactoryTest.createIbRole(repoBC.Id, conRecords[2].id, conRecords[0].AccountId); 
            role3.Programme_Selection__c = 'PYP';
            testRoles.add(role3);
            
            insert testRoles;
        }
    }
    
    public static testMethod void testQueuebleJob() {
        Account acc = [select Id from Account limit 1];
        Test.startTest();
        List<IB_Programme__c> progRecList = new List<IB_Programme__c>();
        IB_Programme__c progRec = IbProgramFactoryTest.createProgrammeForAccount(acc, 'PYP');
        progRecList.add(progRec);
        insert progRecList;
        Test.stopTest();
        
        final List<IB_Role__c> listRoles = [select Id,Status__c from IB_Role__c where Status__c='Withdrawn' and IB_Programme_New__c=null];
        system.assertEquals(3, listRoles.size());
    }
    
}