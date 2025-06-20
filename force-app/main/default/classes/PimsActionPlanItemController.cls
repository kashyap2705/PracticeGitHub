public class PimsActionPlanItemController { 
    
    transient Id itemId;
    
    public List<Attachment> attachments { get; set; }
    public Attachment attachment { get; set; }
    public String deleteDocId { get; set; }
    
    public Account account { get; set; }
    public IB_Programme__c programme { get; set; }
    public List<IB_Action_Plan__c> actionPlan { get; set; }
    public IB_Action_Plan__c actionPlanItem { get; set; }
    public Boolean showPageDetails {get; set;}
    
    public String actionPlanDate { get; set; }
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
        
        PageService.setPage('PimsActionPlan');
        
    }
    private final List<String> constantList = new List<String>{IboUtil.Action_Plan,IboUtil.Action,IboUtil.Action_Item,IboUtil.Action_Plan_Item,
        IboUtil.Action_Type,IboUtil.Back_to_Action_Plan,IboUtil.Budgetary_Implications,IboUtil.Created_Date,IboUtil.Documents,IboUtil.Due_Date,
        IboUtil.Evidence_of_Achievement,IboUtil.MTBA_Evidence,IboUtil.MTBA_Review,IboUtil.Person_Responsible,IboUtil.Practice,IboUtil.Process_Stage,
        IboUtil.Programme,IboUtil.Requirement,IboUtil.Standard,IboUtil.Status,IboUtil.Update_Action_Item,IboUtil.Upload_Document,
        IboUtil.Add_Document,IboUtil.File,IboUtil.Description,IboUtil.Limit_Message_For_File_Upload};
            
            public String Action_Plan {
                get {
                    return this.getTranslationsMap().get(IboUtil.Action_Plan);
                }
                set;
            }
         public String Action {
                get {
                    return this.getTranslationsMap().get(IboUtil.Action);
                }
                set;
            }
         public String Action_Item {
                get {
                    return this.getTranslationsMap().get(IboUtil.Action_Item);
                }
                set;
            }
         public String Action_Plan_Item {
                get {
                    return this.getTranslationsMap().get(IboUtil.Action_Plan_Item);
                }
                set;
            }
         public String Action_Type {
                get {
                    return this.getTranslationsMap().get(IboUtil.Action_Type);
                }
                set;
            }
         public String Back_to_Action_Plan {
                get {
                    return this.getTranslationsMap().get(IboUtil.Back_to_Action_Plan);
                }
                set;
            }
         public String Budgetary_Implications {
                get {
                    return this.getTranslationsMap().get(IboUtil.Budgetary_Implications);
                }
                set;
            }
         public String Created_Date {
                get {
                    return this.getTranslationsMap().get(IboUtil.Created_Date);
                }
                set;
            }
         public String Documents {
                get {
                    return this.getTranslationsMap().get(IboUtil.Documents);
                }
                set;
            }
         public String Due_Date {
                get {
                    return this.getTranslationsMap().get(IboUtil.Due_Date);
                }
                set;
            }
         public String Evidence_of_Achievement {
                get {
                    return this.getTranslationsMap().get(IboUtil.Evidence_of_Achievement);
                }
                set;
            }
         public String MTBA_Evidence {
                get {
                    return this.getTranslationsMap().get(IboUtil.MTBA_Evidence);
                }
                set;
            }
         public String MTBA_Review {
                get {
                    return this.getTranslationsMap().get(IboUtil.MTBA_Review);
                }
                set;
            }
         public String Person_Responsible {
                get {
                    return this.getTranslationsMap().get(IboUtil.Person_Responsible);
                }
                set;
            }
         public String Practice {
                get {
                    return this.getTranslationsMap().get(IboUtil.Practice);
                }
                set;
            }
         public String Process_Stage {
                get {
                    return this.getTranslationsMap().get(IboUtil.Process_Stage);
                }
                set;
            }
         public String IB_Programme {
                get {
                    return this.getTranslationsMap().get(IboUtil.Programme);
                }
                set;
            }
         public String Requirement {
                get {
                    return this.getTranslationsMap().get(IboUtil.Requirement);
                }
                set;
            }
         public String Standard {
                get {
                    return this.getTranslationsMap().get(IboUtil.Standard);
                }
                set;
            }
         public String Status {
                get {
                    return this.getTranslationsMap().get(IboUtil.Status);
                }
                set;
            }
         public String Update_Action_Item {
                get {
                    return this.getTranslationsMap().get(IboUtil.Update_Action_Item);
                }
                set;
            }    
        public String Upload_Document {
                get {
                    return this.getTranslationsMap().get(IboUtil.Upload_Document);
                }
                set;
            }  
        public String Add_Document {
                get {
                    return this.getTranslationsMap().get(IboUtil.Add_Document);
                }
                set;
            }  
        public String File {
                get {
                    return this.getTranslationsMap().get(IboUtil.File);
                }
                set;
            }  
        public String IB_Description {
                get {
                    return this.getTranslationsMap().get(IboUtil.Description);
                }
                set;
            }  
        public String Limit_Message_For_File_Upload {
                get {
                    return this.getTranslationsMap().get(IboUtil.Limit_Message_For_File_Upload);
                }
                set;
            }  
    
    
    public static final Map<String, String> languageCodeMap {
        get {
            Map<String, String> languageMap = new Map<String, String>();
            languageMap.put('fr', 'French');
            languageMap.put('es', 'Spanish');
            return languageMap;
        }
    }
    
    public PimsActionPlanItemController() {
        try
        {
            PageService.setPage('PimsActionPlan');
            
            itemId = ApexPages.currentPage().getParameters().get('id');
            
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            
            account = AccountService.getAccount();
            
            showPageDetails = pimsService.isMySchoolRole(account.Id,pimsService.getCurrentContact().Id);        
            
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
                SELECT Id, Name, Description, ContentType 
                FROM Attachment 
                WHERE Parentid = :actionPlanItem.Id
            ];
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
        
    }
    
    transient Map<String, String> translationsMap;
    
    public  Map<String, String> getTranslationsMap() {        
        if (null == this.translationsMap) {
            try {
                String userLanguage = null != languageCodeMap.get(UserInfo.getLanguage()) ? languageCodeMap.get(UserInfo.getLanguage()) : 'American English';
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                     WHERE CustomLabel__r.Label__c =: constantList
                                                     AND Language__c = :userLanguage];
                
                this.translationsMap = new Map<String, String>();
                
                for (Translation__c translation : translations) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                } 
            }
            catch (Exception ex) {
                Logger.get().add(ex, LogSeverity.ERROR).publish();             
            }
        }
        
        return this.translationsMap;
    }
    
    
    public String getUrlCommunityPath() {
        
        String currUrl = ApexPages.currentPage().getUrl();
        
        if (currUrl.contains('PimsActionPlanItem')) {
            return '/pims/';
        }
        else if (currUrl.contains('IbenActionPlanItem')) {
            return '/educator/';
        }
        else {
            return null;
        }
        
    }
    
    public PageReference save() {
        
        try {
            
            actionPlanItem.AP_Due_Date__c = Date.parse(actionPlanDate);
            // actionPlanItem.AP_Status__c=actionPlanItem.AP_Status__c;
            
            update actionPlanItem;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Action_Item_Updated));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference upload() {
        try {
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = actionPlanItem.Id;
            attachment.IsPrivate = false;
            
            insert attachment;
            
            attachment.body= null;
            /*
catch (DMLException e) {

ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Uploading_Attachment));
return null;

} 
finally {

attachment = new Attachment(); 

}
*/
            attachments = [
                SELECT Id, Name, Description, ContentType 
                FROM Attachment 
                WHERE Parentid = :actionPlanItem.Id
            ];
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, Label.Attachment_uploaded));
            return null;
        } 
        Catch(Exception ex)
        {
            System.Debug(ex);
            attachment.body= null;// to avoid view state error in exception
            return NULL;
            
        }
        
    }
    
    public PageReference removeDocument() {
        
        try {
            
            Attachment docToRemove = new Attachment();
            docToRemove.Id = deleteDocId;
            
            /*Attachment docToRemove = [
SELECT Id, Name, Body, Description, ContentType 
FROM Attachment 
WHERE Id = :deleteDocId
];*/
            
            delete docToRemove;
            
            attachments = [
                SELECT Id, Name, Description, ContentType 
                FROM Attachment 
                WHERE Parentid = :actionPlanItem.Id
            ];
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Document_Delete));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            
        }
        
        return null;
        
    }
    
}