/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class ForgotPasswordController {
    public String username {get; set;} 
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
       
    public ForgotPasswordController() {}
	
  	public PageReference forgotPassword() {
  		final List <User> users = [Select id, name from User where Username = :username];
  		boolean success = Site.forgotPassword(username);
  		PageReference pr = Page.ForgotPasswordConfirm;
  		pr.setRedirect(true);
  		
  		if (success && users.size() > 0) {  			
  			return pr;
  		}
  		else{
  			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IBENPortal_Registration_InvalidUsername));
  		}
  		return null;
  	}
  	
  	/* @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';     	
    
    	System.assertEquals(controller.forgotPassword(),null); 
    } */
}