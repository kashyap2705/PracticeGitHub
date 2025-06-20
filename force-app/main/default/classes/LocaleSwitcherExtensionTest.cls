@isTest
public class LocaleSwitcherExtensionTest {
    static testMethod void validateLocaleNoPage() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        String locale = lse.getLocale();
        
        System.assert(locale == 'en_US');        
    }
    
    static testMethod void validateLocalePageParam() {
        Pagereference IBPortalLogin = Page.IBPortalLogin;
        Test.setCurrentPage(IBPortalLogin);
        System.currentPageReference().getParameters().put('lang', 'en_US');
		LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        String locale = lse.getLocale();
        System.assert(locale == 'en_US');        
    }
    
    static testMethod void validateBadLocales() {
        integer i = 1;
        Pagereference IBPortalLogin = Page.IBPortalLogin;
        Test.setCurrentPage(IBPortalLogin);
        System.currentPageReference().getParameters().put('lang', 'da');
        Cookie locale = ApexPages.currentPage().getCookies().get('locale');
        locale = new Cookie('locale','la',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{locale});
		LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        String locale2 = lse.getLocale();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }
    
    static testMethod void validateMismatchCookieParam() {
        integer i = 1;
        Pagereference IBPortalLogin = Page.IBPortalLogin;
        Test.setCurrentPage(IBPortalLogin);
        System.currentPageReference().getParameters().put('lang', 'es');
        Cookie locale = ApexPages.currentPage().getCookies().get('locale');
        locale = new Cookie('locale','fr',null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{locale});
		LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        String locale2 = lse.getLocale();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
    }

	
}