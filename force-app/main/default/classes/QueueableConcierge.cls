global class QueueableConcierge implements Queueable, Database.AllowsCallouts {
    
    global  List<IBConciergeStaging__c> stagingRecords;
    global class IBConciegeResponse{
        global String accepted;
        global ErrorMessage error;
    }
    global class ErrorMessage{
        global String reason;
        global String error;
    }
    
    
    
    
    @future(callout=true)
    public static void futureCallToConcierge(Id recordId,String requestBody,String receivedEventId) {
        System.debug('Future 1');
        Concierge_API_Configs__c config = Concierge_API_Configs__c.getInstance();
        System.debug('config===>' +config);
        if (config != null && !String.isBlank(receivedEventId)) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint= config.End_Point_URL__c+receivedEventId;
            system.debug('endpoint**'+endpoint);
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization', 'Bearer ' + config.Access_Token__c);
            request.setBody(requestBody);
            System.debug('requestBody in future'+requestBody);
            System.debug('requestBody in future'+JSON.serialize(requestBody));
            System.debug('requestBody in recordId'+recordId);   
            system.debug('request body to concierge **'+ request);
            HttpResponse response = http.send(request);
            
            IBConciergeStaging__c updatedRecord = new IBConciergeStaging__c(
                Id = recordId,
                Request_Body_Sent_To_Concierge__c= requestBody,
                Final_Response_From_API__c = response.getBody(),
                Final_Response_Code__c = response.getStatusCode()
            );
            
            update updatedRecord;
        }
    }
    
    
    
    public QueueableConcierge(List<IBConciergeStaging__c> stagingRecords) {
        this.stagingRecords = stagingRecords;
    }
    
    public  void execute(QueueableContext context) {
        
        IBConciegeResponse response = new IBConciegeResponse();
        List<Campaign> events;  
        List<Campaign> childEvents =new List<Campaign>(); 
        List<Campaign> parentEvents = new List<Campaign>();
        
        String errorMessage ;
        
        String mtbaRemarks; 
        String programmeName;
        Database.SaveResult[] saveResults;
        List<IBConciergeStaging__c> ibConciergeStagingList = new List<IBConciergeStaging__c>();
        
        try{
            
            
            for(IBConciergeStaging__c icStage: stagingRecords)
            {
                
                IB_Wrapper collection  = (IB_Wrapper) System.JSON.deserialize(icStage.Received_Payload__c,IB_Wrapper.class);
                
                system.debug('collection**'+collection.processReference.split('/')[2]);
                
                if(String.isBlank(collection.eventName)  || String.isBlank(collection.schoolCode)  || 
                   String.isBlank(collection.processReference) || collection.programmeCodes.isEmpty()  ) {
                       
                       response.accepted= 'false';
                       ErrorMessage errorMessageResponse = new ErrorMessage();
                       errorMessageResponse.reason='eventName or schoolCode or processReference or programmeCodes is missing';
                       errorMessageResponse.error= 'Validation Error';
                       response.error= errorMessageResponse;
                       system.debug('response**'+response);
                       String requestBody = '{"error": {"error": "Validation Error","reason": "eventName or schoolCode or processReference or programmeCodes is missing"}, "accepted":"false"}'; // Customize based on your needs
                       QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);//requestBody,String.valueOf(response)
                   }
                
                else{
                    try{
                        System.debug('Entered in Try block====>'+collection.programmeCodes);
                        for(integer i=0; i< collection.programmeCodes.size();i++) {
                            if(collection.programmeCodes[i]=='DP') {
                                collection.programmeCodes[i]='Diploma Programme';
                            }
                            
                        }
                        
                        system.debug('collection.schoolCode **'+collection.schoolCode );
                        system.debug('collection.programmeCodes **'+collection.programmeCodes );
                         system.debug('collection.collection.processReference. **'+Integer.valueOf(collection.processReference.split('/')[2] ));
                        
                        events=[select id,name,MTBA_Deadline__c,Deadline_to_Submit_Docs__c,MTBA_Remarks__c,Sub_Type__c,Programme_Visit_RecordType__c,
                                StartDate,EndDate from Campaign where  Account_IBIS_Code__c =: collection.schoolCode  
                                and Type='Evaluation'  
                                and IB_Docs_ID__c='2020' 
                                and CALENDAR_YEAR(Deadline_to_Submit_Docs__c )=: Integer.valueOf(collection.processReference.split('/')[2])
                                and Status in  ('Pending','Planned / Ready for Staffing', 'Staffing in Progress', 'Staffed','Complete' ) 
                                and Programme_Visit_RecordType__c in: collection.programmeCodes];
                        system.debug('events**'+events.size());
                        
                        if(events.isEmpty()){ 
                            String requestBody = '{"error": {"error": "Validation Error","reason": "Events with specified programmeCodes not found"}, "accepted":"false"}'; // Customize based on your needs
                            QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);
                        }
                        else if(events != null && !events.isEmpty()){ 
                            system.debug('Insdie events**');
                            for(Campaign campEvent : events) {
                                for(IB_Wrapper.TriggerEventNames triggerEvent:  collection.triggerEventNames){
                                    /**if(campEvent.Sub_Type__c !='Preliminary Review' && (collection.eventName.contains('evaluation') || collection.eventName.contains('mtba'))){
                                       
                                        if(triggerEvent.triggerName == 'PL/EL/Chair submitted date for Evaluation report'){
                                            system.debug('Insdie triggerName**');
                                            
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            if(triggerEvent.isLEAssigned == false){
                                                campEvent.Status_IB_Docs__c = 'Staffed internally';
                                                campEvent.IB_Docs_status_date__c = ibConciergeDate;
                                                campEvent.Evaluation_Report_Received__c=ibConciergeDate;
                                                campEvent.Report_Received_Date__c=ibConciergeDate;
                                                campEvent.Evaluation_Report_Submitted_by_IB__c=ibConciergeDate.addDays(91);
                                            }else
                                            {
                                                campEvent.Status_IB_Docs__c = 'Review by Lead Educator';
                                                campEvent.IB_Docs_status_date__c = ibConciergeDate;
                                                campEvent.Evaluation_Report_Received__c=ibConciergeDate;
                                                campEvent.Report_Received_Date__c=ibConciergeDate;
                                                campEvent.Evaluation_Report_Submitted_by_IB__c=ibConciergeDate.addDays(91);
                                                campEvent.Report_Due_Date_Editable__c=ibConciergeDate.addDays(14);
                                                
                                            }
                                        }
                                       
                                        
                                        if(triggerEvent.triggerName == 'IBWSM submitted date for Evaluation Report (stage 2)'){
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            campEvent.Report_finalized__c = ibConciergeDate;
                                        }
                                        if(triggerEvent.triggerName == 'IBWSS upload date for Final Evaluation Report (stage 2)'){
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            campEvent.RD_s_Letter_and_Report_to_School__c = ibConciergeDate;
                                        }
                                      
                                        if(triggerEvent.triggerName == 'LE submits reviewed report for IBWSM final review and approval'){
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            campEvent.Status_IB_Docs__c = 'Internal review by programme';
                                            campEvent.IB_Docs_status_date__c=ibConciergeDate;
                                            campEvent.Evaluation_Report_Received__c=ibConciergeDate;
                                            campEvent.Report_Received_Date__c=ibConciergeDate;
                                            
                                        }
                                       
                                        
                                        
                                      
                                        if(triggerEvent.triggerName == 'Stage 2 date (MTBA deadline)' || triggerEvent.triggerName == 'Stage 2 — MTBA Deadline last modified date' || triggerEvent.triggerName == 'Stage 2 — MTBA Docs uploaded overview (additional documents - Matters To Be Addressed)') {
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            campEvent.MTBA_Date_received__c = ibConciergeDate;
                                            campEvent.Status_MTBA__c = 'Documentation complete';
                                            campEvent.Status_MTBA_date__c = ibConciergeDate;
                                        }
                                        
                                        if(triggerEvent.triggerName == 'IBWSS upload date for IB Response to School’ s Report on Matters to be Addressed (stage 2)'){
                                            Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                            campEvent.Status_MTBA_date__c = ibConciergeDate;//(Status MTBA date)
                                        }
                                        
                                        parentEvents.add(campEvent);
                                        system.debug('parentEvents**'+parentEvents.size());
                                        break;
                                    }
                                    
                                    else**/ if(campEvent.Sub_Type__c =='Preliminary Review' &&  
                                            ((collection.eventName.contains('preliminary')) || (collection.eventName.contains('self_study')))){
                                                
                                                if(triggerEvent.triggerName == 'Preliminary Review not requested by deadline') {
                                                    Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                    campEvent.Status_IB_Docs__c='Documents Missing';
                                                    campEvent.IB_Docs_status_date__c= ibConciergeDate;
                                                    campEvent.New_deadline__c= ibConciergeDate.addDays(7);
                                                    campEvent.StartDate=ibConciergeDate.addDays(7);
                                                    campEvent.EndDate=campEvent.EndDate.addDays(7);//ibConciergeDate.addDays(7);
                                                    
                                                }
                                                
                                                if(triggerEvent.triggerName == 'Preliminary Review requested by school before deadline') {
                                                    Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                    campEvent.Status_IB_Docs__c='Documentation Complete';
                                                    campEvent.IB_Docs_status_date__c= ibConciergeDate;
                                                    
                                                }
                                                
                                                                                               
                                                if(triggerEvent.triggerName == 'PL submitted date for PR report') {
                                                    
                                                    // new logic needs to be added based on section statuses if, section statuses contains all submitted
                                                    // for all programmes only then pick this record for updation 
                                                    
                                                    Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                    if( campEvent.MTBA_Deadline__c == null){
                                                        
                                                        Boolean containsOtherThansubmitted = false; // added on 13-2-2025 
                                                        for (String value : collection.triggerEventNames[0].sectionStatuses.VALUES()) {
                                                            if (value != 'submitted') {
                                                                containsOtherThansubmitted = true;
                                                                break; 
                                                            }
                                                        }
                                                        if(containsOtherThansubmitted){
                                                            
                                                        }else{
                                                            
                                                            campEvent.Status_IB_Docs__c='Internal review by programme';
                                                            campEvent.IB_Docs_status_date__c= ibConciergeDate;
                                                            campEvent.Evaluation_Report_Received__c= ibConciergeDate; 
                                                            campEvent.Report_Received_Date__c= ibConciergeDate;
                                                            campEvent.Report_Due_Date_Editable__c= ibConciergeDate.addDays(14); 
                                                            campEvent.Evaluation_Report_Submitted_by_IB__c= ibConciergeDate.addDays(14); 
                                                        }
                                                    }
                                                    else{
                                                        campEvent.Status_MTBA__c='Internal review by Programme';
                                                        campEvent.Status_MTBA_date__c = ibConciergeDate;
                                                    }
                                                }
                                       			 if(triggerEvent.triggerName == 'IBWSM Approval Date For PR Report' || 
                                                   triggerEvent.triggerName == 'IBWSM submitted date for PR report (1st publishing)' 
                                                  ){
                                                      Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                      if(triggerEvent.DPEvaluationOutcome == 'MTBA' || triggerEvent.CPEvaluationOutcome == 'MTBA' ||
                                                         triggerEvent.MYPEvaluationOutcome == 'MTBA' || triggerEvent.PYPEvaluationOutcome == 'MTBA' ){
                                                             campEvent.MTBA_Deadline__c=ibConciergeDate.addDays(21);
                                                             campEvent.Status_MTBA_date__c=ibConciergeDate;
                                                         }
                                                      if(triggerEvent.PYPEvaluationOutcome!= null)
                                                          campEvent.PYP_Outcome__c = triggerEvent.PYPEvaluationOutcome;
                                                      if(triggerEvent.MYPEvaluationOutcome!= null)
                                                          campEvent.MYP_Outcome__c = triggerEvent.MYPEvaluationOutcome;
                                                      if(triggerEvent.CPEvaluationOutcome!= null)
                                                          campEvent.CP_Evaluation_Outcome__c = triggerEvent.CPEvaluationOutcome;
                                                      if(triggerEvent.DPEvaluationOutcome!= null)
                                                          campEvent.Evaluation_outcome__c = triggerEvent.DPEvaluationOutcome;
                                                      campEvent.Status='Complete';
                                                      campEvent.RD_s_Letter_and_Report_to_School__c=ibConciergeDate;
                                                      campEvent.Report_finalized__c=ibConciergeDate;
                                                      campEvent.Status_IB_Docs__c='Report uploaded for school';
                                                      campEvent.IB_Docs_status_date__c=ibConciergeDate;
                                                    }
                                                if(triggerEvent.triggerName.contains('PR outcome')) {
                                                    system.debug('PR outcome***');
                                                    system.debug('PR outcome dp***'+triggerEvent.DPEvaluationOutcome);
                                                    if(triggerEvent.DPEvaluationOutcome!= null){
                                                        campEvent.Evaluation_outcome__c = triggerEvent.DPEvaluationOutcome;
                                                    }
                                                    if(triggerEvent.CPEvaluationOutcome!= null){
                                                        campEvent.CP_Evaluation_Outcome__c = triggerEvent.CPEvaluationOutcome;
                                                    }
                                                    if(triggerEvent.MYPEvaluationOutcome!= null){
                                                        campEvent.MYP_Outcome__c = triggerEvent.MYPEvaluationOutcome;
                                                    }if(triggerEvent.PYPEvaluationOutcome!= null){
                                                        campEvent.PYP_Outcome__c = triggerEvent.PYPEvaluationOutcome;
                                                    }
                                                }
                                                if(triggerEvent.triggerName == 'PC request review date for pMTBA evidence uploaded'){
                                                    Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                    campEvent.MTBA_Date_received__c = ibConciergeDate;  
                                                    campEvent.Status_MTBA__c = 'Documentation Complete';
                                                    campEvent.Status_MTBA_date__c =  ibConciergeDate;
                                                    }
                                                
                                                
                                              
                                                if(triggerEvent.triggerName == 'IBWSM submitted date for PR re-publishing (after pMTBA review)') {
                                                    Date ibConciergeDate=triggerEvent.IBConciergeDate != null ? Date.valueOf(triggerEvent.IBConciergeDate) : null;
                                                   // campEvent.MTBA_Date_received__c = ibConciergeDate;
                                                    
                                                    if(triggerEvent.DPEvaluationOutcome =='MTBA' || triggerEvent.CPEvaluationOutcome =='MTBA'
                                                       || triggerEvent.MYPEvaluationOutcome =='MTBA' || triggerEvent.PYPEvaluationOutcome =='MTBA'
                                                      ){
                                                          if((!String.isBlank(campEvent.MTBA_Remarks__c) ) && (triggerEvent.MTBARemarks!= '' || triggerEvent.MTBARemarks != null) ){
                                                              campEvent.MTBA_Remarks__c=  campEvent.MTBA_Remarks__c+ '' + '\n'+ triggerEvent.MTBARemarks ;
                                                          }else
                                                          {
                                                              campEvent.MTBA_Remarks__c=  triggerEvent.MTBARemarks ;
                                                          }
                                                          campEvent.Status_MTBA__c='';
                                                          campEvent.Status_MTBA_date__c = ibConciergeDate;
                                                          campEvent.Evaluation_MTBA_Letter_from_IB__c = 'Partially Resolved';
                                                          campEvent.Additional_Documents_for_MTBA_due__c=ibConciergeDate.addDays(21);
                                                          campEvent.MTBA_Date_received__c=null;
                                                      }
                                                    else if(triggerEvent.DPEvaluationOutcome =='Requirements met' ||  triggerEvent.CPEvaluationOutcome =='Requirements met'
                                                       || triggerEvent.MYPEvaluationOutcome =='Requirements met' || triggerEvent.PYPEvaluationOutcome =='Requirements met'){
                                                           
                                                          campEvent.Status_MTBA__c='Report uploaded for school';
                                                          campEvent.Status_MTBA_date__c = ibConciergeDate;
                                                          campEvent.Evaluation_MTBA_Letter_from_IB__c = 'Resolved';
                                                    }
                                                    
                                                   
                                                    }
                                                
                                                childEvents.add(campEvent);
                                                break;
                                                
                                            }
                                }
                                
                            }
                            if(!childEvents.isEmpty()){
                                system.debug('childEvents size**'+childEvents.size());
                                saveResults = Database.update(childEvents, true);
                                
                            }
                            if(!parentEvents.isEmpty()){
                                system.debug('parentEvents size**'+parentEvents.size());
                                saveResults = Database.update(parentEvents, true);
                                
                            }
                            
                            
                            //saveResults = Database.update(events, false);
                            system.debug('saveResults**'+saveResults);
                            if(saveResults!= null)
                                
                            { 
                                for (Database.SaveResult saveResult : saveResults) {
                                    if (saveResult.isSuccess()) {
                                        System.debug('Record Succesffully updated '+saveResult.getId());
                                        Boolean success= true;
                                        
                                        if(success== true){
                                            String requestBody = '{"error": null, "accepted":"true"}'; 
                                            QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);
                                            
                                            break;
                                        }
                                        
                                        
                                    } else {
                                        for (Database.Error error : saveResult.getErrors()) {
                                            errorMessage= 'Event with Id'+ saveResult.getId()+ 'Failed with reason' +  String.valueOf(error);
                                            System.debug('Record event update Failed'+error);
                                            Boolean success= false;
                                            if(success== false){
                                                String requestBody = '{"error": "Validation Error","reason":'+'"'+errorMessage+'"'+', "accepted":"false"}';
                                                QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);
                                                break;
                                            }
                                            
                                            
                                            
                                        }
                                    }
                                }
                            }else
                            {
                                String requestBody = '{"error": {"error": "Validation Error","reason": "No proper event found for updation, please reach salesforce admin team"}, "accepted":"false"}'; // Customize based on your needs
                                
                                QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);
                                
                                
                            }
                        }
                        
                    }catch(Exception e)
                    {             
                        system.debug('try inner exception here **'+e.getMessage()+e.getCause()+e.getLineNumber() );
                        errorMessage = e.getMessage()+
                            'Cause:' + e.getCause()+
                            'Line no:' + e.getLineNumber();
                        String requestBody = '{"error": {"error": "Validation Error","reason":'+ '"'+ errorMessage+ '"'+''+'},"accepted":"false"}';
                        system.debug('requestBody***'+requestBody);
                        
                        QueueableConcierge.futureCallToConcierge(icStage.Id,requestBody, icStage.Received_Event_Id__c);
                        
                        
                    }
                }
                
            }
            update ibConciergeStagingList;
        }catch(Exception e)
        {
            errorMessage = e.getMessage()+
                'Cause:' + e.getCause()+
                'Line no:' + e.getLineNumber();
            system.debug('errorMessage***'+errorMessage);
            
            
            
        }
        
        
    }
    
    
    
}