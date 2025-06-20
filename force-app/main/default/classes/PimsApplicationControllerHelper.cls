public virtual class PimsApplicationControllerHelper {
    
    @TestVisible transient Boolean isEditable;
    @TestVisible transient Boolean isPyp;
    @TestVisible transient Boolean isMyp;
    @TestVisible transient Boolean isDp;
    @TestVisible transient Boolean isCp;
    @TestVisible transient Boolean isCpPhase1;
    @TestVisible transient Boolean isCpPhase2;
    @TestVisible transient Boolean isPageInternal;
    @TestVisible transient Boolean isPageExternal;
    @TestVisible transient Boolean anyProgramme;
    @TestVisible transient Boolean isAfa;
    @TestVisible transient Boolean isAfc;
    
    String currPage = ApexPages.currentPage().getUrl();
    PageReference thisPage = ApexPages.currentPage();
    
    public virtual Boolean getIsEditable() {
        try{
            
            if (isEditable == null) {
                
                isEditable = false;
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                List<String> editProfileNames = new List<String>();
                editProfileNames.add('System Administrator');
                editProfileNames.add('School Community User');
                editProfileNames.add('SCU + Advanced');
                editProfileNames.add('SCU + Basic');
                editProfileNames.add('School Community User Old');
                editProfileNames.add('SCU + Advanced OLD');
                editProfileNames.add('SCU + Basic OLD');
                
                // this should be calling some sort of user/profile service and caching the data
                Profile currProfile = [ SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1 ];
                
                PageReference pageRef = thisPage;
                String url = pageRef.getUrl();
                System.debug('mw getIsPageInternal '+getIsPageInternal());
                System.debug('mw getIsAfa ' +getIsAfa());
                if(getIsPageInternal() && getIsAfa()){
                    isEditable = false;
                }else{
                    for (String name : editProfileNames) {
                        if ((name == currProfile.Name) && (application.Status__c == 'Draft' || application.Status__c == 'Return to School' || application.Status__c == 'Additional Information Submitted') 
                            && !url.contains('Iben')) {
                                isEditable = true;
                            }
                    }
                }
            }
            system.debug('isEditable =====> '+isEditable);
            return isEditable;
            
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsAfa() {
        try{
            System.debug(LoggingLevel.ERROR, 'Entering AFA Method');
            if (isAfa == null) {
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                if (application.RecordType.Name == 'Application for Authorization') {
                    isAfa = true;
                    System.debug(LoggingLevel.ERROR, 'AFA Method true');
                }
                else {
                    isAfa = false;
                }
            }
            return isAfa;
        }
        catch(exception e){
            return null;
        }
    }
    public virtual Boolean getIsAfc() {
        try{
            System.debug(LoggingLevel.ERROR, 'Entering AFC Method');
            if (isAfc == null) {
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                if (application.RecordType.Name == 'Application for Candidacy') {
                    System.debug(LoggingLevel.ERROR, 'AFC Method true');
                    isAfc = true;
                }
                else {
                    isAfc = false;
                }
            }
            return isAfc;
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual boolean getIsIBEN() {
        try {
            if(currPage.containsIgnoreCase('iben')) {
                return true;
            } else {
                return false;
            } 
        } catch(exception exp){
            return null;
        }
    }
    
    public virtual Boolean getIsPyp() {
        try{
            System.debug(LoggingLevel.ERROR, 'Entering Super Method');
            if (isPyp == null) {
                system.debug(LoggingLevel.ERROR, 'TEST');
                system.debug(LoggingLevel.ERROR, thisPage);
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'PYP') {
                    isPyp = true;
                }
                else {
                    isPyp = false;
                }
            }
            return isPyp;
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsMyp() {
        try{
            if (isMyp == null) {
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'MYP' || programme.RecordType.Name == 'MYP Partner') {
                    isMyp = true;
                }
                else {
                    isMyp = false;
                }
            }
            return isMyp; 
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsDp() {
        try{
            if (isDp == null) {
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'Diploma Programme') {
                    isDp = true;
                }
                else {
                    isDp = false;
                }
            }
            return isDp;
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsCp() {
        try{
            if (isCp == null) {
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'CP') {
                    isCp = true;
                }
                else {
                    isCp = false;
                }
            }
            return isCp;
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsCpPhase1() {
        try{
            if (isCpPhase1 == null) {
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 1') {
                    isCpPhase1 = true;
                }
                else {
                    isCpPhase1 = false;
                }
            }
            return isCpPhase1;
        }
        catch(exception e){
            return null;
        }
    }
    
    public virtual Boolean getIsCpPhase2() {
        try{
            if (isCpPhase2 == null) {
                
                String appId = thisPage.getParameters().get('id');
                ApplicationService.setApplicationId(appId);
                IB_Application__c application = ApplicationService.getApplication();
                
                ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
                IB_Programme__c programme = ProgrammeService.getProgramme();
                
                if (programme.RecordType.Name == 'CP' && programme.IBCC_Implementation_Phase__c == 'Phase 2') {
                    isCpPhase2 = true;
                }
                else {
                    isCpPhase2 = false;
                }
            }
            return isCpPhase2;
        }
        catch(exception e){
            return null;
        }
    }
    
    // Used as rendered target when the element should be rendered for all programmes
//Following code block is added by Umair-Plumlogix on 24/03/2020 as a part of CR-576
    //Begin
    public virtual Boolean getAnyProgramme() {
        try
        {
            
            if (anyProgramme == null) {
                
                anyProgramme = false;
                if (getIsPyp() || getIsMyp() || getIsDp() || getIsCp() || getIsCpPhase1() || getIsCpPhase2()) {
                    anyProgramme = true;
                }
                
            }
            return anyProgramme;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    //End
    
    // Used to determine if the AFC is being viewed internally
    public virtual Boolean getIsPageInternal() {
        try{
            if (currPage.contains('InternalApplicationForCandidacy' ) || currPage.contains('InternalApplicationForAuthorization')) {
                isPageInternal = true;
            }
            else {
                isPageInternal = false;
            }
            return isPageInternal;
        }
        catch(exception e){
            return null;
        }
    }
    
    // Used to determine if the AFC is being viewed through the My School or IBEN communities
    public virtual Boolean getIsPageExternal() {
        try{
            if (currPage.contains('PimsApplicationForCandidacy') || currPage.contains('IbenApplicationForCandidacy') || currPage.contains('PimsApplicationForAuthorization') || currPage.contains('IbenApplicationForAuthorization')) {
                isPageExternal = true;
            }
            else {
                isPageExternal = false;
            }
            return isPageExternal;
        }
        catch(exception e){
            return null;
        }
    }
    
    public String getUserLanguageKey() {
        try
        {
            return UserInfo.getLanguage();
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public String getCurrentPage() {
        try
        {
            return currPage;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public String getApplicationPageName(){
        try	
        {
            if(getIsAfa()){
                if(getIsIBEN())
                    return 'IbenApplicationForAuthorization';
                return 'PimsApplicationForAuthorization';
            }else{
                 if(getIsIBEN())
                    return 'IbenApplicationForCandidacy';
                return 'PimsApplicationForCandidacy';
            }
        }
        Catch(Exception ex)
        {
            System.Debug(ex);
            return NULL;
        }
        
    }
}