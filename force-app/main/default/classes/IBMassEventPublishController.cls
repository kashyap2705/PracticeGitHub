/*-
* This class is -----
* Modified line 30 by Vikranth for EMS Project D30-08-2023
* Modified by Tarun Sharma for INC0196393
* Modified Description - updated SOQL in getIbEvents
*/
public class IBMassEventPublishController {
    
    public List<Campaign> events { get; set; }
    private String eventRegion = getEventRegion();
    
    public IBMassEventPublishController() {
        events = getIbEvents();
    }
    
    public String getEventRegion() {
        return eventRegion;
    }
            
    public void setEventRegion(String eventRegion) {
        this.eventRegion = eventRegion;
    }
    
    public List<Campaign> getIbEvents() {
        //INC0196393-- START - Added Campaign_Record_Type_Flow__c,Traing_Event_Published__c and added OR condition to support Requested_Workshop & Scheduled_Workshop
        List<Campaign> ibEvents = [
            SELECT Id, Name, Status, StartDate,Campaign_Record_Type_Flow__c,Traing_Event_Published__c,Workshop_Programme__c ,NumberSent,Workshop_Event_City_del__c,Workshop_Event_Country_del__c, IB_Event_Record_Type__c,IB_Programme_c__c, Account_Region__c, EndDate, CreatedDate, Staffing_Event_Published__c, (SELECT Name FROM IB_Event_Roles__r)
            FROM Campaign
            WHERE Staffing_Event_Published__c = FALSE
            AND Traing_Event_Published__c = FALSE
            AND NumberSent>0
            AND (IB_Event_Record_Type__c IN ('Blended Workshop','Cluster Workshop','In School Workshop','Regional Workshop','Authorization','Evaluation','Regional Event','IBEN Training') OR Campaign_Record_Type_Flow__c IN ('Requested_Workshop','Scheduled_Workshop') )
            AND StartDate >= TODAY 
            AND Status IN ('Planned / Ready for Staffing') 
            AND Account_Region__c = :eventRegion
            order by CreatedDate desc        
        ];
        
        Integer x = 0;
        while (x < ibEvents.size()) {
           
                x++;
            
        }
        
        return ibEvents;
        
    }
    
    public List<SelectOption> getEventRegions() {
        
        List<SelectOption> options = new List<SelectOption>();
        List<String> eventsList = new List<String> {'IBAEM','IBA','IBAP'};

        for (String y : eventsList) {
            options.add(new SelectOption(y, y));
        }

        //options.sort();
        return options;

    }
    
    public PageReference filter() {
        events = getIbEvents();
         PageReference home = new PageReference('/apex/IBMassEventPublish');
        home.setRedirect(false);
        return home;

      //  return null;
    }
    
    public PageReference publish() {

        
        List<Campaign> eventsToUpdate = new List<Campaign>();
        for(Campaign c:events){
            if (c.Staffing_Event_Published__c == true)
                eventsToUpdate.add(c);
        }
        update eventsToUpdate;

        events = getIbEvents();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Events updated successfully.'));

        PageReference home = new PageReference('/apex/IBMassEventPublish');
        home.setRedirect(false);

        return home;

    }
    
    

}