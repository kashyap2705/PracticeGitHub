/*******************************************************************************************
* @Name         IBConciergeDataIntegration 
* @Author       
* @Date          
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0             Kashyap                      ECM00564-

/services/apexrest/dataexchange/v1/ibConciergeData
*******************************************************************************************/
@RestResource(urlMapping='/dataexchange/v1/ibConciergeData1')
global class IBConciergeDataIntegration1 {
    @httpPost
    global static IBConciegeResponse doPost( ){
        
        IBConciegeResponse response = new IBConciegeResponse();
        RestRequest req = RestContext.request;
        String jsonInput = req.requestBody.toString() ;
        String errorMessage ;
        IBConciergeStaging__c ibConciergeStaging = new IBConciergeStaging__c(); 
        
        
        try{
            if(!String.isBlank(jsonInput) ){
                ibConciergeStaging.Received_Payload__c=jsonInput;
                Map<String, Object> payloadMap = (Map<String, Object>) JSON.deserializeUntyped(jsonInput);
                ibConciergeStaging.Received_Event_Id__c = (String) payloadMap.get('eventId') != null ? (String) payloadMap.get('eventId') : '';
                insert ibConciergeStaging;
              
            }}catch(Exception e)
        {
            errorMessage = e.getMessage()+
                'Cause:' + e.getCause()+
                'Line no:' + e.getLineNumber();
            system.debug('errorMessage***'+errorMessage);
            
            errorMessage= e.getMessage();
            ErrorMessage errorMessageResponse = new ErrorMessage();
            errorMessageResponse.reason='Payload Insertion failure, Please verify json';
            errorMessageResponse.error='Data Insertion Error';
            response.error= errorMessageResponse;
            response.accepted= 'false';
       	    return response;
        }
        
      return null;
       
        
    }
    
    global class IBConciegeResponse{
       
        global String accepted;
        global ErrorMessage error;
    }
    
    
    global class ErrorMessage{
        global String reason;
        global String error;
    }
    
}