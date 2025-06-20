public with sharing class PimsForgotPasswordController {
    public String username {get; set;}

    public PimsForgotPasswordController() {}

  	public PageReference forgotPassword() {

  		boolean success = Site.forgotPassword(username);
  		PageReference pr = Page.PimsForgotPasswordConfirmation;

  		pr.setRedirect(true);

  		if (success) return pr;

  		return null;

  	}

	public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }

}