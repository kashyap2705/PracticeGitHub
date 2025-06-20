/*******************************************************************************************
* @Name         IbPortalFooterController
* @Author       Saurabh Singh Singhaniya(Epam)
* @Date          06/08/2023  
* @Group        Platform Team
* @Description  To translate the names which are available on the MYib page in the footer.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1.
*******************************************************************************************/
public without sharing class IbPortalFooterController {
    private final List<String> constantList = new List<String>{IboUtil.IB_language_policy,IboUtil.Ib_terms_and_Conditions,IboUtil.IB_privacy_policy,IboUtil.Copyright};
	public static String languageParam {get;set;}
    
    public IbPortalFooterController(){//INC0191040 Ben McGarvey and Kevin Fugate, added in variable for footer of login page
        languageParam = System.currentPageReference().getParameters().get('lang');
        system.debug('language: ' + languageParam);
    }
    
    public String languagePolicy {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_language_policy);
        }
        set;
    }
    
    public String termsAndConditions {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_terms_and_Conditions);
        }
        set;
    }
    
    public String IbPrivacyPolicy {
        get {
            return this.getTranslationsMap().get(IboUtil.IB_privacy_policy);
        }
        set;
    }
    
    public String copyright_ib {
        get {
            return this.getTranslationsMap().get(IboUtil.Copyright);
        }
        set;
    }
    
    public static final Map<String, String> languageCodeMap {
        get {
            Map<String, String> languageMap = new Map<String, String>();
            languageMap.put('fr', 'French');
            languageMap.put('es', 'Spanish');
            return languageMap;
        }
    }
    
    transient Map<String, String> translationsMap;
    
    public  Map<String, String> getTranslationsMap() {        
        if (null == this.translationsMap) {
            if(languageParam!=null){//INC0191040 Ben McGarvey, added in condition for footer of login page so it can translate without relying on user language
                String userLanguage = null != languageCodeMap.get(languageParam) ? languageCodeMap.get(languageParam) : 'American English';
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                        WHERE CustomLabel__r.Label__c =: constantList
                                                        AND Language__c = :userLanguage];
                    
                    this.translationsMap = new Map<String, String>();
                    
                    for (Translation__c translation : translations) {
                        translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                    } 
            }else{
                try {
                    String userLanguage = null != languageCodeMap.get(UserInfo.getLanguage()) ? languageCodeMap.get(UserInfo.getLanguage()) : 'American English';
                    List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                        WHERE CustomLabel__r.Label__c =: constantList
                                                        AND Language__c = :userLanguage];
                    
                    this.translationsMap = new Map<String, String>();
                    
                    for (Translation__c translation : translations) {
                        translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                    } 
                }
                catch (Exception ex) {
                    Logger.get().add(ex, LogSeverity.ERROR).publish();             
                }
            }
        }
        
        return this.translationsMap;
    }
    
    
}