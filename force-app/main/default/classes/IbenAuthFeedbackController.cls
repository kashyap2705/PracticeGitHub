public class IbenAuthFeedbackController {
    
    public Auth_Feedback__c af {get;set;}
    public String activeTab {get;set;}
    public String schoolName {get;set;}
    public String programmeName {get;set;}
    public Boolean pdCompletionStatus {get;set;}
    public String assignmentId {get;set;}
            
    public Auth_Feedback_Section_A__c sectionA { get; set; }
    public Auth_Feedback_Section_B__c sectionB { get; set; }
    public Auth_Feedback_Section_C__c sectionC { get; set; }
    
    public boolean isPyp { get; set; }
    public boolean isMyp { get; set; }
    public boolean isDp { get; set; }
    public boolean isCp { get; set; }
    public boolean isCpPhase1 { get; set; }
    public boolean isCpPhase2 { get; set; }
    public boolean otherLanguage {get;set;}
    public transient IB_Application__c application { get; set; }
    public transient IB_Application_Assessment__c assessment { get; set; }
    
    public Decimal pcTimeAllocTotal {get;set;}
    public Decimal slcTimeAllocTotal {get;set;}          
    public boolean isContinue {get;set;}
    public String website {get;set;}
    //holds the programme for selection in the map
    private String prog;
    
    public boolean isEditMode { get; set; } //Permender
    public boolean showReturn { get; set; } //Permender    
    public boolean isPageInternal { get; set; } //Permender
    
    String currPage = ApexPages.currentPage().getUrl();
    PageReference thisPage = ApexPages.currentPage();
    public boolean allCourseOutlinesSubmitted {get;set;}

    public IbenAuthFeedbackController(ApexPages.StandardController con) 
    {        
        activeTab=ApexPages.currentPage().getParameters().get('activeTab')==null?'instruction':ApexPages.currentPage().getParameters().get('activeTab');        
        isContinue=false;        
        prog='MYP';
        isPyp=false;
        isMyp=false;
        isDp=false;
        isCp=false;
        isCpPhase1=false;
        isCpPhase2=false;
        pdCompletionStatus = false; 
        isEditMode = false; //Permender 
        showReturn = false; //Permender
		allCourseOutlinesSubmitted=true;
        Auth_Feedback__c af2 = [SELECT Id,Assignment_Id__c,IB_Application__c,IB_Application__r.Application_Lookup_to_Programme__c,IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName,IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c,IB_Application__r.Application_Lookup_to_Programme__r.Name,Account__r.Website,Account__r.Name,IB_Application__r.Application_Lookup_to_Programme__r.Other_Language__c,Ready_To_Complete__c,Status__c
                                ,(SELECT id,afaf_a_1_e_1__c,afaf_a_1_e_2__c,afaf_a_1_e_3__c,afaf_a_1_mtba_1__c,afaf_a_1_nf_1_1__c,afaf_a_1_nf_1_2__c,afaf_a_1_nf_1__c,afaf_a_1_nf_2_1__c,afaf_a_1_nf_2_2__c,afaf_a_1_nf_2_3__c,afaf_a_1_nf_2__c,afaf_a_1_pf_1_1__c,afaf_a_1_pf_1_2__c,afaf_a_1_pf_1__c,afaf_a_1_pf_2_1__c,afaf_a_1_pf_2_2__c,afaf_a_1_pf_2_3__c,afaf_a_1_pf_2__c,afaf_a_1_pip_1__c,afaf_a_2_e_1__c,afaf_a_2_e_2__c,afaf_a_2_mtba_1__c,afaf_a_2_nf_1__c,afaf_a_2_pf_1__c,afaf_a_2_pip_1__c,afaf_a_3a_e_1__c,afaf_a_3a_e_2__c,afaf_a_3a_mtba_1__c,afaf_a_3a_mtba_2__c,afaf_a_3a_mtba_3__c,afaf_a_3a_nf_1__c,afaf_a_3a_nf_2__c,afaf_a_3a_nf_3__c,afaf_a_3a_nf_4__c,afaf_a_3a_nf_5__c,afaf_a_3a_nf_6__c,afaf_a_3a_pf_1__c,afaf_a_3a_pf_2__c,afaf_a_3a_pf_3__c,afaf_a_3a_pf_4__c,afaf_a_3a_pf_5__c,afaf_a_3a_pf_6__c,afaf_a_3a_pf_7__c,afaf_a_3a_pf_8__c,afaf_a_3a_pip_1__c,afaf_a_3d_e_1__c,afaf_a_3d_mtba_1__c,afaf_a_3d_nf_1__c,afaf_a_3d_pf_1__c,afaf_a_3d_pip_1__c,afaf_a_3e_e_1__c,afaf_a_3e_mtba_1__c,afaf_a_3e_nf_1__c,afaf_a_3e_pf_1__c,afaf_a_3e_pip_1__c,afaf_a_3_e_1__c,afaf_a_3_e_2__c,afaf_a_3_mtba_1__c,afaf_a_3_mtba_2__c,afaf_a_3_mtba_3__c,afaf_a_3_mtba_4__c,afaf_a_3_nf_1__c,afaf_a_3_nf_2__c,afaf_a_3_nf_3__c,afaf_a_3_nf_4__c,afaf_a_3_pf_1__c,afaf_a_3_pf_2__c,afaf_a_3_pf_3__c,afaf_a_3_pf_4__c,afaf_a_3_pip_1__c,afaf_a_4_e_1__c,afaf_a_4_mtba_1__c,afaf_a_4_nf_1__c,afaf_a_4_nf_2__c,afaf_a_4_pf_1__c,afaf_a_4_pf_2__c,afaf_a_4_pip_1__c,afaf_a_5_e_1__c,afaf_a_5_mtba_1__c,afaf_a_5_nf_1__c,afaf_a_5_nf_2__c,afaf_a_5_pf_1__c,afaf_a_5_pf_2__c,afaf_a_5_pip_1__c,afaf_a_6_e_1__c,afaf_a_6_mtba_1__c,afaf_a_6_nf_1__c,afaf_a_6_nf_2__c,afaf_a_6_pf_1__c,afaf_a_6_pf_2__c,afaf_a_6_pip_1__c,afaf_a_7a_e_1__c,afaf_a_7a_e_2__c,afaf_a_7a_e_3__c,afaf_a_7a_mtba_1__c,afaf_a_7a_nf_1__c,afaf_a_7a_nf_2__c,afaf_a_7a_nf_4__c,afaf_a_7a_nf_5__c,afaf_a_7a_nf_6__c,afaf_a_7a_pf_1__c,afaf_a_7a_pf_2__c,afaf_a_7a_pf_3__c,afaf_a_7a_pf_4__c,afaf_a_7a_pf_5__c,afaf_a_7a_pf_6__c,afaf_a_7a_pip_1__c,afaf_a_7_e_1__c,afaf_a_7_e_2__c,afaf_a_7_e_3__c,afaf_a_7_e_4__c,afaf_a_7_mtba_1__c,afaf_a_7_nf_1__c,afaf_a_7_nf_2__c,afaf_a_7_nf_3__c,afaf_a_7_nf_4__c,afaf_a_7_pf_1__c,afaf_a_7_pf_2__c,afaf_a_7_pf_3__c,afaf_a_7_pf_4__c,afaf_a_7_pip_1__c,afaf_a_8_pip_1__c,afaf_a_9_e_1__c,afaf_a_9_e_2__c,afaf_a_9_e_3__c,afaf_a_9_mtba_1__c,afaf_a_9_mtba_2__c,afaf_a_9_mtba_3__c,afaf_a_9_nf_1__c,afaf_a_9_nf_2__c,afaf_a_9_nf_3_1__c,afaf_a_9_nf_3_2__c,afaf_a_9_nf_3_3__c,afaf_a_9_nf_3__c,afaf_a_9_nf_4__c,afaf_a_9_pf_1__c,afaf_a_9_pf_2__c,afaf_a_9_pf_3_1__c,afaf_a_9_pf_3_2__c,afaf_a_9_pf_3_3__c,afaf_a_9_pf_3__c,afaf_a_9_pf_4__c,afaf_a_9_pip_1__c,AFAF_A_7A_NF_3__c,authorization_feedback__c,A_Status__c,AFAF_A_3_E_3__c,AFAF_A_3_E_4__c,AFAF_A_3_E_5__c,AFAF_A_9_E_4__c,AFAF_A_9_E_5__c,AFAF_A_9_E_6__c,AFAF_A_3A_E_3__c FROM Authorization_Feedback_Section_A__r) 
                                ,(SELECT id,afaf_b1_1_e_1__c,afaf_b1_1_mtba_1__c,afaf_b1_1_nf_1__c,afaf_b1_1_pf_1__c,afaf_b1_1_pip_1__c,afaf_b1_2a_e_1__c,afaf_b1_2a_mtba_1__c,afaf_b1_2a_nf_1__c,afaf_b1_2a_nf_2__c,afaf_b1_2a_pf_1__c,afaf_b1_2a_pf_2__c,afaf_b1_2a_pip_1__c,afaf_b1_2b_e_1__c,afaf_b1_2b_mtba_1__c,afaf_b1_2b_nf_1__c,afaf_b1_2b_nf_2__c,afaf_b1_2b_pf_1__c,afaf_b1_2b_pf_2__c,afaf_b1_2b_pip_1__c,afaf_b1_2_e_1__c,afaf_b1_2_mtba_1__c,afaf_b1_2_nf_1__c,afaf_b1_2_pf_1__c,afaf_b1_2_pip_1__c,afaf_b1_3_e_1__c,afaf_b1_3_e_2__c,afaf_b1_3_e_3__c,afaf_b1_3_mtba_1__c,afaf_b1_3_nf_1__c,afaf_b1_3_nf_2__c,afaf_b1_3_pf_1__c,afaf_b1_3_pf_2__c,afaf_b1_3_pip_1__c,afaf_b1_4_e_1__c,afaf_b1_4_e_2__c,afaf_b1_4_mtba_1__c,afaf_b1_4_mtba_2__c,afaf_b1_4_nf_1__c,afaf_b1_4_nf_2__c,afaf_b1_4_nf_3__c,afaf_b1_4_nf_4__c,afaf_b1_4_pf_1__c,afaf_b1_4_pf_2__c,afaf_b1_4_pf_3__c,afaf_b1_4_pf_4__c,afaf_b1_4_pip_1__c,afaf_b1_5a_e_1__c,afaf_b1_5a_e_2__c,afaf_b1_5a_e_3__c,afaf_b1_5a_mtba_1__c,afaf_b1_5a_mtba_2__c,afaf_b1_5a_nf_1_1__c,afaf_b1_5a_nf_1_2__c,afaf_b1_5a_nf_1_3__c,afaf_b1_5a_nf_1_4__c,afaf_b1_5a_nf_1_5__c,afaf_b1_5a_nf_1__c,afaf_b1_5a_nf_2__c,afaf_b1_5a_pf_1_1__c,afaf_b1_5a_pf_1_2__c,afaf_b1_5a_pf_1_3__c,afaf_b1_5a_pf_1_4__c,afaf_b1_5a_pf_1_5__c,afaf_b1_5a_pf_1__c,afaf_b1_5a_pf_2__c,afaf_b1_5a_pip_1__c,afaf_b1_5b_e_1__c,afaf_b1_5b_mtba_1__c,afaf_b1_5b_nf_1_1__c,afaf_b1_5b_nf_1_2__c,afaf_b1_5b_nf_1_3__c,afaf_b1_5b_nf_1_4__c,afaf_b1_5b_nf_1_5__c,afaf_b1_5b_nf_1__c,afaf_b1_5b_nf_2__c,afaf_b1_5b_nf_3__c,afaf_b1_5b_pf_1_1__c,afaf_b1_5b_pf_1_2__c,afaf_b1_5b_pf_1_3__c,afaf_b1_5b_pf_1_4__c,afaf_b1_5b_pf_1_5__c,afaf_b1_5b_pf_1__c,afaf_b1_5b_pf_2__c,afaf_b1_5b_pf_3__c,afaf_b1_5b_pip_1__c,afaf_b1_5c_e_1__c,afaf_b1_5c_e_2__c,afaf_b1_5c_e_3__c,afaf_b1_5c_e_4__c,afaf_b1_5c_e_5__c,afaf_b1_5c_e_6__c,afaf_b1_5c_mtba_1__c,afaf_b1_5c_nf_1__c,afaf_b1_5c_nf_2_1__c,afaf_b1_5c_nf_2_2__c,afaf_b1_5c_nf_2_3__c,afaf_b1_5c_nf_2_4__c,afaf_b1_5c_nf_2_5__c,afaf_b1_5c_nf_2__c,afaf_b1_5c_pf_1__c,afaf_b1_5c_pf_2_1__c,afaf_b1_5c_pf_2_2__c,afaf_b1_5c_pf_2_3__c,afaf_b1_5c_pf_2_4__c,afaf_b1_5c_pf_2_5__c,afaf_b1_5c_pf_2__c,afaf_b1_5c_pip_1__c,afaf_b1_5d_e_1__c,afaf_b1_5d_mtba_1__c,afaf_b1_5d_nf_1__c,afaf_b1_5d_nf_2_1__c,afaf_b1_5d_nf_2_2__c,afaf_b1_5d_nf_2_3__c,afaf_b1_5d_nf_2_4__c,afaf_b1_5d_nf_2_5__c,afaf_b1_5d_nf_2__c,afaf_b1_5d_nf_3__c,afaf_b1_5d_nf_4__c,afaf_b1_5d_pf_1__c,afaf_b1_5d_pf_2_1__c,afaf_b1_5d_pf_2_2__c,afaf_b1_5d_pf_2_3__c,afaf_b1_5d_pf_2_4__c,afaf_b1_5d_pf_2_5__c,afaf_b1_5d_pf_2__c,afaf_b1_5d_pf_3__c,afaf_b1_5d_pf_4__c,afaf_b1_5d_pip_1__c,afaf_b1_5e_e_1__c,afaf_b1_5e_mtba_1__c,afaf_b1_5e_nf_1__c,afaf_b1_5e_nf_2__c,afaf_b1_5e_nf_3__c,afaf_b1_5e_pf_1__c,afaf_b1_5e_pf_2__c,afaf_b1_5e_pf_3__c,afaf_b1_5e_pip_1__c,afaf_b1_5_pip_1__c,afaf_b1_6a_e_1__c,afaf_b1_6a_e_2__c,afaf_b1_6a_e_3__c,afaf_b1_6a_mtba_1__c,afaf_b1_6a_mtba_2__c,afaf_b1_6a_nf_1__c,afaf_b1_6a_nf_2__c,afaf_b1_6a_pf_1__c,afaf_b1_6a_pf_2__c,afaf_b1_6a_pip_1__c,afaf_b1_6_e_1__c,afaf_b1_6_mtba_1__c,afaf_b1_6_nf_1__c,afaf_b1_6_pf_1__c,afaf_b1_6_pip_1__c,afaf_b2_10a_e_1__c,afaf_b2_10a_e_2__c,afaf_b2_10a_e_3__c,afaf_b2_10a_e_4__c,afaf_b2_10a_e_5__c,afaf_b2_10a_e_6__c,afaf_b2_10a_e_7__c,afaf_b2_10a_e_8__c,afaf_b2_10a_mtba_1__c,afaf_b2_10a_nf_1_1__c,afaf_b2_10a_nf_1_2__c,afaf_b2_10a_nf_1_3__c,afaf_b2_10a_nf_1_4__c,afaf_b2_10a_nf_1_5__c,afaf_b2_10a_nf_1_6__c,afaf_b2_10a_nf_1_7__c,afaf_b2_10a_nf_1_8__c,afaf_b2_10a_nf_1__c,afaf_b2_10a_nf_2__c,afaf_b2_10a_nf_3_1__c,afaf_b2_10a_nf_3_2__c,afaf_b2_10a_nf_3_3__c,afaf_b2_10a_nf_3_4__c,afaf_b2_10a_nf_3_5__c,afaf_b2_10a_nf_3_6__c,afaf_b2_10a_nf_3__c,afaf_b2_10a_pf_1_1__c,afaf_b2_10a_pf_1_2__c,afaf_b2_10a_pf_1_3__c,afaf_b2_10a_pf_1_4__c,afaf_b2_10a_pf_1_5__c,afaf_b2_10a_pf_1_6__c,afaf_b2_10a_pf_1_7__c,afaf_b2_10a_pf_1_8__c,afaf_b2_10a_pf_1__c,afaf_b2_10a_pf_2__c,afaf_b2_10a_pf_3_1__c,afaf_b2_10a_pf_3_2__c,afaf_b2_10a_pf_3_3__c,afaf_b2_10a_pf_3_4__c,afaf_b2_10a_pf_3_5__c,afaf_b2_10a_pf_3_6__c,afaf_b2_10a_pf_3__c,afaf_b2_10a_pip_1__c,afaf_b2_10b_e_1__c,afaf_b2_10b_mtba_1__c,afaf_b2_10b_nf_1_1__c,afaf_b2_10b_nf_1_2__c,afaf_b2_10b_nf_1_3__c,afaf_b2_10b_nf_1_4__c,afaf_b2_10b_nf_1_5__c,afaf_b2_10b_nf_1_6__c,afaf_b2_10b_nf_1_7__c,afaf_b2_10b_nf_1_8__c,afaf_b2_10b_nf_1__c,afaf_b2_10b_pf_1_1__c,afaf_b2_10b_pf_1_2__c,afaf_b2_10b_pf_1_3__c,afaf_b2_10b_pf_1_4__c,afaf_b2_10b_pf_1_5__c,afaf_b2_10b_pf_1_6__c,afaf_b2_10b_pf_1_7__c,afaf_b2_10b_pf_1_8__c,afaf_b2_10b_pf_1__c,afaf_b2_10b_pip_1__c,afaf_b2_10c_e_1__c,afaf_b2_10c_mtba_1__c,afaf_b2_10c_nf_1__c,afaf_b2_10c_nf_2__c,afaf_b2_10c_nf_3__c,afaf_b2_10c_pf_1__c,afaf_b2_10c_pf_2__c,afaf_b2_10c_pf_3__c,afaf_b2_10c_pip_1__c,afaf_b2_10_e_1__c,afaf_b2_10_e_2__c,afaf_b2_10_e_3__c,afaf_b2_10_e_4__c,afaf_b2_10_e_5__c,afaf_b2_10_mtba_1__c,afaf_b2_10_mtba_2__c,afaf_b2_10_nf_1__c,afaf_b2_10_nf_2__c,afaf_b2_10_nf_3__c,afaf_b2_10_nf_4__c,afaf_b2_10_nf_5__c,afaf_b2_10_pf_1__c,afaf_b2_10_pf_2__c,afaf_b2_10_pf_3__c,afaf_b2_10_pf_4__c,afaf_b2_10_pf_5__c,afaf_b2_10_pip_1__c,afaf_b2_11_pip_1__c,afaf_b2_12_e_1__c,afaf_b2_12_e_2__c,afaf_b2_12_mtba_1__c,afaf_b2_12_nf_1_1__c,afaf_b2_12_nf_1_2__c,afaf_b2_12_nf_2_1__c,afaf_b2_12_nf_2_2__c,afaf_b2_12_nf_2__c,afaf_b2_12_pf_1_1__c,afaf_b2_12_pf_1_2__c,afaf_b2_12_pf_1__c,afaf_b2_12_pf_2_1__c,afaf_b2_12_pf_2_2__c,afaf_b2_12_pf_2__c,afaf_b2_12_pip_1__c,afaf_b2_1_e_1__c,afaf_b2_1_mtba_1__c,afaf_b2_1_mtba_2__c,afaf_b2_1_mtba_3__c,afaf_b2_1_nf_1_1__c,afaf_b2_1_nf_1_2__c,afaf_b2_1_nf_1_3__c,afaf_b2_1_nf_1_4__c,afaf_b2_1_nf_1_5__c,afaf_b2_1_nf_1_6__c,afaf_b2_1_nf_1_7__c,afaf_b2_1_nf_1_8__c,afaf_b2_1_nf_1_9__c,afaf_b2_1_nf_1__c,afaf_b2_1_pf_1_1__c,afaf_b2_1_pf_1_2__c,afaf_b2_1_pf_1_3__c,afaf_b2_1_pf_1_4__c,afaf_b2_1_pf_1_5__c,afaf_b2_1_pf_1_6__c,afaf_b2_1_pf_1_7__c,afaf_b2_1_pf_1_8__c,afaf_b2_1_pf_1__c,afaf_b2_1_pip_1__c,afaf_b2_2_e_1__c,afaf_b2_2_mtba_1__c,afaf_b2_2_nf_1__c,afaf_b2_2_pf_1__c,afaf_b2_2_pip_1__c,afaf_b2_3a_e_1__c,afaf_b2_3a_mtba_1__c,afaf_b2_3a_nf_1_1__c,afaf_b2_3a_nf_1_2__c,afaf_b2_3a_nf_1_3__c,afaf_b2_3a_nf_1_4__c,afaf_b2_3a_nf_1_5__c,afaf_b2_3a_nf_1_6__c,afaf_b2_3a_nf_1__c,afaf_b2_3a_pf_1_1__c,afaf_b2_3a_pf_1_2__c,afaf_b2_3a_pf_1_3__c,afaf_b2_3a_pf_1_4__c,afaf_b2_3a_pf_1_5__c,afaf_b2_3a_pf_1_6__c,afaf_b2_3a_pf_1__c,afaf_b2_3a_pip_1__c,afaf_b2_3_e_1__c,afaf_b2_3_e_2__c,afaf_b2_3_e_3__c,afaf_b2_3_e_4__c,afaf_b2_3_mtba_1__c,afaf_b2_3_mtba_2__c,afaf_b2_3_nf_1_10__c,afaf_b2_3_nf_1_11__c,afaf_b2_3_nf_1_12__c,afaf_b2_3_nf_1_1__c,afaf_b2_3_nf_1_2__c,afaf_b2_3_nf_1_3__c,afaf_b2_3_nf_1_4__c,afaf_b2_3_nf_1_5__c,afaf_b2_3_nf_1_6__c,afaf_b2_3_nf_1_7__c,afaf_b2_3_nf_1_8__c,afaf_b2_3_nf_1_9__c,afaf_b2_3_nf_1__c,afaf_b2_3_nf_2__c,afaf_b2_3_nf_3__c,afaf_b2_3_nf_4__c,afaf_b2_3_pf_1_10__c,afaf_b2_3_pf_1_11__c,afaf_b2_3_pf_1_12__c,afaf_b2_3_pf_1_1__c,afaf_b2_3_pf_1_2__c,afaf_b2_3_pf_1_3__c,afaf_b2_3_pf_1_4__c,afaf_b2_3_pf_1_5__c,afaf_b2_3_pf_1_6__c,afaf_b2_3_pf_1_7__c,afaf_b2_3_pf_1_8__c,afaf_b2_3_pf_1_9__c,afaf_b2_3_pf_1__c,afaf_b2_3_pf_2__c,afaf_b2_3_pf_3__c,afaf_b2_3_pf_4__c,afaf_b2_3_pip_1__c,afaf_b2_4_e_1__c,afaf_b2_4_e_2__c,afaf_b2_4_e_3__c,afaf_b2_4_mtba_1__c,afaf_b2_4_nf_1_1__c,afaf_b2_4_nf_1_2__c,afaf_b2_4_nf_1_3__c,afaf_b2_4_nf_1_4__c,afaf_b2_4_nf_1_5__c,afaf_b2_4_nf_1__c,afaf_b2_4_nf_2__c,afaf_b2_4_nf_3__c,afaf_b2_4_pf_1_1__c,afaf_b2_4_pf_1_2__c,afaf_b2_4_pf_1_3__c,afaf_b2_4_pf_1_4__c,afaf_b2_4_pf_1_5__c,afaf_b2_4_pf_1__c,afaf_b2_4_pf_2__c,afaf_b2_4_pf_3__c,afaf_b2_4_pip_1__c,afaf_b2_5a_e_1__c,afaf_b2_5a_mtba_1__c,afaf_b2_5a_nf_1_1__c,afaf_b2_5a_nf_1_2__c,afaf_b2_5a_nf_1__c,afaf_b2_5a_nf_2_1__c,afaf_b2_5a_nf_2_2__c,afaf_b2_5a_nf_2__c,afaf_b2_5a_nf_3_1__c,afaf_b2_5a_nf_3_2__c,afaf_b2_5a_nf_3__c,afaf_b2_5a_pf_1_1__c,afaf_b2_5a_pf_1_2__c,afaf_b2_5a_pf_1__c,afaf_b2_5a_pf_2_1__c,afaf_b2_5a_pf_2_2__c,afaf_b2_5a_pf_2__c,afaf_b2_5a_pf_3_1__c,afaf_b2_5a_pf_3_2__c,afaf_b2_5a_pf_3__c,afaf_b2_5a_pip_1__c,afaf_b2_5b_e_1__c,afaf_b2_5b_mtba_1__c,afaf_b2_5b_nf_1__c,afaf_b2_5b_nf_2__c,afaf_b2_5b_pf_1__c,afaf_b2_5b_pf_2__c,afaf_b2_5b_pip_1__c,afaf_b2_5_e_1__c,afaf_b2_5_mtba_1__c,afaf_b2_5_nf_1_1__c,afaf_b2_5_nf_1_2__c,afaf_b2_5_nf_1_3__c,afaf_b2_5_nf_1_4__c,afaf_b2_5_nf_1_5__c,afaf_b2_5_nf_1__c,afaf_b2_5_pf_1_1__c,afaf_b2_5_pf_1_2__c,afaf_b2_5_pf_1_3__c,afaf_b2_5_pf_1_4__c,afaf_b2_5_pf_1_5__c,afaf_b2_5_pf_1__c,afaf_b2_5_pip_1__c,afaf_b2_6_e_1__c,afaf_b2_6_mtba_1__c,afaf_b2_6_mtba_2__c,afaf_b2_6_nf_1__c,afaf_b2_6_nf_2__c,afaf_b2_6_nf_3__c,afaf_b2_6_nf_4__c,afaf_b2_6_pf_1__c,afaf_b2_6_pf_2__c,afaf_b2_6_pf_3__c,afaf_b2_6_pf_4__c,afaf_b2_6_pip_1__c,afaf_b2_7_e_1__c,afaf_b2_7_mtba_1__c,afaf_b2_7_nf_1__c,afaf_b2_7_pf_1__c,afaf_b2_7_pip_1__c,afaf_b2_8_e_1__c,afaf_b2_8_mtba_1__c,afaf_b2_8_nf_1__c,afaf_b2_8_pf_1__c,afaf_b2_8_pip_1__c,afaf_b2_9_e_1__c,afaf_b2_9_e_2__c,afaf_b2_9_mtba_1__c,afaf_b2_9_nf_1__c,afaf_b2_9_pf_1__c,afaf_b2_9_pip_1__c,authorization_feedback__c,AFAF_B1_4_E_3__c,AFAF_B1_5A_E_4__c,AFAF_B1_5A_E_5__c,AFAF_B2_12_NF_1__c, AFAF_B2_1_PF_1_9__c, AFAF_B2_1_E_2__c, AFAF_B2_1_E_3__c, AFAF_B2_6_E_2__c,B1_Status__c,B2_Status__c,AFAF_B1_6A_E_4__c FROM Authorization_Feedback_Section_B__r)
                                ,(SELECT id,afaf_c1_1c_e_1__c,afaf_c1_1c_mtba_1__c,afaf_c1_1c_nf_1__c,afaf_c1_1c_pf_1__c,afaf_c1_1c_pip_1__c,afaf_c1_1_e_1__c,afaf_c1_1_e_2__c,afaf_c1_1_mtba_1__c,afaf_c1_1_mtba_2__c,afaf_c1_1_mtba_3__c,afaf_c1_1_mtba_4__c,afaf_c1_1_nf_1__c,afaf_c1_1_nf_2__c,afaf_c1_1_nf_3__c,afaf_c1_1_nf_4__c,afaf_c1_1_nf_5__c,afaf_c1_1_pf_1__c,afaf_c1_1_pf_2__c,afaf_c1_1_pf_3__c,afaf_c1_1_pf_4__c,afaf_c1_1_pf_5__c,afaf_c1_1_pip_1__c,afaf_c1_2_e_1__c,afaf_c1_2_mtba_1__c,afaf_c1_2_nf_1__c,afaf_c1_2_nf_2__c,afaf_c1_2_nf_3__c,afaf_c1_2_pf_1__c,afaf_c1_2_pf_2__c,afaf_c1_2_pf_3__c,afaf_c1_2_pip_1__c,afaf_c1_9_e_1__c,afaf_c1_9_mtba_1__c,afaf_c1_9_nf_1__c,afaf_c1_9_pf_1__c,afaf_c1_9_pip_1__c,afaf_c2_11_e_1__c,afaf_c2_11_mtba_1__c,afaf_c2_11_nf_1__c,afaf_c2_11_pf_1__c,afaf_c2_11_pip_1__c,afaf_c2_1a_e_1__c,afaf_c2_1a_e_2__c,afaf_c2_1a_e_3__c,afaf_c2_1a_mtba_1__c,afaf_c2_1a_nf_1_1__c,afaf_c2_1a_nf_1_2__c,afaf_c2_1a_nf_1_3__c,afaf_c2_1a_nf_1__c,afaf_c2_1a_nf_2__c,afaf_c2_1a_nf_3__c,afaf_c2_1a_nf_4__c,afaf_c2_1a_pf_1_1__c,afaf_c2_1a_pf_1_2__c,afaf_c2_1a_pf_1_3__c,afaf_c2_1a_pf_1_4__c,afaf_c2_1a_pf_1__c,afaf_c2_1a_pf_2__c,afaf_c2_1a_pf_3__c,afaf_c2_1a_pf_4__c,afaf_c2_1a_pip_1__c,afaf_c2_1b_e_1__c,afaf_c2_1b_mtba_1__c,afaf_c2_1b_nf_1__c,afaf_c2_1b_nf_2__c,afaf_c2_1b_pf_1__c,afaf_c2_1b_pf_2__c,afaf_c2_1b_pip_1__c,afaf_c2_1c_e_1__c,afaf_c2_1c_e_2__c,afaf_c2_1c_mtba_1__c,afaf_c2_1c_nf_1__c,afaf_c2_1c_nf_2__c,afaf_c2_1c_pf_1__c,afaf_c2_1c_pf_2__c,afaf_c2_1c_pip_1__c,afaf_c2_1d_e_1__c,afaf_c2_1d_e_2__c,afaf_c2_1d_mtba_1__c,afaf_c2_1d_nf_1__c,afaf_c2_1d_nf_2__c,afaf_c2_1d_pf_1__c,afaf_c2_1d_pf_2__c,afaf_c2_1d_pip_1__c,afaf_c2_1e_e_1__c,afaf_c2_1e_mtba_1__c,afaf_c2_1e_nf_1__c,afaf_c2_1e_pf_1__c,afaf_c2_1e_pip_1__c,afaf_c2_1f_e_1__c,afaf_c2_1f_mtba_1__c,afaf_c2_1f_nf_1__c,afaf_c2_1f_pf_1__c,afaf_c2_1f_pip_1__c,afaf_c2_1g_e_1__c,afaf_c2_1g_mtba_1__c,afaf_c2_1g_nf_1__c,afaf_c2_1g_pf_1__c,afaf_c2_1g_pip_1__c,afaf_c2_1h_e_1__c,afaf_c2_1h_e_2__c,afaf_c2_1h_e_3__c,afaf_c2_1h_e_4__c,afaf_c2_1h_e_5__c,afaf_c2_1h_e_6__c,afaf_c2_1h_mtba_1__c,afaf_c2_1h_nf_1__c,afaf_c2_1h_nf_2__c,afaf_c2_1h_nf_3__c,afaf_c2_1h_nf_4__c,afaf_c2_1h_nf_5__c,afaf_c2_1h_nf_6__c,afaf_c2_1h_nf_7__c,afaf_c2_1h_pf_1__c,afaf_c2_1h_pf_2__c,afaf_c2_1h_pf_3__c,afaf_c2_1h_pf_4__c,afaf_c2_1h_pf_5__c,afaf_c2_1h_pf_6__c,afaf_c2_1h_pf_7__c,afaf_c2_1h_pip_1__c,afaf_c2_1_e_1__c,afaf_c2_1_mtba_1__c,afaf_c2_1_nf_1__c,afaf_c2_1_nf_2__c,afaf_c2_1_nf_3__c,afaf_c2_1_pf_1__c,afaf_c2_1_pf_2__c,afaf_c2_1_pf_3__c,afaf_c2_1_pip_1__c,afaf_c2_4a_e_1__c,afaf_c2_4a_mtba_1__c,afaf_c2_4a_nf_1__c,afaf_c2_4a_nf_2__c,afaf_c2_4a_pf_1__c,afaf_c2_4a_pf_2__c,afaf_c2_4a_pip_1__c,afaf_c2_4_e_1__c,afaf_c2_4_mtba_1__c,afaf_c2_4_nf_1__c,afaf_c2_4_pf_1__c,afaf_c2_4_pip_1__c,afaf_c2_7_e_1__c,afaf_c2_7_mtba_1__c,afaf_c2_7_nf_1__c,afaf_c2_7_pf_1__c,afaf_c2_7_pip_1__c,afaf_c2_8_e_1__c,afaf_c2_8_mtba_1__c,afaf_c2_8_nf_1__c,afaf_c2_8_pf_1__c,afaf_c2_8_pip_1__c,afaf_c2_9_e_1__c,afaf_c2_9_e_2__c,afaf_c2_9_e_3__c,afaf_c2_9_mtba_1__c,afaf_c2_9_mtba_2__c,afaf_c2_9_nf_1__c,afaf_c2_9_nf_2__c,afaf_c2_9_pf_1__c,afaf_c2_9_pf_2__c,afaf_c2_9_pip_1__c,afaf_c3_1_e_1__c,afaf_c3_1_e_2__c,afaf_c3_1_e_3__c,afaf_c3_1_e_4__c,afaf_c3_1_mtba_1__c,afaf_c3_1_mtba_2__c,afaf_c3_1_mtba_3__c,afaf_c3_1_mtba_4__c,afaf_c3_1_nf_1__c,afaf_c3_1_nf_2__c,afaf_c3_1_nf_3__c,afaf_c3_1_nf_4__c,afaf_c3_1_pf_1__c,afaf_c3_1_pf_2__c,afaf_c3_1_pf_3__c,afaf_c3_1_pf_4__c,afaf_c3_1_pip_1__c,afaf_c4_1_e_1__c,afaf_c4_1_e_1_2__c,afaf_c4_1_e_1_3__c,afaf_c4_1_e_2__c,afaf_c4_1_e_3__c,afaf_c4_1_e_4__c,afaf_c4_1_mtba_1__c,afaf_c4_1_mtba_2__c,afaf_c4_1_mtba_3__c,afaf_c4_1_mtba_4__c,afaf_c4_1_nf_1__c,afaf_c4_1_nf_2__c,afaf_c4_1_nf_3__c,afaf_c4_1_pf_1__c,afaf_c4_1_pf_2__c,afaf_c4_1_pf_3__c,afaf_c4_1_pip_1__c,afaf_c4_2_e_1__c,afaf_c4_2_mtba_1__c,afaf_c4_2_nf_1__c,afaf_c4_2_pf_1__c,afaf_c4_2_pip_1__c,afaf_c4_3_e_1__c,afaf_c4_3_mtba_1__c,afaf_c4_3_nf_1__c,afaf_c4_3_pf_1__c,afaf_c4_3_pip_1__c,afaf_c4_9_e_1__c,afaf_c4_9_e_2__c,afaf_c4_9_e_3__c,afaf_c4_9_e_4__c,afaf_c4_9_mtba_1__c,afaf_c4_9_nf_1_1__c,afaf_c4_9_nf_1_2__c,afaf_c4_9_nf_1__c,afaf_c4_9_nf_2__c,afaf_c4_9_nf_3__c,afaf_c4_9_nf_4__c,afaf_c4_9_nf_5__c,afaf_c4_9_pf_1_1__c,afaf_c4_9_pf_1_2__c,afaf_c4_9_pf_1__c,afaf_c4_9_pf_2__c,afaf_c4_9_pf_3__c,afaf_c4_9_pf_4__c,afaf_c4_9_pf_5__c,afaf_c4_9_pip_1__c,authorization_feedback__c,AFAF_C4_2_E_2__c,AFAF_C4_9_E_5__c,AFAF_C4_9_E_6__c,C1_Status__c,C2_Status__c,C3_Status__c,C4_Status__c,AFAF_C1_1_E_3__c,AFAF_C1_1_E_4__c,AFAF_C3_1b_PF_1__c,AFAF_C3_1b_NF_1__c FROM Authorization_Feedback_Section_C__r)                               
                                FROM Auth_Feedback__c WHERE Id=:con.getId()]; 
        
        otherLanguage=af2.IB_Application__r.Application_Lookup_to_Programme__r.Other_Language__c;
        
        if(!af2.Authorization_Feedback_Section_A__r.isEmpty())
            sectionA = af2.Authorization_Feedback_Section_A__r.get(0);
        if(!af2.Authorization_Feedback_Section_B__r.isEmpty())
            sectionB = af2.Authorization_Feedback_Section_B__r.get(0);
        if(!af2.Authorization_Feedback_Section_C__r.isEmpty())
            sectionC = af2.Authorization_Feedback_Section_C__r.get(0);
        
        schoolName=af2.Account__r.Name;
        assignmentId = af2.Assignment_Id__c;
        if(String.isNotEmpty(af2.Account__r.website))
        	website=af2.Account__r.website.startsWith('http')?af2.Account__r.website:'http://'+af2.Account__r.website;
        
        programmeName=af2.IB_Application__r.Application_Lookup_to_Programme__r.Name;
        
        af = new Auth_Feedback__c(Id=af2.Id,IB_Application__c=af2.IB_Application__c,Account__c=af2.Account__c,IB_Programme__c=af2.IB_Application__r.Application_Lookup_to_Programme__c,Ready_To_Complete__c=af2.Ready_To_Complete__c,Status__c=af2.Status__c);
        
        if(af2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='PYP')
        {
            isPyp=true;
            prog='PYP';
        }
        if(af2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='MYP')
        {
            isMyp=true;
            prog='MYP';
        }
        if(af2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='Diploma_Programme')
        {
            isDp=true;
            prog='DP';
        }
        if(af2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='CP')
            isCp=true;
        if(af2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='IBCC')
        {
            isCp=true;
            if(af2.IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c == 'Phase 1')
            {
                isCpPhase1=true;
                prog='CP1';
            }
            if(af2.IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c == 'Phase 2')
            {
                isCpPhase2=true;
                prog='CP2';
            }
        }        
        if(isDp || isCp)
        {
            for(Course_Outline_Reading__c co : coList)
            {
                if(co.Status__c!='Submitted')
                {
                	allCourseOutlinesSubmitted=false;
                    continue;
                }
            }
        }
        ApplicationService.setApplicationId(af2.IB_Application__r.Id);
        application = ApplicationService.getApplication();        
        assessment = ApplicationService.getApplicationAssessment();

        af2=null;
        
       /*Following lines are updated by Umair-Plumlogix of US11561 of Staff Augmentation Project on 5/11/2020 */
       //Start
        getIsPageInternal();
        //end
    }
    
    public PageReference activeSection
    {   
        get
        {  
            PageReference pr = programmeMap.get(prog).get(activeTab);
            pr.getParameters().put('Id', af.Id);
            //pr.getParameters().put('activeTab', activeTab);        
            pr.setRedirect(true);
            return pr;
            
        }
        set;
    }
    public Map<String, Map<String,PageReference>> programmeMap
    {
        get
        {
            if(programmeMap == null)
            {
                programmeMap = new Map<String,Map<String,PageReference>>();
                programmeMap.put('MYP',new Map<String, PageReference>{
                'instruction' => Page.IbenAuthFeedbackInstruct_MYP_PYP,
                'sectiona' => Page.IbenAuthFeedbackSectionA_MYP,
                'sectionb1' => Page.IbenAuthFeedbackSectionB1_MYP,
                'sectionb2' => Page.IbenAuthFeedbackSectionB2_MYP,                
                'sectionc1' => Page.IbenAuthFeedbackSectionC1_MYP,
                'sectionc2' => Page.IbenAuthFeedbackSectionC2_MYP,
                'sectionc3' => Page.IbenAuthFeedbackSectionC3_MYP,
                'sectionc4' => Page.IbenAuthFeedbackSectionC4_MYP,
                'advice' => Page.IbenAuthFeedbackAdvice
                });
                programmeMap.put('CP1',new Map<String, PageReference>{
                'instruction' => Page.IbenAuthFeedbackInstruct_DP_CP,
                'sectiona' => Page.IbenAuthFeedbackSectionA_CP1,
                'sectionb1' => Page.IbenAuthFeedbackSectionB1_CP1,
                'sectionb2' => Page.IbenAuthFeedbackSectionB2_CP1,                
                'sectionc1' => Page.IbenAuthFeedbackSectionC1_CP1,
                'sectionc2' => Page.IbenAuthFeedbackSectionC2_CP1,
                'sectionc3' => Page.IbenAuthFeedbackSectionC3_CP1,
                'sectionc4' => Page.IbenAuthFeedbackSectionC4_CP1,
                'advice' => Page.IbenAuthFeedbackAdvice,
                'courseoutline' => Page.IbenAuthFeedbackCourseOutline
                });
                programmeMap.put('CP2',new Map<String, PageReference>{
                'instruction' => Page.IbenAuthFeedbackInstruct_DP_CP,
                'sectiona' => Page.IbenAuthFeedbackSectionA_CP2,
                'sectionb1' => Page.IbenAuthFeedbackSectionB1_CP2,
                'sectionb2' => Page.IbenAuthFeedbackSectionB2_CP2,                
                'sectionc1' => Page.IbenAuthFeedbackSectionC1_CP2,
                'sectionc2' => Page.IbenAuthFeedbackSectionC2_CP2,
                'sectionc3' => Page.IbenAuthFeedbackSectionC3_CP2,
                'sectionc4' => Page.IbenAuthFeedbackSectionC4_CP2,
                'advice' => Page.IbenAuthFeedbackAdvice,
                'courseoutline' => Page.IbenAuthFeedbackCourseOutline
                });
                programmeMap.put('DP',new Map<String, PageReference>{
                'instruction' => Page.IbenAuthFeedbackInstruct_DP_CP,
                'sectiona' => Page.IbenAuthFeedbackSectionA_DP,
                'sectionb1' => Page.IbenAuthFeedbackSectionB1_DP,
                'sectionb2' => Page.IbenAuthFeedbackSectionB2_DP,                
                'sectionc1' => Page.IbenAuthFeedbackSectionC1_DP,
                'sectionc2' => Page.IbenAuthFeedbackSectionC2_DP,
                'sectionc3' => Page.IbenAuthFeedbackSectionC3_DP,
                'sectionc4' => Page.IbenAuthFeedbackSectionC4_DP,
                'advice' => Page.IbenAuthFeedbackAdvice,
                'courseoutline' => Page.IbenAuthFeedbackCourseOutline
                });
                programmeMap.put('PYP',new Map<String, PageReference>{
                'instruction' => Page.IbenAuthFeedbackInstruct_MYP_PYP,
                'sectiona' => Page.IbenAuthFeedbackSectionA_PYP,
                'sectionb1' => Page.IbenAuthFeedbackSectionB1_PYP,
                'sectionb2' => Page.IbenAuthFeedbackSectionB2_PYP,                
                'sectionc1' => Page.IbenAuthFeedbackSectionC1_PYP,
                'sectionc2' => Page.IbenAuthFeedbackSectionC2_PYP,
                'sectionc3' => Page.IbenAuthFeedbackSectionC3_PYP,
                'sectionc4' => Page.IbenAuthFeedbackSectionC4_PYP,
                 'advice' => Page.IbenAuthFeedbackAdvice
               });
            }
            return programmeMap;
        }
        set;
    }
    
    public PageReference saveSectionA()
    {
        try
        {       
            update sectionA;
            if(isContinue)
            	activeTab='sectionb1';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved )); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionB() //mw123
    {        
        try
        {            
            update sectionB;            
            if(isContinue)
            {                
            	if(activeTab=='sectionb1')
                	activeTab='sectionb2';
                else if(activeTab=='sectionb2')
                    activeTab='sectionc1';             
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Feedback_Saved)); 
        }
        catch (Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +ex));            
        }        
        return null;
    }
    
    public PageReference saveSectionC()
    {
        try
        {
            update sectionC;
            if(isContinue)
            {
            	if(activeTab=='sectionc1')
                	activeTab='sectionc2';
                else if(activeTab=='sectionc2')
                    activeTab='sectionc3';
                else if(activeTab=='sectionc3')
                    activeTab='sectionc4';
                else if(activeTab=='sectionc4')
                    activeTab='advice';
            }      
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.Feedback_Saved)); 
        }
        catch (Exception ex) 
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +ex));            
        }            
        return null;
    }
    public PageReference renderSection()
    {
        ApplicationService.setApplicationId(af.IB_Application__c);
        application = ApplicationService.getApplication();        
        assessment = ApplicationService.getApplicationAssessment();
        return null;
    }
    public List<Application_Coordinator_Time__c> coordinatorTimeList
    {
        get
        {
            if(coordinatorTimeList==null)
                coordinatorTimeList = new List<Application_Coordinator_Time__c>([SELECT Id,B2_1a_1_CP_Duty__c,B2_1a_1_CP_Weekly_Time__c,B2_1a_1_DP_Duty__c,B2_1a_1_DP_Weekly_Time__c,B2_1a_1_PYP_Duty__c,B2_1a_1_PYP_Weekly_Time__c,B2_1a_1_MYP_Duty__c,B2_1a_1_MYP_Weekly_Time__c FROM Application_Coordinator_Time__c WHERE IB_Application_Lookup__c=:af.IB_Application__c AND Type__c = 'Programme coordinator']);
            return coordinatorTimeList;
        }
        set;
    }
    // added by Trevor
    public List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps 
    {
        get
        {
            if(standardSubjectProps==null)
            {
                standardSubjectProps = new List<Roles_and_Applications_Subject_Proposal__c>();
                for(Roles_and_Applications_Subject_Proposal__c sp : subjectProposals)
                {
                    if(sp.Subject_Level__c=='Standard')
                        standardSubjectProps.add(sp);
                }
            }
            return standardSubjectProps;
        }
        set;
    }
    
    
    public List<IB_Application_Curriculum_Requirement__c> applicationRequirements 
    { 
        get
        {
            if(applicationRequirements==null)
                applicationRequirements = new List<IB_Application_Curriculum_Requirement__c>([SELECT Id,Programme_Requirements__c,Programme_Requirements_Locales__c,DP_Years__c,CP_years__c FROM IB_Application_Curriculum_Requirement__c WHERE IB_Application__c =:af.IB_Application__c ]);
            return applicationRequirements;
        }
        set;
    }
    
    public List<IB_Role__c> rolesByProgramme
    {
        get
        {
            //System.debug('we are in rolesByProgramme'+rolesByProgramme);
            if(rolesByProgramme==null)
            {
                rolesByProgramme = new List<IB_Role__c>([SELECT Id, Name, Status__c, IB_Contact__c, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
                                                         IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, 
                                                         IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
                                                         IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title,
                                                         (SELECT Id, Name, Year__c, Contact__c, Role__c, Role_Subject__c, Workshop_Category__c, Workshop_Status__c, Workshop_Name__c, Workshop_Sub_Name__c, Region__c, City__c, Workshop_Type__c FROM Contact_Professional_Development__r),
                                                         (SELECT Id, Name, IB_Subject__c, Role_And_Application__c, IB_Programme__c, Subject_Group__c, Subject_Name__c, toLabel(IB_Subject__r.Subject_Group__c), IB_Subject__r.Subject_Name_FR__c, IB_Subject__r.Subject_Name_SP__c  FROM Role_Application_Subjects__r)
                                                         FROM IB_Role__c
                                                         WHERE IB_Account__c =:af.Account__c
                                                         AND IB_Programme_New__c=:af.IB_Programme__c
                                                         AND (End_Date__c = null OR End_Date__c > TODAY)
                                                         ORDER BY Last_Name__c,IB_Role_Name__c]);
            }
            //System.debug('aaa we are in rolesByProgramme'+rolesByProgramme);
            
            return rolesByProgramme;
        }
        set;
    }
    
    public List<Application_Meeting_Chart__c> applicationMeetingList
    {
        get
        {
            if(applicationMeetingList==null)
                applicationMeetingList = new List<Application_Meeting_Chart__c>([SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
                                                                                 FROM Application_Meeting_Chart__c
                                                                                 WHERE IB_Application_Lookup__c=:af.IB_Application__c]);
            return applicationMeetingList;
        }
        set;
    }
    public List<Application_Account_Facilities__c> applicationFacilityList
    {    
        get
        {
            if(applicationFacilityList==null)
            {
         
                     // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
	//begin  
                applicationFacilityList = new List<Application_Account_Facilities__c>([/*SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                                                                                       B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                                                                                       FROM Application_Account_Facilities__c
                                                                                       WHERE IB_Application_Lookup__c = :af.IB_Application__c*/

                    SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                                                                                       B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                                                                                       FROM Application_Account_Facilities__c
                                                                                       WHERE IB_Application_Lookup__c = :af.IB_Application__c]);
         //End
            }
            return applicationFacilityList;
        }
        set;
    }
    public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals
    {
        get
        {
            if(subjectProposals==null)
                subjectProposals = new List<Roles_and_Applications_Subject_Proposal__c>(
                    [SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IB_Application_Lookup__c,
                     Subject_Lookup__c, Subject_Group__c, Subject_Name__c, Language_of_Instruction__c, MYP_Year_Subject_taught__c, Subject_Level__c, Current_Number_of_Students__c, Estimated_Number_of_Students__c,
                     Year_1_Hours__c, Year_2_Hours__c, Before_Year_1_Subject_Name__c, Before_Year_2_Subject_Name__c, IsYearOne__c, IsYearTwo__c, Subject_Lookup__r.Course_Outline__c, 
                     Subject_Lookup__r.Course_Outline_SP__c, Subject_Lookup__r.Course_Outline_FR__c 
                     FROM Roles_and_Applications_Subject_Proposal__c
                     WHERE IB_Application_Lookup__c = :af.IB_Application__c
                     ORDER By Subject_Group__c ASC]);
            return subjectProposals;
        }
        set;
    }
    public List<Application_Teaching_Time__c> applicationTeachingTimeList
    {
        get
        {
            if(applicationTeachingTimeList==null)
                applicationTeachingTimeList = new List<Application_Teaching_Time__c>([
                    SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
                    B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
                    FROM Application_Teaching_Time__c
                    WHERE IB_Application_Lookup__c = :af.IB_Application__c
                ]);
            return applicationTeachingTimeList;
        }
        set;
    }
    public List<Application_Library_Resources__c> applicationLibraryList
    {
        get
        {
            if(applicationLibraryList==null)
                applicationLibraryList = new List<Application_Library_Resources__c>([
                    SELECT B2_6_6_Additional_resources__c, B2_6_6_Fiction_Books__c, B2_6_6_General_Reference__c, B2_6_6_Languages__c, B2_6_6_Nonfiction_Books__c,
                    B2_6_6_Online_Journals__c, B2_6_6_Online_Reference__c, B2_6_6_Print_Periodicals__c, IB_Application_Lookup__c, Id, Name
                    FROM Application_Library_Resources__c
                    WHERE IB_Application_Lookup__c = :af.IB_Application__c
                ]);
            return applicationLibraryList;  
        }
        set;
    }  
    public List<Application_Coordinator_Time__c> serviceCoordinatorTimeList
    {
        get
        {
            
            if(serviceCoordinatorTimeList==null){    
                serviceCoordinatorTimeList = [
                    SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
                    Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                    FROM Application_Coordinator_Time__c
                    WHERE IB_Application_Lookup__c = :af.IB_Application__c
                    AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS coordinator')
                ];
                
                slcTimeAllocTotal = 0;
                for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
                    if (isCp && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
                    if (isDp && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
                }
            }       
            return serviceCoordinatorTimeList;  
        }
        set;
    } 
    public List<Application_Budget_Table__c> applicationBudgetList 
    {
        get
        {
            if(applicationBudgetList==null)
            {
                applicationBudgetList = new List<Application_Budget_Table__c>([
                    SELECT Id, Name, IB_Programme__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_12_Currency_UsedIB__c, PR_12_Currency_Used2IB__c, PR_12_Currency_Used3IB__c, PR_12_Currency_Used2__c,
                    PR_12_Currency_Used3__c, PR_12_Academic_Year__c, PR_12_Academic_Year2__c, PR_12_Academic_Year3__c, PR_12_Academic_YearIB__c, PR_12_Academic_Year2IB__c, PR_12_Academic_Year3IB__c,
                    PR_12_Amount__c, PR_12_Amount2__c, PR_12_Amount3__c, PR_12_AmountIB__c, PR_12_AmountIB2__c, PR_12_AmountIB3__c, Current_Year__c, Resource_Item__c, Other_Item__c, Pro_Dev_Item__c,
                    Fee_Item__c
                    FROM Application_Budget_Table__c
                    WHERE IB_Programme__c = :af.IB_Programme__c
                ]);
            }
            return applicationBudgetList;
        }
        set;
    }
    public String[] lines 
    {
        get
        {
            if(lines==null)
            {
                Set<String> lineSet = new Set<String>();
                for (Application_Budget_Table__c a : applicationBudgetList) 
                    if (a.PR_12_budget_Line__c == 'Other' || a.PR_12_budget_Line__c == 'Resource' || a.PR_12_budget_Line__c == 'Professional Development' || a.PR_12_budget_Line__c == 'Fee') 
                    	lineSet.add(a.PR_12_budget_Line__c);
                
                // convert the set into a string array
                lines = new String[lineSet.size()];
                Integer i = 0;
                for (String line : lineSet) 
                {
                    lines[i] = line;
                    i++;
                }
            }
            return lines;
        }
        set;
    }

    //Permender
    public PageReference save(){
        System.debug('save is called');        
        update af;       
        return null;
    }

    //Permender
    public PageReference saveAndSubmit(){
        System.debug('saveAndSubmit is called');
        af.Status__c = 'Submitted';
        update af;
        return null;
    }

    //Permender
    public Void saveAndReturn(){
        undoReturn();
        save();
    }
    //Permender
    public Void edit(){
        isEditMode = true;
    }
    
    //Permender
    public Void undoEdit(){
        isEditMode = false;
    }

    //Permender
    public Void doReturn(){
        showReturn = true;
    }

    //Permender
    public Void undoReturn(){
        showReturn = false;
    }

    //Permender
    public Void saveFromEdit(){
        undoEdit();
    }

    public Boolean getIsEditable() {
        try{
            
            // if (isEditable == null) {
            
            boolean isEditable = false;
            
            Set<String> editProfileNames = new Set<String>();
            editProfileNames.add('System Administrator');
            editProfileNames.add('SCU + Advanced');
            editProfileNames.add('SCU + Advanced');
            editProfileNames.add('SCU + Basic');
            editProfileNames.add('SCU + Advanced');
            editProfileNames.add('SCU + Advanced');
            editProfileNames.add('SCU + Basic');
            editProfileNames.add('Customer Community Advanced');
            /*Following lines are added by Umair-Plumlogix of US11561 of Staff Augmentation Project on 5/11/2020 */
            //Start
            editProfileNames.add('School Services - Level 2');
            editProfileNames.add('School Services - Level 3');                    
            //end
            // this should be calling some sort of user/profile service and caching the data
            Profile currProfile = [ SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1 ];
            
            PageReference pageRef = thisPage;
            String url = pageRef.getUrl();
            System.debug('mw getIsPageInternal '+getIsPageInternal());
            
            System.debug('Status is:'+ af.Status__c);
            
            //System.debug('mw getIsAfa ' +getIsAfa());
            /*Following lines are commented by Umair-Plumlogix of US11561 of Staff Augmentation Project on 5/11/2020 */
            //Start
            /*if(getIsPageInternal()){
                isEditable = false;
            }*/
            //end
            if ((editProfileNames.contains(currProfile.Name)) && (af.Status__c == 'Not Started' || af.Status__c == 'Return to Reader' || af.Status__c == null)) 
            {
                isEditable = true;
            }
            // }
            system.debug('isEditable =====> '+isEditable);
            return isEditable;
            
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));
            return null;
        }
    }

    public Boolean getAreAllSectionsCompelete(){

        IF((sectionA.A_Status__c == 'Complete') && (sectionB.B1_Status__c == 'Complete') && (sectionB.B2_Status__c == 'Complete')  &&
         (sectionC.C1_Status__c == 'Complete')  && (sectionC.C2_Status__c == 'Complete')  && (sectionC.C3_Status__c == 'Complete')  && (sectionC.C4_Status__c == 'Complete')){
            return true;
        } else{
            return false;
        }
    }
/*
    public Boolean getIsAfa() {
        try{
            System.debug(LoggingLevel.ERROR, 'Entering AFA Method');
            if (isAfa == null) {
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                if (application.RecordType.Name == 'Application for Authorization') {
                    isAfa = true;
                    System.debug(LoggingLevel.ERROR, 'AFA Method true');
                }
                else {
                    isAfa = false;
                }
            }
            return isAfa;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));
            return null;
        }
    }
*/
    public virtual Boolean getIsPageInternal() {
        try{
            if (currPage.contains('InternalAuthFeedback')) {
                isPageInternal = true;
            }
            else {
                isPageInternal = false;
            }
            return isPageInternal;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));
            return null;
        }
    } 
    public List<Course_Outline_Reading__c> coList
    {
        get
        {
            if(coList==null)
            {
                CourseOutlineReadingService.setProgrammeId(af.IB_Programme__c);
                coList = CourseOutlineReadingService.getCourseOutlinesReadingsByProgramme();
            }
            return coList;
        }
        set;
    }
}