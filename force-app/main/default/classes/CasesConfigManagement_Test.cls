@isTest
private class CasesConfigManagement_Test {
  
                     // This Part is being Commented by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
//begin  
 /* @isTest static void taskTest() {
    
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='sta48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
    insert u;
    
    String recordTypeName = 'Salesforce Support';


    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
       
    Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
    id recordTypeId = rtInfo.getRecordTypeId();
       
    Case c = new Case(Name__c='Support Request Title', Status='New', Priority='Low', IB_Systems__c='SalesForce', Description='Testing Change Request', Area_of_Application__c='Cases');

    c.RecordTypeId = recordTypeId;
    c.IT_Case_Owner__c=u.id;
    insert c;
    
    c.Affected_Objects__c='test';
    c.Reason='Data';
    c.Actual_Hours__c=4;
    c.Status='Fixed';


    update c;
    
    System.runAs(u) {

        Sandbox__c sb = new Sandbox__c(Name='fulldata', Available_for_Deployments__c=true);
        insert sb;
        Sandbox__c sb_staging = new Sandbox__c(Name='staging', Available_for_Deployments__c=true, Staging_Sandbox__c=true);
        insert sb_staging;
    
        Date today = System.today();
        Sandbox_Deployment__c sd = new Sandbox_Deployment__c(Sandbox_ID__c=sb.id, Case_ID__c=c.id, Requested_Deployment_Date__c=today, Success_Criteria__c='test', Impact__c='Low', Risk__c='Low',
            Level_of_Effort__c='Low', Status__c='New');
        insert sd;
        
        Task t = new Task(Subject='Deploy Case XXX to Sandbox YYY', Status='Not Started', Priority='Normal', whatid=sd.id);
        insert t;
        
        t.Status='Completed';
        update t;
        
    }     
     
  }
  
  @isTest static void productionReleaseTest() {
      
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='sta48vn20ckjer@testorg.com', Change_Manager__c=true, Can_be_IT_Case_Owner__c=true);
    insert u;
    
    String recordTypeName = 'Salesforce Support';


    Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
       
    Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
    id recordTypeId = rtInfo.getRecordTypeId();
       
    Case c = new Case(Name__c='Support Request Title', Status='New', Priority='Low', IB_Systems__c='SalesForce', Description='Testing Change Request', Area_of_Application__c='Cases');


    c.RecordTypeId = recordTypeId;
    c.IT_Case_Owner__c=u.id;
    insert c;
    
    c.Affected_Objects__c='test';
    c.Reason='Data';
    c.Actual_Hours__c=4;
    c.Status='Fixed';

    update c;
    
    System.runAs(u) {
    
        Sandbox__c sb = new Sandbox__c(Name='fulldata', Available_for_Deployments__c=true);
        insert sb;
        Sandbox__c sb_staging = new Sandbox__c(Name='staging', Available_for_Deployments__c=true, Staging_Sandbox__c=true);
        insert sb_staging;
        
        Date today = System.today();
    
        
     
        Production_Release__c pr = new Production_Release__c(Status__c='New', Deployment_Date__c=today+5, Release_Type__c='Major Release', System_Testing_Date__c=today-5, User_Acceptance_Testing_Date__c=today-2);
        insert pr;
        Production_Release__c pr2 = new Production_Release__c(Status__c='New', Deployment_Date__c=today+2, Release_Type__c='Major Release', System_Testing_Date__c=today-5, User_Acceptance_Testing_Date__c=today-2);
        insert pr2;
    
        Production_Release_Case__c pra = new Production_Release_Case__c(Case__c=c.id, Production_Release__c=pr2.id, Deployment_Items_or_Change_Set__c='text');
        insert pra;
        
        Production_Release_Case__c pra = new Production_Release_Case__c(Case__c=c.id, Deployment_Items_or_Change_Set__c='text');
        insert pra;
        
        
        pra.status__c = 'Approved';
        update pra;
    
        Sandbox_Deployment__c sd = new Sandbox_Deployment__c(Sandbox_ID__c=sb_staging.id, Case_ID__c=c.id, Requested_Deployment_Date__c=today, Success_Criteria__c='test', Impact__c='Low', Risk__c='Low',
            Level_of_Effort__c='Low', Status__c='New');
        insert sd;
        
        sd.status__c = 'Approved';
        update sd;
        
       pr2.status__c = 'Approved';
        update pr2;
        
        pr2.status__c = 'Deployed';
        update pr2;
     }
  }*/

    //End
}