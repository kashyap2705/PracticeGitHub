public with sharing class PostSandboxGenerationQueueable2 implements Queueable  {
    
    List<Account> accountRecords = new List<Account>();
    List<Contact> contactRecords = new List<Contact>();
    
    public PostSandboxGenerationQueueable2(List<Account> tempAccounts, List<Contact> tempContacts)
    {
        this.accountRecords = tempAccounts;
        this.contactRecords = tempContacts;
    }
    
    public void execute(QueueableContext context) {
        
        // 4. Create the IB Country Segmentation
        IB_Country_Segmentation__c segmentation = PostSandboxGeneration.createIBCountrySegmentation('Australia', 'Asia', 'IBA');
        insert segmentation;
        
        // 5. Create the IB Address
        IB_Address__c address = PostSandboxGeneration.createIBAddressInstance('Active', 'Brooklyn', 'New York', '10001', segmentation, accountRecords[0]);
        insert address;
        
        // 6. Create the IB Programmes
        List<IB_Programme__c> ibDPProgrammes = PostSandboxGeneration.createIBProgrammes('Diploma Programme', address, 1);
        List<IB_Programme__c> ibMYPProgrammes = PostSandboxGeneration.createIBProgrammes('MYP', address, 1);
        List<IB_Programme__c> ibPYPProgrammes = PostSandboxGeneration.createIBProgrammes('PYP', address, 1);
        List<IB_Programme__c> ibCPProgrammes = PostSandboxGeneration.createIBProgrammes('CP', address, 1);
        
        List<IB_Programme__c> finalProgrammeList = new List<IB_Programme__c>();
        finalProgrammeList.addAll(ibDPProgrammes);
        finalProgrammeList.addAll(ibMYPProgrammes);
        finalProgrammeList.addAll(ibPYPProgrammes);
        finalProgrammeList.addAll(ibCPProgrammes);
        
        insert finalProgrammeList;
        
        // continue the chain
        if(!Test.isRunningTest())
        {
            System.enqueueJob(new PostSandboxGenerationQueueable3(contactRecords, finalProgrammeList));
        }
    }
}