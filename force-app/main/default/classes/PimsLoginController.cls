public with sharing class PimsLoginController {
    
    public String username { get; set; }
    public String password { get; set; }
    
    public List<String> errorMessages {
        get {
            if(errorMessages == null){
                errorMessages = new List<String>();
            }
            return errorMessages;
        }
        set;
    }
    
    public Integer errorCount {
        get {
            if(errorCount == null){
                errorCount = 0;
            }
            return errorCount;
        }
        set;
    }
    
    public PimsLoginController() {}
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
    
    public PageReference login() {
        
        PageReference ref = null;
        errorMessages.clear();
        
        // we dont want anyone logging in who is a member of the deactivated accounts
        UserService.setUserName(username);
        User usr = UserService.getUserByUsername();
        
        if (usr != null && usr.ContactId != null) {
            
            ContactService.setContactId(usr.ContactId);
            Contact con = ContactService.getContact();
            
            if (con != null) {
                if (con.Account.Name == 'IBAEM Inactive Contacts' || con.Account.Name == 'IBA Inactive Contacts' || con.Account.Name == 'IBAP Inactive Contacts') {
            		errorMessages.add(Label.PIMS_Error_Login);
                }
                else {
                    ref = Site.login(username, password, '/pims');
                    if(ref == null){
                        errorMessages.add(Label.PIMS_Error_Login);
                    }
                }
            }
            
        }
        else {
            errorMessages.add(Label.PIMS_Error_Login);
        }
        
        errorCount = errorMessages.size();
        
        return ref;
        
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    
}