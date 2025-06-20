/*******************************************************************************************
* @Name         IboUtil 
* @Author       Ranjith Kondabathini
* @Date         26-04-2023
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1. 				Michael 			24-05-23		Added getContactIdForSystemAdmin()
* 2.				Michael				25-05-23		Added showLimits()
* 2.				Ranjith				30-05-23		Added constants for Ib Role Names
* 3.				Saurabh 			16-06-23		Added Four constants for ibPortalFooterControlller
* 4.                Tharun              15-09-23        Added constants for Ib Programme Status,Sub_Stage,StageName
* 5.                Saurabh             17-09-23        Added constants for Staffing Sub Type,campaign Status,Account Record Type,contact Type,Staffing Application Status,Staffing Sub Type
*******************************************************************************************/
public class IboUtil {
    /*Indicates the name of GSSS Queue*/
    public static final String GSSS_QUEUE_NAME = 'FEO_Global_School_System_Support';
    //code added by Prerna on 20-07-2023 for ECM00489 --START--
    /*Indicates the name of SO Customer Service Queue*/
    public static final String SO_QUEUE_NAME = 'SO_Customer_Service';
    /*Indicates the recordtype Support name of case */
    private static final String CASE_SUPPORT_RT = 'Support';
    /*Indicates the name of Email Origin*/
    public static final String ORIGIN_EMAIL = 'E-mail';
    /*Indicates the name of Confirmed role*/
    public static final String ROLE_CONFIRMED_STATUS = 'Confirmed';
    /*Indicates the name of Invited role*/ 
    public static final String ROLE_INVITED_STATUS = 'Invited';
    /*Indicates the name of Applicant role*/
    public static final String ROLE_APPLICANT_STATUS = 'Applicant';
    /*Indicates the name of Withdrawn role*/
    public static final String ROLE_WITHDRAWN_STATUS = 'Withdrawn';
    /*Indicates the name of Declined role*/
    public static final String ROLE_DECLINED_STATUS = 'Declined';
    /*Indicates the Internal User type*/
    public static final String USER_TYPE_STANDARD = 'Standard';
    /*Indicates the Automated Process User type*/
    public static final String USER_TYPE_AUTOMATED = 'AutomatedProcess';
    /*Indicates the Standard User type*/
    public static final String USER_TYPE_INTEGRATION = 'CloudIntegrationUser';
    /*Indicates the Role name for CAS Coordinator*/
    public static final String ROLE_CAS_Coordinator = 'CAS Coordinator';
    /*Indicates the Role name for Online Admin Assistant*/
    public static final String ROLE_ONLINE_ADMIN_ASSISTANT = 'Online Admin Assistant';
    /*Indicates the Role name for Billing Contact*/
    public static final String ROLE_BILLING_CONTACT = 'Billing Contact';
    /*Indicates the Role name for Teacher*/
    public static final String ROLE_TEACHER = 'Teacher';
    /*Indicates the Role name for Head of School (Overall)*/
    public static final String ROLE_HOS_OVERALL = 'Head of School (Overall)';
    /*Indicates the Role name for Head of School*/
    public static final String ROLE_HOS = 'Head of School';
    /*Indicates the Role name for Programme Coordinator*/
    public static final String ROLE_PROGRAMME_COORDINATOR = 'Programme Coordinator';
    /*Indicates the Role name for Admin Assistant*/
    public static final String ROLE_ADMIN_ASSISTANT = 'Admin Assistant';
    /*Indicates the Role name for Digital Channel User*/
    public static final String ROLE_DCU = 'Digital Channel User';
    /*Indicates the Role name for Exam Contact*/
    public static final String ROLE_EXAM_CONTACT = 'Exam Contact';
    /*Indicates the Role name for Institute Administrator*/
    public static final String ROLE_INSTITUTE_ADMINISTRATOR = 'Institute Administrator';
    /*Indicates the Role name for Institute Curriculum User*/
    public static final String ROLE_INSTITUTE_CURRICULUM_USER = 'Institute Curriculum User';
    /*Indicates the Role name for Institute Policy User*/
    public static final String ROLE_INSTITUTE_POLICY_USER = 'Institute Policy User';
    /*Indicates the Role name for Institute Transcript User*/
    public static final String ROLE_INSTITUTE_TRANSCRIPT_USER = 'Institute Transcript User';
    /*Indicates the Role name for Communication User*/
    public static final String ROLE_COMMUNICATION_USER = 'Communication User';
    /*Indicates the Role name for Online Coordinator*/
    public static final String ROLE_ONLINE_COORDINATOR = 'Online Coordinator'; 
    /*Indicates the Role name for Association User*/
    public static final String ROLE_ASSOCIATION_USER = 'Association User';
    /*Indicates the Role name for Evaluation Leader*/
    public static final String ROLE_EVALUATION_LEADER = 'Evaluation Leader';
    /*Indicates the Role name for Programme Leader*/
    public static final String ROLE_PROGRAMME_LEADER = 'Programme Leader';
    /*Indicates the Role name for Examiner*/
    public static final String ROLE_EXAMINER = 'Examiner';
    /*Indicates the Role name for Chief Examiner*/
    public static final String ROLE_CHIEF_EXAMINER = 'Chief Examiner';
    /*Indicates the Role name for Exam Team Leader*/
    public static final String ROLE_EXAM_TEAM_LEADER = 'Exam Team Leader';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_PRINCIPAL_EXAMINER = 'Principal Examiner';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_DEPUTY_EXAMINER_RESPONSIBLE = 'Deputy Examiner Responsible';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_EXAMINER_RESPONSIBLE = 'Examiner Responsible';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_ASSESSMENT_LANGUAGE_REVIEWER = 'Assessment Language Reviewer';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_ASSESSMENT_CONTENT_DEVELOPER = 'Assessment Content Developer';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_ASSESSMENT_TRANSLATOR = 'Assessment Translator';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_IBEC_FACULTY_MEMBER = 'IBEC Faculty Member';
    /*Indicates the Role name for Principal Examiner*/
    public static final String ROLE_IBEC_CANDIDATE = 'IBEC Candidate';
    /*Indicates the Role type for Online Coordinator*/
    public static final String ROLE_TYPE_ONLINE_PROVIDER = 'Online Provider';    
    //Added by Prerna as a part of ECM00566 Starts
    /*Indicates the Role name for IBEC Certificate Holder*/
    public static final String ROLE_IBEC_CERTIFICATE_HOLDER = 'IBEC Certificate Holder';
    //Added by Prerna as a part of ECM00566 ENDS
    /*Indicates the DEFAULT ROLES FOR A PROGRAMME*/
    public static final List<String> DEFAULT_PROGRAMME_ROLES = new List<String>{IboUtil.ROLE_HOS, IboUtil.ROLE_PROGRAMME_COORDINATOR, IboUtil.ROLE_BILLING_CONTACT, IboUtil.ROLE_EXAM_CONTACT};
        public static final List<String> DEFAULT_PROGRAMME_ROLES_ADDITION = new List<String>{IboUtil.ROLE_HOS, IboUtil.ROLE_PROGRAMME_COORDINATOR, IboUtil.ROLE_BILLING_CONTACT, IboUtil.ROLE_EXAM_CONTACT, IboUtil.ROLE_ADMIN_ASSISTANT};   
            //Added by Saurabh Singh for Ib Portal Footer transalation.
            public static final String Ib_language_policy = 'Ib_language_policy';
    public static final String Ib_terms_and_Conditions = 'Ib_terms_and_Conditions';
    public static final String IB_privacy_policy = 'IB_privacy_policy';
    public static final String Copyright = 'Copyright';    
    /*Indicates site api name for ibportal*/
    public static final String IB_PORTAL_SITE_NAME = 'ibportal';
    /*Indicates site api name for My School*/
    public static final String MY_SCHOOL_SITE_NAME = 'My_School';
    //Added by Saurabh Singh for IB Action Plan Item Page translation, This change is a part of this Story PRB0041472.
    public static final String Action_Plan = 'Action_Plan';    
    public static final String Action = 'Action';    
    public static final String Action_Item = 'Action_Item';    
    public static final String Action_Plan_Item = 'Action_Plan_Item'; 
    public static final String Action_Type = 'Action_Type';      
    public static final String Back_to_Action_Plan = 'Back_to_Action_Plan';    
    public static final String Budgetary_Implications = 'Budgetary_Implications';    
    public static final String Created_Date = 'Created_Date';    
    public static final String Documents = 'Documents';    
    public static final String Due_Date = 'Due_Date';    
    public static final String Evidence_of_Achievement = 'Evidence_of_Achievement';    
    public static final String MTBA_Evidence = 'MTBA_Evidence';    
    public static final String MTBA_Review = 'MTBA_Review';    
    public static final String Person_Responsible = 'Person_Responsible';    
    public static final String Practice = 'Practice';    
    public static final String Process_Stage = 'Process_Stage';    
    public static final String Programme = 'Programme';    
    public static final String Requirement = 'Requirement';    
    public static final String Standard = 'Standard';    
    public static final String Status = 'Status';    
    public static final String Update_Action_Item = 'Update_Action_Item'; 
    public static final String Description = 'Description';    
    public static final String File = 'File';    
    public static final String Add_Document = 'Add_Document';    
    public static final String Upload_Document = 'Upload_Document';  
    public static final String Limit_Message_For_File_Upload = 'Limit_Message_For_File_Upload';    
    
    //Added logic to update the Email_Confirmed field as the part This user stroy PRB0041092 by Saurabh(Epam).
    public static final String Institute_Administrator = 'Institute Administrator'; 
    public static final String IBEC_University_Administrator = 'IBEC University Administrator'; 
    
    //Added constant Proggramme fields as the part This user stroy 195753 by Tharun(Epam).
    
    //---------Indicates the IB Programme Status__c 
    public static final String PROGRAMME_INTERESTED_STATUS='Interested';
    public static final String PROGRAMME_CANDIDATE_STATUS='Candidate';
    public static final String PROGRAMME_AUTHORIZED_STATUS='Authorized';
    
    //---------Indicates the IB Programme Sub_Stage__c
    public static final String PROGRAMME_ALLOCATE_READER_APP_FOR_AUTH_SUBSTAGE='Allocate reader (App for Auth)';
    public static final String PROGRAMME_RECEIVE_APPLICATION_FOR_AUTHORIZATION_SUBSTAGE='Receive Application for Authorization';
    public static final String PROGRAMME_PLAN_AUTHORIZATION_SUBSTAGE='Plan Authorization';
    public static final String PROGRAMME_ALLOCATE_VISIT_TEAM_SUBSTAGE='Allocate visit team';
    public static final String PROGRAMME_UPDATE_DECISION_SUBSTAGE='Update Decision';
    
    //---------Indicates the IB Programme StageName__c
    public static final String PROGRAMME_REQUEST_FOR_AUTHORIZATION_STAGENAME ='Request for Authorization';
    public static final String PROGRAMME_CONSULTATION_PROCESS_STAGENAME='Consultation process';
    public static final String PROGRAMME_VERIFICATION_VISIT_STAGENAME='Verification visit';
    public static final String PROGRAMME_DECISION_ON_AUTHORIZATION_STAGENAME='Decision on Authorization';
    
    //Added by Saurabh Singh(Epam) for IB Action Plan Item Page translation, This change is a part of this Story PRB0041417.
    
    //---------Indicates the campaign Type Authorization
    public static final String campaign_Authorization='Authorization';
    public static final String campaign_Type_Candidacy_Consultation='Candidacy Consultation';
    public static final String campaign_Type_Course_Outline_Reading='Course Outline Reading';
    public static final String campaign_Type_Request_for_authorization='Request for authorization';
    public static final String campaign_Type_Request_for_Candidacy='Request for Candidacy';
    
    //---------Indicates the campaign Status Authorization
    public static final String campaign_Status_Planned_Ready_for_Staffing='Planned / Ready for Staffing';
    public static final String campaign_Status_Staffing_in_Progress='Staffing in Progress';
    
    //---------Indicates the Account Record Type Values 
    public static final String Account_RecordType_External_PD_Provider='External PD Provider Account';
    
    //---------Indicates the contact Type Values 
    public static final String Contact_type_PD_Provider='PD Provider';
    
    //---------Indicates the Staffing Application Status Values 
    public static final String Staffing_Application_status_Not_Selected='Not Selected';
    public static final String Staffing_Application_status_Not_Approved='Not Approved';
    public static final String Staffing_Application_status_Under_Approval='Under Approval';
    public static final String Staffing_Application_status_Pending_Selection='Pending Selection';
    public static final String Staffing_Application_status_Backup='Backup';
    public static final String Staffing_Application_status_Invited='Invited';
    public static final String Staffing_Application_status_Withdrawn_by_IB='Withdrawn by IB';
    public static final String Staffing_Application_status_Withdraw_Interest='Withdraw Interest';
    
    //---------Indicates the Staffing Sub Type Values 
    public static final String Staffing_Subtype_Preliminary_Review='Preliminary Review';
    public static final String Staffing_Subtype_Evaluation='Evaluation';
    
    //Added by Suraj as a part of ECM00665 Starts
    public static final String Business_Registration= 'Business_Registration';
    public static final String Vat_HelpText= 'Vat_HelpText';
    public static final String Sales_HelpText= 'Sales_HelpText';
    public static final String Gst_HelpText= 'Gst_HelpText';
    public static final String Business_Registration_Num= 'Business_Registration_Num';
    public static final String Vat_Gst_Ent= 'Vat_Gst_Ent';
    public static final String Gst_Check= 'Gst_Check';
    public static final String Error_Message= 'Error_Message';
    public static final String Gst_Check_Dec= 'Gst_Check_Dec';
    public static final String Country_Blank= 'Country_Blank';    
    
    //---------Ib_Application_Feedback Save Feedback button translation 
    public static final String Pims_Save_Feedback='Save_Feedback';
    
    //---------Picklist Value translations for contact. 
    public static final String Ib_Application_Select_Contact ='Select_a_Contact';
    public static final String Ib_Application_Select ='Select';
    public static final String Ib_Application_New_Programme_Application ='New_Programme_Application';
    public static final String Iben_Application_ViewActionPlan ='View_Action_Plans';
    
    //---------Ib_Application_Agrrement Budget section translation 
    public static final String Ib_Agreement_Resource ='Resource';
    public static final String Ib_Agreement_Fee ='Fee';
    public static final String Ib_Agreement_Other ='Other';
    public static final String Ib_Agreement_Professional_Development ='Professional_Development';
    
    /** Added by Kashyap 692***/
    public static final String PIMS_PROGRAMME_STATUS ='Programme Status';
    public static final String PIMS_IB_PROGRAMME ='IB Programme';
    public static final String PIMS_IB_STAFF_CONTACT_INFORMATION ='IB staff contact information';
    /** Added by Kashyap ***/
    
    
    /** Added by Kashyap DAS***/
    public static final String PIMS_REMOVE_ROLE ='Remove role';
    public static final String PIMS_HEADING ='Sorry, you can\'t remove this role';
    public static final String PIMS_SUBHEADING ='Contact your Programme Coordinator or Head of School to re-assign your role of Chief Invigilator.';
    public static final String PIMS_CANCEL ='cancel';
    public static final String PIMS_BUTTONVALUE ='Send request to withdraw';
    public static final String PIMS_BUTTONRESPONSE ='Your request to withdraw from a role of Chief Invigilator was sent to Programme Coordinator at your school.';
    public static final String PIMS_DONE ='Done';
    public static final String PIMS_SUCCESSMSG ='Request Successfully Sent';
    public static final String PIMS_CI_ROLE_LIMIT_ERROR ='Chief Invigilator role limit has been reached. Remove some other contacts from this role to proceed.';
    public static final String PIMS_CHIEF_INVIGILATOR ='Chief Invigilator';
    public static final String PIMS_TOOL_TIP ='Add new contact only for Programme Coordinators, Heads of Schools, Billing Contacts, Exam Contacts, Chief Invigilators and Admin Assistants roles. All other contacts register themselves via My IB.';
    public static final String PIMS_SCHOOL_TUTORIAL ='See My School Tutorial';
    public static final String PIMS_IB_TUTORIAL ='See My IB tutorial';
    public static final String PIMS_MYP ='Middle Years Programme Contacts';
    public static final String PIMS_DP ='Diploma Years Programme Contacts';
    public static final String PIMS_PYP ='Primary Years Programme Contacts';
    public static final String PIMS_CP ='Career-related Programme Contacts';
    public static final String PIMS_UPDATE ='Update';
    public static final String PIMS_SAVING='Saving';
    public static final String PIMS_SUCCESS= 'Roles updated successfully';
    public static final String PIMS_SELECTION= 'Select one or more';
    public static final String PIMS_SELECTED= 'Selected';
    public static final String DAS_DUPLICATECONTACTINVITATIONERROR= 'This action cannot be completed. The person that you are inviting to this role already has a pending or confirmed Chief Invigilator role for this programme at your school.';
    public static final String PIMS_ADMIN1= 'Admin Assistant 1';
    public static final String PIMS_ADMIN2= 'Admin Assistant 2';
    public static final String PIMS_ADMIN3= 'Admin Assistant 3';
    
    /** Added by Kashyap DAS******/
    
    
    /*Indicates Support Case RecordTypeId*/    
    public static Id SUPPORT_CASE_RT_ID {
        get {
            if (SUPPORT_CASE_RT_ID == null) {
                SUPPORT_CASE_RT_ID = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(CASE_SUPPORT_RT).getRecordTypeId();
            }
            return SUPPORT_CASE_RT_ID;
        }
        set;
    }
    /*Indicates Support Case RecordTypeId*/    
    public static Id ROLE_INVITED_RT_ID {
        get {
            if (ROLE_INVITED_RT_ID == null) {
                ROLE_INVITED_RT_ID = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Invited').getRecordTypeId();
            }
            return ROLE_INVITED_RT_ID;
        }
        set;
    }
    
    //Added By MDK(EPAM)
    /*Method to get contact Id for System Admin from IB_View_State_Contacts__c object */
    public static IB_View_State_Contacts__c vsContact;
    
    public static User currentUser {
        get {
            if(currentUser == null) {
                currentUser = [select Id, Name, Profile.Name, Bypass_Validation_Rules__c from User where Id = :UserInfo.getUserId()];
            }
            return currentUser;
        }
        set;
    }
    
    public static String getContactIdForSystemAdmin() {
        
        String userContactId;
        Id currentUserProfileId = UserInfo.getProfileId();
        
        String profileName = [SELECT Name FROM Profile WHERE Id =: currentUserProfileId].Name;
        if(profileName== 'System Administrator'){
            if(vsContact ==null)
                vsContact = [SELECT Contact_ID__c, Account_ID__c FROM IB_View_State_Contacts__c WHERE Active__c = true LIMIT 1];
            system.debug('connnn mdk'+vsContact);
            if (vsContact != null) 
            {
                userContactId = vsContact.Contact_ID__c;
            }
        }
        return userContactId;
    }
    
    /*Method to print limit usage of Salesforce */
    public static void showLimits(String classAndMethodName){
        String limitsMessage ='\n Start -->Class And Method name: '+ classAndMethodName + '\n Total Number of SOQL Queries used in this apex code context: ' + Limits.getQueries() + '\n Total Number of records that is queried in this apex code context: ' + Limits.getDmlRows() 
            + '\n The CPU time (in milliseconds) that has been used in the current transaction: ' + Limits.getCpuTime() + '\n The approximate amount of memory (in bytes) that has been used for the heap.: ' + Limits.getHeapSize() +'\n The number of SOSL queries that have been issued.: ' + Limits.getSoslQueries() + '\n The number of records that have been returned by issuing SOQL queries.: ' + Limits.getQueryRows() + '\n End -->Class And Method name: '+classAndMethodName ; 
        
        System.debug('------------------------------------------------------------------------------------');
        System.debug('Start -->Class And Method name: '+classAndMethodName);
        System.debug('Total Number of SOQL Queries used in this apex code context: ' + Limits.getQueries());
        System.debug('Total Number of records that is queried in this apex code context: ' + Limits.getDmlRows());
        System.debug('The CPU time (in milliseconds) that has been used in the current transaction: ' + Limits.getCpuTime());
        System.debug('The approximate amount of memory (in bytes) that has been used for the heap.: ' + Limits.getHeapSize());
        System.debug('The number of SOSL queries that have been issued.: ' + Limits.getSoslQueries());
        System.debug('The number of records that have been returned by issuing SOQL queries.: ' + Limits.getQueryRows());
        System.debug('End -->Class And Method name: '+classAndMethodName);
        System.debug('------------------------------------------------Sau------------------------------------');
        Logger.get().add(limitsMessage, LogSeverity.Info).publish();
    }
}