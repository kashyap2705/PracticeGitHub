public with sharing class RedirectEventsExtController {
	private User user; 
    public RedirectEventsExtController (ApexPages.StandardController stdController) {
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    }
    
    public User getUserInfo() {
    	return user;
    }
    
}