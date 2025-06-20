public class PimsProfileAddressController implements PimsProfilePanelInterface {
    
    public Account account { get; set; }
    public String selectedCountryValue {get; set;}
    public List<IB_Programme__c> programmes { get; set; }
    public List<IB_Address__c> addresses { get; set; }
    public IB_Address__c addAddress { get; set; }
    public IB_Address__c editAddress { get; set; }
    public IB_Address__c address { get; set; }
    
    public Id editAddressId { get; set; }
    public Id deleteAddressId { get; set; }
    
    public String pageIntent { get; set; }
    public String activeTab { get; set; }
    public Boolean isUpdatePage { get; set; }
    public String redirectUrl { get; set; }
    
    @TestVisible private ProfileService profileService = new ProfileService();
    
    public IB_Programme__c pyp {
        
        get { 
            try 
            {
                return profileService.getProgrammeByType(programmes, 'PYP'); 
            }
            Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
        }
        set;
    }
    public IB_Programme__c myp {
        get { 
            try{
                return profileService.getProgrammeByType(programmes, 'MYP'); 
            }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
        }
        set;
    }
    public IB_Programme__c dp {
        get { try { return profileService.getProgrammeByType(programmes, 'Diploma_Programme'); }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }}
        set;
    }
    public IB_Programme__c ibcc {
        get { try{return profileService.getProgrammeByType(programmes, 'IBCC'); }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }}
        set;
    }
    
    public PimsProfileAddressController() {
        try
        {
            PimsCommunityService pimsService = new PimsCommunityService();
            account = pimsService.getCurrentAccount();
            
            profileService.account = account;
            
            ProgrammeService.setAccountId(account.Id);
            programmes = ProgrammeService.getProgrammesByAccount();
            
            AddressService.setAccountId(account.Id);
            addresses = AddressService.getAddressesByAccount();
            
            address = new IB_Address__c(IB_Account__c = account.Id);
            addAddress = new IB_Address__c(IB_Account__c = account.Id);
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    public Boolean getHasPypProgramme() {
        try
        {
        return profileService.hasProgramme(programmes, 'PYP');
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }
    
    public Boolean getHasMypProgramme() {
        try
        {
        return profileService.hasProgramme(programmes, 'MYP');
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }
    
    public Boolean getHasDpProgramme() {
        try
        {
        return profileService.hasProgramme(programmes, 'Diploma_Programme');
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }
    
    public Boolean getHasIbccProgramme() {
        try
        {
        return profileService.hasProgramme(programmes, 'IBCC');
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }
    
    public PageReference save() {
        
        try {
            
            List<IB_Address__c> addressValidation = [
                SELECT ID, Name 
                FROM IB_Address__c 
                WHERE IB_Account__c = :account.Id
            ];
            
            if (addressValidation.size() < 1) {
                throw new CustomValidationException(Label.System_Address_Validation);
            }
            
            update account;
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.address_Saved));
            
            if (!isUpdatePage) {
                redirectUrl = '/pims/PimsProfileNew?tab=section';
            }
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference savePyp() {
        
        try {
            
            update pyp;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.PYP_Address));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference saveMyp() {
        
        try {
            
            update myp;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.MYP_Address));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference saveDp() {
        
        try {
            
            update dp;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.DP_Address));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference saveIbcc() {
        
        try {
            
            update ibcc;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.CP_Address));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference create() {
        
        try {
            
            addAddress.Country__c = selectedCountryValue;
            
            insert addAddress;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Address_Added));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference createIntent() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            insert address;
            
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsDashboard');
                pageRef.getParameters().put('prog', pageIntent);
            }
            else {
                pageRef = new PageReference('/pims/PimsProfileNew');
                pageRef.getParameters().put('tab', 'intent');
                pageRef.getParameters().put('prog', pageIntent);
            }
            
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
            pageRef.setRedirect(false);
            
        }
        
        return pageRef;
        
    }    
    
    public PageReference edit() {
        
        try {
            
            update editAddress;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Address_Updated));
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            
        }
        
        return null;
        
    }
    
    public PageReference remove() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            IB_Address__c addressToDelete = new IB_Address__c();
            addressToDelete.Id = deleteAddressId;
            
            delete addressToDelete;
            
            activeTab = 'address';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsProfile');
            }
            else {
                pageRef = new PageReference('/pims/PimsProfileNew');
            }
            pageRef.setRedirect(true);
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'address';
            pageRef.setRedirect(false);
            
        }
        
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
        
    }
    
    public List<SelectOption> getCountryOptions() {
        try
        {
        return profileService.getAddressCountries();
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }

    public void findCountryLabel(){
        for(SelectOption so : getCountryOptions()){
            if(selectedCountryValue == so.getValue()){
                selectedCountryValue = so.getLabel();
            }
        }
    }
    
    public List<SelectOption> getAddressOptions() {
        try
        {
        return profileService.getAddressOptions(account.Id);
        }Catch(Exception x)
            {
                System.debug('Exception: '+x);
                return NULL;
            }
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
}