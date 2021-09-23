public class EnhancedAuditTrackingCont {
    
    public id recordId{get;set;}
    public string objName{get;set;}
    public boolean viewAllClassic{get;set;}
    public integer rowLimit{get;set;}
    public integer rowOffSet{get;set;}
    
    public EnhancedAuditTrackingCont(){
        objName = '';
        rowOffSet = 0;
        rowLimit = 20;
        viewAllClassic=true;
        recordId = ApexPages.CurrentPage().getparameters().get('id');
        objectName(recordId);
    }

    public void objectName(id recId){
        objName = recId.getSObjectType().getDescribe().getName();
    }
}