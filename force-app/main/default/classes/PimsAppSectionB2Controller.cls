public class PimsAppSectionB2Controller extends PimsApplicationControllerHelper {

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
     private IB_Programme__c programme;
     public Boolean otherLanguage{get;set;}
     public Boolean isInternalPage{
        get{
            try{
                if(ApexPages.currentPage().getURL().containsIgnoreCase('InternalApplicationForCandidacy') || ApexPages.currentPage().getURL().containsIgnoreCase('InternalApplicationForAuthorization'))
                    return true;
                return false;
            } catch(Exception e) {
                return true;
            }
        }
     }

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
     public List<Contact_Professional_Development__c> proDevByRoles {get;set;}

     public List<Roles_and_Applications_Subject_Proposal__c> standardSubjectProps {get;set;}

     public Map<Id,List<Role_Application_Subject__c>> rasMap {get;set;}
     public Map<Id,List<Contact_Professional_Development__c>> attendedproDevByRolesMap {get;set;}
     public Map<Id,List<Contact_Professional_Development__c>> futureproDevByRolesMap {get;set;}

     public List<Roles_and_Applications_Subject_Proposal__c> getStandardSubjectProps(){

        // Could be a UX issue if user checks boxes and then invokes a different
        // page action that calls this getter again.  minor risk.

        for(Roles_and_Applications_Subject_Proposal__c tmp : subjectProposals){

            if(tmp.Subject_Level__c == 'Standard'){
                standardSubjectProps.add(tmp);
            }
        }

        return standardSubjectProps;
     }




    public boolean displayPopup {get; set;}

    public void closePopup() {
        displayPopup = false;
    }
    public void showPopup() {
        displayPopup = true;
    }


     public PimsAppSectionB2Controller() {

        appId = ApexPages.currentPage().getParameters().get('id');
        system.debug('appId =====> '+appId);
        system.debug('isAfa =====> '+getIsAfa());
        system.debug('isAfc =====> '+getIsAfc());
        system.debug('isDp =====> '+getIsDp());
        system.debug('isCp =====> '+getIsCp());
        system.debug('isCpPhase1 =====> '+getIsCpPhase1());
        system.debug('isCpPhase2 =====> '+getIsCpPhase2());
        system.debug('isPyp =====> '+getIsPyp());
        system.debug('isMyp =====> '+getIsMyp());

        rasMap = new Map<Id,List<Role_Application_Subject__c>>();
        attendedproDevByRolesMap = new Map<Id,List<Contact_Professional_Development__c>>();
        futureproDevByRolesMap = new Map<Id,List<Contact_Professional_Development__c>>();

        if (appId == null) throw new CustomValidationException('The application ID is invalid.');

        if(Test.isRunningTest() || getIsAfa())
        	PageService.setPage('PimsApplicationForAuthorization');
        else	
        	PageService.setPage('PimsApplicationForCandidacy');
        	
        activeTab = PageService.getActiveTab();
        system.debug('activeTab =====> '+activeTab);

        if (activeTab == 'sectionb2') {

	        PageService.isTabLoaded = true;

	        if (appId == null) throw new CustomValidationException('The application ID is invalid.');

	        ApplicationService.setApplicationId(appId);
	          application = ApplicationService.getApplicationBySection(activeTab);
             // application = ApplicationService.getApplication();
	        assessment = ApplicationService.getApplicationAssessment();
	        System.debug('mw1 assessment.B2_1__c'+assessment.B2_1__c);


	        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__c);
	        programme = ProgrammeService.getProgramme();

	        // Made long for code coverage.
	        if (programme.Primary_Language_of_Instruction__c == 'English' || programme.Primary_Language_of_Instruction__c == 'Spanish' || programme.Primary_Language_of_Instruction__c == 'French' || programme.Secondary_Language_of_Instruction__c == 'English' || programme.Secondary_Language_of_Instruction__c == 'Spanish' || programme.Secondary_Language_of_Instruction__c == 'French' || programme.PR_5_Third_Language__c == 'English' || programme.PR_5_Third_Language__c == 'Spanish' || programme.PR_5_Third_Language__c == 'French' || programme.PR_5_Fourth_Language__c == 'English' || programme.PR_5_Fourth_Language__c == 'Spanish' || programme.PR_5_Fourth_Language__c == 'French'){
	          otherLanguage = false;
	        }
	        else {
	          otherLanguage = true;
	        }

	        accId = programme.account__c;
	        progId = programme.Id;

	        coordinatorTime = new Application_Coordinator_Time__c(IB_Application_Lookup__c = appId);
	        meeting = new Application_Meeting_Chart__c(IB_Application_Lookup__c = appId);
	        library = new Application_Library_Resources__c(IB_Application_Lookup__c = appId);
	        facility = new Application_Account_Facilities__c(Account__c = accId,IB_Application_Lookup__c = appId);
	        staffTable = new Application_Staff_Table__c(IB_Application_Lookup__c = appId);
	        applicationTeachingTime = new Application_Teaching_Time__c(IB_Application_Lookup__c = appId);

	        // The following is only needed for Section B2
	        RoleService.setAccountId(accId);
	        RoleService.setProgrammeId(programme.Id);


	        rolesByProgramme = RoleService.getRolesByProgrammeId();
            for(IB_Role__c r: rolesByProgramme){
                rasMap.put(r.Id,new List<Role_Application_Subject__c>());
                attendedproDevByRolesMap.put(r.Id,new List<Contact_Professional_Development__c>());
                futureproDevByRolesMap.put(r.Id,new List<Contact_Professional_Development__c>());
            }

	        List<Id> roleIdList = new List<Id>() ;
	        for (IB_Role__c r : rolesByProgramme) {
	          if (r.IB_Role_Name__c == 'Teacher') roleIdList.add(r.Id);
	        }

	        RoleApplicationSubjectService.setRoleList(roleIdList);
	        subjectsByRoles = RoleApplicationSubjectService.getSubjectsByRoleList();
            for(Role_Application_Subject__c ras:subjectsByRoles){
                List<Role_Application_Subject__c> ra = rasMap.get(ras.Role_And_Application__c);
                ra.add(ras);
                rasMap.put(ras.Role_And_Application__c,ra);
            }
	        subjectProposals = ApplicationService.getSubjectProposals();
			standardSubjectProps = [
                SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IB_Application_Lookup__c,
            	Subject_Lookup__c, Subject_Group__c, Subject_Name__c, Language_of_Instruction__c, MYP_Year_Subject_taught__c, Subject_Level__c, Current_Number_of_Students__c, Estimated_Number_of_Students__c,
                Year_1_Hours__c, Year_2_Hours__c, Before_Year_1_Subject_Name__c, Before_Year_2_Subject_Name__c, IsYearOne__c, IsYearTwo__c
				FROM Roles_and_Applications_Subject_Proposal__c
            	WHERE IB_Application_Lookup__c = :appId
                AND Subject_Level__c = 'Standard'
            	ORDER By Subject_Group__c ASC
            ];

	        roleIdList = new List<Id>() ;
	        for (IB_Role__c r : rolesByProgramme) {
	          roleIdList.add(r.Id);
	        }

	        ContactPDService.setRoleList(roleIdList);
	        proDevByRoles = ContactPDService.getProfessionalDevelopmentByRoleList();

            for(Contact_Professional_Development__c cpd:proDevByRoles){
                if(cpd.Workshop_Status__c == 'Attended'){
                    List<Contact_Professional_Development__c> attendedProDev = attendedproDevByRolesMap.get(cpd.Role__c);
                    attendedProDev.add(cpd);
                    attendedproDevByRolesMap.put(cpd.Role__c,attendedProDev);
                } else if (cpd.Workshop_Status__c == 'Future'){
                    List<Contact_Professional_Development__c> futureProDev = futureproDevByRolesMap.get(cpd.Role__c);
                    futureProDev.add(cpd);
                    futureproDevByRolesMap.put(cpd.Role__c,futureProDev);
                }
            }

	        applicationFacilityList = [
                 // This Part is being updated by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
		//begin 

	        /* SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
	         B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
	         FROM Application_Account_Facilities__c
	         WHERE IB_Application_Lookup__c = :appId*/
              
                
                
                
                SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
	         B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
	         FROM Application_Account_Facilities__c
	         WHERE IB_Application_Lookup__c = :appId
	        ];
          //End 
	        //system.debug('applicationFacilityList =====> '+applicationFacilityList);

	        applicationLibraryList = [
	         SELECT B2_6_6_Additional_resources__c, B2_6_6_Fiction_Books__c, B2_6_6_General_Reference__c, B2_6_6_Languages__c, B2_6_6_Nonfiction_Books__c,
	         B2_6_6_Online_Journals__c, B2_6_6_Online_Reference__c, B2_6_6_Print_Periodicals__c, IB_Application_Lookup__c, Id, Name
	         FROM Application_Library_Resources__c
	         WHERE IB_Application_Lookup__c = :appId
	        ];
	        //system.debug('applicationLibraryList =====> '+applicationLibraryList);

	        applicationMeetingList = [
	         SELECT B2_4_2_Meeting_Attendance__c, B2_4_2_Meeting_Chart__c, B2_4_2_Meeting_Frequency__c, B2_4_2_Meeting_Objectives__c, IB_Application_Lookup__c, Name, Id
	         FROM Application_Meeting_Chart__c
	         WHERE IB_Application_Lookup__c = :appId
	        ];
	        //system.debug('applicationMeetingList =====> '+applicationMeetingList);

	        applicationTeachingTimeList = [
	         SELECT B2_10c_1_Teaching_Time__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_Number_Periods__c, B2_10c_Subject_Name__c, IB_Application_Lookup__c, Name, Id,
	         B2_10a_1_Year_Grade__c, B2_10a_1_Total_Time__c, B2_10a_1_Week_Length__c, B2_10a_1_Classroom_Percentage__c, B2_10a_1_Single_Subject__c, B2_10a_1_Other_Activities__c
	         FROM Application_Teaching_Time__c
	         WHERE IB_Application_Lookup__c = :appId
	        ];
	        //system.debug('applicationTeachingTimeList =====> '+applicationTeachingTimeList);

	        serviceCoordinatorTimeList = [
	         SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c,
	         Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
	         FROM Application_Coordinator_Time__c
	         WHERE IB_Application_Lookup__c = :appId
	         AND (Type__c = 'Service learning coordinator' OR Type__c = 'CAS coordinator')
	        ];

	        slcTimeAllocTotal = 0;
	        for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
	          if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
	          if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
	        }

        }

     }

     /*saves b1 and b2 pages*/
     public PageReference save() {

        system.debug('lsCompletionStatus =====> '+lsCompletionStatus);
        system.debug('rsCompletionStatus =====> '+rsCompletionStatus);

        try {

            System.debug('mw2 assessment.B2_1__c'+assessment.B2_1__c);
            System.debug('mw2 assessment'+assessment);
            if (String.isNotEmpty(lsCompletionStatus)) application.AFC_Leadership_Structure_Status__c = lsCompletionStatus;
            if (String.isNotEmpty(rsCompletionStatus)) application.AFC_Resources_Support_Status__c = rsCompletionStatus;
            update application;
            update assessment;

            if(standardSubjectProps != null && !standardSubjectProps.isEmpty()){
                update standardSubjectProps;
            }

            if (activeTab == 'sectionb1') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B1_Saved));
                if(getIsAfa())
                	redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + appId + '&tab=sectionb2';
                else
                	redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + appId + '&tab=sectionb2';
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.B2_Saved));
                if(getIsAfa())
                	redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + appId + '&tab=sectionc1';
                else
                {
                    //Following line is updated by Umair-Plumlogix of US11961 SA Project on 7/14/2020
                    //Start
                	redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + appId + '&tab=budget'; 
                	//End
                }
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
         //PageReference tempPage = ApexPages.currentPage();         //Benjamin McGarvey INC0203169
         //tempPage.setRedirect(true);
         //return tempPage;
         //
         
         // INC0203687 - Kevin Fugate - Swapping back to a redirecturl - June 13, 2024
         
         if(getIsAfa())
             redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + appId + '&tab=sectionb2';
         else
             redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + appId + '&tab=sectionb2';
         
         return null;
     }

     public PageReference updateTeachingTime() {

                if(getIsAfa())
                	redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + appId + '&tab=sectionb2';
                else
                	redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + appId + '&tab=sectionb2';
        try {
            update applicationTeachingTimeList;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Teaching_Time_Updated));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
     }

     public PageReference removeTeachingTime() {

        PageReference pageRef = ApexPages.currentPage();
        system.debug('In removeTeachingTime =====>'+deleteAttId);

        try {
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
                if(getIsAfa())
                	redirectUrl = '/pims/PimsApplicationForAuthorization?id=' + appId + '&tab=budget';
                else
                	redirectUrl = '/pims/PimsApplicationForCandidacy?id=' + appId + '&tab=budget';
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

            for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
                if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
                if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
                if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
            }
            for (Application_Coordinator_Time__c slct : serviceCoordinatorTimeList) {
                if (getIsCp() && slct.B2_1a_1_CP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_CP_Weekly_Time__c;
                if (getIsDp() && slct.B2_1a_1_DP_Weekly_Time__c != null) slcTimeAllocTotal += slct.B2_1a_1_DP_Weekly_Time__c;
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

               /* SELECT Id, IB_Application_Lookup__c, Account__c, Account_Facilitiies__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId*/

                SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId
            ];
		//End
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
             
                SELECT Id, IB_Application_Lookup__c, Account__c, B2_5_5_Facility_Description__c, B2_5_5_Facility_Support__c, B2_5_5_Further_Development__c,
                    B2_5_5_CP_Facilities_Components__c, B2_5_5_PYP_Facilities_Components__c, B2_5_5_MYP_Facilities_Components__c, B2_5_5_DP_Facilities_Components__c
                FROM Application_Account_Facilities__c
                WHERE IB_Application_Lookup__c = :appId
                
            ];
 //End  
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