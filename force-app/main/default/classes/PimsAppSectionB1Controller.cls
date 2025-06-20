public class PimsAppSectionB1Controller extends PimsApplicationControllerHelper {

     public String appId;
     public String accId;
     public String progId;

     public String activeTab {get;set;}
     public String activeComponent {get;set;}
     public String redirectUrl {get;set;}
     public String lsCompletionStatus {get;set;}
     public String rsCompletionStatus {get;set;}

     public String coordinatorTimeId {get;set;}
     public String meetingId {get;set;}
     public String facilityId {get;set;}
     public String libraryId {get;set;}
     public String staffId {get;set;}
     public String deleteAttId {get;set;}

     public Decimal pcTimeAllocTotal {get;set;}
     public Decimal slcTimeAllocTotal {get;set;}

     public IB_Application__c application {get;set;}
     public IB_Application_Assessment__c assessment {get;set;}
     @TestVisible private IB_Programme__c programme;
     public boolean otherLanguage{get;set;}

     public Application_Coordinator_Time__c coordinatorTime {get;set;}
     public List<Application_Coordinator_Time__c> progCoordinatorTimeList {get;set;}
     public List<Application_Coordinator_Time__c> serviceCoordinatorTimeList {get;set;}

     public Application_Library_Resources__c library {get;set;}
     public List<Application_Library_Resources__c> applicationLibraryList {get;set;}

     public Application_Account_Facilities__c facility {get;set;}
     public List<Application_Account_Facilities__c> applicationFacilityList {get;set;}

     public Application_Teaching_Time__c applicationTeachingTime {get;set;}
     public List<Application_Teaching_Time__c> applicationTeachingTimeList {get;set;}

     public List<Application_Staff_Table__c> applicationStaffTableList {get;set;}
     public Application_Staff_Table__c staffTable {get;set;}

     public Application_Meeting_Chart__c meeting {get;set;}
     public List<Application_Meeting_Chart__c> applicationMeetingList {get;set;}

     public List<IB_Role__c> rolesByProgramme {get;set;}
     public List<Role_Application_Subject__c> subjectsByRoles {get;set;}
     public List<Roles_and_Applications_Subject_Proposal__c> subjectProposals {get;set;}
     public List<Contact_Professional_Development__c> proDevByRoles { get; set; }

     public transient List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps;

     public List<Roles_and_Applications_Subject_Proposal__c> getStandardSubjectProps(){
         try
         {

        // Could be a UX issue if user checks boxes and then invokes a different
        // page action that calls this getter again.  minor risk.
        standardSubjectProps = new List<Roles_and_Applications_Subject_Proposal__c>();

        for(Roles_and_Applications_Subject_Proposal__c tmp : subjectProposals){

            if(tmp.Subject_Level__c == 'Standard'){
                standardSubjectProps.add(tmp);
            }
        }

        return standardSubjectProps;
         }
         Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
     }


     public PimsAppSectionB1Controller() {
try
{
        appId = ApexPages.currentPage().getParameters().get('id');
        system.debug('appId =====> '+appId);

        if (appId == null) throw new CustomValidationException('The application ID is invalid.');

        PageService.setPage(getApplicationPageName());
        activeTab = PageService.getActiveTab();
        system.debug('activeTab =====> '+activeTab);

        if (activeTab == 'sectionb1') {
        
	        PageService.isTabLoaded = true;
	
	        if (appId == null) throw new CustomValidationException('The application ID is invalid.');
	
	        ApplicationService.setApplicationId(appId);
	        application = ApplicationService.getApplicationBySection(activeTab);
	        assessment = ApplicationService.getApplicationAssessment();
	
	        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
	        programme = ProgrammeService.getProgramme();
	
	        otherLanguage = false;
            if (programme.Primary_Language_of_Instruction__c != 'English' && programme.Primary_Language_of_Instruction__c != 'Spanish' && programme.Primary_Language_of_Instruction__c != 'French' && programme.Primary_Language_of_Instruction__c != null) {
                otherLanguage = true;
            }
            if (programme.Secondary_Language_of_Instruction__c != 'English' && programme.Secondary_Language_of_Instruction__c != 'Spanish' && programme.Secondary_Language_of_Instruction__c != 'French' && programme.Secondary_Language_of_Instruction__c != null) {
                otherLanguage = true;
            }
            if (programme.PR_5_Third_Language__c != 'English' && programme.PR_5_Third_Language__c != 'Spanish' && programme.PR_5_Third_Language__c != 'French' && programme.PR_5_Third_Language__c != null) {
                otherLanguage = true;
            }
            if (programme.PR_5_Fourth_Language__c != 'English' && programme.PR_5_Fourth_Language__c != 'Spanish' && programme.PR_5_Fourth_Language__c != 'French' && programme.PR_5_Fourth_Language__c != null) {
                otherLanguage = true;
            }


	        /*if (programme.Primary_Language_of_Instruction__c.contains('English','Spanish','French') || programme.Primary_Language_of_Instruction__c == 'Spanish' || programme.Primary_Language_of_Instruction__c == 'French' || programme.Secondary_Language_of_Instruction__c == 'English' || programme.Secondary_Language_of_Instruction__c == 'Spanish' || programme.Secondary_Language_of_Instruction__c == 'French' || programme.PR_5_Third_Language__c == 'English' || programme.PR_5_Third_Language__c == 'Spanish' || programme.PR_5_Third_Language__c == 'French' || programme.PR_5_Fourth_Language__c == 'English' || programme.PR_5_Fourth_Language__c == 'Spanish' || programme.PR_5_Fourth_Language__c == 'French'){
	           otherLanguage = false;
	        }
	        else {
	           otherLanguage = true;
	        }*/
	
	        accId = programme.account__c;
	        progId = programme.Id;
	
	        coordinatorTime = new Application_Coordinator_Time__c(IB_Application_Lookup__c = appId);
	        meeting = new Application_Meeting_Chart__c(IB_Application_Lookup__c = appId);
	        library = new Application_Library_Resources__c(IB_Application_Lookup__c = appId);
	        facility = new Application_Account_Facilities__c(Account__c = accId,IB_Application_Lookup__c = appId);
	        staffTable = new Application_Staff_Table__c(IB_Application_Lookup__c = appId);
	        applicationTeachingTime = new Application_Teaching_Time__c(IB_Application_Lookup__c = appId);
	
	        progCoordinatorTimeList = [
	           SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c,
	           B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
	           FROM Application_Coordinator_Time__c
	           WHERE IB_Application_Lookup__c = :appId AND Type__c = 'Programme coordinator'
	        ];
	        pcTimeAllocTotal = 0;
	        for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
	           if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
	           if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
	           if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
	           if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
	        }
        
        }
}
         Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

     }

     /*saves b1 and b2 pages*/
     public PageReference save() {

        system.debug('lsCompletionStatus =====> '+lsCompletionStatus);
        system.debug('rsCompletionStatus =====> '+rsCompletionStatus);

        try {

            if (String.isNotEmpty(lsCompletionStatus)) application.AFC_Leadership_Structure_Status__c = lsCompletionStatus;
            if (String.isNotEmpty(rsCompletionStatus)) application.AFC_Resources_Support_Status__c = rsCompletionStatus;
            update application;
            update assessment;

            if(standardSubjectProps != null && !standardSubjectProps.isEmpty()){
                update standardSubjectProps;
            }

            if (activeTab == 'sectionb1') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B1_Saved));
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=sectionb2';
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B2_Saved));
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=sectionc1';
            }
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving +ex));
            return null;
        }
        return null;
     }


     public PageReference saveTeachingTime() {

        try {
            insert applicationTeachingTime;

            // Must query data for the table again to ensure deleted rows no longer appear on the page
            applicationTeachingTimeList = [
                SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
                B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
                FROM Application_Teaching_Time__c
                WHERE IB_Application_Lookup__c = :appId
            ];

            applicationTeachingTime = new Application_Teaching_Time__c(IB_Application_Lookup__c = appId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Teaching_Time_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Teaching_time_error +ex));
            return null;
        }
        return null;
     }

     public PageReference updateTeachingTime() {
try {
        redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=sectionb2';
        
            update applicationTeachingTimeList;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Teaching_Time_Updated));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
     }

     public PageReference removeTeachingTime() {
try {
        PageReference pageRef = ApexPages.currentPage();
        system.debug('In removeTeachingTime =====>'+deleteAttId);

        
            Application_Teaching_Time__c attToDelete = new Application_Teaching_Time__c();
            attToDelete.Id = deleteAttId;

            delete attToDelete;

            // Must query data for the table again to ensure deleted rows no longer appear on the page
            applicationTeachingTimeList = [
                SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
                B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
                FROM Application_Teaching_Time__c
                WHERE IB_Application_Lookup__c = :appId
            ];

            if (activeTab == 'sectionb2') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Teaching Time was successfully removed.'));
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=budget';
            }
        }
        catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Teacher_time_remove +ex));
            return null;
        }
        return null;
     }


     public PageReference saveCoordinatorTime() {

        try {

            if (activeComponent == 'sectionb1') coordinatorTime.Type__c = 'Programme coordinator';
            if (activeComponent == 'sectionb2' && getIsCp()) coordinatorTime.Type__c = 'Service learning coordinator';
            if (activeComponent == 'sectionb2' && getIsDp()) coordinatorTime.Type__c = 'CAS coordinator';
            insert coordinatorTime;

            pcTimeAllocTotal = 0;
            slcTimeAllocTotal = 0;

            progCoordinatorTimeList = [
                SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c,
                B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                FROM Application_Coordinator_Time__c
                WHERE IB_Application_Lookup__c = :appId AND Type__c = 'Programme coordinator'
            ];
            for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
                if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
                if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
                if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
            }
            serviceCoordinatorTimeList = [
                SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
                Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                FROM Application_Coordinator_Time__c
                WHERE IB_Application_Lookup__c = :appId
                AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS coordinator')
            ];
            for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
                if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
            }

            coordinatorTime = new Application_Coordinator_Time__c(IB_Application_Lookup__c = appId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Coordinator_time_saved));

        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Saving_Coordinator +ex));
            return null;
        }
        return null;
     }

     public PageReference updateCoordinatorTime() {

        try {

            if (activeComponent == 'sectionb1') update progCoordinatorTimeList;
            if (activeComponent == 'sectionb2') update serviceCoordinatorTimeList;

            pcTimeAllocTotal = 0;
            slcTimeAllocTotal = 0;
			if(progCoordinatorTimeList != null){
				for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
					if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
					if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
					if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
					if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
				}
			}
			if(serviceCoordinatorTimeList != null){
				for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
					if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
					if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
				}
			}
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Coordinator_time_updated));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Edit_Coordinator +ex));
            return null;
        }
        return null;
     }

     public PageReference removeCoordinatorTime() {

        try {
            Application_Coordinator_Time__c timeToRemove = new Application_Coordinator_Time__c();
            timeToRemove.Id = coordinatorTimeId;

            delete timeToRemove;

            pcTimeAllocTotal = 0;
            slcTimeAllocTotal = 0;

            progCoordinatorTimeList = [
                SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c,
                B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                FROM Application_Coordinator_Time__c
                WHERE IB_Application_Lookup__c = :appId AND Type__c = 'Programme coordinator'
            ];
            for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
                if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
                if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
                if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
            }
            serviceCoordinatorTimeList = [
                SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
                Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
                FROM Application_Coordinator_Time__c
                WHERE IB_Application_Lookup__c = :appId
                AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS coordinator')
            ];
            for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
                if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Coordinator_time_updated));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Remove_Coordinator +ex));
            System.debug(logginglevel.ERROR, ex);
            return null;
        }
        return null;
     }


     public PageReference saveMeeting() {

        try {
            insert meeting;

            applicationMeetingList = [
            SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Meeting_Chart__c
            WHERE IB_Application_Lookup__c = :appId
            ];

            meeting = new Application_Meeting_Chart__c(IB_Application_Lookup__c = appId);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Meeting_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Meeting +ex));
            return null;
        }
        return null;
     }

     public PageReference updateMeeting() {

        try {
            update applicationMeetingList;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Meeting_Updated));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Meeting +ex));
            return null;
        }
        return null;
     }

     public PageReference removeMeeting() {

        try {
            Application_Meeting_Chart__c meetingToRemove = new Application_Meeting_Chart__c();
            meetingToRemove.Id = meetingId;

            delete meetingToRemove;

            applicationMeetingList = [
            SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
            FROM Application_Meeting_Chart__c
            WHERE IB_Application_Lookup__c = :appId
            ];

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Meeting_Updated));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_removing_Meeting +ex));
            return null;
        }
        return null;
     }


     public PageReference saveFacility() {

        try {
            insert facility;

            applicationFacilityList = [
                
             
    // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
//begin 
                
                /*SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId*/
 //End               
              SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId
                
            ];

            facility = new Application_Account_Facilities__c(Account__c = accId,IB_Application_Lookup__c = appId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Facility_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Facility +ex));
            return null;
        }
        return null;
     }

     public PageReference updateFacility() {

        try {
            update applicationFacilityList;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Facility_Saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Facility +ex));
            return null;
        }
        return null;
     }

     public PageReference removeFacility() {

        try {
            Application_Account_Facilities__c facilityToRemove = new Application_Account_Facilities__c();
            facilityToRemove.Id = facilityId;

            delete facilityToRemove;

            applicationFacilityList = [
                
    // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
//begin 
                
                /*SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId*/
  //End              
                SELECT Id, IB_Application_Lookup__c, Account__c,B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId
                
                
            ];

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Meeting_Updated));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error removing Facility '+ex));
            return null;
        }
        return null;
     }


     public PageReference saveLibrary() {

        try {
            insert library;

            applicationLibraryList= [
                SELECT B2_6_6_Additional_resources__c, B2_6_6_Fiction_Books__c, B2_6_6_General_Reference__c, B2_6_6_Languages__c, B2_6_6_Nonfiction_Books__c,
                B2_6_6_Online_Journals__c, B2_6_6_Online_Reference__c, B2_6_6_Print_Periodicals__c, IB_Application_Lookup__c, Id, Name
                FROM Application_Library_Resources__c
                WHERE IB_Application_Lookup__c =  :appId
            ];

            library = new Application_Library_Resources__c(IB_Application_Lookup__c = appId);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Library_Resource_saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Library +ex));
            return null;
        }
        return null;
     }

     public PageReference updateLibrary() {

        try {
            update applicationLibraryList;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Library_Resource_saved));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_saving_Library +ex));
            return null;
        }
        return null;
     }

     public PageReference removeLibrary() {

        try {
            Application_Library_Resources__c libraryToRemove = new Application_Library_Resources__c();
            libraryToRemove.Id = libraryId;

            delete libraryToRemove;

            applicationLibraryList= [
                SELECT B2_6_6_Additional_resources__c, B2_6_6_Fiction_Books__c, B2_6_6_General_Reference__c, B2_6_6_Languages__c, B2_6_6_Nonfiction_Books__c,
                B2_6_6_Online_Journals__c, B2_6_6_Online_Reference__c, B2_6_6_Print_Periodicals__c, IB_Application_Lookup__c, Id, Name
                FROM Application_Library_Resources__c
                WHERE IB_Application_Lookup__c =  :appId
            ];

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Coordinator Time was updated successfully.'));
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_removing_Library +ex));
            return null;
        }
        return null;
     }
    
}