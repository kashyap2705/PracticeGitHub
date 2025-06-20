public class ApplicationDAO {
    
    private static final ApplicationDAO instance = new ApplicationDAO();
    private static IB_Application__c application;
    private static List<IB_Application__c> applications;
    
    private ApplicationDAO() {}
    
    public static ApplicationDAO getInstance() {
        return instance;
    }
    
    /*public IB_Application__c getApplicationBySectionAndId (Id applicationId, String appSection) {

application = [
SELECT Id, Account__c, Application_Lookup_to_Programme__c, Application_Lookup_to_Programme__r.Id, AFC_Profile_Review_Status__c, AFC_School_Description_Status__c, AFC_Programme_Information_Status__c,
AFC_Subject_Proposal_Status__c, AFC_Philosophy_Status__c, AFC_Leadership_Structure_Status__c, AFC_Resources_Support_Status__c, AFC_Collaborative_Planning_Status__c, AFC_Written_Curriculum_Status__c,
AFC_Teaching_Learning_Status__c, AFC_Assessment_Status__c, AFC_Implementation_Budget_Status__c, AFC_Documents_Status__c, AFC_Agreement_Status__c, Status__c,
B_1_1_1_AF_Explain_informed__c, B_1_2_1_Educational_Authority__c, B_1_2_1_Other_Description__c, B_1_2_2a_Authority_Formed__c, B_1_2_2a_Explain_Authority__c, B_1_2_3_Pedagogical_Leadership__c,
B_1_2_4_Staff_Recruiting__c, B124_CP_recruiting__c, B_1_2_5_Recruiting_Challenges__c, Current_Assessment_15__c, Current_Assessment_17__c, B_1_3_1_Common_Language__c, B_1_3_2_Different_Language__c,
Current_Assessment_18__c, B_1_4_1_Weekly_Schedule__c, Current_Assessment_19__c, B_1_5_1DP_CP_Policy_Process__c, B1_5a_1_Language_Policy__c, B1_5a_2_PYP_MYP_Language_Support__c, B_1_5a_3_PYP_MYP_Language_Provisions__c,
Current_Assessment_20__c, B1_5c_1_PYP_Assessment_Perspective__c, Current_Assessment_21__c, B1_5c_1_MYP_Assessment_Process__c, Current_Assessment_22__c, Current_Assessment_23__c,
B1_5b_1_Assessent_Policy__c, B1_5b_2_DP_CP_Language_Provisions__c, Current_Assessment_24__c, Current_Assessment_25__c, Current_Assessment_26__c, SD_Staff_Language__c,
Current_Assessment_27__c, B2_1a_1_DP_CAS_Time__c, Current_Assessment_28__c, Current_Assessment_29__c, Current_Assessment_30__c, Current_Assessment_31__c, B2_3a_2_Staff_Training__c,
Current_Assessment_32__c, B2_4_1_Collaborative_Planning__c, Current_Assessment_33__c, B2_5_1_Chk_a__c, B2_5_1_Chk_b__c, B2_5_1_Text_b__c, B2_5_1_Chk_c__c, B2_5_1_Text_c__c, B2_5_1_Chk_d__c,
B2_5_1_Text_d__c, B2_5_1_Chk_e__c, B2_5_1_Chk_f__c, B2_5_1_Text_f__c, B2_5_1_Chk_g__c, B2_5_1_Chk_h__c, B2_5_1_Text_h__c, B2_5_2_Internet_Access__c, Does_the_school_have_WiFi__c, B2_5_4_Internet_Restrictions__c,
B2_5_4_Classroom_Computers__c, B2_5_2_DP_CP_Community_Resources__c, Current_Assessment_34__c, Current_Assessment_35__c, B2_5b_DP_CP_IT_Facilities__c, Current_Assessment_36__c, B2_5c_1_DP_CP_Exam_Location__c,
Current_Assessment_80__c, B2_6_1_Independent_Access__c, B2_6_2_Browse_Borrow__c, B2_6_1_CP_Library_Resources__c, B2_6_4_Study_Spaces__c, B2_6_5_Age_Group__c, B2_6_5a_Who_Else__c, B2_6_7_Whole_Class__c, B2_6_8_Library_Managed__c,
B2_6_8_Class_Library__c, B2_6_9_Library_Description__c, Current_Assessment_37__c, B2_6a_2_DP_Adequate_Resources__c, Current_Assessment_38__c, GEN_Current_Implementation__c, Current_Assessment_38_a__c,
B2_9a_1_DP_Guidance__c, B2_9a_1_CP_Guidance__c, Current_Assessment_39__c, B2_10_2_Standard_Level__c, B2_10_3_Display_Standard__c, B2_10_4_CP_Programme_Choices__c, Current_Assessment_40__c,
B2_10a_2_Schedule_Adjustments__c, Current_Assessment_41__c, Current_Assessment_42__c, B2_10c_2_MYP_Min_Req__c, B2_10c_2_MYP_Sched_Adj__c, B2_10c_3_MYP_Min_Teach__c, B2_10c_3_MYP_Sched_Adj__c,
B2_10c_4_MYP_Teach_Hours__c, B2_10c_4_MYP_Sched_Adj__c, B2_10c_5_MYP_Lang_Sustained__c, B2_10c_5_MYP_Sched_Adj__c, B2_10c_6_MYP_No_Visual_Art__c, B2_10c_7_MYP_PE_50__c, B2_10c_7_MYP_Describe_Sched__c,
REQ_B2_10c_MYP_Promotes_Concurrency__c, B2_10c_2_DP_CP_Schedule_Adjustments__c, B2_10c_2a_MYP_Instruct_Lang__c, Current_Assessment_42_a__c, Current_Assessment_43__c, B2_1_12_1_MYP_Personal_Project_Process__c,
B2_12_2_MYP_Community_Project__c, B2_12_3_MYP_Community_project__c
FROM IB_Application__c
WHERE Id = :applicationId
];

return application;
}*/
    
    public IB_Application__c getApplicationById(Id applicationId) {
        
        system.debug('In getApplicationById(Id)');
        system.debug('applicationId ====> '+applicationId);
        try
        {
            application = [
                SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, A1_2_Mission_Align__c, A1_3_Refinement_Process__c,
                A1_4_Alignment_Extent__c, A1_5_Further_Align__c, A3_4_10_Pedagogical_Outcomes__c, A3_4_11_Teacher_Actions__c,
                A3_4_12_Teacher_Outcomes__c, A3_4_1_Governing_Actions__c, A3_4_2_Governing_Outcomes__c, A3_4_3_Local_Actions__c,
                A3_4_4_Local_Outcomes__c, A3_4_5_Other_Actions__c, A3_4_6_Other_Outcomes__c, A3_4_7_Parents_Actions__c, A3_4_8_Parents_Outcomes__c,
                A3_e_2_PYP_Transdisciplinary_Challenges__c, A3_4_9_Pedagogical_Actions__c, A3_5_Additional_Information__c, A5_1_DP_CAS_Involvement__c,
                A5_1_Indicate_Interactions__c, A7_a_1_PYP_What_languages__c, A7_a_2_PYP_Language_Age__c, A7a_1_SS_New_Languages__c,
                A8_1_OCC_Utilization__c, A9_1_2a_Student_Criteria__c, A9_a_1_PYP_Inclusive_Program__c, A9_a_2_Admission_Requirements__c,
                A9_a_2_CP_Career_Programme__c, A9_a_2_CP_Integrate_Students__c, A9_a_2_CP_Programme_Choice__c, A9_a_2_CP_Promote_Access__c,
                A9_a_2_MYP_Year__c, A9_a_2_MYP_Year_2__c, A9_a_2_MYP_Year_3__c, A9_a_2_MYP_Year_4__c, A9_a_2_MYP_Year_5__c,
                A9_a_3_Admissions_Policy__c, A9_a_3_MYP_Inclusive_Program__c, A9_a_4_Full_Cohort_Explanation__c,
                A1_5_describe_other__c, A9_a_4a_Access_Description__c, AC_A3_2_Additional_Stakeholders_Other__c, A9_a_MYP_5_Year_Explanation__c,
                A9_a_MYP_All_Grades_Start__c, AC_3_1_Feasability_Lead__c, AC_3_1_Feasability_Leads__c, AC_4_1_DP_CP_International_Embodied__c,
                AC_A1_2b_CP_Implementation__c, AC_A1_2c_CP_Community__c, AC_A3_2_Additional_Stakeholders__c, AC_A3_3_Feasibility_Process__c,
                AF_4_2_DP_CP_International_Promoted__c, AF_A1_2_Mission_Change__c, AF_A1_2a_Process_Refinement__c, AF_A1_4_Philosophy_Change__c,
                AF_A1_4a_Who_involved__c, AF_A2_1_DP_Approaches_to_Learning__c, AF_A2_2_DP_School_s_Philosophy__c, AF_Update_Information__c,
                A_1_1_Current_Mission__c, A_9a_2_Enrollment_Policy__c, A_9a_3_Enrollment_Criteria__c, A1_5_Other__c, Additional_Comments__c,
                Application_Lookup_to_Programme__c, Assessment_Philosophy__c, B1_5a_1_DP_Admissions_Policy__c, B1_5a_1_DP_CP_Admission_Changes__c,
                B1_5a_1_Language_Policy__c, B1_5a_1_SS_Language_Policy__c, B1_5a_2_PYP_MYP_Language_Support__c, B1_5b_1_Assessent_Policy__c,
                B1_5b_1_Communicating_Policy__c, B1_5b_2_DP_CP_Language_Provisions__c, B1_5b_3_DP_CP_Language_Policy__c, B1_5b_MYP_Assessment__c,
                B1_5c_1_DP_CP_Support_Requirements__c, B1_5c_1_MYP_Assessment_Process__c, B1_5c_1_PYP_Assessment_Perspective__c,
                B1_5c_1a_Assessment_Process__c, B1_5d_1_DP_Assessment_Policy__c, B1_5e_1_DP_CP_Honesty_Revisions__c, B1_5e_1_DP_Describe_Revisions__c,
                B1_6_1_DP_Structure_Examples__c, /*B2_10_1_DP_CP_Chose_Course__c, */B2_10_1_DP_CP_Current_Num__c, B2_10_1_DP_CP_Estimated_Num__c,
                B2_10_1_DP_CP_Instruction_Language__c, B2_10_1_DP_CP_Subject_Level__c, B2_10_1_DP_CP_Subject_Name__c, B2_10_1_DP_CP_Y1_Hours__c,
                B2_10_1_DP_CP_Y1_Name__c, B2_10_1_DP_CP_Y2_Hours__c, B2_10_1_DP_CP_Y2_Name__c, B2_10_1a_Cp_IBCC_Choose_Course__c,
                B2_10_1a_DP_CP_Subject_Changes__c, B2_10_2_DP_CAS_Interviews__c, B2_10_2_Standard_Level__c, B2_10_3_Display_Standard__c,
                B2_10_4_CP_Programme_Choices__c, B2_10_c_1b_Name_of_Subject__c, B2_10a_2_Schedule_Adjustments__c, B2_10a_2_Schedule_Change__c,
                B2_10c_2_CP_IBCC_School_Adjustments__c, B2_10c_2_DP_CP_Schedule_Adjustments__c, /*B2_10c_2_DP_School_Adjustments__c, */
                B2_10c_2_MYP_Min_Req__c, B2_10c_2_MYP_Sched_Adj__c, B2_10c_2_MYP_Y_Subject_Taught__c, B2_10c_2_MYP_Year_Hours__c,
                B2_10c_2a_DP_CP_IBCC_Changes_Made__c, B2_10c_2a_DP_CP_IBCC_Explain__c, B2_10c_2a_MYP_Instruct_Lang__c, B2_10c_3_MYP_Min_Teach__c,
                B2_10c_3_MYP_Sched_Adj__c, B2_10c_4_MYP_Sched_Adj__c, B2_10c_4_MYP_Teach_Hours__c, B2_10c_5_MYP_Lang_Sustained__c,
                B2_10c_5_MYP_Sched_Adj__c, B2_10c_6_DP_Time_Arrange__c, B2_10c_6_MYP_No_Visual_Art__c, B2_10c_6_MYP_Visual_Art__c,
                B2_10c_7_DP_Y1_End__c, B2_10c_7_DP_Y1_Start__c, B2_10c_7_DP_Y2_End__c, B2_10c_7_DP_Y2_Start__c, B2_10c_7_MYP_Describe_Sched__c,
                B2_10c_7_MYP_PE_50__c, B2_12_1_CP_IBCC_Support_Plan__c, B2_12_1_DP_Extended_Essay__c, B2_12_2_MYP_Community_Project__c,
                B2_12_3_MYP_Community_project__c, B2_12_4_MYP_Community_project__c, B2_1_12_1_MYP_Personal_Project_Process__c, B2_1a_1_DP_CAS_Time__c,
                B2_1a_1a_Service_Learning_Time__c, B2_2_2_Staff_Standards__c, B2_2_3_Full_Time__c, B2_2_3_PYP_Single_Subject__c,
                B2_2_4_DP_CAS_Advisor__c, B2_2_4_DP_CAS_Consistency__c, B2_2_4_DP_CAS_Guidance__c, B2_2_4_DP_CAS_Identify__c,
                B2_2_4_DP_CAS_Student_Supervision__c, B2_2_4_DP_CAS_Students__c, B2_2_4_Part_Time__c, B2_3a_2_Staff_Training__c,
                B2_4_1_Collaborative_Planning__c, B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c,
                B2_4_2_Meeting_Objectives__c, B2_5_1_Facilities_Changes__c, B2_5_1_Technology_Approach__c, B2_5_2_DP_CP_Community_Resources__c,
                B2_5_2_Internet_Access__c, B2_5_3_CP_IT_Support__c, B2_5_3_CP_Services_Learning__c, B2_5_4_CP_Skilss_Development__c,
                B2_5_4_Classroom_Computers__c, B2_5_4_Internet_Restrictions__c, B2_5_5_CP_IT_Provisions__c, B2_5_5_Facility_Description__c,
                B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c, B2_5_5_PYP_Facilities_Components__c, B2_5c_1_DP_CP_Exam_Location__c,
                B2_5c_1_Exam_Storage__c, B2_6_1_CP_Library_Resources__c, B2_6_1_Independent_Access__c, B2_6_2_Browse_Borrow__c,
                B2_6_4_Study_Spaces__c, B2_6_5_Age_Group__c, B2_6_5a_Who_Else__c, B2_6_6_CP_Resources__c, B2_6_7_Whole_Class__c,
                B2_6_8_Class_Library__c, B2_6_9_Adequate_Resources__c, B2_6_9_Library_Description__c, B2_6a_1_DP_Adequate_Resources__c,
                B2_6a_2_DP_Adequate_Resources__c, B2_9_1_DP_Student_Guidance__c, B2_9_1_DP_Student_Induction__c, B2_9_1_MYP_Student_Guidance__c,
                B2_9a_1_CP_Guidance__c, B2_9a_1_DP_Guidance__c, B2_9a_1_DP_SS_Guidance__c, B_1_1_1_AF_Explain_informed__c,
                B_1_1_1_SS_Describe_Informed__c, B_1_2_1_Educational_Authority__c, B_1_2_1_Other_Description__c, B_1_2_2a_Authority_Formed__c,
                B_1_2_2a_Explain_Authority__c, B_1_2_3_Pedagogical_Leadership__c, B_1_2_3_SS_Programme_Implementation__c,
                B_1_2_3a_AF_Pedagogical_Changes__c, B_1_2_3b_AF_New_Members__c, B_1_2_4_CP_Staff_Recruiting__c, B_1_2_4_Staff_Recruiting__c,
                B_1_2_5_Recruiting_Challenges__c, B_1_2_5_SS_Pedagogical_Changes__c, B_1_2_5a_SS_Explain_Changes__c,
                B_1_2_6_SS_Pedagogical_Leadership__c, B_1_3_1_Common_Language__c, B_1_3_1_Coordinator_Proficient__c, B_1_3_2_Different_Language__c,
                B_1_3_2ba_MYP_SS_Language_Proficiency__c, B_1_4_1_Weekly_Schedule__c, B_1_4_2a_Duty_Chart__c, B_1_4_2b_Time_Chart__c,
                B_1_5_1_DP_CP_AF_Verification_Visit__c, B_1_5_1_DP_CP_SS_Verification_Visit__c, B_1_5a_3_PYP_MYP_Language_Provisions__c,
                B_2_AF_School_Changes__c, C1_1A_1_Reviewing_Process__c, C1_1A_2_Single_Subject_Role__c, C1_1_1a_CP_Articulation__c,
                C1_1_1b_CP_Overview__c, C1_1_1c_CP_Differentiation__c, C1_1_1d_CP_Assessment__c, C1_1_1e_CP_Learner_Profile__c,
                C1_1_CP_DP_Planning_Changes__c, C1_1_DP_CAS_Planning__c, C1_4_1_DP_Desc_Collab__c, C1_5_1_DP_Desc_Collab__c,
                C1_7_1A_Learning_Skills_Dev__c, C1_7_1B_Student_Feedback__c, C1_7_1C_Teaching_Practices__c, C1_7_1D_Meaningful_Reflection__c,
                C1_8_1_DP_Learning_Efforts__c, C2_1D_1_CP_IBCC_School_Components__c, C2_1_1B2_Requirement_Challenges__c,
                C2_1_1B_Programme_Requirements_Locales__c, C2_1_1B_Programme_Requirements__c, C2_1_1B_Requirement_Challenges__c,
                C2_1_1_Other_Mandated_Requirements__c, C2_1_1_Programme_Mandated_Requirements__c, C2_1_2_Actions_Taken_Description__c,
                C2_1_2_Addressed_Requirements__c, C2_1c_1_DP_Chosen_Levels__c, C2_1e_1_CP_IBCC_Learning_Plans__c, C2_1f_1_CP_Desc_Plans__c,
                C2_1f_1_IBCC_Desc_Plans__c, C2_1g_1_Reflective_Plans__c, C2_2_1_CP_IBCC_Curriculum_Plans__c, C2_2_1_DP_Available_Curriculum__c,
                C2_2_1_DP_Curriculum_Plans__c, C2_5_1_DP_CAS_Experiences__c, C2_5_2_DP_Activity_Undertaking__c,
                C2_5_3_DP_CAS_Programme_Advised_Plan__c, C3_1_1_MYP_Implementation_Changes__c, C3_1_1_PYP_Implementation_Changes__c,
                C4_1_1_Assess_Student_Learning__c, C4_1b_1_MYP_Student_Learning_Changes__c, C4_1b_1_PYP_Student_Learning_Changes__c,
                C4_6_1_CP_Report_Process__c, C4_6_1_DP_Assessment_Report__c, C4_6_1_DP_Report_Process__c, C4_6_1_PYP_Student_Achievements__c,
                C4_6_1_MYP_Student_Achievements__c, C4_6_2_CAS_Programme_Report__c, C4_6_3_CAS_Student_Achievements__c, C4_6a_1_Learner_Profile_Description__c,
                C4_7_1_Assessment_Data_Description__c, C4_7_2_Exam_Results_Analysis__c, C4_8_1_DP_Teacher_Efforts__c, CP_C1_9_1_Addressed_Elements__c,
                CP_Current_Asessment__c, CP_years__c, DP_Assessment_Strategy_Tools__c, DP_C3_13_1_Describe_Efforts__c,
                DP_C3_2_1_Desc_Teacher_Efforts__c, DP_CAS_Programme_Report__c, DP_CAS_Student_Achievements__c, DP_CP_C1_9_1A_Int_mindedness__c,
                DP_CP_C1_9_1B_Learner_Incorporation__c, DP_Current_Level__c, DP_Describe_Assessment__c, DP_Diploma_Programme_Planning__c,
                DP_Improvement_Strategies__c, DP_Student_Development_Strategies__c, DP_Subject_Decisions__c, DP_Written_Curriculum__c,
                B1_5d_1_MYP_Honesty_Policy_Process__c, DP_Years__c, Describe_the_school_s_current_assessment__c, Does_the_school_have_WiFi__c,
                GEN_Additional_Stakeholders__c, GEN_Current_Implementation__c, GEN_Questionnaire_Completion__c, GEN_SS_Leadership_Changes__c,
                GEN_SS_School_Changes__c, MYP_4_Arts__c, MYP_4_Design__c, MYP_4_PEH__c, MYP_5_Art__c, MYP_5_Design__c, MYP_5_PEH__c,
                MYP_C1_9_1A_Int_Mindedness__c, MYP_Current_Assess__c, MYP_DP_C1_9_1B_Learner_Incorporation__c, MYP_DP_Curriculum_Review_Process__c,
                MYP_Eval_This_Practice__c, MYP_Indicate_Assess__c, MYP_Planning_Middle_Years__c, MYP_Years__c, PR_B2_5_Learning_Environment__c,
                PYP_Authorization_Questions__c, PYP_C2_4a_1_Scope_Sequence__c, PYP_If_Other__c, PYP_MYP_DP_School_Curriculum__c,
                PYP_MYP_Desc_Collab__c, PYP_MYP_Diverse_Anwsers__c, PYP_Planning_Primary_Years__c, PYP_Years__c,
                REQ_B2_10c_MYP_Promotes_Concurrency__c, REQ_B2_5a_DP_CP_Lab_Environment__c, SD_Proficient_Language__c, SD_AC_CP_Contribution__c,
                SD_AC_DP_Contribution__c, SD_AC_MYP_Contribution__c, SD_AC_PYP_Contribution__c, SD_AF_MYP_Contribution__c, SD_AF_PYP_Contribution__c,
                SD_CP_Academic_Recognition__c, SD_CP_Student_Description__c, SD_Community_Population__c, SD_Community_Setting__c,
                SD_Community_Summary__c, SD_DP_Student_Description__c, SD_Mother_Tongue__c, SD_SS_Parent_Perception__c, SD_SS_Student_Impact__c,
                SD_School_History__c, SD_Staff_Description__c, SD_Staff_Language__c, SD_Student_Description__c, SP_Check_Sig__c, SP_Date__c,
                SP_Executive_Head__c, SP_Executive_Head_Sign_Date__c, SP_EH_Signature__c, SP_Governing_Body__c, SP_Governing_Body_Sign_Date__c,
                SP_GB_Signature__c, SP_Head_of_School__c, SP_School_Superintendent__c, SP_School_Superintendent_Sign_Date__c, SP_SS_Signature__c,
                SP_Signature__c, SS_A1_2_Change_Mission__c, SS_A1_4_Philosophy_Alignment__c, SS_A3_7_DP_Parent_Perceptions__c,
                SS_A3_8_DP_Student_Perceptions__c, SS_Evaluation_Visit_B_1_2__c, Status__c, Teaching_learning_Philosophy__c,
                X9_b_1_DP_Does_Encourage__c, X9_b_1_DP_Will_Encourage__c, Additional_Information_Submitted__c, SD_DP_CP_Higher_Education__c,
                SD_DP_CP_Higher_Education2__c, SD_DP_CP_Further_Education__c, SD_DP_CP_Further_Education2__c, SD_DP_CP_Apprenticeship__c,
                SD_DP_CP_Apprenticeship2__c, SD_DP_CP_Other_Education__c, SD_DP_CP_Other_Education2__c, Application_Lookup_to_Programme__r.Id,
                B_1_5_1DP_CP_Policy_Process__c, B_1_2_2_Educational_Authority__c, B2_5b_DP_CP_IT_Facilities__c, A1_5_school_fac__c, A1_5_com_fin__c,
                A1_5_com_fac__c, A1_5_school_has__c, A1_5_sch_com_effort__c, A1_5_the_sch_com__c, A1_5_sch_com_events__c, A1_5_sch_invites__c,
                B124_CP_recruiting__c, B2_5_1_Chk_a__c, B2_5_1_Chk_b__c, B2_5_1_Chk_c__c, B2_5_1_Chk_d__c, B2_5_1_Chk_e__c, B2_5_1_Chk_f__c,
                B2_5_1_Chk_g__c, B2_5_1_Chk_h__c, B2_5_1_Text_h__c, B2_5_1_Text_b__c, B2_5_1_Text_c__c, B2_5_1_Text_d__c, B2_5_1_Text_f__c,
                B2_6_8_Library_Managed__c, Start_Year__c, Account__c, AFC_Profile_Review_Status__c, AFC_School_Description_Status__c,
                AFC_Programme_Information_Status__c, AFC_Subject_Proposal_Status__c, AFC_Philosophy_Status__c, AFC_Leadership_Structure_Status__c,
                AFC_Resources_Support_Status__c, AFC_Collaborative_Planning_Status__c, AFC_Written_Curriculum_Status__c,
                AFC_Teaching_Learning_Status__c, AFC_Assessment_Status__c, AFC_Implementation_Budget_Status__c, AFC_Documents_Status__c, AFC_Agreement_Status__c,
                AFA_Outline_Status__c, CreatedDate,Account_id__c,RecordType.Name, B2_10_C_1a_Subject_Group__c, B2_12_5_MYP_Community_Project__c,Is_Agreement_Confirmed__c
                
                FROM IB_Application__c
                WHERE Id = :applicationId
            ];
            
            return application;
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
    
    public IB_Application__c getApplicationById(Id applicationId, String appSection) {
        
        try
        {
        system.debug('In getApplicationById(Id, String)');
        system.debug('applicationId ====> '+applicationId);
        system.debug('appSection ====> '+appSection);
        if (appSection == 'sectionb1' || appSection == 'sectionb2') {
            application = [
                SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, A1_2_Mission_Align__c, A1_3_Refinement_Process__c,
                A1_4_Alignment_Extent__c, A1_5_Further_Align__c, A3_4_10_Pedagogical_Outcomes__c, A3_4_11_Teacher_Actions__c,
                A3_4_12_Teacher_Outcomes__c, A3_4_1_Governing_Actions__c, A3_4_2_Governing_Outcomes__c, A3_4_3_Local_Actions__c,
                A3_4_4_Local_Outcomes__c, A3_4_5_Other_Actions__c, A3_4_6_Other_Outcomes__c, A3_4_7_Parents_Actions__c, A3_4_8_Parents_Outcomes__c,
                A3_e_2_PYP_Transdisciplinary_Challenges__c, A3_4_9_Pedagogical_Actions__c, A3_5_Additional_Information__c, A5_1_DP_CAS_Involvement__c,
                A5_1_Indicate_Interactions__c, A7_a_1_PYP_What_languages__c, A7_a_2_PYP_Language_Age__c, A7a_1_SS_New_Languages__c,
                A8_1_OCC_Utilization__c, A9_1_2a_Student_Criteria__c, A9_a_1_PYP_Inclusive_Program__c, A9_a_2_Admission_Requirements__c,
                A9_a_2_CP_Career_Programme__c, A9_a_2_CP_Integrate_Students__c, A9_a_2_CP_Programme_Choice__c, A9_a_2_CP_Promote_Access__c,
                A9_a_2_MYP_Year__c, A9_a_2_MYP_Year_2__c, A9_a_2_MYP_Year_3__c, A9_a_2_MYP_Year_4__c, A9_a_2_MYP_Year_5__c,
                A9_a_3_Admissions_Policy__c, A9_a_3_MYP_Inclusive_Program__c, A9_a_4_Full_Cohort_Explanation__c,
                A1_5_describe_other__c, A9_a_4a_Access_Description__c, AC_A3_2_Additional_Stakeholders_Other__c, A9_a_MYP_5_Year_Explanation__c,
                A9_a_MYP_All_Grades_Start__c, AC_3_1_Feasability_Lead__c, AC_3_1_Feasability_Leads__c, AC_4_1_DP_CP_International_Embodied__c,
                AC_A1_2b_CP_Implementation__c, AC_A1_2c_CP_Community__c, AC_A3_2_Additional_Stakeholders__c, AC_A3_3_Feasibility_Process__c,
                AF_4_2_DP_CP_International_Promoted__c, AF_A1_2_Mission_Change__c, AF_A1_2a_Process_Refinement__c, AF_A1_4_Philosophy_Change__c,
                AF_A1_4a_Who_involved__c, AF_A2_1_DP_Approaches_to_Learning__c, AF_A2_2_DP_School_s_Philosophy__c, AF_Update_Information__c,
                A_1_1_Current_Mission__c, A_9a_2_Enrollment_Policy__c, A_9a_3_Enrollment_Criteria__c, A1_5_Other__c, Additional_Comments__c,
                Application_Lookup_to_Programme__c, Assessment_Philosophy__c, B1_5a_1_DP_Admissions_Policy__c, B1_5a_1_DP_CP_Admission_Changes__c,
                B1_5a_1_Language_Policy__c, B1_5a_1_SS_Language_Policy__c, B1_5a_2_PYP_MYP_Language_Support__c, B1_5b_1_Assessent_Policy__c,
                B1_5b_1_Communicating_Policy__c, B1_5b_2_DP_CP_Language_Provisions__c, B1_5b_3_DP_CP_Language_Policy__c, B1_5b_MYP_Assessment__c,
                B1_5c_1_DP_CP_Support_Requirements__c, B1_5c_1_MYP_Assessment_Process__c, B1_5c_1_PYP_Assessment_Perspective__c,
                B1_5c_1a_Assessment_Process__c, B1_5d_1_DP_Assessment_Policy__c, B1_5e_1_DP_CP_Honesty_Revisions__c, B1_5e_1_DP_Describe_Revisions__c,
                B1_6_1_DP_Structure_Examples__c, /*B2_10_1_DP_CP_Chose_Course__c, */B2_10_1_DP_CP_Current_Num__c, B2_10_1_DP_CP_Estimated_Num__c,
                B2_10_1_DP_CP_Instruction_Language__c, B2_10_1_DP_CP_Subject_Level__c, B2_10_1_DP_CP_Subject_Name__c, B2_10_1_DP_CP_Y1_Hours__c,
                B2_10_1_DP_CP_Y1_Name__c, B2_10_1_DP_CP_Y2_Hours__c, B2_10_1_DP_CP_Y2_Name__c, B2_10_1a_Cp_IBCC_Choose_Course__c,
                B2_10_1a_DP_CP_Subject_Changes__c, B2_10_2_DP_CAS_Interviews__c, B2_10_2_Standard_Level__c, B2_10_3_Display_Standard__c,
                B2_10_4_CP_Programme_Choices__c, B2_10_c_1b_Name_of_Subject__c, B2_10a_2_Schedule_Adjustments__c, B2_10a_2_Schedule_Change__c,
                B2_10c_2_CP_IBCC_School_Adjustments__c, B2_10c_2_DP_CP_Schedule_Adjustments__c, /*B2_10c_2_DP_School_Adjustments__c, */
                B2_10c_2_MYP_Min_Req__c, B2_10c_2_MYP_Sched_Adj__c, B2_10c_2_MYP_Y_Subject_Taught__c, B2_10c_2_MYP_Year_Hours__c,
                B2_10c_2a_DP_CP_IBCC_Changes_Made__c, B2_10c_2a_DP_CP_IBCC_Explain__c, B2_10c_2a_MYP_Instruct_Lang__c, B2_10c_3_MYP_Min_Teach__c,
                B2_10c_3_MYP_Sched_Adj__c, B2_10c_4_MYP_Sched_Adj__c, B2_10c_4_MYP_Teach_Hours__c, B2_10c_5_MYP_Lang_Sustained__c,
                B2_10c_5_MYP_Sched_Adj__c, B2_10c_6_DP_Time_Arrange__c, B2_10c_6_MYP_No_Visual_Art__c, B2_10c_6_MYP_Visual_Art__c,
                B2_10c_7_DP_Y1_End__c, B2_10c_7_DP_Y1_Start__c, B2_10c_7_DP_Y2_End__c, B2_10c_7_DP_Y2_Start__c, B2_10c_7_MYP_Describe_Sched__c,
                B2_10c_7_MYP_PE_50__c, B2_12_1_CP_IBCC_Support_Plan__c, B2_12_1_DP_Extended_Essay__c, B2_12_2_MYP_Community_Project__c,
                B2_12_3_MYP_Community_project__c, B2_12_4_MYP_Community_project__c, B2_1_12_1_MYP_Personal_Project_Process__c, B2_1a_1_DP_CAS_Time__c,
                B2_1a_1a_Service_Learning_Time__c, B2_2_2_Staff_Standards__c, B2_2_3_Full_Time__c, B2_2_3_PYP_Single_Subject__c,
                B2_2_4_DP_CAS_Advisor__c, B2_2_4_DP_CAS_Consistency__c, B2_2_4_DP_CAS_Guidance__c, B2_2_4_DP_CAS_Identify__c,
                B2_2_4_DP_CAS_Student_Supervision__c, B2_2_4_DP_CAS_Students__c, B2_2_4_Part_Time__c, B2_3a_2_Staff_Training__c,
                B2_4_1_Collaborative_Planning__c, B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c,
                B2_4_2_Meeting_Objectives__c, B2_5_1_Facilities_Changes__c, B2_5_1_Technology_Approach__c, B2_5_2_DP_CP_Community_Resources__c,
                B2_5_2_Internet_Access__c, B2_5_3_CP_IT_Support__c, B2_5_3_CP_Services_Learning__c, B2_5_4_CP_Skilss_Development__c,
                B2_5_4_Classroom_Computers__c, B2_5_4_Internet_Restrictions__c, B2_5_5_CP_IT_Provisions__c, B2_5_5_Facility_Description__c,
                B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c, B2_5_5_PYP_Facilities_Components__c, B2_5c_1_DP_CP_Exam_Location__c,
                B2_5c_1_Exam_Storage__c, B2_6_1_CP_Library_Resources__c, B2_6_1_Independent_Access__c, B2_6_2_Browse_Borrow__c,
                B2_6_4_Study_Spaces__c, B2_6_5_Age_Group__c, B2_6_5a_Who_Else__c, B2_6_6_CP_Resources__c, B2_6_7_Whole_Class__c,
                B2_6_8_Class_Library__c, B2_6_9_Adequate_Resources__c, B2_6_9_Library_Description__c, B2_6a_1_DP_Adequate_Resources__c,
                B2_6a_2_DP_Adequate_Resources__c, B2_9_1_DP_Student_Guidance__c, B2_9_1_DP_Student_Induction__c, B2_9_1_MYP_Student_Guidance__c,
                B2_9a_1_CP_Guidance__c, B2_9a_1_DP_Guidance__c, B2_9a_1_DP_SS_Guidance__c, B_1_1_1_AF_Explain_informed__c,
                B_1_1_1_SS_Describe_Informed__c, B_1_2_1_Educational_Authority__c, B_1_2_1_Other_Description__c, B_1_2_2a_Authority_Formed__c,
                B_1_2_2a_Explain_Authority__c, B_1_2_3_Pedagogical_Leadership__c, B_1_2_3_SS_Programme_Implementation__c,
                B_1_2_3a_AF_Pedagogical_Changes__c, B_1_2_3b_AF_New_Members__c, B_1_2_4_CP_Staff_Recruiting__c, B_1_2_4_Staff_Recruiting__c,
                B_1_2_5_Recruiting_Challenges__c, B_1_2_5_SS_Pedagogical_Changes__c, B_1_2_5a_SS_Explain_Changes__c,
                B_1_2_6_SS_Pedagogical_Leadership__c, B_1_3_1_Common_Language__c, B_1_3_1_Coordinator_Proficient__c, B_1_3_2_Different_Language__c,
                B_1_3_2ba_MYP_SS_Language_Proficiency__c, B_1_4_1_Weekly_Schedule__c, B_1_4_2a_Duty_Chart__c, B_1_4_2b_Time_Chart__c,
                B_1_5_1_DP_CP_AF_Verification_Visit__c, B_1_5_1_DP_CP_SS_Verification_Visit__c, B_1_5a_3_PYP_MYP_Language_Provisions__c,
                B_2_AF_School_Changes__c, C1_1A_1_Reviewing_Process__c, C1_1A_2_Single_Subject_Role__c, C1_1_1a_CP_Articulation__c,
                C1_1_1b_CP_Overview__c, C1_1_1c_CP_Differentiation__c, C1_1_1d_CP_Assessment__c, C1_1_1e_CP_Learner_Profile__c,
                C1_1_CP_DP_Planning_Changes__c, C1_1_DP_CAS_Planning__c, C1_4_1_DP_Desc_Collab__c, C1_5_1_DP_Desc_Collab__c,
                C1_7_1A_Learning_Skills_Dev__c, C1_7_1B_Student_Feedback__c, C1_7_1C_Teaching_Practices__c, C1_7_1D_Meaningful_Reflection__c,
                C1_8_1_DP_Learning_Efforts__c, C2_1D_1_CP_IBCC_School_Components__c, C2_1_1B2_Requirement_Challenges__c,
                C2_1_1B_Programme_Requirements_Locales__c, C2_1_1B_Programme_Requirements__c, C2_1_1B_Requirement_Challenges__c,
                C2_1_1_Other_Mandated_Requirements__c, C2_1_1_Programme_Mandated_Requirements__c, C2_1_2_Actions_Taken_Description__c,
                C2_1_2_Addressed_Requirements__c, C2_1c_1_DP_Chosen_Levels__c, C2_1e_1_CP_IBCC_Learning_Plans__c, C2_1f_1_CP_Desc_Plans__c,
                C2_1f_1_IBCC_Desc_Plans__c, C2_1g_1_Reflective_Plans__c, C2_2_1_CP_IBCC_Curriculum_Plans__c, C2_2_1_DP_Available_Curriculum__c,
                C2_2_1_DP_Curriculum_Plans__c, C2_5_1_DP_CAS_Experiences__c, C2_5_2_DP_Activity_Undertaking__c,
                C2_5_3_DP_CAS_Programme_Advised_Plan__c, C3_1_1_MYP_Implementation_Changes__c, C3_1_1_PYP_Implementation_Changes__c,
                C4_1_1_Assess_Student_Learning__c, C4_1b_1_MYP_Student_Learning_Changes__c, C4_1b_1_PYP_Student_Learning_Changes__c,
                C4_6_1_CP_Report_Process__c, C4_6_1_DP_Assessment_Report__c, C4_6_1_DP_Report_Process__c, C4_6_1_PYP_Student_Achievements__c,
                C4_6_1_MYP_Student_Achievements__c, C4_6_2_CAS_Programme_Report__c, C4_6_3_CAS_Student_Achievements__c, C4_6a_1_Learner_Profile_Description__c,
                C4_7_1_Assessment_Data_Description__c, C4_7_2_Exam_Results_Analysis__c, C4_8_1_DP_Teacher_Efforts__c, CP_C1_9_1_Addressed_Elements__c,
                CP_Current_Asessment__c, CP_years__c, DP_Assessment_Strategy_Tools__c, DP_C3_13_1_Describe_Efforts__c,
                DP_C3_2_1_Desc_Teacher_Efforts__c, DP_CAS_Programme_Report__c, DP_CAS_Student_Achievements__c, DP_CP_C1_9_1A_Int_mindedness__c,
                DP_CP_C1_9_1B_Learner_Incorporation__c, DP_Current_Level__c, DP_Describe_Assessment__c, DP_Diploma_Programme_Planning__c,
                DP_Improvement_Strategies__c, DP_Student_Development_Strategies__c, DP_Subject_Decisions__c, DP_Written_Curriculum__c,
                B1_5d_1_MYP_Honesty_Policy_Process__c, DP_Years__c, Describe_the_school_s_current_assessment__c, Does_the_school_have_WiFi__c,
                GEN_Additional_Stakeholders__c, GEN_Current_Implementation__c, GEN_Questionnaire_Completion__c, GEN_SS_Leadership_Changes__c,
                GEN_SS_School_Changes__c, MYP_4_Arts__c, MYP_4_Design__c, MYP_4_PEH__c, MYP_5_Art__c, MYP_5_Design__c, MYP_5_PEH__c,
                MYP_C1_9_1A_Int_Mindedness__c, MYP_Current_Assess__c, MYP_DP_C1_9_1B_Learner_Incorporation__c, MYP_DP_Curriculum_Review_Process__c,
                MYP_Eval_This_Practice__c, MYP_Indicate_Assess__c, MYP_Planning_Middle_Years__c, MYP_Years__c, PR_B2_5_Learning_Environment__c,
                PYP_Authorization_Questions__c, PYP_C2_4a_1_Scope_Sequence__c, PYP_If_Other__c, PYP_MYP_DP_School_Curriculum__c,
                PYP_MYP_Desc_Collab__c, PYP_MYP_Diverse_Anwsers__c, PYP_Planning_Primary_Years__c, PYP_Years__c,
                REQ_B2_10c_MYP_Promotes_Concurrency__c, REQ_B2_5a_DP_CP_Lab_Environment__c, SD_Proficient_Language__c, SD_AC_CP_Contribution__c,
                SD_AC_DP_Contribution__c, SD_AC_MYP_Contribution__c, SD_AC_PYP_Contribution__c, SD_AF_MYP_Contribution__c, SD_AF_PYP_Contribution__c,
                SD_CP_Academic_Recognition__c, SD_CP_Student_Description__c, SD_Community_Population__c, SD_Community_Setting__c,
                SD_Community_Summary__c, SD_DP_Student_Description__c, SD_Mother_Tongue__c, SD_SS_Parent_Perception__c, SD_SS_Student_Impact__c,
                SD_School_History__c, SD_Staff_Description__c, SD_Staff_Language__c, SD_Student_Description__c, SP_Check_Sig__c, SP_Date__c,
                SP_Executive_Head__c, SP_Executive_Head_Sign_Date__c, SP_EH_Signature__c, SP_Governing_Body__c, SP_Governing_Body_Sign_Date__c,
                SP_GB_Signature__c, SP_Head_of_School__c, SP_School_Superintendent__c, SP_School_Superintendent_Sign_Date__c, SP_SS_Signature__c,
                SP_Signature__c, SS_A1_2_Change_Mission__c, SS_A1_4_Philosophy_Alignment__c, SS_A3_7_DP_Parent_Perceptions__c,
                SS_A3_8_DP_Student_Perceptions__c, SS_Evaluation_Visit_B_1_2__c, Status__c, Teaching_learning_Philosophy__c,
                X9_b_1_DP_Does_Encourage__c, X9_b_1_DP_Will_Encourage__c, Additional_Information_Submitted__c, SD_DP_CP_Higher_Education__c,
                SD_DP_CP_Higher_Education2__c, SD_DP_CP_Further_Education__c, SD_DP_CP_Further_Education2__c, SD_DP_CP_Apprenticeship__c,
                SD_DP_CP_Apprenticeship2__c, SD_DP_CP_Other_Education__c, SD_DP_CP_Other_Education2__c, Application_Lookup_to_Programme__r.Id,
                B_1_5_1DP_CP_Policy_Process__c, B_1_2_2_Educational_Authority__c, B2_5b_DP_CP_IT_Facilities__c, A1_5_school_fac__c, A1_5_com_fin__c,
                A1_5_com_fac__c, A1_5_school_has__c, A1_5_sch_com_effort__c, A1_5_the_sch_com__c, A1_5_sch_com_events__c, A1_5_sch_invites__c,
                B124_CP_recruiting__c, B2_5_1_Chk_a__c, B2_5_1_Chk_b__c, B2_5_1_Chk_c__c, B2_5_1_Chk_d__c, B2_5_1_Chk_e__c, B2_5_1_Chk_f__c,
                B2_5_1_Chk_g__c, B2_5_1_Chk_h__c, B2_5_1_Text_h__c, B2_5_1_Text_b__c, B2_5_1_Text_c__c, B2_5_1_Text_d__c, B2_5_1_Text_f__c,
                B2_6_8_Library_Managed__c, Start_Year__c, Account__c, AFC_Profile_Review_Status__c, AFC_School_Description_Status__c,
                AFC_Programme_Information_Status__c, AFC_Subject_Proposal_Status__c, AFC_Philosophy_Status__c, AFC_Leadership_Structure_Status__c,
                AFC_Resources_Support_Status__c, AFC_Collaborative_Planning_Status__c, AFC_Written_Curriculum_Status__c,
                AFC_Teaching_Learning_Status__c, AFC_Assessment_Status__c, AFC_Implementation_Budget_Status__c, AFC_Documents_Status__c, AFC_Agreement_Status__c,
                AFA_Outline_Status__c, Account_id__c, RecordType.Name, B2_10_C_1a_Subject_Group__c,B2_12_5_MYP_Community_Project__c
                FROM IB_Application__c
                WHERE Id = :applicationId
            ];
        }
        
        return application;
        }
        catch(exception x)
        {
            System.debug('excp'+x);
            return NULL;
            
        }
        
    }
    
    public List<IB_Application__c> getApplicationsByProgrammeId(Id programmedId) {
        
        applications = [
            SELECT Id, Name, RecordTypeId, RecordType.Name, Application_Lookup_to_Programme__c, CreatedDate
            FROM IB_Application__c
            WHERE Application_Lookup_to_Programme__c = :programmedId
        ];
        
        return applications;
    }
    
    public List<IB_Application__c> getAllFieldsApplicationsByProgrammeId(Id programmedId) {
        DescribeSObjectResult describeResult = IB_Application__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ', Owner.isActive FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE Application_Lookup_to_Programme__c = :programmedId';
        applications = Database.query(qryString);
        
        return applications;
    }
    
    public List<IB_Application__c> getApplicationsByProgrammeIdList(List<Id> idList) {
        
        applications = [
            SELECT  Id, Name, RecordTypeId, RecordType.Name, Application_Lookup_to_Programme__c, CreatedDate,
            AFA_Available_to_School__c, Application_Lookup_to_Programme__r.RecordType.Name, Status__c
            FROM IB_Application__c
            WHERE Application_Lookup_to_Programme__c IN :idList
        ];
        
        return applications;
    }
    public IB_Application__c getAfcByProgrammeId(Id pId)
    {
        IB_Application__c afc;
        List<IB_Application__c> appList = new List<IB_Application__c>([SELECT Id,C3_1_1_PYP_Implementation_Changes__c,C3_1_1_MYP_Implementation_Changes__c,A1_2_Mission_Align__c ,
                                                                       A1_3_Refinement_Process__c ,
                                                                       A1_4_Alignment_Extent__c ,
                                                                       A1_5_Further_Align__c ,
                                                                       A1_5_describe_other__c,
                                                                       A3_4_10_Pedagogical_Outcomes__c ,
                                                                       A3_4_11_Teacher_Actions__c ,
                                                                       A3_4_12_Teacher_Outcomes__c ,
                                                                       A3_4_1_Governing_Actions__c ,
                                                                       A3_4_2_Governing_Outcomes__c ,
                                                                       A3_4_3_Local_Actions__c ,
                                                                       A3_4_4_Local_Outcomes__c ,
                                                                       A3_4_5_Other_Actions__c ,
                                                                       A3_4_6_Other_Outcomes__c ,
                                                                       A3_4_7_Parents_Actions__c ,
                                                                       A3_4_8_Parents_Outcomes__c ,
                                                                       A3_4_9_Pedagogical_Actions__c ,
                                                                       A3_5_Additional_Information__c ,
                                                                       A3_e_2_PYP_Transdisciplinary_Challenges__c ,
                                                                       A7_a_1_PYP_What_languages__c ,
                                                                       A7_a_2_PYP_Language_Age__c ,
                                                                       A8_1_OCC_Utilization__c ,
                                                                       A9_a_2_Admission_Requirements__c ,
                                                                       A9_a_2_CP_Promote_Access__c ,
                                                                       A9_a_2_MYP_Year_2__c ,
                                                                       A9_a_2_MYP_Year_3__c ,
                                                                       A9_a_2_MYP_Year_4__c ,
                                                                       A9_a_2_MYP_Year_5__c ,
                                                                       A9_a_2_MYP_Year__c   ,
                                                                       A9_a_3_Admissions_Policy__c ,
                                                                       A9_a_3_MYP_Inclusive_Program__c   ,
                                                                       A9_a_4_Full_Cohort_Explanation__c ,
                                                                       A9_a_MYP_5_Year_Explanation__c ,
                                                                       A9_a_MYP_All_Grades_Start__c ,
                                                                       AC_4_1_DP_CP_International_Embodied__c ,
                                                                       AC_A1_2b_CP_Implementation__c ,
                                                                       AC_A1_2c_CP_Community__c ,
                                                                       AC_A3_2_Additional_Stakeholders_Other__c ,
                                                                       AC_A3_2_Additional_Stakeholders__c ,
                                                                       AC_A3_3_Feasibility_Process__c ,
                                                                       AF_A1_2_Mission_Change__c  ,
                                                                       AF_A1_4_Philosophy_Change__c ,
                                                                       AF_A2_1_DP_Approaches_to_Learning__c ,
                                                                       AF_A2_2_DP_School_s_Philosophy__c ,
                                                                       A_1_1_Current_Mission__c ,
                                                                       //Current_Assessment_12__c ,
                                                                       X9_b_1_DP_Will_Encourage__c ,
                                                                       B124_CP_recruiting__c,
                                                                       B1_5a_1_DP_CP_Admission_Changes__c,
                                                                       B1_5a_1_Language_Policy__c,
                                                                       B1_5a_2_PYP_MYP_Language_Support__c,
                                                                       B1_5b_1_Assessent_Policy__c,
                                                                       B1_5b_2_DP_CP_Language_Provisions__c,
                                                                       B1_5b_3_DP_CP_Language_Policy__c,
                                                                       B1_5b_MYP_Assessment__c,
                                                                       B1_5c_1_DP_CP_Support_Requirements__c,
                                                                       B1_5c_1_MYP_Assessment_Process__c,
                                                                       B1_5c_1_PYP_Assessment_Perspective__c,
                                                                       B1_5d_1_DP_Assessment_Policy__c,
                                                                       B1_5d_1_MYP_Honesty_Policy_Process__c,
                                                                       B1_5e_1_DP_CP_Honesty_Revisions__c,
                                                                       B1_6_1_DP_Structure_Examples__c,
                                                                       B_1_1_1_AF_Explain_informed__c,
                                                                       B_1_2_1_Educational_Authority__c,
                                                                       B_1_2_1_Other_Description__c,
                                                                       B_1_2_2_Educational_Authority__c,
                                                                       B_1_2_2a_Authority_Formed__c,
                                                                       B_1_2_2a_Explain_Authority__c,
                                                                       B_1_2_3_Pedagogical_Leadership__c,
                                                                       B_1_2_3a_AF_Pedagogical_Changes__c,
                                                                       B_1_2_3b_AF_New_Members__c,
                                                                       B_1_2_4_Staff_Recruiting__c,
                                                                       B_1_2_5_Recruiting_Challenges__c,
                                                                       B_1_3_1_Common_Language__c,
                                                                       B_1_3_2_Different_Language__c,
                                                                       B_1_4_1_Weekly_Schedule__c,
                                                                       B_1_5_1DP_CP_Policy_Process__c,
                                                                       B_1_5a_3_PYP_MYP_Language_Provisions__c,
                                                                       B_2_AF_School_Changes__c,
                                                                       B2_10_1a_Cp_IBCC_Choose_Course__c,
                                                                       B2_10_2_Standard_Level__c,
                                                                       B2_10_3_Display_Standard__c,
                                                                       B2_10_4_CP_Programme_Choices__c,
                                                                       B2_10a_2_Schedule_Adjustments__c,
                                                                       B2_10c_2_CP_IBCC_School_Adjustments__c,
                                                                       B2_10c_2_DP_CP_Schedule_Adjustments__c,
                                                                       B2_10c_2_MYP_Min_Req__c,
                                                                       B2_10c_2_MYP_Sched_Adj__c,
                                                                       B2_10c_2a_MYP_Instruct_Lang__c,
                                                                       B2_10c_3_MYP_Min_Teach__c,
                                                                       B2_10c_4_MYP_Sched_Adj__c,
                                                                       B2_10c_4_MYP_Teach_Hours__c,
                                                                       B2_10c_5_MYP_Lang_Sustained__c,
                                                                       B2_10c_5_MYP_Sched_Adj__c,
                                                                       B2_10c_6_MYP_No_Visual_Art__c,
                                                                       B2_10c_7_MYP_Describe_Sched__c,
                                                                       B2_10c_7_MYP_PE_50__c,
                                                                       B2_12_1_CP_IBCC_Support_Plan__c,
                                                                       B2_12_1_DP_Extended_Essay__c,
                                                                       B2_12_2_MYP_Community_Project__c,
                                                                       B2_12_3_MYP_Community_project__c,
                                                                       B2_12_4_MYP_Community_project__c,
                                                                       B2_12_5_MYP_Community_Project__c,
                                                                       B2_1_12_1_MYP_Personal_Project_Process__c,
                                                                       B2_1a_1_DP_CAS_Time__c,
                                                                       B2_1a_1a_Service_Learning_Time__c,
                                                                       B2_2_2_Staff_Standards__c,
                                                                       B2_3a_2_Staff_Training__c,
                                                                       B2_4_1_Collaborative_Planning__c,
                                                                       B2_5_1_Technology_Approach__c,
                                                                       B2_5_1_Text_b__c,
                                                                       B2_5_1_Text_c__c,
                                                                       B2_5_1_Text_d__c,
                                                                       B2_5_1_Text_f__c,
                                                                       B2_5_1_Text_h__c,
                                                                       B2_5_2_DP_CP_Community_Resources__c,
                                                                       B2_5_2_Internet_Access__c,
                                                                       B2_5_3_CP_Services_Learning__c,
                                                                       B2_5_4_CP_Skilss_Development__c,
                                                                       B2_5_4_Classroom_Computers__c,
                                                                       B2_5_4_Internet_Restrictions__c,
                                                                       B2_5b_DP_CP_IT_Facilities__c,
                                                                       B2_5c_1_DP_CP_Exam_Location__c,
                                                                       B2_6_1_CP_Library_Resources__c,
                                                                       B2_6_1_Independent_Access__c,
                                                                       B2_6_2_Browse_Borrow__c,
                                                                       B2_6_4_Study_Spaces__c,
                                                                       B2_6_5_Age_Group__c,
                                                                       B2_6_5a_Who_Else__c,
                                                                       B2_6_7_Whole_Class__c,
                                                                       B2_6_8_Class_Library__c,
                                                                       B2_6_8_Library_Managed__c,
                                                                       B2_6_9_Library_Description__c,
                                                                       B2_6a_2_DP_Adequate_Resources__c,
                                                                       B2_9a_1_CP_Guidance__c,
                                                                       B2_9a_1_DP_Guidance__c,
                                                                       Does_the_school_have_WiFi__c,
                                                                       GEN_Current_Implementation__c,
                                                                       C1_1_1a_CP_Articulation__c,
                                                                       C1_1_1b_CP_Overview__c,
                                                                       C1_1_1c_CP_Differentiation__c,
                                                                       C1_1_1d_CP_Assessment__c,
                                                                       C1_1_1e_CP_Learner_Profile__c,
                                                                       C1_1_CP_DP_Planning_Changes__c,
                                                                       C1_4_1_DP_Desc_Collab__c,
                                                                       C1_5_1_DP_Desc_Collab__c,
                                                                       C1_7_1A_Learning_Skills_Dev__c,
                                                                       C1_7_1B_Student_Feedback__c,
                                                                       C1_7_1D_Meaningful_Reflection__c,
                                                                       C1_8_1_DP_Learning_Efforts__c,
                                                                       DP_CP_C1_9_1A_Int_mindedness__c,
                                                                       MYP_DP_C1_9_1B_Learner_Incorporation__c,
                                                                       C2_1c_1_DP_Chosen_Levels__c,
                                                                       Additional_Comments__c,
                                                                       C2_1D_1_CP_IBCC_School_Components__c,
                                                                       C2_1_1B_Requirement_Challenges__c,
                                                                       C2_1_1_Other_Mandated_Requirements__c,
                                                                       C2_1e_1_CP_IBCC_Learning_Plans__c,
                                                                       C2_1f_1_CP_Desc_Plans__c,
                                                                       C2_1g_1_Reflective_Plans__c,
                                                                       C2_2_1_DP_Curriculum_Plans__c,
                                                                       PYP_C2_4a_1_Scope_Sequence__c,        
                                                                       C4_1_1_Assess_Student_Learning__c,
                                                                       C4_1b_1_MYP_Student_Learning_Changes__c,
                                                                       C4_1b_1_PYP_Student_Learning_Changes__c,
                                                                       C4_6_1_DP_Assessment_Report__c,
                                                                       C4_6_1_MYP_Student_Achievements__c,
                                                                       C4_6_1_PYP_Student_Achievements__c,
                                                                       C4_6a_1_Learner_Profile_Description__c,
                                                                       C4_8_1_DP_Teacher_Efforts__c
                                                                       FROM IB_Application__c WHERE RecordType.DeveloperName='Application_for_Candidacy' AND Application_Lookup_to_Programme__c=:pId]);
        if(!appList.isEmpty() && appList.size()==1)
            afc = appList.get(0);
        return afc;
    }
}