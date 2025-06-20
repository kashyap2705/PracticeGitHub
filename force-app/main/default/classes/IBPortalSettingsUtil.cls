public with sharing class IBPortalSettingsUtil {

	//private static final String NULL_VALUE = 'null';
	public static IBPortalSettingsUtil util;
	//private IBPortalSettings__c settings;
	//private IBPortalSettings__c globalSettings;
	private Map <String, Community_Setting__mdt> communitySettingMeta;
	private User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
	
	public static IBPortalSettingsUtil getInstance() {
		if (util == null) util = new IBPortalSettingsUtil ();
		return util;
	}



	private IBPortalSettingsUtil() {
		//settings = IBPortalSettings__c.getInstance();
		//globalSettings = IBPortalSettings__c.getOrgDefaults();
		communitySettingMeta = new Map <String, Community_Setting__mdt> ();
		for (Community_Setting__mdt mdt: [SELECT Id, MasterLabel, Icon_Image_Name_Prefix__c, Captcha_Private_Key__c, Captcha_Public_Key__c, External_Link__c FROM Community_Setting__mdt]) {
			communitySettingMeta.put (mdt.MasterLabel.toLowerCase(), mdt);
		}

		System.debug('communitySettingMeta >>> ' + communitySettingMeta);
	}

	/*public Map <String,String> getExternalLinksToDisplay() {
		Map <String,String> externalLinksToDisplay = new Map <String,String>();

System.debug('1');		
		//role based external links
		for (IB_Role__c role: [SELECT Id, IB_Role_Name__c FROM IB_Role__c WHERE IB_Contact__c = :user.ContactId and ((Start_Date__c != null AND Start_Date__c <= TODAY) OR Status__c = 'Confirmed') AND (End_Date__c = null OR End_Date__c > TODAY)]){
System.debug('2');	
			Set<String> accessSet = new Set<String>();
			
			try{
System.debug('3');
				String userAccess = IBPortalRoleSettings__c.getInstance(role.IB_Role_Name__c).Access__c;
				accessSet.addAll(userAccess.split(','));

				for(String s:accessSet){
System.debug('4');	
					if(getExternalLink(s.toLowerCase()) != null && getExternalLink(s.toLowerCase()).length() > 0){
						externalLinksToDisplay.put(s.toLowerCase(),getExternalLink(s.toLowerCase()));
System.debug('5');	
					}
				}
			} catch(Exception e){
				System.debug(e);
			}

		}
		//profile based external links
		String networkNameString = String.isEmpty(util.settings.Community_Names__c) ? util.globalSettings.Community_Names__c : util.settings.Community_Names__c;
		networkNameString = networkNameString.equalsIgnoreCase(NULL_VALUE) ? null : networkNameString;
System.debug('6');			
		if (!String.isEmpty(networkNameString)) {
System.debug('7');	
			Set <String> networkNameSet = new Set <String> ();
			networkNameSet.addAll(networkNameString.split(','));

			for (String s:networkNameSet) {
System.debug('8');	              
				if(getExternalLink(s.toLowerCase()) != null && getExternalLink(s.toLowerCase()).length() > 0){
System.debug('9');	
					externalLinksToDisplay.put(s.toLowerCase(),getExternalLink(s.toLowerCase()));
				}
			}
		}

		return externalLinksToDisplay;

	}*/

	public String getCaptchaPrivateKey (String communityName) {
		return communitySettingMeta.get(communityName) != null ? communitySettingMeta.get(communityName).Captcha_Private_Key__c : '';
	}

	public String getCaptchaPublicKey (String communityName) {
		return communitySettingMeta.get(communityName) != null ? communitySettingMeta.get(communityName).Captcha_Public_Key__c : '';
	}

	/*public String getIconNamePrefix (String communityName) {
		return communitySettingMeta.get(communityName) != null ? communitySettingMeta.get(communityName).Icon_Image_Name_Prefix__c : 'noimage';
	}

	public String getExternalLink (String communityName) {
		return communitySettingMeta.get(communityName) != null ? communitySettingMeta.get(communityName).External_Link__c : '';
	}*/
}