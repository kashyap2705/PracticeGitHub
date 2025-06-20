public class PageService {

	public static String page = null;
	public static String activeTab = null;
	public static Boolean isActiveTabCached = false;
    public static Boolean isTabLoaded = false;
	public static Map<String,String> defaultTabMap = new Map<String,String> {
		'PimsProfile' => 'info',
		'PimsProfileNew' => 'info',
		'PimsApplicationForCandidacy' => 'profile',
		'PimsApplicationForAuthorization' => 'profile',
        'IbenApplicationForCandidacy' => 'profile',
		'IbenApplicationForAuthorization' => 'profile'
	};

	public static String getPage() {
		return page;
	}

	public static void setPage(String pageName) {
		page = pageName;
	}

	private static void getTabCookie() {

		Cookie activeTabCookie = ApexPages.currentPage().getCookies().get(page + '_tab');
		String anchor = ApexPages.currentPage().getAnchor();

		if (anchor != null) {
			activeTab = anchor;
			activeTabCookie = new Cookie(page + '_tab', activeTab, null, -1, false);
			ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});
		}
		else {
			if (activeTabCookie == null) {
				activeTab = defaultTabMap.get(page);
				activeTabCookie = new Cookie(page + '_tab', activeTab, null, -1, false);
				ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});
			}
			else {
	        	activeTab = activeTabCookie.getValue();
			}
		}

	}

	private static void setTabCookie(String tab) {

		Cookie activeTabCookie = new Cookie(page + '_tab', tab, null, -1, false);
		ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});

	}

	public static String getActiveTab() {

		if (!isActiveTabCached) {

			activeTab = ApexPages.currentPage().getParameters().get('tab');

			if (activeTab == null) {
				getTabCookie();
				if (activeTab == null) {
					activeTab = defaultTabMap.get(page);
					setTabCookie(activeTab);
				}
			}
			else {
				setTabCookie(activeTab);
			}

			isActiveTabCached = true;

		}

		return activeTab;

	}

}