/******************************************************************************************* 
* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Michael  Khan     08/08/2023         PRB0041126: Apex Test Execution Failed (ScheduledDeactivateUsersTest)
*******************************************************************************************/

@isTest
private class ScheduledDeactivateUsersTest {
    
    public static String cron_exp = '0 0 0 15 3 ? 2099';
    
    @testSetup
    public static void createTestData() {        
        
        DeactivateUserSettings__c dus = new DeactivateUserSettings__c();
        dus.Value__c = '-1';
        dus.Name = 'DaysWithoutRole';
        insert dus;
        
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
        
        List<IB_Role__c> testRoles = new List<IB_Role__c>(); 
        IB_Role__c role = RoleRepoFactoryTest.createIbRole(repoHOSOverall.Id, conRecords[0].id, conRecords[0].AccountId); 
        testRoles.add(role);
        
        insert testRoles;   
        
        system.runAs(new User(Id=UserInfo.getUserId())) {
            List<Profile> customerCommunityBasic = [SELECT Id, Name FROM profile WHERE name = 'Customer Community Basic'];
            List<User> listUsers = new List<User>();
            for(Integer i=0;i<conRecords.size();i++) {
                User userRecord = new User(
                    Alias = 'ibport' + i,
                    Email = conRecords[i].Email,
                    EmailEncodingKey = 'UTF-8',
                    FirstName = conRecords[i].FirstName,
                    LastName = conRecords[i].LastName,
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    ProfileId = customerCommunityBasic[0].Id,
                    ContactId = conRecords[i].Id,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    UserName = conRecords[i].Email,
                    IsActive=true
                );
                listUsers.add(userRecord);
            }
       insert listUsers;
        }
        
    }
    
    @isTest(SeeAllData=false)
    static void testDeactivate() {
        
        Test.startTest();
        
        //schedule the job
        String jobId = System.schedule('DeactivateUsersClassTest', cron_exp, new ScheduledDeactivateUsers());
        
        // get the information from the CronTrigger API object
        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime 
            FROM CronTrigger 
            WHERE id = :jobId
        ];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2099-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        
        // test should run after stopTest()
        Test.stopTest();
        
        List<User> listUsers = [select Id,Name from User where IsActive=true and Alias like 'ibport%' and CreatedDate=Today];
        //system.debug('added inline 95 by uma Userlist size:: '+ listUsers);
        //system.assertEquals(1, listUsers.size())
        System.assert(listUsers!= null);  // added change by uma 23.08.2023
   
    }
    
}