public class PimsProfileInfoController implements PimsProfilePanelInterface {
    
    public Account account { get; set; }
    
    public Boolean isNewSchoolPage { get; set; }
    public String redirectUrl { get; set; }
    public String gosCheckBox { get; set ; }
    public Boolean isUpdatePage {get;set;}
    public String activeTab { get; set; }
    public String groupofschool {get; set;}
    //Added by Suraj as a part of ECM00665 Starts
    private final List<String> constantList = new List<String>{IboUtil.Business_Registration_Num,IboUtil.Vat_Gst_Ent,IboUtil.Gst_Check,IboUtil.Error_Message,IboUtil.Gst_Check_Dec,IboUtil.Country_Blank};
        
        public String businessRegNum {
            get {
                return this.getTranslationsMap().get(IboUtil.Business_Registration_Num);
            }
            set;
        }
    
    public String vatGstEnt {
        get {
            return this.getTranslationsMap().get(IboUtil.Vat_Gst_Ent);
        }
        set;
    }
    
    
    public String gstCheck {
        get {
            return this.getTranslationsMap().get(IboUtil.Gst_Check);
        }
        set;
    }
    
    public String gstCheckDec {
        get {
            return this.getTranslationsMap().get(IboUtil.Gst_Check_Dec);
        }
        set;
    }
    
    public String errorMessage {
        get {
            return this.getTranslationsMap().get(IboUtil.Error_Message);
        }
        set;
    }
    
        public String countryBlank {
        get {
            return this.getTranslationsMap().get(IboUtil.Country_Blank);
        }
        set;
    }
    
    
    //END
    
    public PimsProfileInfoController() {
        PimsCommunityService pimsService = new PimsCommunityService();
        account = pimsService.getCurrentAccount();
        if(account.Group_of_School__c != null)
            groupofschool = getAccount(account.Group_of_School__c);
        if (ApexPages.currentPage().getParameters().get('redir') != null) {
            redirectUrl = ApexPages.currentPage().getParameters().get('redir');
        }
    }
    
    
    public PageReference save() {
        
        try {
            if(gosCheckBox == 'Yes' && groupofschool != null && account.Group_of_schools_not_on_the_list__c == null){
                if(groupofschool != null && groupofschool.contains(':')){
                    string accName = groupofschool.split(':')[0];
                    string ibis = groupofschool.split(':')[1];
                    if(ibis != null){
                        List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE IBIS_ID__c = \'' + String.escapeSingleQuotes(ibis) + '\'');
                        account.Group_of_School__c = accountList[0].id;
                    }
                    else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.PIMS_Error_School_Group));
                        return null;
                    }
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.PIMS_Error_School_Group));
                    return null;
                }
            }
            else if(gosCheckBox == 'No' || groupofschool == null || groupofschool == ''){
                if(gosCheckBox == 'No'){
                    account.Group_of_School__c = null;
                    account.Group_of_schools_not_on_the_list__c = '';
                    account.ParentId = null;}
                else if(groupofschool == null || groupofschool == ''){
                    account.Group_of_School__c = null;
                    account.ParentId = null;}
            }
            if (gosCheckBox == 'Yes' && (account.Group_of_School__c == null && account.Group_of_schools_not_on_the_list__c == null)) {
                throw new CustomValidationException(Label.PIMS_Error_School_Group);
            }
            System.debug('After If Condition------------------------java log');
            // Following code is added by Umair-Plumlogix of SA Project of US12186 on 3/22/2021
            // Start
            if(account.Dial_code__c != Null && account.Phone_Number__c!= Null)
            {
                PhoneValidation phone_validation = new PhoneValidation();
                Boolean temp = phone_validation.edit_phone_account(account);
                Integer charLength = account.Phone_Number__c.length();
                if(charLength<4 || charLength>15 || temp == true)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Error));
                    return null;
                }
                
            }
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Instruction));
                return null;
            }
            //End
            //Added  by Suraj as a part of ECM00665
            if(account.VAT_GST_Sales_Tax_registered_entitiy__c=='No'){
                account.VAT_GST_Sales_Tax_ID__c=Null;
                account.GST_registration_declaration__c=false; 
            }
            //Added by Suraj End
            update account;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.School_info_saved));
            
            if (isNewSchoolPage) {
                redirectUrl = '/pims/PimsProfileNew?tab=address';
            }
            
        }
        catch (Exception ex) {
            
            System.debug('Exception: '+ex);
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    public String getAccount(ID accountid){
        Account Acc = new Account();
        Acc = [Select id,Name,IBIS_ID__c from Account where id =:accountid Limit 1];
        return Acc.Name+':'+Acc.IBIS_ID__c;
    }
    
    public boolean getIsGroupOfSchoolsChecked() {
        
        if ((account.Group_Of_School__c != null) || (account.Group_Of_Schools_Not_On_The_List__c != null)) {
            return true;
        }
        else {
            return false;
        }
        
    }
    
    //Added by suraj as a part of ECM00665
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
    
    //END
    
}