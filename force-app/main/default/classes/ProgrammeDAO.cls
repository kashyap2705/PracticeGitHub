public without Sharing class ProgrammeDAO {

    private static final ProgrammeDAO instance = new ProgrammeDAO();
    private IB_Programme__c programme;
    private List<IB_Programme__c> programmes;

    private ProgrammeDAO() {}

    
    public static ProgrammeDAO getInstance() {
        return instance;
    }

    // Added Programme_Decision_Owner__r.Name, Programme_Decision_Owner__r.Email ,Owner__r.name,Owner__r.email,Account__r.owner.name,Account__r.owner.email by Kashyap for ECM00692
    public List<IB_Programme__c> getProgrammesByAccountId(Id accountId) {
 			//, Added Agreement_Type__c by kashyap ECM00635
          programmes = [
            SELECT Id, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, RecordType.Name, RecordType.DeveloperName,
                Account__c, Programme_Selection__c, Programme_Coordinator_Name__c, Programme_Coordinator_Email__c, Account_IBIS_Code__c, Action_Plan__c, Exam_Address__c, Exam_Session__c, IBCC_Exam_Session__c, IBCC_Implementation_Phase__c, IB_Event__c, Programme_Legal_Name__c, StageName__c, Status__c, Sub_Stage__c, Type__c,
                Date_Decision_on_Authorization__c, Postal_Address__c, Street_Address__c, Billing_Address__c, Projected_Authorization_date__c, Projected_AFA_Submission_Date__c, Owner__c, Programme_Relationship_Manager_Name__c, Programme_Relationship_Manager_Email__c,
                Programme_Decision_Owner__r.Name, Programme_Decision_Owner__r.Email ,Owner__r.name,Owner__r.email,Account__r.owner.name,Account__r.owner.email , Agreement_Type__c 
            FROM IB_Programme__c
            WHERE Account__c = :accountId
        ];

        return programmes;

    }

    public IB_Programme__c getProgrammeById(Id programmeId) {

      
        
        programme = [
               SELECT Id ,IsDeleted, Name, CurrencyIsoCode, RecordTypeId,
                Account__c, Account__r.Name, Account_IBIS_Code__c, Account_Region__c, Account_Sub_Region__c, Action_Plan__c, Additional_Address_1__c, Additional_Address_2__c, Additional_Address_3__c, Additional_Address_4__c,
                Additional_Exam_Session__c, Additional_information_received__c, Application_Authorization_received__c, Application_for_Authorization_Deadline__c, Application_for_Candidacy_Deadline__c,
                Application_for_candidacy_received__c, Assessment_validation_del__c, Auth_Certificate_Dispatched__c, Billing_Address_Text__c, Billing_Address__c, Boarding_Facilities__c, Candidacy_Application_Deadline__c,
                Candidacy_Documents__c, Candidacy_Termination_Date__c, Candidacy_allocated_consultant__c, Candidacy_pending__c, Candidate_schools_in_Old_Auth_Process__c, Candidate_status_start__c,
                Career_related_studies_at_the_school_are__c, Career_related_studies_will_be_provided__c, Close_Date__c, Consultant_approved__c, Consultation_visit_report_received__c, Copy_Date_Decision_on_Authorization__c,

                Date_Decision_on_Authorization__c, Date_Decision_on_Candidacy__c, Days_Authorization_To_Start__c, Days_Candidate_To_Authorization__c, Days_SIF_To_Candidate__c, Deadline_to_submit_further_information__c,
                Decision_on_Authorization__c, Decision_on_Candidacy__c, Description__c, Disregard_Discrepency__c, Disregard_Status_Changed_is__c, End_process__c, Evaluation_outcome__c, Exam_Address__c, Exam_Session__c,
                Expected_Revenue__c, Expression_of_Interest__c, Fast_Track_Application__c, Feed_back_form_received__c, Final_Date_Copy__c, Finance_validation__c, Forecast_Category__c, IBCC_Comments__c, IBCC_Exam_Session__c,
                IBCC_Implementation_Phase__c, IB_Event__c, IB_Forms_ID__c,
                IB_Student_Government_Subsidy__c, IB_Student_Tuiton_Fee__c, Language_of_instruction__c,
                Last_Evaluation_Date__c, Last_Modified_By_Region_Department__c, LeadSource__c, Lead_programme__c, Legal_Status__c, MYP_Exam_Session__c,
                MYP_Year_1__c, MYP_Year_2__c, MYP_Year_3__c, MYP_Year_4__c, MYP_Year_5__c, Main_Address_City__c, Main_Address_Country__c, Main_Address_Lines__c, Main_Address_Postal_Code__c, Main_Address_Province__c, Main_Session__c,
                Master_Programme__c, Motive_for_Rejection__c, Network_name__c, Next_Evaluation_Date__c, Next_Step__c, Notes_from_Development__c, Number_of_Students__c, OCC_Code_Candidate__c, OCC_Code__c,

                Opportunity_ids__c, Original_Lead_Description__c, Owner_Region_Department__c, Owner__c, Partner_Account__c, Partner_Start_Date__c, Partnership_End_Date__c, Partnership_Name__c,
                Pilot_school__c, Please_list_the_career_related_studies__c, Postal_Address_Text__c, Postal_Address__c, Previous_Status__c, Price_Book__c, Primary_Campaign_Source__c, Primary_Language_of_Instruction__c,
                Programme_Decision_Owner__c, Programme_Legal_Name__c, Programme_Remarks__c, Programme_Start_Date__c, Programme_Status_Number_Conversion__c, Programme_Validation__c, Programmechoice__c, Progress_Report_Content__c,

                Secondary_Language_of_Instruction__c,
                StageName__c, Status__c, Stop_Workflow__c, Street_Address_Text__c, Street_Address__c,
                Student_Gender__c, Sub_Stage__c, Type__c, Type_of_network__c, Verification_visit__c, Visit_status__c, Withdrawal_Date__c, contract__c, PR_sent_to_Consultant__c, PR_5_Languages__c, PR_7d_Indicate_Coordinator__c,
                PR_7b_Indicate_Person__c, PR_7_MYP_Multiple_Campuses__c, PR_7_CP_Multiple_Campuses__c, PR_2_MYP_School_Lookup__c, PR_2_DP_Estimated_Candidates_2__c, PR_2_DP_Candidates_Completing__c, PR_2_DP_Full_Candidates_2__c,
                PR_2_Dp_Candidates_Starting__c, PR_2_CP_Candidates_Starting__c, PR_2_Dp_Non_DP_Students_2__c, PR_2_DP_Non_Dp_Starting__c, PR_2_DP_Non_DP_Students__c, PR_2_CP_Non_CP_Students_2__c, PR_2_CP_Non_CP_Candidates_Completeing__c,
                PR_6_Campus_Lookup__c, PR_2_DP_CP_Total_Students_2__c, PR_14_Exam_Session__c, PR_2_DP_CP_Total_Students__c, PR_2_MYP_Year_One__c, PR_2_MYP_Year_Two__c, PR_2_MYP_Year_Three__c, PR_2_MYP_Year_Four__c, PR_2_MYP_Year_Five__c,
                PR_2_MYP_Student_Total__c, PR_13_CP_Maximum_size__c, PR_5_Third_Language__c, PR_5_Fourth_Language__c, PR_7a_Single_School__c, PR_7d_Programme_Coordinator__c, PR_7e_Programme_Articulation__c, PR_7f_Collaberative_Planning__c,
                RecordType.Name, PR_8_Additional_tuition__c, PR_16_CP_Studies_List__c, PR_16_CP_Provider_Dropdown__c, PR_16_CP_Provider_Name__c, PR_17_CP_Students_Assessed__c, PR_18_CP_Assessment_Plan__c,PR_7b_One_Person__c,
                PR_20_CP_Criteria_Role__c, PR_20a_CP_Delivery__c, PR_20b_Accreditation__c, PR_20c_Quality_Assurance__c, PR_21_Curricular_Links__c, PR_5_First_Language__c, PR_5_Second_Language__c, PR_7_Multiple_Campuses__c,
                PR_2_PYP_Student_Age__c, PR_2_PYP_Number_of_Grades__c, PR_2_PYP_MYP_Section__c, PR_2_PYP_Number_of_Classes__c, PR_2_PYP_Total_Students_Year__c, PR_2_PYP_Total_Students__c, PR_3_Student_Gender__c, PR_4_Boarding_Facilities__c,
                PR_7c_Campus_Governance__c, PR_11_Tax_Code__c, PR_10_Billing_Organization__c, PR_9_Government_Subsidy__c, PR_12_budget_Line__c, PR_12_Currency_Used__c, PR_13_PYP_Maximum_Size__c, PR_13_MYP_Maximum_Size__c,
                PR_2_MYP_Grade_Year_From__c, PR_2_MYP_Grade_Year_To__c, PR_2_MYP_Age_From__c, PR_2_MYP_Age_To__c, PR_2_MYP_Student_Total_Year__c, PR_2_CP_Estimated_Candidates__c, PR_2_DP_Non_DP_Candidates_Completing__c,
                PR_2_DP_Estimated_Candidates__c, PR_2_DP_Full_Candidates__c, PR_13_DP_Maxmium_Size__c, PR_2_CP_Non_CP_Students__c, PR_2_CP_Estimated_Completions__c, PR_2_MYP_Year__c, Projected_Authorization_date__c, Projected_AFA_Submission_Date__c,
                PR_2_CP_Non_IB_Students_Starting__c, PR_2_CP_Non_IB_Students_Starting_2__c, PR_2_CP_Non_IB_Students_Finishing__c, PR_2_CP_Non_IB_Students_Finishing_2__c
            FROM IB_Programme__c
               WHERE Id = :programmeId
          ];

      
        return programme;

    }

}