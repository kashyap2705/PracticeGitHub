public class IbenVerificationVisitExitReport 
{
    public transient IB_Verification_Visit_Feedback__c vvFeedback {get;set;}
    public transient IB_Verification_Visit_Feedback_A__c vvA {get;set;}
    public transient IB_Verification_Visit_Feedback_B1__c vvB1 {get;set;}
    public transient IB_Verification_Visit_Feedback_B2__c vvB2 {get;set;}
    public transient IB_Verification_Visit_Feedback_C1__c vvC1 {get;set;}
    public transient IB_Verification_Visit_Feedback_C2__c vvC2 {get;set;}
    public transient IB_Verification_Visit_Feedback_C3__c vvC3 {get;set;}
    public transient IB_Verification_Visit_Feedback_C4__c vvC4 {get;set;}
    
    public IbenVerificationVisitExitReport(ApexPages.StandardController con)
    {
        vvFeedback = [
            SELECT Id,Name,IB_Application__c,Account__c,Account__r.Name,Programme_Type__c,
            (SELECT Id,a_1_c__c,a_1_e_1__c,a_1_f__c,a_1_mtba_1__c,a_1_pip__c,a_1_r__c,a_2_c__c,a_2_e_1__c,a_2_f__c,a_2_mtba_1__c,a_2_pip__c,a_2_r__c,a_3_c__c,a_3_e_1__c,a_3_e_2__c,a_3_e_3__c,a_3_e_4__c,a_3_f__c,a_3_mtba_1__c,a_3_mtba_2__c,a_3_mtba_3__c,a_3_mtba_4__c,a_3_pip__c,a_3_r__c,a_3__c,a_3a_c__c,a_3a_e_1__c,a_3a_e_2__c,a_3a_f__c,a_3a_mtba_3__c,a_3a_r__c,a_3b_c__c,a_3b_f__c,a_3b_r__c,a_3c_c__c,a_3c_f__c,a_3c_r__c,a_3d_c__c,a_3d_e_1__c,a_3d_f__c,a_3d_mtba_1__c,a_3d_r__c,a_3e_c__c,a_3e_e_1__c,a_3e_f__c,a_3e_mtba_1__c,a_3e_pip__c,a_3e_r__c,a_4_c__c,a_4_e_1__c,a_4_f__c,a_4_mtba_1__c,a_4_pip__c,a_4_r__c,a_5_c__c,a_5_e_1__c,a_5_f__c,a_5_mtba_1__c,a_5_pip__c,a_5_r__c,a_6_c__c,a_6_e_1__c,a_6_f__c,a_6_mtba_1__c,a_6_pip__c,a_6_r__c,a_7_c__c,a_7_e_1__c,a_7_f__c,a_7_mtba_1__c,a_7_pip__c,a_7_r__c,a_7a_c__c,a_7a_e_1__c,a_7a_f__c,a_7a_mtba_1__c,a_7a_pip__c,a_7a_r__c,a_7b_c__c,a_7b_f__c,a_7b_r__c,a_8_c__c,a_8_f__c,a_8_r__c,a_9_c__c,a_9_e_1__c,a_9_e_2__c,a_9_e_3__c,a_9_f__c,a_9_mtba_1__c,a_9_mtba_2__c,a_9_mtba_3__c,a_9_pip__c,a_9_r__c,a_9a_c__c,a_9a_e_1__c,a_9a_f__c,a_9a_mtba_1__c,a_9a_pip__c,a_9a_r__c,a_9c_c__c,a_9c_f__c,a_9c_r__c,A_3a_PIP__c FROM IB_Verification_Visit_Feedback_A__r),
            (SELECT Id,b1_1_c__c,b1_1_e_1__c,b1_1_f__c,b1_1_mtba_1__c,b1_1_pip__c,b1_1_r__c,b1_2_c__c,b1_2_e_1__c,b1_2_f__c,b1_2_mtba_1__c,b1_2_pip__c,b1_2_r__c,b1_2a_c__c,b1_2a_e_1__c,b1_2a_f__c,b1_2a_mtba_1__c,b1_2a_pip__c,b1_2a_r__c,b1_2b_c__c,b1_2b_e_1__c,b1_2b_f__c,b1_2b_mtba_1__c,b1_2b_pip__c,b1_2b_r__c,b1_3_c__c,b1_3_e_1__c,b1_3_f__c,b1_3_mtba_1__c,b1_3_pip__c,b1_3_r__c,b1_4_c__c,b1_4_e_1__c,b1_4_e_2__c,b1_4_f__c,b1_4_mtba_1__c,b1_4_mtba_2__c,b1_4_pip__c,b1_4_r__c,b1_5a_c__c,b1_5a_e_1__c,b1_5a_f__c,b1_5a_mtba_1__c,b1_5a_pip__c,b1_5a_r__c,b1_5b_c__c,b1_5b_e_1__c,b1_5b_f__c,b1_5b_mtba_1__c,b1_5b_pip__c,b1_5b_r__c,b1_5c_c__c,b1_5c_e_1__c,b1_5c_f__c,b1_5c_mtba_1__c,b1_5c_pip__c,b1_5c_r__c,b1_5d_c__c,b1_5d_e_1__c,b1_5d_f__c,b1_5d_mtba_1__c,b1_5d_pip__c,b1_5d_r__c,b1_5e_c__c,b1_5e_e_1__c,b1_5e_f__c,b1_5e_mtba_1__c,b1_5e_pip__c,b1_5e_r__c,b1_5f_c__c,b1_5f_f__c,b1_5f_r__c,b1_6_c__c,b1_6_e_1__c,b1_6_f__c,b1_6_mtba_1__c,b1_6_pip__c,b1_6_r__c,b1_6a_c__c,b1_6a_e_1__c,b1_6a_e_2__c,b1_6a_f__c,b1_6a_mtba_1__c,b1_6a_mtba_2__c,b1_6a_pip__c,b1_6a_r__c FROM IB_Verification_Visit_Feedback_B__r),
            (SELECT Id,b2_10_c__c,b2_10_e_1__c,b2_10_e_2__c,b2_10_f__c,b2_10_mtba_1__c,b2_10_mtba_2__c,b2_10_pip__c,b2_10_r__c,b2_10a_c__c,b2_10a_e_1__c,b2_10a_f__c,b2_10a_mtba_1__c,b2_10a_pip__c,b2_10a_r__c,b2_10b_c__c,b2_10b_e_1__c,b2_10b_f__c,b2_10b_mtba_1__c,b2_10b_pip__c,b2_10b_r__c,b2_10c_c__c,b2_10c_e_1__c,b2_10c_f__c,b2_10c_mtba_1__c,b2_10c_pip__c,b2_10c_r__c,b2_11_c__c,b2_11_f__c,b2_11_pip__c,b2_11_r__c,b2_12_c__c,b2_12_e_1__c,b2_12_f__c,b2_12_mtba_1__c,b2_12_pip__c,b2_12_r__c,b2_1_c__c,b2_1_e_1__c,b2_1_e_2__c,b2_1_e_3__c,b2_1_f__c,b2_1_mtba_1__c,b2_1_mtba_2__c,b2_1_mtba_3__c,b2_1_pip__c,b2_1_r__c,b2_2_c__c,b2_2_e_1__c,b2_2_f__c,b2_2_mtba_1__c,b2_2_pip__c,b2_2_r__c,b2_3_c__c,b2_3_e_1__c,b2_3_e_2__c,b2_3_f__c,b2_3_mtba_1__c,b2_3_mtba_2__c,b2_3_pip__c,b2_3_r__c,b2_3a_c__c,b2_3a_e_1__c,b2_3a_f__c,b2_3a_mtba_1__c,b2_3a_pip__c,b2_3a_r__c,b2_4_c__c,b2_4_e_1__c,b2_4_f__c,b2_4_mtba_1__c,b2_4_pip__c,b2_4_r__c,b2_5_c__c,b2_5_e_1__c,b2_5_f__c,b2_5_mtba_1__c,b2_5_pip__c,b2_5_r__c,b2_5a_c__c,b2_5a_e_1__c,b2_5a_f__c,b2_5a_mtba_1__c,b2_5a_pip__c,b2_5a_r__c,b2_5b_c__c,b2_5b_e_1__c,b2_5b_f__c,b2_5b_mtba_1__c,b2_5b_pip__c,b2_5b_r__c,b2_5c_c__c,b2_5c_f__c,b2_5c_r__c,b2_6_c__c,b2_6_e_1__c,b2_6_e_2__c,b2_6_f__c,b2_6_mtba_1__c,b2_6_mtba_2__c,b2_6_pip__c,b2_6_r__c,b2_7_c__c,b2_7_e_1__c,b2_7_f__c,b2_7_mtba_1__c,b2_7_pip__c,b2_7_r__c,b2_8_c__c,b2_8_e_1__c,b2_8_f__c,b2_8_mtba_1__c,b2_8_pip__c,b2_8_r__c,b2_9_c__c,b2_9_e_1__c,b2_9_f__c,b2_9_mtba_1__c,b2_9_pip__c,b2_9_r__c,b2_9a_c__c,b2_9a_f__c,b2_9a_r__c FROM IB_Verification_Visit_Feedback_B2__r),
            (SELECT Id,c1_1_c__c,c1_1_e_1__c,c1_1_e_2__c,c1_1_e_3__c,c1_1_e_4__c,c1_1_f__c,c1_1_mtba_1__c,c1_1_mtba_2__c,c1_1_mtba_3__c,c1_1_mtba_4__c,c1_1_pip__c,c1_1_r__c,c1_1a_c__c,c1_1a_e_1__c,c1_1a_f__c,c1_1a_mtba_1__c,c1_1a_pip__c,c1_1a_r__c,c1_1b_c__c,c1_1b_f__c,c1_1b_r__c,c1_1c_c__c,c1_1c_e_1__c,c1_1c_f__c,c1_1c_mtba_1__c,c1_1c_pip__c,c1_1c_r__c,c1_2_c__c,c1_2_e_1__c,c1_2_f__c,c1_2_mtba_1__c,c1_2_pip__c,c1_2_r__c,c1_3_c__c,c1_3_f__c,c1_3_r__c,c1_3a_c__c,c1_3a_f__c,c1_3a_r__c,c1_3b_c__c,c1_3b_f__c,c1_3b_r__c,c1_4_c__c,c1_4_f__c,c1_4_r__c,c1_4a_c__c,c1_4a_f__c,c1_4a_r__c,c1_4b_c__c,c1_4b_f__c,c1_4b_r__c,c1_5_c__c,c1_5_f__c,c1_5_r__c,c1_6_c__c,c1_6_f__c,c1_6_r__c,c1_7_c__c,c1_7_f__c,c1_7_r__c,c1_8_c__c,c1_8_f__c,c1_8_r__c,c1_9_c__c,c1_9_e_1__c,c1_9_f__c,c1_9_mtba_1__c,c1_9_pip__c,c1_9_r__c FROM IB_Verification_Visit_Feedback_C1__r),
            (SELECT Id,c2_10_c__c,c2_10_f__c,c2_10_r__c,c2_11_c__c,c2_11_e_1__c,c2_11_f__c,c2_11_mtba_1__c,c2_11_pip__c,c2_11_r__c,c2_1_c__c,c2_1_e_1__c,c2_1_f__c,c2_1_mtba_1__c,c2_1_pip__c,c2_1_r__c,c2_1a_c__c,c2_1a_e_1__c,c2_1a_f__c,c2_1a_mtba_1__c,c2_1a_pip__c,c2_1a_r__c,c2_1b_c__c,c2_1b_e_1__c,c2_1b_f__c,c2_1b_mtba_1__c,c2_1b_pip__c,c2_1b_r__c,c2_1c_c__c,c2_1c_e_1__c,c2_1c_f__c,c2_1c_mtba_1__c,c2_1c_pip__c,c2_1c_r__c,c2_1d_c__c,c2_1d_e_1__c,c2_1d_f__c,c2_1d_mtba_1__c,c2_1d_pip__c,c2_1d_r__c,c2_1e_c__c,c2_1e_e_1__c,c2_1e_f__c,c2_1e_mtba_1__c,c2_1e_pip__c,c2_1e_r__c,c2_1f_c__c,c2_1f_e_1__c,c2_1f_f__c,c2_1f_mtba_1__c,c2_1f_pip__c,c2_1f_r__c,c2_1g_c__c,c2_1g_e_1__c,c2_1g_f__c,c2_1g_mtba_1__c,c2_1g_pip__c,c2_1g_r__c,c2_1h_c__c,c2_1h_e_1__c,c2_1h_f__c,c2_1h_mtba_1__c,c2_1h_pip__c,c2_1h_r__c,c2_2_c__c,c2_2_f__c,c2_2_r__c,c2_3_c__c,c2_3_f__c,c2_3_r__c,c2_4_c__c,c2_4_e_1__c,c2_4_f__c,c2_4_mtba_1__c,c2_4_pip__c,c2_4_r__c,c2_4a_c__c,c2_4a_e_1__c,c2_4a_f__c,c2_4a_mtba_1__c,c2_4a_pip__c,c2_4a_r__c,c2_4b_c__c,c2_4b_f__c,c2_4b_r__c,c2_5_c__c,c2_5_f__c,c2_5_r__c,c2_6_c__c,c2_6_f__c,c2_6_r__c,c2_6a_c__c,c2_6a_f__c,c2_6a_r__c,c2_7_c__c,c2_7_e_1__c,c2_7_f__c,c2_7_mtba_1__c,c2_7_pip__c,c2_7_r__c,c2_7a_c__c,c2_7a_f__c,c2_7a_r__c,c2_8_c__c,c2_8_e_1__c,c2_8_f__c,c2_8_mtba_1__c,c2_8_pip__c,c2_8_r__c,c2_9_c__c,c2_9_e_1__c,c2_9_f__c,c2_9_mtba_1__c,c2_9_pip__c,c2_9_r__c,c2_9a_c__c,c2_9a_f__c,c2_9a_r__c,c2_5a_c__c,c2_5a_r__c,c2_5a_pip__c,C2_5a_F__c FROM IB_Verification_Visit_Feedback_C2__r),
            (SELECT Id,c3_10_c__c,c3_10_f__c,c3_10_r__c,c3_10a_c__c,c3_10a_f__c,c3_10a_r__c,c3_11_c__c,c3_11_f__c,c3_11_r__c,c3_12_c__c,c3_12_f__c,c3_12_r__c,c3_13_c__c,c3_13_f__c,c3_13_r__c,c3_14_c__c,c3_14_f__c,c3_14_r__c,c3_14a_c__c,c3_14a_f__c,c3_14a_r__c,c3_14b_c__c,c3_14b_f__c,c3_14b_r__c,c3_15_c__c,c3_15_f__c,c3_15_r__c,c3_16_c__c,c3_16_f__c,c3_16_r__c,c3_1_c__c,c3_1_e_1__c,c3_1_e_2__c,c3_1_f__c,c3_1_mtba_1__c,c3_1_mtba_2__c,c3_1_pip__c,c3_1_r__c,c3_1a_c__c,c3_1a_f__c,c3_1a_r__c,c3_1b_c__c,c3_1b_e_1__c,c3_1b_f__c,c3_1b_mtba_1__c,c3_1b_pip__c,c3_1b_r__c,c3_1c_c__c,c3_1c_f__c,c3_1c_r__c,c3_2_c__c,c3_2_f__c,c3_2_r__c,c3_2a_c__c,c3_2a_f__c,c3_2a_r__c,c3_3_c__c,c3_3_f__c,c3_3_r__c,c3_3a_c__c,c3_3a_f__c,c3_3a_r__c,c3_4_c__c,c3_4_e_1__c,c3_4_f__c,c3_4_mtba_1__c,c3_4_pip__c,c3_4_r__c,c3_5_c__c,c3_5_f__c,c3_5_r__c,c3_6_c__c,c3_6_f__c,c3_6_r__c,c3_7_c__c,c3_7_f__c,c3_7_r__c,c3_8_c__c,c3_8_f__c,c3_8_r__c,c3_9_c__c,c3_9_f__c,c3_9_r__c FROM IB_Verification_Visit_Feedback_C3__r),
            (SELECT Id,c4_1_c__c,c4_1_e_1__c,c4_1_e_2__c,c4_1_e_3__c,c4_1_f__c,c4_1_mtba_1__c,c4_1_mtba_2__c,c4_1_mtba_3__c,c4_1_pip__c,c4_1_r__c,c4_1a_c__c,c4_1a_e_1__c,c4_1a_f__c,c4_1a_mtba_1__c,c4_1a_pip__c,c4_1a_r__c,c4_1b_c__c,c4_1b_f__c,c4_1b_r__c,c4_1c_c__c,c4_1c_f__c,c4_1c_r__c,c4_1d_c__c,c4_1d_f__c,c4_1d_r__c,c4_2_c__c,c4_2_e_1__c,c4_2_f__c,c4_2_mtba_1__c,c4_2_pip__c,c4_2_r__c,c4_3_c__c,c4_3_e_1__c,c4_3_f__c,c4_3_mtba_1__c,c4_3_pip__c,c4_3_r__c,c4_4_c__c,c4_4_f__c,c4_4_r__c,c4_5a_c__c,c4_5a_f__c,c4_5a_r__c,c4_5_c__c,c4_5_f__c,c4_5_r__c,c4_6_c__c,c4_6_f__c,c4_6_r__c,c4_6a_c__c,c4_6a_f__c,c4_6a_r__c,c4_7_c__c,c4_7_f__c,c4_7_r__c,c4_7a_c__c,c4_7a_f__c,c4_7a_r__c,c4_8_c__c,c4_8_f__c,c4_8_r__c,c4_9_c__c,c4_9_e_1__c,c4_9_f__c,c4_9_mtba_1__c,c4_9_pip__c,c4_9_r__c FROM IB_Verification_Visit_Feedback_C4__r)
            FROM IB_Verification_Visit_Feedback__c 
            WHERE Id = :con.getId()
        ];
        System.debug('Programme:'+vvFeedback.Programme_Type__c);
        if(!vvFeedback.IB_Verification_Visit_Feedback_A__r.isEmpty())
            vvA = vvFeedback.IB_Verification_Visit_Feedback_A__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_B__r.isEmpty())
            vvB1 = vvFeedback.IB_Verification_Visit_Feedback_B__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_B2__r.isEmpty())
            vvB2 = vvFeedback.IB_Verification_Visit_Feedback_B2__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_C1__r.isEmpty())
            vvC1 = vvFeedback.IB_Verification_Visit_Feedback_C1__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_C2__r.isEmpty())
            vvC2 = vvFeedback.IB_Verification_Visit_Feedback_C2__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_C3__r.isEmpty())
            vvC3 = vvFeedback.IB_Verification_Visit_Feedback_C3__r.get(0);
        if(!vvFeedback.IB_Verification_Visit_Feedback_C4__r.isEmpty())
            vvC4 = vvFeedback.IB_Verification_Visit_Feedback_C4__r.get(0);
    }
    public boolean displayA1
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_1_c__c)||String.isNotEmpty(vvA.a_1_r__c)||vvA.a_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA2
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_2_c__c)||String.isNotEmpty(vvA.a_2_r__c)||vvA.a_2_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA3
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3_c__c)||String.isNotEmpty(vvA.a_3_r__c)||vvA.a_3_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA3a
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3a_c__c)||String.isNotEmpty(vvA.a_3a_r__c)||vvA.a_3a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA3b
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3b_c__c)||String.isNotEmpty(vvA.a_3b_r__c)/*||vvA.a_3b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayA3c
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3c_c__c)||String.isNotEmpty(vvA.a_3c_r__c)/*||vvA.a_3c_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayA3d
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3d_c__c)||String.isNotEmpty(vvA.a_3d_r__c)/*||vvA.a_3d_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayA3e
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_3e_c__c)||String.isNotEmpty(vvA.a_3e_r__c)||vvA.a_3e_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA4
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_4_c__c)||String.isNotEmpty(vvA.a_4_r__c)||vvA.a_4_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA5
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_5_c__c)||String.isNotEmpty(vvA.a_5_r__c)||vvA.a_5_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA6
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_6_c__c)||String.isNotEmpty(vvA.a_6_r__c)||vvA.a_6_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA7
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_7_c__c)||String.isNotEmpty(vvA.a_7_r__c)||vvA.a_7_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA7a
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_7a_c__c)||String.isNotEmpty(vvA.a_7a_r__c)||vvA.a_7a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA7b
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_7b_c__c)||String.isNotEmpty(vvA.a_7b_r__c)/*||vvA.a_7b_pip__c=='No'*/)?true:false;          
        }
        set;
    } 
    public boolean displayA8
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_8_c__c)||String.isNotEmpty(vvA.a_8_r__c)/*||vvA.a_8_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayA9
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_9_c__c)||String.isNotEmpty(vvA.a_9_r__c)||vvA.a_9_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA9a
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_9a_c__c)||String.isNotEmpty(vvA.a_9a_r__c)||vvA.a_9a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayA9c
    {        
        get
        {
        	return (String.isNotEmpty(vvA.a_9c_c__c)||String.isNotEmpty(vvA.a_9c_r__c)/*||vvA.a_9c_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayB11
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_1_c__c)||String.isNotEmpty(vvB1.b1_1_r__c)||vvB1.b1_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB12
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_2_c__c)||String.isNotEmpty(vvB1.b1_2_r__c)||vvB1.b1_2_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB12a
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_2a_c__c)||String.isNotEmpty(vvB1.b1_2a_r__c)||vvB1.b1_2a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB12b
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_2b_c__c)||String.isNotEmpty(vvB1.b1_2b_r__c)||vvB1.b1_2b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB13
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_3_c__c)||String.isNotEmpty(vvB1.b1_3_r__c)||vvB1.b1_3_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB14
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_4_c__c)||String.isNotEmpty(vvB1.b1_4_r__c)||vvB1.b1_4_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15
    {        
        get
        {
        	return true;
        }
        set;
    }
    public boolean displayB15a
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5a_c__c)||String.isNotEmpty(vvB1.b1_5a_r__c)||vvB1.b1_5a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15b
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5b_c__c)||String.isNotEmpty(vvB1.b1_5b_r__c)||vvB1.b1_5b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15c
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5c_c__c)||String.isNotEmpty(vvB1.b1_5c_r__c)||vvB1.b1_5c_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15d
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5d_c__c)||String.isNotEmpty(vvB1.b1_5d_r__c)||vvB1.b1_5d_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15e
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5e_c__c)||String.isNotEmpty(vvB1.b1_5e_r__c)||vvB1.b1_5e_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB15f
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_5f_c__c)||String.isNotEmpty(vvB1.b1_5f_r__c)/*||vvB1.b1_5f_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayB16
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_6_c__c)||String.isNotEmpty(vvB1.b1_6_r__c)||vvB1.b1_6_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB16a
    {        
        get
        {
        	return (String.isNotEmpty(vvB1.b1_6a_c__c)||String.isNotEmpty(vvB1.b1_6a_r__c)||vvB1.b1_6a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB17
    {        
        get
        {
        	return true;          
        }
        set;
    }
    public boolean displayB21
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_1_c__c)||String.isNotEmpty(vvB2.b2_1_r__c)||vvB2.b2_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB22
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_2_c__c)||String.isNotEmpty(vvB2.b2_2_r__c)||vvB2.b2_2_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB23
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_3_c__c)||String.isNotEmpty(vvB2.b2_3_r__c)||vvB2.b2_3_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB23a
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_3a_c__c)||String.isNotEmpty(vvB2.b2_3a_r__c)||vvB2.b2_3a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB24
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_4_c__c)||String.isNotEmpty(vvB2.b2_4_r__c)||vvB2.b2_4_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB25
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_5_c__c)||String.isNotEmpty(vvB2.b2_5_r__c)||vvB2.b2_5_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB25a
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_5a_c__c)||String.isNotEmpty(vvB2.b2_5a_r__c)||vvB2.b2_5a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB25b
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_5b_c__c)||String.isNotEmpty(vvB2.b2_5b_r__c)||vvB2.b2_5b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB25c
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_5c_c__c)||String.isNotEmpty(vvB2.b2_5c_r__c)/*||vvB2.b2_5c_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayB26
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_6_c__c)||String.isNotEmpty(vvB2.b2_6_r__c)||vvB2.b2_6_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB27
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_7_c__c)||String.isNotEmpty(vvB2.b2_7_r__c)||vvB2.b2_7_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB28
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_8_c__c)||String.isNotEmpty(vvB2.b2_8_r__c)||vvB2.b2_8_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB29
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_9_c__c)||String.isNotEmpty(vvB2.b2_9_r__c)||vvB2.b2_9_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB29a
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_9a_c__c)||String.isNotEmpty(vvB2.b2_9a_r__c)/*||vvB2.b2_9a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayB210
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_10_c__c)||String.isNotEmpty(vvB2.b2_10_r__c)||vvB2.b2_10_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB210a
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_10a_c__c)||String.isNotEmpty(vvB2.b2_10a_r__c)||vvB2.b2_10a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB210b
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_10b_c__c)||String.isNotEmpty(vvB2.b2_10b_r__c)||vvB2.b2_10b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB210c
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_10c_c__c)||String.isNotEmpty(vvB2.b2_10c_r__c)||vvB2.b2_10c_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB211
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_11_c__c)||String.isNotEmpty(vvB2.b2_11_r__c)||vvB2.b2_11_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayB212
    {        
        get
        {
        	return (String.isNotEmpty(vvB2.b2_12_c__c)||String.isNotEmpty(vvB2.b2_12_r__c)||vvB2.b2_12_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC11
    {        
        get
        {
        	return (String.isNotEmpty(vvC1.c1_1_c__c)||String.isNotEmpty(vvC1.c1_1_r__c)||vvC1.c1_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC11a
    {        
        get
        {
        	return (String.isNotEmpty(vvC1.c1_1a_c__c)||String.isNotEmpty(vvC1.c1_1a_r__c)||vvC1.c1_1a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC11b
    {        
        get
        {
        	return (String.isNotEmpty(vvC1.c1_1b_c__c)||String.isNotEmpty(vvC1.c1_1b_r__c))/*||vvC1.c1_1b_pip__c=='No'*/?true:false;          
        }
        set;
    }
    public boolean displayC11c
    {        
        get
        {
        	return (String.isNotEmpty(vvC1.c1_1c_c__c)||String.isNotEmpty(vvC1.c1_1c_r__c)||vvC1.c1_1c_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC12
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_2_c__c)||String.isNotEmpty(vvC1.c1_2_r__c)||vvC1.c1_2_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC13
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_3_c__c)||String.isNotEmpty(vvC1.c1_3_r__c)/*||vvC1.c1_3_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC13a
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_3a_c__c)||String.isNotEmpty(vvC1.c1_3a_r__c)/*||vvC1.c1_3a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC13b
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_3b_c__c)||String.isNotEmpty(vvC1.c1_3b_r__c)/*||vvC1.c1_3b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC14
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_4_c__c)||String.isNotEmpty(vvC1.c1_4_r__c)/*||vvC1.c1_4_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC14a
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_4a_c__c)||String.isNotEmpty(vvC1.c1_4a_r__c)/*||vvC1.c1_4a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC14b
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_4b_c__c)||String.isNotEmpty(vvC1.c1_4b_r__c)/*||vvC1.c1_4b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC15
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_5_c__c)||String.isNotEmpty(vvC1.c1_5_r__c)/*||vvC1.c1_5_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC16
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_6_c__c)||String.isNotEmpty(vvC1.c1_6_r__c)/*||vvC1.c1_6_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC17
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_7_c__c)||String.isNotEmpty(vvC1.c1_7_r__c)/*||vvC1.c1_7_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC18
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_8_c__c)||String.isNotEmpty(vvC1.c1_8_r__c)/*||vvC1.c1_8_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC19
    {        
        get
        {
            return (String.isNotEmpty(vvC1.c1_9_c__c)||String.isNotEmpty(vvC1.c1_9_r__c)||vvC1.c1_9_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1_c__c)||String.isNotEmpty(vvC2.c2_1_r__c)||vvC2.c2_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1a_c__c)||String.isNotEmpty(vvC2.c2_1a_r__c)||vvC2.c2_1a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21b
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1b_c__c)||String.isNotEmpty(vvC2.c2_1b_r__c)||vvC2.c2_1b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21c
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1c_c__c)||String.isNotEmpty(vvC2.c2_1c_r__c)||vvC2.c2_1c_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21d
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1d_c__c)||String.isNotEmpty(vvC2.c2_1d_r__c)||vvC2.c2_1d_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21e
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1e_c__c)||String.isNotEmpty(vvC2.c2_1e_r__c)||vvC2.c2_1e_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21f
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1f_c__c)||String.isNotEmpty(vvC2.c2_1f_r__c)||vvC2.c2_1f_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21g
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1g_c__c)||String.isNotEmpty(vvC2.c2_1g_r__c)||vvC2.c2_1g_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC21h
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_1h_c__c)||String.isNotEmpty(vvC2.c2_1h_r__c)||vvC2.c2_1h_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC22
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_2_c__c)||String.isNotEmpty(vvC2.c2_2_r__c)/*||vvC2.c2_2_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC23
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_3_c__c)||String.isNotEmpty(vvC2.c2_3_r__c)/*||vvC2.c2_3_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC24
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_4_c__c)||String.isNotEmpty(vvC2.c2_4_r__c)||vvC2.c2_4_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC24a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_4a_c__c)||String.isNotEmpty(vvC2.c2_4a_r__c)||vvC2.c2_4a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC24b
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_4b_c__c)||String.isNotEmpty(vvC2.c2_4b_r__c)/*||vvC2.c2_4b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC25
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_5_c__c)||String.isNotEmpty(vvC2.c2_5_r__c)/*||vvC2.c2_5_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC25a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_5a_c__c)||String.isNotEmpty(vvC2.c2_5a_r__c)||vvC2.c2_5a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC26
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_6_c__c)||String.isNotEmpty(vvC2.c2_6_r__c)/*||vvC2.c2_6_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC26a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_6a_c__c)||String.isNotEmpty(vvC2.c2_6a_r__c)/*||vvC2.c2_6a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC27
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_7_c__c)||String.isNotEmpty(vvC2.c2_7_r__c)||vvC2.c2_7_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC27a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_7a_c__c)||String.isNotEmpty(vvC2.c2_7a_r__c)/*||vvC2.c2_7a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC28
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_8_c__c)||String.isNotEmpty(vvC2.c2_8_r__c)||vvC2.c2_8_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC29
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_9_c__c)||String.isNotEmpty(vvC2.c2_9_r__c)||vvC2.c2_9_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC29a
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_9a_c__c)||String.isNotEmpty(vvC2.c2_9a_r__c)/*||vvC2.c2_9a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC210
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_10_c__c)||String.isNotEmpty(vvC2.c2_10_r__c)/*||vvC2.c2_10_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC211
    {        
        get
        {
            return (String.isNotEmpty(vvC2.c2_11_c__c)||String.isNotEmpty(vvC2.c2_11_r__c)||vvC2.c2_11_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC31
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_1_c__c)||String.isNotEmpty(vvC3.c3_1_r__c)||vvC3.c3_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC31a
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_1a_c__c)||String.isNotEmpty(vvC3.c3_1a_r__c)/*||vvC3.c3_1a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC31b
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_1b_c__c)||String.isNotEmpty(vvC3.c3_1b_r__c)||vvC3.c3_1b_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC31c
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_1c_c__c)||String.isNotEmpty(vvC3.c3_1c_r__c)/*||vvC3.c3_1c_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC32
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_2_c__c)||String.isNotEmpty(vvC3.c3_2_r__c)/*||vvC3.c3_2_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC32a
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_2a_c__c)||String.isNotEmpty(vvC3.c3_2a_r__c)/*||vvC3.c3_2a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC33
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_3_c__c)||String.isNotEmpty(vvC3.c3_3_r__c)/*||vvC3.c3_3_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC33a
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_3a_c__c)||String.isNotEmpty(vvC3.c3_3a_r__c)/*||vvC3.c3_3a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC34
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_4_c__c)||String.isNotEmpty(vvC3.c3_4_r__c)||vvC3.c3_4_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC35
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_5_c__c)||String.isNotEmpty(vvC3.c3_5_r__c)/*||vvC3.c3_5_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC36
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_6_c__c)||String.isNotEmpty(vvC3.c3_6_r__c)/*||vvC3.c3_6_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC37
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_7_c__c)||String.isNotEmpty(vvC3.c3_7_r__c)/*||vvC3.c3_7_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC38
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_8_c__c)||String.isNotEmpty(vvC3.c3_8_r__c)/*||vvC3.c3_8_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC39
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_9_c__c)||String.isNotEmpty(vvC3.c3_9_r__c)/*||vvC3.c3_9_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC310
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_10_c__c)||String.isNotEmpty(vvC3.c3_10_r__c)/*||vvC3.c3_10_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC310a
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_10a_c__c)||String.isNotEmpty(vvC3.c3_10a_r__c)/*||vvC3.c3_10a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC311
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_11_c__c)||String.isNotEmpty(vvC3.c3_11_r__c)/*||vvC3.c3_11_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC312
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_12_c__c)||String.isNotEmpty(vvC3.c3_12_r__c)/*||vvC3.c3_12_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC313
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_13_c__c)||String.isNotEmpty(vvC3.c3_13_r__c)/*||vvC3.c3_13_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC314
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_14_c__c)||String.isNotEmpty(vvC3.c3_14_r__c)/*||vvC3.c3_14_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC314a
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_14a_c__c)||String.isNotEmpty(vvC3.c3_14a_r__c)/*||vvC3.c3_14a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC314b
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_14b_c__c)||String.isNotEmpty(vvC3.c3_14b_r__c)/*||vvC3.c3_14b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC315
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_15_c__c)||String.isNotEmpty(vvC3.c3_15_r__c)/*||vvC3.c3_15_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC316
    {        
        get
        {
            return (String.isNotEmpty(vvC3.c3_16_c__c)||String.isNotEmpty(vvC3.c3_16_r__c)/*||vvC3.c3_16_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC41
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_1_c__c)||String.isNotEmpty(vvC4.c4_1_r__c)||vvC4.c4_1_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC41a
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_1a_c__c)||String.isNotEmpty(vvC4.c4_1a_r__c)||vvC4.c4_1a_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC41b
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_1b_c__c)||String.isNotEmpty(vvC4.c4_1b_r__c)/*||vvC4.c4_1b_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC41c
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_1c_c__c)||String.isNotEmpty(vvC4.c4_1c_r__c)/*||vvC4.c4_1c_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC41d
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_1d_c__c)||String.isNotEmpty(vvC4.c4_1d_r__c)/*||vvC4.c4_1d_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC42
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_2_c__c)||String.isNotEmpty(vvC4.c4_2_r__c)||vvC4.c4_2_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC43
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_3_c__c)||String.isNotEmpty(vvC4.c4_3_r__c)||vvC4.c4_3_pip__c=='No')?true:false;          
        }
        set;
    }
    public boolean displayC44
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_4_c__c)||String.isNotEmpty(vvC4.c4_4_r__c)/*||vvC4.c4_4_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC45
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_5_c__c)||String.isNotEmpty(vvC4.c4_5_r__c)/*||vvC4.c4_5_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC45a
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_5a_c__c)||String.isNotEmpty(vvC4.c4_5a_r__c)/*||vvC4.c4_5a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC46
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_6_c__c)||String.isNotEmpty(vvC4.c4_6_r__c)/*||vvC4.c4_6_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC46a
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_6a_c__c)||String.isNotEmpty(vvC4.c4_6a_r__c)/*||vvC4.c4_6a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC47
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_7_c__c)||String.isNotEmpty(vvC4.c4_7_r__c)/*||vvC4.c4_7_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC47a
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_7a_c__c)||String.isNotEmpty(vvC4.c4_7a_r__c)/*||vvC4.c4_7a_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC48
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_8_c__c)||String.isNotEmpty(vvC4.c4_8_r__c)/*||vvC4.c4_8_pip__c=='No'*/)?true:false;          
        }
        set;
    }
    public boolean displayC49
    {
        get
        {
            return (String.isNotEmpty(vvC4.c4_9_c__c)||String.isNotEmpty(vvC4.c4_9_r__c)||vvC4.c4_9_pip__c=='No')?true:false;          
        }
        set;
    }
}