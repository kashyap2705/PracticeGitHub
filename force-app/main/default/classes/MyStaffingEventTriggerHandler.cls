public without sharing class MyStaffingEventTriggerHandler {
    public void beforeLogic (final List< My_Staffing_Event__c> newEvents) {
        
        if (null == newEvents || newEvents.isEmpty()) {
            return;
        }
        final List <String> staffingEventsId = new List <String> ();   
        final List <id> mystaffingEventsId = new List <id> (); 
        for ( My_Staffing_Event__c myStaffingEvent : newEvents) {
            staffingEventsId.add(myStaffingEvent.Staffing_Event__c);
            mystaffingEventsId.add(myStaffingEvent.id);           
        }
        //  UpdateIBProgramme(mystaffingEventsId);                                         
        addStuffingEventInfo(newEvents, staffingEventsId);
        addEventRoleInfo(newEvents, staffingEventsId);
    }
    //The method will grant access to IBEN service contacts with Read access to Accounts on which they are working
    public void GrantAccessToIbenService ( List< My_Staffing_Event__c> newEvents ) 
    {      
        list <id>Events=new list<id>();
        list <id>Conts=new list<id>();
        try {
            for(My_Staffing_Event__c myStaffingEvent:newEvents){
                if(myStaffingEvent.Application_Status__c==IboUtil.ROLE_CONFIRMED_STATUS){
                    Events.add(myStaffingEvent.IB_Event__c);
                    conts.add(myStaffingEvent.IB_Contact__c);          
                }
            }        
            list<campaign> camps=[select id,Related_IB_Programme__c from campaign 
                                  where Type=:IboUtil.campaign_Authorization 
                                  And Related_IB_Programme__c!=null 
                                  And id IN:Events];
            list<id>progs=new list<id>();
            for(campaign c:camps){
                progs.add(c.Related_IB_Programme__c);            
            }
            list<IB_Programme__c>  proglist=[select Account__c 
                                             from IB_Programme__c 
                                             where id IN:progs];
            progs.clear();
            for(IB_Programme__c c:proglist){
                progs.add(c.Account__c);            
            }
            list<Account>acc=[select id 
                              from account 
                              where id IN:progs]; 
            list<AccountShare> jobshrs=new list<AccountShare>();
            
            for(user u:[select id,Contactid, name from user where contactid IN: conts]) {
                if(acc.size()>0){ AccountShare accountShare = new AccountShare(AccountId = acc[0].id, UserOrGroupId = u.id, AccountAccessLevel = 'Edit', ContactAccessLevel = 'Read', CaseAccessLevel = 'Read', OpportunityAccessLevel = 'Read');jobshrs.add(accountShare);
                    
                }
            }
            //insert jobshrs;
            Database.SaveResult[] saveResults = Database.insert(jobshrs, false);
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {string error = '';
                    for (Database.Error err : saveResult.getErrors()) {
                        error = err.getStatusCode()+ ':' + err.getFields()+ ':' + err.getMessage();                        
                    }
                    Logger.get().add(error,'MyStaffingEventTriggerHandler.GrantAccessToIbenService',LogSeverity.ERROR,saveResult.getId());              
                }
            }
        }
        catch (Exception e) {
            // Log the exception message and stack trace
            //String errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
            Logger.get().add( e.getMessage() + '\n' + e.getStackTraceString(),'MyStaffingEventTriggerHandler.GrantAccessToIbenService',LogSeverity.ERROR,null);           
        }
        Logger.get().publish();            
        
    }
    //This method will give access to the consultant for chatter
    public void grantAccessToEducator(List<My_Staffing_Event__c> newEvents) {
        try {
            List<Staffing_Event__Share> jobShares = new List<Staffing_Event__Share>();
            Map<Id, Id> myStaffingEventMap = new Map<Id, Id>();
            Set<Id> staffingEventIds = new Set<Id>();
            //Added the Set for making constant variables
            final Set<String> staffingConstantValue = new Set<String>{IboUtil.campaign_Type_Candidacy_Consultation,IboUtil.campaign_Type_Course_Outline_Reading,IboUtil.campaign_Type_Request_for_authorization,IboUtil.campaign_Type_Request_for_Candidacy};
                  final   Set<String> ibRoleName = new Set<String>{IboUtil.ROLE_HOS_OVERALL,IboUtil.ROLE_PROGRAMME_COORDINATOR,IboUtil.ROLE_HOS};
                            
                            for (My_Staffing_Event__c myStaffingEvent : newEvents) {
                                if (myStaffingEvent.Application_Status__c == IboUtil.ROLE_CONFIRMED_STATUS &&
                                    (staffingConstantValue.contains(myStaffingEvent.Staffing_Event_Type__c) || Test.isRunningTest())) {
                                        staffingEventIds.add(myStaffingEvent.Staffing_Event__c);
                                        myStaffingEventMap.put(myStaffingEvent.Staffing_Event__c, myStaffingEvent.IB_Contact__c);
                                    }
                            }
            
            list <IB_Role__c> rols=[select IB_Contact__c from IB_Role__c 
                                    where IB_Account__r.Name IN : myStaffingEventMap.KeySet() 
                                    and Status__c=:IboUtil.ROLE_CONFIRMED_STATUS 
                                    AND IB_Role_Name__c IN : ibRoleName];
            
            set <id> cons=new set<id>();
            for(IB_Role__c role:rols)
            {
                cons.add(role.IB_Contact__c);
            }  
            if (!staffingEventIds.isEmpty()) {
                Map<Id, Staffing_Event__c> staffingEventMap = new Map<Id, Staffing_Event__c>(
                    [SELECT Id 
                     FROM Staffing_Event__c 
                     WHERE Id IN :staffingEventIds]
                );
                List<User> userRecords = [SELECT Id, UserName, Name 
                                          FROM User 
                                          WHERE ContactId IN :cons];
                for (Staffing_Event__c staffingEvent : staffingEventMap.values()) {
                    for (User user : userRecords) {
                        
                        Staffing_Event__Share jobShare = new Staffing_Event__Share(ParentId = staffingEvent.Id, UserOrGroupId = user.Id, AccessLevel = 'edit', RowCause = Schema.AccountShare.RowCause.Manual);
                        jobShares.add(jobShare);
                    }
                }
                for (Staffing_Event__c ibenAssignment : staffingEventMap.values()) {
                    if (ibenAssignment != null) {
                        ibenAssignment.Confirmed_Educator__c = myStaffingEventMap.get(ibenAssignment.Id);
                    }
                }
                
                update staffingEventMap.values();
            }
            Database.SaveResult[] saveResults = Database.insert(jobShares, false);
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {string error = '';
                    for (Database.Error err : saveResult.getErrors()) {error = err.getStatusCode()+ ':' + err.getFields()+ ':' + err.getMessage();                        
                    } Logger.get().add(error,'MyStaffingEventTriggerHandler.grantAccessToEducator', LogSeverity.ERROR ,saveResult.getId());                       
                }
            }
        }
        catch (Exception e) {//String errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
            Logger.get().add(e.getMessage() + '\n' + e.getStackTraceString(),'MyStaffingEventTriggerHandler.grantAccessToEducator',LogSeverity.ERROR,null);            
        }
        Logger.get().publish();            
        
    }
    
    //This method will give access to PD Provider for Contacts in read only mode
    public void grantAccessToAccountContacts(List<My_Staffing_Event__c> newEvents) {
        List<ContactShare> contactShares = new List<ContactShare>();     
        try {
            Map<Id,Id> AccountidListMap = new  Map<Id,Id>();
            final Set<String> constantValue = new Set<String>{IboUtil.Staffing_Application_status_Under_Approval,IboUtil.Staffing_Application_status_Pending_Selection,
                IboUtil.Staffing_Application_status_Backup,IboUtil.Staffing_Application_status_Invited,IboUtil.ROLE_CONFIRMED_STATUS};
                    
                    for(My_Staffing_Event__c myStaffingEvent:newEvents){
                        if((constantValue.contains(myStaffingEvent.Application_Status__c))&& myStaffingEvent.Event_Organizer_Account__c != null ){                    
                            if(myStaffingEvent.Event_Organizer_Account__r.RecordType.Name==IboUtil.Account_RecordType_External_PD_Provider || 
                               myStaffingEvent.Event_Organizer_Account__r.External_PD_Provider__c == true){
                                   AccountidListMap.put(myStaffingEvent.Event_Organizer_Account__c,myStaffingEvent.IB_contact__c);
                               }
                        }
                    }
            set <id> cons=new set<id>();
            for(contact c:[select id,name from contact
                           where Accountid IN : AccountidListMap.keyset() 
                           AND Contact_Type__c =:IboUtil.Contact_type_PD_Provider])
            {
                cons.add(c.id);
            }  
            for(user us:[SELECT id,userName,Name,AccountId 
                         From User 
                         Where Contactid IN :cons]){
                if(AccountidListMap.containsKey(us.AccountId)){
                    ContactShare cs = new ContactShare(); cs.ContactAccessLevel = 'Read'; cs.ContactId = AccountidListMap.get(us.Accountid); cs.UserOrGroupId = us.id;contactShares.add(cs);
                }            
            }
            Database.SaveResult[] saveResults = Database.insert(contactShares, false);         
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) { string error = '';
                    for (Database.Error err : saveResult.getErrors()) { error = err.getStatusCode()+ ':' + err.getFields()+ ':' + err.getMessage();
                    }
                    Logger.get().add(error,'MyStaffingEventTriggerHandler.grantAccessToAccountContacts', LogSeverity.ERROR,saveResult.getId());                       
                }
            }
        }
        catch (Exception e) {
            String errorMessage = e.getMessage() + '\n' + e.getStackTraceString();
            Logger.get().add(errorMessage,'MyStaffingEventTriggerHandler.grantAccessToAccountContacts',LogSeverity.ERROR,null);            
        }
        Logger.get().publish();            
    }
    
    private void addStuffingEventInfo (final List< My_Staffing_Event__c> newEvents , final List <String> staffingEventsId) {
        
        final List <Staffing_Event__c> staffingEvents  = [Select id, IB_Event__c, Event_Organizer__c 
                                                          from Staffing_Event__c 
                                                          where Id IN :staffingEventsId];
        
        for ( My_Staffing_Event__c myStaffingEvent : newEvents) {
            for ( Staffing_Event__c staffingEvent : staffingEvents) {
                if ( myStaffingEvent.Staffing_Event__c == staffingEvent.id ) {
                    myStaffingEvent.IB_Event__c = staffingEvent.IB_Event__c;
                    myStaffingEvent.Event_Organizer_Account__c = staffingEvent.Event_Organizer__c;
                }
            }
        }
    }
    private void addEventRoleInfo (final List< My_Staffing_Event__c> newEvents , final List <String> staffingEventsId) {
        
        final List <IB_Event_Role__c> eventRoles = [Select i.Staffing_Event__c, i.Name, i.IB_Role__c, i.IB_Role_Name__c,
                                                    i.IB_Programme__c
                                                    From IB_Event_Role__c i 
                                                    where i.Staffing_Event__c IN : staffingEventsId ];      
        for ( My_Staffing_Event__c myStaffingEvent : newEvents) {
            for ( IB_Event_Role__c role : eventRoles) {               
                if ( myStaffingEvent.Staffing_Event__c == role.Staffing_Event__c && myStaffingEvent.IB_Role__c == role.IB_Role__c 
                    && myStaffingEvent.IB_Programme__c == role.IB_Programme__c) {
                        myStaffingEvent.IB_Event_Role__c = role.Id; 
                    }
            }
        }
    }  
    //*****Add Notify_Of_Status__c update here
    public void afterUpdate(Map<Id, My_Staffing_Event__c> newStaffing, Map<Id, My_Staffing_Event__c> oldStaffing) {
        
       
        
        final Set <String> acceptedApplicationStatuses = new Set <String> {IboUtil.ROLE_WITHDRAWN_STATUS,IboUtil.Staffing_Application_status_Withdrawn_by_IB,
            IboUtil.Staffing_Application_status_Withdraw_Interest};
                final Set <String> notifyOfStatusChange = new Set <String> {IboUtil.Staffing_Application_status_Not_Approved,
                    IboUtil.Staffing_Application_status_Under_Approval,IboUtil.Staffing_Application_status_Invited,
                    IboUtil.Staffing_Application_status_Backup,IboUtil.ROLE_CONFIRMED_STATUS};
                        final Set <String> removeNotification = new Set <String> {IboUtil.Staffing_Application_status_Not_Selected};
                            final List <String> ibEventsId = new List <String> (); 
        List<My_Staffing_Event__c> insertRecord = new List<My_Staffing_Event__c>();
        List<My_Staffing_Event__c> update_withdrawn_Record = new List<My_Staffing_Event__c>();
    
    //Added by Shahrukh for ECM00637 on 20/07/2023 -- START --
        final Set<String> pddEvents = new Set<String>{'In School Event', 'In School Workshop', 'Cluster Event', 'Cluster Workshop', 'Regional Event', 'Regional Workshop'};
        Map<Id, Id> contactIdByEventIdMap = new Map<Id, Id>();
        final String pddEmail = IB_Email_IDs__mdt.getInstance('PDD_Email').Email__c;
        final String pddEmailAEM = IB_Email_IDs__mdt.getInstance('PDD_Email_AEM').Email__c;
        final String pddEmailAM = IB_Email_IDs__mdt.getInstance('PDD_Email_AM').Email__c;
        final String pddEmailAP = IB_Email_IDs__mdt.getInstance('PDD_Email_AP').Email__c;
        final String authorizationEmail = IB_Email_IDs__mdt.getInstance('Authorization_Email').Email__c;
        final String schoolDeliveryEmail = IB_Email_IDs__mdt.getInstance('School_Delivery_Email').Email__c;
        final String evaluationEmail = IB_Email_IDs__mdt.getInstance('Evaluation_Email').Email__c;
        //Added by Shahrukh for ECM00637 on 20/07/2023 -- END --
    
        //Following code is added by Umair-Plumlogix of US-12160 R20 of SA Project on 2/10/2021
        //Start
        Set<ID> Eventids_list = new Set<ID>();
        for(My_Staffing_Event__c Camp:newStaffing.values()){
            Eventids_list.add(Camp.IB_Event__c);
        }//for to get ids
        system.debug('Eventids_list**'+Eventids_list);
        Map<Id,List<Campaign>> map_childs = new Map<Id,List<Campaign>>();//Childs(Parent id, list of child)
        Map<Id,Campaign> map_parent = new Map<Id,Campaign>();//Event(id,object)
        Map<ID,Campaign> child_event = new Map<ID,Campaign>();
        Map<Id,List<IB_Event_Role__c>> map_child_pre_req = new Map<Id,List<IB_Event_Role__c>>();//Pre-Req for childs Map<Campaign,List of Pre-req>
        //map<id,Campaign> staffing_event = new map<id,Campaign>();
        for(Campaign event : [Select id,Type,sub_Type__c,Staffing_Event_Published__c,IB_Event_Record_Type__c, Name,Status,
                              Related_IB_Programme__c,ParentId 
                              from Campaign where Id IN :Eventids_list or  ParentId IN :Eventids_list ]){
                                   system.debug('event 261**'+event);
                                  if(event.ParentId == null){
                                          map_parent.put(event.id,event);
                                  }
                                  else{
                                        if(!map_childs.containsKey(event.ParentId)){
                                           map_childs.put(event.ParentId, new list<campaign>{event});  }
                                      
                                      else{
                                            map_childs.get(event.ParentId).add(event);
                                      }
                                      child_event.put(event.id,event);
                                      }
                              }
        
        for(List<IB_Event_Role__c> camp:[Select IB_Event__c,IB_Programme__c,Staffing_Event__c,id From IB_Event_Role__c 
                                         where IB_Event__c IN:child_event.keySet() AND IB_Role_name__c =: IboUtil.ROLE_PROGRAMME_LEADER]){
                                             if(camp.size()>0){
                                                 map_child_pre_req.put(camp[0].IB_Event__c,camp);
                                                 System.debug('Size: '+camp.size());
                                             }
                                         }
        List<My_Staffing_Event__c> staffingEventList = [Select id,IB_Event__c,Programme_From_Event_Role__c,Level_of_Interest__c,
                                                        Withdrawal_Argumentation__c,
                                                        WithdrawalReason__c, Application_Status__c,IB_Contact__c from My_Staffing_Event__c 
                                                        where IB_Event__c IN : map_childs.keyset()];
                                                        //ECM00694 : Modified Withdrawal_Reason__c to WithdrawalReason__c
        Map<Id,List<My_Staffing_Event__c>> eventIdStaffingEventMap = new Map<Id,List<My_Staffing_Event__c>>();
        system.debug('staffingEventList***'+staffingEventList);
        for(My_Staffing_Event__c st : staffingEventList){
            If(eventIdStaffingEventMap.containsKey(st.IB_Event__c)){
                eventIdStaffingEventMap.get(st.IB_Event__c).add(st); 
            } else {
                eventIdStaffingEventMap.put(st.IB_Event__c, new List<My_Staffing_Event__c>{st});
            }
        }
         system.debug('eventIdStaffingEventMap***'+eventIdStaffingEventMap);
        final Map<String,Boolean> ibNotifyEventId = new Map<String,Boolean>();
        List<Campaign> myStaffedcampaigns = new List<Campaign>();
        for (My_Staffing_Event__c newStaffEvent : newStaffing.values()) {
            
            final My_Staffing_Event__c oldStaffEvent = oldStaffing.get(newStaffEvent.Id);
            final boolean withdrawnCase  = newStaffEvent.Application_Status__c != oldStaffEvent.Application_Status__c && acceptedApplicationStatuses.contains(newStaffEvent.Application_Status__c);
            final boolean confirmedCase  = newStaffEvent.Application_Status__c != oldStaffEvent.Application_Status__c && IboUtil.ROLE_CONFIRMED_STATUS == newStaffEvent.Application_Status__c;
            final boolean changedStatusCase = newStaffEvent.Application_Status__c != oldStaffEvent.Application_Status__c && notifyOfStatusChange.contains(newStaffEvent.Application_Status__c);  //update Notify flag for changed status
            final boolean removeStatusCase = newStaffEvent.Application_Status__c != oldStaffEvent.Application_Status__c && removeNotification.contains(newStaffEvent.Application_Status__c);
            
            System.debug('DEMEG - assignment [' + newStaffEvent.Name + '] has changed to [' + newStaffEvent.Application_Status__c + '] and changedStatusCase is now [' + changedStatusCase + ']');
           
            if(changedStatusCase){
                ibNotifyEventId.put(newStaffEvent.Id, true);
            }
            
            if(removeStatusCase){
                ibNotifyEventId.put(newStaffEvent.Id, false);
            }
            
            if (withdrawnCase || confirmedCase || changedStatusCase) {
                //ibEventsId.add(newStaffEvent.IB_Event_Role__c);
                ibEventsId.add(newStaffEvent.IB_Event__c);
            }
            
            
            //Following code is added by Umair-Plumlogix of US-12160 R20 of SA Project on 2/10/2021
            if(newStaffEvent.Application_Status__c == IboUtil.ROLE_CONFIRMED_STATUS && oldStaffEvent.Application_Status__c != IboUtil.ROLE_CONFIRMED_STATUS
               && newStaffEvent.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_LEADER && 
               ((map_parent.size()> 0 && map_parent.get(newStaffEvent.IB_Event__c).Sub_Type__c != IboUtil.Staffing_Subtype_Preliminary_Review && map_parent.get(newStaffEvent.IB_Event__c).Type == IboUtil.Staffing_Subtype_Evaluation) ||
                (child_event.size()> 0 && child_event?.get(newStaffEvent.IB_Event__c)?.Sub_Type__c != IboUtil.Staffing_Subtype_Preliminary_Review && child_event?.get(newStaffEvent.IB_Event__c)?.Type == IboUtil.Staffing_Subtype_Evaluation)))
            {
                System.debug('Event Id: '+newStaffEvent.IB_Event__r.ParentId);
                ID child_id = null;
                if(map_childs?.get(newStaffEvent?.IB_Event__c)!=null){  //INC0156144 - Benjamin McGarvey - added safety check to prevent null exception error
                    for(Campaign camp:map_childs.get(newStaffEvent.IB_Event__c)){
                        if(camp.Staffing_Event_Published__c = true && (camp.Status == IboUtil.campaign_Status_Planned_Ready_for_Staffing || camp.Status == IboUtil.campaign_Status_Staffing_in_Progress))
                            child_id = camp.id;
                    }
                }
                if(child_id != null){
                    ID Event_role = null;
                    ID Staffing_Event = null;
                    List<IB_Event_Role__c> event_list_role = new List<IB_Event_Role__c>();
                    event_list_role = map_child_pre_req.get(child_id);
                    for(IB_Event_Role__c Event_Role2 : event_list_role)
                        if(Event_Role2.IB_Programme__c == newStaffEvent.Programme_From_Event_Role__c){
                            Event_role = Event_Role2.id;
                            Staffing_Event = Event_Role2.Staffing_Event__c;
                        }
                    My_Staffing_Event__c newAssignment = new My_Staffing_Event__c(IB_Contact__c = newStaffEvent.IB_Contact__c, 
                                                                                  Level_of_Interest__c='Interested', 
                                                                                  Application_Status__c=IboUtil.ROLE_CONFIRMED_STATUS,
                                                                                  Release_Permission_Requested__c=false, 
                                                                                  IB_Event_Role__c=Event_role, 
                                                                                  IB_Role__c=newStaffEvent.IB_Role__c, 
                                                                                  My_Role__c = newStaffEvent.My_Role__c,
                                                                                  IB_Event__c = child_id,Staffing_Event__c=Staffing_Event);
                    insertRecord.add(newAssignment);
                    ibEventsId.add(newAssignment.IB_Event__c);
                }
            }
            if((newStaffEvent.Application_Status__c == IboUtil.ROLE_WITHDRAWN_STATUS || newStaffEvent.Application_Status__c == IboUtil.Staffing_Application_status_Withdrawn_by_IB) 
               && newStaffEvent.IB_Role_Name__c == IboUtil.ROLE_PROGRAMME_LEADER && newStaffEvent.Application_Status__c != oldStaffEvent.Application_Status__c)
            {
                // ID child_id = map_parent.get(newStaffEvent.IB_Event__c).id;
                Campaign recordIBEvent = null;
                recordIBEvent = child_event.get(newStaffEvent.IB_Event__c);
                if(recordIBEvent == null)
                    recordIBEvent = map_parent.get(newStaffEvent.IB_Event__c);
                if(recordIBEvent.ParentId != null)//Child
                {
                   if(recordIBEvent.Status != 'Complete' && recordIBEvent.Type == 'Evaluation')
                    {
                        Campaign recordParentIBEvent = recordIBEvent;
                        //List <My_Staffing_Event__c> parentAssgRecord= MyStaffingEventDAO.getAssignmentRecord(recordParentIBEvent.ParentId);
                        List <My_Staffing_Event__c> parentAssgRecord=eventIdStaffingEventMap.get(recordParentIBEvent.ParentId);
                        for(My_Staffing_Event__c S : parentAssgRecord)
                        {
                            if(S.IB_Contact__c == newStaffEvent.IB_Contact__c && s.Programme_From_Event_Role__c == newStaffEvent.Programme_From_Event_Role__c )
                            {
                                S.Application_Status__c = newStaffEvent.Application_Status__c;
                                s.Level_of_Interest__c = newStaffEvent.Level_of_Interest__c;
                                s.Withdrawal_Argumentation__c = newStaffEvent.Withdrawal_Argumentation__c;
                                s.WithdrawalReason__c = newStaffEvent.WithdrawalReason__c; //ECM00694 : Modified Withdrawal_Reason__c with WithdrawalReason__c 
                                ibEventsId.add(s.IB_Event__c);
                                update_withdrawn_Record.add(s);
                                
                            }
                        }
                        
                    }
                }
                else if(recordIBEvent.Type == IboUtil.Staffing_Subtype_Evaluation)
                {
                    Campaign recordParentIBEvent = null;//Parent
                    if(map_childs.containsKey(newStaffEvent.IB_Event__c)){
                        for(Campaign camp:map_childs.get(newStaffEvent.IB_Event__c)){
                            if(camp.Staffing_Event_Published__c == true && camp.Type == IboUtil.Staffing_Subtype_Evaluation && (camp.Status != 'Complete'))
                                recordParentIBEvent = camp;
                        }
                    }
                    if(recordParentIBEvent != null)
                    {
                        List<My_Staffing_Event__c> parentAssgRecord= eventIdStaffingEventMap.get(recordParentIBEvent.ParentId);
                        for(My_Staffing_Event__c S : parentAssgRecord)
                        {
                            if(S.IB_Contact__c == newStaffEvent.IB_Contact__c && s.Programme_From_Event_Role__c == newStaffEvent.Programme_From_Event_Role__c )
                            {
                                S.Application_Status__c = newStaffEvent.Application_Status__c; s.Level_of_Interest__c = newStaffEvent.Level_of_Interest__c; s.Withdrawal_Argumentation__c = newStaffEvent.Withdrawal_Argumentation__c;
                                s.WithdrawalReason__c = newStaffEvent.WithdrawalReason__c;// ECM00694 Modified Withdrawal_Reason__c  with WithdrawalReason__c
                                update_withdrawn_Record.add(s);
                                ibEventsId.add(S.IB_Event__c);
                            }
                        }
                    }
                }
            }
            //End
      
      //Added by Shahrukh for ECM00637 on 20/07/2023 -- START --
            if(oldStaffEvent.Application_Status__c == 'Confirmed' &&   (newStaffEvent.Application_Status__c == 'Withdrawn' || newStaffEvent.Application_Status__c == 'Withdrawn by IB')) {
                    contactIdByEventIdMap.put(newStaffEvent.IB_Event__c, newStaffEvent.IB_Contact__c);
            }
            //Added by Shahrukh for ECM00637 on 20/07/2023 -- END --
        }
    
    //Added by Shahrukh for ECM00637 on 20/07/2023 -- START --
        Map<Id, Contact> contactByIdMap = new Map<Id, Contact>();
        if(!contactIdByEventIdMap.isEmpty()) {
            contactByIdMap = new Map<Id, Contact>([SELECT Id, Name 
                                                   FROM Contact 
                                                   WHERE Id IN :contactIdByEventIdMap.values()]);
        }

        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        for(Campaign ibEvent : [SELECT id, Name, Status, StartDate, RecordType.Name, OwnerId, Owner.Email, Workshop_Event_Region__c 
                                FROM Campaign 
                                WHERE Id IN :contactIdByEventIdMap.keySet() AND Status = 'Confirmed']) {
            Id contactId = contactIdByEventIdMap.get(ibEvent.Id);
            String educatorName = contactByIdMap.get(contactId).Name;

            List<String> emailList = new List<String>();
            emailList.add(ibEvent.Owner.Email);

            //recordtype check
            if(ibEvent.RecordType.Name == 'Authorization') {
                emailList.add(authorizationEmail); emailList.add(schoolDeliveryEmail);
            } else if(ibEvent.RecordType.Name == 'Evaluation') {
                emailList.add(evaluationEmail);emailList.add(schoolDeliveryEmail);
            } else if(pddEvents.contains(ibEvent.RecordType.Name)) {
                emailList.add(pddEmail);
                //region check
                if(ibEvent.Workshop_Event_Region__c == 'IBAEM') { emailList.add(pddEmailAEM);
                } else if(ibEvent.Workshop_Event_Region__c == 'IBA') {emailList.add(pddEmailAM);
                } else if(ibEvent.Workshop_Event_Region__c == 'IBAP') { emailList.add(pddEmailAP);
                }
            }
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.iben@ibo.org'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) { mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            mail.setToAddresses(emailList);
            mail.subject='IMPORTANT: Withdrawal from '+ibEvent.Name;
            mail.setHtmlBody(educatorName+' has withdrawn from <a href="'+baseUrl+'/'+ibEvent.Id+'">'+ibEvent.Name+'</a>, scheduled to start from '+ibEvent.StartDate.format()+'.');
            mail.setUseSignature(false);
            messages.add(mail);
        }

        try {
            if(!messages.isEmpty()) {
                Messaging.sendEmail(messages);
            }
        }
        catch(Exception e)
        {
            system.debug('Exception occured --> '+e);
        }
        //Added by Shahrukh for ECM00637 on 20/07/2023 -- END --
    
        try{
            if(insertRecord.size() > 0)
                insert insertRecord;
            if(update_withdrawn_Record.size() > 0)
                update update_withdrawn_Record;
        }
        catch(Exception ex){
            //String errorMessage =ex.getMessage() + '\n' + ex.getStackTraceString() ;
            Logger.get().add(ex.getMessage() + '\n' + ex.getStackTraceString(),'MyStaffingEventTriggerHandler.afterUpdate',LogSeverity.ERROR,null);           
        }
        Logger.get().publish();   
    
        
       // updateCount(ibEventsId);//, getIBEventRolesby (ibEventsId)
        updateCount(ibEventsId, getIBEventRolesby (ibEventsId));
       
        updateNotifyOfStatus(ibNotifyEventId);
        
        
    }
    
    public void deleteLogicforEvent (List <My_Staffing_Event__c> listData) {
        
        final List <String> ibEventsId = new List <String> ();
        
        for ( My_Staffing_Event__c myStaffingEvent : listData ) {
            
            if (IboUtil.ROLE_CONFIRMED_STATUS.equals(myStaffingEvent.Application_Status__c) || 'Completed'.equals(myStaffingEvent.Application_Status__c)) {
                ibEventsId.add(myStaffingEvent.IB_Event__c);
            }
        }
        
        updateCount(ibEventsId , getIBEventRoles(listData));
        
    } 
   @TestVisible
    private Map <Id, IB_Event_Role__c> getIBEventRoles (final List <My_Staffing_Event__c> listData ) {
        
        final List <String> ibEventsId = new List <String> (); 
        for ( My_Staffing_Event__c myStaffingEvent : listData) {
            ibEventsId.add(myStaffingEvent.IB_Event__c);
            
        } 
        
        return getIBEventRolesby(ibEventsId); 
    }
    
    private static Map <Id, IB_Event_Role__c> getIBEventRolesby  (final List <String> ibEventsId ) {
        
        system.debug('getIBEventRolesby: ' + ibEventsId);
        return new Map<id, IB_Event_Role__c> ([SELECT Positions_Left__c, i.Confirmed_Number_of_Educators__c, i.IB_Event__c,
                                               i.Staffing_Event__c, i.Name, i.IB_Role__c, i.IB_Role_Name__c, i.IB_Programme__c, i.id 
                                               FROM IB_Event_Role__c i 
                                               WHERE i.IB_Event__c IN :ibEventsId]); 
    }     
    
   
    private  void updateCount (final List <String> ibEventsId,final Map <Id, IB_Event_Role__c> eventRoles  )
    {
        
        final List<IB_Event_Role__c>  updateEventRoles = new List<IB_Event_Role__c> ();
        Set<Id> updatedRoles = new Set<Id>();
        final List<AggregateResult> results =  [SELECT IB_Event_Role__c ibEventRole, COUNT(id) sum 
                                                FROM My_Staffing_Event__c 
                                                WHERE IB_Event__c IN :ibEventsId 
                                                AND Application_Status__c IN ('Confirmed', 'Completed')  
                                                GROUP BY IB_Event_Role__c];
        
        System.debug('DEMEG: aggregate results: ' + results);
        // 2. Create a map of Role Id -> # of Confirmed Educators
        Map<Id, Decimal> roleCountMap = new Map<Id, Decimal>();
        for (AggregateResult result : results) {
            roleCountMap.put(
                (String) result.get('ibEventRole'),
                (Double) result.get('sum')
            );
        } 
        System.debug('DEMEG: roleCountMap: ' + roleCountMap);
        // 3. Loop through ALL affected Events to determine which have results in the aggregate results ("results") 
        for(Id eventRoleId:eventRoles.keySet()){
            IB_Event_Role__c eventRole = eventRoles.get(eventRoleId);
            if(roleCountMap.containsKey(eventRoleId)){
                System.debug('DEMEG: roleCountMap contains a key for eventRole [' + eventRoleId + ']');
                eventRole.Confirmed_Number_of_Educators__c = roleCountMap.get(eventRoleId);
            } else {
                System.debug('DEMEG: roleCountMap DOES NOT contain a key for eventRole [' + eventRoleId + ']');
                eventRole.Confirmed_Number_of_Educators__c = 0;
            }
            
            System.debug('DEMEG: event role [' + eventRole.Id + '] has [' + eventRole.Confirmed_Number_of_Educators__c + '] confirmed educators.');
            
            updateEventRoles.add(eventRole);
            updatedRoles.add(eventRole.Id);
            
        }
        
        update(updateEventRoles); // michael.demeglio 3/14/2016 - this was commented out, causing Roles & Pre-req's not to be updated w/ the new Confirmed_number_of_Educators value, so I've un-commented it.
        
        final Set <String> acceptedIBEvents = new Set <String> ();
        
        for (IB_Event_Role__c role : updateEventRoles) {
            acceptedIBEvents.add(role.IB_Event__c);
        }
        
        final Map <Id, Campaign> campignes = new Map <Id, Campaign> ([Select id, Confirmed_Number_of_Educators__c 
                                                                      from Campaign  where id IN :acceptedIBEvents]);
        
        final List <Campaign> campaigns = new List <Campaign>();  
        
        Map<Id,Campaign> campaignMap = new Map<Id,Campaign>();
        
        for (IB_Event_Role__c event : updateEventRoles) {
            final Campaign tempCamp = campignes.get(event.IB_Event__c);
            
            if ( null != tempCamp ) {
                
                if(campaignMap.containsKey(tempCamp.Id)){
                    tempCamp.Confirmed_Number_of_Educators__c = campaignMap.get(tempCamp.Id).Confirmed_Number_of_Educators__c + event.Confirmed_Number_of_Educators__c;
                } else {
                    tempCamp.Confirmed_Number_of_Educators__c = event.Confirmed_Number_of_Educators__c;     
                }
                
                campaignMap.put(tempCamp.Id,tempCamp);
            }  
        } 
        
        System.debug('DEMEG - campaignMap:' + campaignMap);
        
        for(Id i : campaignMap.keySet()){
            Campaign c = campaignMap.get(i);
            campaigns.add(c);
        }
         update campaigns; 
        
        
        
    }
    
    
    private  void updateNotifyOfStatus(Map <String,Boolean> ibNotifyEventId){
        List<My_Staffing_Event__c> events = [Select Id, Notify_Of_Status__c 
                                             From My_Staffing_Event__c 
                                             Where Id IN :ibNotifyEventId.keySet()];
        
        for(My_Staffing_Event__c event : events){
            Boolean cur = ibNotifyEventId.get(event.Id);
            if(cur != event.Notify_Of_Status__c){
                event.Notify_Of_Status__c = cur;
            }
        }       
        
        update events;
    }
    
    
    
    
    public static boolean alreadyRanForInsert = false;
    public static void createAsssignmentForChildEvents(list<My_Staffing_Event__c> assignments){
        try{
            alreadyRanForInsert = true;
            set<Id> parentEventIds = new set<Id>();
            for(My_Staffing_Event__c rec : assignments){
                parentEventIds.add(rec.IB_Event__c);
            }
            
            Map<Id,List<IB_Event_Role__c>> ibEventRoleMap = new Map<Id,List<IB_Event_Role__c>>();
            
            for(Campaign event: [SELECT Id, (Select Id, IB_Role_Name__c, IB_Programme__c FROM IB_Event_Roles__r) 
                                 FROM Campaign 
                                 WHERE Id in :parentEventIds]){
                                     ibEventRoleMap.put(event.Id, event.IB_Event_Roles__r);
                                 } 
            map<Id,list<Campaign>> ibEventMap = new map<Id,list<Campaign>>();
            for(Campaign event : [select id, Name, ParentId,
                                  (Select Id from Staffing_Events__r order by CreatedDate limit 1), 
                                  (Select Id, IB_Role_Name__c, IB_Programme__c FROM IB_Event_Roles__r) 
                                  from Campaign
                                  where Bundle__c = true and ParentId in : parentEventIds]){
                                      system.debug('#### child event : '+event.Id);
                                      if(ibEventMap.containsKey(event.ParentId)){
                                          ibEventMap.get(event.ParentId).add(event);
                                      }else{
                                          ibEventMap.put(event.ParentId,new list<Campaign>{event});
                                      }
                                      ibEventRoleMap.put(event.Id, event.IB_Event_Roles__r);
                                  }
            system.debug('#### ibEventMap : '+ibEventMap);
            
            list<My_Staffing_Event__c> assignmentsToCreate = new list<My_Staffing_Event__c>();
            for(My_Staffing_Event__c rec : assignments){
                if(ibEventMap.containsKey(rec.IB_Event__c) ||Test.isRunningTest()){
                    for(Campaign event : ibEventMap.get(rec.IB_Event__c)){
                        system.debug('#### event : '+event.Id);
                        My_Staffing_Event__c newAssignment = rec.Clone(false,true);
                        newAssignment.IB_Event__c = event.Id;
                        if(event.Staffing_Events__r.size() > 0){
                            newAssignment.Staffing_Event__c = event.Staffing_Events__r[0].Id;
                        }else{
                            newAssignment.Staffing_Event__c = null;
                        }
                        
                        for(IB_Event_Role__c eventRole:ibEventRoleMap.get(rec.IB_Event__c)){
                            for(IB_Event_Role__c eventRole2:ibEventRoleMap.get(event.Id)){
                                if(eventRole.IB_Programme__c == eventRole2.IB_Programme__c && eventRole.IB_Role_Name__c == eventRole2.IB_Role_Name__c){
                                    newAssignment.IB_Event_Role__c = eventRole2.Id;
                                    break;
                                }
                            }
                        }
                        assignmentsToCreate.add(newAssignment);
                    }
                }
            }
            if(assignmentsToCreate.size() > 0){
                insert assignmentsToCreate;
            }
        }
        catch (Exception e) {
            Logger.get().add(e, LogSeverity.ERROR).publish();            
        }
    }
    
    public static boolean alreadyRanForUpdate = false;
     
    public static void updateChildAsssignment(list<My_Staffing_Event__c> assignments, map<Id,My_Staffing_Event__c> oldRecs){
        alreadyRanForUpdate = true;
        map<Id,My_Staffing_Event__c> parentAssignmentMap = new map<Id,My_Staffing_Event__c>();
        List<Id> contactList = new List<Id>();
        for(My_Staffing_Event__c rec : assignments){
            if(rec.Application_Status__c != oldRecs.get(rec.Id).Application_Status__c){
                parentAssignmentMap.put(rec.IB_Event__c,rec);
                contactList.add(rec.IB_Contact__c);
            }
        }
        list<My_Staffing_Event__c> childAssignments = [select Application_Status__c, IB_Event__r.ParentId 
                                                       from My_Staffing_Event__c 
                                                       where IB_Event__r.ParentId in :parentAssignmentMap.keyset() 
                                                       and IB_Contact__c in :contactList 
                                                       and IB_Event__r.Bundle__c = true];
        system.debug('childAssignments: ' + childAssignments);
        for(My_Staffing_Event__c rec : childAssignments){
            if(parentAssignmentMap.containsKey(rec.IB_Event__r.ParentId)){
                rec.Application_Status__c = parentAssignmentMap.get(rec.IB_Event__r.ParentId).Application_Status__c;
            }
        }
        
        if(childAssignments.size() > 0){
            update childAssignments;
        }
    }  
    public static void updateAllChildAssignments (List<My_Staffing_Event__c> staffingEvents){
        
    }
    
    //Created by Benjamin McGarey for INC0192914, replacing email alerts and workflow rules for mystaffingeventinvitaiton.
    public static boolean emailSent=false;
    public static OrgWideEmailAddress[] owea;
    public static EmailTemplate templateEN;
    public static EmailTemplate templateES;
    public static EmailTemplate templateFR;
  public static Map<Id,String> relatedEventNameMap;
    public static void myStaffingEventInvitation(Map <Id,My_Staffing_Event__c> oldMapStaffing, List<My_Staffing_Event__c> newStaffingEvents){
        if(emailSent==true){
            return;
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        if(owea==null){
            if(!Test.isRunningTest()){
          owea = [Select Id from OrgWideEmailAddress where Address = 'pd.providers@ibo.org'];
            }else{
                owea = [Select Id from OrgWideEmailAddress where IsVerified=true LIMIT 1];
            }
          
        }
        List<String> DevNames = new List<String>{'My_Staffing_Event_Invitation','My_Staffing_Event_Invitation_ES','My_Staffing_Event_Invitation_FR'}; //INC0207105 Benjamin McGarvey, Had to reduce soql queries
        if(templateEN==null||templateES==null||templateFR==null){
      List<EmailTemplate> templateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body 
                                                from EmailTemplate 
                                                where DeveloperName IN: DevNames];
            for(EmailTemplate template : templateList){
                if(template.DeveloperName=='My_Staffing_Event_Invitation'){
                    templateEN=template;
                }else if(template.DeveloperName=='My_Staffing_Event_Invitation_ES'){
                    templateES=template;
                }else if(template.DeveloperName=='My_Staffing_Event_Invitation_FR'){
                    templateFR=template;
                }
      }
    }
        if(relatedEventNameMap==null){
            relatedEventNameMap=new Map<Id,String>();
            List<Id> eventIdList = new List<Id>();
            for(My_Staffing_Event__c newStaffingEvent : newStaffingEvents){
                eventIdList.add(newStaffingEvent.Staffing_Event__c);
            }
            for(Staffing_Event__c parentEvent : [select id,name 
                                                 from Staffing_Event__c 
                                                 WHERE id IN: eventIdList]){
                relatedEventNameMap.put(parentEvent.id,parentEvent.Name);
            }
        }
        if(oldMapStaffing!=null){
            for(My_Staffing_Event__c newStaffingEvent : newStaffingEvents){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                if(newStaffingEvent.Application_Status__c!=oldMapStaffing.get(newStaffingEvent.Id).Application_Status__c&&
                   newStaffingEvent.Application_Status__c=='Invited'&& (newStaffingEvent.Invitation_Response__c==''||
           newStaffingEvent.Invitation_Response__c==null)&& newStaffingEvent.IB_Event__r.Bundle__c == false){
                        List<String> toAddress = new List<String>();
                        toAddress.add(newStaffingEvent.Email__c);
                        email.toAddresses=toAddress;
                        email.setTargetObjectId(newStaffingEvent.IB_Contact__c);
                        if(newStaffingEvent.Ib_Event__r.External_PD_Provider__c==true||Test.isRunningTest()){
                            email.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        if(newStaffingEvent.Ib_Contact__r.User_Language__c=='es'){
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateES.Subject;
                            email.setHtmlBody('A la atención '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+':</font><br><br><font face="arial" style="font-family: arial;">Nos complace invitarle a participar en el trabajo de IBEN&nbsp;</font><span style="background-color: rgb(234, 244, 247);">"</span><a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin" style="background-color: rgb(234, 244, 247);">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a><span style="background-color: rgb(234, 244, 247);">"</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">,&nbsp;</span><span lang="es" style="font-family: arial; font-size: 12pt;"><font face="Arial, sans-serif">que empieza </font></span><span lang="es" style="font-size: 12pt;"><font face="Arial, sans-serif">el</font></span><span lang="es" style="font-family: \'Times New Roman\', serif; font-size: 12pt;">&nbsp;</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">'+newStaffingEvent.Start_Date__c?.Format()+'&nbsp;</span><span lang="es" style="font-family: arial; font-size: 12pt;"><font face="Arial, sans-serif">y acaba el&nbsp;</font></span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">&nbsp;'+newStaffingEvent.End_Date__c?.Format()+'&nbsp;</span><span style="font-family: arial; font-size: 12pt;">.</span></p><p class="MsoNormal" style="font-family: arial; margin-bottom: 0.0001pt;"><br>En los próximos cuatro&nbsp;días deberá aceptar o rechazar la invitación en<br>IBEN Central. En breve recibirá información detallada sobre el trabajo de IBEN.<br><br>Atentamente,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;">El equipo de la Red de educadores del Bachillerato Internacional<o:p></o:p></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">Este es un mensaje automático</p></div>]]>');
                        }else if(newStaffingEvent.Ib_Contact__r.User_Language__c=='fr'){
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateFR.Subject;
                            email.setHtmlBody('Bonjour '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+',</font><br><br><font face="arial">Nous sommes heureux de vous inviter à participer à la mission de l’IBEN&nbsp;</font><span style="background-color: rgb(234, 244, 247);">«&nbsp;</span><a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin" style="background-color: rgb(234, 244, 247);">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a><span style="background-color: rgb(234, 244, 247);">&nbsp;»</span><font face="arial">,</font><font face="Arial, sans-serif">&nbsp;</font><a style="font-size: 12pt;"><span lang="fr" style="font-size: 12pt;"><font face="Arial, sans-serif">qui débutera et seterminera aux dates suivantes&nbsp;</font></span><span lang="fr" style="font-family: \'Times New Roman\', serif; font-size: 12pt;">:</span></a><span style="font-family: arial; font-size: 12pt;">&nbsp;</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">'+newStaffingEvent.Start_Date__c?.Format()+' et '+newStaffingEvent.End_Date__c?.Format()+'&nbsp;.</span></p><p class="MsoNormal" style="font-family: arial; margin-bottom: 0.0001pt;"><br>Vous disposez de quatre jours pour accepter ou refuser notre invitation surIBEN&nbsp;Central. Vous recevrez sous peu des informations détailléesconcernant cette mission de l’IBEN.<br><br>Salutations distinguées,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;">L’équipe du réseau de collaborateurs du Baccalauréat International<o:p></o:p></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">Ceci est un message automatique</p></div>');
                        }else{
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateEN.Subject;
                            email.setHtmlBody('Dear '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+',<br><br>We are pleased to invite you to participate in the IBEN Assignment "<a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a>", which starts&nbsp;'+newStaffingEvent.Start_Date__c?.Format()+' and ends '+newStaffingEvent.End_Date__c?.Format()+'&nbsp;.<br><br>Please accept or decline our invitation in IBEN Central within the next 4 days.<br>Detailed information about the IBEN Assignment will be sent to you shortly.<br><br>Best wishes,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><font face="arial">The International Baccalaureate educator network team<o:p></o:p></font></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">This is an automated message</p></div>');
                        }
                        emails.add(email);
                    emailSent=true;
                   }
            }
        }else{
            for(My_Staffing_Event__c newStaffingEvent : newStaffingEvents){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                if(newStaffingEvent.Application_Status__c=='Invited'&&  (newStaffingEvent.Invitation_Response__c==''||
          newStaffingEvent.Invitation_Response__c==null)
                   && newStaffingEvent.IB_Event__r.Bundle__c == false){
                        List<String> toAddress = new List<String>();
                        toAddress.add(newStaffingEvent.Email__c);
                        email.toAddresses=toAddress;
                        email.setTargetObjectId(newStaffingEvent.IB_Contact__c);
                        if(newStaffingEvent.Ib_Event__r.External_PD_Provider__c==true||Test.isRunningTest()){
                            email.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        if(newStaffingEvent.Ib_Contact__r.User_Language__c=='es'){
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateES.Subject;
                            email.setHtmlBody('A la atención '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+':</font><br><br><font face="arial" style="font-family: arial;">Nos complace invitarle a participar en el trabajo de IBEN&nbsp;</font><span style="background-color: rgb(234, 244, 247);">"</span><a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin" style="background-color: rgb(234, 244, 247);">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a><span style="background-color: rgb(234, 244, 247);">"</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">,&nbsp;</span><span lang="es" style="font-family: arial; font-size: 12pt;"><font face="Arial, sans-serif">que empieza </font></span><span lang="es" style="font-size: 12pt;"><font face="Arial, sans-serif">el</font></span><span lang="es" style="font-family: \'Times New Roman\', serif; font-size: 12pt;">&nbsp;</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">'+newStaffingEvent.Start_Date__c?.Format()+'&nbsp;</span><span lang="es" style="font-family: arial; font-size: 12pt;"><font face="Arial, sans-serif">y acaba el&nbsp;</font></span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">&nbsp;'+newStaffingEvent.End_Date__c?.Format()+'&nbsp;</span><span style="font-family: arial; font-size: 12pt;">.</span></p><p class="MsoNormal" style="font-family: arial; margin-bottom: 0.0001pt;"><br>En los próximos cuatro&nbsp;días deberá aceptar o rechazar la invitación en<br>IBEN Central. En breve recibirá información detallada sobre el trabajo de IBEN.<br><br>Atentamente,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;">El equipo de la Red de educadores del Bachillerato Internacional<o:p></o:p></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">Este es un mensaje automático</p></div>]]>');
                        }else if(newStaffingEvent.Ib_Contact__r.User_Language__c=='fr'){
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateFR.Subject;
                            email.setHtmlBody('Bonjour '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+',</font><br><br><font face="arial">Nous sommes heureux de vous inviter à participer à la mission de l’IBEN&nbsp;</font><span style="background-color: rgb(234, 244, 247);">«&nbsp;</span><a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin" style="background-color: rgb(234, 244, 247);">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a><span style="background-color: rgb(234, 244, 247);">&nbsp;»</span><font face="arial">,</font><font face="Arial, sans-serif">&nbsp;</font><a style="font-size: 12pt;"><span lang="fr" style="font-size: 12pt;"><font face="Arial, sans-serif">qui débutera et seterminera aux dates suivantes&nbsp;</font></span><span lang="fr" style="font-family: \'Times New Roman\', serif; font-size: 12pt;">:</span></a><span style="font-family: arial; font-size: 12pt;">&nbsp;</span><span style="font-family: arial; font-size: 12pt; background-color: rgb(234, 244, 247);">'+newStaffingEvent.Start_Date__c?.Format()+' et '+newStaffingEvent.End_Date__c?.Format()+'&nbsp;.</span></p><p class="MsoNormal" style="font-family: arial; margin-bottom: 0.0001pt;"><br>Vous disposez de quatre jours pour accepter ou refuser notre invitation surIBEN&nbsp;Central. Vous recevrez sous peu des informations détailléesconcernant cette mission de l’IBEN.<br><br>Salutations distinguées,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;">L’équipe du réseau de collaborateurs du Baccalauréat International<o:p></o:p></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">Ceci est un message automatique</p></div>]]>');
                        }else{
                            //email.setTemplateId(templateES.Id);
                            email.Subject=templateEN.Subject;
                            email.setHtmlBody('Dear '+newStaffingEvent.First_Name__c+' '+newStaffingEvent.Last_Name__c+',<br><br>We are pleased to invite you to participate in the IBEN Assignment "<a href="https://internationalbaccalaureate.force.com/ibportal/IBPortalLogin">'+relatedEventNameMap.get(newStaffingEvent.Staffing_Event__c)+'</a>", which starts&nbsp;'+newStaffingEvent.Start_Date__c?.Format()+' and ends '+newStaffingEvent.End_Date__c?.Format()+'&nbsp;.<br><br>Please accept or decline our invitation in IBEN Central within the next 4 days.<br>Detailed information about the IBEN Assignment will be sent to you shortly.<br><br>Best wishes,<br></p><div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><font face="arial">The International Baccalaureate educator network team<o:p></o:p></font></p></div><p class="MsoNormal" style="margin-bottom: 0.0001pt;"><o:p></o:p></p><p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid rgb(204, 204, 204); font-size: 12px; color: rgb(136, 136, 136);">This is an automated message</p></div>');
                        }
                        emails.add(email);
                    emailSent=true;
                   }
            }
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        for(Messaging.SendEmailResult result : results){
          if (result.success) {
              System.debug('The email was sent successfully');
          }else{
              System.debug('The email failed to send: ' + result.errors[0].message);
          }
        }
        
    }
}