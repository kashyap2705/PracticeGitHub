public virtual class PimsFeedbackHelper{
    
    public IB_Application_Feedback__c pimsApplicationFeedback { get; set; }
    public String appId { get; set; }
    public  String fbId { get; set; }
    
    
    public PimsFeedbackHelper(){
        try
        {
            fbId = ApexPages.currentPage().getParameters().get('id');
            
            pimsApplicationFeedback = [
                SELECT Id, FB_Lookup_IB_Application__c FROM IB_Application_Feedback__c WHERE Id = :fbId
            ];
            
            
            appId = pimsApplicationFeedback.FB_Lookup_IB_Application__c;
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            
        }
    }
    
    public virtual Boolean getIsEditable() {
        
        List<String> editProfileNames = new List<String>();
        editProfileNames.add('System Administrator');
        //TODO : Add any names here, like 'System Administrator' above, if they CAN edit the AfC's Feedback Application
        editProfileNames.add('SCU + Advanced');
        editProfileNames.add('SCU + Basic');
        
        Profile currProfile = [ SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1 ];
        
        for (String name : editProfileNames) {
            if (name == currProfile.Name) {
                return true;
            }
        }
        
        return false; 
    }
    
    public virtual Boolean getIsPyp() {
        try
        {
            
            ApplicationService.setApplicationId(appId);
            IB_Application__c application = ApplicationService.getApplication();
            
            ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            IB_Programme__c programme = ProgrammeService.getProgramme();
            
            if (programme.RecordType.Name == 'PYP') {
                return true;
            }
            else {
                return false;
            }
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
    
    public virtual Boolean getIsMyp() {
        
        try
        {
        String appId = ApexPages.currentPage().getParameters().get('id');
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'MYP') {
            return true;
        }
        else {
            return false;
        }
        }
        catch(exception x)
        {
            System.debug('excp'+x);
            return NULL;
            
        }
        
        
    }
    
    public virtual Boolean getIsDp() {
        try
        {
        
        String appId = ApexPages.currentPage().getParameters().get('id');
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'Diploma Programme') {
            return true;
        }
        else {
            return false;
        }
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return NUll;
        }
        
    }
    
    public virtual Boolean getIsCp() {
        
        try
        {
        String appId = ApexPages.currentPage().getParameters().get('id');
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP') {
            return true;
        }
        else {
            return false;
        }
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return NUll;
        }
        
    }
    
    public virtual Boolean getIsCpPhase1() {
        
        try
        {
        String appId = ApexPages.currentPage().getParameters().get('id');
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
            return true;
        }
        else {
            return false;
        }
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return NUll;
        }
        
    }
    
    public virtual Boolean getIsCpPhase2() {
        
        try
        {
        String appId = ApexPages.currentPage().getParameters().get('id');
        ApplicationService.setApplicationId(appId);
        IB_Application__c application = ApplicationService.getApplication();
        
        ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        IB_Programme__c programme = ProgrammeService.getProgramme();
        
        if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
            return true;
        }
        else {
            return false;
        }
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return NUll;
        }
        
    }
    
    public String getUserLanguageKey() {
        try
        {
        return UserInfo.getLanguage();
        }
        catch(exception x)
        {
            system.debug('excep'+x);
            return NUll;
        }
    }
}