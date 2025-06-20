/* ---------------------------------------------------------------------------------------
Document        :  CR 3806 (8) Batch of Reader Events
Author          :  Syed Jameel 
Description     :  To bind / unbind the child events to the Parent Event
---------------------------------------------------------------------------------------- */
public with sharing class IBEventControllerCls {
    public Campaign campgn{get;set;}                // event instance to get the records
    public list<wrapper> wrappList{get;set;}        // wrapper list to bind the boolean and event object
    public List<SelectOption> options{get;set;}     // Event sub type select options
    //public List<SelectOption> prgOptions{get;set;}  // Event releted program select options
    public List<SelectOption> langOptions{get;set;} // Event language select options
    public List<SelectOption> subOptions{get;set;}
    public string subTypeSelected{get;set;}         // Event sub type selected
    public string languageSelected{get;set;}        // Event language selected
    public string subjectSelected{get;set;}         // Event subject selected
    public string type{get;set;}                    // To check type bundle or unbundle.
    public boolean validateFlag{get;set;}           // To show page message if related Progrmme not selected
    public string relatedProgSelected{get;set;}     // To search /retrieve the Related Program records
    //public string venueAccount{get;set;}          // Event Venue Account selected
    
    public IBEventControllerCls(ApexPages.StandardController controller) {
        type = apexpages.currentpage().getparameters().get('type');
        campgn = (Campaign)controller.getrecord();        
        wrappList = new list<wrapper>();    
        options =  new List<SelectOption>();    
        options.add(new selectOption('None','--- None ---')); 
        //prgOptions =  new List<SelectOption>();    
        //prgOptions.add(new selectOption('None','--- None ---')); 
        langOptions =  new List<SelectOption>();    
        langOptions.add(new selectOption('None','--- None ---')); 
        subOptions =  new List<SelectOption>();    
        subOptions.add(new selectOption('None','--- None ---'));    
        Schema.DescribeFieldResult fieldResult = Campaign.Sub_Type__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:ple)    
        {    
            
            if(f.getLabel() == 'Request for Candidacy' || f.getLabel() == 'Request for Authorization' ||  f.getLabel() == 'Evaluation Reading' || f.getLabel() == 'Course Outline Reading'){
                options.add(new selectOption(f.getLabel(),f.getValue()));    
            }                
        }
        
        /*Schema.DescribeFieldResult langfieldResult = Account.Language_Of_Correspondance__c .getDescribe();    
        List<Schema.picklistEntry> langList = langfieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:langList )    
        {    
            langOptions.add(new selectOption(f.getLabel(),f.getValue()));                    
        }*/
        langOptions.add(new selectOption('English','English'));
        langOptions.add(new selectOption('Spanish','Spanish'));
        langOptions.add(new selectOption('French','French'));
        langOptions.add(new selectOption('German','German'));
        langOptions.add(new selectOption('Japanese','Japanese'));
        /* code commented as requested to add serach filter instead of Options
        Schema.DescribeFieldResult progResult = Campaign.IB_Programme__c.getDescribe();    
        List<Schema.picklistEntry> progLst = progResult.getPicklistValues();    
        for(Schema.picklistEntry f:progLst)    
        {    
        prgOptions.add(new selectOption(f.getLabel(),f.getValue()));                    
        } */ 
        string parentEvent = apexpages.currentpage().getparameters().get('id');
        string query;
        system.debug('===parent language==='+campgn.Event_Language__c);
        if(campgn.status =='Complete'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info,'Child Events cannot be bundled/unbundled as Parent Event status is complete '));
        }
        else if(apexpages.currentpage().getparameters().get('type') == 'unBind' && string.isNotBlank(parentEvent)){
            query = 'SELECT id,Name,IB_Programme__c, Event_Language__c, IB_Subject__r.Subject_Name__c, IB_Subject__r.Name, Related_IB_Programme__c, Related_IB_Programme__r.name, Sub_Type__c, StartDate, EndDate from Campaign where ParentId=:parentEvent And Bundle__c=true';
            try{
                list<Campaign> childEvents = database.query(query);
                if(!childEvents.isEmpty()){
                    for(Campaign cmp :childEvents ){
                        wrappList.add(new wrapper(cmp));
                    }
                }
            }catch(exception e){
                apexpages.addmessages(e);
            }
        }
        
    }
    // *** Method to get the Child Events based on the selection criteria and type of binding (bind / unbind)
    public pagereference getChildEvents(){
        
        wrappList = new list<wrapper>();
        string parentEvent = apexpages.currentpage().getparameters().get('id');
        string type = apexpages.currentpage().getparameters().get('type');       
        string subject = campgn.IB_Subject__c;
        string relatedProgram;
        string query;
        string schoolgroup = campgn.Group_of_School__c;
        string WorkShopVenueRegion = apexpages.currentpage().getparameters().get('venueRegion');
        string stdt = apexpages.currentpage().getparameters().get('stdt');
        string endt = apexpages.currentpage().getparameters().get('endt');        
        date startDt = date.parse(stdt);
        date endDt = date.parse(endt);
        string strStartDate = string.valueof(startDt.year());
        string strEndDate = string.valueof(endDt.year());
        if(string.valueof(startDt.month()).length()==1)
            strStartDate = strStartDate+'-0'+startDt.month();
        else if(string.valueof(startDt.month()).length()==2)
            strStartDate= strStartDate+'-'+startDt.month(); 
        if(string.valueof(startDt.day()).length()==1)
            strStartDate= strStartDate+'-0'+startDt.day();
        else if(string.valueof(startDt.day()).length()==2)
            strStartDate= strStartDate+'-'+startDt.day();            
        if(string.valueof(endDt.month()).length()==1)
            strEndDate= strEndDate+'-0'+endDt.month();
        else if(string.valueof(endDt.month()).length()==2)
            strEndDate= strEndDate+'-'+endDt.month(); 
        if(string.valueof(endDt.day()).length()==1)
            strEndDate= strEndDate+'-0'+endDt.day();
        else if(string.valueof(endDt.day()).length()==2)
            strEndDate= strEndDate+'-'+endDt.day();    
        
        if(type == 'Bind')
        {
            //query = 'SELECT id,Name,type,Event_Language__c ,Venue_Account__r.Group_of_School_Name__c,IB_Subject__r.Subject_Name__c,startdate,enddate,Workshop_Event_Region__c,Group_of_School__c,IB_Subject__c, IB_Subject__r.name ,IB_Programme__c,Related_IB_Programme__c,Related_IB_Programme__r.name,subject__c,Sub_Type__c,Venue_Account__c,Venue_Account__r.Group_of_School__c from Campaign where Bundle__c=false AND status=\'Pending\'' + ' And (recordtype.name=\'Authorization\' OR recordtype.name=\'Evaluation\')' + ' And (type=\'Authorization\' OR type=\'Evaluation\')'+ ' And (Sub_Type__c=\'Request for Candidacy\' OR Sub_Type__c=\'Request for Authorization\' OR Sub_Type__c=\'Evaluation Reading\' OR Sub_Type__c=\'Course Outline Reading\')';
            query = 'SELECT id,Name,type,Event_Language__c ,IB_Subject__r.Subject_Name__c,startdate,enddate,Workshop_Event_Region__c,Group_of_School__c,IB_Subject__c, IB_Subject__r.name ,IB_Programme__c,Related_IB_Programme__c,Related_IB_Programme__r.name,Sub_Type__c,Venue_Account__c,Venue_Account__r.Group_of_School__c from Campaign where Bundle__c=false AND status=\'Pending\'' + ' And (recordtype.name=\'Authorization\' OR recordtype.name=\'Evaluation\')' + ' And (type=\'Authorization\' OR type=\'Evaluation\')'+ ' And (Sub_Type__c=\'Request for Candidacy\' OR Sub_Type__c=\'Request for Authorization\' OR Sub_Type__c=\'Evaluation Reading\' OR Sub_Type__c=\'Course Outline Reading\')';
         }
        else if(type == 'unBind')
        {     
           //query = 'SELECT id,Name,Event_Language__c ,Group_of_School__c, Venue_Account__r.Group_of_School_Name__c,IB_Subject__r.Subject_Name__c,IB_Subject__r.name, IB_Programme__c,Related_IB_Programme__c,Related_IB_Programme__r.name,subject__c,Sub_Type__c from Campaign where ParentId=:parentEvent And Bundle__c=true';
           query = 'SELECT id,Name,Event_Language__c,Group_of_School__c,IB_Subject__r.Subject_Name__c,IB_Subject__r.name, IB_Programme__c,Related_IB_Programme__c,Related_IB_Programme__r.name,Sub_Type__c from Campaign where ParentId=:parentEvent And Bundle__c=true';
        }    
        if(string.isNotBlank(relatedProgSelected ))
        {
            relatedProgram = '%'+relatedProgSelected+'%';         
            query = query + ' And Related_IB_Programme__r.Name like:relatedProgram';
        }        
        if(languageSelected != 'None')
            query = query + ' And Event_Language__c=:languageSelected';        
        if(subTypeSelected != 'None' )
            query = query + ' And sub_Type__c=:subTypeSelected';       
        if(string.isNotBlank(subject))                   
            query = query + ' And IB_Subject__c=:subject';
        if(string.isNotBlank(schoolgroup)){                 
            query = query + ' And Venue_Account__r.Group_of_School__c=:schoolgroup';                 
            system.debug('----schoolgroup / query ------->'+schoolgroup +'*******'+query);
        }
        if(string.isNotBlank(WorkShopVenueRegion)){
            query = query + ' And Workshop_Event_Region__c=:WorkShopVenueRegion'; 
        }
        if(string.isNotBlank(strStartDate) && string.isNotBlank(strEndDate)){
            query = query + ' And startDate>= ' + strStartDate; 
            query = query + ' And endDate<= ' + strEndDate;
            system.debug('===query Date Filter==='+query);
        } 
        try{
            list<Campaign> childEvents = database.query(query);
            system.debug('---events------->'+childEvents);
            
            if(!childEvents.isEmpty()){
                for(Campaign cmp :childEvents ){
                    wrappList.add(new wrapper(cmp));
                }
            }
        }catch(exception e){
            apexpages.addmessages(e);
        }
        
        return null;
    }
    // ***Method to Connect / Disconnect the selected child events to / from Parent Event.
    public pagereference save(){
        
        list<Campaign> childEvents = new list<Campaign>();
        string parentEvent = apexpages.currentpage().getparameters().get('id');
        string type = apexpages.currentpage().getparameters().get('type');
        Set<Id> eventIdsToUnBind = new Set<Id>();
        for(wrapper wp :wrappList)
        {
            if (wp.check == true  ) {
                if (type  =='Bind') {
                    if (campgn.Event_Language__c == null) {
                        wp.cmpn.ParentId = parentEvent ;
                        wp.cmpn.Bundle__c = true;
                        childEvents.add(wp.cmpn);
                        campgn.Event_Language_Override__c = wp.cmpn.Event_Language__c;
                    }
                    else {
                        if (campgn.Event_Language__c == wp.cmpn.Event_Language__c) {
                            wp.cmpn.ParentId = parentEvent ;
                            wp.cmpn.Bundle__c = true;
                            childEvents.add(wp.cmpn);
                        }
                        else {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error,'The Child Event language does not match the parent event language.'));
                            return null;
                        }
                    }
                }
                else if (type =='unBind') {
                    system.debug('curEvent: ' + wp.cmpn);
                    wp.cmpn.ParentId = null;
                    wp.cmpn.Bundle__c =false;
                    wp.cmpn.Status = 'Pending';
                    childEvents.add(wp.cmpn);
                }
            }
        }        
        
        if(!childEvents.isEmpty()){
            try{
                update childEvents; 
                update campgn;
            }
            catch(exception e){
                apexpages.addmessages(e);
            }       
        } 

        return new pagereference('/'+parentEvent);
    }
    // ***Method to navigate back to the Parent Event record     
    public pagereference cancel(){        
        return new pagereference('/'+apexpages.currentpage().getparameters().get('id'));
    }
    
    // ***wrapper class to bind the boolean type and event object.
    public class wrapper{
        public boolean check{get;set;}
        public Campaign cmpn{get;set;}
        public wrapper(Campaign cmp){
            this.check = false;
            this.cmpn = cmp;    
        }
    }
}