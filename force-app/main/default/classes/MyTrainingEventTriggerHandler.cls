public without sharing class MyTrainingEventTriggerHandler {
    public static boolean RAN_FLAG = false;
    // Post Event Feedback Section Case
    public void postEventFeedback(final List<My_Training_Event__c> events , final Map<Id,My_Training_Event__c> oldEvents) {
        System.debug('Post Event Feedback');
        final List <IB_Role__c> roleforUpdate =  new List <IB_Role__c>();
             
        final List <String> trainingsId = new List <String> ();
        final List <String> contactsId = new List <String> ();
        final List<String> ibNotifyEventId = new List<String>();
        
        final Set<String> skipEventsList = new Set<String>();  
        
        for(My_Training_Event__c event : events) {

            final My_Training_Event__c oldTrainEvent = oldEvents.get(event.Id);
            //bypass logic if this is a change in notification status
            //
            if((event.Notify_Of_Status__c == false && oldTrainEvent.Notify_Of_Status__c == true) || (event.Notify_Of_Status__c == true && oldTrainEvent.Notify_Of_Status__c == false)){
              skipEventsList.add(event.id);
              continue;
            } else {
               //This Part is being updated by Ammara-Plumlogix,as part of US-11586 on 06/11/2020
              //Begin
              if ((!String.isEmpty(event.Training_Result__c) || 'Declined for (all) Role Application(s)'.equals(event.Application_Status__c))||
                  (!String.isEmpty(event.Training_outcome_2nd_Role__c) ||'Declined for (all) Role Application(s)'.equals(event.Application_Status__c)))//End 
              {
                  trainingsId.add(event.Training_Event__c);
                  contactsId.add  (event.IB_Contact__c);   
              } else {
                  skipEventsList.add(event.id);
              }
            }
            
        }
        System.debug('trainingsId==='+trainingsId);
        System.debug('contactsId==='+contactsId);
        System.debug('skipEventsList==='+skipEventsList);
        System.debug('events===='+events);
        
        final Map <Id, Training_Event__c> trainingEvents = new Map <Id, Training_Event__c> ([ Select Id, Name, IB_Event__c, IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c From Training_Event__c where id IN :trainingsId ]);
         
        final List <String> rolesId = new List <String> ();
        final List <String> programmsId = new List <String> ();
        
        System.debug('trainingEvents==='+trainingEvents.values());
        for (Training_Event__c event : trainingEvents.values()) {
            
            rolesId.add     (event.IB_Role__c);
            if (!String.isEmpty(event.IB_Role_2__c)) {
                rolesId.add     (event.IB_Role_2__c);
            }
            else if (!String.isEmpty(event.IB_Role_3__c)) {
                rolesId.add     (event.IB_Role_3__c);
            }
            programmsId.add (event.IB_Programme__c);
            
             
        }
        
        final List<IB_Role__c> roles = [ Select i.Role_Level__c,  i.Status__c, i.Title__c, Application_Feedback__c,  i.Referee_2_Title__c, i.Referee_2_Last_Name__c, i.Referee_2_First_Name__c, i.Referee_2_Email__c, i.Referee_1_Last_Name__c, i.Referee_1_First_Name__c, i.Referee_1_Email__c, i.Ref_2_Feedback_Request__c, i.Ref_1_Feedback_Request__c, i.RecordTypeId, i.Programme_Selection__c, i.Programme_Selection_Form__c, i.Motivation__c, 
                                   i.LastModifiedDate, i.LastModifiedById, i.LastActivityDate, i.IsDeleted, i.Declined_Application_Status_Information__c,  i.Id, i.IB_Role__c, i.IB_Role_Category__c, i.IB_Contact__c 
                                   From IB_Role__c i where IB_Role__c IN :rolesId and  IB_Contact__c IN :contactsId and Programme_Selection__c IN :programmsId];
             
        for (My_Training_Event__c event : events) {
            
            if (skipEventsList.contains(event.id) ) {
                continue;   
                            
            }
            
            
            final Training_Event__c trainingEvent = trainingEvents.get(event.Training_Event__c);
                        
            if (null == trainingEvent) {
                
                event.addError(new TriggerException(' Post Event Feedback Case : TrainingEvent was not found My_Training_Event__c ' + event ).getMessage());
                continue;   
                            
            }
            final IB_Role__c role  = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role__c,   roles);
            System.debug('role===='+role);
            final IB_Role__c role2 = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role_2__c, roles);
            System.debug('role2===='+role2);
            final IB_Role__c role3 = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role_3__c, roles);
           System.debug('role3===='+role3); 
           
           System.debug('trainingEvent===='+trainingEvent);
           //System.debug('event===='+event);
           
            /*This Part is being updated by Ammara-Plumlogix as a part of US-11586 on 06/11/2020
            /*Begin*/
            if ('Passed'.equals(event.Training_Result__c)) {
                   if (!String.isEmpty(trainingEvent.IB_Role__c) && role != null) {
                       role.Status__c = 'Confirmed';
                       role.Role_Level__c = event.Role_Level__c;
                       roleforUpdate.add(role);
                   }
            }
            else if ('Declined for (all) Role Application(s)'.equals(event.Application_Status__c) || 
                     ( 'Failed'.equals(event.Training_Result__c) && 'Yes'.equals(event.Declined_for_Further_Trainings__c) ) ) {
                  if (!String.isEmpty(trainingEvent.IB_Role__c) && role != null) {
                       role.Status__c = 'Declined';
                       role.Role_Level__c = event.Role_Level__c;
                       roleforUpdate.add(role);
                      System.debug('******Role Status: '+role.Status__c);

                   }
            }
            if('Passed'.equals(event.Training_outcome_2nd_Role__c)){
                   if (!String.isEmpty(trainingEvent.IB_Role_2__c) && role2 != null) {
                       role2.Status__c = 'Confirmed';
                       role2.Role_Level__c = event.Role2_Level__c;
                       roleforUpdate.add(role2);
                   }                               
            } 
           
             else if ('Declined for (all) Role Application(s)'.equals(event.Application_Status__c) || 
                      ( 'Failed'.equals(event.Training_outcome_2nd_Role__c) && 'Yes'.equals(event.Declined_for_Further_Trainings2__c) ) ) {
                    if (!String.isEmpty(trainingEvent.IB_Role_2__c) && role2 != null) {
                       role2.Status__c = 'Declined';
                       role2.Role_Level__c = event.Role2_Level__c;
                       roleforUpdate.add(role2);
                        System.debug('******Role 2 Status: '+role2.Status__c);
                    }                               
            }
                    
            //End  
                
            
            
            
        }
         
        update roleforUpdate;
    
    }

    public void indicateInterestInTrainingEventUpdate (Map<Id, My_Training_Event__c> newTraining, Map<Id, My_Training_Event__c> oldTraining){
        List <My_Training_Event__c> events = new List<My_Training_Event__c>();

        for (My_Training_Event__c newTrainEvent : newTraining.values()) {
            
            final My_Training_Event__c oldTrainEvent = oldTraining.get(newTrainEvent.Id);
            //bypass logic if this is a change in notification status
            if((newTrainEvent.Notify_Of_Status__c == false && oldTrainEvent.Notify_Of_Status__c == true) || (newTrainEvent.Notify_Of_Status__c == true && oldTrainEvent.Notify_Of_Status__c == false)){
              continue;
            } else {
              events.add(newTrainEvent);
            }
            
        }

        if(!events.isEmpty()){
          indicateInterestInTrainingEvent(events);
        }
    }
    
    // Indicate Interest In Training Event Case 
    public void indicateInterestInTrainingEvent(final List <My_Training_Event__c> events ) {
        
        final List <String> trainingsId = new List <String> ();
        final List <String> contactsId = new List <String> ();
        
        
        for (My_Training_Event__c event : events) {
             trainingsId.add(event.Training_Event__c);
             contactsId.add  (event.IB_Contact__c);
             
        }
        
        final Map <String, Training_Event__c> trainingEvents = new Map <String, Training_Event__c> ([ Select Id, Name, IB_Event__c, IB_Role__c, IB_Role_2__c, IB_Role_3__c, IB_Programme__c, Training_Event_Type__c From Training_Event__c where id IN :trainingsId ]);
        
        final List <String> rolesId = new List <String> ();
        final List <String> programmsId = new List <String> ();
        
        for (Training_Event__c event : trainingEvents.values()) {
            rolesId.add     (event.IB_Role__c);
            if (!String.isEmpty(event.IB_Role_2__c)) {
                rolesId.add     (event.IB_Role_2__c);
            }
            else if (!String.isEmpty(event.IB_Role_3__c)) {
                rolesId.add     (event.IB_Role_3__c);
            }
            programmsId.add (event.IB_Programme__c);
             
        }
        //System.debug('rolesId: ' + rolesId);
        //System.debug('contactsId: ' + contactsId);
        //System.debug('programmsId: ' + programmsId);
        final List<IB_Role__c> roles = [ Select i.Role_Level__c,  i.Status__c, i.Title__c, Application_Feedback__c,  i.Referee_2_Title__c, i.Referee_2_Last_Name__c, i.Referee_2_First_Name__c, i.Referee_2_Email__c, i.Referee_1_Last_Name__c, i.Referee_1_First_Name__c, i.Referee_1_Email__c, i.Ref_2_Feedback_Request__c, i.Ref_1_Feedback_Request__c, i.RecordTypeId, i.Programme_Selection__c, i.Programme_Selection_Form__c, i.Motivation__c, 
                                   i.LastModifiedDate, i.LastModifiedById, i.LastActivityDate, i.IsDeleted, i.Declined_Application_Status_Information__c,  i.Id, i.IB_Role__c, i.IB_Role_Category__c, i.IB_Contact__c 
                                   From IB_Role__c i where IB_Role__c IN :rolesId and  IB_Contact__c IN :contactsId and Programme_Selection__c IN :programmsId];
        
        //System.debug('events==='+events);

        for (My_Training_Event__c event : events) {
            
            final Training_Event__c trainingEvent = trainingEvents.get(event.Training_Event__c);
            //System.debug('trainingEvent==='+trainingEvent);                        
            if (null == trainingEvent) {
                event.addError(new TriggerException('Indicate Interest In TrainingEvent: TrainingEvent was not found My_Training_Event__c ' + event ).getMessage());
                continue;   
                            
            }
            
            final IB_Role__c role = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role__c, roles);
            //System.debug('role===='+role);
            final IB_Role__c role2 = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role_2__c, roles);
            //System.debug('role2===='+role2);
            final IB_Role__c role3 = getIBRoleObjectby(event.IB_Contact__c, trainingEvent.IB_Programme__c, trainingEvent.IB_Role_3__c, roles);
            
            //System.debug('role3===='+role3);
            
            /*This Part is being updated by Ammara-Plumlogix as a part of CR Functionlity
            /*Begin*/
            
            final boolean isRolePresent = !String.isEmpty(trainingEvent.IB_Role__c)   && null != role;
            final boolean isRole2Present = !String.isEmpty(trainingEvent.IB_Role_2__c)   && null != role2;
            final boolean isRole3Present = !String.isEmpty(trainingEvent.IB_Role_3__c)   && null != role3;
            final String TrainingEventType = trainingEvent.Training_Event_Type__c;
            
            if ( (isRolePresent   && 'Declined'.equals(role.Status__c))
                  || (isRole2Present  && 'Declined'.equals(role2.Status__c))
                  || (isRole3Present  && 'Declined'.equals(role3.Status__c))  ) {
                event.addError(Label.Declined_Role_Application);
                break;
            
            }  if ( (isRolePresent  && 'Unregistered'.equals(role.Status__c))
                        || (isRole2Present  && 'Unregistered'.equals(role2.Status__c))
                        || (isRole3Present  && 'Unregistered'.equals(role3.Status__c)) ) {
                            
                event.addError(Label.Unregistered_Role_Application);
                break;
            
            } 
            //This Part is added by Developer Ammara-Plumlogix on 3-09-2019,CR-688(New Training Event Type 'Ongoing Development')
           //begin
             if (isRolePresent 
                    || isRole2Present 
                    || isRole3Present) {
               
                
               if ( isRolePresent && 'Applicant'.equals(role.Status__c)&& ('Initial Training'.equals(TrainingEventType) || 'Advanced Training'.equals(TrainingEventType)) ||
                    isRolePresent && 'Confirmed'.equals(role.Status__c)&& 'Ongoing Development'.equals(TrainingEventType)) {
                
                    event.IB_Event__c  = trainingEvent.IB_Event__c;
                    event.IB_Role__c   = trainingEvent.IB_Role__c;
                    event.IB_Programme__c = trainingEvent.IB_Programme__c;
                    
               }
               
                if ( isRole2Present && 'Applicant'.equals(role2.Status__c)&& ('Initial Training'.equals(TrainingEventType) || 'Advanced Training'.equals(TrainingEventType)) ||
                         isRolePresent && 'Confirmed'.equals(role.Status__c)&& 'Ongoing Development'.equals(TrainingEventType)) {
                
                    event.IB_Event__c  = trainingEvent.IB_Event__c;
                    event.IB_Role_2__c   = trainingEvent.IB_Role_2__c;
                    event.IB_Programme__c = trainingEvent.IB_Programme__c;
                    
               }
               
                if ( isRole3Present && 'Applicant'.equals(role3.Status__c)&& ('Initial Training'.equals(TrainingEventType) || 'Advanced Training'.equals(TrainingEventType)) ||
                         isRolePresent && 'Confirmed'.equals(role.Status__c)&& 'Ongoing Development'.equals(TrainingEventType)) {
                
                    event.IB_Event__c  = trainingEvent.IB_Event__c;
                    event.IB_Role_3__c   = trainingEvent.IB_Role_3__c;
                    event.IB_Programme__c = trainingEvent.IB_Programme__c;
                    
               }            
            }
            //End
                    
        }
    
    }
    
    
    
    public void notifyOfStatusChange(Map<Id, My_Training_Event__c> newTraining, Map<Id, My_Training_Event__c> oldTraining) {
            
          final Set <String> notifyOfStatusChange = new Set <String> {'Invited', 'Under Approval', 'Confirmed', 'Not Selected', 'Not Approved'};
          final List<String> ibNotifyEventId = new List<String>();
            
          for (My_Training_Event__c newTrainEvent : newTraining.values()) {
            
            final My_Training_Event__c oldTrainEvent = oldTraining.get(newTrainEvent.Id);
            
            final boolean changedStatusCase = newTrainEvent.Application_Status__c != oldTrainEvent.Application_Status__c && notifyOfStatusChange.contains(newTrainEvent.Application_Status__c);  //update Notify flag for changed status

            if(changedStatusCase){
                ibNotifyEventId.add(newTrainEvent.Id);
            }
        } 
       
                updateNotifyOfStatus(ibNotifyEventId);        
    }
    
    
    private void updateNotifyOfStatus(List <String> ibNotifyEventId){
        List<My_Training_Event__c> events = [Select Id, Notify_Of_Status__c From My_Training_Event__c Where Id IN :ibNotifyEventId And Notify_Of_Status__c != true];
                
                for(My_Training_Event__c event : events){
                    event.Notify_Of_Status__c = true;
                }       
        
        update events;
    }
    
    
    
    
    
    
    
    public static void prePopulateContact(final List<My_Training_Event__c> trainings) {
       
       //final Set <String> validProfiles = new Set <String> { '  00eg0000000QNHfAAO' , '00eg0000000QNHeAAO' };
       final Set<String> validProfiles = new Set <String>();
       final List<Profile> listProfiles = [SELECT Id, Name FROM Profile WHERE Name IN ('SCU + Basic','SCU + Advanced','Customer Community Basic','Customer Community Advanced')];
       for (Profile p : listProfiles) {
            validProfiles.add(p.Id);
        }
       
       if (validProfiles.contains(Userinfo.getProfileId())) {
        
           final String contactId =  UserDAO.INSTANCE.getUserById(Userinfo.getUserId()).ContactId;
     
           for (My_Training_Event__c training : trainings) {
                training.IB_Contact__c = contactId;
           }
            
       }
       
   }
   
   private IB_Role__c getIBRoleObjectby(String iBContact, String iBProgramme, String iBRoleId, List<IB_Role__c> roles) {
        //System.debug('ibContact==='+iBContact);
        //System.debug('iBProgramme==='+iBProgramme);
        //System.debug('iBRoleId==='+iBRoleId);
        //System.debug('roles==='+roles);
       for (IB_Role__c role : roles) {
          if (!String.isBlank(iBRoleId) && iBRoleId.equals(role.IB_Role__c) && 
              !String.isBlank(iBProgramme) && iBProgramme.equals(role.Programme_Selection__c) &&
              !String.isBlank(iBContact) && iBContact == role.IB_Contact__c ) {
             return role;
          }
       }
       return null;
   }

}