public with sharing class ForgotPasswordConfirmController {
	public ForgotPasswordConfirmController() {}
	public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }

}