public class BQCBulkEventCreation {
    public static boolean isAlreadyExecutedEventCreation = false;
    public static boolean isAlreadyExecutedEventPublish = false;
    public static boolean isAlreadyExecutedStatusChange = false;
    public static boolean isAlreadyExecutedReadyforSRReview = false;
    public static boolean isAlreadyExecutedEventStatus = false;
    public static boolean isAlreadyComplete = false;
    public static void creat_Events(Set<Campaign> Event_set)
    {
        List<Campaign> Event_list = new List<Campaign>(Event_set);
        Set<Campaign> create_events = new Set<Campaign>();
        List<IB_Subject__c> subjects = new List<IB_Subject__c>();
        List<IB_Subject__c> subjects_list = new List<IB_Subject__c>();
        List<string> subjects_string= new List<string>();
        subjects_string = getsubjects();
        RecordType RecType = new RecordType(id =Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Authorization').getRecordTypeId() );
        for(String subject:subjects_string){
            for(Campaign Event_record:Event_list){
                Campaign  NewChildEvent = new Campaign(
                    ParentId = Event_record.id,
                    Related_IB_Programme__c = Event_record.Related_IB_Programme__c,
                    RecordTypeId = Event_record.RecordTypeId,
                    Venue_Account__c = Event_record.Venue_Account__c,
                    Sub_Type__c = 'BQC Event',
                    Name = 'BQC Child Event',
                    StartDate=Event_record.StartDate,
                    Event_Organizer_Account__c =  Event_record.Event_Organizer_Account__c,
                    BQC_Status__c = 'Pending Document Submission',
                    Required_Number_of_Educators__c = 2,
                    Type = Event_record.Type,
                    BQC_Subject__c = subject,
                    Unit_Plan__c = 'Unit 1'
                );
                Campaign  NewChildEvent1 = new Campaign(
                    ParentId = Event_record.id,
                    Related_IB_Programme__c = Event_record.Related_IB_Programme__c,
                    RecordTypeId =  Event_record.RecordTypeId,
                    Venue_Account__c = Event_record.Venue_Account__c,
                    Sub_Type__c = 'BQC Event',
                    Name = 'BQC Child Event',
                    BQC_Status__c = 'Pending Document Submission',
                    StartDate=Event_record.StartDate,
                    Event_Organizer_Account__c =  Event_record.Event_Organizer_Account__c,
                    Required_Number_of_Educators__c = 2,
                    Type = Event_record.Type,
                    BQC_Subject__c = subject,
                    Unit_Plan__c = 'Unit 2'
                );
                create_events.add(NewChildEvent);
                create_events.add(NewChildEvent1);
            }
        }
        
        List<Campaign> events_need_to_insert = new List<Campaign>(create_events);
        try{
            insert events_need_to_insert;
            isAlreadyExecutedEventCreation = true;
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
            isAlreadyExecutedEventCreation = false;
        }
        
    }
    public static List<string> getsubjects(){
        List<string> subjects= new List<string>();
        subjects.add('Language Acquisition');
        subjects.add('Language and Literature');
        subjects.add('Individuals and Societies');
        subjects.add('Sciences');
        subjects.add('Mathematics');
        subjects.add('Arts');
        subjects.add('Physical and Health Education');
        subjects.add('Design');
        subjects.add('Interdisciplinary (IDU)');
        return subjects;
    }
    public static List<ID> getcampaignids(List<Campaign> Event_list, boolean parentids){
        List<ID> campaignids = new List<ID>();
        for(Campaign camp_record:Event_list){
            if(parentids == true)
                campaignids.add(camp_record.ParentId);
            else
                campaignids.add(camp_record.id);
        }
        return campaignids;
    }
    @Future
    Public static void BQC_child_publish(List<ID> Event_list){
        //List<Campaign> Event_list = new List<Campaign>(Event_set);
        Set<Campaign> update_events = new Set<Campaign>();
        //List<ID> campaign_ids =   getcampaignids(Event_list,true);
        List<Campaign> mypParenteventList = new List<Campaign>();
        
        map<id, list<Campaign>> mypParentToChildeventsMap = new map<id, list<Campaign>>();
        
        for(Campaign event : [Select id,Staffing_Event_Published__c,IB_Event_Record_Type__c,BQC_Status__c ,IB_Subject__c,IB_Subject__r.Subject_Name__c,
                              
                              Name,Status,Related_IB_Programme__c, ParentId  from Campaign where Id IN :Event_list or (
                                  ParentId IN :Event_list AND Status != 'Cancelled' AND Status != 'Complete')]){
                                      
                                      if(event.ParentId == null){
                                          
                                          mypParenteventList.add(event); }
                                      
                                      else{
                                          
                                          if(!mypParentToChildeventsMap.containsKey(event.ParentId)){
                                              
                                              mypParentToChildeventsMap.put(event.ParentId, new list<campaign>{event});  }
                                          
                                          else{
                                              
                                              mypParentToChildeventsMap.get(event.ParentId).add(event); }
                                          
                                      }
                                  }
        if(mypParentToChildeventsMap.size()>0 ){
            for(Campaign parent_camp:mypParenteventList) {
                for(Campaign child_camp:mypParentToChildeventsMap.get(parent_camp.id)   ){
                    if(child_camp.Staffing_Event_Published__c != TRUE && child_camp.Status != 'Cancelled' && child_camp.Status == 'Planned / Ready for Staffing') {
                        child_camp.Staffing_Event_Published__c = true;
                        update_events.add(child_camp);
                    }
                }
            }
        }
        List<Campaign> events_need_to_update = new List<Campaign>(update_events);
        try{
            if(events_need_to_update.size()>0){
                update events_need_to_update;
            }
            isAlreadyExecutedEventPublish = true;
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
            isAlreadyExecutedEventPublish = false;
        }
    }
    Public static void BQC_Event_Status_Change(List<ID> Event_list){
        Set<Campaign> update_events = new Set<Campaign>();
        List<Campaign> mypParenteventList = new List<Campaign>();
        Set<ID> Parent_Event_ID = new Set<ID>();
        map<id, list<Campaign>> mypParentToChildeventsMap = new map<id, list<Campaign>>();
        
        for(Campaign event : [Select id,Staffing_Event_Published__c,BQC_Status__c ,IB_Subject__c,IB_Subject__r.Subject_Name__c,
                              
                              Name,Status,Related_IB_Programme__c, ParentId  from Campaign where Id IN :Event_list or (
                                  ParentId IN :Event_list AND Status != 'Complete')]){
                                      
                                      if(event.ParentId == null){
                                           /***This Part is added by Ammara-Plumlogix as part of INC0150184,Staff-Aug Project(Sprint 27)*/
                                         /***Add Cancelled and Postponed Events Related Programme to Set***/
                                        /***Begin***/
                                          System.debug('Status: '+event.Status);
                                          if(event.Status == 'Cancelled' || event.Status == 'Postponed'){
                                             Parent_Event_ID.add(event.Related_IB_Programme__c);
                                         } 
                                          //else
                                          mypParenteventList.add(event); }
                                      
                                      else{
                                          if(!mypParentToChildeventsMap.containsKey(event.ParentId)){
                                              
                                              mypParentToChildeventsMap.put(event.ParentId, new list<campaign>{event});  }
                                          
                                          else{
                                              
                                              mypParentToChildeventsMap.get(event.ParentId).add(event); }
                                          
                                          //End
                                      }
                                  }
        if(mypParentToChildeventsMap.size()>0){
            for(Campaign parent_camp:mypParenteventList) {
                
                for(Campaign child_camp:mypParentToChildeventsMap.get(parent_camp.id)   ){
                    child_camp.Status = parent_camp.Status;
                    System.debug('Update List Size: '+parent_camp.Status); 
                    update_events.add(child_camp);}
            }
        }
        List<Campaign> events_need_to_update = new List<Campaign>(update_events);
        try{
            /***This Part is added by Ammara-Plumlogix as part of INC0150184,Staff-Aug Project(Sprint 27)*/
            /***Begin***/
            if(Parent_Event_ID.size()>0){
                updateapplicationdocument(Parent_Event_ID);
            }
            /***End***/
            if(events_need_to_update.size()>0)
                update events_need_to_update;
            System.debug('Update List Size: '+events_need_to_update.size());
            isAlreadyExecutedEventStatus = true;
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
            isAlreadyExecutedEventStatus = false;
        }
    }
    @Future
    public static void BQC_Parent_Event_Status_Changed(List<ID> Event_list_id){
        Boolean cancel_check = false;
        
        Set<Campaign> update_events = new Set<Campaign>();
        List<Campaign> mypParenteventList = new List<Campaign>();
        
        map<id, list<Campaign>> mypParentToChildeventsMap = new map<id, list<Campaign>>();
        
        for(Campaign event : [Select id,Staffing_Event_Published__c,BQC_Status__c ,IB_Subject__c,IB_Subject__r.Subject_Name__c,
                              
                              Name,Status,Related_IB_Programme__c, ParentId  from Campaign where Id IN :Event_list_id or (
                                  ParentId IN :Event_list_id AND Status != 'Cancelled' AND Status != 'Complete')]){
                                      
                                      if(event.ParentId == null){
                                          
                                          mypParenteventList.add(event); }
                                      
                                      else{
                                          
                                          if(!mypParentToChildeventsMap.containsKey(event.ParentId)){
                                              
                                              mypParentToChildeventsMap.put(event.ParentId, new list<campaign>{event});  }
                                          
                                          else{
                                              
                                              mypParentToChildeventsMap.get(event.ParentId).add(event); }
                                          
                                      }
                                  }
        for(Campaign camp_record:mypParenteventList) {
            if(mypParentToChildeventsMap.get(camp_record.id) != null)
            for(Campaign child_camp:mypParentToChildeventsMap.get(camp_record.id)   ){
                if(camp_record.BQC_Status__c == 'Pending Document Submission'){
                    child_camp.BQC_Status__c = 'Pending Document Submission';
                    
                }
                else if(camp_record.BQC_Status__c == 'Document Submitted')
                    child_camp.BQC_Status__c = 'Document Submitted';
                else if(camp_record.BQC_Status__c == 'Pending Feedback from School Reviewer')
                    child_camp.BQC_Status__c = 'Pending Feedback from School Reviewer';
                else if(camp_record.BQC_Status__c == 'Feedback Submitted by School Reviewer')
                    child_camp.BQC_Status__c = 'Feedback Submitted by School Reviewer';
                else if(camp_record.BQC_Status__c == 'Report Published to My School')
                    child_camp.BQC_Status__c = 'Report Published to My School';
                else if(camp_record.BQC_Status__c ==  'Cancelled'){
                    child_camp.BQC_Status__c =  'Cancelled';
                }else if(camp_record.BQC_Status__c ==  'Event Complete'){
                    child_camp.BQC_Status__c =  'Event Complete';
                }
                System.debug(camp_record.BQC_Status__c+'  '+child_camp.BQC_Status__c);
                update_events.add(child_camp);
            }
        }
        List<Campaign> events_need_to_update = new List<Campaign>(update_events);
        try{
            update events_need_to_update;
            isAlreadyExecutedStatusChange = true;
        }
        Catch(Exception ex){
            System.debug('Exception: '+ex);
            isAlreadyExecutedStatusChange = false;
        }
        
    }
    /** 
* @author Ammara Alvi
* @date 14/09/2021
* @description update Event_Cancelled_Postponed__c on IB Application Attachment
* @returntype void
* @param Set<ID>
*/   
    public static void updateapplicationdocument(Set<ID> programmeId){
        List<IB_Application_Attachment__c> attachments = new List<IB_Application_Attachment__c>();
        attachments = [Select id,Name,Event_Cancelled_Postponed__c,Unit_Plan__c,Attachment__c,Type__c,BQC_Subject__c from IB_Application_Attachment__c where IB_Programme__c IN: programmeId AND (Type__c = 'Unit Plan' OR Type__c = 'Self-assessment')];
        for(IB_Application_Attachment__c attachment:attachments){
            attachment.Event_Cancelled_Postponed__c = true;
        }
        update attachments;
    }
    public static void Ready_for_Review(Set<Campaign> Event_set, string senior_reviewer){
        try{
            List<Campaign> Event_list = new List<Campaign>(Event_set);
            List<ID> campaign_ids =   getcampaignids(Event_list,false);
            List<My_Staffing_Event__c> my_staffing_event_list = [Select id,IB_Role_Name__c,BQC_School_Reviewer_Notify__c,BQC_Senior_Reviewer_Notify__c from My_Staffing_Event__c where Application_Status__c = 'Confirmed' 
                                                                 AND IB_Event__c IN :campaign_ids AND ((BQC_Senior_Reviewer_Notify__c=false AND IB_Role_Name__c = 'Building Quality Curriculum Senior Reviewer')
                                                                                                       OR (BQC_School_Reviewer_Notify__c = false AND IB_Role_Name__c = 'Building Quality Curriculum School Reviewer')
                                                                                                       OR (BQC_Reviewer_Notify__c = false AND IB_Role_Name__c = 'Building Quality Curriculum Reviewer' ))];
            List<My_Staffing_Event__c> mystaffingevent_needtoupdate = new List<My_Staffing_Event__c>();
            System.debug('Staffing Event: '+my_staffing_event_list.size());
            if(my_staffing_event_list.size() >0){
                for(Campaign camp_record:Event_list){
                    for(My_Staffing_Event__c my_staffing_event_record:my_staffing_event_list){
                        
                        if(senior_reviewer == 'BQC Senior Reviewer' && my_staffing_event_record.IB_Role_Name__c == 'Building Quality Curriculum Senior Reviewer'){
                            System.debug('Senior Reviewer');
                            my_staffing_event_record.BQC_Senior_Reviewer_Notify__c = true;
                        }
                        else if(senior_reviewer == 'BQC School Reviewer' && my_staffing_event_record.IB_Role_Name__c == 'Building Quality Curriculum School Reviewer'){
                            System.debug('School Reviewer');
                            my_staffing_event_record.BQC_School_Reviewer_Notify__c = true;
                        }
                        else if(senior_reviewer == 'BQC Reviewer' && my_staffing_event_record.IB_Role_Name__c == 'Building Quality Curriculum Reviewer'  ){
                            System.debug('Reviewer');
                            my_staffing_event_record.BQC_Reviewer_Notify__c = true;
                        }
                        mystaffingevent_needtoupdate.add(my_staffing_event_record);
                    }
                }
            }
            update mystaffingevent_needtoupdate;
            isAlreadyExecutedReadyforSRReview = true;
        }   
        catch(Exception ex){
            System.debug('Exception: '+ex);
            isAlreadyExecutedReadyforSRReview = false;
        }
    }
    
    
}