/**    
* <h1>IB_RoleAfterInsertTriggerHandler</h1>    
* This class is responsible managing after insert trigger functionality on IB_Role__c object as part of trigger consolidation,US11101.
* 
* @author  Abd Ur Rehman    
* @version 1.0   
* @since   28-1-2020

Modification Log     :                                                                              
*-------------------------------------------------------------------------------------------------- 
* Developer                   Date                   Description          Version                          
* ------------------------------------------------------------------------------------------------- 
* Ranjith Kondabathini      05/30/2023         Moved method setProgrammeDefaultRoles to IB_RoleTriggerHelper class
*/
public class IB_RoleAfterInsertTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        system.debug('IB_RoleAfterInsertTriggerHandler mainEntry');
        //if(TriggerContextUtility.isFirstRun()){
        
        //TriggerContextUtility.setFirstRunFalse();
         //IB_NewCIRoleAdded.withdrawTheUserWhoRequestedCIRole((list<IB_Role__c>)tp.newList); // added newly for DAS
        IB_RoleTriggerHelper.setProgrammeDefaultRoles((list<IB_Role__c>)tp.newList, new Map<Id,IB_Role__c>());
        process((Map<Id,IB_Role__c>)tp.oldMap, (Map<Id,IB_Role__c>)tp.newMap);        
        system.debug('calling the function changes profile');
        IB_RoleTriggerHelper.ChangeProfiles((list<IB_Role__c>)tp.newList);  
        //   new IbInstituteManagement().ManageAdminRoles((list<IB_Role__c>)tp.newList); 
        // }
    }
    @testVisible private static void process (Map<Id,IB_Role__c> oldRec, Map<Id,IB_Role__c> newRec) {
                     
        List<IB_Role__c> listRolesToIBECAdminEmail = new List<IB_Role__c>();//Added by Michael(EPAM) as part of PRB0041092
        list<id> accIdsForIBECAdmin=new list<id>(); //Added as part of PRB0041092 by Michael(EPAM)
        Set<Id> ibenMoodleUsernameContacts = new Set<Id>(); 
        Set<Id> insertIBCodeSet = new Set<Id>();
        // IBEN Services - US-94178 - Moodle Username generation
        String ibenMoodleUsernameRoles = 'Examiner|Exam Team Leader|Principal Examiner|Deputy Examiner Responsible|Examiner Responsible|Chief Examiner|Assessment Language Reviewer|Assessment Content Developer|Assessment Translator';
        // IBEN Services - US-112732 - IB Code Generation
        String schoolRoles = 'Head of School (Overall)|Head of School|Programme Coordinator|Exam Contact|Billing Contact';
        
        String roleStatusFilter2 = 'Confirmed';
        
        //Below list created prerna on 04-06-2024 for ECM00501 --START--
        List<IB_Role__c> rolesToSendEmail = new List<IB_Role__c>();
        
        for (Id key : newRec.keySet()) {
            Id cId = newRec.get(key).IB_Contact__c;
            
            //code added by prerna on 05-06-2024 for ECM00501 --START--
            IB_Role__c newRoleRecord = newRec.get(key);
            if (newRoleRecord.Status__c == 'Confirmed' && 
                newRoleRecord.Programme_Status__c == 'Candidate' &&
                (newRoleRecord.IB_Role_Name__c == 'Head of School' || newRoleRecord.IB_Role_Name__c == 'Programme Coordinator' || newRoleRecord.IB_Role_Name__c == 'Head of School (Overall)')) {
                rolesToSendEmail.add(newRoleRecord);
            }
            //code added by prerna on 05-06-2024 for ECM00501 --END--
            
            if( /*(ibenMoodleUsernameRoles.contains(newRec.get(key).IB_Role_Name__c) || schoolRoles.contains(newRec.get(key).IB_Role_Name__c)) && */ roleStatusFilter2.contains(newRec.get(key).Status__c)){
                insertIBCodeSet.add(cId);
            }
          /*  if(ibenMoodleUsernameRoles.contains(newRec.get(key).IB_Role_Name__c) && roleStatusFilter2.contains(newRec.get(key).Status__c)){
                ibenMoodleUsernameContacts.add(cId);
            }*/
        }
        //code added by prerna on 05-06-2024 for ECM00501 --START--
        if (!rolesToSendEmail.isEmpty()) {
            EmailNotificationHandler.sendEmail(rolesToSendEmail);
        }
        //code added by prerna on 05-06-2024 for ECM00501 --END--
        
        System.debug('insertIBCodeSet.size() : ' + insertIBCodeSet.size());
        // IBEN Services - US-112732 - Calls contactIBCodeGeneration method to generate IB Code(old IBIS_contact_ID__c) field value
        if(!insertIBCodeSet.isEmpty() && /*!System.isBatch() && */!System.isQueueable() && !System.isFuture()){
            ContactDAO conDao = ContactDAO.getInstance();
            List<Contact> contactList = conDao.getContactsByContactIdList(insertIBCodeSet);
            IBENServicesHelper.contactIBCodeGeneration(contactList);
        }
        
       // System.debug('ibenMoodleUsernameContacts.size() : ' + ibenMoodleUsernameContacts.size());
        // Calls future method to update Moodle usernames
       // if(!ibenMoodleUsernameContacts.isEmpty() && !System.isBatch() && !System.isQueueable() && !System.isFuture()){
         //   IBENServicesHelper.generateTrainingUsername(ibenMoodleUsernameContacts);
       // }
        
        Set<Id> contactIds = new Set<Id>();
        for(IB_Role__c r:newRec.values()){
            contactIds.add(r.IB_Contact__c);
        }
        
        system.debug('ContactIds: ' + contactIds);
        
        system.debug('newRec.keyset(): ' + newRec.keyset());
        
        Set<Id> contactIdsToUpdate = new Set<Id>();
        List<ID> contactToProcess = new List<ID>();
        for(Id ibId : newRec.keyset()){
            
            system.debug('newRec.get(ibId) ' + newRec.get(ibId));
            system.debug('newRec.get(ibId).Status__c: ' + newRec.get(ibId).Status__c);
            system.debug('newRec.get(ibId).IB_Contact__c: ' + newRec.get(ibId).IB_Contact__c);
            system.debug('newRec.get(ibId).UserID__c: ' + newRec.get(ibId).UserID__c);
            system.debug('newRec.get(ibId).Email_Confirmed__c: ' + newRec.get(ibId).Email_Confirmed__c);
            system.debug('newRec.get(ibId).role: ' + newRec.get(ibId).IB_Role_Name__c);
            system.debug('newRec.get(ibId).contactInforation: ' + newRec.get(ibId).Contact_Information_Email__C);

            if(newRec.get(ibId) != null && newRec.get(ibId).Status__c != null && newRec.get(ibId).Status__c == 'Confirmed') {
                contactIdsToUpdate.add(newRec.get(ibId).IB_Contact__c);
            }
            
            if(newRec.get(ibId) != null && newRec.get(ibId).Status__c != null && newRec.get(ibId).UserID__c == null &&
               newRec.get(ibId).Status__c == 'Confirmed' && newRec.get(ibId).IB_Contact__c!=null &&
               (newRec.get(ibId).IB_Role_Name__c == 'Examiner' || newRec.get(ibId).IB_Role_Name__c == 'Chief Examiner' 
                || newRec.get(ibId).IB_Role_Name__c == 'Exam Team Leader' || newRec.get(ibId).IB_Role_Name__c == 'Principal Examiner' 
                || newRec.get(ibId).IB_Role_Name__c == 'Deputy Examiner Responsible' || newRec.get(ibId).IB_Role_Name__c == 'Examiner Responsible'|| newRec.get(ibId).IB_Role_Name__c == 'Assessment Language Reviewer'|| newRec.get(ibId).IB_Role_Name__c == 'Assessment Content Developer'|| newRec.get(ibId).IB_Role_Name__c == 'Assessment Translator')){
                    contactToProcess.add(newRec.get(ibId).IB_Contact__c);
                } 
            
            if((newRec.get(ibId).IB_Role_Name__c == 'IBEC Faculty Member' || newRec.get(ibId).IB_Role_Name__c == 'IBEC Candidate') && 
               newRec.get(ibId).Contact_Information_Email__C !=NULL && newRec.get(ibId).Status__c ==IboUtil.ROLE_APPLICANT_STATUS && 
               newRec.get(ibId).Email_Confirmed__c == true){//Added as part of PRB0041092 by Michael(EPAM)
                   listRolesToIBECAdminEmail.add(newRec.get(ibId));
                   system.debug('newRec '+listRolesToIBECAdminEmail);
                   accIdsForIBECAdmin.add(newRec.get(ibId).IB_Account__c);
               }
            
        }        
        
        if (!contactIdsToUpdate.isEmpty()) {
            IB_RoleTriggerHelper.updateContactRecordTypeOnRoleStatus(contactIdsToUpdate);
        }
        
        Map<Id,Contact> mapOfContactToProcess = new Map<Id,contact>([select Id,Name,Email,FirstName,LastName,User__c,IBEN_Examiner_Account_Setup__c from Contact where Id in :contactToProcess and User__c=Null and Email != null]);
        if(!mapOfContactToProcess.isEmpty() && !System.isBatch() && !System.isQueueable() && !System.isFuture()){
            CreateUserBatch bth = new CreateUserBatch(newRec,mapOfContactToProcess);
            Database.executeBatch(bth,2000);  
        }
        
        
        new IBRoleTriggerHandler().createRefereeFeedbacks(newRec);
        
        ID jobID = System.enqueueJob(new PermissionSetMaintenanceQueueable(contactIds));
        
        if(!Test.isRunningTest())
        {
            new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(newRec.values());
            //Following code line is added by Plumlogix-ECM00440 on 1/July/2022
            //new InstituteMgmRolesHandler().sendEmailtoAdminsForApplicantEmailConfirmedMatched(newRec.values());
            new InstituteMgmRolesHandler().ProcessInstitueRoles(newRec.values());
            //Added for ECM226 as part of Staff-Aug Project
            new IBECMgmRolesHandler().ProcessIBECRoles(newRec.values());

        }
        if(!listRolesToIBECAdminEmail.isEmpty()){
            new IBECMgmRolesHandler().SendEmailtoIBECAdminForApplicant(listRolesToIBECAdminEmail,accIdsForIBECAdmin);//added AccountIds as part of PRB0041092 by Michael(EPAM)
        }
       
    }    
    
}