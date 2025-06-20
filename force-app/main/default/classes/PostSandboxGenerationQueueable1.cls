public with sharing class PostSandboxGenerationQueueable1 implements Queueable {
    
    public void execute(QueueableContext context) {
        
        // 1. Create the Leads
        List<Lead> leadRecords = PostSandboxGeneration.createLeads(4, 'School Lead');
        insert leadRecords;
        
        // 2. Create the Accounts
        List<Account> accountRecords = PostSandboxGeneration.createAccounts(1, 'School Account');
        Integer i = 0;
        for(Account acc : accountRecords)
        {
            acc.IBIS_ID__c = '100000';
        }
        insert accountRecords;
        
        for(Account tempAccount : accountRecords)
        {
            tempAccount.IsPartner = true;
            tempAccount.Lead_Account__c = false;
        }
        
        update accountRecords;
        
        // 3. Create the Contacts
        List<Contact> contactRecords = PostSandboxGeneration.createContacts(1, 'Invited Contact');
        List<Contact> contactRecords2 = PostSandboxGeneration.createContacts(2, 'Standard Contact');
        List<Contact> finalContactList = new List<Contact>();
        finalContactList.addAll(contactRecords);
        finalContactList.addAll(contactRecords2);
        
        for(Contact tempContact : finalContactList)
        {
            tempContact.AccountId = accountRecords[0].Id;
        }
        
        insert finalContactList;
        
        // continue the chain
        if(!Test.isRunningTest())
        {
            System.enqueueJob(new PostSandboxGenerationQueueable2(accountRecords, finalContactList));
        }
    }
}