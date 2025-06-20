/*******************************************************************************************
* @Name         PimsHelpModuleController
* @Author       Suraj Parihar(Epam)
* @Date          27/09/2023  
* @Group        CR Team
* @Description  To Translate the help text available in MySchool Profile page
*********************************************************************************************/
public without sharing class PimsHelpModuleController {
    private final List<String> constantList = new List<String>{IboUtil.Business_Registration,IboUtil.Vat_HelpText,IboUtil.Sales_HelpText,IboUtil.Gst_HelpText};
    
    public String businessReg {
        get {
            return this.getTranslationsMap().get(IboUtil.Business_Registration);
        }
        set;
    }
    
    public String vatIdHelpText {
        get {
            return this.getTranslationsMap().get(IboUtil.Vat_HelpText);
        }
        set;
    }
    
    
   public String salesNumHelpText {
        get {
            return this.getTranslationsMap().get(IboUtil.Sales_HelpText);
        }
        set;
    }
    
    public String gstNumHelpText {
        get {
            return this.getTranslationsMap().get(IboUtil.Gst_HelpText);
        }
        set;
    }
    
    public static final Map<String, String> languageCodeMap {
        get {
            Map<String, String> languageMap = new Map<String, String>();
            languageMap.put('fr', 'French');
            languageMap.put('es', 'Spanish');
            languageMap.put('en_US', 'American English');
            return languageMap;
        }
    }
    
    transient Map<String, String> translationsMap;
    
    public  Map<String, String> getTranslationsMap() {        
        if (null == this.translationsMap) {
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
        
        return this.translationsMap;
    }
    
    
}