public with sharing class PimsNavbarController {

	public String userFullName { get; set; }
	public Boolean displayName { get; set; }
	public String locale { get; set; }

	public PimsNavbarController() {
		
		if (UserInfo.getUserType() != 'Guest') {
			userFullName = UserInfo.getName();
			displayName = true;
		}
		else {
			displayName = false;
		}

	}

}