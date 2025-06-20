/*** This is used to Test the instance of List of Accounts* * Ticket: US-0002457 *
* @author: Gautam Manchanda 
* @since 10-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 10-10-2024      Created             US-0002457       Created the class
* 14-10-2024      Modified            US-0002457       Updated Naming to Random string and updated the class name
* 29-10-2024      Modified            US-0002660       Updating to include newly required field
* 28-03-2025      Modified            US-0002473       Cacheing Record Type IDs to reduce SOQL calls
*/
@isTest
public without sharing class AccountTestDataFactory {
    
    private final static String REGION = 'IBAEM';
    private final static String SUBREGION = 'EUROPE';
    private final static String LANGUAGE = 'English';
    private final static String PRIVATE_VAR = 'Private';
    private final static String USD_CURRENCY = 'USD';
    private final static String WEBSITE = 'https://www.test.org';
    private final static String COUNTRY = 'SWEDEN';

    // Static cache for Record Type IDs
    private static Map<String, String> recordTypeIdCache = new Map<String, String>();

    public static List<Account> createAccounts(String recordTypeName, Account tempAccount, Integer nAccounts) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < nAccounts; i++) {
            Account acc = (tempAccount != null) ? tempAccount.clone(false) : new Account();
            acc = createAccountInstance(acc, recordTypeId);
            accounts.add(acc);
        }
        return accounts;
    }

    public static Account createAccount(String recordTypeName, Account tempAccount) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        Account acc = (tempAccount != null) ? tempAccount.clone(false) : new Account();
        acc = createAccountInstance(acc, recordTypeId);
        return acc;
    }

    public static String getRecordTypeId(String recTypeName) {
        // Check cache first
        if (recordTypeIdCache.containsKey(recTypeName)) {
            return recordTypeIdCache.get(recTypeName);
        }

        String recTypeId = '';
        try {
            recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch (Exception e) {
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' LIMIT 1].Id;
        }
        recordTypeIdCache.put(recTypeName, recTypeId);
        return recTypeId;
    }

    public static Account createAccountInstance(Account accountRecord, String recordTypeId) {
        Account accountInstance = accountRecord;
        if (recordTypeId != null) {
            accountInstance.RecordTypeId = recordTypeId;
        }

        accountInstance.Name = String.isBlank(accountRecord.Name) ? TestDataUtility.generateRandomString(5) : accountRecord.Name;
        accountInstance.Region__c = String.isBlank(accountRecord.Region__c) ? REGION : accountRecord.Region__c;
        accountInstance.Sub_region__c = String.isBlank(accountRecord.Sub_region__c) ? SUBREGION : accountRecord.Sub_region__c;
        accountInstance.External_PD_Provider__c = true;
        accountInstance.Language_Of_Correspondance__c = String.isBlank(accountRecord.Language_Of_Correspondance__c) ? LANGUAGE : accountRecord.Language_Of_Correspondance__c;
        accountInstance.Legal_Status__c = String.isBlank(accountRecord.Legal_Status__c) ? PRIVATE_VAR : accountRecord.Legal_Status__c;
        accountInstance.Billing_Currency__c = String.isBlank(accountRecord.Billing_Currency__c) ? USD_CURRENCY : accountRecord.Billing_Currency__c;
        accountInstance.Website = String.isBlank(accountRecord.Website) ? WEBSITE : accountRecord.Website;
        accountInstance.Lead_Account__c = true;
        accountInstance.Short_Name__c = accountInstance.Name;
        accountInstance.Country__c = String.isBlank(accountRecord.Country__c) ? COUNTRY : accountRecord.Country__c;

        return accountInstance;
    }
}