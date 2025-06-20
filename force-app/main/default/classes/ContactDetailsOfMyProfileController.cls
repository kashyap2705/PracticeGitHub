public without sharing class ContactDetailsOfMyProfileController {
    
    public static final Integer MAX_FILE_SIZE_FOR_UPLOAD = 5000000;
    public static final Integer MAX_PROFILEIMAGE_SIZE_FOR_UPLOAD = 1000000;
    public static final String CV_DESCRIPTION = '**CV**';
    public static final String TERMS_DESCRIPTION = '**TERMS&CONDITIONS**';
    public static final String IBENTANDC_DESCRIPTION = '**TERMS&CONDITIONS - IBEN Terms And Conditions **';
    public static final String READERTANDC_DESCRIPTION = '**TERMS&CONDITIONS - Reader Terms and Conditions **';
    public static final String SVTEAMTANDC_DESCRIPTION = '**TERMS&CONDITIONS - School Visit Team Member Terms and Conditions **';
    public static final String SVLEADTANDC_DESCRIPTION = '**TERMS&CONDITIONS - School Visit Team Leader Terms and Conditions **';
    public static final String CONSULTTANDC_DESCRIPTION = '**TERMS&CONDITIONS - Consultant Terms and Conditions **';
    public static final String WORKSHOPTANDC_DESCRIPTION = '**TERMS&CONDITIONS - Workshop Leader Terms  and Conditions **';
    public static final String FIELDREPTANDC_DESCRIPTION = '**TERMS&CONDITIONS - Programme Field Representative Terms and Conditions **';
    public static final String PROFILEPHOTO_DESCRIPTION = 'profile photo';
    public static final String ANNUALRELEASE_DESCRIPTION = '**TERMS&CONDITIONS - Head of School Annual Release **';
    //Shashi
    public static final String sampleunitplanner_DESCRIPTION = '**sample unit planner**';
    public static final String curriculumcourseoverview_DESCRIPTION = '**curriculum course overview**';
    public static String consent ;
    public static String Ulan ;
    public static String language ;
    public static String PrefPhone;
    public static String PrefAdd;
    public static String IBENComm;
    public static String MailingCountry;
    public static String ResidentialCountry;
    public static String MailingZipPostalCode;
    public static String ResidentialZipPostalCode;
    public static String MailingState;
    public static String ResidentialState;
    public static String MailingCity;
    public static String ResidentialCity;
    public static String MailingStreet;
    public static String ResidentialAddress;
    public static String AddressDetails;
    public static String LegallastName;
    public static String Legalinformation;
    public static String LegalfirstName;
    public static String Retired;
    public static String JobTitle;
    public static String AdditionalContactDetails;
    public static String CommunicationPreference;
    public static String IBENId;
    public static String CorHelpText;
    
    //Added by Shahrukh for ECM00207 Phase 1 on 27/06/2024
    public static Set<String> countriesWithStates = new Set<String> {'US', 'CA', 'AU'};
    
    public String getconsent() {
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
        List<Translation__c> lstTranslations = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'Consent' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+lstTranslations);
        if(!lstTranslations.isEmpty()){
            consent = (String)lstTranslations[0].Value__c;
        }
        return consent;
    }
    
    public String getCorHelpText() {
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
        List<Translation__c> helptext = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'CORHelpText' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+helptext);
        if(!helptext.isEmpty()){
            CorHelpText = (String)helptext[0].Value__c;
        }
        return CorHelpText;
    } 
    public String getPrefPhone() {
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
        List<Translation__c> Pphone = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'PreferredPhone' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Pphone);
        if(!Pphone.isEmpty()){
            PrefPhone = (String)Pphone[0].Value__c;
        }
        return PrefPhone;
    }   
    public String getPrefAdd() {
        // Ulan = [Select LanguageLocaleKey from User Where Id = :UserInfo.getUserId() LIMIT 1].LanguageLocaleKey;
        if(UserInfo.getLanguage() == 'en_US'){
            language = 'American English';  
        }
        if(UserInfo.getLanguage() == 'es'){
            language = 'Spanish';  
        }
        if(UserInfo.getLanguage() == 'fr'){
            language = 'French';  
        }
        List<Translation__c> PAddress = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'PreferredAddressofCorrespondence' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+PAddress);
        if(!PAddress.isEmpty()){
            PrefAdd = (String)PAddress[0].Value__c;
        }
        return PrefAdd;
    }    
    public String getIBENComm() {
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
        List<Translation__c> PAddress = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'PreferredMethodofIBENCommunication' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+PAddress);
        if(!PAddress.isEmpty()){
            IBENComm = (String)PAddress[0].Value__c;
        }
        return IBENComm;
    }   
    public String getMailingCountry() {
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
        List<Translation__c> MailCountry = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'MailingCountry' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+MailCountry);
        if(!MailCountry.isEmpty()){
            MailingCountry = (String)MailCountry[0].Value__c;
        }
        return MailingCountry;
    }    
    public String getResidentialCountry() {
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
        List<Translation__c> ResCountry = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'ResidentialCountry' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+ResCountry);
        if(!ResCountry.isEmpty()){
            ResidentialCountry = (String)ResCountry[0].Value__c;
        }
        return ResidentialCountry;
    }    
    public String getMailingZipPostalCode() {
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
        List<Translation__c> MailZipPostalCode = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'MailingZIPPostalCode' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+MailZipPostalCode);
        if(!MailZipPostalCode.isEmpty()){
            MailingZipPostalCode = (String)MailZipPostalCode[0].Value__c;
        }
        return MailingZipPostalCode;
    }     
    public String getResidentialZipPostalCode() {
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
        List<Translation__c> ResZipPostalCode = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'ResidentialZipPostalCode' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+ResZipPostalCode);
        if(!ResZipPostalCode.isEmpty()){
            ResidentialZipPostalCode = (String)ResZipPostalCode[0].Value__c;
        }
        return ResidentialZipPostalCode;
    }     
    public String getMailingState() {
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
        List<Translation__c> MailingstateProvince = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'MailingState' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+MailingstateProvince);
        if(!MailingstateProvince.isEmpty()){
            MailingState = (String)MailingstateProvince[0].Value__c;
        }
        return MailingState;
    } 
    public String getResidentialState() {
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
        List<Translation__c> ResidentialstateProvince = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'ResidentialState' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+ResidentialstateProvince);
        if(!ResidentialstateProvince.isEmpty()){
            ResidentialState = (String)ResidentialstateProvince[0].Value__c;
        }
        return ResidentialState;
    }     
    public String getMailingCity() {
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
        List<Translation__c> MailCity = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'MailingCity' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+MailCity);
        if(!MailCity.isEmpty()){
            MailingCity = (String)MailCity[0].Value__c;
        }
        return MailingCity;
    }         
    public String getResidentialCity() {
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
        List<Translation__c> ResCity = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'ResidentialCity' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+ResCity);
        if(!ResCity.isEmpty()){
            ResidentialCity = (String)ResCity[0].Value__c;
        }
        return ResidentialCity;
    }     
    public String getMailingStreet() {
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
        List<Translation__c> MailStreet = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'MailingStreet' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+MailStreet);
        if(!MailStreet.isEmpty()){
            MailingStreet = (String)MailStreet[0].Value__c;
        }
        return MailingStreet;
    }  
    
    public String getResidentialAddress() {
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
        List<Translation__c> Res = [SELECT Value__c FROM Translation__c where Language__c = :language and CustomLabel__r.Label__c = 'ResidentialAddress' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Res);
        if(!Res.isEmpty()){
            ResidentialAddress = (String)Res[0].Value__c;
        }
        return ResidentialAddress;
    } 
    public String getAddressDetails() {
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
        List<Translation__c> AddressDetail = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'AddressDetail' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+AddressDetail);
        if(!AddressDetail.isEmpty()){
            AddressDetails = (String)AddressDetail[0].Value__c;
        }
        return AddressDetails;
    }    
    
    public String getLegallastName() {
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
        List<Translation__c> llname = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'LegalLastNames' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+llname);
        if(!llname.isEmpty()){
            LegallastName = (String)llname[0].Value__c;
        }
        return LegallastName;
    } 
    
    public String getLegalfirstName() {
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
        List<Translation__c> lfname = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'LegalFirstNames' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+lfname);
        if(!lfname.isEmpty()){
            LegalfirstName = (String)lfname[0].Value__c;
        }
        return LegalfirstName;
    }    
    
    public String getLegalinformation() {
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
        List<Translation__c> legalinfo = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'LegalInformation' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+legalinfo);
        if(!legalinfo.isEmpty()){
            Legalinformation = (String)legalinfo[0].Value__c;
        }
        return Legalinformation;
    } 
    public String getRetired() {
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
        List<Translation__c> Addretired = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'Retired' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Addretired);
        if(!Addretired.isEmpty()){
            Retired = (String)Addretired[0].Value__c;
        }
        return Retired;
    } 
    
    public String getJobTitle() {
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
        List<Translation__c> Title = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'JobTitle' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+Title);
        if(!Title.isEmpty()){
            JobTitle = (String)Title[0].Value__c;
        }
        return JobTitle;
    }   
    public String getAdditionalContactDetails() {
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
        List<Translation__c> AddConDetails = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'AdditionalDetails' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+AddConDetails);
        if(!AddConDetails.isEmpty()){
            AdditionalContactDetails = (String)AddConDetails[0].Value__c;
        }
        return AdditionalContactDetails;
    } 
    public String getCommunicationPreference() {
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
        List<Translation__c> ComPref = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'Communication Preferences' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+ComPref);
        if(!ComPref.isEmpty()){
            CommunicationPreference = (String)ComPref[0].Value__c;
        }
        return CommunicationPreference;
    }  
    public String getIBENId() {
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
        List<Translation__c> identification = [SELECT Value__c FROM Translation__c where Language__c = :language and  CustomLabel__r.Label__c = 'IBEN ID#' and CustomLabel__r.Group__c = 'IBEN'  LIMIT 1];
        system.debug('Translation'+identification);
        if(!identification.isEmpty()){
            IBENId = (String)identification[0].Value__c;
        }
        return IBENId;
    }  
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public String getUserEmail() {
        return UserInfo.getUserEmail();
    }
    
    public static String userProfile = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1].Profile.Name;
    
    public String getUserProfile() {
        return userProfile;
    }
    
    
    
    private FileWraper cvDoc;
    private FileWraper termsDoc;
    private FileWraper ibenTermsDoc;
    private FileWraper readerTermsDoc;
    private FileWraper svTeamTermsDoc;
    private FileWraper svLeadTermsDoc;
    private FileWraper consultTermsDoc;
    private FileWraper workshopTermsDoc;
    private FileWraper fieldRepTermsDoc;
    private FileWraper profilePhoto;
    private FileWraper annualRelease;
    //case 6167
    private FileWraper sampleunitplannerDoc;
    private FileWraper curriculumcourseoverviewDoc;
    
    
    private Set<String> allowdFileExt = new Set<String> {'.doc','.docx','.pdf','.rtf','.wpd','.wp','.wp7','.wp6','.wp5','.wp4','.txt','.text','.jpg','.jpeg','.png','.zip'};
        
        private final Contact contactObject; 
    
    public ContactDetailsOfMyProfileController() {
        
        this.cvDoc = new FileWraper();
        this.cvDoc.description = CV_DESCRIPTION;
        
        this.sampleunitplannerDoc = new FileWraper();
        this.sampleunitplannerDoc.description = sampleunitplanner_DESCRIPTION;
        
        this.curriculumcourseoverviewDoc= new FileWraper();
        this.curriculumcourseoverviewDoc.description = curriculumcourseoverview_DESCRIPTION;
        
        
        this.termsDoc = new FileWraper();
        this.termsDoc.description = TERMS_DESCRIPTION;
        
        this.ibenTermsDoc = new FileWraper();
        this.ibenTermsDoc.description = IBENTANDC_DESCRIPTION;
        
        this.readerTermsDoc = new FileWraper();
        this.readerTermsDoc.description = READERTANDC_DESCRIPTION;
        
        this.svTeamTermsDoc = new FileWraper();
        this.svTeamTermsDoc.description = SVTEAMTANDC_DESCRIPTION;
        
        this.svLeadTermsDoc = new FileWraper();
        this.svLeadTermsDoc.description = SVLEADTANDC_DESCRIPTION;
        
        this.consultTermsDoc = new FileWraper();
        this.consultTermsDoc.description = CONSULTTANDC_DESCRIPTION;
        
        this.workshopTermsDoc = new FileWraper();
        this.workshopTermsDoc.description = WORKSHOPTANDC_DESCRIPTION;
        
        this.fieldRepTermsDoc = new FileWraper();
        this.fieldRepTermsDoc.description = FIELDREPTANDC_DESCRIPTION;
        
        this.profilePhoto = new FileWraper();
        this.profilePhoto.description = PROFILEPHOTO_DESCRIPTION; 
        
        this.annualRelease = new FileWraper();
        this.annualRelease.description = ANNUALRELEASE_DESCRIPTION;
        
        try {
            for (IB_Country_Segmentation__c country : IBCountrySegmentationDAO.INSTANCE.getAll()) {
                if (UserInfo.getLanguage() == 'fr') {
                    if (country.country_fr__c == null) {
                        this.countryInfo.add(new SelectOption(country.id, country.name));
                    } else {
                        this.countryInfo.add(new SelectOption(country.id, country.country_fr__c));
                    }
                } else if (UserInfo.getLanguage() == 'es') {
                    if (country.country_es__c == null) {
                        this.countryInfo.add(new SelectOption(country.id, country.name));
                    } else {
                        this.countryInfo.add(new SelectOption(country.id, country.country_es__c));
                    }
                } else {
                    this.countryInfo.add(new SelectOption(country.id, country.name));
                }
            }
            
            User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
            
            if (null == user.ContactId ) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
            } else {
                this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
            }
            
        } catch (Exception e) {
            system.debug('*** Error in Constructor method *** ' + e.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getMessage()));
            
        }
        
    }
    
    public Contact getContactObject() {
        return contactObject;
    }
    
    public String remAttachId { 
        
        get;set;
        
    }
    
    @RemoteAction
    public static List<string> lookupSchoolAccount(String searchTerm) {
        system.debug('#### searchTerm : '+searchTerm);
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        List<Account> accountList = Database.query('SELECT Id, IBIS_ID__c, Name FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.Name+':'+x.IBIS_ID__c);
        }
        return accounts;
        
    }
    
    @RemoteAction
    public static String lookupSchoolAccountByName(String searchTerm) {
        system.debug('#### searchTerm : '+searchTerm);
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\'');
        return accountList[0].IBIS_ID__c;
        
    }
    
    @RemoteAction
    public static List<String> lookupSchoolAccountByNameMulti(String searchTerm) {
        system.debug('#### searchTerm : '+searchTerm);
        string accName = searchTerm.split(':')[0];
        string ibis = searchTerm.split(':')[1];
        
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        //List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\'');
        List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(accName) + '\' AND IBIS_ID__c = \'' + String.escapeSingleQuotes(ibis) + '\'');
        
        //return accountList[0].IBIS_ID__c;
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.IBIS_ID__c);
        }
        return accounts;
        
    }    
    
    private List <SelectOption> countryInfo = new List<SelectOption>();
    
    public List<SelectOption> getCountryInfo() {
        return this.countryInfo;
    }
    
    public List<Attachment> attachments {
        
        get {
            
            if (null == attachments) {
                attachments = AttachmentsDAO.INSTANCE.getAttachmentsbyParentId(contactObject.Id);
            }
            
            return attachments;
        }
        private set; 
    }
    
    public void removeCv() {
        try {
            
            delete AttachmentsDAO.INSTANCE.getAttachmentsbyId(remAttachId);
            attachments = null;
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_Error_AttachmentDeleted + ex.getMessage()));
        }  
    }
    
    public String rerenderParents  { 
        get; set; 
    }
    
    public PageReference cancel() {
        String selectedTab = ApexPages.currentPage().getParameters().get('selectedTab');
        if (selectedTab == null || selectedTab == '') {
            selectedTab = 'theContInfoTabId';
        }
        PageReference page = new PageReference('/myProfile?selectedTab=' + selectedTab);
        page.setRedirect(true);
        return page;
    }
    
    public PageReference edit() {
        
        PageReference page = ApexPages.currentPage();
        String selectedTab = ApexPages.currentPage().getParameters().get('selectedTab');
        if (selectedTab == null || selectedTab == '') {
            selectedTab = 'theContInfoTabId';
        }
        
        //Added by Shahrukh for ECM00207 Phase 1 on 27/06/2024 -- START --
        if(countriesWithStates.contains(contactObject.MailingCountryCode)) {
            contactObject.Mailing_Province__c = null;
        }
        if(countriesWithStates.contains(contactObject.OtherCountryCode)) {
            contactObject.Residential_Province__c = null;
        }
        //Added by Shahrukh for ECM00207 Phase 1 on 27/06/2024 -- END --
        
        try {
            
            update contactObject;
            addAttachmentToObject (cvDoc, contactObject.Id);
            addAttachmentToObject (sampleunitplannerDoc, contactObject.Id);
            addAttachmentToObject (curriculumcourseoverviewDoc, contactObject.Id);
            addAttachmentToObject (termsDoc, contactObject.Id);
            addAttachmentToObject (ibenTermsDoc, contactObject.Id);
            addAttachmentToObject (readerTermsDoc, contactObject.Id);
            addAttachmentToObject (svTeamTermsDoc, contactObject.Id);
            addAttachmentToObject (svLeadTermsDoc, contactObject.Id);
            addAttachmentToObject (consultTermsDoc, contactObject.Id);
            addAttachmentToObject (workshopTermsDoc, contactObject.Id); 
            addAttachmentToObject (fieldRepTermsDoc, contactObject.Id); 
            addAttachmentToObject (profilePhoto, contactObject.Id); 
            addAttachmentToObject (annualRelease, contactObject.Id);     
            
            
            attachments = null;
            ApexPages.getMessages().clear();
            
            page = new PageReference('/myProfile?selectedTab=' + selectedTab);
            page.setRedirect(true);
            
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
                page.setRedirect(false);
                page.getParameters().put('selectedTab', selectedTab);
            }
            
        }  catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  + Label.IBENPortal_Error_ProfileUpdateReason + ex.getMessage()));
            page.setRedirect(false);
            page.getParameters().put('selectedTab', selectedTab);
        }
        
        return page;
        
    }
    
    private void addAttachmentToObject (FileWraper file, String objectId) {
        
        if ( null != file && null != file.body) {
            
            if (file.size > MAX_FILE_SIZE_FOR_UPLOAD) {
                throw new ControllerException(Label.IBENPortal_Error_FileSizeLimit + ' ' + file.Name );
            } else if (file.description == 'profile photo' && file.size > MAX_PROFILEIMAGE_SIZE_FOR_UPLOAD){
                throw new ControllerException(Label.IBENPortal_Error_ProfileImageSizeLimit + ' ' + file.Name );
            }
            Boolean badFile = true;
            for( String ext : allowdFileExt) {
                if( file.name.endsWith(ext) ) {
                    badFile = false;
                    break;
                }
            }
            if( badFile ) {
                throw new ControllerException(Label.Profile_File_Upload_Error + ' ' + file.Name );
            }
            
            for (Attachment attach : attachments) {
                
                if(attach.Description != null){
                    if (attach.Description.equals(file.description)) {
                        delete attach;
                        break;
                    }
                }
                
            }
            insert new Attachment ( body= file.body , Name=file.name, ContentType = file.ContentType, parentId = objectId, description = file.description );
        }
        
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
    
    
    public FileWraper getCvDoc()  { 
        return this.cvDoc;
    }
    
    public FileWraper getsampleunitplannerDoc()  { 
        return this.sampleunitplannerDoc;
    }
    
    public FileWraper getcurriculumcourseoverviewDoc()  { 
        return this.curriculumcourseoverviewDoc;
    }
    
    
    public FileWraper getTermsDoc()  { 
        return this.termsDoc;
    }
    
    public FileWraper getIbenTermsDoc(){
        return this.ibenTermsDoc;
    }
    public FileWraper getReaderTermsDoc(){
        return this.readerTermsDoc;
    }
    public FileWraper getSvTeamTermsDoc(){
        return this.svTeamTermsDoc;
    }
    public FileWraper getSvLeadTermsDoc(){
        return this.svLeadTermsDoc;
    }
    public FileWraper getConsultTermsDoc(){
        return this.consultTermsDoc;
    }
    public FileWraper getWorkshopTermsDoc(){
        return this.workshopTermsDoc;
    }
    public FileWraper getFieldRepTermsDoc(){
        return this.fieldRepTermsDoc;
    }
    
    public FileWraper getProfilePhoto(){
        return this.profilePhoto;
    }
    
    public FileWraper getAnnualReleaseDoc(){
        return this.annualRelease;
    }
    
    public class FileWraper {
        public transient Blob body { get; set; }
        public transient String name { get; set; }
        public transient Integer size { get; set; }
        public transient String contentType { get; set; }
        public String description { get; set; }
        public String base64 {get; set;}
        
    } 
    
    
}