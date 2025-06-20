public without sharing class ICFSectionB2Controller extends PimsApplicationControllerHelper {
    
    private String appId;
    public String accId;
    public Boolean isEndOfProcess {get;set;}
    public String FeasibilityLeads {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public PageReference activeContent {get;set;}
    
    public Decimal pcTimeAllocTotal {get;set;}
    public Decimal slcTimeAllocTotal {get;set;}
    
    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public transient List<IB_Consultant_Feedback__c> consFeedbackList {get; set;}
    public IB_Application__c application {get;set;}
    public IB_Application_Assessment__c assessment {get;set;}
    public IB_Programme__c programme {get;set;}
    public Map<Id,Set<Role_Application_Subject__c>> roleAppSubjectMap {get;set;}
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
    public List<Application_Budget_Table__c> applicationBudgetList {
        get{
            if(applicationBudgetList == null){
                
                applicationBudgetList = new List<Application_Budget_Table__c>([
                    SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                    PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                    PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
                    Fee_Item__c
                    FROM Application_Budget_Table__c
                    WHERE IB_Programme__c = :programme.Id
                ]);
            }
            
            return applicationBudgetList;
        }
        set;
    }
    public String[] lines {get;set;}
    public List<IB_Role__c> rolesByProgramme {get;set;}
    public List<IB_Role__c> rolesByProgramme_T {get;set;}
    public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
    public List<Contact_Professional_Development__c> proDevByRoles {get;set;}
    
    public List<Application_Meeting_Chart__c> applicationMeetingList {
        get{
            if(applicationMeetingList == null){
                applicationMeetingList = new List<Application_Meeting_Chart__c>([
                    SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
                    FROM Application_Meeting_Chart__c
                    WHERE IB_Application_Lookup__c = :appId
                ]);
            }
            
            return applicationMeetingList;
        }
        set;
    }
    public List<Application_Account_Facilities__c> applicationFacilityList {
        get{
            if(applicationFacilityList == null){
                applicationFacilityList = new List<Application_Account_Facilities__c>([
                    
                    // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
                    //begin  
                    
                    /* SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
FROM Application_Account_Facilities__c
WHERE IB_Application_Lookup__c = :appId*/
                    
                    SELECT Id, IB_Application_Lookup__c, Account__c,B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                    FROM Application_Account_Facilities__c
                    WHERE IB_Application_Lookup__c = :appId
                    
                ]);
                //End
            }
            
            return applicationFacilityList;
        }
        set;
    }
    public List<Application_Teaching_Time__c> applicationTeachingTimeList {
        get{
            if(applicationTeachingTimeList == null){
                applicationTeachingTimeList = new List<Application_Teaching_Time__c>([
                    SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
                    B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
                    FROM Application_Teaching_Time__c
                    WHERE IB_Application_Lookup__c = :appId
                ]);
            }
            return applicationTeachingTimeList;
        }
        set;
    }
    
    public List<Application_Coordinator_Time__c> progCoordinatorTimeList {get;set;}
    public List<Application_Coordinator_Time__c> serviceCoordinatorTimeList {
        get{
            
            if(serviceCoordinatorTimeList == null){
                serviceCoordinatorTimeList = new List<Application_Coordinator_Time__c>([
                    SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
                    Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                    FROM Application_Coordinator_Time__c
                    WHERE IB_Application_Lookup__c = :appId
                    AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS planner')
                ]);
            }
            
            return serviceCoordinatorTimeList;
        }
        set;
    }
    public List<Application_Library_Resources__c> applicationLibraryList {
        get{
            if(applicationLibraryList == null){
                applicationLibraryList = new List<Application_Library_Resources__c>([
                    SELECT B2_6_6_Additional_resources__c, B2_6_6_Fiction_Books__c, B2_6_6_General_Reference__c, B2_6_6_Languages__c, B2_6_6_Nonfiction_Books__c,
                    B2_6_6_Online_Journals__c, B2_6_6_Online_Reference__c, B2_6_6_Print_Periodicals__c, IB_Application_Lookup__c, Id, Name
                    FROM Application_Library_Resources__c
                    WHERE IB_Application_Lookup__c = :appId
                ]);
            }
            return applicationLibraryList;
        }
        set;
    }
    
    public Boolean isEditMode {get;set;}
    public String workingId {get;set;}
    public Boolean isEditable {get;set;}
    public Boolean showReturn {get;set;}
    
    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];
    
    public ICFSectionB2Controller() {
        if(getIsPyp()){
            activeContent = Page.ICFSectionB2_PYP;
        } else if(getIsMyp()){
            activeContent = Page.ICFSectionB2_MYP;
        } else if(getIsDp()){
            activeContent = Page.ICFSectionB2_DP;
        } else if(getIsCpPhase1()){
            activeContent = Page.ICFSectionB2_CP1;
        } else if(getIsCpPhase2()){
            activeContent = Page.ICFSectionB2_CP2;
        } 
        
        isEndOfProcess = false;
        pdCompletionStatus = false;
        appId = ApexPages.currentPage().getParameters().get('id');
        if (appId == null) throw new CustomValidationException(Label.PIMS_INVALID_APPID);
        
        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();
        subjectProposals = ApplicationService.getSubjectProposals();
        assessment = ApplicationService.getApplicationAssessment();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        programme = ProgrammeService.getProgramme();
        accId = programme.account__c;
        
        ConsultantFeedbackDAO dao = ConsultantFeedbackDAO.getInstance();
        consFeedbackList = dao.getRecordsByAppId(appId);
        
        // lines == budget lines dynamically create set of unique lines from query
        Set<String> lineSet = new Set<String>();
        for (Application_Budget_Table__c a : applicationBudgetList) {
            if (a.PR_12_budget_Line__c == 'Other' || a.PR_12_budget_Line__c == 'Resource' || a.PR_12_budget_Line__c == 'Professional Development' || a.PR_12_budget_Line__c == 'Fee') lineSet.add(a.PR_12_budget_Line__c);
        }
        
        // convert the set into a string array
        lines = new String[lineSet.size()];
        Integer i = 0;
        for (String line : lineSet) {
            lines[i] = line;
            i++;
        }
        
        RoleService.setAccountId(accId);
        RoleService.setProgrammeId(programme.Id);
        //rolesByProgramme = RoleService.getRolesByProgrammeId();
        
        /* Code added as part of APEX CPU Limit issues fix */
        
        rolesByProgramme = RoleService.getRolesByProgrammeId_B(accId,programme.Id); //non - teacher
        rolesByProgramme_T = RoleService.getRolesByProgrammeId_T(accId,programme.Id); // teacher
        
        List<Id> roleIdList_T = new List<Id>() ;
        if(rolesByProgramme_T.size()>0 ){
            for (IB_Role__c r : rolesByProgramme_T) {
                roleIdList_T.add(r.Id);
            }
        }
        
        RoleApplicationSubjectService.setRoleList(roleIdList_T);
        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
        
        roleAppSubjectMap = new Map<Id, Set<Role_Application_Subject__c>>();
        
        for(IB_Role__c teacher: rolesByProgramme_T){
            Set<Role_Application_Subject__c> subList = new Set<Role_Application_Subject__c>();
            for(Role_Application_Subject__c subject: subjectsByRoles){
                if(teacher.Id == subject.Role_And_Application__c){
                    subList.add(subject);
                }
            }
            roleAppSubjectMap.put(teacher.Id, subList);
        }
        System.debug('rolesByProgramme_T.size():'+rolesByProgramme_T.size());
        System.debug('subjectsByRoles.size():'+subjectsByRoles.size());
        System.debug('roleAppSubjectMap.size():'+roleAppSubjectMap.size());
        /* ------------------------------------------------------------------------------------------- */
        List<Id> roleIdList = new List<Id>() ;
        for (IB_Role__c r : rolesByProgramme) {
            roleIdList.add(r.Id);
        }
        
        ContactPDService.setRoleList(roleIdList);
        proDevByRoles = ContactPDService.getProfessionalDevelopmentByRoleList();
        
        slcTimeAllocTotal = 0;
        for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
            if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
            if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
        }
        
        isEditMode = false;
        isEditable = false;
        
        for(Profile tmp : [select Id, Name from Profile where Name IN :ICFlib.allowEdit]){
            
            if(UserInfo.getProfileId() == tmp.Id){
                isEditable = true;
            }
        }
        
        for (IB_Consultant_Feedback__c tmp : consFeedbackList) {
            if (tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                workingId = workingId != null ? workingId : tmp.Id;
            }
            if (tmp.RecordTypeId == endOfProcRecType.Id) {
                endOfProcFeedback = tmp;
                workingId = tmp.Id;
                isEndOfProcess = true;
            }
        }
        
        if(visitFeedback != null && visitFeedback.Status__c == 'Returned to Consultant'){
            endOfProcFeedback = null;
            isEndOfProcess = false;
            workingId = visitFeedback.Id;
        }
    }
    
    public Void saveAndReturn(){
        undoReturn();
        save();
    }
    
    public Void edit(){
        isEditMode = true;
    }
    
    public Void undoEdit(){
        isEditMode = false;
    }
    
    public Void doReturn(){
        showReturn = true;
    }
    
    public Void undoReturn(){
        showReturn = false;
    }
    
    public Void saveFromEdit(){
        undoEdit();
        
        if(visitFeedback != null && visitFeedback.Id == workingId){
            visitFeedback.Edited_by_Staff__c = true;
            update visitFeedback;
        }
        else if(endOfProcFeedback != null && endOfProcFeedback.Id == workingId){
            endOfProcFeedback.Edited_by_Staff__c = true;
            update endOfProcFeedback;
        }
    }
    
    public PageReference save(){
        
        try {
            if (isEndOfProcess) {
                endOfProcFeedback.B2_Complete__c = pdCompletionStatus;
                update endOfProcFeedback;
            }
            if (isEndOfProcess == false) {
                visitFeedback.B2_Complete__c = pdCompletionStatus;
                update visitFeedback;
            }
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B2_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +ex));
            return null;
        }
        
        return null;
    }
}