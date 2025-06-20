public class ApplicationService {
    
    public static IB_Application__c application = null;
    public static Boolean isApplicationCached = false;
    public static Boolean isApplicationBySectionCached = false;
    public static Boolean isMultiProgApplicationsCached = false;
    
    public static List<IB_Application__c> applications = null;
    public static List<IB_Application__c> multiProgApplications = null;
    public static Boolean isApplicationsCached = false;
    
    public static List<Roles_and_Applications_Subject_Proposal__c> subjectProposals = null;
    public static Boolean isSubjectProposalsCached = false;
    
    public static List<IB_Application_Curriculum_Requirement__c> applicationRequirements = null;
    public static Boolean isApplicationRequirementsCached = false;
    
    public static IB_Application_Assessment__c applicationAssessment = null;
    
	public static Id applicationId {get;set;}
    public static Id programmeId = null;
    public static List<Id> programmeIdList = null;
    
    public static IB_Application__c getApplication() {
        try
        {
            if (!isApplicationCached) {
                
                if (applicationId == null) {
                    throw new CustomValidationException(Label.PIMS_INVALID_APPID);
                }
                
                ApplicationDAO dao = ApplicationDAO.getInstance();
                application = dao.getApplicationById(applicationId);
                
                ApplicationAssessmentDAO assessmentDAO = ApplicationAssessmentDAO.getInstance();
                applicationAssessment = assessmentDAO.getAppAssessmentByAppId(applicationId);
                
                isApplicationCached = true;
            }
            
            return application;
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
    }
    
    public static IB_Application__c getApplicationBySection(String appSection) {
        
        try
        {
        if (!isApplicationBySectionCached) {
            
            if (applicationId == null) {
                throw new CustomValidationException('The value for applicationId cannot be null.');
            }
            
            ApplicationDAO dao = ApplicationDAO.getInstance();
            application = dao.getApplicationById(applicationId, appSection); //dao.getApplicationBySectionAndId(applicationId, appSection);
            
            ApplicationAssessmentDAO assessmentDAO = ApplicationAssessmentDAO.getInstance();
            applicationAssessment = assessmentDAO.getAppAssessmentByAppId(applicationId, appSection);
            
            isApplicationBySectionCached = true;
            
        }
        
        return application;
        }
        catch(exception x)
        {
            System.debug('excp'+x);
            return NULL;
            
        }
        
    }
    
    public static List<IB_Application__c> getApplications() {
        
        if (!isApplicationsCached) {
            
            if (programmeId == null) {
                throw new CustomValidationException('The value for programmeId cannot be null.');
            }
            
            ApplicationDAO dao = ApplicationDAO.getInstance();
            applications = dao.getApplicationsByProgrammeId(programmeId);
            isApplicationsCached = true;
            
        }
        
        return applications;
    }
    
    public static List<IB_Application__c> getAllFieldsApplications() {
        
        if (!isApplicationsCached) {
            
            if (programmeId == null) {
                throw new CustomValidationException('The value for programmeId cannot be null.');
            }
            
            ApplicationDAO dao = ApplicationDAO.getInstance();
            applications = dao.getAllFieldsApplicationsByProgrammeId(programmeId);
            isApplicationsCached = true;
            
        }
        
        return applications;
    }
    public static IB_Application__c getAfcByProgrammeId()
    {
        if (programmeId == null) 
            throw new CustomValidationException('The value for programmeId cannot be null.');
        ApplicationDAO dao = ApplicationDAO.getInstance();        
        return dao.getAfcByProgrammeId(programmeId);  
    }
    public static List<IB_Application__c> getApplicationsByProgrammeIds() {
        
        if (!isMultiProgApplicationsCached) {
            
            if (programmeIdList == null) {
                throw new CustomValidationException('The value for programmeIdList cannot be null.');
            }
            
            ApplicationDAO dao = ApplicationDAO.getInstance();
            multiProgApplications = dao.getApplicationsByProgrammeIdList(programmeIdList);
            isMultiProgApplicationsCached = true;
        }
        
        return multiProgApplications;
    }
    
    public static IB_Application_Assessment__c getApplicationAssessment() {
        
        if (applicationAssessment == null) {
            getApplication();
        }
        
        return applicationAssessment;
    }
    
    public static List<Roles_and_Applications_Subject_Proposal__c> getSubjectProposals() {
        
        if (!isSubjectProposalsCached) {
            
            if (applicationId == null) {
                throw new CustomValidationException('The value for applicationId cannot be null.');
            }
            
            SubjectProposalDAO dao = SubjectProposalDAO.getInstance();
            subjectProposals = dao.getProposalsByApplicationId(applicationId);
            isSubjectProposalsCached = true;
            
        }
        
        return subjectProposals;
    }
    
    public static List<IB_Application_Curriculum_Requirement__c> getApplicationRequirements() {
        
        if (!isApplicationRequirementsCached) {
            
            if (applicationId == null) {
                throw new CustomValidationException('The value for applicationId cannot be null.');
            }
            
            //ApplicationRequirementsDAO dao = ApplicationRequirementsDAO.getInstance();
            //applicationRequirements = dao.getRequirementsByApplicationId(applicationId);
            applicationRequirements = [SELECT Id,Programme_Requirements__c,Programme_Requirements_Locales__c,PYP_Years__c,MYP_Years__c,DP_years__c,CP_years__c FROM IB_Application_Curriculum_Requirement__c WHERE IB_Application__c = :applicationId ORDER BY CP_years__c];
            isApplicationRequirementsCached = true;
            
        }
        
        return applicationRequirements;
    }
    
    public static void setApplicationId(Id appId) {
        applicationId = appId;
    }
    
    public static void setProgrammeId(Id progId) {
        programmeId = progId;
    }
    
    public static void setProgrammeIdList(List<Id> progIds){
        
        System.debug(LoggingLevel.ERROR, 'progIds.size() : ' + progIds.size());
        programmeIdList = progIds;
        System.debug(LoggingLevel.ERROR, 'programmeIdList.size() : ' + programmeIdList.size());
    }

}