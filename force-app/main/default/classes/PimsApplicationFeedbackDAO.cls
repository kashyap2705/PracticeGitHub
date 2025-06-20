public class PimsApplicationFeedbackDAO {
    

    private IB_Application_Feedback__c pimsApplicationFeedback;
    private List<IB_Application_Feedback__c> pimsApplicationFeedbackList;

		public IB_Address__c applicationFeedbackAddress;
	public List<IB_Address__c> applicationFeedbackAddressList;

    public List<IB_Application_Feedback__c> getPimsApplicationFeedbackByApplicationId (Id appId) {

        pimsApplicationFeedbackList = [
            SELECT FB_LD_Requirement_1__c, FB_PC_Comment_1__c, FB_PC_Requirement_Met_1__c, FB_SP_Requirement_Met_1__c, FB_AP_Comment_1__c, FB_Application_ID__c, 
                FB_AP_Requirement_Met_1__c, FB_BD_Comment_1__c, FB_BD_Comment_2__c, FB_BD_Comment_3__c, FB_BD_Comment_4__c, FB_BD_Comment_5__c, FB_BD_Requirement_Met_1__c, 
                FB_BD_Requirement_Met_2__c, FB_BD_Requirement_Met_3__c, FB_BD_Requirement_Met_4__c, FB_BD_Requirement_Met_5__c, FB_CAS_Comment_1__c, FB_CAS_Requirement_Met_1__c, 
                FB_CIB_Comment_1__c, FB_CIB_Requirement_Met_1__c,FB_CQ_Comment_1__c, FB_CQ_Comment_2__c, FB_CQ_Comment_3__c, FB_CQ_Comment_4__c,FB_CQ_Requirement_Met_1__c, 
                FB_CQ_Requirement_Met_2__c, FB_CQ_Requirement_Met_3__c, FB_CQ_Requirement_Met_4__c, FB_Documents_Expiration__c, FB_EP_Comment_1__c, FB_EP_Requirement_Met_1__c, 
                FB_FD_Comment_1__c, FB_FD_Comment_2__c, FB_FD_Requirement_Met_1__c, FB_FD_Requirement_Met_2__c, FB_GI_Comment_1__c, FB_GI_Requirement_Met_1__c, FB_Head_of_School__c, 
                FB_LD_Comment_1__c, FB_LD_Requirement_Met_1__c,FB_LE_Comment_1__c, FB_LE_Comment_2__c, FB_LE_Comment_3__c, FB_LE_Comment_4__c, FB_LE_Comment_5__c, FB_LE_Comment_6__c,
                FB_LE_Comment_7__c, FB_LE_Requirement_Met_1__c, FB_LE_Requirement_Met_2__c, FB_LE_Requirement_Met_3__c, FB_LE_Requirement_Met_4__c, FB_LE_Requirement_Met_5__c, FB_LE_Requirement_Met_6__c, 
                FB_LE_Requirement_Met_7__c, FB_LG_Comment_1__c, FB_LG_Comment_2__c, FB_LG_Comment_3__c, FB_LG_Requirement_Met_1__c, FB_LG_Requirement_Met_2__c, FB_LG_Requirement_Met_3__c, 
                FB_LI_Comment_1__c, FB_LI_Comment_2__c, FB_LI_Requirement_Met_1__c, FB_LI_Requirement_Met_2__c, FB_LOM_Comment_1__c, FB_LOM_Requirement_Met_1__c, FB_Lookup_IB_Application__c,
                FB_MC_Comment_1__c, FB_MC_Comment_2__c, FB_MC_Comment_3__c, FB_MC_Comment_4__c, FB_MC_Comment_5__c, FB_MC_Comment_6__c, FB_MC_Comment_7__c, FB_MC_Comment_8__c, FB_MC_Comment_9__c, 
                FB_MC_Requirement_Met_1__c, FB_MC_Requirement_Met_2__c, FB_MC_Requirement_Met_3__c, FB_MC_Requirement_Met_4__c, FB_MC_Requirement_Met_5__c, FB_MC_Requirement_Met_6__c, 
                FB_MC_Requirement_Met_7__c, FB_MC_Requirement_Met_8__c, FB_MC_Requirement_Met_9__c, FB_PD_Comment_1__c, FB_PD_Comment_2__c, FB_PD_Requirement_Met_1__c,FB_PD_Requirement_Met_2__c, 
                FB_Programme__c, FB_Programme_Coordinator__c, FB_PS_Comment_1__c, FB_PS_Comment_2__c, FB_PS_Comment_3__c, FB_PS_Comment_4__c, FB_PSG_Comment_1__c, FB_PSG_Requirement_Met_1__c, 
                FB_PS_Requirement_Met_1__c, FB_PS_Requirement_Met_2__c, FB_PS_Requirement_Met_3__c, FB_PS_Requirement_Met_4__c, FB_SC_Comment_1__c, FB_School_Code__c, FB_School_Mission__c, 
                FB_School_Name__c, FB_School_Open__c,  FB_SC_Requirement_Met_1__c, FB_SM_Comment_1__c, FB_SM_Comment_2__c, FB_SM_Comment_3__c, FB_SM_Comment_4__c,FB_SM_Requirement_Met_1__c, 
                FB_SM_Requirement_Met_2__c,FB_SM_Requirement_Met_3__c, FB_SM_Requirement_Met_4__c, FB_SN_Comment_1__c, FB_SN_Comment_2__c, FB_SN_Requirement_Met_2__c, FB_SP_Comment_1__c, 
                FB_STR_Comment_1__c, FB_STR_Comment_2__c, FB_STR_Comment_3__c, FB_STR_Requirement_Met_1__c, FB_STR_Requirement_Met_2__c, FB_STR_Requirement_Met_3__c, FB_TOK_Comment_1__c, 
                FB_TOK_Requirement_1__c, FB_TOK_Requirement_Met_1__c, AccountSchoolName__c, Date_Submitted__c, IB_Application_Lookup__c
            FROM IB_Application_Feedback__c 
            WHERE IB_Application_Lookup__c = :appId
        ];

        return pimsApplicationFeedbackList;

    }

}