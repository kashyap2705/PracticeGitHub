public class IBPortalForgotPasswordController {
    
    
    public String username {get; set;}
    public List<String> errorMessages {
        get {
            if(errorMessages == null){
                errorMessages = new List<String>();
            }
            return errorMessages;
            
        }
        set;
    }
    public List<User> userId {get; set;} 
    public Integer errorCount {
        get {
            if(errorCount == null){
                errorCount = 0;
            }
            return errorCount;
        }
        set;
    }
    
    public IBPortalForgotPasswordController() {
        username=System.currentPagereference().getParameters().get('username');
        
    }
    
    public PageReference forgotPassword() {
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.IBPortalForgotPasswordConf;
        //this code is edited by developer Ali HAider bajwa-plumlogix for ecm388
        //start
        userId = [select id , Name,	IsActive,email,LanguageLocaleKey from User where Username = :username Limit 1];
        if(userId.size()>0)
        {
            if(!userId[0].IsActive)
            {
                Map<String,Id> mapFlow = new Map<String,Id>();
                mapFlow.put('recordID',userId[0].Id);
                mapFlow.put('forgotPassword',userId[0].Id);
                Flow.Interview.LWC_Email_Flow flow1 = new Flow.Interview.LWC_Email_Flow(mapFlow);
                flow1.start();
                //end
                errorMessages.add(Label.PIMS_Error_Login_inActive);
                pr=Null;
            }
            errorCount = errorMessages.size();
            //this code is edited by developer Ali HAider bajwa-plumlogix for ecm388
            //start
            if (success && userId[0].IsActive) 
            {
                pr.getParameters().put('username',username);
                pr.setRedirect(true);
                return pr;
            }
            
        }
        if (success && userID.size()==0)
        {
            pr.getParameters().put('username',username);
            pr.setRedirect(true);
            return pr;
        }
        
        //end
        return NULL;
        
        
    }
    //this code is edited by developer Ali HAider bajwa-plumlogix for ecm388
    //start
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
    
}