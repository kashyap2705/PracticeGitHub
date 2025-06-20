public without sharing class MyProfileController {
    private final Contact contactObject;
    private final String currentPageUrl;
    public static String userProfile = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].Profile.Name;
    public static list<PermissionSetAssignment> psa = [select PermissionSet.Label from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() and PermissionSet.Label IN ('Chief Examiner',
                                                                                                                                                             'Examiner Responsible',
                                                                                                                                                             'Deputy Examiner Responsible',
                                                                                                                                                             'Principal Examiner',
                                                                                                                                                             'Exam Team Leader',
                                                                                                                                                             'Examiner',
                                                                                                                                                             'Workshop Leader',
                                                                                                                                                             'Evaluation Leader and Programme Leader',
                                                                                                                                                             'Programme Field Representative',
                                                                                                                                                             'School Visit Team Leader',
                                                                                                                                                             'School Visit Team Member',
                                                                                                                                                             'Reader',
                                                                                                                                                             'IB Chair of synchronised visit',
                                                                                                                                                             'Lead educator',
                                                                                                                                                             'Assessment Content Developer',
                                                                                                                                                             'Generation global moderator',
                                                                                                                                                             'Online Facilitator') LIMIT 1];
    public static String ibenFinancialInformation ;
    public static String Ulan ;
    public static String language ;
    public static String ibenFinancialInformationa;
    public String getibenFinancialInformation() {
        //Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(UserInfo.getLanguage() == 'en_US'){
            language = 'American English';  
        }
        if(UserInfo.getLanguage() == 'es'){
            language = 'Spanish';  
        }
        if(UserInfo.getLanguage() == 'fr'){
            language = 'French';  
        }
        List<Translation__c> lstTranslations = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'financialinformation' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+lstTranslations);
        if(!lstTranslations.isEmpty()){
            ibenFinancialInformation = (String)lstTranslations[0].Value__c;
        }
        return ibenFinancialInformation;
    }	
    /*public String getibenFinancialInformationa() {
        Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(Ulan == 'en_US'){
            language = 'American English';  
        }
        if(Ulan == 'es'){
            language = 'Spanish';  
        }
        if(Ulan == 'fr'){
            language = 'French';  
        }
        List<Translation__c> lstTranslations = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'financialinformation' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+lstTranslations);
        if(!lstTranslations.isEmpty()){
            ibenFinancialInformationa = (String)lstTranslations[0].Value__c;
        }
        return ibenFinancialInformationa;
    }   */ 
    public String getUserProfile() {
        return userProfile;
    }
    public Boolean getpsa(){
        if(psa.size()!= 0){
            system.debug('ifdebugpsa' +psa);
            return true;
        }
        system.debug('debugpsa' +psa);
        if(psa.size()==0){
            system.debug('ifdebugpsa' +psa);
            return false;
        }
        return null;
    }
    public MyProfileController() {
        
        profileImageUrl = UserDAO.INSTANCE.getFullUserPhotoUrlId(Userinfo.getUserId()).FullPhotoUrl ;
        selectedTab = ApexPages.currentPage().getParameters().get('selectedTab');
       if (selectedTab == null || selectedTab == '') {
           selectedTab = 'theContInfoTabId';
       }
        //selectedTab = 'theContInfoTabId';
        User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        
        if (null == user.ContactId ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
            
        } else {
            this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
        }
        currentPageUrl = ApexPages.currentPage().getUrl();
        
    }
    
    public String getPhoto(){
      /*List<Attachment> attach = AttachmentsDAO.INSTANCE.getAttachmentsbyParentId(contactObject.Id);
      for(Attachment a: attach){
          if(a.description == 'profile photo'){
              return System.EncodingUtil.base64Encode(a.body);
          }
      }*/
      return AttachmentsDAO.getProfilePhoto(contactObject.Id);
  }
    
    public String profileImageUrl    { get; set; }
    public String selectedTab   { get; set; }
    
    public Contact getContactObject() {
            return this.contactObject;
    }
    
    public boolean getHasError() {
         return ApexPages.hasMessages();      
    }
    
    public String getPageUrl() {
         return currentPageUrl;       
    }
    
    public Id getIbTeachingExperienceRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'IB_Teaching_Experience'];
        return rt.Id;
    }
    
    public Id getIbTrainingsAttendedRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'IB_Trainings_Attended'];
        return rt.Id;
    }
    
    public Id getConferenceExperienceRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'IB_Conference_Experience'];
        return rt.Id;
    }
    
    public Id getNationalEducationKnowledgeRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'National_Education_Working_Knowledge'];
        return rt.Id;
    }
  
    public Id getGeneralTeachingExperianceRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'General_Teaching_Experience'];
        return rt.Id;
    }
    
    public Id getEducationalDegreesRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'Educational_Degrees'];
        return rt.Id;
    }
    
    public Id getLanguageExperienceRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'Language_Experience'];
        return rt.Id;
    }
    
    public Id getAccreditationKnoweledgeRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'Accreditation_Knowledge'];
        return rt.Id;
    }
    
    public Id getPublicationsRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'Publications'];
        return rt.Id;
    }
    
}