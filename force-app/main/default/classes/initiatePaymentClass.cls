/*-
* This class is handling Payment Record Creation
* Modified line Added Type__c in line 40 and 41 in query,Added IB_Event__r.recordtype.name in line 102,Added new logic from 169-186,Added bypass startdate logic for EMS events 250,Added condition to consider IB_Programme  logic for EMS events 410 by Vikranth for EMS Project D30-08-2023
* Modified line 492 to remove requested event and workshop record type check condition after discussion with BA
* Modified By: Tarun Sharma
* Modified Date: Nov 21,2023
* Modified Description: 203747 - Honorarium Table: IB Programme field integration
* Modified Changes: Implemented business logic for EMS record types and simplified existing if-else condition for better code coverage.
*/
global class initiatePaymentClass {
    private static final set<Id> sEMSRecordtypeIds = IBConstants.fetchCampaignEMSRecordTypeIds(); //Added for EMS Project
    @AuraEnabled
    webservice static string initiatePayment(id eventId) {
        Campaign ibEvent = new Campaign();
        string eventRecType;
        string eventType;
        string eventSubType;
        string region;
        string feesName;
        string message;
        string unitOfMeasure;
        integer eventDays;
        date startDt;
        date endDt;
        decimal quantity = 1;
        boolean isVisit = false;
        set<id> setContactId = new set<id>();
        set<id> setCampaignIds = new set<id>();
        set<id> setChildCampaignIds = new set<id>();
        set<id> setChildCampaignIdsToUpd = new set<id>();
        set<string> setFeesNames = new set<string>();
        map<id, integer> mapEventIdToHours = new map<id, integer>();
        map<string, string> mapFeesNameToUnit = new map<string, string>();
        map<string, string> mapFeesNameToQty = new map<string, string>();
        map<id,integer> mapContIdToSubjectsCount = new map<id,integer>();
        map<string, list<IBEN_Honorarium_Fees_Table__c>> mapFeeNameToListFeesTable = new map<string, list<IBEN_Honorarium_Fees_Table__c>>();
        list<string> listVenueRegions = new list<string>();
        list<Campaign> listUpdateEvents = new list<Campaign>();
        list<CampaignMember> listEventMembers = new list<CampaignMember>();
        list<CampaignMember> listUpdateEventMembers = new list<CampaignMember>();
        list<My_Staffing_Event__c> listAssignments = new list<My_Staffing_Event__c>();
        list<My_Staffing_Event__c> listParentAssignments = new list<My_Staffing_Event__c>();
        list<My_Staffing_Event__c> listUpdateAssignments = new list<My_Staffing_Event__c>();
        list<IBEN_Honorarium_Payment_Exception__c> listException = new list<IBEN_Honorarium_Payment_Exception__c>();
        ibEvent = [select Name, Status, Type, RecordType.Name,RecordtypeId, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate, Venue_Account__r.Name,
                             Consultation_Visit_Date_Confirmed__c, CV_End_Date__c, Quantity__c, Quantity2__c,
                             Workshop_Programme__c, Type__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name, ParentId, X20_Hours_Confirmed__c, X40_Hours_Confirmed__c, X60_Hours_Confirmed__c, X10_Hours_IBCC_Confirmed__c,
                             (Select Name, Status, Type__c, Type, RecordType.Name,RecordtypeId, Workshop_Event_Region__c, Workshop_Event_Region_del__c, StartDate, EndDate, Consultation_Visit_Date_Confirmed__c, CV_End_Date__c,
                             Workshop_Programme__c, IB_Programme__c, Programme_del__c, Related_IB_Programme__r.Name, Sub_Type__c, Related_IB_Programme__r.RecordType.Name, ParentId, X20_Hours_Confirmed__c, X40_Hours_Confirmed__c, X60_Hours_Confirmed__c, X10_Hours_IBCC_Confirmed__c
                             from ChildCampaigns where Status != 'Cancelled' and Payment_approval__c = false and External_PD_Provider__c = false)
                             from Campaign where id =: eventId and Payment_approval__c = false and External_PD_Provider__c = false];
        if(ibEvent.id != null){
            if(ibEvent.RecordType.Name != 'IBEN Parent Reader Event'){
                setCampaignIds.add(ibEvent.id);
                if(ibEvent.Sub_Type__c == 'Candidacy Remote Consultation'){
                    integer hours;
                    if(ibEvent.X10_Hours_IBCC_Confirmed__c == true){
                        hours = 10;
                    }
                    if(ibEvent.X20_Hours_Confirmed__c == true){
                        hours = 20;
                    }
                    if(ibEvent.X40_Hours_Confirmed__c == true){
                        hours = 40;
                    }
                    if(ibEvent.X60_Hours_Confirmed__c == true){
                        hours = 60;
                    }
                    mapEventIdToHours.put(ibEvent.id, hours);
                }
            }
            system.debug('mapEventIdToHours: ' + mapEventIdToHours);
            if(ibEvent.ChildCampaigns != null){
                for(Campaign camp : ibEvent.ChildCampaigns){
                    setCampaignIds.add(camp.id);
                    if(camp.Sub_Type__c == 'Candidacy Remote Consultation'){
                        integer hours;
                        if(camp.X20_Hours_Confirmed__c == true){
                            hours = 20;
                        }
                        else if(camp.X10_Hours_IBCC_Confirmed__c == true){
                            hours = 10;
                        }
                        else if(camp.X40_Hours_Confirmed__c == true){
                            hours = 40;
                        }
                        else if(camp.X60_Hours_Confirmed__c == true){
                            hours = 60;
                        }
                        mapEventIdToHours.put(camp.id, hours);
                    }
                }
            }
            system.debug('setCampaignIds: ' + setCampaignIds);
            if(ibEvent.Type != null && ibEvent.Type == 'Exam Visit'){
                String memberFieldString = UtilityClass.getFieldsSOQL('CampaignMember');
                memberFieldString += ', Campaign.Name';
                String memberQueryWhereClause = ' where (Invitation_Status__c = \'Confirmed\' or Invitation_Status__c = \'Completed\') and CampaignId IN: setCampaignIds and Honorarium_Payment_Order_Created__c = false and Exception_Created__c = false and Contact.IB_Staff__c != \'Current\'';
                String memberQuery = 'SELECT ' + memberFieldString + ' FROM CampaignMember';
                for(CampaignMember eventMember : Database.Query(memberQuery + memberQueryWhereClause)){
                    if(setContactId != null && !setContactId.contains(eventMember.ContactId)){
                        setContactId.add(eventMember.ContactId);
                        listEventMembers.add(eventMember);
                    }
                }
            }
            else{
                String assignmentFieldString = UtilityClass.getFieldsSOQL('My_Staffing_Event__c');
                assignmentFieldString += ', IB_Event__r.Name,IB_Event__r.recordtype.name';
                String assignmentQueryWhereClause = ' where (Application_Status__c = \'Confirmed\' or Application_Status__c = \'Completed\') and IB_Event__c IN:  setCampaignIds and Payment_Initiated__c = false and Exception_Created__c = false and IB_Contact__r.IB_Staff__c != \'Current\'';
                String assignmentQuery = 'SELECT ' + assignmentFieldString + ' FROM My_Staffing_Event__c';
                listAssignments = Database.Query(assignmentQuery + assignmentQueryWhereClause);
                if((ibEvent.Sub_Type__c == 'Candidacy Remote Consultation' ||  ibEvent.Sub_Type__c == 'Candidacy Consultation Visit')){
                    assignmentQueryWhereClause = '';
                    assignmentQueryWhereClause = ' where (Application_Status__c = \'Confirmed\' or Application_Status__c = \'Completed\') and IB_Event__c = \'' + ibEvent.ParentId + '\' and Payment_Initiated__c = false and Exception_Created__c = false and IB_Contact__r.IB_Staff__c != \'Current\'';
                    listParentAssignments = Database.Query(assignmentQuery + assignmentQueryWhereClause);
                }
                if(!listAssignments.isEmpty()){
                    for(My_Staffing_Event__c staffAssgnmt : listAssignments){
                        if(setContactId != null && !setContactId.contains(staffAssgnmt.IB_Contact__c)
                                && staffAssgnmt.Staffing_Event_Region__c != null){
                            setContactId.add(staffAssgnmt.IB_Contact__c);
                            listVenueRegions.add(staffAssgnmt.Staffing_Event_Region__c);
                        }
                        system.debug('staffAssgnmt.IB_Event__c: ' + staffAssgnmt.IB_Event__c);
                        /*system.debug('setChildCampaignIds.contains(staffAssgnmt.IB_Event__c): ' + setChildCampaignIds.contains(staffAssgnmt.IB_Event__c));
                        if(ibEvent.Sub_Type__c == 'Course Outline Reading' && setChildCampaignIds.contains(staffAssgnmt.IB_Event__c)){
                            system.debug('Entered');
                            if(!mapContIdToSubjectsCount.containsKey(staffAssgnmt.IB_Contact__c)){
                                mapContIdToSubjectsCount.put(staffAssgnmt.IB_Contact__c, 1);
                            }
                            else{
                                mapContIdToSubjectsCount.put(staffAssgnmt.IB_Contact__c, mapContIdToSubjectsCount.get(staffAssgnmt.IB_Contact__c) + 1);
                            }
                        }
                        system.debug('mapContIdToSubjectsCount: ' + mapContIdToSubjectsCount);
                        if(!listVenueRegions.isEmpty()){
                            region = listVenueRegions[0];
                        }
                        else if(ibEvent.Workshop_Event_Region__c != null){
                            region = ibEvent.Workshop_Event_Region__c;
                        }
                        else if(ibEvent.Workshop_Event_Region_del__c != null){
                            region = ibEvent.Workshop_Event_Region_del__c;
                        }*/
                    }
                    if(listVenueRegions.isEmpty() && !listParentAssignments.isEmpty()){
                        for(My_Staffing_Event__c assgnmt : listParentAssignments){
                            if(assgnmt.Staffing_Event_Region__c != null){
                                listVenueRegions.add(assgnmt.Staffing_Event_Region__c);
                            }
                        }
                    }
                }
                else{
                    return 'There is no educator assigned to this event';
                }
            }
            if(!listVenueRegions.isEmpty()){
                region = listVenueRegions[0];
            }
            else if(ibEvent.Workshop_Event_Region__c != null){
                region = ibEvent.Workshop_Event_Region__c;
            }
            else if(ibEvent.Workshop_Event_Region_del__c != null){
                region = ibEvent.Workshop_Event_Region_del__c;
            }
            else if(ibEvent.RecordType.Name != null && ibEvent.RecordType.Name == 'Learning and Teaching Programme Development'){
                region = 'IBAEM';
            }
            //Added as part of INC0209657 by Kevin Fugate 8/27/2024 - Sets the region to global for the online pd provider events
            if((ibEvent.Venue_Account__r.Name == 'IB Online as provider' || ibEvent.Venue_Account__r.Name == 'Online PD as Provider') && ibEvent.RecordType.Name == 'Scheduled Workshop' && IBevent.Type == 'Online'){
                region = 'Global';
            }
            system.debug('region: ' + region);
            if(ibEvent.RecordType.Name != null){
                if(ibEvent.RecordType.Name == 'Regional Event'){
                    eventRecType = 'Regional Workshop';
                }
                else if(ibEvent.RecordType.Name == 'Cluster Event'){
                    eventRecType = 'Cluster Workshop';
                }
                else if(ibEvent.RecordType.Name == 'In School Event'){
                    eventRecType = 'In School Workshop';
                }
                else if(ibEvent.RecordType.Name == 'IBEN Parent Reader Event'){
                    eventRecType = 'Authorization';
                }
                else{
                    eventRecType = ibEvent.RecordType.Name;
                }
            }
            if(ibEvent.Type != null){
                if(ibEvent.Type == 'Reader Parent Event'){
                    eventType = 'Authorization';
                }
                else if(ibEvent.Type == 'Consultation' && eventRecType == 'Evaluation'){
                    eventType = 'Evaluation';
                }
                else if(ibEvent.Type == 'Parent In School Workshop' && eventRecType == 'In School Workshop'){
                    eventType = null;
                }
                else if(sEMSRecordtypeIds.contains(ibEvent.RecordTypeId)) 
                    // ibEvent.Recordtype.Name == IBConstants.REQUESTED_EVENT || ibEvent.Recordtype.Name == IBConstants.REQUESTED_WORKSHOP) //Start of EMS Code
                {
                    if(ibEvent.Type__c != null && ibEvent.Type__c != ''){
                        string sType = ibEvent.Type__c;
                        if(sType.contains('Single School'))
                        {
                            List<String> stringSplit = sType.split('Single School', 2);
                            eventType = (stringSplit.size() > 1) ?  'Requested '+'SS ' + stringSplit[1].trim() : sType; 
                        }
                        else if(sType.contains('Multi-School'))
                        {
                            List<String> stringSplit = sType.split('Multi-School', 2);
                            eventType = (stringSplit.size() > 1) ?  'Requested ' + 'MS ' + stringSplit[1].trim() : sType;
                        }
                        else
                        {
                            eventType = ibEvent.Type__c;
                        }
                    } else {
                        eventType = ibEvent.Type__c;
                    }
                    
                }   //End of EMS Code
                else{
                    eventType = ibEvent.Type;
                }
            }
            if(ibEvent.Sub_Type__c != null){
                if(ibEvent.Sub_Type__c == 'Authorization Visit'){
                    eventSubType = 'Verification Visit';
                }
                else if(ibEvent.Sub_Type__c == 'Evaluation Follow Up'){
                    eventSubType = 'Authorisation Follow Up';
                }
                else if(ibEvent.Sub_Type__c == 'Return Visit'){
                    eventRecType = 'Evaluation';
                    eventSubType = 'Return Visit';
                    eventType = 'Evaluation';
                }
                else{
                    eventSubType = ibEvent.Sub_Type__c;
                }
            }
            if(eventRecType == 'Cluster Workshop'){ //No need to verify Type and Sub-type for Cluster Workshop events
                eventSubType = null;
                eventType = null;
            }
            startDt = ibEvent.StartDate;
            endDt = ibEvent.EndDate;
            if(eventSubType != null){
                if(eventSubType == 'Candidacy Consultation Visit'){
                    if(ibEvent.Consultation_Visit_Date_Confirmed__c != null && ibEvent.CV_End_Date__c != null){
                        startDt = ibEvent.Consultation_Visit_Date_Confirmed__c;
                        endDt = ibEvent.CV_End_Date__c;
                    }
                    else{
                        return 'Consultancy Visit Start Date and Consultancy Visit End Date is mandatory before completing this event';
                    }
                }
                else if(eventSubType == 'Candidacy Remote Consultation'){
                    startDt = system.today();
                    endDt = system.today() + 1;
                }
                else if(eventSubType.contains('Visit') || eventSubType.contains('Follow Up')){
                    isVisit = true;
                }
            }
            eventDays = startDt.daysBetween(endDt) + 1;
            system.debug('region: '+ region);
            system.debug('eventRecType : '+ eventRecType);
            system.debug('eventType: '+ eventType);
            system.debug('eventSubType: '+ eventSubType);
            system.debug('startDt: '+ startDt);
            system.debug('endDt: '+ endDt);
            system.debug('eventDays: '+ eventDays);
            //Check whether payment is required for this event. If its not required return 'Not Reqd' message
            string query = 'SELECT ' + UtilityClass.getFieldsSOQL('IBEN_Honorarium_Fees_Table__c') + ' FROM IBEN_Honorarium_Fees_Table__c';
            string queryCondition = ' where Active__c = true and Venue_Region__c =: region';
            if(eventRecType != null){
                queryCondition += ' and Event_Record_Type__c =: eventRecType';
            }
            if(eventType != null){
                queryCondition += ' and Event_Type__c =: eventType';
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
            if(startDt != null && (!sEMSRecordtypeIds.contains(ibEvent.RecordTypeId)/*ibEvent.recordtype.Name != IBConstants.REQUESTED_EVENT && ibEvent.recordtype.Name != IBConstants.REQUESTED_WORKSHOP*/)){ //Added to bypass date for EMS Events
                queryCondition += ' and Effective_Start_Date__c <=: startDt and Effective_End_Date__c >=: startDt';
            }
            if(eventRecType == 'Learning and Teaching Programme Development'){
                if(ibEvent.Quantity__c != null){
                    if(ibEvent.Quantity__c == 'Hourly'){
                        unitOfMeasure = ibEvent.Quantity__c;
                        
                    }/**Added by kashyap **/
                    else if(ibEvent.Quantity__c == 'Daily meeting fee'){
                        unitOfMeasure = ibEvent.Quantity__c;
                    }
                    /**end of Added by kashyap **/
                        
                    else{
                        unitOfMeasure = 'Daily';
                    }
                }
                else{
                    return 'Please pick a unit of measure';
                }
                if(unitOfMeasure != null){
                    queryCondition += ' and Unit_of_Measure__c =: unitOfMeasure';
                }
            }
            list<IBEN_Honorarium_Fees_Table__c> listFeesTable = new list<IBEN_Honorarium_Fees_Table__c>();
            system.debug('queryCondition: ' + queryCondition);
            listFeesTable = Database.query(query + queryCondition);
            system.debug('listFeesTable: ' + listFeesTable);
            system.debug('listFeesTable.size(): ' + listFeesTable.size());
            if(!listFeesTable.isEmpty()){
                for(IBEN_Honorarium_Fees_Table__c feesTableRec : listFeesTable){
                    setFeesNames.add(feesTableRec.Fees_Name__c);
                }
            }
            else{
                for(IBEN_Honorarium_payment_mapping__mdt mapping : [SELECT MasterLabel, DeveloperName, Event_Sub_type__c, Event_Type__c, No_Payment_Required__c FROM IBEN_Honorarium_payment_mapping__mdt where MasterLabel =: eventRecType]){
                    if((eventType != null && mapping.Event_Type__c != null && eventType == mapping.Event_Type__c) || (eventType == null && mapping.Event_Type__c == null)){
                        if((eventSubType != null && mapping.Event_Sub_type__c != null && eventSubType == mapping.Event_Sub_type__c) || (eventSubType == null && mapping.Event_Sub_type__c == null)){
                            if(mapping.No_Payment_Required__c){
                                return System.Label.IBEN_Honorarium_No_Payment_Error_Message;
                            }
                        }
                    }
                }
            }
            if(!setFeesNames.isEmpty()){
                list<IBEN_Honorarium_Payment__c> listInsertPayment = new list<IBEN_Honorarium_Payment__c>();
                system.debug('setFeesNames: ' + setFeesNames);
                 /***This Part of Code is added by Ammara-Plumlogix as part of US-12160(ECM00218 & ECM00219),Staff-Aug Project on 2/5/2021
                 Begin
                 The Pick list value of event sub-typr change from Cross Prog Visit to Multiple Programme Evaluation Visit
                 In if condition the sub-type name is updated*/
                if(setFeesNames.size() <= 2 || (eventRecType != null && (eventSubType == 'Multiple Programme Evaluation Visit' || eventSubType == 'Synchronized Visit') && setFeesNames.size() <= 3)){
                    //End
                    if(!listAssignments.isEmpty()){
                        for(My_Staffing_Event__c assignment : listAssignments) {
                            string programme;
                            integer childEventDays;
                            date childEventStartDt;
                            date childEventEndDt;
                            if(assignment.Start_Date__c != ibEvent.StartDate){
                                childEventStartDt = assignment.Start_Date__c;
                            }
                            if(assignment.End_Date__c != ibEvent.EndDate){
                                childEventEndDt = assignment.End_Date__c;
                            }
                            if(childEventStartDt != null && childEventEndDt != null){
                                childEventDays = childEventStartDt.daysBetween(childEventEndDt) + 1;
                            }
                            if(childEventDays == null){
                                childEventDays = eventDays;
                            }
                            IBEN_Honorarium_Payment__c payment = new IBEN_Honorarium_Payment__c(My_Assignment_New__c = assignment.id, IB_Event__c = eventId);
                            //check for requested event/workshop record type - EMS - Tarun Sharma - 203747 - START
                            Boolean isEMSEvent = (assignment.IB_Event__r.Recordtype.Name==IBConstants.SCHEDULED_EVENT || assignment.IB_Event__r.Recordtype.Name==IBConstants.SCHEDULED_WORKSHOP || assignment.IB_Event__r.Recordtype.Name==IBConstants.REQUESTED_EVENT || assignment.IB_Event__r.Recordtype.Name==IBConstants.REQUESTED_WORKSHOP);
                            //check for requested event/workshop record type - EMS - Tarun Sharma - 203747 - END
                            if(assignment != null){
                                //---- PROPOSED LOGIC - EMS - Tarun Sharma --203747 START---
                                programme = (isEMSEvent && String.isNotBlank(assignment.Programme_Selection__c))?ibProgrammeProcess(assignment.Programme_Selection__c,isEMSEvent):(String.isNotBlank(assignment.IB_Programme__c)?assignment.IB_Programme__c:(String.isNotBlank(assignment.Programme_Selection__c)?assignment.Programme_Selection__c:(String.isNotBlank(assignment.Programme_From_Event_Role__c)?assignment.Programme_From_Event_Role__c:(String.isNotBlank(assignment.Programme_s__c)?ibProgrammeProcess(assignment.Programme_s__c,isEMSEvent):null))));
                                /*
                                ---- EXISTING LOGIC -------
                                Below logic is a existing logic with multiple if-else conditions.
                                Programme_Selection__c and Programme_s__c is referring to same value on field level so will not be able to cover Programme_s__c condition.
                                So, converted below logic into ternary operator which is doing the same thing.
                                
                                if(assignment.IB_Programme__c != null && assignment.IB_Programme__c != ''){
                                    programme = assignment.IB_Programme__c;
                                }
                                else if(assignment.Programme_Selection__c != null && assignment.Programme_Selection__c != ''){
                                    programme = assignment.Programme_Selection__c;
                                }
                                else if(assignment.Programme_From_Event_Role__c != null && assignment.Programme_From_Event_Role__c != ''){
                                    programme = assignment.Programme_From_Event_Role__c;
                                }
                                else if(assignment.Programme_s__c != null && assignment.Programme_s__c != ''){
                                    string programmes = assignment.Programme_s__c;
                                    if(programmes.contains('DP') || programmes.contains('Continuum')){
                                        programme = 'DP';
                                    }
                                    else if(programmes.contains('CP')){
                                        programme = 'CP';
                                    }
                                    else if(programmes.contains('PYP')){
                                        programme = 'PYP';
                                    }
                                    else if(programmes.contains('MYP')){
                                        programme = 'MYP';
                                    }
                                }*/
                                //---- PROPOSED LOGIC - EMS - Tarun Sharma --203747 END---
                            }
                            
                            system.debug('programme: ' + programme); 
                            //check for requested event/workshop record type - EMS - Tarun Sharma - 203747 - START
                            if(!isEMSEvent){
                                if(programme == null || programme.contains('Continuum') || programme == 'DP+CP' ||
                                        programme == 'IB Ed' || programme == 'Lead'){
                                    if(eventRecType != 'Learning and Teaching Programme Development'){
                                        programme = 'DP';
                                    }
                                }

                                if(programme =='MYP Partner'){//Benjamin McGarvey INC0187534
                                    programme='MYP';
                                }
                            }
                            //check for requested event/workshop record type - EMS - Tarun Sharma - 203747 - END
                            
                            system.debug('programme: ' + programme);
                            if(listFeesTable != null && !listFeesTable.isEmpty()) {
                                for(IBEN_Honorarium_Fees_Table__c feesRec : listFeesTable){
                                    system.debug('feesRec.IB_Programme__c: ' + feesRec.IB_Programme__c);
                                    system.debug('feesRec.Fees_Name__c: ' + feesRec.Fees_Name__c);
                                    system.debug('feesRec.Task_Code__c: ' + feesRec.Task_Code__c);
                                    system.debug('feesRec.Amount__c: ' + feesRec.Amount__c);
                                    if(feesRec.Fees_Name__c == '' || feesRec.Fees_Name__c == null){
                                        return 'Fees Name is empty.';
                                    }
                                    /*else if((feesRec.Fees_Name__c == '2 days' || feesRec.Fees_Name__c == 'Standard 3 days') && (childEventDays < 2 || childEventDays > 3)){
                                        system.debug('Exception');
                                        IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                                        if(eventRecType != null){
                                            exp.Event_Record_Type__c = eventRecType;
                                        }
                                        if(eventType != null){
                                            exp.Event_Type__c = eventType;
                                        }
                                        if(eventSubType != null){
                                            exp.Event_Sub_type__c = eventSubType;
                                        }
                                        exp.Exception_message__c = System.Label.IBEN_Honorarium_Reg_WS_Exception_Message;
                                        exp.IB_Event__c = assignment.IB_Event__c;
                                        //exp.IB_Programme__c = 
                                        exp.Registration_Number__c = assignment.id;
                                        if(region != null){
                                            exp.Venue_Region__c = region;
                                        }
                                        listException.add(exp);
                                        if(eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
                                            assignment.Exception_Created__c = true;
                                            listUpdateAssignments.add(assignment);
                                        }
                                        message = System.Label.IBEN_Honorarium_Reg_WS_Error_Message;
                                    }*/
                                    else{
                                        if(feesRec.IB_Programme__c == 'All' || feesRec.IB_Programme__c == programme){
                                            if(!isVisit){
                                                system.debug('Non-Visit');
                                                if(feesRec.Fees_Name__c.contains('per day')){
                                                    quantity = Decimal.ValueOf(childEventDays);
                                                }
                                                else if(feesRec.Fees_Name__c.contains('per subject')){
                                                    if(mapContIdToSubjectsCount.get(assignment.IB_Contact__c) != null){
                                                        quantity = mapContIdToSubjectsCount.get(assignment.IB_Contact__c);
                                                    }
                                                }
                                                if(eventSubType == 'Candidacy Remote Consultation'){
                                                    //quantity = Integer.valueOf(Math.Round(mapEventIdToHours.get(ibEvent.Id) / 20));
                                                    if(mapEventIdToHours.get(ibEvent.Id) != null){
                                                        quantity = Integer.valueOf(mapEventIdToHours.get(ibEvent.Id));
                                                    }
                                                    else{
                                                        return 'Please choose hours for Remote Consultation';
                                                    }
                                                }
                                                system.debug('ibEvent.Quantity__c: ' + ibEvent.Quantity__c);
                                                if(eventRecType == 'Learning and Teaching Programme Development'){
                                                    if(ibEvent.Quantity__c == 'Full Day' || ibEvent.Quantity__c == 'Hourly' || ibEvent.Quantity__c == 'Daily meeting fee'){// added by kashyap meeting fee or condition 
                                                        if(ibEvent.Quantity2__c != null){
                                                            quantity = ibEvent.Quantity2__c;
                                                        }
                                                        else{
                                                            return 'Please provide number of hour(s) or day(s) in Quantity field';
                                                        }
                                                    }
                                                    else if(ibEvent.Quantity__c == 'Half Day'){
                                                        if(ibEvent.Quantity2__c != null){
                                                            quantity = 0.5 * ibEvent.Quantity2__c;
                                                        }
                                                        else{
                                                            quantity = 0.5;
                                                        }
                                                    }
                                                    else if(ibEvent.Quantity__c == 'Quarter Day'){
                                                        if(ibEvent.Quantity2__c != null){
                                                            quantity = 0.25 * ibEvent.Quantity2__c;
                                                        }
                                                        else{
                                                            quantity = 0.25;
                                                        }
                                                    }
                                                }
                                                system.debug('quantity: ' + quantity);
                                                /*if(!((feesRec.Fees_Name__c != '2 days' && feesRec.Fees_Name__c != 'Standard 3 days') || (feesRec.Fees_Name__c == '2 days' && childEventDays == 2) || (feesRec.Fees_Name__c == 'Standard 3 days' && childEventDays == 3))){
                                                    continue;
                                                }*/
                                                payment.GL_Account__c = Integer.valueOf(feesRec.Account__c);
                                                payment.Invoice_Line_Description__c = assignment.IB_Event__r.Name;
                                                payment.Invoice_Line_Task_Code__c = feesRec.Task_Code__c;
                                                payment.Quantity__c = quantity;
                                                payment.Unit_of_Measure__c = feesRec.Unit_of_Measure__c;
                                                system.debug('feesRec.Amount__c: ' + feesRec.Amount__c);
                                                system.debug('quantity: ' + quantity);
                                                payment.Invoice_Total_Amount__c = feesRec.Amount__c * quantity;
                                                payment.Fees_Name__c = feesRec.Fees_Name__c;
                                                payment.Fees_Type__c = feesRec.Fees_Type__c;
                                                payment.CurrencyIsoCode = 'USD';
                                                payment.IB_Contact__c = assignment.IB_Contact__c;
                                                payment.Activity__c = feesRec.Activity__c;
                                                payment.Cost_Center__c = feesRec.Cost_Center__c;
                                                //EMS - After discussion with Lewis Rutledge remove the condition to check requested event and workshop record type. As it is breaking the functionality. It should work same as existing
                                                payment.IB_Programme__c = programme;//(assignment.IB_Event__r.Recordtype.Name == IBConstants.REQUESTED_EVENT || assignment.IB_Event__r.Recordtype.Name == IBConstants.REQUESTED_WORKSHOP) ?assignment.IB_Programme__c : programme;  //Added logic to accept IB Programme to accept as such from Assignments;
                                                
                                                listInsertPayment.add(payment);
                                                if(assignment.IB_Event__c != ibEvent.id && !setChildCampaignIdsToUpd.contains(assignment.IB_Event__c) && eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
                                                    Campaign eventObj = new Campaign(id = assignment.IB_Event__c, Payment_approval__c = true, Payment_Approved_By__c = UserInfo.getName());
                                                    listUpdateEvents.add(eventObj);
                                                    setChildCampaignIdsToUpd.add(assignment.IB_Event__c);
                                                }
                                                if(!listInsertPayment.isEmpty()){
                                                    assignment.Payment_Initiated__c = true;
                                                    listUpdateAssignments.add(assignment);
                                                }
                                            }
                                            else{
												if(assignment.Chair__c && feesRec.Fees_Name__c.contains('Chair')){
													system.debug('Visit_Chair');
													quantity = 1;
													if(feesRec.Fees_Name__c.contains('per day')){
														quantity = Decimal.ValueOf(childEventDays);
													}
													else if(feesRec.Fees_Name__c.contains('per subject')){
														if(mapContIdToSubjectsCount.get(assignment.IB_Contact__c) != null){
															quantity = mapContIdToSubjectsCount.get(assignment.IB_Contact__c);
														}
													}
													system.debug('quantity: ' + quantity);
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
													if(assignment.IB_Event__c != ibEvent.id && !setChildCampaignIdsToUpd.contains(assignment.IB_Event__c) && eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
														Campaign eventObj = new Campaign(id = assignment.IB_Event__c, Payment_approval__c = true, Payment_Approved_By__c = UserInfo.getName());
														listUpdateEvents.add(eventObj);
														setChildCampaignIdsToUpd.add(assignment.IB_Event__c);
													}
													if(eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
														assignment.Payment_Initiated__c = true;
														listUpdateAssignments.add(assignment);
													}
												}
												else if(!assignment.Chair__c && ((assignment.IB_Role_Name__c.contains('Team Leader') && feesRec.Fees_Name__c.contains('Team Leader')) || 
                                                        (assignment.IB_Role_Name__c.contains('Team Member') && feesRec.Fees_Name__c.contains('Team Member')))){
													system.debug('Visit');
													if(feesRec.Fees_Name__c.contains('per day')){
														quantity = Decimal.ValueOf(childEventDays);
													}
													else if(feesRec.Fees_Name__c.contains('per subject')){
														if(mapContIdToSubjectsCount.get(assignment.IB_Contact__c) != null){
															quantity = mapContIdToSubjectsCount.get(assignment.IB_Contact__c);
														}
													}
													/*if(!((feesRec.Fees_Name__c != '2 days' && feesRec.Fees_Name__c != 'Standard 3 days') || (feesRec.Fees_Name__c == '2 days' && childEventDays == 2) || (feesRec.Fees_Name__c == 'Standard 3 days' && childEventDays == 3))){
														continue;
													}*/
													system.debug('quantity: ' + quantity);
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
													if(assignment.IB_Event__c != ibEvent.id && !setChildCampaignIdsToUpd.contains(assignment.IB_Event__c) && eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
														Campaign eventObj = new Campaign(id = assignment.IB_Event__c, Payment_approval__c = true, Payment_Approved_By__c = UserInfo.getName());
														listUpdateEvents.add(eventObj);
														setChildCampaignIdsToUpd.add(assignment.IB_Event__c);
													}
													if(eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
														assignment.Payment_Initiated__c = true;
														listUpdateAssignments.add(assignment);
													}
												}
											}
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if(!listEventMembers.isEmpty()){
                        for(CampaignMember member : listEventMembers) {
                            string programme;
                            IBEN_Honorarium_Payment__c payment = new IBEN_Honorarium_Payment__c();
                            if(member.Programme__c != null){
                                programme = member.Programme__c;
                            }
                            if(programme == 'MYP,PYP'){
                                programme = 'MYP';
                            }
                            if(programme == null || programme.contains('Continuum') || programme.contains('Diploma')){
                                programme = 'DP';
                            }
                            system.debug('programme: ' + programme);
                            if(listFeesTable != null && !listFeesTable.isEmpty()) {
                                for(IBEN_Honorarium_Fees_Table__c feesRec : listFeesTable){
                                    system.debug('feesRec.IB_Programme__c: ' + feesRec.IB_Programme__c);
                                    system.debug('feesRec.Fees_Name__c: ' + feesRec.Fees_Name__c);
                                    system.debug('feesRec.Task_Code__c: ' + feesRec.Task_Code__c);
                                    system.debug('feesRec.Amount__c: ' + feesRec.Amount__c);
                                    if(feesRec.Fees_Name__c == '' || feesRec.Fees_Name__c == null){
                                        return 'Fees Name is empty.';
                                    }
                                    else{
                                        if(feesRec.IB_Programme__c != null && programme != null && (feesRec.IB_Programme__c == programme || feesRec.IB_Programme__c == 'All')){
                                            payment.GL_Account__c = Integer.valueOf(feesRec.Account__c);
                                            payment.Invoice_Line_Description__c = member.Campaign.Name;
                                            payment.Invoice_Line_Task_Code__c = feesRec.Task_Code__c;
                                            payment.Quantity__c = quantity;
                                            payment.Unit_of_Measure__c = feesRec.Unit_of_Measure__c;
                                            payment.Invoice_Total_Amount__c = feesRec.Amount__c * quantity;
                                            payment.Fees_Name__c = feesRec.Fees_Name__c;
                                            payment.Fees_Type__c = feesRec.Fees_Type__c;
                                            payment.IB_Event__c = eventId;
                                            payment.CurrencyIsoCode = 'USD';
                                            payment.Event_Member_Id__c = member.id;
                                            payment.IB_Contact__c = member.ContactId;
                                            payment.Activity__c = feesRec.Activity__c;
                                            payment.Cost_Center__c = feesRec.Cost_Center__c;
                                            payment.IB_Programme__c = programme;
                                            listInsertPayment.add(payment);
                                            member.Honorarium_Payment_Order_Created__c = true;
                                            listUpdateEventMembers.add(member);
                                        }
                                    }
                                }
                            }
                            /*else{
                                system.debug('Exception');
                                //Create Exception
                                IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                                if(eventRecType != null){
                                    exp.Event_Record_Type__c = eventRecType;
                                }
                                if(eventType != null){
                                    exp.Event_Type__c = eventType;
                                }
                                if(eventSubType != null){
                                    exp.Event_Sub_type__c = eventSubType;
                                }
                                exp.Exception_message__c = System.Label.IBEN_Honorarium_No_fees_value_Exception_Message;
                                exp.IB_Event__c = member.CampaignId;
                                //exp.IB_Programme__c = 
                                //exp.Registration_Number__c = assignment.id;
                                if(region != null){
                                    exp.Venue_Region__c = region;
                                }
                                listException.add(exp);
                                member.Exception_Created__c = true;
                                listUpdateEventMembers.add(member);
                                message = System.Label.IBEN_Honorarium_No_fees_value_Error_Message;
                            }*/
                        }
                    }
                    else{
                        return 'There is no educator assigned to this event';
                    }
                }
                else{
                    if(!listAssignments.isEmpty()){
                        for(My_Staffing_Event__c assignment : listAssignments) {
                            system.debug('Exception');
                            //Create Exception
                            IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                            if(eventRecType != null){
                                exp.Event_Record_Type__c = eventRecType;
                            }
                            if(eventType != null){
                                exp.Event_Type__c = eventType;
                            }
                            if(eventSubType != null){
                                exp.Event_Sub_type__c = eventSubType;
                            }
                            exp.Exception_message__c = System.Label.IBEN_Honorarium_multiple_fees_value_Exception_Message;
                            exp.IB_Event__c = assignment.IB_Event__c;
                            //exp.IB_Programme__c = 
                            exp.Registration_Number__c = assignment.id;
                            if(region != null){
                                exp.Venue_Region__c = region;
                            }
                            listException.add(exp);
                            if(eventSubType != 'Candidacy Remote Consultation' && eventSubType != 'Candidacy Consultation Visit'){
                                assignment.Exception_Created__c = true;
                                listUpdateAssignments.add(assignment);
                            }
                        }
                    }
                    message = System.Label.IBEN_Honorarium_multiple_fees_value_Error_Message;
                }
                if(!listInsertPayment.isEmpty()){
                    system.debug('listInsertPayment: ' + listInsertPayment);
                    insert listInsertPayment;
                    /*ibEvent.Payment_approval__c = true;
                    update ibEvent;*/
                    message = System.Label.IBEN_Honorarium_Payment_Success_Message;
                }
                else if(message == null){
                    return System.Label.IBEN_Honorarium_No_Payment_Message;
                }
            }
            else{
                if(!listAssignments.isEmpty()){
                    for(My_Staffing_Event__c assignment : listAssignments) {
                        system.debug('Exception');
                        IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                        if(eventRecType != null){
                            exp.Event_Record_Type__c = eventRecType;
                        }
                        if(eventType != null){
                            exp.Event_Type__c = eventType;
                        }
                        if(eventSubType != null){
                            exp.Event_Sub_type__c = eventSubType;
                        }
                        exp.Exception_message__c = System.Label.IBEN_Honorarium_No_fees_value_Exception_Message;
                        exp.IB_Event__c = assignment.IB_Event__c;
                        //exp.IB_Programme__c = 
                        exp.Registration_Number__c = assignment.id;
                        if(region != null){
                            exp.Venue_Region__c = region;
                        }
                        listException.add(exp);
                    }
                }
                else if(!listEventMembers.isEmpty()){
                    for(CampaignMember member : listEventMembers) {
                        system.debug('Exception');
                        //Create Exception
                        IBEN_Honorarium_Payment_Exception__c exp = new IBEN_Honorarium_Payment_Exception__c();
                        if(eventRecType != null){
                            exp.Event_Record_Type__c = eventRecType;
                        }
                        if(eventType != null){
                            exp.Event_Type__c = eventType;
                        }
                        if(eventSubType != null){
                            exp.Event_Sub_type__c = eventSubType;
                        }
                        exp.Exception_message__c = System.Label.IBEN_Honorarium_No_fees_value_Exception_Message;
                        exp.IB_Event__c = member.CampaignId;
                        //exp.IB_Programme__c = 
                        //exp.Registration_Number__c = assignment.id;
                        if(region != null){
                            exp.Venue_Region__c = region;
                        }
                        listException.add(exp);
                        member.Exception_Created__c = true;
                        listUpdateEventMembers.add(member);
                    }
                }
                message = System.Label.IBEN_Honorarium_No_fees_value_Error_Message;
            }
        }
        if(!listException.isEmpty()){
            system.debug('listException: ' + listException);
            insert listException;
        }
        if(!listUpdateAssignments.isEmpty()){
            system.debug('listUpdateAssignments: ' + listUpdateAssignments);
            update listUpdateAssignments;
        }
        if(!listUpdateEvents.isEmpty()){
            system.debug('listUpdateEvents: ' + listUpdateEvents);
            update listUpdateEvents;
        }
        if(!listUpdateEventMembers.isEmpty()){
            system.debug('listUpdateEventMembers: ' + listUpdateEventMembers);
            update listUpdateEventMembers;
        }
        if(message != null){
            return message;
        }
        return null;
    }

    /*
    * Modified By with Date: Tarun Sharma - 2023-11-21
    * Description: pass programme value and ems event flag to manipulate into logic value.
    * Stoyr: 203747 - Honorarium Table: IB Programme field integration 
    */
    @testVisible
    private static string ibProgrammeProcess(String programme,Boolean isEMSEvent){
        //check it is for requested event/workshop
        if(isEMSEvent){
            programme= emsProgrammeCalculation(programme);
        }else if(!isEMSEvent){//check it is not for requested event/workshop
            programme= nonEMSProgrammeCalculation(programme);
        }
        return programme;
    }

    /*
    * Modified By with Date: Tarun Sharma - 2023-11-21
    * Description: pass programme value for EMS programme.
    * Stoyr: 203747 - Honorarium Table: IB Programme field integration 
    */
    private static string emsProgrammeCalculation(String programme){
        //change DP+CP to DP
        if(programme.equalsIgnoreCase(IBConstants.DPCP_IBPROGRAMME)){
            programme = IBConstants.DP_IBPROGRAMME;
        }else if(programme.equalsIgnoreCase(IBConstants.IBED_IBPROGRAMME) || programme.equalsIgnoreCase(IBConstants.LEAD_IBPROGRAMME) || programme.startsWith(IBConstants.CONTINUUM_IBPROGRAMME)){
            //change IB Ed, Lead to Continuum
            programme = IBConstants.CONTINUUM_IBPROGRAMME;
        }
        return programme;
    }

    /*
    * Modified By with Date: Tarun Sharma - 2023-11-21
    * Description: pass programme value for non EMS programme. (Existing logic moved into new method - nothing else is changed)
    * Stoyr: 203747 - Honorarium Table: IB Programme field integration 
    */
    private static string nonEMSProgrammeCalculation(String programme){
        if(programme.contains('DP') || programme.contains('Continuum')){
            programme = 'DP';
        }
        else if(programme.contains('CP')){
            programme = 'CP';
        }
        else if(programme.contains('PYP')){
            programme = 'PYP';
        }
        else if(programme.contains('MYP')){
            programme = 'MYP';
        }else{
            return null;
        }
        return programme;
    }


}