public class PimsApplicationPrintController extends PimsApplicationControllerHelper{
    
    public Boolean sent {get;set;}
    
    // This var sets the appropriate CSS class based on the nature of the message to be sent to the UI
    public String outcome {get;set;}

    public Pagereference callConga(){
        
        ApexPages.Message result;
        
        try{
			//Feb15th,2023 INC0168892 Benjamin McGarvey
			List<IB_Application__c> tmp = [select conga_print__c, Conga_Emailto__c from IB_Application__c where Id =: ApexPages.currentPage().getParameters().get('id')];
            
            if(tmp.size()>0){
                tmp[0].conga_print__c = true;
                tmp[0].Conga_Emailto__c = [select contactId from User where Id =: UserInfo.getUserId()][0].contactId;// Not as bad as it looks.
                update tmp;
            }
        }
        catch(Exception e){
            result = new ApexPages.Message(ApexPages.Severity.ERROR, Label.PIMS_AFC_Print_Error);
            outcome = 'alert';
        }
        
        if(result == null){
            result = new ApexPages.Message(ApexPages.Severity.INFO, Label.PIMS_AFC_Print_Success);
            outcome = 'success';
        }
        
        sent = true;
        ApexPages.addMessage(result);
        
        return null;
    }
    public Pagereference clearMessage(){
        sent = sent == true ? false : true;
        return null;
    }
}