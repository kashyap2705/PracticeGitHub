public without sharing class SiteHomePageController {
    
    public String getLocale() {
    	LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
    	return lse.getLocale();
    } 
    
    public String password {
        get;
        set;
    }
    public String userName {
        get;
        set;
    }

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
    
    public PageReference isLoggedIn() {
    	
    	if (UserInfo.getUserType() == 'Guest') {
    		return null;
    	}
    	else {
    		//return new PageReference('/home/home.jsp');
    		return new PageReference('/educator/dashboard');
    	}
    	
    }
    
    public PageReference login() {
        errorMessages.clear();
        if (String.IsBlank(username)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_Registration_Username + Label.IBENPortal_Registration_NoUserName));
            errorMessages.add(Label.IBENPortal_Registration_Username + Label.IBENPortal_Registration_NoUserName);
        }
        if (String.IsBlank(password)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_Registration_Password + Label.IBENPortal_Registration_NoPassword));
            errorMessages.add(Label.IBENPortal_Registration_Password + Label.IBENPortal_Registration_NoPassword);
        }   
        if (!ApexPages.getMessages().isEmpty()) {
            return null;
        }

        //oleg 3-15/16 add startUrl parameter tracking
        String startUrl = ApexPages.currentPage().getParameters().get('startUrl');

        PageReference result = String.isBlank(startUrl) ? Site.login(username, password, '/educator') : Site.login(username, password, startUrl);
        
        if(result == null){
            //ApexPages.getMessages().clear();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_Login_Error));
            errorMessages.add(Label.IBENPortal_Login_Error);
        }

        errorCount = errorMessages.size();
        
        return result;
    }


}