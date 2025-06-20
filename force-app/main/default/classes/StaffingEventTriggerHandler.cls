/*-
* This class is handling Staffing Event
* Added line 9,10,56-65 by Vikranth for EMS Project D30-08-2023
*/ 
public class StaffingEventTriggerHandler {
    
     private final SchoolServicesTriggerProp__c schoolServicesConf = SchoolServicesTriggerProp__c.getInstance('SchoolServices');
     private final ProfessionalDevelopmentTriggerProp__c profDevConf = ProfessionalDevelopmentTriggerProp__c.getInstance('ProfessionalDevelopment');
     private final string ssRecordId = Schema.SObjectType.Staffing_Event__c.getRecordTypeInfosByDeveloperName().get('School_Services').getRecordTypeId();  //EMS-Project
     private final string pdRecordId = Schema.SObjectType.Staffing_Event__c.getRecordTypeInfosByDeveloperName().get('Professional_Development').getRecordTypeId(); //EMS-Project  
     private static final set<Id> sEMSRecordtypeIds = IBConstants.fetchCampaignEMSRecordTypeIds();
     public void publishStaffingEvents(final Map <Id, Campaign> oldMap,  final Map <Id, Campaign> newMap) {
         final List <IB_Event_Role__c> ibEventsRole = [SELECT IB_Event__c, Staffing_Event__c, Staffed_by_IB_Internally__c FROM IB_Event_Role__c where IB_Event__c IN  :newMap.keySet()];
         final List<Staffing_Event__c> staffingEvents = new List<Staffing_Event__c>();
         
         for (Campaign camp : newMap.values()) {
             
             final Campaign oldCamp = oldMap.get(camp.Id);
             
             if (camp.Staffing_Event_Published__c != oldCamp.Staffing_Event_Published__c && camp.Staffing_Event_Published__c ) 
             {
                 
                 final Staffing_Event__c newEvent = new Staffing_Event__c(IB_Event__c = camp.Id, Event_Organizer__c = camp.Event_Organizer_Account__c,
                                                                            Actual_PAX__c = camp.Actual_PAX__c, Forecasted_PAX__c = camp.Forecasted_PAX__c,
                                                                            Est_Num_IBEN__c = camp.NumberSent);
                 
                 if (null == schoolServicesConf) {
                    throw new ControllerException(' Error configuration for School Services Conf. Configuration with name - SchoolServices was not found!!');            
                 }
                 if (null == profDevConf) {
                    throw new ControllerException(' Error configuration for Professional Development Conf. Configuration with name - ProfessionalDevelopment was not found!!');
            
                 }  
                 
                 final Set <String> schoolServices = new Set <String> ();//'01220000000Ewq0', '01220000000FZFK' };
                 for (String id : schoolServicesConf.schoolServicesCampList__c.split(',', -2) ) {
                     schoolServices.add(id);
                 }
                 
                 final Set <String> professionalDevelopment = new Set <String> ();//{ '01220000000FvbI', '01220000000FYvg',
                                                                               // '01220000000FpOQ', '01220000000FuB8',
                                                                               // '01220000000EwqA', '01220000000Ewpv',
                                                                               //'01220000000FryG', '01220000000FYvb' };
                 for (String id : profDevConf.professionalDevelopmentCampList__c.split(',', -2) ) {
                     professionalDevelopment.add(id);
                 }                                                             
                                                                               
                 final String recId = ((String)camp.RecordTypeId).substring(0,15);
                 
                 if (professionalDevelopment.contains(recId) ) {
                     newEvent.RecordTypeId = profDevConf.profDevForStuffEvent__c; //'01211000000Ciyn';
                     
                 } else if (schoolServices.contains(recId) ) {
                     newEvent.RecordTypeId = schoolServicesConf.schoolServiceForStuffEvent__c; //'01211000000Ciyi';
                     
                 }
                 //Start of EMS-Project 
                 else if(sEMSRecordtypeIds.contains(camp.RecordTypeId)
                        /* == Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Requested_Event').getRecordTypeId()
                        || camp.RecordTypeId == Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Requested_Workshop').getRecordTypeId()
                        || camp.RecordTypeId == Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Scheduled_Event').getRecordTypeId()
                        || camp.RecordTypeId == Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Scheduled_Workshop').getRecordTypeId()*/
                 )
                 {
                          newEvent.RecordTypeId = pdRecordId; 
                 }  
                 //End of EMS-Project
                 staffingEvents.add(newEvent);
                 
             }
             
         }
         
         System.debug('Staffing Event '+staffingEvents);
         insert staffingEvents;
         
         final List <IB_Event_Role__c> ibEventsRoleForUpdate = new List <IB_Event_Role__c> ();
          
         for (Staffing_Event__c event : staffingEvents) {
            newMap.get(event.IB_Event__c).Staffing_Event_Notice_Board__c = event.Id;
                
            for (IB_Event_Role__c role : ibEventsRole) {
                if (role.IB_Event__c == event.IB_Event__c && role.Staffing_Event__c == null) {
                    role.Staffing_Event__c = event.Id;
                    ibEventsRoleForUpdate.add(role);

                }
            }
              
         }
         
         if (!ibEventsRoleForUpdate.isEmpty()) {
             update ibEventsRoleForUpdate;
         }
         
     }
          
     public void deleteStaffingEvents(final Map <Id, Campaign> oldMap) {
        
        final Map <Id, Campaign> acceptedCampignes = new Map <Id, Campaign> ();
        
        for (Campaign camp : oldMap.values()) {
            
            if (camp.StartDate <= Date.today())  {
                camp.addError(Label.Previous_Current_Event);
            
            } else {
                acceptedCampignes.put(camp.Id, camp);
                
            } 
            
        }
        
        final Set<String> staffingOrTrainingEvents = new Set<String> ();
        
        final Set<My_Training_Event__c> trainingEvents = new Set<My_Training_Event__c> ();
        
        for (AggregateResult result : [Select IB_Event__c event from My_Staffing_Event__c where IB_Event__c IN :acceptedCampignes.keySet() AND Start_Date__c <= : Date.today() group by IB_Event__c]) {
            
            staffingOrTrainingEvents.add((String) result.get('event'));    
              
        }
       
        for (AggregateResult result : [Select IB_Event__c event from My_Training_Event__c where IB_Event__c IN :acceptedCampignes.keySet() AND Start_Date__c <= : Date.today() group by IB_Event__c]) {
            
            staffingOrTrainingEvents.add((String) result.get('event'));    
              
        }
        
        for (String id  : staffingOrTrainingEvents) {
            acceptedCampignes.get(id).addError(Label.Delete_Event);
            acceptedCampignes.remove(id);
        }
        
        delete [select id from IB_Event_Role__c where IB_Event__c IN :acceptedCampignes.keySet()];
        delete [select id from Staffing_Event__c where IB_Event__c IN :acceptedCampignes.keySet()];
        delete [select id from Training_Event__c where IB_Event__c IN :acceptedCampignes.keySet()];
        
     }
     
     public void afterUpdateLogic(final Map <Id, Campaign> newMap,  final Map <Id, Campaign> oldMap) {
        /* //This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
        /*Begin*/
        try
        {
        final List <Training_Event__c> events =  new List <Training_Event__c> ();
        final List <String> campaingneIds = new List <String> ();
        List<Campaign> campaignsToNotSelect = new List<Campaign>();
        List<Campaign> campaignsToCancel = new List<Campaign>();
        List<Campaign> campaignsToComplete = new List<Campaign>();
        List<Campaign> Staffedcampaigns = new List<Campaign>();
        List<IB_Role__c> role = new List<IB_Role__c>();
        List<My_Staffing_Event__c> myStaffToUpdate = new List<My_Staffing_Event__c>();
         List<My_Staffing_Event__c> myStaffingToUpdate = new List<My_Staffing_Event__c>();
        List<My_Training_Event__c> myTrainingToUpdate = new List<My_Training_Event__c>();
        String template_name;
        //End

        //Added by Shahrukh for ECM00637 on 19/07/2023 -- START --
        Set<Id> eventIdSet = new Set<Id>();
        List<My_Staffing_Event__c> updateMyStaffingEvent = new List<My_Staffing_Event__c>();
        //Added by Shahrukh for ECM00637 on 19/07/2023 -- END --
        
        //code added by prerna on 27-02-2024 for ECM00508 -- START--
        Set<Id> relatedIBProgrammeIds = new Set<Id>();
        List<Id> filteredCampaigns = new List<Id> ();
        List<Campaign> campaignListToUpdate = new List<Campaign>();
        //code added by prerna on 27-02-2024 for ECM00508 -- END--

        for (String idValue : newMap.keySet()) {
            
            final Campaign oldVal = oldMap.get(idValue);
            final Campaign newVal = newMap.get(idValue);
            System.debug(' Training Event: '+newVal.Traing_Event_Published__c+' '+newVal.Training_Event_Notice_Board__c);
            if ( String.isEmpty(newVal.Training_Event_Notice_Board__c) && newVal.Traing_Event_Published__c ) {
                    
                Training_Event__c event = new Training_Event__c ();
                event.IB_Event__c = idValue;
                event.IB_Role__c  = newVal.IB_Role__c;
                event.IB_Role_2__c  =  newVal.IB_Role_2__c;
                event.IB_Role_3__c  =  newVal.IB_Role_3__c;
                event.Training_Organizer_Contact__c = newVal.Event_Organizer_Contact__c;
                events.add (event);
                 
            }
              /*This Part is being updated by Ammara-Plumlogix,as part of US-11580 and US-11565 on 06/11/2020
             /*Begin*/
            if( oldVal.Status != newVal.Status && (newVal.Status == 'Staffed' || newVal.Status == 'Confirmed' ||
                newVal.Status == 'Complete' || newVal.Status == 'Cancelled' || newVal.Status == 'Postponed' || newVal.Status == 'Closed / Finished' ))  {
                campaignsToNotSelect.add(newVal);
            } 
            /*code added by Prerna on 27-02-2024 for ECM00508 --starts--*/
            if(oldVal.Status != newVal.Status && (newVal.Status == 'Staffed' && newVal.StartDate != null && newVal.EndDate != null && newVal.EndDate >= System.Today() && newVal.Delivery_Mode__c != null && newVal.Related_IB_Programme__c != null && (newVal.IB_Event_Record_Type__c == 'Authorization' || newVal.IB_Event_Record_Type__c == 'Evaluation')))
            {
                System.debug('condition match====>');
                filteredCampaigns.add(idValue);
                relatedIBProgrammeIds.add(newVal.Related_IB_Programme__c);
                System.debug('filteredCampaigns==>'+filteredCampaigns);
            }
            // Added Cancelled condition for INC0199319 by Atticus F. on 10-07-2024
            // Added Staffing in Progress, Planned / Ready for Staffing, Pending condition on 09-09-2024 and removed Cancelled condition
            if(oldVal.Status != newVal.Status && (oldVal.Status == 'Staffed') && (newVal.Status == 'Staffing in Progress' || newVal.Status == 'Planned / Ready for Staffing' || newVal.Status == 'Pending') && (newVal.IB_Event_Record_Type__c == 'Authorization' || newVal.IB_Event_Record_Type__c == 'Evaluation'))
            {
                System.debug('oldstatus and new status are same====>');
                Campaign campaign  = new Campaign(Id = newVal.Id);
                campaign.Event_Confirmed__c = '';
                campaignListToUpdate.add(campaign);
            }  
            /*code added by Prerna on 27-02-2024 for ECM00508 --ends--*/
           
            //Campaigns with Status=Complete 
            if(oldVal.Status == 'Participants Confirmed' && newVal.Status == 'Complete') {
                campaignsToComplete.add(newVal);
            }
            //Campaigns with Status=Staffed
               if(oldVal.Status == 'Staffed' && newVal.Status == 'Participants Confirmed') {
                Staffedcampaigns.add(newVal);
            }
            if((oldVal.Status == 'Staffed' || oldVal.Status == 'Confirmed') && newVal.Status == 'Cancelled'){
                campaignsToCancel.add(newVal);
            }
            //End

            //Added by Shahrukh for ECM00637 on 18/07/2023 -- START --
            if(oldVal.Status != 'Cancelled' && newVal.Status == 'Cancelled'){
                eventIdSet.add(idValue);
            }
            //Added by Shahrukh for ECM00637 on 18/07/2023 -- END --
             
        }
         System.debug('Insert Training Events '+events);
        insert events;
        
         //Added by Prerna on 27-02-2024 for ECM00508 -- START --
            if(filteredCampaigns != null){
                String oldMapJson = JSON.serialize(oldMap);
                String newMapJson = JSON.serialize(newMap);
                //below change added by prerna on 02-04-2024 because we were facing "System.AsyncException" Exception.
                customCreateAndAttachPDF.ibProgramWLPDFExecuted = true;
                processCampaignsAsync(filteredCampaigns, oldMapJson, newMapJson, relatedIBProgrammeIds);
                customCreateAndAttachPDF.ibProgramWLPDFExecuted = false;
            }
            if (!campaignListToUpdate.isEmpty()) {
                System.debug('campaignListToUpdate separate====>'+campaignListToUpdate);
                Database.update(campaignListToUpdate);
            }
        //Added by Prerna on 27-02-2024 for ECM00508 -- END --

        //Added by Shahrukh for ECM00637 on 18/07/2023 -- START --
        //ECM00694 replaced Withdrawal_Reason__c with WithdrawalReason__c and modified the multi select logic
        if(!eventIdSet.isempty()){
        for(My_Staffing_Event__c staffingEvent: [SELECT Id, WithdrawalReason__c FROM My_Staffing_Event__c WHERE IB_Event__c IN :eventIdSet]){
            if((staffingEvent.WithdrawalReason__c != null && staffingEvent.WithdrawalReason__c != 'Event cancelled') ||
                staffingEvent.WithdrawalReason__c == null ) { // Modified by Atticus for INC0199319 on 10-07-2024
                staffingEvent.WithdrawalReason__c = 'Event cancelled';
            }
            updateMyStaffingEvent.add(staffingEvent); 
        }
        }

        if(!updateMyStaffingEvent.isEmpty()) {
            update updateMyStaffingEvent;
        }
        //Added by Shahrukh for ECM00637 on 18/07/2023 -- END --

          /*This Part is Being updated by Ammara-Plumlogix,CR Functionlity
         /*Begin*/
        if(events.size() > 0) {
            String role_status;
             List<Training_Event__c> training_event = [select id,Application_Deadline__c,Application_Deadline_French__c,Application_Deadline_Spanish__c,Training_Event_Language__c,Training_Event_Region__c,IB_Programme__c,Training_Event_Type__c from Training_Event__c where id=: events[0].id];
             System.debug('Values '+events[0].id +' '+training_event[0].Training_Event_Region__c +' '+training_event[0].IB_Programme__c);
        //get all roles that applied for that event
        //This variable is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
        //begin
        if(training_event[0].Training_Event_Type__c == 'Ongoing Development')
            role_status = 'Confirmed';
        else
            role_status = 'Applicant' ;
        //end
                   set<id> setRoleId = new set<id>();
            if(events[0].IB_Role__c != null){
                setRoleId.add(events[0].IB_Role__c);
            }
            if(events[0].IB_Role_2__c != null){
                setRoleId.add(events[0].IB_Role_2__c);
            }
            if(events[0].IB_Role_3__c != null){
                setRoleId.add(events[0].IB_Role_3__c);
            }
            List<IB_Role__c> roles = [Select id,IB_Contact__c,Email__c,IB_Contact__r.User_Language__c,Notify_of_Training_Event__c,Programme_Selection__c,Contact_IBEN_Region__c from IB_Role__c where Role_Application_Status__c = :role_status
                                         AND Programme_Selection__c =: training_event[0].IB_Programme__c
                                         AND Contact_IBEN_Region__c =: training_event[0].Training_Event_Region__c
                                         AND IB_Role__c IN: setRoleId];
            System.debug('Roles '+roles.size());
            
            //List for comparision holding IB Contact Ids
            set<ID> setContId = new set<ID>();
            set<String> setEngUserId = new set<String>();
            set<String> setFrUserId = new set<String>();
            set<String> setSpUserId = new set<String>();
            map<id, string> mapContIdToLang = new map<id, string>();
            
            //for to traverse IB Roles
            for(IB_Role__c r0le: roles){
                 //Check to send the email only one time to a specfic contact
                if(!setContId.contains(r0le.IB_Contact__c)) {
                    setContId.add(r0le.IB_Contact__c);
                    mapContIdToLang.put(r0le.IB_Contact__c, r0le.IB_Contact__r.User_Language__c);
                }
            }
            for(User usr : [SELECT ContactId,Email FROM User where ContactId IN: setContId]){
                if(mapContIdToLang.get(usr.ContactId) == null || mapContIdToLang.get(usr.ContactId) == 'en_US'){
                    setEngUserId.add(usr.Email);
                }
                if(mapContIdToLang.get(usr.ContactId) == 'es'){
                    setSpUserId.add(usr.Email);
                }
                if(mapContIdToLang.get(usr.ContactId) == 'fr'){
                    setFrUserId.add(usr.Email);
                }
            }
            if(!setEngUserId.isEmpty()){
                System.debug('English: '+events[0].IB_Event__c+' Size: '+setEngUserId.size());
                Send_Email(setEngUserId,string.valueOf(training_event[0].Application_Deadline__c),'English');
            }
            if(!setSpUserId.isEmpty()){
                System.debug('Spanish: '+events[0].IB_Event__c+' Size: '+setSpUserId.size());
                Send_Email(setSpUserId,string.valueOf(training_event[0].Application_Deadline_Spanish__c),'Spanish');
            }
            if(!setFrUserId.isEmpty()){
                System.debug('French: '+events[0].IB_Event__c+' Size: '+setFrUserId.size());
                Send_Email(setFrUserId,string.valueOf(training_event[0].Application_Deadline_French__c),'French');
            }
        }
                if(!campaignsToNotSelect.isEmpty()){

            final List <My_Staffing_Event__c> myStaffEvents =  [SELECT Id  FROM My_Staffing_Event__c 
                                                            WHERE IB_Event__c in :campaignsToNotSelect
                                                            AND Application_Status__c IN ('Invited', 'Pending Selection', 'Consideration', 'Under Approval')];
            for (My_Staffing_Event__c myStaffEvent : myStaffEvents) {
                myStaffEvent.Application_Status__c = 'Not Selected';
                myStaffToUpdate.add(myStaffEvent);
            }
          }
                   //change the My Educator Developmen Application Status to complete when evnt status is complete

           if(!campaignsToComplete.isEmpty()){
            final List <My_Training_Event__c> myTrainingEvents1 =  [SELECT Id  FROM My_Training_Event__c 
                                                            WHERE IB_Event__c in :campaignsToComplete
                                                            AND Application_Status__c IN ('Confirmed')];
            for (My_Training_Event__c TrainingEvent : myTrainingEvents1) {
                TrainingEvent.Application_Status__c = 'Complete';
                myTrainingToUpdate.add(TrainingEvent);
            }
          }
            //change the My Educator Developmen Application Status to Not selected when evnt status is Participants Confirmed
           if(!Staffedcampaigns.isEmpty()){
             final List <My_Training_Event__c> myTrainingEvents2 =  [SELECT Id  FROM My_Training_Event__c 
                                                            WHERE IB_Event__c in :Staffedcampaigns
                                                            AND Application_Status__c IN ('Invited', 'Pending Selection', 'Consideration', 'Under Approval')];
            
            for (My_Training_Event__c TrainingEvent : myTrainingEvents2) {
                TrainingEvent.Application_Status__c = 'Not Selected';
                myTrainingToUpdate.add(TrainingEvent);
            }
          }
          
    
        if(!campaignsToCancel.isEmpty()){
            List<My_Staffing_Event__c> toCancel = [SELECT Id FROM My_Staffing_Event__c
                                               WHERE IB_Event__c in :campaignsToCancel
                                               AND Application_Status__c = 'Confirmed']; 
            for(My_Staffing_Event__c s:toCancel){
                s.Application_Status__c = 'Withdrawn by IB';
                myStaffToUpdate.add(s);
            }
        }
        
        update myStaffToUpdate;
        //update My Educator Development Record
        update myTrainingToUpdate;
        }
         catch(Exception e)
         {
            System.debug('An exception occurred: ' + e.getMessage());
         }
    }
    //below method writtened by Prerna on 21-03-2024 for ECM00508
    @future
    public static void processCampaignsAsync(List<Id> filteredCampaigns, String oldMapJson, String newMapJson, Set<Id> relatedIBProgrammeIds) {
        // Deserialize old and new maps
        Map<Id, Campaign> oldMap = (Map<Id, Campaign>) JSON.deserialize(oldMapJson, Map<Id, Campaign>.class);
        Map<Id, Campaign> newMap = (Map<Id, Campaign>) JSON.deserialize(newMapJson, Map<Id, Campaign>.class);
        System.debug('oldMap==>'+oldMap);
        System.debug('newMap==>'+newMap);
        System.debug('filteredCampaigns==>'+filteredCampaigns);
        System.debug('relatedIBProgrammeIds==>'+relatedIBProgrammeIds);
        List<Campaign> campaignListToUpdate = new List<Campaign>();
        if(filteredCampaigns != null){
            System.debug('relatedIBProgrammeIds====>'+relatedIBProgrammeIds);
            Map<Id, IB_Programme__c> programmeMap = new Map<Id, IB_Programme__c>();
            Map<Id, Map<String, IB_Role__c>> ibProgrammeVsIBRoleMap = new Map<Id, Map<String, IB_Role__c>>();
            Map<Id, Map<String, My_Staffing_Event__c>> ibEventVsMyAssignmentMap = new Map<Id, Map<String, My_Staffing_Event__c>>();        
            List<My_Staffing_Event__c> myAssignmentsList = new List<My_Staffing_Event__c>();
            List<IB_Role__c> ibRolesList = new List<IB_Role__c>();
            //Map<id, id> programmeVsContactMap = new Map<id, id>();
            myAssignmentsList = [select id, IB_Event__c,IB_Role_Name__c,Application_Status__c,IB_Contact__r.Email,IB_Contact__r.Name 
                                 FROM My_Staffing_Event__c 
                                 WHERE IB_Event__c IN: filteredCampaigns
                                 AND (IB_Role_Name__c = 'School Visit Team Leader' OR IB_Role_Name__c = 'School Visit Team Member')
                                 AND Application_Status__c = 'Confirmed'];
            
            if (!relatedIBProgrammeIds.isEmpty()) {
                ibRolesList = [SELECT id, IB_Contact__c,IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,IB_Role_Name__c,Status__c 
                               FROM IB_Role__c 
                               WHERE IB_Programme_New__c IN :relatedIBProgrammeIds 
                               AND Status__c = 'Confirmed' 
                               AND (IB_Role_Name__c = 'Head of School' Or IB_Role_Name__c = 'Programme Coordinator')];
                programmeMap = new Map<Id, IB_Programme__c>([SELECT Id, Account__r.Name, Contact_Programme_Coordinator__c, Contact_Head_of_School__c, Language_of_Correspondence_Acct__c, Owner__c, Account_Region__c,Account_Sub_Region__c, Account_IBIS_Code__c, HOSName__c, Programme_Coordinator_Name__c, PcName__c FROM IB_Programme__c WHERE Id IN :relatedIBProgrammeIds]);
                //programmeMap = new Map<Id, IB_Programme__c>([SELECT Id, Account__r.Name, Contact_Programme_Coordinator__c, Contact_Head_of_School__c, Language_of_Correspondence_Acct__c, Owner__c, Account_Region__c, Account_IBIS_Code__c, Programme_Coordinator_Name__c, PcName__c FROM IB_Programme__c WHERE Id IN :relatedIBProgrammeIds]);
            }
            System.debug('ibRolesList===>'+ibRolesList);
            if(!ibRolesList.isEmpty()){
                for(IB_Role__c ibRole : ibRolesList){
                     if(!ibProgrammeVsIBRoleMap.containsKey(ibRole.IB_Programme_New__c)){
                        ibProgrammeVsIBRoleMap.put(ibRole.IB_Programme_New__c,new Map<String, IB_Role__c>());
                    }
                    ibProgrammeVsIBRoleMap.get(ibRole.IB_Programme_New__c).put(ibRole.IB_Role_Name__c,ibRole);
                }
            }
            System.debug('ibProgrammeVsIBRoleMap===>'+ibProgrammeVsIBRoleMap);
            System.debug('myAssignmentsList===>'+myAssignmentsList);
            if(!myAssignmentsList.isEmpty()){
                for(My_Staffing_Event__c myAssignment : myAssignmentsList){
                    if(!ibEventVsMyAssignmentMap.containsKey(myAssignment.IB_Event__c)){
                        ibEventVsMyAssignmentMap.put(myAssignment.IB_Event__c,new Map<String, My_Staffing_Event__c>());
                    }
                    ibEventVsMyAssignmentMap.get(myAssignment.IB_Event__c).put(myAssignment.IB_Role_Name__c,myAssignment);
                }
            }
            
            System.debug('ibEventVsMyAssignmentMap===>'+ibEventVsMyAssignmentMap);
            //Set<Id> contactIds = new Set<Id>();
            Set<Id> programmeOwnerIds = new Set<Id>();
            for (IB_Programme__c programme : programmeMap.values()) {
                /*if(programme.Contact_Programme_Coordinator__c != null){
                    contactIds.add(programme.Contact_Programme_Coordinator__c);
                }
                if(programme.Contact_Head_of_School__c != null){
                    contactIds.add(programme.Contact_Head_of_School__c);
                }*/
                programmeOwnerIds.add(programme.Owner__c);
            }
            //Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Id IN :contactIds]);
            Map<Id, User> programmeRelationShipManagerMap = new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN :programmeOwnerIds]);
            
            Set<Id> ownerIds = new Set<Id>();
            for (String idValue : newMap.keySet()) {
                ownerIds.add(newMap.get(idValue).OwnerId);
            }
            Map<Id, User> ownerMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Id IN :ownerIds]);
            
            Set<String> templateDeveloperNames =new Set<String> { 
                'Custom_VV_schools_confirmation_message_Remote_Eng',
                    'Custom_VV_schools_confirmation_message_Hybrid_Eng',
                    'Custom_VV_schools_confirmation_message_On_site_Eng',
                    'Custom_VV_educator_confirmation_message_Remote_Eng',
                    'Custom_VV_Educators_Confirmation_email_AEM_On_site_Eng',
                    'Custom_VV_Educators_Confirmation_email_AP_On_site_Eng',
                    'Custom_VV_Educators_Confirmation_LATIN_AMERICA_THE_CARIBBEAN_On_site_Eng',
                    'Custom_VV_Educators_Confirmation_email_NORTHERN_AMERICA_On_site_Eng',
                    'Custom_VV_schools_confirmation_message_Remote_French',
                    'Custom_VV_schools_confirmation_message_Hybrid_French',
                    'Custom_VV_schools_confirmation_message_On_site_French',
                    'Custom_VV_educator_confirmation_message_Remote_French',
                    'Custom_VV_Educators_Confirmation_email_AEM_On_site_French',
                    'Custom_VV_Educators_Confirmation_email_AP_On_site_French',
                    'Custom_VV_Educators_Confirmation_LATIN_AMERICA_THE_CARIBBEAN_On_site_French',
                    'Custom_VV_Educators_Confirmation_email_NORTHERN_AMERICA_On_site_French',
                    'Custom_VV_schools_confirmation_message_Remote_Spanish',
                    'Custom_VV_schools_confirmation_message_Hybrid_Spanish',
                    'Custom_VV_schools_confirmation_message_On_site_Spanish',
                    'Custom_VV_educator_confirmation_message_Remote_Spanish',
                    'Custom_VV_Educators_Confirmation_email_AEM_On_site_Spanish',
                    'Custom_VV_Educators_Confirmation_email_AP_On_site_Spanish',
                    'Custom_VV_Educators_Confirmation_LATIN_AMERICA_THE_CARIBBEAN_On_site_Spanish',
                    'Custom_VV_Educators_Confirmation_email_NORTHERN_AMERICA_On_site_Spanish' 
                    };
                        
            Map<String, EmailTemplate> templateMap = new Map<String, EmailTemplate>();
            List<EmailTemplate> emailTemplatesList = new List<EmailTemplate>();
            if (!templateDeveloperNames.isEmpty()) {
                emailTemplatesList = [SELECT Id, Body, HtmlValue,DeveloperName FROM EmailTemplate WHERE DeveloperName IN :templateDeveloperNames];
            }
            for(EmailTemplate empTemp : emailTemplatesList){
                templateMap.put(empTemp.DeveloperName,empTemp);
            }
            System.debug('templateMap===>'+templateMap);
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'schooldelivery@ibo.org'];
            
            // Define a list to hold the emails to be sent
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
            //code added by Prerna on 15-04-2024 for ECM00508 --STARTS--
            List<task> taskToCreate = new List<task>();
            //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
            for (String idValue : filteredCampaigns) {
                final Campaign oldVal = oldMap.get(idValue);
                final Campaign newVal = newMap.get(idValue);
                if (newMap.get(idValue).Related_IB_Programme__c != null && programmeMap.containsKey(newMap.get(idValue).Related_IB_Programme__c)) {
                    IB_Programme__c programme = programmeMap.get(newMap.get(idValue).Related_IB_Programme__c);
                    
                    //below code modified by Prerna on 03-05-2024 since we have different subjects for school and educator templates
                    String schoolSubject;
                    String educatorSubject;
                    String tmpName = '';
                    String secondTmpName = '';
                    
                    Map<String, String> emailSubjectTemplateInformation = new Map<String, String>();
                    
                    // English
                    if (programme.Language_of_Correspondence_Acct__c == 'English') {
                        emailSubjectTemplateInformation = getEmailSubjectAndTemplates(programme, newMap, 'Eng', idValue);
                    }
                    // French
                    if (programme.Language_of_Correspondence_Acct__c == 'French') {
                        emailSubjectTemplateInformation = getEmailSubjectAndTemplates(programme, newMap, 'French', idValue);
                    }
                    // Spanish
                    if (programme.Language_of_Correspondence_Acct__c == 'Spanish') {
                        emailSubjectTemplateInformation = getEmailSubjectAndTemplates(programme, newMap, 'Spanish', idValue);
                    }
                    System.debug('emailSubjectTemplateInformation====>'+emailSubjectTemplateInformation);
                    // Assigning email subject, template name, and second template name.
                    if(emailSubjectTemplateInformation.size() > 0){
                        //below code modified by Prerna on 03-05-2024
                        schoolSubject = emailSubjectTemplateInformation.get('schoolSubject');
                        educatorSubject = emailSubjectTemplateInformation.get('educatorSubject');
                        tmpName = emailSubjectTemplateInformation.get('tmpName');
                        secondTmpName = emailSubjectTemplateInformation.get('secondTmpName');
                    }
                    System.debug('schoolSubject====>'+schoolSubject);
                    System.debug('educatorSubject====>'+educatorSubject);
                    System.debug('tmpName====>'+tmpName);
                    System.debug('secondTmpName====>'+secondTmpName);
                    
                    //Contact contactCoordinator = contactMap.get(programme.Contact_Programme_Coordinator__c);
                    //Contact contactHOS = contactMap.get(programme.Contact_Head_of_School__c);
                    EmailTemplate schoolTemplate = templateMap.get(tmpName);
                    EmailTemplate educatorTemplate = templateMap.get(secondTmpName);
                    System.debug('schoolTemplate===>'+schoolTemplate);
                    System.debug('educatorTemplate===>'+educatorTemplate);
                    User programmeRelationShipManager = programmeRelationShipManagerMap.get(programme.Owner__c);
                    User ibEventOwner = ownerMap.get(newVal.OwnerId);
                    
                    String teamLeaderContactName;
                    String teamLeaderContactEmail;
                    String teamMemberContactName;
                    String teamMemberContactEmail;
                    
                    if(ibEventVsMyAssignmentMap.containsKey(idValue)){
                        if(ibEventVsMyAssignmentMap.get(idValue).containsKey('School Visit Team Leader')){
                            if(ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Leader') != null){
                                teamLeaderContactName = ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Leader').IB_Contact__r != null ? ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Leader').IB_Contact__r.Name : null;
                                teamLeaderContactEmail = ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Leader').IB_Contact__r != null ? ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Leader').IB_Contact__r.Email : null;
                            }
                        }
                        if(ibEventVsMyAssignmentMap.get(idValue).containsKey('School Visit Team Member')){
                            if(ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Member') != null){
                                teamMemberContactName = ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Member').IB_Contact__r != null ? ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Member').IB_Contact__r.Name : null;
                                teamMemberContactEmail = ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Member').IB_Contact__r != null ? ibEventVsMyAssignmentMap.get(idValue).get('School Visit Team Member').IB_Contact__r.Email : null;
                            }
                        }
                    }
                    System.debug('teamLeaderContactName===>'+teamLeaderContactName +'teamLeaderContactEmail===>'+teamLeaderContactEmail);
                    System.debug('teamMemberContactName===>'+teamMemberContactName +'teamMemberContactEmail===>'+teamMemberContactEmail);
                    
                    String hosName,hosEmail,pcName,pcEmail;
                    if(ibProgrammeVsIBRoleMap.containsKey(newMap.get(idValue).Related_IB_Programme__c)){
                        if(ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).containsKey('Head of School')){
                            if(ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Head of School') != null){
                                hosName = ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Head of School').IB_Contact__r != null ? ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Head of School').IB_Contact__r.Name : null;
                                hosEmail = ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Head of School').IB_Contact__r != null ? ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Head of School').IB_Contact__r.Email : null;
                            }
                        }
                        if(ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).containsKey('Programme Coordinator')){
                            if(ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Programme Coordinator') != null){
                                pcName = ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Programme Coordinator').IB_Contact__r != null ? ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Programme Coordinator').IB_Contact__r.Name : null;
                                pcEmail = ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Programme Coordinator').IB_Contact__r != null ? ibProgrammeVsIBRoleMap.get(newMap.get(idValue).Related_IB_Programme__c).get('Programme Coordinator').IB_Contact__r.Email : null;
                            }
                        }
                    }
                    System.debug('hosName===>'+hosName +'hosEmail===>'+hosEmail);
                    System.debug('pcName===>'+pcName +'pcEmail===>'+pcEmail);
                    
                    
                    
                    List<String> emailAddresses = new List<String>();
                    if (!String.isBlank(teamLeaderContactEmail) || !String.isBlank(teamMemberContactEmail)) {
                        if (!String.isBlank(teamLeaderContactEmail) && teamLeaderContactEmail.contains('@')) {
                            emailAddresses.add(teamLeaderContactEmail);
                        }
                        
                        if (!String.isBlank(teamMemberContactEmail) && teamMemberContactEmail.contains('@')) {
                            emailAddresses.add(teamMemberContactEmail);
                        }
                    }
                    System.debug('emailAddresses===>'+emailAddresses);
                    
                    List<String> schoolEmailAddress = new List<String>();
                    if (!String.isBlank(hosEmail) || !String.isBlank(pcEmail)) {
                        if (!String.isBlank(hosEmail) && hosEmail.contains('@')) {
                            schoolEmailAddress.add(hosEmail);
                        }
                        
                        if (!String.isBlank(pcEmail) && pcEmail.contains('@')) {
                            schoolEmailAddress.add(pcEmail);
                        }
                    }
                     System.debug('schoolEmailAddress===>'+schoolEmailAddress);
                     System.debug('pcEmail===>'+pcEmail);
                     System.debug('hosEmail===>'+hosEmail);
                     System.debug('programmeRelationShipManager===>'+programmeRelationShipManager);
                    //if (contactCoordinator != null && contactHOS != null && schoolTemplate != null && programmeRelationShipManager != null && teamLeaderContactName!= null && teamLeaderContactEmail != null && teamMemberContactName != null && teamMemberContactEmail != null) {
                    if ((pcEmail != null || hosEmail != null) && programmeRelationShipManager != null ) {
                        
                        System.debug('ITS SUCCESS===>');
                        String templateBody;
                        String templateBody2;
                        if(schoolTemplate.HtmlValue != null){
                            templateBody = schoolTemplate.HtmlValue;
                        }
                        if(educatorTemplate != null){
                            templateBody2 = educatorTemplate.HtmlValue;
                        }
                        
                        if(templateBody != null){
                            templateBody = templateBody.replace('{IBEventName}', String.valueOf(newMap.get(idValue).Name))
                                //below 2 lines modified by Prerna on 12-04-2024 for date formatting of StartDate and EndDate
                                .replace('{StartDate}', formatDate(newMap.get(idValue).StartDate))
                                .replace('{EndDate}', formatDate(newMap.get(idValue).EndDate))
                                .replace('{IB Event Owner}', ibEventOwner.Name)
                                .replace(']]>', '');
                            if(templateBody.contains('{Head_of_School_Name}') && hosName != null){
                                templateBody = templateBody.replace('{Head_of_School_Name}', hosName);
                            }
                            if(templateBody.contains('{Head_of_School_Name}') && hosName == null){
                                if (programme.Language_of_Correspondence_Acct__c == 'English') {
                                    templateBody = templateBody.replace('{Head_of_School_Name} and','');
                                }
                                if (programme.Language_of_Correspondence_Acct__c == 'French') {
                                    templateBody = templateBody.replace('{Head_of_School_Name} et','');
                                }
                                if (programme.Language_of_Correspondence_Acct__c == 'Spanish') {
                                    templateBody = templateBody.replace('{Head_of_School_Name} y','');
                                }
                            }
                            if(templateBody.contains('{Programme_Coordinator_Name}') && pcName != null){
                                templateBody = templateBody.replace('{Programme_Coordinator_Name}', pcName);
                            }
                            if(templateBody.contains('{Programme_Coordinator_Name}') && pcName == null){
                                
                                if (programme.Language_of_Correspondence_Acct__c == 'English') {
                                    templateBody = templateBody.replace('and {Programme_Coordinator_Name}', '');
                                }
                                if (programme.Language_of_Correspondence_Acct__c == 'French') {
                                    templateBody = templateBody.replace('et {Programme_Coordinator_Name}','');
                                }
                                if (programme.Language_of_Correspondence_Acct__c == 'Spanish') {
                                    templateBody = templateBody.replace('y {Programme_Coordinator_Name}','');
                                }
                            }
                            if(templateBody.contains('{PrmName}') && programmeRelationShipManager.Name != null){
                                templateBody = templateBody.replace('{PrmName}', programmeRelationShipManager.Name);
                            }
                            if(templateBody.contains('{PrmEmail}') && programmeRelationShipManager.Email != null){
                                templateBody = templateBody.replace('{PrmEmail}', programmeRelationShipManager.Email);
                            }
                            if(templateBody.contains('{LeaderName}') && teamLeaderContactName != null){
                                templateBody = templateBody.replace('{LeaderName}', teamLeaderContactName);
                            }
                            if(templateBody.contains('{LeaderName}') && teamLeaderContactName == null){
                                templateBody = templateBody.replace('{LeaderName}', '');
                            }
                            if(templateBody.contains('{LeaderEmail}') && teamLeaderContactEmail != null){
                                templateBody = templateBody.replace('{LeaderEmail}', teamLeaderContactEmail);
                            }
                            if(templateBody.contains('{LeaderEmail}') && teamLeaderContactEmail == null){
                                templateBody = templateBody.replace('{LeaderEmail}', '');
                            }
                            if(templateBody.contains('{MemberName}') && teamMemberContactName != null){
                                templateBody = templateBody.replace('{MemberName}', teamMemberContactName);
                            }
                            if(templateBody.contains('{MemberName}') && teamMemberContactName == null){
                                templateBody = templateBody.replace('{MemberName}', '');
                            }
                            if(templateBody.contains('{MemberEmail}') && teamMemberContactEmail != null){
                                templateBody = templateBody.replace('{MemberEmail}', teamMemberContactEmail);
                            }
                            if(templateBody.contains('{MemberEmail}') && teamMemberContactEmail == null){
                                templateBody = templateBody.replace('{MemberEmail}', '');
                            }
                        }
                        if(templateBody2 != null){
                            System.debug('templateBody2 is not null==>'+templateBody2);
                            System.debug('PRM name==>'+programmeRelationShipManager.Name);
                            System.debug('Email==>'+programmeRelationShipManager.Email);
                            templateBody2 = templateBody2.replace('{IBEventName}', String.valueOf(newMap.get(idValue).Name))
                                //below 2 lines modified by Prerna on 12-04-2024 for date formatting of StartDate and EndDate
                                .replace('{StartDate}', formatDate(newMap.get(idValue).StartDate))
                                .replace('{EndDate}', formatDate(newMap.get(idValue).EndDate))
                                .replace('{IB Event Owner}', ibEventOwner.Name)
                                .replace(']]>', '');
                            
                            if(templateBody2.contains('{VerificationVisitReportDueDate}') && newMap.get(idValue).Report_Due_Date__c != null){
                                templateBody2 = templateBody2.replace('{VerificationVisitReportDueDate}', formatDate(newMap.get(idValue).Report_Due_Date__c));
                            }
                            if(templateBody2.contains('{PrmName}') && programmeRelationShipManager.Name != null){
                                templateBody2 = templateBody2.replace('{PrmName}', programmeRelationShipManager.Name);
                            }
                            if(templateBody2.contains('{PrmEmail}') && programmeRelationShipManager.Email != null){
                                templateBody2 = templateBody2.replace('{PrmEmail}', programmeRelationShipManager.Email);
                            }
                            if(templateBody2.contains('{VenueAccount}') && newMap.get(idValue).Venue_Account_Name__c != null){
                                templateBody2 = templateBody2.replace('{VenueAccount}', String.valueOf(newMap.get(idValue).Venue_Account_Name__c));
                            }
                            if(templateBody2.contains('{VenueCity}') && newMap.get(idValue).Workshop_Event_City__c != null){
                                templateBody2 = templateBody2.replace('{VenueCity}', String.valueOf(newMap.get(idValue).Workshop_Event_City__c));
                            }
                            if(templateBody2.contains('{VenueCountry}') && newMap.get(idValue).Workshop_Event_Country__c != null){
                                templateBody2 = templateBody2.replace('{VenueCountry}', String.valueOf(newMap.get(idValue).Workshop_Event_Country__c));
                            }
                            if(templateBody2.contains('{LeaderName}') && teamLeaderContactName != null){
                                templateBody2 = templateBody2.replace('{LeaderName}', teamLeaderContactName);
                            }
                            if(templateBody2.contains('{LeaderName}') && teamLeaderContactName == null){
                                templateBody2 = templateBody2.replace('{LeaderName}', '');
                            }
                            if(templateBody2.contains('{LeaderEmail}') && teamLeaderContactEmail != null){
                                templateBody2 = templateBody2.replace('{LeaderEmail}', teamLeaderContactEmail);
                            }
                            if(templateBody2.contains('{LeaderEmail}') && teamLeaderContactEmail == null){
                                templateBody2 = templateBody2.replace('{LeaderEmail}', '');
                            }
                            if(templateBody2.contains('{MemberName}') && teamMemberContactName != null){
                                templateBody2 = templateBody2.replace('{MemberName}', teamMemberContactName);
                            }
                            if(templateBody2.contains('{MemberName}') && teamMemberContactName == null){
                                templateBody2 = templateBody2.replace('{MemberName}', '');
                            }
                            if(templateBody2.contains('{MemberEmail}') && teamMemberContactEmail != null){
                                templateBody2 = templateBody2.replace('{MemberEmail}', teamMemberContactEmail);
                            }
                            if(templateBody2.contains('{MemberEmail}') && teamMemberContactEmail == null){
                                templateBody2 = templateBody2.replace('{MemberEmail}', '');
                            }
                        }
                        if(schoolTemplate != null){
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            if (owea.size() > 0) {
                                mail.setOrgWideEmailAddressId(owea[0].Id);
                            }
                            //below code modified by Prerna on 03-05-2024 
                            mail.setSubject(schoolSubject);
                            mail.setHtmlBody(templateBody);
                            mail.setTemplateId(schoolTemplate.Id);
                            mail.setWhatId(programme.Id);
                            if(!schoolEmailAddress.isEmpty()){
                                mail.setToAddresses(schoolEmailAddress);  
                            //below code modified by Prerna on 12-04-2024
                            //because as per new requirement we need to send a copy of school template to School Visit Team Member and School Visit Team Leader along with PRM 
                            List<String> ccEmails = new List<String>{programmeRelationShipManager.Email};
                            if (!emailAddresses.isEmpty()) {
                                ccEmails.addAll(emailAddresses);
                            }
                            mail.setCcAddresses(ccEmails);
                            mail.setUseSignature(false);
                            emailsToSend.add(mail);
                            System.debug('emailsToSend in school temp===>'+emailsToSend);
                            
                            //code added by Prerna on 15-04-2024 for ECM00508 --STARTS--
                            //because we want to track emails sent on that perticular event
                            
                            Task task = new Task();
                            //below code modified by Prerna on 03-05-2024 
                            task.Subject = schoolSubject;
                            // Remove HTML tags from the templateBody
                            String sanitizedDescription = templateBody.replaceAll('<[^>]*>', '')
                                                                      .replaceAll('&nbsp;', ' ')
                                                                      .trim();
                            task.Description = sanitizedDescription;
                            //task.WhoId = contact_coordinator[0].Id; 
                            task.WhatId = idValue; 
                            task.Priority = 'Normal';
                            task.Status = 'Completed';
                            task.ActivityDate = Date.today();
                            task.Type = 'Email';
                            taskToCreate.add(task);
                            //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
                        }
                        }
                        System.debug('emailAddresses before eductor====>'+emailAddresses);
                        if(educatorTemplate != null){
                            Messaging.SingleEmailMessage educatorEmail = new Messaging.SingleEmailMessage();
                            if (owea.size() > 0) {
                                educatorEmail.setOrgWideEmailAddressId(owea[0].Id);
                            }
                            //below code modified by Prerna on 03-05-2024 
                            educatorEmail.setSubject(educatorSubject);
                            educatorEmail.setHtmlBody(templateBody2);
                            educatorEmail.setTemplateId(educatorTemplate.Id);
                            educatorEmail.setWhatId(programme.Id);
                            //educatorEmail.setToAddresses(new List<String>{teamLeaderContactEmail,teamMemberContactEmail});
                            if(!emailAddresses.isEmpty()){
                            educatorEmail.setToAddresses(emailAddresses);
                            
                            educatorEmail.setCcAddresses(new List<String>{programmeRelationShipManager.Email});
                            educatorEmail.setUseSignature(false);
                            emailsToSend.add(educatorEmail);
                            System.debug('emailsToSend in educator temp===>'+emailsToSend);
                            //code added by Prerna on 15-04-2024 for ECM00508 --STARTS--
                            //because we want to track emails sent on that perticular event
                            Task task = new Task();
                            //below code done by Prerna on 03-05-2024 
                            task.Subject = educatorSubject;
                            // Remove HTML tags from the templateBody
                            String sanitizedDescription = templateBody2.replaceAll('<[^>]*>', '')
                                                                      .replaceAll('&nbsp;', ' ')
                                                                      .trim();
                            task.Description = sanitizedDescription;
                            //task.WhoId = contact_coordinator[0].Id; 
                            task.WhatId = idValue; 
                            task.Priority = 'Normal';
                            task.Status = 'Completed';
                            task.ActivityDate = Date.today();
                            task.Type = 'Email';
                            taskToCreate.add(task);
                            }
                            //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
                            
                        }
                        Campaign campaign = new Campaign(Id = newVal.Id);
                        campaign.Event_Confirmed__c = 'Confirmed';
                        campaignListToUpdate.add(campaign);
                    }
                }
            }
            // Send all the emails after the loop
            if (!emailsToSend.isEmpty()) {
                System.debug('emailsToSend===>'+emailsToSend);
                Messaging.SendEmailResult[] result = Messaging.sendEmail(emailsToSend);
                for(Messaging.SendEmailResult emailResult : result) {
                    if (emailResult.isSuccess()) {
                        System.debug('Email sent successfully');
                    } else {
                        System.debug('Failed to send email:' + emailResult.getErrors()[0].getMessage());
                    }
                }
                System.debug('campaignListToUpdate===>'+campaignListToUpdate);
                if (!campaignListToUpdate.isEmpty()) {
                Database.update(campaignListToUpdate);
                System.debug('campaignListToUpdate after update===>'+campaignListToUpdate);
            }
            //code added by Prerna on 15-04-2024 for ECM00508 --STARTS--
                System.debug('taskToCreate===>'+taskToCreate);
                if(!taskToCreate.isEmpty()){
                    Database.insert(taskToCreate);
            }
            //code added by Prerna on 15-04-2024 for ECM00508 --ENDS--
        }
    }
    }
    // Method to get email subject and email templates
    public static Map<String, String> getEmailSubjectAndTemplates(IB_Programme__c programme, Map<Id, Campaign> newMap, String language, String idValue){

        Map<String, String> emailSubjectAndTemplate = new Map<String, String>();
    
        // Assign email subject 
        //below lines modified by Prerna on 12-04-2024 to maintain the consistency of Delivery Mode infront
        switch on language{
            when 'Eng'{
                //below if conditions added by Prerna on 03-05-2024 since now we have different subjects for School and Educator Templates.
                if (newMap.get(idValue).Delivery_Mode__c == 'On-site') {
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' School Confirmation Verification visit ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Visiting team Confirmation Verification visit ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
                if(newMap.get(idValue).Delivery_Mode__c == 'Remote'){
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmation Verification visit ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Visiting team Confirmation Verification visit ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
                if (newMap.get(idValue).Delivery_Mode__c == 'Hybrid') {
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmation Verification visit ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
            }
            when 'Spanish'{
                //below if conditions added by Prerna on 03-05-2024 since now we have different subjects for School and Educator Templates.
                if (newMap.get(idValue).Delivery_Mode__c == 'On-site') {
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Colegio - Confirmación de visita de verificación en el ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    if(programme.Account_Sub_Region__c == 'Latin America'|| programme.Account_Sub_Region__c == 'The Caribbean' || programme.Account_Sub_Region__c == 'Northern America'){
                        emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipo visitante: Confirmación de la visita de verificación en el ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    }
                    else{
                        emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipo visitante: Confirmación de visita de verificación en el ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    }
                } 
                if(newMap.get(idValue).Delivery_Mode__c == 'Remote'){
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmación de visita de verificación ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipo visitante: Confirmación de la visita de verificación en el ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
                if(newMap.get(idValue).Delivery_Mode__c == 'Hybrid'){
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmación de visita de verificación ' + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
            }
            when 'French'{
                //below if conditions added by Prerna on 03-05-2024 since now we have different subjects for School and Educator Templates.
                if (newMap.get(idValue).Delivery_Mode__c == 'On-site') {
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' École : Confirmation de visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    if(programme.Account_Sub_Region__c == 'Latin America'|| programme.Account_Sub_Region__c == 'The Caribbean'){
                        emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipe de la visite : Confirmation de la visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    }
                    else{
                        emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipe visitant : Confirmation de visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    }
                }
                if (newMap.get(idValue).Delivery_Mode__c == 'Remote') {
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmation de visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                    emailSubjectAndTemplate.put('educatorSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Equipe visitant : Confirmation de visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
                if(newMap.get(idValue).Delivery_Mode__c == 'Hybrid'){
                    emailSubjectAndTemplate.put('schoolSubject', programme.Account_Region__c + ': ' + newMap.get(idValue).Delivery_Mode__c+ ' Confirmation de visite de vérification '  + ' – ' + programme.Account__r.Name + ' ' + programme.Account_IBIS_Code__c + '\n');
                }
            }
        }
    
        // Assign email template and second email template
        if (newMap.get(idValue).Delivery_Mode__c == 'Remote') {
            emailSubjectAndTemplate.put('tmpName', 'Custom_VV_schools_confirmation_message_Remote_' + language);
            emailSubjectAndTemplate.put('secondTmpName','Custom_VV_educator_confirmation_message_Remote_' + language);
        } 
        if (newMap.get(idValue).Delivery_Mode__c == 'Hybrid') {
            emailSubjectAndTemplate.put('tmpName', 'Custom_VV_schools_confirmation_message_Hybrid_' + language);
        } 
        if (newMap.get(idValue).Delivery_Mode__c == 'On-site') {
            emailSubjectAndTemplate.put('tmpName', 'Custom_VV_schools_confirmation_message_On_site_' + language);
            //tmpName = 'VV_schools_confirmation_message_On_site' + language;
            if (newMap.get(idValue).Workshop_Event_Region__c == 'IBAEM' && (newMap.get(idValue).Workshop_Event_Sub_Region__c == 'AFRICA' || newMap.get(idValue).Workshop_Event_Sub_Region__c == 'EUROPE' || newMap.get(idValue).Workshop_Event_Sub_Region__c == 'MIDDLE EAST')) {
                emailSubjectAndTemplate.put('secondTmpName', 'Custom_VV_Educators_Confirmation_email_AEM_On_site_' + language);
            }
            else if (newMap.get(idValue).Workshop_Event_Region__c == 'IBAP' && (newMap.get(idValue).Workshop_Event_Sub_Region__c == 'ASIA'|| newMap.get(idValue).Workshop_Event_Sub_Region__c == 'OCEANIA' || newMap.get(idValue).Workshop_Event_Sub_Region__c == 'SOUTH ASIA' || newMap.get(idValue).Workshop_Event_Sub_Region__c == 'SOUTH EAST ASIA' || newMap.get(idValue).Workshop_Event_Sub_Region__c == 'EAST ASIA')) {
                emailSubjectAndTemplate.put('secondTmpName', 'Custom_VV_Educators_Confirmation_email_AP_On_site_' + language);
            }
            else if (newMap.get(idValue).Workshop_Event_Region__c == 'IBA' && (newMap.get(idValue).Workshop_Event_Sub_Region__c == 'LATIN AMERICA' || newMap.get(idValue).Workshop_Event_Sub_Region__c ==  'THE CARIBBEAN')) {
                emailSubjectAndTemplate.put('secondTmpName', 'Custom_VV_Educators_Confirmation_LATIN_AMERICA_THE_CARIBBEAN_On_site_' + language);
            }
            else if (newMap.get(idValue).Workshop_Event_Region__c == 'IBA' && newMap.get(idValue).Workshop_Event_Sub_Region__c == 'NORTHERN AMERICA') {
                emailSubjectAndTemplate.put('secondTmpName', 'Custom_VV_Educators_Confirmation_email_NORTHERN_AMERICA_On_site_' + language);
            }
        }
        return emailSubjectAndTemplate;
    }
    // below method writtened by Prerna for Date Formatting on 12-04-2024 for ECM00508
    public static String formatDate(Date dateValue) {
        String formattedDate = String.valueOf(dateValue.month()) + '/' + String.valueOf(dateValue.day()) + '/' + String.valueOf(dateValue.year());
        formattedDate = formattedDate.replaceAll('(^|/)0', '$1');
        return formattedDate;
    }
    //This Part of Code is being updated by Ammara-Plumlogix,as Part od CR-685 on 3/25/2020
    //Begin
    @future
    public static void Send_Email(set<String> usr_emails,String Application_deadline,String Language) {
        System.debug('Sending Email');
        System.debug('Test: '+Application_deadline);
        try {
            
            ID Org_wide_id;
              OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'ibcommunities.noreply@ibo.org'];
                            if ( owea.size() > 0 ) {
                                Org_wide_id = owea.get(0).Id;
                            }//End
            List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
          for(String usr_email : usr_emails){
              String []email= new string[]{usr_email};
                  System.debug('Email: '+email);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(Org_wide_id);
                mail.setToAddresses(email);
              if(Language == 'English'){
                mail.setSubject('Training opportunity in the IBEN has been published');
                mail.setPlainTextBody('Dear Educator:'+'\n'+'Thank you for your interest in joining the IB Educator Network.A training opportunity is now open for the role in which you’ve shown interest. Please log into My IB and submit your application to the training event on the IB roles page. Your application will be reviewed after the application deadline,'+Application_deadline+'.'+'\n'+'Best,'+'\n'+'The IBEN Team'+'\n'+'---');
              }
              else if(Language == 'Spanish'){
                  mail.setSubject(' Oportunidades de desarrollo profesional en IBEN'); 
                  mail.setPlainTextBody('Estimado(a) educador(a):'+'\n'+'Agradecemos su interés en sumarse a la Red de educadores del IB. En IBEN Central están publicadas oportunidades de desarrollo profesional que se ajustan a la función para la cual ha presentado solicitud. Debe iniciar sesión en IBEN Central y solicitar un evento de capacitación para que su solicitud pueda ser considerada.  '+Application_deadline+'.'+'\n'+
                  'Muchas gracias,'+'\n'+'El equipo de IBEN'+'\n'+'---');             
              }  else if(Language == 'French'){
                   mail.setPlainTextBody('Madame, Monsieur,'+'\n'+
 'Nous vous remercions de l’intérêt que vous portez au réseau de collaborateurs de l’IB (IBEN). Des formations correspondant au rôle auquel vous avez postulé sont à présent disponibles sur la plateforme IBEN Central. Votre candidature ne sera étudiée qu’à condition que vous vous connectiez sur IBEN Central pour postuler à l’une de ces formations.'
       +Application_deadline+'.'+'\n'+
 'Salutations distinguées,'+'\n'+'L’équipe du réseau de collaborateurs de l’IB'+'\n'+'---');
                  mail.setSubject(' À l’attention des professionnels de l’éducation');
                  
              }//add all email objects in list          
                allmsg.add(mail);
                
            }
            //sending emails
            System.debug('All Email Messages added');
            Messaging.sendEmail(allmsg);
            System.debug('Email Send');
        }
        catch (Exception ex) {
            System.debug('Error Send Email'+ ex);
        }
         }
         //END
    public void updateCampaignOwner(List<Campaign> newRecs, map<Id,Campaign> oldRecsMap){
        Id authorizationRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Authorization').getRecordTypeId();
        Id evaluationRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Evaluation').getRecordTypeId();
        Id parentReaderRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('IBEN Parent Reader Event').getRecordTypeId();

        Set<Id> venueAccountIds = new Set<Id>();
        for(Campaign c:newRecs){
            if((c.RecordTypeId == authorizationRT || c.RecordTypeId == evaluationRT || c.RecordTypeId == parentReaderRT) && c.Venue_Account__c != null){
                if((oldRecsMap != null && c.Venue_Account__c != oldRecsMap.get(c.Id).Venue_Account__c) || oldRecsMap == null){
                    venueAccountIds.add(c.Venue_Account__c);
                } 
            }
        }

        if(venueAccountIds.size() > 0){
            Map<Id,Account> venueAccountIdMap = new Map<Id,Account>([SELECT Id, Region__c FROM Account WHERE Id in :venueAccountIds]);

            Default_Account_Owner__mdt[] defAccountOwner = [SELECT MasterLabel, User_ID__c FROM Default_Account_Owner__mdt];

            Map<String,Id> defAccountOwnerMap = new Map<String,Id>();

            for(Default_Account_Owner__mdt a:defAccountOwner){
                defAccountOwnerMap.put(a.MasterLabel,Id.valueOf(a.User_ID__c));
            }

            for(Campaign c:newRecs){
                if((c.RecordTypeId == authorizationRT || c.RecordTypeId == evaluationRT || c.RecordTypeId == parentReaderRT) && c.Venue_Account__c != null){
                    if(c.OwnerId != defAccountOwnerMap.get(venueAccountIdMap.get(c.Venue_Account__c).Region__c)){
                        c.OwnerId = defAccountOwnerMap.get(venueAccountIdMap.get(c.Venue_Account__c).Region__c);
                    }
                }
            }
        }
    }
    
    public static boolean isAlreadyExecuted = false;
    public static List<IB_Role_Repository__c > allRolesList;
    public static void updateCampaignStatus(list<Campaign> newRecs, map<Id,Campaign> oldRecsMap){
      /** Added as part of 754 phase 2**/
        
                List<IB_Event_Role__c> eventRolesRecords= new List<IB_Event_Role__c>();
                List<String> rolesList= new List<String>();
                rolesList.add('Evaluation Facilitator');
                rolesList.add('Preliminary Review Chair');
                
                Map<String,IB_Role_Repository__c > roleMap= new Map<String,IB_Role_Repository__c >();
        		if(allRolesList==null){//INC0222214 Ben McGarvey, changing the soql query to one time run being held in a static variable to reduce soql queries.
            		allRolesList=[Select id,name,Role_Name__c from IB_Role_Repository__c];
        		}
                //List<IB_Role_Repository__c > rolesRepositoryListRecords=[select id,name,Role_Name__c from IB_Role_Repository__c where Role_Name__c in: rolesList]
				for(IB_Role_Repository__c roleRepo: allRolesList){
                    if(rolesList.contains(roleRepo.Role_Name__c)){
                    	roleMap.put(roleRepo.Role_Name__c,roleRepo );
                    }
                }
                system.debug('roleMap***'+roleMap);
               
                for(Campaign c : newRecs )
                {
                    if(c.Status == 'Planned / Ready for Staffing' && c.IB_Event_Record_Type__c == 'Evaluation' && c.ParentId == null && c.Sub_Type__c=='Multiple Programme Evaluation Visit' && c.Programme_Combination_Evaluation_Visits__c == 'IB only - Affiliated')
                    {
                        
                        for(STring s: rolesList){
                            IB_Event_Role__c eventRole= new IB_Event_Role__c();
                            eventRole.IB_Event__c= c.id; eventRole.IB_Role__c=roleMap.get(s).Id;
                            eventRole.Number_of_Required_Educators__c=1; eventRole.IB_Programme__c='Continuum (PYP+MYP+DP+CP)';
                            eventRole.Proposed_Language__c=c.Event_Language__c; eventRole.Delivery_Mode__c=c.Delivery_Mode__c; 
                            eventRolesRecords.add(eventRole);
                            system.debug('eventRolesRecords***'+eventRolesRecords);
                            system.debug('roleMap***'+roleMap.get(s).Id);
                        }
                        
                    }  
                    
                }
        
         List<IB_Event_Role__c> roleList=[select id ,IB_Role_Name__c from IB_Event_Role__c where IB_Role_Name__c in : rolesList 
                                             and IB_Event__c in : oldRecsMap.keyset()];
        
        if( roleList.size()==0){//StaffingEventTriggerHandler.isAlreadyExecuted == false ||
           
            
                insert eventRolesRecords;
            
        }
           
                /** Added as part of 754 phase 2**/
        //isAlreadyExecuted = true;
        
        Map<Id,Campaign> cmpMap = new Map<Id,Campaign>();
        List<Campaign> cmpUpdates = new List<Campaign>();
        list<My_Staffing_Event__c> myAssignments = new list<My_Staffing_Event__c>();
        
        set<id>parentId = new set<id>();
        
        //string parentRecTypeId = [Select id from RecordType where Name = 'IBEN Parent Reader Event' limit 1].Id;
        string parentRecTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('IBEN Parent Reader Event').getRecordTypeId();
        system.debug('parentRecTypeId: ' + parentRecTypeId);
        // Find all of the Campaigns whose Status has changed
        for(Campaign newCamp : newRecs){
            Campaign oldCamp = oldRecsMap.get(newCamp.Id);
            // Did the status change?
            if(newCamp.status != oldCamp.Status){
                // Add the campaign to the list to be processed
                if(!newCamp.Bundle__c && newCamp.RecordTypeId == parentRecTypeId && (newCamp.Status =='Planned / Ready for Staffing' || newCamp.Status =='Staffed')){
                    cmpMap.put(newCamp.Id,newCamp);
                }
                if(newCamp.Bundle__c && newCamp.Status == 'Complete'){
                    parentId.add(newcamp.parentId);
                }
            }
        }
    
        // Find all child campaigns to update
        if(!cmpMap.isEmpty()){
            for(Campaign childCmp : [select Id, Status, ParentId, bundle__c from Campaign where ParentId IN :cmpMap.keySet()]){
                Campaign parentCmp = cmpMap.get(childCmp.ParentId);      
                if(parentCmp.Status =='Planned / Ready for Staffing' || parentCmp.Status =='Staffed'){
                    if(childCmp.bundle__c == true){
                        childCmp.Status = parentCmp.Status;
                    }
                    childCmp.Confirmed_Number_of_Educators__c = parentCmp.Confirmed_Number_of_Educators__c;
                    cmpUpdates.add(childCmp);
                }
            }
        }
        if(!parentId.isEmpty()){
            map<id,campaign> camMap = new map<id,Campaign>([SELECT id, Name, Status, (SELECT Id FROM ChildCampaigns WHERE Status != 'Complete'), (SELECT id, Application_Status__c from My_Staffing_Events__r) FROM Campaign WHERE id IN : parentId AND Bundle__c = false AND status !='complete']);
            
            for(Campaign parent : camMap.values()){
                if(parent.ChildCampaigns.size() == 0){
                    parent.Status = 'Complete';
                    cmpUpdates.add(parent);
                    for(My_Staffing_Event__c rec : parent.My_Staffing_Events__r){
                        myAssignments.add(new My_Staffing_Event__c(Id=rec.Id,Application_Status__c='Completed'));
                    }
                }
            }
        }
        
        if(!cmpUpdates.isEmpty()){
            update(cmpUpdates);
        }
        if(!myAssignments.isEmpty()){
            update myAssignments;
        }
    }

 public static void RemoveAccountAccess(list<Campaign> newRecs)  {
        list<campaign> camps=[select id,Related_IB_Programme__c from campaign where Type='Authorization' AND(Status='Complete' OR Status='Cancelled' OR Status='Postponed') And Related_IB_Programme__c!=null And id IN:newrecs];
        list<id>progs=new list<id>();
        for(campaign c:camps) {
            progs.add(c.Related_IB_Programme__c);            
        }
        list<IB_Programme__c>  proglist=[select Account__c from IB_Programme__c where id IN:progs ];
        progs.clear();
        for(IB_Programme__c c:proglist) {
            progs.add(c.Account__c);            
        }
        
        list<Account>acc=[select id from account where id IN:progs ]; 
        //    liat<Account> acc=[];
              
        List <my_Staffing_Event__c>mystaffingEvents = new list <my_Staffing_Event__c>();
        mystaffingEvents=[select id,IB_Contact__c,name,Staffing_Event_Organizer__c  from my_Staffing_Event__c where IB_Event__c IN:camps AND Application_status__C='Confirmed' ];
        set<id>con=new set<id>();
       // set<string>AccNames=new set <String>();
        for(my_Staffing_Event__c ev:mystaffingEvents) {
                con.add(ev.IB_Contact__c);
            //  AccNames.add(ev.Staffing_Event_Organizer__c);            
        }       
        list<my_Staffing_Event__c>mystaffingEventsAcc=[select id,IB_Contact__c,name from my_Staffing_Event__c where IB_Contact__c IN:con AND Application_status__C='Confirmed' AND Event_Organizer_Account__c IN:[select id,name from account where id IN:Acc]];
        if(mystaffingEventsAcc!=null)
        {
           delete [select id from accountShare where UserOrGroupId IN:[select id from user where Contactid IN:con] AND RowCause='Manual' AND accountid IN :[select id from account where id IN:Acc]] ;

        }
    } 
        }