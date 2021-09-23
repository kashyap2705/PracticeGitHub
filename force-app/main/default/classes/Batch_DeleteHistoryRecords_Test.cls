@isTest
public class Batch_DeleteHistoryRecords_Test {
    public static testmethod void trackHistoryTest() {
        e_eat__Audit_Tracking_sObject__c trackObj1 = new e_eat__Audit_Tracking_sObject__c();
        trackObj1.Name = 'Account';
        trackObj1.e_eat__API_Name__c = 'Account';
        trackObj1.e_eat__Archival_Time_in_Months__c = 1;
        insert trackObj1;
        
        system.assertEquals(trackObj1.e_eat__API_Name__c, 'Account');
        
        List<e_eat__Audit_Tracking_Field__c> accFieldsList = new List<e_eat__Audit_Tracking_Field__c>();
        e_eat__Audit_Tracking_Field__c accField1 = new e_eat__Audit_Tracking_Field__c();
        accField1.e_eat__Audit_Tracking_sObject__c = trackObj1.Id;
        accField1.e_eat__Field_API_Name__c = 'Name';
        accField1.e_eat__Active__c = true;
        accFieldsList.add(accField1);
        e_eat__Audit_Tracking_Field__c accField2 = new e_eat__Audit_Tracking_Field__c();
        accField2.e_eat__Audit_Tracking_sObject__c = trackObj1.Id;
        accField2.e_eat__Field_API_Name__c = 'AccountNumber';
        accField1.e_eat__Active__c = true;
        accFieldsList.add(accField2);
        insert accFieldsList;
        
        system.assertEquals(accFieldsList.size(), 2);
        
        List<Account> accountList = new List<Account>();
        
        for(integer i=0; i<10; i++){
        	Account objAcc= new Account(Name='TestAcc'+i,AccountNumber='12345'+i);
            accountList.add(objAcc);    
        }
        insert accountList;
        
        system.assertEquals(accountList[0].AccountNumber, '123450');
        
        List<Account> accountListUpdate = new List<Account>();
        for(Account objAcc : [select Id,Name,AccountNumber from Account where Name like 'TestAcc%']){
        	objAcc.Name += 'a';
            objAcc.AccountNumber += 1;
            accountListUpdate.add(objAcc);    
        }
        update accountListUpdate;
        
        system.assertEquals(accountListUpdate[0].AccountNumber, '1234501');
        
        Database.executeBatch(new Batch_DeleteHistoryRecords(), 200);
    }

}