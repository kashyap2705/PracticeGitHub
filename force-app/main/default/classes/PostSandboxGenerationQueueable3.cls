public with sharing class PostSandboxGenerationQueueable3 implements Queueable {
    
    List<Contact> contactRecords = new List<Contact>();
    List<IB_Programme__c> programmeRecords = new List<IB_Programme__c>();
    
    public PostSandboxGenerationQueueable3(List<Contact> tempContacts, List<IB_Programme__c> tempProgrammes)
    {
        this.contactRecords = tempContacts;
        this.programmeRecords = tempProgrammes;
    }
    
    public void execute(QueueableContext context) {
        
        // 7. Create the IB Role Repositories
        List<IB_Role_Repository__c> ibRoleRepositoryRecords = PostSandboxGeneration.createRoleRepository();
        for(IB_Role_Repository__c tempRoleRepo : ibRoleRepositoryRecords)
        {
            tempRoleRepo.Category__c = 'School Services';
        }
        insert ibRoleRepositoryRecords;
        
        // 8. Create the Role(s) and Application(s)
        List<IB_Role_Repository__c> insertedRoleRepo = ([SELECT Id, 
                                                            Role_Name__c 
                                                        FROM IB_Role_Repository__c 
                                                        WHERE Role_Name__c IN ('Programme Coordinator', 'Head of School (Overall)', 'Head of School')]);
        
        IB_Role_Repository__c hosRole = null;
        IB_Role_Repository__c hosOverallRole = null;
        IB_Role_Repository__c pcRole = null;
        
        for(IB_Role_Repository__c tempRepo : insertedRoleRepo)
        {
            if(tempRepo.Role_Name__c == 'Programme Coordinator')
            {
                pcRole = tempRepo;
            }
            else if(tempRepo.Role_Name__c == 'Head of School (Overall)')
            {
                hosOverallRole = tempRepo;
            }
            else
            {
                hosRole = tempRepo;
            }
        }
        
        List<IB_Role__c> ibRoleRecords = PostSandboxGeneration.createIbRoles(hosRole, hosOverallRole, pcRole, contactRecords, programmeRecords[0]);
        if(!Test.isRunningTest())
        {
            // this is here due to issues with multiple queueable job error that doesn't show during normal usage
            insert ibRoleRecords;
        }
        
        
        // 9. Create the IB Applications
        List<IB_Application__c> allApplications = new List<IB_Application__c>();
        for(IB_Programme__c tempProgramme : programmeRecords)
        {
            List<IB_Application__c> ibApplicationRecords = PostSandboxGeneration.createIBApplications('Application for Candidacy', tempProgramme, 1);
            allApplications.addAll(ibApplicationRecords);
        }
        
        insert allApplications;
        
        // 10. Activate Partner Contacts
        
        List<User> userList = new List<User>();
        
        for(Contact tempCon : contactRecords)
        {
            User userNew = PostSandboxGeneration.createUser('SCU + Advanced', tempCon.FirstName, tempCon.LastName);
            userNew.ContactId = tempCon.Id;
            userList.add(userNew);
        }
        
        insert userList;
    }
}