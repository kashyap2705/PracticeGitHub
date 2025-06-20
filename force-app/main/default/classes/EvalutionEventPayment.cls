/** Added newly by kashyap as a part of ECM00305
* 
* Description:- On click of initiate Payment button on Campaign(Event) for Evaluation Record type
* Based on the Type, SubType,Event Protocol, Venue Region , start and end date value , Fees Table data is filtered and for
* the corresponding programme, the Amount is pulled and payment record is created
* 
* If the Campaign has child campaign, then for all the child campaign contacts also payment records are created
* If the same contact is shared with parent, child campaign the shared Amount specified in fees table is considered
* 
* On succsessful payment creation , Payment approval checkbox on parent+ child campaigns is checked and 
* On staffing events records  payment initiated is marked as true
* 
* 
* 
* **/

global Class EvalutionEventPayment {
    public static String  eventSubType;
    public static List<IBEN_Honorarium_Payment__c> listInsertPayment = new List<IBEN_Honorarium_Payment__c>();
    public static Decimal quantity = 1;
    //public static Set<id> setChildCampaignIdsToUpd = new Set<id>();
    public static List<Campaign> listUpdateEvents = new List<Campaign>();
    public static List<My_Staffing_Event__c> listUpdateAssignments = new List<My_Staffing_Event__c>();
    @AuraEnabled
    webservice static String evalutionEventPaymentCreation(id eventId) {  
      Campaign  ibEventEvaluation = [select Name, Programme_Combination_Evaluation_Visits__c,Status, Type, RecordType.Name, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate,
                             Consultation_Visit_Date_Confirmed__c, CV_End_Date__c, Quantity__c, Quantity2__c,
                             Workshop_Programme__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name, ParentId, X20_Hours_Confirmed__c, X40_Hours_Confirmed__c, X60_Hours_Confirmed__c, X10_Hours_IBCC_Confirmed__c,
                             (Select Name, Status, Type, RecordType.Name, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate, Consultation_Visit_Date_Confirmed__c, CV_End_Date__c,
                             Workshop_Programme__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name, ParentId, X20_Hours_Confirmed__c, X40_Hours_Confirmed__c, X60_Hours_Confirmed__c, X10_Hours_IBCC_Confirmed__c
                             from ChildCampaigns where Status != 'Cancelled' and Payment_approval__c = false and External_PD_Provider__c = false)
                             from Campaign where id =: eventId and Payment_approval__c = false and External_PD_Provider__c = false];
        
        
        Campaign ibEvent = ibEventEvaluation;
        String  eventRecType = 'Evaluation';
        String  region;
        String  feesName;
        String  message;
        Set<id> setContactId = new Set<id>();
        Set<id> setCampaignIds = new Set<id>();
        Set<string> setFeesNames = new Set<string>();
        List<string> listVenueRegions = new List<string>();
        List<My_Staffing_Event__c> listAssignments = new List<My_Staffing_Event__c>();
        List<IBEN_Honorarium_Payment_Exception__c> listException = new List<IBEN_Honorarium_Payment_Exception__c>();
        
        
        setCampaignIds.add(ibEvent.id);
        if(ibEvent.ChildCampaigns != null){
            for(Campaign camp : ibEvent.ChildCampaigns){
                setCampaignIds.add(camp.id);
            }
        }
        system.debug('setCampaignIds: ' + setCampaignIds);
        
        String assignmentFieldString = UtilityClass.getFieldsSOQL('My_Staffing_Event__c');
        assignmentFieldString += ', IB_Event__r.Name ,IB_Event__r.ParentId ';
        String assignmentQueryWhereClause = ' where (Application_Status__c = \'Confirmed\' or Application_Status__c = \'Completed\') and Payment_Initiated__c = false and IB_Event__c IN:  setCampaignIds  and Exception_Created__c = false and IB_Contact__r.IB_Staff__c != \'Current\'';
        String assignmentQuery = 'SELECT ' + assignmentFieldString + ' FROM My_Staffing_Event__c';
        listAssignments = Database.Query(assignmentQuery + assignmentQueryWhereClause);
        system.debug('listAssignments: ' + listAssignments);
        
        if(!listAssignments.isEmpty()){
            for(My_Staffing_Event__c staffAssgnmt : listAssignments){
                if(setContactId != null && !setContactId.contains(staffAssgnmt.IB_Contact__c)
                   && staffAssgnmt.Staffing_Event_Region__c != null){
                       setContactId.add(staffAssgnmt.IB_Contact__c);
                       listVenueRegions.add(staffAssgnmt.Staffing_Event_Region__c);
                   }
                system.debug('staffAssgnmt.IB_Event__c: ' + staffAssgnmt.IB_Event__c);
            }
        }
        else{
            return 'There is no educator assigned to this event';
        }
        
        if(!listVenueRegions.isEmpty()){
            region = listVenueRegions[0];
        }
        
        
        eventSubType = ibEvent.Sub_Type__c;            
        
        system.debug('region: '+ region);
        system.debug('eventRecType : '+ 'Evaluation');
        system.debug('eventType: '+ ibEvent.Type);
        system.debug('eventSubType: '+ eventSubType);
        system.debug('startDt: '+ ibEvent.StartDate);
        system.debug('endDt: '+ ibEvent.EndDate);
        system.debug('event Protocol: '+ ibEvent.Programme_Combination_Evaluation_Visits__c);
        
        //Check whether payment is required for this event. If its not required return 'Not Reqd' message
        string query = 'SELECT ' + UtilityClass.getFieldsSOQL('IBEN_Honorarium_Fees_Table__c') + ' FROM IBEN_Honorarium_Fees_Table__c';
        string queryCondition = ' where Active__c = true and Venue_Region__c =: region and Event_Record_Type__c= \'Evaluation\'';
        
        if(ibEvent.Type != null){
            queryCondition += ' and Event_Type__c = ' +'\''+ ibEvent.Type+ '\'';
        }
        else{
            queryCondition += ' and Event_Type__c = null';
        }
        if(eventSubType != null){
            queryCondition += ' and Event_Sub_type__c =: eventSubType';
        }
        else{
            queryCondition += ' and Event_Sub_type__c = null';
        }
        if(ibEvent.Programme_Combination_Evaluation_Visits__c =='IB only' || ibEvent.Programme_Combination_Evaluation_Visits__c =='Synchronized')
        {
            queryCondition += ' and Event_Protocol__c =' +'\''+ ibEvent.Programme_Combination_Evaluation_Visits__c+ '\''; // ibEvent.Programme_Combination_Evaluation_Visits__c';
        }
        else {
            queryCondition += ' and Event_Protocol__c = null';
        }
        if(ibEvent.StartDate != null){
            queryCondition += ' and Effective_Start_Date__c <='+ String.valueOf(ibEvent.StartDate)+ ' and Effective_End_Date__c >='+ String.valueOf(ibEvent.StartDate) ;//+' and createdby.name =\'Kashyap Modali\' ' ;
        }
       
        
        List<IBEN_Honorarium_Fees_Table__c> listFeesTable = new List<IBEN_Honorarium_Fees_Table__c>();
        system.debug('query: ' + query + queryCondition);
        listFeesTable = Database.query(query + queryCondition);
        system.debug('listFeesTable: ' + listFeesTable);
        system.debug('listFeesTable.size(): ' + listFeesTable.size());
        
        Map<String, Integer> roleContactCountMap = new Map<String, Integer>();
        for(My_Staffing_Event__c assignment : listAssignments) {
            
            String roleContactConcat = assignment.IB_Contact__c+assignment.IB_Role_Name__c+assignment.Programme_From_Event_Role__c+assignment.Chair__c;
            Integer roleContactCount ;
            if(roleContactCountMap.containsKey(roleContactConcat))
            {
                roleContactCount= roleContactCountMap.get(roleContactConcat)+1;
                roleContactCountMap.put(roleContactConcat,roleContactCount);
            }else{
                roleContactCountMap.put(roleContactConcat,1); 
            }
            
        }
        system.debug('roleContactCountMap**'+roleContactCountMap);
        /** Added by kashyap need it separately only ***/
        system.debug('listAssignments newly added **'+listAssignments.size());
        List<My_Staffing_Event__c> campaignContacts = new List<My_Staffing_Event__c>();
        CampaignContacts.addAll(listAssignments );
        
        for(My_Staffing_Event__c assignment : campaignContacts)
        {
            system.debug('keyName**'+assignment.IB_Contact__c+assignment.IB_Role_Name__c+assignment.Programme_From_Event_Role__c+assignment.Chair__c);
            system.debug('check**'+assignment.IB_Event__r.Name+'Parent Id'+assignment.IB_Event__r.ParentId);
            if((roleContactCountMap.get(assignment.IB_Contact__c+assignment.IB_Role_Name__c+assignment.Programme_From_Event_Role__c+assignment.Chair__c) > 1)
               &&
               /**((assignment.IB_Event__r.Name).contains('Preliminary') && assignment.IB_Event__r.ParentId !='' && assignment.IB_Event__r.ParentId !=null))**/
                (!String.isBlank(assignment.IB_Event__r.ParentId) )) 
               
            {
                system.debug('check if this is insdieee**');
                listAssignments.remove(listAssignments.indexOf(assignment));
                assignment.Payment_Initiated__c = true;
                listUpdateAssignments.add(assignment);
             }
        }
        
        system.debug('listAssignments after removal**'+listAssignments); 
        for(My_Staffing_Event__c assignment : listAssignments) {
            string programme;
            String roleContactConcat = assignment.IB_Contact__c+assignment.IB_Role_Name__c+assignment.Programme_From_Event_Role__c+assignment.Chair__c;
            
            
            IBEN_Honorarium_Payment__c payment = new IBEN_Honorarium_Payment__c(My_Assignment_New__c = assignment.id, IB_Event__c = ibEvent.id);
            if(assignment != null){
                if(assignment.Programme_From_Event_Role__c != null && assignment.Programme_From_Event_Role__c != ''){
                    programme = assignment.Programme_From_Event_Role__c;
                }
                
            }
            system.debug('programme: ' + programme);
            if(programme == null || programme.contains('Continuum') || programme == 'DP+CP' ||
               programme == 'IB Ed' || programme == 'Lead'){
                   programme = 'DP';
               }
            system.debug('programme: ' + programme);
            if(listFeesTable != null && !listFeesTable.isEmpty()) 
            {
                system.debug('listFeesTable***'+listFeesTable);
                for(IBEN_Honorarium_Fees_Table__c feesRec : listFeesTable){
                    if(feesRec.Fees_Name__c == '' || feesRec.Fees_Name__c == null){
                        return 'Fees Name is empty.';
                    }
                    else{
                        if(feesRec.IB_Programme__c == programme){
                            
                            if(ibEvent.Type == 'Evaluation')
                            {
                                
                                // applicable for Subtype :- Multiple Programme Evaluation Visit only
                               
                                if(assignment.Chair__c  && feesRec.Fees_Name__c.contains('Chair') && eventSubType=='Multiple Programme Evaluation Visit' && 
                                   (assignment.IB_Role_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER ) )
                                {
                                    if( (feesRec.Fees_Name__c == EventPaymentFeeNames.MULTI_PROGRAMME_CHAIR_CHILD_ONLY || feesRec.Fees_Name__c   == EventPaymentFeeNames.SYNCHRONISED_VISIT_IBCHAIR_CHILD_ONLY) && !String.isBlank(assignment.IB_Event__r.ParentId) && roleContactCountMap.get(roleContactConcat) ==1  ) 
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                    
                                    if( (feesRec.Fees_Name__c == EventPaymentFeeNames.MULTI_PROGRAMME_CHAIR_PARENT_ONLY || feesRec.Fees_Name__c   == EventPaymentFeeNames.SYNCHRONISED_VISIT_IBCHAIR_PARENT_ONLY) && String.isBlank(assignment.IB_Event__r.ParentId) && roleContactCountMap.get(roleContactConcat) ==1  ) 
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                    
                                     if( (feesRec.Fees_Name__c == EventPaymentFeeNames.MULTI_PROGRAMME_CHAIR_CHILD_PARENT || feesRec.Fees_Name__c   == EventPaymentFeeNames.SYNCHRONISED_VISIT_IBCHAIR_CHILD_PARENT)  && roleContactCountMap.get(roleContactConcat) ==2  ) 
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                    
                                } 
                                
                                
                                // applicable for Preliminary Review, Multiple Programme Evaluation Visit,Evaluation Visit,Evaluation Reading
                                
                                
                                else if( !assignment.Chair__c  && ( feesRec.Fees_Name__c.contains(EventPaymentFeeNames.PROGRAMME_LEADER)) && assignment.IB_Role_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER && String.isBlank(assignment.IB_Event__r.ParentId) && roleContactCountMap.get(roleContactConcat) == 1 )
                                {
                                    if((feesRec.Fees_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER_PARENT_ONLY )) 
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                }
                                else if( !assignment.Chair__c  && ( feesRec.Fees_Name__c.contains(EventPaymentFeeNames.PROGRAMME_LEADER)) && assignment.IB_Role_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER && !String.isBlank(assignment.IB_Event__r.ParentId)  && roleContactCountMap.get(roleContactConcat) == 1 )
                                {
                                    if((feesRec.Fees_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER_CHILD_ONLY )) 
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                }        
                                else if(!assignment.Chair__c  && ( feesRec.Fees_Name__c.contains(EventPaymentFeeNames.PROGRAMME_LEADER)) && assignment.IB_Role_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER )
                                {
                                    if(feesRec.Fees_Name__c == EventPaymentFeeNames.PROGRAMME_LEADER_CHILD_PARENT && roleContactCountMap.get(roleContactConcat) == 2)   
                                    {
                                        addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                    }
                                }      
                                        
                                        
                                
                                // applicable for Multiple Programme Evaluation Visit,Evaluation Visit
                                else if(feesRec.Fees_Name__c== EventPaymentFeeNames.EVALUATION_LEADER_PARENT_ONLY &&  
                                        assignment.IB_Role_Name__c == EventPaymentFeeNames.EVALUATION_LEADER  )
                                {
                                    addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                }
                            }
                            
                            if(ibEvent.Type == 'Consultation' )
                            {
                                if(eventSubType =='Return Visit' &&  feesRec.Fees_Name__c.contains(EventPaymentFeeNames.EVALUATION_LEADER_PROGRAMME_LEADER_RETURN_VISIT ))
                                {
                                    addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                }
                                if(eventSubType =='Evaluation Follow Up' && feesRec.Fees_Name__c.contains(EventPaymentFeeNames.PROGRAMME_LEADER_EVALUATION_FOLOWUP_VISIT))
                                {
                                    addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                }
                                if(eventSubType =='Programme Development Support Visit' && feesRec.Fees_Name__c.contains(EventPaymentFeeNames.EVALUATION_LEADER_PROGRAMME_LEADER_PDSV))
                                {
                                    addPaymentRecordsToList( assignment, feesRec, programme, payment, ibEvent );
                                }
                                
                            }
                        }
                    }
                }
            }else{
                
                            IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                            exp.Event_Record_Type__c = 'Evaluation';
                            if(ibEvent.Type != null){
                                exp.Event_Type__c = ibEvent.Type;
                            }
                            if(eventSubType != null){
                                exp.Event_Sub_type__c = eventSubType;
                            }
                            exp.Exception_message__c = System.Label.IBEN_Honorarium_No_fees_value_Error_Message;
                            exp.IB_Event__c = assignment.IB_Event__c;
                            exp.Registration_Number__c = assignment.id;
                            if(region != null){
                                exp.Venue_Region__c = region;
                            }
                            listException.add(exp);
                            insert listException;
                
                            return System.Label.IBEN_Honorarium_No_fees_value_Error_Message;
            }
            
        }
        if(!listInsertPayment.isEmpty()){
            system.debug('listInsertPayment: ' + listInsertPayment);
            system.debug('listInsertPayment size: ' + listInsertPayment.size());
            List<IBEN_Honorarium_Payment__c> insertPaymentList= new List<IBEN_Honorarium_Payment__c> ();
            for(IBEN_Honorarium_Payment__c ibenPayment: listInsertPayment)
            {
                if (!insertPaymentList.contains(ibenPayment)) {
                    insertPaymentList.add(ibenPayment);
                }
            }
            insert insertPaymentList;
            message = System.Label.IBEN_Honorarium_Payment_Success_Message;
            system.debug('message*****'+message);
            
            
            Campaign eventObj = new Campaign(id = ibEvent.id, Payment_approval__c = true, Payment_Approved_By__c = UserInfo.getName());
            listUpdateEvents.add(eventObj);
            
             List<Campaign> childCampaignList= [select id,name from Campaign where parentId=: ibEvent.id];
             system.debug('childCampaignList'+childCampaignList);
                 
            if(childCampaignList.size()>0){
                for(Campaign campaign: childCampaignList)
                {
                    campaign.Payment_approval__c = true;
                    campaign.Payment_Approved_By__c = UserInfo.getName();
                }
            listUpdateEvents.addAll(childCampaignList);
            }
        }
        else if(message == null){
            system.debug('message *****'+System.Label.IBEN_Honorarium_No_Payment_Message);
            return System.Label.IBEN_Honorarium_No_Payment_Message;
        }
        
        
        if(!listUpdateAssignments.isEmpty()){
            system.debug('listUpdateAssignments: ' + listUpdateAssignments);
            
            List<My_Staffing_Event__c> listUpdateAssignmentsNoDuplicates = new List<My_Staffing_Event__c>();
            for (My_Staffing_Event__c staffEvent : listUpdateAssignments) {
                if (!listUpdateAssignmentsNoDuplicates.contains(staffEvent)) {
                    listUpdateAssignmentsNoDuplicates.add(staffEvent);
                }
            }
            //update listUpdateAssignments;
            update listUpdateAssignmentsNoDuplicates;
        }
        if(!listUpdateEvents.isEmpty()){
            system.debug('listUpdateEvents: ' + listUpdateEvents);
            update listUpdateEvents;
            
           
            
        }
        
        if(message != null){
            system.debug('message*****'+message);
            return message;
        }
        
        return null;         
    }
    
    public static void addPaymentRecordsToList(My_Staffing_Event__c assignment,IBEN_Honorarium_Fees_Table__c feesRec,String programme,IBEN_Honorarium_Payment__c payment,Campaign ibEvent ){
        
        payment.GL_Account__c = Integer.valueOf(feesRec.Account__c);
        payment.Invoice_Line_Description__c = assignment.IB_Event__r.Name;
        payment.Invoice_Line_Task_Code__c = feesRec.Task_Code__c;
        payment.Quantity__c = quantity;
        payment.Unit_of_Measure__c = feesRec.Unit_of_Measure__c;
        payment.Invoice_Total_Amount__c = feesRec.Amount__c * quantity;
        payment.Fees_Name__c = feesRec.Fees_Name__c;
        payment.Fees_Type__c = feesRec.Fees_Type__c;
        payment.CurrencyIsoCode = 'USD';
        payment.IB_Contact__c = assignment.IB_Contact__c;
        payment.Activity__c = feesRec.Activity__c;
        payment.Cost_Center__c = feesRec.Cost_Center__c;
        payment.IB_Programme__c = programme;
        listInsertPayment.add(payment);
        
        if(eventSubType != ''){
            assignment.Payment_Initiated__c = true;
            listUpdateAssignments.add(assignment);
        }
    }
    
    
}