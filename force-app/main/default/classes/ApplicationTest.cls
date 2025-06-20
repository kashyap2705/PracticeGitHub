@isTest
private class ApplicationTest {
    
    @isTest 
    static void testApplicationService() {
        
        IB_Application__c app = PimsTestUtil.createApplication();
        insert app;
        
        try {
            ApplicationService.getApplication();
        } catch (Exception ex) {}
        try {
            ApplicationService.getApplicationBySection('sectiona');
        } catch (Exception ex) {}
        try {
            ApplicationService.getApplications();
        } catch (Exception ex) {}
        try {
            ApplicationService.getSubjectProposals();
        } catch (Exception ex) {}
        try {
            ApplicationService.getApplicationRequirements();
        } catch (Exception ex) {}
        
        ApplicationService.setApplicationId(app.Id);
        ApplicationService.setProgrammeId(app.Application_Lookup_to_Programme__c);
        
        ApplicationService.getApplication();
        ApplicationService.getApplications();
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectiona');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionb1');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionb2');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionc1');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionc2');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionc3');
        ApplicationService.getApplicationAssessment();
        
        ApplicationService.isApplicationBySectionCached = false;
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationBySection('sectionc4');
        ApplicationService.getApplicationAssessment();   
        
        ApplicationService.applicationAssessment = null;
        ApplicationService.getApplicationAssessment(); 
        
        ApplicationService.getSubjectProposals();
        ApplicationService.getApplicationRequirements();
        
    }

}