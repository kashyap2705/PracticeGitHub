public class ActionPlanDAO {
    
    private static final ActionPlanDAO instance = new ActionPlanDAO();
    private List<IB_Action_Plan__c> actionPlan;
    private IB_Action_Plan__c actionPlanItem;
    
    private ActionPlanDAO() {}
    
    public static ActionPlanDAO getInstance() {
        return instance;
    }
    
    public IB_Action_Plan__c getActionPlanItem(Id actionPlanId) {
        try
        {
            actionPlanItem = [
                SELECT Id, OwnerId, Owner.Name, IsDeleted, Name, AP_Authorization_Status__c, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, 
                AP_Achievement_Evidence__c, AP_Action_Description__c, AP_Action_ID__c, AP_Action_Type__c, AP_Budgetary_Implications__c, AP_Document_Description__c, AP_Due_Date__c, 
                AP_Last_Modified__c, AP_MTBA_Evidence__c, AP_MTBA_Review__c, AP_Standard__c, AP_Status__c, AP_Task_Name__c, Programme__c, Programme__r.Id, AP_Standard_Practice__c, 
                AP_Standard_Practice__r.Standard__c, AP_Standard_Practice__r.Practice__c, AP_Standard_Practice__r.Required_For_Candidacy__c, AP_Standard_Practice__r.Required_For_Authorization__c, 
                AP_Standard_Practice__r.In_Progress_For_Candidacy__c, AP_Standard_Practice__r.In_Progress_For_Authorization__c 
                FROM IB_Action_Plan__c 
                WHERE Id = :actionPlanId
                ORDER BY Name
            ];
            
            return actionPlanItem;
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
    
    public List<IB_Action_Plan__c> getActionPlan(Id programmeId) {
        
        actionPlan = [
            SELECT Id, OwnerId, Owner.Name, IsDeleted, Name, AP_Authorization_Status__c, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, 
            AP_Achievement_Evidence__c, AP_Action_Description__c, AP_Action_ID__c, AP_Action_Type__c, AP_Budgetary_Implications__c, AP_Document_Description__c, AP_Due_Date__c, 
            AP_Last_Modified__c, AP_MTBA_Evidence__c, AP_MTBA_Review__c, AP_Standard__c, AP_Status__c, AP_Task_Name__c, Programme__c, Programme__r.Id, AP_Standard_Practice__c, 
            AP_Standard_Practice__r.Standard__c, AP_Standard_Practice__r.Practice__c, AP_Standard_Practice__r.Required_For_Candidacy__c, AP_Standard_Practice__r.Required_For_Authorization__c, 
            AP_Standard_Practice__r.In_Progress_For_Candidacy__c, AP_Standard_Practice__r.In_Progress_For_Authorization__c 
            FROM IB_Action_Plan__c 
            WHERE Programme__c = :programmeId
            ORDER BY Name
        ];
        
        return actionPlan;
        
    }
    
    
    
}