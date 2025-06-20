public class IBActivity{
    
    public String Table {get; set;}
    public String Id {get; set;}
    public String ListColor {get;set;}
    public String ApplicationStatus {get; set;}  //Assignments, Training
    public Date EndDate {get; set;}
    public String EndDateString {get;set;}
    public String IBContact {get; set;}
    public String IBRoleName {get; set;}
    public String Programme_fr {get; set;}
    public String Programme_sp {get; set;}
    public String Programme {get; set;}
    public String RecordType {get; set;}
    public String case_id {get;set;}
    // this code is edited by developer Ali Haider Bajwa-plumlogix for user story 11741 of staff aug project
    // start
    public String Audience {get; set;}
    //end
    //                <!--// this code is edited by developer Ali Haider Bajwa-plumlogix for user story 12160 of staff aug project-->
    //                start
    
    public String RecordTypeName {get; set;}
    public String IBDocsID {get; set;}
    public String SubType{get; set;}
    public String Type{get; set;}
    public String EventLanguage{get; set;}
    public String ProgrammeCombinationEvaluationVisits{get; set;}
    public Date StartDate {get; set;}
    public String StartDateString {get;set;}
    //end
    public String EventId {get; set;}
    public String EventCity {get; set;}
    public String EventState {get; set;}
    public String EventCountry {get; set;}
    public String EventSubregion {get; set;}
    public String EventRegion {get; set;}
    public String EventVenue {get; set;}
    public String EventName {get; set;}
    public String EventSubject {get; set;}
    public String EventCategory {get; set;}
    public String EventLanguage1 {get; set;}
    public String EventLanguage2 {get; set;}
    public String LanguageOfDelivery {get; set;}
    public String DeliveryMode {get; set;}
    //public String EventOrganizer {get; set;}
    public String RoleName {get; set;}
    public Integer PositionsLeft {get; set;}
    public String eventOrganizerAccount {get; set;} // added by kashyap as a part of ECM00524 to display Event Organizer Account 
    public String PrgRelationshipManager {get; set;} // added by Suraj as a part of ECM00651 to display PRM 
    public String PreliminaryReviewEndDateString {get;set;}// added by kashyap as a part of phase 3 754
    public String PreliminaryReviewStartDateString {get;set;}// added by kashyap as a part of phase 3 754
    
    
    public static List<IB_Data_Translate__c> translations = [
        SELECT Id, Name, Record_ID__c, Object_Name__c, Locale__c, Translate_Value_1__c, Translate_Value_2__c 
        FROM IB_Data_Translate__c 
        WHERE Object_Name__c = 'IBActivity'
        AND Locale__c = :UserInfo.getLanguage()
    ];
    
    public static Map<String,String> translationMap{
        get{
            if(translationMap == null){
                translationMap = new Map<String,String>();
                for(IB_Data_Translate__c ibdt:translations){
                    translationMap.put(ibdt.Record_ID__c,ibdt.Translate_Value_1__c);
                }
            }
            return translationMap;
        }
        set;
    }
    
    public void IBActivity(){
        RecordType='';
        Table = '';
        Id = '';
        ApplicationStatus = '';
        EndDate = null;
        EndDateString = '';
        IBRoleName = '';
        Programme = '';
        StartDate = null;
        StartDateString = '';
        EventId = '';
        EventCity = '';
        EventCountry = '';
        EventSubregion = '';
        EventRegion = '';
        EventVenue = '';
        EventName = '';
        EventSubject = '';
        EventCategory = '';
        EventLanguage1 = '';
        EventLanguage2 = '';
        //EventOrganizer = '';
        PositionsLeft = 0;
        
    }
    
    public static String removeInvalidChars(String myString){
        myString = myString.replaceAll('\'', '');
        return myString;
    }
    
    public static List<IBActivity> convertCamapign(List<Campaign> eventList){
        
        List<IBActivity> activityList= new List<IBActivity> ();
        for(Campaign cmp:eventList){
          IBActivity activity = new IBActivity();
        
        	activity.EndDate = cmp.EndDate;
            activity.startDate = cmp.StartDate;
            activity.EventName = cmp.Name;
            
				activityList.add(activity);        
            
        }
        
        return activityList;
            
        
    }
    
    /** Added newly by kashyap as a part of 754 phase -3 **/
    public static List<IBActivity> publishedStaffingEvent(List<Staffing_Event__c> publishedStaffingEventList){
        
        List<IBActivity> activityList= new List<IBActivity> ();
        for(Staffing_Event__c staffingEvent:publishedStaffingEventList){
          IBActivity activity = new IBActivity();
        
        	activity.EndDate = staffingEvent.End_Date__c;
            activity.startDate = staffingEvent.Start_Date__c;
            activity.EventName = staffingEvent.IB_Event__r.Name;
            activity.EventId=  staffingEvent.Id;
            
            
            
            
            
         List<String> roleNames = new List<String>();
        for(IB_Event_Role__c role : staffingEvent.IB_Event_Roles__r){
            switch on UserInfo.getLanguage() {
                when 'fr' {     // when block 1
                    roleNames.add(role.IB_Role_Name_fr__c);
                }   
                when 'es' {     // when block 2
                    roleNames.add(role.IB_Role_Name_es__c);
                }
                
                when else {       // default block, optional
                    roleNames.add(role.IB_Role_Name__c);     
                }
            }
        }        
         activity.IBRoleName='';
        Integer i = 1;
        for(String role : roleNames){
            activity.IBRoleName += role;
            if(i < roleNames.size()){
                activity.IBRoleName += ', ';
            }
            i++;
        }
            
            
				activityList.add(activity);        
            
        }
        
        return activityList;
            
        
    }
    
     /** Added newly by kashyap as a part of 754 phase -3 **/
    
    
    public static IBActivity convertAssignment(My_Staffing_Event__c assignment){
        IBActivity activity = new IBActivity();
        activity.Table = 'My_Staffing_Event__c';
        activity.Id = assignment.Id;
        
       /** added by kashyap as a part of phase 3 754**/
        if(assignment.IB_Event__r.Preliminary_Review_End_Date__c != null){
        
        activity.PreliminaryReviewEndDateString =assignment.IB_Event__r.Preliminary_Review_End_Date__c.format() ;
        }
        if(assignment.IB_Event__r.Preliminary_Review_Start_Date__c != null){
        activity.PreliminaryReviewStartDateString=assignment.IB_Event__r.Preliminary_Review_Start_Date__c.format() ;
        }
        activity.RecordTypeName= assignment.IB_Event__r.recordtype.name;
         /** added by kashyap as a part of phase 3 754**/
        
        
        activity.ApplicationStatus = assignment.Application_Status__c;
        activity.EndDate = assignment.End_Date__c;
        try{
            activity.EndDateString = assignment.End_Date__c.format();
        } catch (Exception e){
            activity.EndDateString = '';
        }
     /*   if(UserInfo.getLanguage() == 'fr'){
            activity.IBRoleName = assignment.IB_Event_Role__r.IB_Role_Name_fr__c;
            
        }else if(UserInfo.getLanguage() == 'es'){
            activity.IBRoleName = assignment.IB_Event_Role__r.IB_Role_Name_es__c;
            
        }else {
            activity.IBRoleName = assignment.IB_Event_Role__r.IB_Role_Name__c;
            
        }*/
        switch on UserInfo.getLanguage() {
            when 'fr' {     // when block 1
            activity.IBRoleName = assignment.IB_Event_Role__r.IB_Role_Name_fr__c;
            }   
            when 'es' {     // when block 2
            activity.IBRoleName = assignment.IB_Event_Role__r.IB_Role_Name_es__c;
            }
         
            when else {       // default block, optional
                activity.IBRoleName = assignment.IB_Role_Name__c;     
            }
        }
        activity.Programme = assignment.Programme_From_Event_Role__c;
        // activity.Audience = assignment.IB_Event__r.Audience__c;
        activity.StartDate = assignment.Start_Date__c;
        try{
            activity.StartDateString = assignment.Start_Date__c.format();
        } catch(Exception e){
            activity.StartDateString = '';
        }
        activity.EventId = assignment.Staffing_Event__c;
        activity.EventCity = assignment.Staffing_Event_City__c;
        //Following Line is added by plumlogix For ECM 477
        activity.IBDocsID=assignment.IB_Event_Role__r.PSP__c;
        activity.EventCountry = assignment.Staffing_Event_Country__c;
        activity.EventRegion = assignment.Staffing_Event_Region__c;
        activity.EventName = assignment.Staffing_Event__r.Name;
        
        
        //activity.EventOrganizer = assignment.Staffing_Event_Organizer__c;
        
        /*if(assignment.IB_Event_Role__r.Proposed_Language__c == 'French'){
activity.languageOfDelivery = 'Française';
} else if(assignment.IB_Event_Role__r.Proposed_Language__c == 'Spanish'){
activity.languageOfDelivery = 'Español';
} else if(assignment.IB_Event_Role__r.Proposed_Language__c == 'Spanish'){
activity.languageOfDelivery = assignment.IB_Event_Role__r.Proposed_Language__c;
} 
*/
        /* if(assignment.IB_Event_Role__r.Proposed_Language__c != null){
activity.languageOfDelivery = 'Language of delivery -' + assignment.IB_Event_Role__r.Proposed_Language__c;    */
        
        try{
            activity.languageOfDelivery = assignment.IB_Event_Role__r.Proposed_Language__c;
        } catch (Exception e){
            activity.languageOfDelivery = '';
        }
        activity = translateIBActivity(activity);
        activity.languageOfDelivery = Label.IBENPortal_LanguageOfDelivery + ' ' + activity.languageOfDelivery;
        
        try{
            activity.deliveryMode = assignment.IB_Event__r.Delivery_Mode__c;// added by Atticus as a part of ECM00508 
            //Following Line is added by plumlogix For ECM 477
            activity.IBDocsID = 'PSP '+assignment.IB_Event_Role__r.PSP__c;
            System.debug('IBDocsID ECM477: '+assignment.IB_Event_Role__r.PSP__c);
            System.debug('Delievery Mode 1: '+assignment.IB_Event_Role__r.delivery_Mode__c);
            System.debug('Delievery Mode 2: '+assignment.IB_Event_Role__c);
            System.debug('Delievery Mode 3: '+activity.deliveryMode);
        } catch (Exception e){
            System.debug('Delievery Mode Ex: '+assignment.IB_Event_Role__r.delivery_Mode__c);
            System.debug('Delievery Mode Ex: '+assignment.IB_Event_Role__c);
            System.debug('Delievery Mode Ex: '+e);
            activity.deliveryMode='';
        }
        /* if(activity.deliveryMode == Null)
activity.deliveryMode='';*/
        activity = translateIBActivity(activity);
        activity.deliveryMode = Label.IBENPortal_DeliveryMode + ' ' + activity.deliveryMode;
        
        activity = translateIBActivity(activity);
        return activity;
        
    }
    
    
    //Following Function is added by Shehryar-plumlogix in Sprint 22 on 06/10/2021 
    //Start
    public static IBActivity convertCase(Case assignment){
        IBActivity activity = new IBActivity();
        activity.Table = 'Case';
        activity.Id = assignment.Id;
        activity.case_id=assignment.Subject;
        
        
        activity.RecordType=assignment.RecordType.Name;
        System.debug('record type'+assignment.RecordType.Name);
        // this code is edited by developer Ali HAider Bajwa-plumlogix forECM00379 of staff aug project
        // start
        system.debug('RecordTypeId'+assignment.RecordTypeId);
        if(assignment.RecordType.Name == 'SIPGE Request')
        {
            
            
            if(assignment.Examiner_1__c != null && (assignment.Examiner_1_Review_Status__c == 'In-Progress' || assignment.Examiner_1_Review_Status__c ==  'En marcha' || assignment.Examiner_1_Review_Status__c ==  'En cours')){
                if(assignment.Examiner_1_Start_Date__c != null)
                    activity.StartDateString = assignment.Examiner_1_Start_Date__c.format();
                activity.ApplicationStatus = assignment.Examiner_1_Review_Status__c;        
            }
            if(assignment.Examiner_2__c != null && (assignment.Examiner_2_Review_Status__c == 'In-Progress'|| assignment.Examiner_2_Review_Status__c == 'En marcha' || assignment.Examiner_2_Review_Status__c == 'En cours') ){
                if(assignment.Examiner_2_Start_Date__c != null)
                    activity.StartDateString = assignment.Examiner_2_Start_Date__c.format();
                activity.ApplicationStatus = assignment.Examiner_2_Review_Status__c;        
            }
            
            
            
            /* if(activity.deliveryMode == Null)
activity.deliveryMode='';*/
            //   activity = translateIBActivity(activity);
            //  activity.deliveryMode = Label.IBENPortal_DeliveryMode + ' ' + activity.deliveryMode;
            
            //  activity = translateIBActivity(activity);
            
        }
        else if(assignment.RecordType.Name  =='PGQA')
        {
            if(assignment.PGQA_Examiner_1__c != null && (assignment.PGQA_Examiner_1_Review_Status__c == 'In-Progress' || assignment.PGQA_Examiner_1_Review_Status__c ==  'En marcha' || assignment.PGQA_Examiner_1_Review_Status__c ==  'En cours')){
                if(assignment.PGQA_Examiner_1_Start_Date__c != null)
                    activity.StartDateString = assignment.PGQA_Examiner_1_Start_Date__c.format();
                activity.ApplicationStatus = assignment.PGQA_Examiner_1_Review_Status__c;        
            }
            if(assignment.PGQA_Examiner_2__c != null && (assignment.PGQA_Examiner_2_Review_Status__c == 'In-Progress'|| assignment.PGQA_Examiner_2_Review_Status__c == 'En marcha' || assignment.PGQA_Examiner_2_Review_Status__c == 'En cours') ){
                if(assignment.PGQA_Examiner_2_Review_Status__c != null)
                    activity.StartDateString = assignment.PGQA_Examiner_2_Start_Date__c.format();
                activity.ApplicationStatus = assignment.PGQA_Examiner_2_Review_Status__c;
                activity.RecordType='PGQA';
            }
            //end
            
            /* if(activity.deliveryMode == Null)
activity.deliveryMode='';*/
            //   activity = translateIBActivity(activity);
            //  activity.deliveryMode = Label.IBENPortal_DeliveryMode + ' ' + activity.deliveryMode;
            
            //  activity = translateIBActivity(activity);
            
        }
        return activity;
    }
    
    
    //End
    
    public static IBActivity convertEligAssignment(Staffing_Event__c eligAssignment){
        IBActivity activity = new IBActivity();
        
        activity.ApplicationStatus = Label.IBENPortal_shared_NotApplied;  //use as default status
        activity.Table = 'Staffing_Event__c';
        activity.Id = eligAssignment.Id;
        activity.EndDate = eligAssignment.End_Date__c;
        try{
            activity.EndDateString = eligAssignment.End_Date__c.format();
        } catch(Exception e){
            activity.EndDateString = '';
        }
        activity.Programme = eligAssignment.Programme_s__c;
        activity.StartDate = eligAssignment.Start_Date__c;  
        try{
            activity.StartDateString = eligAssignment.Start_Date__c.format();   
        } catch (Exception e){
            activity.StartDateString = '';
        }
        activity.EventId = eligAssignment.Id;
        activity.EventCity = eligAssignment.Staffing_Event_City__c;
        //Following Line is added by plumlogix For ECM 477 - added exception handling ben mcgarvey inc0188648
        try{
            activity.IBDocsID='PSP '+eligAssignment.IB_Event__r.IB_Docs_ID__c;
        }catch (Exception e){
            System.debug('Prevented exception, IBDocsId value left blank' + e);
            activity.IBDocsID='';
        }
        activity.EventCountry = eligAssignment.Staffing_Event_Country__c;
        activity.EventRegion = eligAssignment.Staffing_Event_Region__c;
        activity.EventName = eligAssignment.Name;
        //activity.EventName = eligAssignment.Staffing_Event_Organizer__c;
        activity.IBRoleName = '';
        
        /** Added by Kashyap as part of ECM 00524 for eligible assignments which are Not Applied Added exception handling Ben McGarvey**/
        try{
            activity.languageOfDelivery=Label.IBENPortal_LanguageOfDelivery + ' ' + eligAssignment.IB_Event__r.Event_Language__c;
         }catch (Exception e){
            activity.languageOfDelivery='';
            System.debug('Prevented exception, LanguageOfDelivery value left blank' + e);
         }
         try{
            activity.deliveryMode=Label.IBENPortal_DeliveryMode + ' ' +eligAssignment.IB_Event__r.delivery_Mode__c;
         }catch (Exception e){
            activity.deliveryMode='';
            System.debug('Prevented exception, Deliverymode value left blank' + e);
         }
        /** end of Added by Kashyap for eligible assignments**/
        
       
        /** added by kashyap as a part of phase 3 754**/
        if(eligAssignment.IB_Event__r.Preliminary_Review_End_Date__c!= null){
        activity.PreliminaryReviewEndDateString=eligAssignment.IB_Event__r.Preliminary_Review_End_Date__c.format();
        }
        if(eligAssignment.IB_Event__r.Preliminary_Review_Start_Date__c != null){
        activity.PreliminaryReviewStartDateString=eligAssignment.IB_Event__r.Preliminary_Review_Start_Date__c.format();
        }
         activity.RecordTypeName= eligAssignment.IB_Event__r.recordtype.name;
        /** added by kashyap as a part of phase 3 754**/
        
        
        //Added by Suraj as part of ECM00651 START
        activity.PrgRelationshipManager=eligAssignment.IB_Event__r.Programme_Relationship_Manager__c;
        //Added by Suraj END
        
        //loop through the children of the parent record (shouldn't be more than 1 child)
        List<String> roleNames = new List<String>();
        
        for(IB_Event_Role__c role : eligAssignment.IB_Event_Roles__r){
            switch on UserInfo.getLanguage() {
                when 'fr' {     // when block 1
                    roleNames.add(role.IB_Role_Name_fr__c);
                }   
                when 'es' {     // when block 2
                    roleNames.add(role.IB_Role_Name_es__c);
                }
                
                when else {       // default block, optional
                    roleNames.add(role.IB_Role_Name__c);     
                }
            }
        }
        
        Integer j = 1;
        for(String role : roleNames){
            activity.IBRoleName += role;
            if(j < roleNames.size()){
                activity.IBRoleName += ', ';
            }
            j++;
        }
        
        activity = translateIBActivity(activity);
        
        return activity;
    }
    
    
    
    public static IBActivity convertEligAssignmentDetails(Staffing_Event__c eligAssignment){
        IBActivity activity = new IBActivity();
        
        activity.ApplicationStatus = Label.IBENPortal_shared_NotApplied;  //use as default status
        activity.Table = 'Staffing_Event__c';
        activity.Id = eligAssignment.Id;
        activity.EndDate = eligAssignment.End_Date__c;
        activity.RecordTypeName = eligAssignment.IB_Event__r.RecordType.Name;
        activity.Type=eligAssignment.IB_Event__r.Type;
        // this code is edited by developer Ali Haider Bajwa-plumlogix for user story 11741 of staff aug project
        // start
        // this is done for second audience
        activity.Audience=eligAssignment.IB_Event__r.Audience__c;
        activity.deliveryMode = eligAssignment.IB_Event__r.Delivery_Mode__c; 
        activity.eventOrganizerAccount= eligAssignment.IB_Event__r.Event_Organizer_Account__r.Name;//Added By Kashyap IB_Event__r.Event_Organizer_Account__r.Name as a part of ECM00524 to display Event Organizer Account in Detail page
        //end
        //                <!--// this code is edited by developer Ali Haider Bajwa-plumlogix for user story 11741 of staff aug project-->
        
        //start
        //activity.IBDocsID=eligAssignment.IB_Event__r.IB_Docs_ID__c;
        activity.ProgrammeCombinationEvaluationVisits=eligAssignment.IB_Event__r.Programme_Combination_Evaluation_Visits__c;
        activity.EventLanguage=eligAssignment.IB_Event__r.Event_Language__c;
        activity.SubType=eligAssignment.IB_Event__r.Sub_Type__c;

        //Added by Suraj as part of ECM00651 START
        activity.PrgRelationshipManager=eligAssignment.IB_Event__r.Programme_Relationship_Manager__c;
        //Added by Suraj END
        //end
        try{
            activity.EndDateString = eligAssignment.End_Date__c.format();
        } catch(Exception e){
            activity.EndDateString = '';
        }
        activity.Programme = eligAssignment.Programme_s__c;
        activity.Programme_sp = eligAssignment.IB_Programme_spanish__c;
        activity.Programme_fr = eligAssignment.IB_Programme_french__c;
        activity.StartDate = eligAssignment.Start_Date__c;
        try{
            activity.StartDateString = eligAssignment.Start_Date__c.format();
        } catch(Exception e){
            activity.StartDateString = '';
        }
        activity.EventId = eligAssignment.Id;
        activity.EventCity = eligAssignment.Staffing_Event_City__c;
        //Following Line is added by plumlogix For ECM 477
        activity.IBDocsID= 'PSP '+eligAssignment.IB_Event__r.IB_Docs_ID__c;
        activity.EventState = eligAssignment.Staffing_Event_State__c;
        activity.EventCountry = eligAssignment.Staffing_Event_Country__c;
        activity.EventSubregion = eligAssignment.Staffing_Event_Sub_Region__c;
        activity.EventRegion = eligAssignment.Staffing_Event_Region__c;
        activity.EventName = eligAssignment.Name;
        activity.EventCategory = eligAssignment.Category__c;
        activity.EventSubject = eligAssignment.Subject__c;
        activity.EventVenue = eligAssignment.Staffing_Event_Venue__c;
        activity.EventLanguage1 = eligAssignment.Staffing_Event_Language_1__c;
        activity.EventLanguage2 = eligAssignment.Staffing_Event_Language_2__c;
        //activity.EventName = eligAssignment.Staffing_Event_Organizer__c;
        activity.IBRoleName = '';
        activity.PositionsLeft = 0;
        
        /** added by kashyap as a part of phase 3 754**/
        if(eligAssignment.IB_Event__r.Preliminary_Review_End_Date__c!= null){
           activity.PreliminaryReviewEndDateString=eligAssignment.IB_Event__r.Preliminary_Review_End_Date__c.format();
        }
         if(eligAssignment.IB_Event__r.Preliminary_Review_Start_Date__c!= null){
        activity.PreliminaryReviewStartDateString=eligAssignment.IB_Event__r.Preliminary_Review_Start_Date__c.format();
         }
         activity.RecordTypeName=eligAssignment.IB_Event__r.recordtype.name;
        
        /** added by kashyap as a part of phase 3 754**/
        
        
        //loop through the children of the parent record (shouldn't be more than 1 child)
        List<String> roleNames = new List<String>();
        
        for(IB_Event_Role__c role : eligAssignment.IB_Event_Roles__r){
            switch on UserInfo.getLanguage() {
                when 'fr' {     // when block 1
                    roleNames.add(role.IB_Role_Name_fr__c);
                }   
                when 'es' {     // when block 2
                    roleNames.add(role.IB_Role_Name_es__c);
                }
                
                when else {       // default block, optional
                    roleNames.add(role.IB_Role_Name__c);     
                }
            }
        }        
        
        Integer i = 1;
        for(String role : roleNames){
            activity.IBRoleName += role;
            if(i < roleNames.size()){
                activity.IBRoleName += ', ';
            }
            i++;
        }
        
        //loop through the children of the parent record (shouldn't be more than 1 child)
        List<Decimal> positions = new List<Decimal>();
        
        for(IB_Event_Role__c role : eligAssignment.IB_Event_Roles__r){
            positions.add(role.Positions_Left__c);
        }
        
        for(Decimal num : positions){
            activity.PositionsLeft +=  Integer.valueOf(num);
        }
        
        activity = translateIBActivity(activity);
        return activity;
    }   
    
    
    
    public static IBActivity convertMyTraining(My_Training_Event__c training){
        IBActivity activity = new IBActivity();
        
        activity.Table = 'My_Training_Event__c';
        //activity.Id = training.Training_Event__c;
        activity.Id = training.ID;
        activity.ApplicationStatus = training.Application_Status__c;
        activity.EndDate = training.End_Date__c;
        try{
            activity.EndDateString = training.End_Date__c.format();
        } catch (Exception e){
            activity.EndDateString = '';
        }
        activity.IBRoleName = training.IB_Role_Names__c;
        activity.Programme = training.IB_Programme__c;
        activity.StartDate = training.Start_Date__c;
        try{
            activity.StartDateString = training.Start_Date__c.format();
        } catch (Exception e){
            activity.StartDateString = '';
        }
        activity.EventId = training.Training_Event__c;
        activity.EventCity = training.Training_Event_City__c;
        activity.EventCountry = training.Training_Event_Country__c;
        activity.EventRegion = training.Training_Event_Region__c;
        activity.EventName = training.Training_Event__r.Name;
        
        
        activity.languageOfDelivery = training.Training_Event_Language__c;
        
        activity = translateIBActivity(activity);
        
        activity.languageOfDelivery = Label.IBENPortal_TrainingLanguage + ' ' + activity.languageOfDelivery;
        //activity.IBDocsID=training.
        
        
        
        
        return activity;
    }
    
    
    
    public static IBActivity convertEligTraining(Training_Event__c training){
        IBActivity activity = new IBActivity();
        
        activity.Table = 'Training_Event__c';
        activity.Id = training.Id;
        activity.ApplicationStatus =  Label.IBENPortal_shared_NotApplied;  //use as default status
        activity.EndDate = training.End_Date__c;
        try{
            activity.EndDateString = training.End_Date__c.format();
        } catch(Exception e){
            activity.EndDateString = '';
        }
        activity.IBRoleName = training.IB_Role_Name__c;
        activity.Programme = training.IB_Programme__c;
        try{
            activity.StartDateString = training.Start_Date__c.format();
        } catch(Exception e){
            activity.EndDateString = '';
        }
        activity.EventId = training.Id;
        activity.EventCity = training.Training_Event_City__c;
        activity.EventCountry = training.Training_Event_Country__c;
        activity.EventRegion = training.Training_Event_Region__c;
        activity.EventName = training.Name;
        
        
        activity.languageOfDelivery = training.IB_Event__r.Training_Language__c;
        
        activity = translateIBActivity(activity);
        
        activity.languageOfDelivery = Label.IBENPortal_TrainingLanguage + ' ' + activity.languageOfDelivery;
        
        
        return activity;
    }
    
    
    
    public static List<IBActivity> addAssignmentsToActivities(List<IBActivity> activities, List<My_Staffing_Event__c> assignments){
        //Convert assignments list to IBActivity list
        try{
            for(My_Staffing_Event__c assignment : assignments){
                activities.add(IBActivity.convertAssignment(assignment));
            }
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex +'lno:'+ ex.getLineNUmber());
        }
        
        return activities;
    }
    //Following Function is added by Shehryar-plumlogix in Sprint 22 on 06/10/2021 
    //Start
    public static List<IBActivity> addCasesToActivities(List<IBActivity> activities, List<Case> cases){
        //Convert assignments list to IBActivity list
        try{
            for(Case assignment : cases){
                activities.add(IBActivity.convertCase(assignment));
            }
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex);
        }
        
        return activities;
    } 
    
    //End
    public static List<IBActivity> addEligAssignmentsToActivities(List<IBActivity> activities, List<Staffing_Event__c> assignments){
        //Convert eligible assignments list to IBActivity list
        
        try{
            for(Staffing_Event__c assignment : assignments){
                activities.add(IBActivity.convertEligAssignment(assignment));
            }
        }
        catch(Exception ex){
            System.debug('ERROR: in addEligAssignmentsToActivities  ' + ex + 'lno**'+ ex.getLineNUmber());
        }
        
        return activities;
    }
    
    
    
    public static List<IBActivity> addMyTrainingsToActivities(List<IBActivity> activities, List<My_Training_Event__c> trainings){
        //Convert trainings list to IBActivity list
        try{
            for(My_Training_Event__c training : trainings){
                activities.add(IBActivity.convertMyTraining(training));
            }
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex);
        }
        return activities;
    }
    
    
    
    public static List<IBActivity> addEligTrainingsToActivities(List<IBActivity> activities, List<Training_Event__c> trainings){
        //Convert trainings list to IBActivity list
        try{
            for(Training_Event__c training : trainings){
                activities.add(IBActivity.convertEligTraining(training));
            }
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex);
        }
        return activities;
    }
    
    
    public static List<IBActivity> refineActivities(List<IBActivity> activities){
        //Removes any activities not conforming to the listed rules for Assignments/Trainings
        system.debug('IBACTIVITY refine start');
        Integer i = 0;
        List<Integer> toDelete = new List<Integer>();
        
        /* ### MyAssignments & MyTrainings criteria:
###   Declined or Rejected Status: display for 30 days only (done in query)
###   Confirmed Status: display to the end of the assignment
###   Pending Status:  continually displayed
*/
        for(IBActivity activity : activities){
            system.debug('appstatus: ' + activity.ApplicationStatus.toLowerCase());
            system.debug('DATE TODAY: ' + Date.today() + ' End Date: ' + activity.EndDate);
            if(activity.ApplicationStatus.toLowerCase() == 'confirmed' || activity.ApplicationStatus.toLowerCase() == 'backup' || 
               activity.ApplicationStatus.toLowerCase() == 'confirmado' || activity.ApplicationStatus.toLowerCase() == 'contacto alternativo' || 
               activity.ApplicationStatus.toLowerCase() == 'confirmado' || activity.ApplicationStatus.toLowerCase() == 'confirmé'
              ){
                  system.debug('DATE TODAY: ' + Date.today() + ' End Date: ' + activity.EndDate);
                  if(Date.today() > activity.EndDate){
                      toDelete.add(i);
                  }
              }
            else{
                //do nothing
            }
            i++;
        }//for
        
        Integer adjustPos = 0;  //used to adjust the list position based on number of deleted elements
        for(Integer del : toDelete){
            del -= adjustPos;
            activities.remove(del);
            adjustPos++;
        }
        system.debug('IBACTIVITY refine end');
        return activities;
    }
    
    
    
    public static List<Staffing_Event__c> refineEligibleAssignments(List<Staffing_Event__c> assignments){
        //delete any assignments where there are no children (ie, valid roles)
        Integer i = 0;
        List<Integer> toDelete = new List<Integer>();
        
        for(Staffing_Event__c assign : assignments){
            if(assign.IB_Event_Roles__r.isEmpty()){
                toDelete.add(i);
            }
            i++;
        }
        
        Integer adjustPos = 0;  //used to adjust the list position based on number of deleted elements
        for(Integer del : toDelete){
            del -= adjustPos;
            assignments.remove(del);
            adjustPos++;
        }
        
        return assignments;
    }
    
    
    
    public static List<IBActivity> sortIBActivities(List<IBActivity> activities){
        //Sort the IBActivity objects by Start Date
        IBActivityWrapper[] activitiesList = new List<IBActivityWrapper>();
        
        for(IBActivity activity : activities){
            activitiesList.add(new IBActivityWrapper(activity));
        }
        
        activitiesList.sort();
        
        List<IBActivity> sortedActivities = new List<IBActivity>();
        
        for(IBActivityWrapper item : activitiesList){
            sortedActivities.add(item.myActivity);
        }
        
        return sortedActivities;
    }
    
    
    public static List<IBActivity> filterIBActivities(List<IBActivity> activities, String[] filters){
        
        final string logTag = '[filterIBActivities]';
        System.debug(logTag + activities.size() + ' records in the raw activities List.');
        
        List<IBActivity> filteredActivities = new List<IBActivity>();
        for(IBActivity a : activities){
            
            // Loop through each filtered status to see if the current activity's status is one of the desired (filtered) statuses or if
            // if should not be included in the filtered results returned back to the calling applicaton.
            for(String status:filters){
                if(a.ApplicationStatus.equals(status)){
                    System.debug(logTag + 'Activity status [' + a.ApplicationStatus +'] is in the filter criteria [' + status + ']');
                    filteredActivities.add(a); 
                    break;
                } else {
                    System.debug(logTag + 'Activity status [' + a.ApplicationStatus + '] is NOT in this filter criteria [' + status + ']');
                }
            }
        }
        
        System.debug(logTag + filteredActivities.size() + ' records in the filtered activities List.');
        return filteredActivities;
    } 
    
    
    public static Boolean isAssignment(IBActivity activity){
        if(activity.Table == 'My_Staffing_Event__c' || activity.Table == 'Staffing_Event__c'){
            return true;
        }
        return false;
    }
    
    public static Boolean isMyAssignment(IBActivity activity){
        if(activity.Table == 'My_Staffing_Event__c'){
            return true;
        }
        return false;
    }
    
    public static Boolean isEditMyCurrentAssignment(IBActivity activity){
        if(activity.Table == 'My_Staffing_Event__c' && 
           (activity.ApplicationStatus == Label.IBENPortal_Global_Confirmed ||
            activity.ApplicationStatus == Label.IBENPortal_Global_Backup ||
            activity.ApplicationStatus == Label.IBENPortal_Global_UnderApproval ||
            activity.ApplicationStatus == Label.IBENPortal_Global_PendingSelection
           )
          ){
              return true;
          }
        return false;
    }
    
    public static Boolean isTraining(IBActivity activity){
        if(activity.Table == 'My_Training_Event__c' || activity.Table == 'Training_Event__c'){
            return true;
        }
        return false;
    }
    
    public static Boolean isCase(IBActivity activity){
        system.debug('caseeeeeeeee'+activity.Table);
        if(activity.Table == 'Case' ){
            return true;
        }
        return false;
    }
    
    public static Boolean isMyTraining(IBActivity activity){
        if(activity.Table == 'My_Training_Event__c'){
            return true;
        }
        return false;
    }
    
    public static Boolean isEditMyCurrentTraining(IBActivity activity){
        if(activity.Table == 'My_Training_Event__c' && activity.ApplicationStatus == Label.IBENPortal_Global_Confirmed){
            return true;
        }
        return false;
    }
    
    public static Boolean isEligibleTraining(IBActivity activity){
        if(activity.Table == 'Training_Event__c'){
            return true;
        }
        return false;
    }
    
    
    public static Boolean hasEventCity(IBActivity activity){
        if(activity.EventCity != null){
            return true;
        }
        return false;
    }
    
    
    public static Boolean hasEventCountry(IBActivity activity){
        if(activity.EventCountry != null){
            return true;
        }
        return false;
    }
    
    
    public static Boolean hasEventRegion(IBActivity activity){
        if(activity.EventRegion != null){
            return true;
        }
        return false;
    }
    
    
    
    public static Boolean hasSameMonths(IBActivity activity){
        Integer startMonth = activity.StartDate.month();
        Integer endMonth = activity.EndDate.month();
        
        if(startMonth == endMonth){
            return true;
        }
        
        return false;
    }
    
    
    public static Boolean isNotSingleDay(IBActivity activity){
        if(activity.StartDate == activity.EndDate){
            return false;
        }
        return true;
    }
    
    
    
    public static List<String> loadMyRoles(List<String> roles, String query){
        List<IB_Role__c> myRolesQuery = new List<IB_Role__c>();
        User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        if(query == null){
            myRolesQuery = [Select IB_Role__c From IB_Role__c
                            Where  IB_Contact__c = :user.ContactId and Status__c = 'Confirmed' 
                            and (IB_Role_Level__c = 'Fully Qualified' or IB_ROLE_LEVEL__c = 'Shadow')];
            
        }
        else{
            myRolesQuery = Database.query(query);
        }
        
        for(IB_Role__c role : myRolesQuery){
            roles.add(role.IB_Role__c);
        }
        
        return roles;
    }
    
    public static set<String> loadMyLanguages(){
        set<string> setLanguages = new set<string>();
        User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        for(IB_E_Background__c bg : [Select Id, Language__c From IB_E_Background__c Where IB_Contact__c = :user.ContactId and Language_Delivery__c = 'Yes']){
            setLanguages.add(bg.Language__c);
        }
        if(!setLanguages.isEmpty()){
            system.debug('setLanguages: ' + setLanguages);
            return setLanguages;
        }
        return null;
    }
    
    public static List<IB_Role__c> loadMyIBRoles(String query, String roleStatus){
        List<IB_Role__c> myRoles = new List<IB_Role__c>();
        User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        if(query == null){
            myRoles = [SELECT id, IB_Role__r.Role_Name_es__c,Role_Programme_Psp_Combo__c, IB_Role__r.Role_Name_fr__c , IB_Role__c,Subject__c, IB_Role_Name__c, Programme_Selection__c, IB_Role_Programme_Combo__c,Upskilled_in_PSP__c,
                       (SELECT IB_Subject__c, IB_Subject__r.Subject_Name__c FROM Role_Application_Subjects__r), (SELECT IB_Workshop_Title__c, IB_Workshop_Title__r.Workshop_Title_ENG__c from Role_Application_Workshop_Titles__r)
                       FROM IB_Role__c
                       WHERE  IB_Contact__c = :user.ContactId 
                       AND Status__c = :roleStatus
                       AND Display_In_PIMS_Community__c=false
                       AND IB_Role__r.SF_Role_Application__c = true];
        }
        else{
            myRoles = Database.query(query);
        }
        
        return myRoles;
    }
    
    
    
    
    public static List<String> loadSearchRoles(List<String> roles, String query){
        List<IB_Event_Role__c> mySearchRoles = new List<IB_Event_Role__c>();
        mySearchRoles = Database.query(query);
        
        for(IB_Event_Role__c role : mySearchRoles){
            roles.add(role.Staffing_Event__c);
        }
        
        return roles;
    }
    
    
    
    public static List<String> getRoleIds(List<IB_Role__c> myRoles){
        List<String> roles = new List<String>();
        
        for(IB_Role__c role : myRoles){
            roles.add(role.IB_Role__c);
        }
        return roles;
    }
    
    
    //remove trainings that do not have the paired role & programme from the IB_Role__c list
    public static List<Training_Event__c> filterTrainingsByProgramme(List<Training_Event__c> trainings, List<IB_Role__c> roles){
        IBActivity a = new IBActivity();
        try{
            Set<String> roleSet = new Set<String>();
            for(IB_Role__c role : roles){
                roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c);
            }
            
            List<Training_Event__c> filteredTrainings = new List<Training_Event__c>();
            
            for(Training_Event__c training : trainings){
                if(
                    roleSet.contains(training.IB_Role__c + '.' + translateText(training.IB_Programme__c,a)) ||
                    roleSet.contains(training.IB_Role_2__c + '.' + translateText(training.IB_Programme__c,a)) ||
                    roleSet.contains(training.IB_Role_3__c + '.' + translateText(training.IB_Programme__c,a))
                ){
                    filteredTrainings.add(training);
                }
            }
            return filteredTrainings;           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            return null;
        }
    }
    
    /*private static Boolean addProgramme(String prereqRole,String prereqProgramme,Set<String> roleSet,String subject){
Boolean response = false;

system.debug('preReqRole: ' + prereqRole);
system.debug('prereqProgramme: ' + prereqProgramme);
system.debug('roleSet: ' + roleSet);
system.debug('subject: ' + subject);
if(roleSet.contains(prereqRole + '.' + prereqProgramme + '.' + subject)){
response = true;
}
if(prereqProgramme.contains('Continuum')){
if(prereqProgramme.contains('DP')){
if(roleSet.contains(prereqRole + '.Continuum|DP.' + subject)){
response = true;
}
}
if(prereqProgramme.contains('CP') || prereqProgramme.contains('IBCC')){
if(roleSet.contains(prereqRole + '.Continuum|IBCC.' + subject) || roleSet.contains(prereqRole + '.Continuum|CP.' + subject)){
response = true;
}
}
if(prereqProgramme.contains('PYP')){
if(roleSet.contains(prereqRole + '.Continuum|PYP.' + subject)){
response = true;
}

}
if(prereqProgramme.contains('MYP')){
if(roleSet.contains(prereqRole + '.Continuum|MYP.' + subject)){
response = true;
}
}
}
return response;
}*/
    
    //remove assignments that do not have the paired role & programme from the IB_Role__c list
    public static List<Staffing_Event__c> filterAssignmentsByProgramme(List<Staffing_Event__c> assignments, List<IB_Role__c> roles){
        try{
            Set<String> roleSet = new Set<String>();
            for(IB_Role__c role : roles){
                roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c + '.');
                /*if(role.Continuum__c){
roleSet.add(role.IB_Role__c + '.' + 'Continuum|' + role.Programme_Selection__c + '.');
}*/
            }
            system.debug('ROLESET: ' + roleSet);
            
            Set<Staffing_Event__c> filteredAssignments = new Set<Staffing_Event__c>();
            
            for(Staffing_Event__c assignment : assignments){
                for(IB_Event_Role__c eventRole : assignment.IB_Event_Roles__r){
                    String prereqRole = eventRole.IB_Role__c;
                    String prereqProgramme = eventRole.IB_Programme__c;
                    if(roleSet.contains(eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c) && !filteredAssignments.contains(assignment)){
                        filteredAssignments.add(assignment);
                    }
                }
            }
            
            List<Staffing_Event__c> newAssignments = new List<Staffing_Event__c>();
            for(Staffing_Event__c assign : filteredAssignments){
                newAssignments.add(assign);
            }
            
            return newAssignments;          
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            return null;
        }        
    }
    
    /*private static Map<Id,List<Id>> getWorkshopTitlesWithSubjects(List<IB_Role__c> myConfirmedRoles){
List<IB_Workshop_Titles__c> ibWorkshopTitles = new List<IB_Workshop_Titles__c>();
List<IB_Workshop_Titles__c> ibWorkshopTitles2 = new List<IB_Workshop_Titles__c>();
List<Role_Application_Subject__c> rasSubjects = new List<Role_Application_Subject__c>();
List<String> myConfirmedSubjects = new List<String>();
List<String> searchRoleIds = new List<String>(); 
Map<Id,List<Id>> eligibleWorkshopTitles = new Map<Id,List<Id>>();

for(IB_Role__c r: myConfirmedRoles)
{
searchRoleIds.add(r.Id);
}

rasSubjects = [SELECT Id,IB_Subject__c, Role_And_Application__c FROM Role_Application_Subject__c WHERE Role_And_Application__c in :searchRoleIds];

for(Role_Application_Subject__c r : rasSubjects){
myConfirmedSubjects.add(r.IB_Subject__c);
}

ibWorkshopTitles = [SELECT Id,(SELECT IB_Subject__c FROM IB_Workshop_Title_Subjects__r) FROM IB_Workshop_Titles__c
WHERE Id in (Select IB_Workshop_Title__c FROM IB_Workshop_Title_Subject__c WHERE IB_Subject__c in :myConfirmedSubjects)];

ibWorkshopTitles2 = [SELECT Id FROM IB_Workshop_Titles__c WHERE Id NOT in (Select IB_Workshop_Title__c FROM IB_Workshop_Title_Subject__c)];                            

for(IB_Workshop_Titles__c w:ibWorkshopTitles){
//eligibleWorkshopTitles.add(w.Id);
List<String> subjectList = new List<String>();
for(IB_Workshop_Title_Subject__c s:w.IB_Workshop_Title_Subjects__r){
subjectList.add(s.IB_Subject__c);
}
eligibleWorkshopTitles.put(w.Id,subjectList);
}

system.debug('workshoptitleswsubjects: ' + eligibleWorkshopTitles);
for(IB_Workshop_Titles__c w:ibWorkshopTitles2){
eligibleWorkshopTitles.put(w.Id, new List<String>());
}

return eligibleWorkshopTitles;


}*/
    
    private static set<string> getWorkshopTitles(List<IB_Role__c> myConfirmedRoles){
        set<string> eligibleWorkshopTitlesAndSubs = new set<string>();
        /*set<id> workshopTitles = new set<id>();
set<id> myConfirmedSubjects = new set<id>();*/
        system.debug('myConfirmedRoles: ' + myConfirmedRoles);
        for(IB_Role__c role : myConfirmedRoles){
            if(role.Role_Application_Workshop_Titles__r != null){
                for(Role_Application_Workshop_Title__c wsTitle : role.Role_Application_Workshop_Titles__r){
                    system.debug('wsTitle.IB_Workshop_Title__r.Workshop_Title_ENG__c: ' + wsTitle.IB_Workshop_Title__r.Workshop_Title_ENG__c);
                    eligibleWorkshopTitlesAndSubs.add(wsTitle.IB_Workshop_Title__r.Workshop_Title_ENG__c);
                }
            }
            if(role.Role_Application_Subjects__r != null){
                for(Role_Application_Subject__c sub : role.Role_Application_Subjects__r){
                    system.debug('sub.IB_Subject__r.Subject_Name__c: ' + sub.IB_Subject__r.Subject_Name__c);
                    eligibleWorkshopTitlesAndSubs.add(sub.IB_Subject__r.Subject_Name__c);
                    eligibleWorkshopTitlesAndSubs.add(String.valueOf(sub.IB_Subject__c).substring(0, 15));
                }
            }
        }
        /*system.debug('workshopTitles: ' + workshopTitles);
if(!workshopTitles.isEmpty() && !myConfirmedSubjects.isEmpty()){
for(IB_Workshop_Titles__c wsTitle : [SELECT Id,(SELECT IB_Subject__c FROM IB_Workshop_Title_Subjects__r) FROM IB_Workshop_Titles__c
WHERE Id IN: workshopTitles]){
if(wsTitle.IB_Workshop_Title_Subjects__r != null && !wsTitle.IB_Workshop_Title_Subjects__r.isEmpty()){
for(IB_Workshop_Title_Subject__c wsSubj : wsTitle.IB_Workshop_Title_Subjects__r){
if(myConfirmedSubjects.contains(wsSubj.IB_Subject__c)){
eligibleWorkshopTitles.add((string)wsTitle.Id);
}
}
}
else{
eligibleWorkshopTitles.add((string)wsTitle.Id);
}
}
}*/
        system.debug('eligibleWorkshopTitlesAndSubs: ' + eligibleWorkshopTitlesAndSubs);
        if(!eligibleWorkshopTitlesAndSubs.isEmpty()){
            return eligibleWorkshopTitlesAndSubs;
        }
        return null;
    }
    
    //remove assignments that do not have the paired role & programme & subject from the IB_Role__c list
    /*public static List<Staffing_Event__c> filterAssignmentsByProgrammeAndSubject(List<Staffing_Event__c> assignments, List<IB_Role__c> roles){
Map<Id,List<Id>> eligWorkshopTitles = getWorkshopTitlesWithSubjects(roles);

//try{
Set<String> roleSet = new Set<String>();
for(IB_Role__c role : roles){

system.debug('eligiblecombos: ' + role.IB_Role__c + '.' + role.Programme_Selection__c + '.');
roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c + '.');

for(Role_Application_Subject__c sub : role.Role_Application_Subjects__r){
system.debug('eligiblecombos: ' + role.IB_Role__c + '.' + role.Programme_Selection__c + '.' + sub.Id);
roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c + '.' + sub.IB_Subject__c);
}

}

Set<Id> eligibleWorkshops = new Set<Id>();
eligibleWorkshops = eligWorkshopTitles.keySet();

Set<Staffing_Event__c> filteredAssignments = new Set<Staffing_Event__c>();

for(Staffing_Event__c assignment : assignments){
if(assignment.Workshop_Product_Title__c == null || assignment.Workshop_Product_Title__c == ''){
for(IB_Event_Role__c eventRole : assignment.IB_Event_Roles__r){
String prereqRole = eventRole.IB_Role__c;
String prereqProgramme = eventRole.IB_Programme__c;
system.debug('doesitmatchnoprod: ' + eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c + '.');
if(roleSet.contains(eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c) && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
}
} else{
for(Id e:eligibleWorkshops){
if(assignment.Workshop_Product_Title__c == e){
List<Id> workshopSubjects = eligWorkshopTitles.get(e);
if(workshopSubjects.size() == 0){
for(IB_Event_Role__c eventRole : assignment.IB_Event_Roles__r){
String prereqRole = eventRole.IB_Role__c;
String prereqProgramme = eventRole.IB_Programme__c;
system.debug('doesitmatchnosubs: ' + eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c + '.');
if(roleSet.contains(eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c) && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
}
} else {
for(Id j:eligWorkshopTitles.get(e)){
for(IB_Event_Role__c eventRole : assignment.IB_Event_Roles__r){
String prereqRole = eventRole.IB_Role__c;
String prereqProgramme = eventRole.IB_Programme__c;
system.debug('doesitmatchwsubs: ' + eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c + '.' + j);
if(roleSet.contains(eventRole.IB_Role__c + '.' + eventRole.IB_Programme__c + '.' + j) && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
}
}
}
}
}
}
}

List<Staffing_Event__c> newAssignments = new List<Staffing_Event__c>();
for(Staffing_Event__c assign : filteredAssignments){
newAssignments.add(assign);
}

return newAssignments;          
//}
//catch(Exception ex){
//    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
//    return null;
//}
}*/
    
    public static List<Staffing_Event__c> filterAssignmentsByProgrammeAndSubject(List<Staffing_Event__c> assignments, List<IB_Role__c> roles){
        
        Set<string> eligibleWorkshops = new Set<string>();
        eligibleWorkshops = getWorkshopTitles(roles);
        
        Set<Staffing_Event__c> filteredAssignments = new Set<Staffing_Event__c>();
        system.debug('assignments: ' + assignments);
        
        //code added by Prerna on 03-07-2024 for ECM00710 --STARTS-- 
        Set<id> relatedSubjects = new Set<id>(); //relatedSubjects will contain the subject present on assignment record
        List<IB_Role__c> ibRolesList = new List<IB_Role__c>();
        List<Role_Application_Subject__c> roleApplicationSubjectsList = new List<Role_Application_Subject__c>();
        Set<id> specialisedSubjectsList = new Set<id>();
        List<Id> contactIds = new List<Id>();
        
        for(Staffing_Event__c assignment: assignments){
            if(assignment.Staffing_Event_Type__c == 'Course Outline Reading'){
                relatedSubjects.add(assignment.Related_Subject__c);
            }
        }
        System.debug('RelatedSubject=======>'+relatedSubjects); 
        
        Id currentUserId = UserInfo.getUserId();
        System.debug('Current User ID =======>'+currentUserId);
        
        for (User user : [SELECT ContactId FROM User WHERE Id = :currentUserId]) {
            contactIds.add(user.ContactId);
        }
        System.debug('Contact Ids====>'+contactIds);
        
        if(!contactIds.isEmpty()) { 
            roleApplicationSubjectsList = [SELECT id, IB_Subject__c,IB_Subject__r.Subject_Name__c
                                           FROM Role_Application_Subject__c 
                                           WHERE Role_And_Application__r.IB_Contact__c =:contactIds 
                                           AND Role_And_Application__r.Status__c = 'Confirmed'
                                           AND Role_And_Application__r.IB_Role_Name__c = 'Course Outline Reader'];
            
        }
        System.debug('roleApplicationSubjectsList===>'+roleApplicationSubjectsList);
        if(!roleApplicationSubjectsList.isEmpty()){
            for(Role_Application_Subject__c roleSubject: roleApplicationSubjectsList){
                specialisedSubjectsList.add(roleSubject.IB_Subject__c); 
            }
        }
        System.debug('specialisedSubjectsList===>'+specialisedSubjectsList);
        System.debug('size===>'+specialisedSubjectsList.size());
        //code added by Prerna on 03-07-2024 for ECM00710 --ENDS-- 

        system.debug('eligibleWorkshops: ' + eligibleWorkshops);
        for(Staffing_Event__c assignment : assignments){
            //below if condition modified by Prerna for ECM00710 on 03-07-2024 and added assignment.Staffing_Event_Type__c != 'Course Outline Reading' check
            if(assignment.Staffing_Event_Type__c != 'Preliminary Review' && assignment.Staffing_Event_Type__c != 'Course Outline Reading'){
                if( (assignment.Subject__c == null || assignment.Subject__c == '' || 
                     (assignment.Subject__c != null && eligibleWorkshops != null && !eligibleWorkshops.isEmpty() && eligibleWorkshops.contains(assignment.Subject__c)))){
                         if(!filteredAssignments.contains(assignment)){
                             System.debug('Assignment id===>'+assignment.id);
                             filteredAssignments.add(assignment);
                         }
                     }
                //Following code is commented by Shehryar-plumlogix as a part of US-12219 of Sprint 20 of Staff Auf on  05/02/2021
                /*  if(assignment.Staffing_Event_Type__c == 'Course Outline Reading' && (assignment.Related_Subject__c == null || assignment.Related_Subject__c == '' || 
(assignment.Related_Subject__c != null && eligibleWorkshops != null && !eligibleWorkshops.isEmpty() && eligibleWorkshops.contains(assignment.Related_Subject__c)))){
if(!filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
*/
                //}
            }
            //code added by Prerna on 03-07-2024 for ECM00710 --STARTS-- 
            if(assignment.Staffing_Event_Type__c == 'Course Outline Reading' && relatedSubjects != null && relatedSubjects.contains(assignment.Related_Subject__c) && specialisedSubjectsList.contains(assignment.Related_Subject__c))
            {
                System.debug('true===>');
                filteredAssignments.add(assignment);
            }
            //code added by Prerna on 03-07-2024 for ECM00710 --ENDS-- 
        }
        
        
        List<Staffing_Event__c> newAssignments = new List<Staffing_Event__c>();
        for(Staffing_Event__c assign : filteredAssignments){
            newAssignments.add(assign);
        }
        System.debug('Orange newAssg: '+newAssignments);
        return newAssignments;
    }
    
    /*public static List<Staffing_Event__c> filterAssignmentsBySubject(List<Staffing_Event__c> assignments, List<String> workshopTitles){
Set<Staffing_Event__c> filteredAssignments = new Set<Staffing_Event__c>();

Set<String> titles = new Set<String>();
for(String s : workshopTitles){
titles.add(s);
}

for(Staffing_Event__c assignment : assignments){
if(titles.contains(assignment.Workshop_Product_Title__c) && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
}

List<Staffing_Event__c> newAssignments = new List<Staffing_Event__c>();
for(Staffing_Event__c assign : filteredAssignments){
newAssignments.add(assign);
}

return newAssignments;

}*/
    
    
    /*public static List<Staffing_Event__c> filterAssignmentsByProgrammeAndSubject(List<Staffing_Event__c> assignments, List<IB_Role__c> roles, List<String> workshopTitles){
try{
Set<String> roleSet = new Set<String>();
for(IB_Role__c role : roles){
roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c);
for(String s : workshopTitles){
roleSet.add(role.IB_Role__c + '.' + role.Programme_Selection__c + '.' + s);
}
}

Set<Staffing_Event__c> filteredAssignments = new Set<Staffing_Event__c>();

for(Staffing_Event__c assignment : assignments){
Integer i = 0;
for(IB_Event_Role__c event : assignment.IB_Event_Roles__r){
if(roleSet.contains(assignment.IB_Event_Roles__r[i].IB_Role__c + '.' + assignment.IB_Event_Roles__r[i].IB_Programme__c + '.' + assignment.Workshop_Product_Title__c) && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
} else if (assignment.Workshop_Product_Title__c == null || assignment.Workshop.Workshop_Product_Title__c == '' && roleSet.contains(assignment.IB_Event_Roles__r[i].IB_Role__c + '.' + assignment.IB_Event_Roles__r[i].IB_Programme__c && !filteredAssignments.contains(assignment)){
filteredAssignments.add(assignment);
}
i++;
}

}

List<Staffing_Event__c> newAssignments = new List<Staffing_Event__c>();
for(Staffing_Event__c assign : filteredAssignments){
newAssignments.add(assign);
}

return newAssignments;          
}
catch(Exception ex){
ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
return null;
}
}*/
    
    
    
    
    public static List<SelectOption> getReleasePermissionItems() {
        List<SelectOption> releasePermissionItems = new List<SelectOption>();
        releasePermissionItems.add(new SelectOption(Label.IBENPortal_shared_None, Label.IBENPortal_shared_None));
        releasePermissionItems.add(new SelectOption(Label.IBENPortal_shared_No, Label.IBENPortal_shared_No));
        releasePermissionItems.add(new SelectOption(Label.IBENPortal_shared_Yes, Label.IBENPortal_shared_Yes));
        return releasePermissionItems;
    }
    
    
    public static List<SelectOption> getInterestLevelItems() {
        List<SelectOption> interestLevelItems = new List<SelectOption>();
        interestLevelItems.add(new SelectOption(Label.IBEN_Training_Withdraw_Interest, Label.IBEN_Training_Withdraw_Interest));
        return interestLevelItems;
    }
    
    
    public static List<SelectOption> getWithdrawalReasons() {
        List<SelectOption> withdrawReasonItems = new List<SelectOption>();
        withdrawReasonItems.add(new SelectOption(Label.IBENPortal_shared_Personal,Label.IBENPortal_shared_PersonalLabel));
        withdrawReasonItems.add(new SelectOption(Label.IBENPortal_shared_Professional,Label.IBENPortal_shared_ProfessionalLabel));
        return withdrawReasonItems;
    }
    
    
    public static IB_Event_Role__c loadIBEventAssignmentReqs(String eventId){
        List<IB_Event_Role__c> requirements = new List<IB_Event_Role__c>();
        
        System.debug('Called loadEventRequirements() and eventID is ' + eventId);
        if(eventId != null){
            requirements = [Select IB_Event__c, toLabel(Proposed_Language__c),Special_Requistes_Additional_Notes__c, toLabel(Delivery_Mode__c),toLabel(Proposed_Spoken_Proficiency__c), Proposed_years_of_IB_Experience__c, toLabel(Proposed_Written_Proficiency__c)
                            From IB_Event_Role__c
                            Where IB_Event__c IN 
                            (Select IB_Event__c
                             From Staffing_Event__c
                             Where IB_Event__c = :eventId)];
            System.debug('After query in loadEventRequirements() where requirements is ' + requirements);
            if(!requirements.isEmpty()){
                return requirements[0];
            }
        }
        return null;
    }
    
    
    public static Boolean hasIBEventRequirements(IB_Event_Role__c req){
        Boolean hasReqs = false;
        
        if(req != null){
            if((req.Proposed_years_of_IB_Experience__c != null && req.Proposed_years_of_IB_Experience__c.length() > 0) || (req.Proposed_Written_Proficiency__c != null && req.Proposed_Written_Proficiency__c.length() > 0) ||(req.Proposed_Spoken_Proficiency__c != null && req.Proposed_Spoken_Proficiency__c.length() > 0) || (req.Proposed_Language__c != null && req.Proposed_Language__c.length() > 0)||(req.Delivery_Mode__c != null && req.Delivery_Mode__c.length() > 0)){
                System.debug('****No training requirements');
                hasReqs = true;
            }
        }
        return hasReqs;
    }
    
    public static String translateText(String s, IBActivity a){
        String response = s;
        /*for(IB_Data_Translate__c t : translations){
if(s == t.Record_ID__c){
response = t.Translate_Value_1__c;
break;
}
}*/
        if(translationMap.get(s) != null){
            response = translationMap.get(s);
        }
        return response;
    }
    
    public static IBActivity translateIBActivity(IBActivity a){
        
        if(translationMap.get(a.ApplicationStatus) != null){
            a.ApplicationStatus = translationMap.get(a.ApplicationStatus);
        }
        if(translationMap.get(a.Programme) != null){
            a.Programme = translationMap.get(a.Programme);
        }
        if(translationMap.get(a.EventCategory) != null){
            a.EventCategory = translationMap.get(a.EventCategory);
        }
        if(translationMap.get(a.EventCountry) != null){
            a.EventCountry = translationMap.get(a.EventCountry);
        }
        if(translationMap.get(a.EventLanguage1) != null){
            a.EventLanguage1 = translationMap.get(a.EventLanguage1);
        }
        if(translationMap.get(a.EventLanguage2) != null){
            a.EventLanguage2 = translationMap.get(a.EventLanguage2);
        }
        if(translationMap.get(a.EventName) != null){
            a.EventName = translationMap.get(a.EventName);
        }
        if(translationMap.get(a.EventRegion) != null){
            a.EventRegion = translationMap.get(a.EventRegion);
        }
        if(translationMap.get(a.EventSubject) != null){
            a.EventSubject = translationMap.get(a.EventSubject);
        }
        if(translationMap.get(a.EventSubregion) != null){
            a.EventSubregion = translationMap.get(a.EventSubregion);
        }
        if(translationMap.get(a.EventVenue) != null){
            a.EventVenue = translationMap.get(a.EventVenue);
        }
        if(translationMap.get(a.languageOfDelivery) != null){
            a.languageOfDelivery = translationMap.get(a.languageOfDelivery);
        }
        
        
        /*for(IB_Data_Translate__c t : translations){

try{
if(a.IBRoleName.contains(t.Record_ID__c)){
a.IBRoleName = a.IBRoleName.replace(t.Record_ID__c,t.Translate_Value_1__c);
}
} catch (Exception e){
a.IBRoleName = '';
}
if(a.ApplicationStatus == t.Record_ID__c){
a.ApplicationStatus = t.Translate_Value_1__c;
}
if(a.Programme == t.Record_ID__c){
a.Programme = t.Translate_Value_1__c;
}
if(a.EventCategory == t.Record_ID__c){
a.EventCategory = t.Translate_Value_1__c;
}
if(a.EventCountry == t.Record_ID__c){
a.EventCountry = t.Translate_Value_1__c;
}
if(a.EventLanguage1 == t.Record_ID__c){
a.EventLanguage1 = t.Translate_Value_1__c;
}
if(a.EventLanguage2 == t.Record_ID__c){
a.EventLanguage2 = t.Translate_Value_1__c;
}
if(a.EventName == t.Record_ID__c){
a.EventName = t.Translate_Value_1__c;
}
if(a.EventRegion == t.Record_ID__c){
a.EventRegion = t.Translate_Value_1__c;
}
if(a.EventSubject == t.Record_ID__c){
a.EventSubject = t.Translate_Value_1__c;
}
if(a.EventSubregion == t.Record_ID__c){
a.EventSubregion = t.Translate_Value_1__c;
}
if(a.EventVenue == t.Record_ID__c){
a.EventVenue = t.Translate_Value_1__c;
}
if(a.languageOfDelivery == t.Record_ID__c){
a.languageOfDelivery = t.Translate_Value_1__c;
}


}*/
        
        
        return a;
        
    }
}