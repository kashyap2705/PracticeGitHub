public class FeedbackIncludeController {
    public Account acnt {get;set;}
    public IB_Application__c application{get;set;}
    public IB_Application_Feedback__c pimsApplicationFeedback{get;set;}
    public IB_Application_Feedback__c[] pimsApplicationFeedbackList{get;set;}
    
    public List<SchoolSections__c> sectionsList { get; set; }    
    public IB_Address__c address { get; set; }
    public List<IB_Address__c> addressList { get; set; }
    public List<Application_Staff_Table__c> applicationStaffTable { get; set; }
    public IB_Programme__c programme  { get; set; }
    public List<Application_Budget_Table__c> applicationBudgetTable { get; set; }
    public List<IB_Programme__c> programmeList  { get; set; }
    public Boolean hasErrors = false;
    
    public FeedbackIncludeController(){       
        
        try{
            pimsApplicationFeedback = [
                SELECT Id, OwnerId, IsDeleted, Name, AccountSchoolName__c, FB_AP_Comment_1__c, FB_AP_Requirement_Met_1__c, FB_Application_ID__c, FB_BD_Comment_1__c,
                    FB_BD_Comment_2__c, FB_BD_Comment_3__c, FB_BD_Comment_4__c, FB_BD_Comment_5__c, FB_BD_Requirement_Met_1__c, FB_BD_Requirement_Met_2__c, FB_BD_Requirement_Met_3__c,
                    FB_BD_Requirement_Met_4__c, FB_BD_Requirement_Met_5__c, FB_CAS_Comment_1__c, FB_CAS_Requirement_Met_1__c, FB_CIB_Comment_1__c, FB_CIB_Requirement_Met_1__c, FB_CQ_Comment_1__c,
                    FB_CQ_Comment_2__c, FB_CQ_Comment_3__c, FB_CQ_Comment_4__c, FB_CQ_Requirement_Met_1__c, FB_CQ_Requirement_Met_2__c, FB_CQ_Requirement_Met_3__c, FB_CQ_Requirement_Met_4__c,
                    FB_Documents_Expiration__c, FB_EP_Comment_1__c, FB_EP_Requirement_Met_1__c, FB_FD_Comment_1__c, FB_FD_Comment_2__c, FB_FD_Requirement_Met_1__c, FB_FD_Requirement_Met_2__c,
                    FB_GI_Comment_1__c, FB_GI_Requirement_Met_1__c, FB_Head_of_School__c, FB_LD_Comment_1__c, FB_LD_Requirement_1__c, FB_LD_Requirement_Met_1__c, FB_LE_Comment_1__c,
                    FB_LE_Comment_2__c, FB_LE_Comment_3__c, FB_LE_Comment_4__c, FB_LE_Comment_5__c, FB_LE_Comment_6__c, FB_LE_Comment_7__c, FB_LE_Requirement_Met_1__c, FB_LE_Requirement_Met_2__c,
                    FB_LE_Requirement_Met_3__c, FB_LE_Requirement_Met_4__c, FB_LE_Requirement_Met_5__c, FB_LE_Requirement_Met_6__c, FB_LE_Requirement_Met_7__c, FB_LG_Comment_1__c, FB_LG_Comment_2__c,
                    FB_LG_Comment_3__c, FB_LG_Requirement_Met_1__c, FB_LG_Requirement_Met_2__c, FB_LG_Requirement_Met_3__c, FB_LI_Comment_1__c, FB_LI_Comment_2__c, FB_LI_Requirement_Met_1__c,
                    FB_LI_Requirement_Met_2__c, FB_LOM_Comment_1__c, FB_LOM_Requirement_Met_1__c, FB_MC_Comment_1__c, FB_MC_Comment_2__c, FB_MC_Comment_3__c,
                    FB_MC_Comment_4__c, FB_MC_Comment_5__c, FB_MC_Comment_6__c, FB_MC_Comment_7__c, FB_MC_Comment_8__c, FB_MC_Comment_9__c, FB_MC_Requirement_Met_1__c, FB_MC_Requirement_Met_2__c,
                    FB_MC_Requirement_Met_3__c, FB_MC_Requirement_Met_4__c, FB_MC_Requirement_Met_5__c, FB_MC_Requirement_Met_6__c, FB_MC_Requirement_Met_7__c, FB_MC_Requirement_Met_8__c,
                    FB_MC_Requirement_Met_9__c, FB_PC_Comment_1__c, FB_PC_Requirement_Met_1__c, FB_PD_Comment_1__c, FB_PD_Comment_2__c, FB_PD_Requirement_Met_1__c, FB_PD_Requirement_Met_2__c,
                    FB_PSG_Comment_1__c, FB_PSG_Requirement_Met_1__c, FB_PS_Comment_1__c, FB_PS_Comment_2__c, FB_PS_Comment_3__c, FB_PS_Comment_4__c, FB_PS_Requirement_Met_1__c,
                    FB_PS_Requirement_Met_2__c, FB_PS_Requirement_Met_3__c, FB_PS_Requirement_Met_4__c, FB_Programme_Coordinator__c, FB_Programme__c, FB_SC_Comment_1__c, FB_SC_Requirement_Met_1__c,
                    FB_SM_Comment_1__c, FB_SM_Comment_2__c, FB_SM_Comment_3__c, FB_SM_Comment_4__c, FB_SM_Requirement_Met_1__c, FB_SM_Requirement_Met_2__c, FB_SM_Requirement_Met_3__c,
                    FB_SM_Requirement_Met_4__c, FB_SN_Comment_1__c, FB_SN_Comment_2__c, FB_SN_Requirement_Met_2__c, FB_SP_Comment_1__c, FB_SP_Requirement_Met_1__c, FB_STR_Comment_1__c,
                    FB_STR_Comment_2__c, FB_STR_Comment_3__c, FB_STR_Requirement_Met_1__c, FB_STR_Requirement_Met_2__c, FB_STR_Requirement_Met_3__c, FB_School_Code__c, FB_School_Mission__c, FB_School_Name__c,
                    FB_School_Open__c, FB_TOK_Comment_1__c, FB_TOK_Requirement_1__c, FB_TOK_Requirement_Met_1__c, Date_Submitted__c, Status__c, FB_SN_Requirement_Met_1__c, Current_Mission_Lookup__c,
                    FB_Lookup_IB_Application__c, FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__c, FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c, FB_Feedback_Completed__c
                FROM IB_Application_Feedback__c
                WHERE Id = :ApexPages.currentPage().getParameters().get('Id')
            ];
            
            String accId = pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c;
    
            application = ApplicationService.getApplication();
    
            acnt = [
                SELECT Id, Legal_Name__c, Website, Name, Legal_Status__c,Total_Number_Of_Students__c
                FROM Account
                WHERE Id = :accId
            ];
            
    
            sectionsList = [
                SELECT Id, Name, Account__c, Age_From__c, Age_To__c, Grade_From__c, Number_Of_Classes__c, Grade_To__c, Number_Of_Students__c, Other__c, Section_Name__c
                FROM SchoolSections__c
                WHERE Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
            ];
            
            addressList = [
                SELECT Id, Address_Line_1__c, City__c, Country__c, IB_Account__c, Postal_Code__c, Province__c, Status__c, Name
                FROM IB_Address__c
                WHERE IB_Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
            ];
            
            applicationStaffTable = [
                SELECT B2_2_2_Staff_Standards__c, B2_2_3_Full_Time__c, B2_2_4_Part_Time__c, IB_Application_Lookup__c, Name, Id
                FROM Application_Staff_Table__c
                WHERE IB_Application_Lookup__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__c
            ];     
            
            programme = ProgrammeService.getProgramme();
            
            programmeList = [
                SELECT Id, Name, Account__c, Programme_Legal_Name__c, PR_5_Languages__c, Type__c
                FROM IB_Programme__c
                WHERE Account__c = :pimsApplicationFeedback.FB_Lookup_IB_Application__r.Application_Lookup_to_Programme__r.Account__c
            ];
            
        }
        catch(Exception e){
            hasErrors = true;
        }

    }
}