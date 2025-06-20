@isTest
public class AccountFactoryTest {
    public static User createPortalUserPYP(String testemail, Contact c){
        Profile p =  [select Id,UserLicense.Name from profile where Name='SCU + Advanced' limit 1];
        Account acc = createAccount('test acc name', '');
        
        insert acc;
        
        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '5',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
            
        );
        
        insert s;
        
        RoleRepoFactoryTest.generateStandardRoles();
        
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        
        system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        
        
        return pu;
    }
    public static User createCommunityUser(String testemail, Contact c){
        Profile p =  [select Id,UserLicense.Name from profile where Name='SCU + Advanced' limit 1];
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        return pu;
    }
    public static User createPortalUserPYP(String testemail, Boolean generateRoles,Contact c){
        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];
        
        Account acc = createAccount('test acc name', '');
        insert acc;
        
        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '5',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
            
        );
        
        insert s;
        
        if(generateRoles){
            RoleRepoFactoryTest.generateStandardRoles();
        }
        User pu = new User(profileId = p.id, username = testemail, email = testemail, 
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        
        system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        return pu;
    }
    
    
    public static Account createAccount(String name, String recordType){
        Id recordTypeId;
        if(recordType != ''){
            try{
                recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
            } catch(Exception e){}
        }
        
        if (recordTypeId == null){
            return new Account (
                Name = name,
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = name
            );
            
        } else {
            return new Account (
                Name = name,
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Short_Name__c = name,
                Lead_Account__c = true,
                Billing_Currency__c = 'USD',
                RecordTypeId = recordTypeId
            );
        }
    }
    
    public static Account createAccountRecord(Boolean isInsert){
        Account acc=new Account ( 
            Name = 'John',
            Region__c = 'IBAEM',
            Sub_region__c = 'EUROPE', 
            External_PD_Provider__c = true,
            Language_Of_Correspondance__c = 'English',
            Legal_Status__c = 'Private',
            Short_Name__c = 'John',
            IBIS_ID__c = '000001',
            State_Abbr__c = 'SA',    // US-0001944 Change
            Website = 'https://www.test.com'   // US-0001944 Change
        );    
        if(isInsert == true){
            insert acc;
        }
        return acc;
    }    
    // created this test data for the class IbportalFooterController And IbPortalFooterControllerTest by Saurabh Singh
    public static List<User> createUserTestData(Integer count,Id profileId,Boolean isInsert, String userData) {
        List<User> users = new List<User>();
        for(Integer i=0; i<count; i++){
            User userRecords = new User(Alias = 'ibport'+i, Email='ibportaluser@testorg.com'+i,
                                        EmailEncodingKey='UTF-8',FirstName='test'+i, LastName='testing1'+i, LanguageLocaleKey='en_US',
                                        LocaleSidKey='en_US', ProfileId = profileId,
                                        TimeZoneSidKey='America/Los_Angeles', UserName=userData);
            users.add(userRecords);
        }
        
        if(isInsert)
            insert users;
        return users;
    }
}