public class IbenVerificationVisitController {
    
    public IB_Verification_Visit_Feedback__c visit { get; set; }
    public IB_Verification_Visit_Feedback_A__c sectionA { get; set; }
    public IB_Verification_Visit_Feedback_B1__c sectionB1 { get; set; }
    public IB_Verification_Visit_Feedback_B2__c sectionB2 { get; set; }
    public IB_Verification_Visit_Feedback_C1__c sectionC1 { get; set; }
    public IB_Verification_Visit_Feedback_C2__c sectionC2 { get; set; }
    public IB_Verification_Visit_Feedback_C3__c sectionC3 { get; set; }
    public IB_Verification_Visit_Feedback_C4__c sectionC4 { get; set; }
    public Decimal pcTimeAllocTotal {get;set;}
    public Decimal slcTimeAllocTotal {get;set;} 
    public transient IB_Application__c application { get; set; }
    public transient IB_Programme__c programme {get;set;}
    public transient IB_Application_Assessment__c assessment { get; set; }
    public boolean isPyp { get; set; }
    public boolean isMyp { get; set; }    
    public boolean isDp { get; set; }
    public boolean isCp { get; set; }
    public boolean isCpPhase1 { get; set; }
    public boolean isCpPhase2 { get; set; }
    public String activeTab {get;set;}
    public String programmeName {get;set;}
    public String programmeId {get;set;}
    private String prog;
    public boolean isMypPartnership {get;set;}
    public boolean hasWorkingLanguage {get;set;}
    public boolean isMultiCampus {get;set;}
    public Date dueDate {get;set;}    
    public VerificationVisitLinks headerLinks { get; set; }
    public List<VerificationVisitLinks> mypPartnershipLinks { get; set; }
    
    public IbenVerificationVisitController(ApexPages.StandardController con) 
    {
        activeTab=ApexPages.currentPage().getParameters().get('activeTab')==null?'instructions':ApexPages.currentPage().getParameters().get('activeTab');
        
        IB_Verification_Visit_Feedback__c visit2 = [
            SELECT Id, Name, IB_Application__r.Id, Account__r.Name,Assignment_Id__c, IB_Application__r.Application_Lookup_to_Programme__r.Name, 
            Account__r.website, IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName, IB_Application__c,IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c,
            IB_Programme__c, IB_Application__r.Application_Lookup_to_Programme__r.Other_Language__c,IB_Application__r.Application_Lookup_to_Programme__r.Has_Working_Language__c,
            IB_Application__r.Application_Lookup_to_Programme__r.Master_Programme__c, IB_Programme__r.Master_Programme__c,Lock_Form__c,Status__c,
            //This Part of Code is being added by Ali-Plumlogix,as a part of CR-856 on 3/3/2020
            //Begin
            (SELECT Id, Name, A_1_C__c,A_1_E_1__c,A_1_F__c,A_1_MTBA_1__c,A_1_PIP__c,A_1_R__c,A_2_C__c,A_2_E_1__c,A_2_F__c,A_2_MTBA_1__c,A_2_PIP__c,A_2_R__c,A_3_C__c,A_3_E_1__c,A_3_E_2__c,A_3_E_3__c,A_3_E_4__c,A_3_F__c,A_3_MTBA_1__c,A_3_MTBA_2__c,A_3_MTBA_3__c,A_3_MTBA_4__c,A_3_PIP__c,A_3_R__c,A_3a_C__c,A_3a_E_1__c,A_3a_E_2__c,A_3a_E_3__c,A_3a_F__c,A_3a_MTBA_1__c,A_3a_MTBA_2__c,A_3a_MTBA_3__c,A_3a_PIP__c,A_3a_R__c,A_3b_C__c,A_3b_F__c,A_3b_R__c,A_3c_C__c,A_3c_MTBA_1__c,A_3c_F__c,A_3c_R__c,A_3d_C__c,A_3d_E_1__c,A_3b_E_1__c,A_3d_F__c,A_3d_MTBA_1__c,A_3b_MTBA_1__c,A_3__c,A_3d_R__c,A_3e_C__c,A_3e_E_1__c,A_3e_F__c,A_3e_MTBA_1__c,A_3e_PIP__c,A_3e_R__c,A_4_C__c,A_4_E_1__c,A_4_F__c,A_4_MTBA_1__c,A_4_PIP__c,A_4_R__c,A_5_C__c,A_5_E_1__c,A_5_F__c,A_5_MTBA_1__c,A_5_PIP__c,A_5_R__c,A_6_C__c,A_6_E_1__c,A_6_F__c,A_6_MTBA_1__c,A_6_PIP__c,A_6_R__c,A_7_C__c,A_7_E_1__c,A_7_F__c,A_7_MTBA_1__c,A_7_PIP__c,A_7_R__c,A_7a_C__c,A_7a_E_1__c,A_7a_F__c,A_7a_MTBA_1__c,A_7a_PIP__c,A_7a_R__c,A_7b_C__c,A_7b_F__c,A_7b_R__c,A_8_C__c,A_8_F__c,A_8_R__c,A_9_C__c,A_9_E_1__c,A_3c_E_1__c,A_9_E_2__c,A_9_E_3__c,A_9_F__c,A_9_MTBA_1__c,A_9_MTBA_2__c,A_9_MTBA_3__c,A_9_PIP__c,A_9_R__c,A_9a_C__c,A_9a_E_1__c,A_9a_F__c,A_9a_MTBA_1__c,A_9a_PIP__c,A_9a_R__c,A_9c_C__c,A_9c_F__c,A_9c_R__c,IB_Verification_Visit_Feedback__c,Status__c,A_3b_PIP__c,A_3c_PIP__c,A_3d_PIP__c FROM IB_Verification_Visit_Feedback_A__r),
            //A_3b_PIP__c,A_3c_PIP__c,A_3d_PIP__c Added by Atticus as part of ECM00349
            //End
            (SELECT Id, Name, IB_Verification_Visit_Feedback__c, B1_1_F__c, B1_1_C__c, B1_1_R__c, B1_2_F__c, B1_2_C__c, B1_2_R__c, B1_2_PIP__c, B1_2_MTBA_1__c, B1_2_E_1__c, B1_2A_F__c, B1_2A_C__c, B1_2A_R__c, B1_2A_PIP__c,B1_2A_E_1__c, B1_2B_F__c, B1_2B_R__c, B1_2B_PIP__c, B1_2B_MTBA_1__c,B1_2B_C__c, B1_2B_E_1__c, B1_3_F__c, B1_3_C__c, B1_3_R__c, B1_3_PIP__c, B1_3_MTBA_1__c, B1_3_E_1__c, B1_4_F__c, B1_4_C__c, B1_4_R__c, B1_4_PIP__c, B1_4_MTBA_1__c, B1_4_E_1__c, B1_5A_F__c, B1_5A_C__c, B1_5A_R__c, B1_5A_PIP__c, B1_5A_MTBA_1__c, B1_5A_E_1__c, B1_5B_F__c, B1_5B_C__c, B1_5B_R__c, B1_5B_PIP__c, B1_5B_MTBA_1__c, B1_5B_E_1__c, B1_6_F__c, B1_6_C__c, B1_6_R__c, B1_6_PIP__c, B1_6_MTBA_1__c, B1_6_E_1__c,B1_2A_MTBA_1__c, B1_4_MTBA_2__c, B1_4_E_2__c,B1_5C_F__c, B1_5C_C__c, B1_5C_R__c, B1_5C_PIP__c, B1_5C_MTBA_1__c, B1_5C_E_1__c, B1_5D_F__c, B1_5D_C__c, B1_5D_R__c, B1_5D_PIP__c, B1_5D_MTBA_1__c, B1_5D_E_1__c,B1_6A_F__c, B1_6A_C__c, B1_6A_R__c, B1_6A_PIP__c, B1_6A_MTBA_1__c, B1_6A_E_1__c, B1_6A_MTBA_2__c, B1_6A_E_2__c, B1_5E_F__c, B1_5E_C__c, B1_5E_R__c, B1_5E_PIP__c, B1_5E_MTBA_1__c, B1_5E_E_1__c, B1_5F_F__c, B1_5F_C__c, B1_5F_R__c, B1_1_PIP__c, B1_1_MTBA_1__c, B1_1_E_1__c,Status__c FROM IB_Verification_Visit_Feedback_B__r),
            (SELECT Id, Name,B2_1_F__c,B2_1_C__c,B2_1_R__c,B2_1_MTBA_1__c,B2_1_E_1__c,B2_1_PIP__c,B2_2_F__c,B2_2_C__c,B2_2_R__c,B2_2_E_1__c,B2_2_PIP__c,B2_2_MTBA_1__c,B2_3_F__c,B2_3_C__c,B2_3_R__c,B2_3_E_1__c,B2_3_E_2__c,B2_3_PIP__c,B2_3_MTBA_1__c,B2_3_MTBA_2__c,B2_3a_PIP__c,B2_4_F__c,B2_4_C__c,B2_4_R__c,B2_4_E_1__c,B2_4_PIP__c,B2_4_MTBA_1__c,B2_5_F__c,B2_5_C__c,B2_5_R__c,B2_5_E_1__c,B2_5_PIP__c,B2_5_MTBA_1__c,B2_5a_PIP__c,B2_5b_PIP__c,B2_6_F__c,B2_6_C__c,B2_6_R__c,B2_6_E_1__c,B2_6_PIP__c,B2_7_F__c,B2_7_C__c,B2_7_R__c,B2_7_E_1__c,B2_7_PIP__c,B2_8_F__c,B2_8_C__c,B2_8_R__c,B2_8_E_1__c,B2_8_PIP__c,B2_9_F__c,B2_9_C__c,B2_9_R__c,B2_9_E_1__c,B2_9_PIP__c,B2_10_F__c,B2_10_C__c,B2_10_R__c,B2_10_E_1__c,B2_10_E_2__c,B2_10_PIP__c,B2_10_MTBA_1__c,B2_10_MTBA_2__c,B2_10a_PIP__c,B2_10a_F__c,B2_10a_C__c ,B2_10b_PIP__c,B2_10c_PIP__c,B2_11_F__c,B2_11_C__c,B2_11_R__c,B2_12_PIP__c, B2_10a_R__c, B2_10a_E_1__c, B2_10b_F__c, B2_10b_R__c, B2_10b_C__c, B2_10b_E_1__c, B2_10c_F__c, B2_10c_R__c, B2_10c_C__c, B2_10c_E_1__c, B2_11_PIP__c, B2_12_F__c, B2_12_R__c, B2_12_C__c, B2_12_E_1__c, B2_10a_MTBA_1__c, B2_10b_MTBA_1__c, B2_10c_MTBA_1__c, B2_12_MTBA_1__c,Status__c, B2_1_E_2__c,B2_1_MTBA_3__c, B2_1_E_3__c,B2_3a_F__c, B2_3a_C__c, B2_3a_R__c, B2_3a_MTBA_1__c, B2_3a_E_1__c, B2_5a_F__c,B2_5a_C__c, B2_5a_R__c, B2_5a_MTBA_1__c, B2_5a_E_1__c, B2_5b_F__c, B2_5b_C__c, B2_5b_R__c, B2_5b_MTBA_1__c, B2_5b_E_1__c,B2_5c_F__c, B2_5c_C__c, B2_5c_R__c, B2_5c_PIP__c, B2_5c_MTBA_1__c, B2_5c_E_1__c, B2_6_E_2__c, B2_1_MTBA_2__c, B2_6_MTBA_1__c, B2_6_MTBA_2__c, B2_9a_F__c, B2_9a_C__c, B2_9a_R__c, B2_7_MTBA_1__c, B2_8_MTBA_1__c, B2_9_MTBA_1__c  FROM IB_Verification_Visit_Feedback_B2__r),
            (SELECT Id, Name,C1_1a_C__c,C1_1a_E_1__c,C1_1a_F__c,C1_1a_MTBA_1__c,C1_1a_PIP__c,C1_1a_R__c,C1_1b_C__c,C1_1b_F__c,C1_1b_R__c,C1_1c_C__c,C1_1c_E_1__c,C1_1c_F__c,C1_1c_MTBA_1__c,C1_1c_PIP__c,C1_1c_R__c,C1_1_C__c,C1_1_E_1__c,C1_1_E_2__c,C1_1_E_3__c,C1_1_E_4__c,C1_1_F__c,C1_1_MTBA_1__c,C1_1_MTBA_2__c,C1_1_MTBA_3__c,C1_1_MTBA_4__c,C1_1_PIP__c,C1_1_R__c,C1_2_C__c,C1_2_E_1__c,C1_2_F__c,C1_2_MTBA_1__c,C1_2_PIP__c,C1_2_R__c,C1_3a_C__c,C1_3a_F__c,C1_3a_R__c,C1_3b_C__c,C1_3b_F__c,C1_3b_R__c,C1_3_C__c,C1_3_F__c,C1_3_R__c,C1_4a_C__c,C1_4a_F__c,C1_4a_R__c,C1_4b_C__c,C1_4b_F__c,C1_4b_R__c,C1_4_C__c,C1_4_F__c,C1_4_R__c,C1_5_C__c,C1_5_F__c,C1_5_R__c,C1_6_C__c,C1_6_F__c,C1_6_R__c,C1_7_C__c,C1_7_F__c,C1_7_R__c,C1_8_C__c,C1_8_F__c,C1_8_R__c,C1_9_C__c,C1_9_E_1__c,C1_9_F__c,C1_9_MTBA_1__c,C1_9_PIP__c,C1_9_R__c,Status__c FROM IB_Verification_Visit_Feedback_C1__r),
            (SELECT Id, Name,C2_1a_C__c,C2_1a_E_1__c,C2_1a_F__c,C2_1a_MTBA_1__c,C2_1a_PIP__c,C2_1a_R__c,C2_1b_C__c,C2_1b_E_1__c,C2_1b_F__c,C2_1b_MTBA_1__c,C2_1b_PIP__c,C2_1b_R__c,C2_1c_C__c,C2_1c_E_1__c,C2_1c_F__c,C2_1c_MTBA_1__c,C2_1c_PIP__c,C2_1c_R__c,C2_1d_C__c,C2_1d_E_1__c,C2_1d_F__c,C2_1d_MTBA_1__c,C2_1d_PIP__c,C2_1d_R__c,C2_1e_C__c,C2_1e_E_1__c,C2_1e_F__c,C2_1e_MTBA_1__c,C2_1e_PIP__c,C2_1e_R__c,C2_1f_C__c,C2_1f_E_1__c,C2_1f_F__c,C2_1f_MTBA_1__c,C2_1f_PIP__c,C2_1f_R__c,C2_1g_C__c,C2_1g_E_1__c,C2_1g_F__c,C2_1g_MTBA_1__c,C2_1g_PIP__c,C2_1g_R__c,C2_1h_C__c,C2_1h_E_1__c,C2_1h_F__c,C2_1h_MTBA_1__c,C2_1h_PIP__c,C2_1h_R__c,C2_1_C__c,C2_1_E_1__c,C2_1_F__c,C2_1_MTBA_1__c,C2_1_PIP__c,C2_1_R__c,C2_2_C__c,C2_2_F__c,C2_2_R__c,C2_3_C__c,C2_3_F__c,C2_3_R__c,C2_4a_C__c,C2_4a_E_1__c,C2_4a_F__c,C2_4a_MTBA_1__c,C2_4a_PIP__c,C2_4a_R__c,C2_4b_C__c,C2_4b_F__c,C2_4b_R__c,C2_4_C__c,C2_4_E_1__c,C2_4_F__c,C2_4_MTBA_1__c,C2_4_PIP__c,C2_4_R__c,C2_5a_C__c,C2_5a_E_1__c,C2_5a_F__c,C2_5a_MTBA_1__c,C2_5a_PIP__c,C2_5a_R__c,C2_5_C__c,C2_5_F__c,C2_5_R__c,C2_6a_C__c,C2_6a_F__c,C2_6a_R__c,C2_6_C__c,C2_6_F__c,C2_6_R__c,C2_7a_C__c,C2_7a_F__c,C2_7a_R__c,C2_7_C__c,C2_7_E_1__c,C2_7_F__c,C2_7_MTBA_1__c,C2_7_PIP__c,C2_7_R__c,C2_8_C__c,C2_8_E_1__c,C2_8_F__c,C2_8_MTBA_1__c,C2_8_PIP__c,C2_8_R__c,C2_9a_C__c,C2_9a_F__c,C2_9a_R__c,C2_9_C__c,C2_9_E_1__c,C2_9_F__c,C2_9_MTBA_1__c,C2_9_PIP__c,C2_9_R__c,C2_10_C__c,C2_10_F__c,C2_10_R__c,C2_11_C__c,C2_11_E_1__c,C2_11_F__c,C2_11_MTBA_1__c,C2_11_PIP__c,C2_11_R__c,Status__c FROM IB_Verification_Visit_Feedback_C2__r),
            //This Query is Updated for CR-709 as part of IBO Staff Augmentation Project Developer: Ali Haider Bajwa
            //Begin
            (SELECT Id, Name, C3_1_C__c,C3_1_E_1__c,C3_1_E_2__c,C3_1_F__c,C3_1_MTBA_1__c,C3_1_MTBA_2__c,C3_1_PIP__c,C3_1_R__c,C3_10_C__c,C3_10_F__c,C3_10_R__c,C3_10a_C__c,C3_10a_F__c,C3_10a_R__c,C3_11_C__c,C3_11_F__c,C3_11_R__c,C3_12_C__c,C3_12_F__c,C3_12_R__c,C3_13_C__c,C3_13_F__c,C3_13_R__c,C3_14_C__c,C3_14_F__c,C3_14_R__c,C3_14a_C__c,C3_14a_F__c,C3_14a_R__c,C3_14b_C__c,C3_14b_F__c,C3_14b_R__c,C3_15_C__c,C3_15_F__c,C3_15_R__c,C3_16_C__c,C3_16_F__c,C3_16_R__c,C3_1a_C__c,C3_1a_F__c,C3_1a_R__c,C3_1b_C__c,C3_1b_E_1__c,C3_1b_F__c,C3_1b_MTBA_1__c,C3_1b_PIP__c,C3_1b_R__c,C3_1c_C__c,C3_1c_F__c,C3_1c_R__c,C3_2_C__c,C3_2_F__c,C3_2_R__c,C3_2a_C__c,C3_2a_F__c,C3_2a_R__c,C3_3_C__c,C3_3_F__c,C3_3_R__c,C3_3a_C__c,C3_3a_F__c,C3_3a_R__c,C3_4_C__c,C3_4_E_1__c,C3_1a_E_1__c,C3_4_F__c,C3_4_MTBA_1__c,C3_4_PIP__c,C3_1a_PIP__c,C3_4_R__c,C3_5_C__c,C3_5_F__c,C3_5_R__c,C3_6_C__c,C3_6_F__c,C3_6_R__c,C3_7_C__c,C3_7_F__c,C3_7_R__c,C3_8_C__c,C3_8_F__c,C3_8_R__c,C3_9_C__c,C3_9_F__c,C3_9_R__c,IB_Verification_Visit_Feedback__c,Status__c FROM IB_Verification_Visit_Feedback_C3__r),//End
            (SELECT Id, Name, IB_Verification_Visit_Feedback__c, C4_1_F__c, C4_1_C__c, C4_1_R__c, C4_1A_F__c, C4_1A_C__c, C4_1A_R__c, C4_1B_F__c, C4_1B_C__c, C4_1B_R__c, C4_1C_F__c, C4_1C_C__c, C4_1C_R__c, C4_1d_F__c, C4_1d_C__c, C4_1d_R__c, C4_2_F__c, C4_2_C__c, C4_2_R__c, C4_2_PIP__c, C4_2_MTBA_1__c, C4_2_E_1__c, C4_3_F__c, C4_3_C__c, C4_3_R__c, C4_4_F__c, C4_4_C__c, C4_4_R__c, C4_5_F__c, C4_5_C__c, C4_5_R__c, C4_6_F__c, C4_6_C__c, C4_6_R__c, C4_6A_F__c, C4_6A_C__c, C4_6A_R__c, C4_7_F__c, C4_7_C__c, C4_7_R__c, C4_7A_F__c, C4_7A_C__c, C4_7A_R__c, C4_8_F__c, C4_8_C__c, C4_8_R__c, C4_5A_C__c, C4_5A_F__c, C4_5A_R__c,C4_1_PIP__c,C4_1_E_1__c,C4_1_E_2__c,C4_1_E_3__c,C4_3_PIP__c,C4_3_E_1__c,C4_9_F__c,C4_9_C__c,C4_9_R__c,C4_9_PIP__c,C4_9_E_1__c,C4_1_MTBA_1__c,C4_1_MTBA_2__c,C4_1_MTBA_3__c, C4_3_MTBA_1__c,C4_9_MTBA_1__c, C4_1a_PIP__c, C4_1a_E_1__c, C4_1a_MTBA_1__c,Status__c FROM IB_Verification_Visit_Feedback_C4__r)
            FROM IB_Verification_Visit_Feedback__c 
            WHERE Id = :con.getId() 
        ];
        programmeId = visit2.IB_Programme__r.id;
        isMypPartnership=false;
        isMultiCampus=false;
        hasWorkingLanguage=visit2.IB_Application__r.Application_Lookup_to_Programme__r.Has_Working_Language__c;
        integer addressCount = [SELECT COUNT() FROM IB_Address__c WHERE IB_Account__c=:visit2.Account__c];
        if(addressCount>0)
            isMultiCampus=true;
        if(!visit2.IB_Verification_Visit_Feedback_A__r.isEmpty())
            sectionA = visit2.IB_Verification_Visit_Feedback_A__r.get(0);
        if(!visit2.IB_Verification_Visit_Feedback_B__r.isEmpty())
            sectionB1 = visit2.IB_Verification_Visit_Feedback_B__r.get(0);            
        if(!visit2.IB_Verification_Visit_Feedback_B2__r.isEmpty())
            sectionB2 = visit2.IB_Verification_Visit_Feedback_B2__r.get(0);
        if(!visit2.IB_Verification_Visit_Feedback_C1__r.isEmpty())
            sectionC1 = visit2.IB_Verification_Visit_Feedback_C1__r.get(0);
        if(!visit2.IB_Verification_Visit_Feedback_C2__r.isEmpty())
            sectionC2 = visit2.IB_Verification_Visit_Feedback_C2__r.get(0);
        if(!visit2.IB_Verification_Visit_Feedback_C3__r.isEmpty())
            sectionC3 = visit2.IB_Verification_Visit_Feedback_C3__r.get(0);
        if(!visit2.IB_Verification_Visit_Feedback_C4__r.isEmpty())
            sectionC4 = visit2.IB_Verification_Visit_Feedback_C4__r.get(0);    
        
        programmeName=visit2.IB_Application__r.Application_Lookup_to_Programme__r.Name;
        prog='MYP';
        isPyp=false;
        isMyp=false;
        isDp=false;
        isCp=false;
        isCpPhase1=false;
        isCpPhase2=false;
        
        visit = new IB_Verification_Visit_Feedback__c(Id=visit2.Id,IB_Application__c=visit2.IB_Application__c,Account__c=visit2.Account__c,IB_Programme__c=visit2.IB_Application__r.Application_Lookup_to_Programme__c,Status__c=visit2.Status__c,Lock_Form__c=visit2.Lock_Form__c,Assignment_Id__c=visit2.Assignment_Id__c);
        if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='PYP')
        {
            isPyp=true;
            prog='PYP';
        }
        if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='MYP'||
           visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='MYP_Partner')
        {
            isMyp=true;
            prog='MYP';
            if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='MYP_Partner')
                isMypPartnership=true;
        }
        if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='Diploma_Programme')
        {
            isDp=true;
            prog='DP';
        }
        if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='CP')
            isCp=true;
        if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.RecordType.DeveloperName=='IBCC')
        {
            isCp=true;
            if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c == 'Phase 1')
            {
                isCpPhase1=true;
                prog='CP1';
            }
            if(visit2.IB_Application__r.Application_Lookup_to_Programme__r.IBCC_Implementation_Phase__c == 'Phase 2')
            {
                isCpPhase2=true;
                prog='CP2';
            }
        }       
        ApplicationService.setApplicationId(visit2.IB_Application__r.Id);
        application = ApplicationService.getApplication();        
        assessment = ApplicationService.getApplicationAssessment();

        headerLinks = new VerificationVisitLinks();
        headerLinks.programmeName = programmeName;
        headerLinks.website = visit2.Account__r.website;
        for (IB_Application__c app : [SELECT Id, RecordType.DeveloperName FROM IB_Application__c WHERE Application_Lookup_to_Programme__c = :visit2.IB_Programme__c]) {
            if (app.RecordType.DeveloperName == 'Application_for_Candidacy') {
                headerLinks.afc = app.Id;
            }
            if (app.RecordType.DeveloperName == 'Application_for_Authorization') {
                headerLinks.afa = app.Id;
            }
        }
        headerLinks.actionPlan = visit2.IB_Programme__c;
        System.debug('before headerLinks.exitReport : ' + headerLinks.exitReport);
        System.debug('visit2 : ' + visit2);
        headerLinks.exitReport = visit2.Id;
        System.debug('after headerLinks.exitReport : ' + headerLinks.exitReport);
        if (isMyp) {

            List<IB_Programme__c> mypPartnerProgrammes = null;
            if (isMypPartnership) {
                mypPartnerProgrammes = [
                    SELECT Id, Name, Account__r.Website   
                    FROM IB_Programme__c 
                    WHERE Id = :visit2.IB_Programme__r.Master_Programme__c
                    OR (Master_Programme__c = :visit2.IB_Programme__r.Master_Programme__c AND Id != :visit.IB_Programme__c)
                ];
            }
            else {
                mypPartnerProgrammes = [
                    SELECT Id, Name, Account__r.Website   
                    FROM IB_Programme__c 
                    WHERE Master_Programme__c = :visit2.IB_Programme__c
                ];
            }

            if (!mypPartnerProgrammes.isEmpty()) {

                Set<Id> progIdSet = new Set<Id>();
                mypPartnershipLinks = new List<VerificationVisitLinks>();
                
                for (IB_Programme__c prog : mypPartnerProgrammes) {
                    progIdSet.add(prog.Id);
                }
                List<IB_Application__c> mypApplications = [
                    SELECT Id, RecordType.DeveloperName, Application_Lookup_to_Programme__c 
                    FROM IB_Application__c 
                    WHERE Application_Lookup_to_Programme__c IN :progIdSet
                ];
                for (IB_Programme__c prog : mypPartnerProgrammes) {
                    VerificationVisitLinks links = new VerificationVisitLinks();
                    links.programmeName = prog.Name;
                    links.website = prog.Account__r.Website;
                    links.actionPlan = prog.Id;
                    for (IB_Application__c app : mypApplications) {
                        if (app.Application_Lookup_to_Programme__c == prog.Id && app.RecordType.DeveloperName == 'Application_for_Candidacy') {
                            links.afc = app.Id;
                        }
                        if (app.Application_Lookup_to_Programme__c == prog.Id && app.RecordType.DeveloperName == 'Application_for_Authorization') {
                            links.afa = app.Id;
                        }
                    }
                    mypPartnershipLinks.add(links);
                }

            }

        }

        //Get due date
       Staffing_Event__c[] events = [SELECT End_Date__c FROM Staffing_Event__c where Event_Type__c =  'Verification Visit' AND IB_Event__r.Related_IB_Programme__c =:  visit.IB_Programme__c];
       if(events.size()>0)
       {
           dueDate = events[0].End_Date__c;
       }

        visit2 = null;

    }
    public PageReference submitVerificationVisit()
    {
        try
        {
            visit.Status__c='Submitted';
            update visit;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));
        }
        PageReference pr = Page.MyAssignmentDetails;
        Map<String,String> paramMap = pr.getParameters();
        paramMap.put('Id',visit.Assignment_Id__c);
        paramMap.put('role','Reader');
        pr.setRedirect(true);
        return pr;
    }
    public PageReference saveSectionA()
    {
        try
        {
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionA;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }

        return null;
    }
    public PageReference saveSectionB1()
    {
        try
        {    
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionB1;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionB2()
    {
        try
        {            
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionB2;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionC1()
    {
        try
        {            
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionC1;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionC2()
    {
        try
        {            
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionC2;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionC3()
    {
        try
        {            
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionC3;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference saveSectionC4()
    {
        try
        {            
            if(isPageInternal){
                visit.Edited_by_Staff__c = true;
                update visit;
            }
            update sectionC4;            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Feedback_Saved)); 
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +e));            
        }        
        return null;
    }
    public PageReference activeSection
    {   
        get
        {            
            PageReference pr = programmeMap.get(prog).get(activeTab);            
            pr.getParameters().put('Id', visit.Id);            
            pr.setRedirect(true);            
            return pr;
        }
        set;
    }
    public void goToNextSection()
    {
        if(activeTab=='sectiona')
            activeTab='sectionb1';
        else if(activeTab=='sectionb1')
            activeTab='sectionb2';
        else if(activeTab=='sectionb2')
            activeTab='sectionc1';
        else if(activeTab=='sectionc1')
            activeTab='sectionc2';
        else if(activeTab=='sectionc2')
            activeTab='sectionc3';
        else if(activeTab=='sectionc3')
            activeTab='sectionc4';
        else if(activeTab=='sectionc4')
            activeTab='feedback';
        renderSection();
        //PageReference pr = activeSection;
        //pr.setRedirect(true);
        //return pr;
    }
    private Map<String, Map<String,PageReference>> programmeMap
    {
        get
        {
            if(programmeMap == null)
            {
                programmeMap = new Map<String,Map<String,PageReference>>();
                programmeMap.put('MYP',new Map<String, PageReference>{       
                        'instructions' => Page.IbenVerificationVisitInstruct,             
                        'sectiona' => Page.IbenVerificationVisitSectionA_MYP,
                        'sectionb1' => Page.IbenVerificationVisitSectionB1_MYP,
                        'sectionb2' => Page.IbenVerificationVisitSectionB2_MYP,               
                        'sectionc1' => Page.IbenVerificationVisitSectionC1_MYP,
                        'sectionc2' => Page.IbenVerificationVisitSectionC2_MYP,
                        'sectionc3' => Page.IbenVerificationVisitSectionC3_MYP,
                        'sectionc4' => Page.IbenVerificationVisitSectionC4_MYP,
                        'feedback' => Page.IbenVerificationVisitFeedback
                        });
                programmeMap.put('CP1',new Map<String, PageReference>{ 
                        'instructions' => Page.IbenVerificationVisitInstruct,                    
                        'sectiona' => Page.IbenVerificationVisitSectionA_CP1,
                        'sectionb1' => Page.IbenVerificationVisitSectionB1_CP1,
                        'sectionb2' => Page.IbenVerificationVisitSectionB2_CP1,               
                        'sectionc1' => Page.IbenVerificationVisitSectionC1_CP1,
                        'sectionc2' => Page.IbenVerificationVisitSectionC2_CP1,
                        'sectionc3' => Page.IbenVerificationVisitSectionC3_CP1,
                        'sectionc4' => Page.IbenVerificationVisitSectionC4_CP1,
                        'feedback' => Page.IbenVerificationVisitFeedback
                        //'courseoutline' => Page.IbenVerificationVisitCourseOutline
                        });
                programmeMap.put('CP2',new Map<String, PageReference>{ 
                        'instructions' => Page.IbenVerificationVisitInstruct,                    
                        'sectiona' => Page.IbenVerificationVisitSectionA_CP2,
                        'sectionb1' => Page.IbenVerificationVisitSectionB1_CP2,
                        'sectionb2' => Page.IbenVerificationVisitSectionB2_CP2,               
                        'sectionc1' => Page.IbenVerificationVisitSectionC1_CP2,
                        'sectionc2' => Page.IbenVerificationVisitSectionC2_CP2,
                        'sectionc3' => Page.IbenVerificationVisitSectionC3_CP2,
                        'sectionc4' => Page.IbenVerificationVisitSectionC4_CP2,
                        'feedback' => Page.IbenVerificationVisitFeedback
                         //'courseoutline' => Page.IbenVerificationVisitCourseOutline
                        });
                programmeMap.put('DP',new Map<String, PageReference>{ 
                        'instructions' => Page.IbenVerificationVisitInstruct,                    
                        'sectiona' => Page.IbenVerificationVisitSectionA_DP,
                        'sectionb1' => Page.IbenVerificationVisitSectionB1_DP,
                        'sectionb2' => Page.IbenVerificationVisitSectionB2_DP,               
                        'sectionc1' => Page.IbenVerificationVisitSectionC1_DP,
                        'sectionc2' => Page.IbenVerificationVisitSectionC2_DP,
                        'sectionc3' => Page.IbenVerificationVisitSectionC3_DP,
                        'sectionc4' => Page.IbenVerificationVisitSectionC4_DP,
                        'feedback' => Page.IbenVerificationVisitFeedback
                        //'courseoutline' => Page.IbenVerificationVisitCourseOutline
                        });
                programmeMap.put('PYP',new Map<String, PageReference>{  
                        'instructions' => Page.IbenVerificationVisitInstruct,                   
                        'sectiona' => Page.IbenVerificationVisitSectionA_PYP,
                        'sectionb1' => Page.IbenVerificationVisitSectionB1_PYP,
                        'sectionb2' => Page.IbenVerificationVisitSectionB2_PYP,               
                        'sectionc1' => Page.IbenVerificationVisitSectionC1_PYP,
                        'sectionc2' => Page.IbenVerificationVisitSectionC2_PYP,
                        'sectionc3' => Page.IbenVerificationVisitSectionC3_PYP,
                        'sectionc4' => Page.IbenVerificationVisitSectionC4_PYP,
                        'feedback' => Page.IbenVerificationVisitFeedback
                        });
            }
            return programmeMap;
        }
        set;
    }
    public PageReference renderSection()
    {
        ApplicationService.setApplicationId(visit.IB_Application__c);
        application = ApplicationService.getApplication();        
        assessment = ApplicationService.getApplicationAssessment();
        return null;
    }
    
    public List<IB_Role__c> rolesByProgramme
    {
        get
        {            
            if(rolesByProgramme==null)
            {
                rolesByProgramme = new List<IB_Role__c>([SELECT Id, Name, Status__c, IB_Contact__c, Role_Has_Subjects__c,IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c,  
                                                         IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name, 
                                                         IB_Contact__r.Qualifications__c, IB_Contact__r.Number_of_years_at_school__c, IB_Contact__r.Full_time_Part_time__c , Programme_Selection__c, Programme_Selection_Es__c, Programme_Selection_FR__c, 
                                                         IB_Contact__r.IBEN_Preferred_Email__c, IB_Contact__r.Title,
                                                         (SELECT Id, Name, Year__c, Contact__c, Role__c, Role_Subject__c, Workshop_Category__c, Workshop_Status__c, Workshop_Name__c, Workshop_Sub_Name__c, Region__c, City__c, Workshop_Type__c FROM Contact_Professional_Development__r),
                                                         (SELECT Id, Name, IB_Subject__c, Role_And_Application__c, IB_Programme__c, Subject_Group__c, Subject_Name__c, toLabel(IB_Subject__r.Subject_Group__c), IB_Subject__r.Subject_Name_FR__c, IB_Subject__r.Subject_Name_SP__c  FROM Role_Application_Subjects__r)
                                                         FROM IB_Role__c
                                                         WHERE IB_Account__c =:visit.Account__c
                                                         AND IB_Programme_New__c=:visit.IB_Programme__c
                                                         AND (End_Date__c = null OR End_Date__c > TODAY)
                                                         ORDER BY Last_Name__c,IB_Role_Name__c]);
            }
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
                                                                                 WHERE IB_Application_Lookup__c=:visit.IB_Application__c]);
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
                applicationFacilityList = new List<Application_Account_Facilities__c>([
                // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
                //begin  
                    /*SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                                                                                       B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                                                                                       FROM Application_Account_Facilities__c
                                                                                       WHERE IB_Application_Lookup__c = :visit.IB_Application__c]*/

                    SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                                                                                       B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                                                                                       FROM Application_Account_Facilities__c
                                                                                       WHERE IB_Application_Lookup__c = :visit.IB_Application__c]
                                                                                     );
                //End
            }
            return applicationFacilityList;
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
                    WHERE IB_Application_Lookup__c = :visit.IB_Application__c
                ]);
            return applicationLibraryList;  
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
                    WHERE IB_Application_Lookup__c = :visit.IB_Application__c
                ]);
            return applicationTeachingTimeList;
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
                     WHERE IB_Application_Lookup__c = :visit.IB_Application__c
                     ORDER By Subject_Group__c ASC]);
            return subjectProposals;
        }
        set;
    }
    public List<Application_Coordinator_Time__c> serviceCoordinatorTimeList
    {
        get
        {
            
            if(serviceCoordinatorTimeList==null){    
                serviceCoordinatorTimeList = [
                    SELECT  B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c, B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
                    Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                    FROM Application_Coordinator_Time__c
                    WHERE IB_Application_Lookup__c = :visit.IB_Application__c
                    AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS coordinator' OR Type__c = 'Programme coordinator')
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
                applicationRequirements= new List< IB_Application_Curriculum_Requirement__c >(
                    [SELECT Id, Programme_Requirements__c, Programme_Requirements_Locales__c, CP_years__c, DP_Years__c
                     FROM IB_Application_Curriculum_Requirement__c
                     WHERE IB_Application__c = :visit.IB_Application__c]);
            return applicationRequirements;
        }
        set;
    }
    public PageReference goToExitReport()
    {
        return Page.IbenVerificationVisitExitReport;
    }

    public class VerificationVisitLinks {
        public String programmeName { get; set; }
        public String website { get; set; }
        public String afc { get; set; }
        public String afa { get; set; }
        public String actionPlan { get; set; }
        public String exitReport { get; set; }
    }
    public boolean isEditable
    {
        get
        {
            //if(isEditable==null) {
                if ((isPageInternal && visit.Status__c == 'Submitted') || (!visit.Lock_Form__c && (visit.Status__c == 'Not Started' || visit.Status__c == 'Return to Team Leader' || String.isEmpty(visit.Status__c)))) {
                    isEditable=true;
                }
                else
                    isEditable=false;
                // page locking scenario
                if (isEditable && !isPageInternal && getPageLock() != null && getPageLock().Locked_By__c != UserInfo.getUserId()) 
                    isEditable = false;
                if(!getIsTeamLeader() && visit.Status__c == 'Return to Team Leader')
                    isEditable = false;            
            //}
            SYstem.debug('mw isEditable>>> '+isEditable);
            return isEditable;
        }
        set;
    }

    public boolean isPageInternal 
    {
        get
        {
            if(isPageInternal==null)
                isPageInternal=ApexPages.currentPage().getUrl().contains('Internal');
            SYstem.debug('mw isPageInternal>>> '+isPageInternal);
            return isPageInternal;
        }
        set;
    }

    public boolean getIsTeamLeader() {

        if (isPageInternal) {
            return false;
        }
        
        User usr = UserService.getUser();
        System.debug('mw usr.ContactId'+usr.ContactId);
        System.debug('mw programmeId '+programmeId.substring(0,15));
        if (usr.ContactId != null) {
            //IBEN Assignment = Staffing_Event__c
            List<Staffing_Event__c> staffEvent = [
                SELECT Id, Name, IB_Event__c, Related_Programme__c, Related_Programme_Name__c, Event_Type__c 
                FROM Staffing_Event__c
               // WHERE Related_Programme__c = :visit.IB_Programme__r.Id 
                WHERE Related_Programme__c = :programmeId.substring(0,15)
                AND Event_Type__c = 'Verification Visit'
               // LIMIT 1
            ]; 
                       
            
            System.debug('mw staffEvent.size() : '+ staffEvent.size());
            //My Assignment New = My_Staffing_Event__c
            List<My_Staffing_Event__c> myStaffingEvents = [
                SELECT Staffing_Event__c, IB_Contact__c, IB_Role_Name__c, Application_Status__c
                FROM My_Staffing_Event__c
                WHERE Staffing_Event__c in :staffEvent //= :staffEvent[0].Id   
                AND Application_Status__c = 'Confirmed' 
                AND IB_Role_Name__c = 'School Visit Team Leader' 
                AND IB_Contact__c = :usr.ContactId 
            ];
            System.debug('mw SIZE'+myStaffingEvents.size());
            System.debug('mw myStaffingEvents'+myStaffingEvents);
            if (!myStaffingEvents.isEmpty()) {
                 System.debug('mw returning true');
                return true;
            }
        
        }
        System.debug('mw returning false');
        return false;

    }

    public PageLock__c getPageLock() {

        PageLockService.setProgrammeId(visit.IB_Programme__c);
        PageLock__c lock = PageLockService.getPageLock('IbenVerificationVisit', activeTab);
        System.debug(lock);

        return lock;

    }

    public PageReference breakLock() {

        PageLockService.setProgrammeId(visit.IB_Programme__c);
        PageLock__c lock = PageLockService.getPageLock('IbenVerificationVisit', activeTab);
        System.debug(lock);

        delete lock;
        PageLockService.isCached = false;

        return null;

    }

    public PageReference lockPage() {

        PageLock__c lock = new PageLock__c(
            Community__c = 'IBEN', 
            Page_Name__c = 'IbenVerificationVisit', 
            Page_Section__c = activeTab, 
            Locked_By__c = UserInfo.getUserId(), 
            Programme__c = visit.IB_Programme__c
        );

        insert lock;
        PageLockService.isCached = false;

        return null;

    }

}