/*-
* This class is handling Future methods for IB Event Object
* @author Junaid Iqbal
* Added line 29 changes made by Vikranth for EMS Project D30-08-2023
*/
public class IBEventPublishedFuture {
    
    // Future method is executed or not
    public static boolean isAlreadyExecuted = false;
    public static boolean isAlreadyExecuted2 = false;
    public static boolean isAlreadyExecutedcor = false;
    public static boolean isAlreadyExecutedcor2 = false;
    
    
    
    //Future method publishing the IB-Event record.
    @Future
    public static void publishIBEvent(list<Id> ibEventID) {
        //Fetching data of IB Event with respect to ID
        List<Campaign> camp = [SELECT name, Status, IB_Event_Record_Type__c, Sub_Type__c, Staffing_Event_Published__c FROM Campaign WHERE Id in: ibEventID];
        for(Campaign c : camp) {
            //This condition is being updated by Ammara-Plumlogix,as part of US-11580,US-11930,L&T Project and US-11565 on 06/11/2020
            //Begin
            if(c.Status == 'Planned / Ready for Staffing' ) {
                if (c.IB_Event_Record_Type__c == 'IBEN Training'
                    || c.IB_Event_Record_Type__c == 'Cluster Workshop'
                    || c.IB_Event_Record_Type__c == 'In School Workshop'
                    || c.IB_Event_Record_Type__c == 'Learning and Teaching Programme Development'
                    || c.IB_Event_Record_Type__c == IBConstants.REQUESTED_WORKSHOP  //Added by Vikranth for EMS Project
                    || c.Sub_Type__c == 'Candidacy Consultation'
                    || c.Sub_Type__c == 'Request for authorization'
                    || c.Sub_Type__c == 'Course Outline Reading'
                    ||c.Sub_Type__c == 'Request for Candidacy')//End
                    
                {
                    if(c.IB_Event_Record_Type__c == 'Learning and Teaching Programme Development')
                        c.Workshop_Event_Region_del__c = 'IBAEM	';
                    
                    if(c.Staffing_Event_Published__c != TRUE) {
                        c.Staffing_Event_Published__c = true;
                        try {
                            //method is executed
                            isAlreadyExecuted = True;
                            //updating record with Staffing_Event_Published__c = true
                            //UPDATE c;
                        } Catch(Exception e) {
                            system.debug('Jarvis Log Exception: '+e);
                        }
                    }
                }
            }          
        }
        try {
            //method is executed
            //  isAlreadyExecuted = True;
            //updating record with Staffing_Event_Published__c = true
            UPDATE camp;
        } Catch(Exception e) {
            system.debug('Jarvis Log Exception: '+e);
        }
        
    }
    
    //function update status, start and end date if decision on candidacy is accepted and event type is Candidacy Consultation
    public void status_and_date_automation(IB_Programme__c prog) {
        
        //List reterive related IB Programme data
        List <campaign> cammp=[select StartDate , EndDate,sub_type__c, status from campaign where  Related_IB_Programme__c=:prog.id ];
        List <campaign> cammp1 = new list<campaign>();
        for(campaign camp:cammp){
            
            //Check decision on candidacy is accepted and event type is Candidacy Consultation
            if(camp.sub_type__c == 'Candidacy Consultation' && prog.StageName__c == 'Consultation process' && prog.Status__c == 'Candidate' && prog.Sub_Stage__c == 'Candidacy Approved' && camp.Status == 'Staffed-Pending L1') {
                camp.StartDate = date.today();
                camp.EndDate = date.today()+365;
                camp.Status = 'Staffed';
                
                cammp1.add(camp);
            }
            
        }
        isAlreadyExecuted2 = true;
        //update campaign record
        update cammp1;
        
    }
    
    
    
    public static void updateCORStatus(ID prog,ID subj )
    {
        
        list<Course_outline_reading__c> ReadingEvents = [select Status__c from Course_outline_reading__c where Programme__r.id =:prog AND Subject_Id__c=:subj];
        for(Course_outline_reading__c cor :ReadingEvents)
        {
            cor.status__c = 'Submitted';
            
        }
        
        update ReadingEvents;
    }
    
}