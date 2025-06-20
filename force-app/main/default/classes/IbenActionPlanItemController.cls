public class IbenActionPlanItemController { 
    
    transient Id itemId;
    
    public List<Attachment> attachments { get; set; }
    public Attachment attachment { get; set; }
    
    public Account account { get; set; }
    public IB_Programme__c programme { get; set; }
    public List<IB_Action_Plan__c> actionPlan { get; set; }
    public IB_Action_Plan__c actionPlanItem { get; set; }
    
    public String actionPlanDate { get; set; }
    //public List<ActivityHistory> activityHistory { get; set; }
    //
    public String description { get; set; }
    public String fileName { get; set; }
    public Blob fileBody { get; set; }
    
    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }
    
    public void init() {
        
        PageService.setPage('IbenActionPlan');
        
    }
    
    public IbenActionPlanItemController() {
        try
        {
            
            PageService.setPage('IbenActionPlan');
            
            itemId = ApexPages.currentPage().getParameters().get('id');
            
            // Keeping this pointing to PIMS instead of creating IBEN versions.  
            // Can reevaluate this later if needed. 
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            
            account = AccountService.getAccount();
            
            ActionPlanService.setItemId(itemId);
            actionPlanItem = ActionPlanService.getActionPlanItem();
            ActionPlanService.setProgrammeId(actionPlanItem.Programme__r.Id);
            actionPlan = ActionPlanService.getActionPlanByProgramme();
            
            ProgrammeService.setProgrammeId(actionPlanItem.Programme__r.Id);
            programme = ProgrammeService.getProgramme();
            
            if (actionPlanItem.AP_Due_Date__c != null) {
                actionPlanDate = actionPlanItem.AP_Due_Date__c.format();
            }
            
            attachment = new Attachment(); 
            
            attachments = [
                SELECT Id, Name, Body, Description, ContentType 
                FROM Attachment 
                WHERE Parentid = :actionPlanItem.Id
            ];
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
        
    }
    
    public PageReference save() {
        
        try {
            
            actionPlanItem.AP_Due_Date__c = Date.parse(actionPlanDate);
            update actionPlanItem;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Action_Item_Updated));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference upload() {
        try
        {
            System.debug(actionPlanItem);    
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = actionPlanItem.Id;
            attachment.IsPrivate = false;
            /*
try {

insert attachment;

} 
catch (DMLException e) {

ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Uploading_Attachment));
return null;

} 
finally {

attachment = new Attachment(); 

}
*/
            attachments = [
                SELECT Id, Name, Body, Description, ContentType 
                FROM Attachment 
                WHERE Parentid = :actionPlanItem.Id
            ];
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Attachment_uploaded));
            return null;
        }
        
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
    
}